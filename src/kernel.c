/* Manual Type Definitions (Freestanding) */
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;

void kernel_main(void) {
    /* VGA Text Buffer starts at 0xB8000 */
    uint16_t* terminal_buffer = (uint16_t*) 0xB8000;

    /* Text to display */
    const char* str = "HydrogenOS is Booted!";
    
    /* Color: White (15) on Black (0) */
    /* Character format: [ Color Byte | ASCII Byte ] */
    for (size_t i = 0; str[i] != '\0'; i++) {
        terminal_buffer[i] = (uint16_t) str[i] | (uint16_t) 15 << 8;
    }

    /* Keep the kernel alive */
    while(1);
}