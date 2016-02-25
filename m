From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] virt: Lift the maximum RAM limit from 30GB
 to 255GB
Date: Thu, 25 Feb 2016 16:51:51 +0000
Message-ID: <CAFEAcA9d6u=2GLo5UEXGPzb=9bZNnk-CgEOt=235giCdPTW_pw@mail.gmail.com>
References: <1456402182-11651-1-git-send-email-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1456402182-11651-1-git-send-email-peter.maydell@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: QEMU Developers <qemu-devel@nongnu.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

[Typoed the kvmarm list address; sorry... -- PMM]

On 25 February 2016 at 12:09, Peter Maydell <peter.maydell@linaro.org> wrote:
> The virt board restricts guests to only 30GB of RAM. This is a
> hangover from the vexpress-a15 board, and there's inherent reason
> for it. 30GB is smaller than you might reasonably want to provision
> a VM for on a beefy server machine. Raise the limit to 255GB.
>
> We choose 255GB because the available space we currently have
> below the 1TB boundary is up to the 512GB mark, but we don't
> want to paint ourselves into a corner by assigning it all to
> RAM. So we make half of it available for RAM, with the 256GB..512GB
> range available for future non-RAM expansion purposes.
>
> If we need to provide more RAM to VMs in the future then we need to:
>  * allocate a second bank of RAM starting at 2TB and working up
>  * fix the DT and ACPI table generation code in QEMU to correctly
>    report two split lumps of RAM to the guest
>  * fix KVM in the host kernel to allow guests with >40 bit address spaces
>
> The last of these is obviously the trickiest, but it seems
> reasonable to assume that anybody configuring a VM with a quarter
> of a terabyte of RAM will be doing it on a host with more than a
> terabyte of physical address space.
>
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
> ---
> CC'ing kvm-arm as a heads-up that my proposal here is to make
> the kernel devs do the heavy lifting for supporting >255GB.
> Discussion welcome on whether I have the tradeoffs here right.
> ---
>  hw/arm/virt.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 44bbbea..7a56b46 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -95,6 +95,23 @@ typedef struct {
>  #define VIRT_MACHINE_CLASS(klass) \
>      OBJECT_CLASS_CHECK(VirtMachineClass, klass, TYPE_VIRT_MACHINE)
>
> +/* RAM limit in GB. Since VIRT_MEM starts at the 1GB mark, this means
> + * RAM can go up to the 256GB mark, leaving 256GB of the physical
> + * address space unallocated and free for future use between 256G and 512G.
> + * If we need to provide more RAM to VMs in the future then we need to:
> + *  * allocate a second bank of RAM starting at 2TB and working up
> + *  * fix the DT and ACPI table generation code in QEMU to correctly
> + *    report two split lumps of RAM to the guest
> + *  * fix KVM in the host kernel to allow guests with >40 bit address spaces
> + * (We don't want to fill all the way up to 512GB with RAM because
> + * we might want it for non-RAM purposes later. Conversely it seems
> + * reasonable to assume that anybody configuring a VM with a quarter
> + * of a terabyte of RAM will be doing it on a host with more than a
> + * terabyte of physical address space.)
> + */
> +#define RAMLIMIT_GB 255
> +#define RAMLIMIT_BYTES (RAMLIMIT_GB * 1024ULL * 1024 * 1024)
> +
>  /* Addresses and sizes of our components.
>   * 0..128MB is space for a flash device so we can run bootrom code such as UEFI.
>   * 128MB..256MB is used for miscellaneous device I/O.
> @@ -130,7 +147,7 @@ static const MemMapEntry a15memmap[] = {
>      [VIRT_PCIE_MMIO] =          { 0x10000000, 0x2eff0000 },
>      [VIRT_PCIE_PIO] =           { 0x3eff0000, 0x00010000 },
>      [VIRT_PCIE_ECAM] =          { 0x3f000000, 0x01000000 },
> -    [VIRT_MEM] =                { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
> +    [VIRT_MEM] =                { 0x40000000, RAMLIMIT_BYTES },
>      /* Second PCIe window, 512GB wide at the 512GB boundary */
>      [VIRT_PCIE_MMIO_HIGH] =   { 0x8000000000ULL, 0x8000000000ULL },
>  };
> @@ -1066,7 +1083,7 @@ static void machvirt_init(MachineState *machine)
>      vbi->smp_cpus = smp_cpus;
>
>      if (machine->ram_size > vbi->memmap[VIRT_MEM].size) {
> -        error_report("mach-virt: cannot model more than 30GB RAM");
> +        error_report("mach-virt: cannot model more than %dGB RAM", RAMLIMIT_GB);
>          exit(1);
>      }
>
> --
> 1.9.1
