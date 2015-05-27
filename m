From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [RESEND PATCH v12 4/4] hw/arm/virt: change
 indentation in a15memmap
Date: Wed, 27 May 2015 22:05:50 +0800
Message-ID: <5565CF3E.7040100@linaro.org>
References: <1432716470-2096-1-git-send-email-eric.auger@linaro.org>
	<1432716470-2096-5-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1432716470-2096-5-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org
Cc: patches@linaro.org, agraf@suse.de, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015年05月27日 16:47, Eric Auger wrote:
> Re-indent in a15memmap after VIRT_PLATFORM_BUS introduction
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
>
> ---
>
> v11 -> v12:
> - Add Alex R-b
> ---
>   hw/arm/virt.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 199d031..6c1ec58 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -128,26 +128,26 @@ typedef struct {
>    */
>   static const MemMapEntry a15memmap[] = {
>       /* Space up to 0x8000000 is reserved for a boot ROM */
> -    [VIRT_FLASH] =      {          0, 0x08000000 },
> -    [VIRT_CPUPERIPHS] = { 0x08000000, 0x00020000 },
> +    [VIRT_FLASH] =          {          0, 0x08000000 },
> +    [VIRT_CPUPERIPHS] =     { 0x08000000, 0x00020000 },
>       /* GIC distributor and CPU interfaces sit inside the CPU peripheral space */
> -    [VIRT_GIC_DIST] =   { 0x08000000, 0x00010000 },
> -    [VIRT_GIC_CPU] =    { 0x08010000, 0x00010000 },
> -    [VIRT_UART] =       { 0x09000000, 0x00001000 },
> -    [VIRT_RTC] =        { 0x09010000, 0x00001000 },
> -    [VIRT_FW_CFG] =     { 0x09020000, 0x0000000a },
> -    [VIRT_MMIO] =       { 0x0a000000, 0x00000200 },
> +    [VIRT_GIC_DIST] =       { 0x08000000, 0x00010000 },
> +    [VIRT_GIC_CPU] =        { 0x08010000, 0x00010000 },
> +    [VIRT_UART] =           { 0x09000000, 0x00001000 },
> +    [VIRT_RTC] =            { 0x09010000, 0x00001000 },
> +    [VIRT_FW_CFG] =         { 0x09020000, 0x0000000a },
> +    [VIRT_MMIO] =           { 0x0a000000, 0x00000200 },
>       /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that size */
>       [VIRT_PLATFORM_BUS] =   { 0x0c000000, 0x02000000 },
>       /*
>        * PCIE verbose map:
>        *
> -     * MMIO window      { 0x10000000, 0x2eff0000 },
> -     * PIO window       { 0x3eff0000, 0x00010000 },
> -     * ECAM             { 0x3f000000, 0x01000000 },
> +     * MMIO window          { 0x10000000, 0x2eff0000 },
> +     * PIO window           { 0x3eff0000, 0x00010000 },
> +     * ECAM                 { 0x3f000000, 0x01000000 },
>        */
> -    [VIRT_PCIE] =       { 0x10000000, 0x30000000 },
> -    [VIRT_MEM] =        { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
> +    [VIRT_PCIE] =           { 0x10000000, 0x30000000 },
> +    [VIRT_MEM] =            { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
>   };
>
>   static const int a15irqmap[] = {
>

Could we reserve more blanks in case of long name in the future? Then we 
won't deal the indentation again I guess.

-- 
Shannon
