From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 04/16] pci: Fix BAR resource sizing arbitration
Date: Thu, 4 Apr 2019 14:44:53 +0100
Message-ID: <20190404144453.1342bdeb@donnerap.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-5-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C414A43B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:44:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F6MGMj-dL1hn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 09:44:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 578CB4A332
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:44:58 -0400 (EDT)
In-Reply-To: <1551947777-13044-5-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>, Sami.Mujawar@arm.com
Cc: will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 7 Mar 2019 08:36:05 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

Hi,

> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> According to the 'PCI Local Bus Specification, Revision 3.0,
> February 3, 2004, Section 6.2.5.1, Implementation Notes, page 227'
> 
>     "Software saves the original value of the Base Address register,
>     writes 0 FFFF FFFFh to the register, then reads it back. Size
>     calculation can be done from the 32-bit value read by first
>     clearing encoding information bits (bit 0 for I/O, bits 0-3 for
>     memory), inverting all 32 bits (logical NOT), then incrementing
>     by 1. The resultant 32-bit value is the memory/I/O range size
>     decoded by the register. Note that the upper 16 bits of the result
>     is ignored if the Base Address register is for I/O and bits 16-31
>     returned zero upon read."
> 
> kvmtool was returning the actual BAR resource size which would be
> incorrect as the software software drivers would invert all 32 bits
> (logical NOT), then incrementing by 1. This ends up with a very large
> resource size (in some cases more than 4GB) due to which drivers
> assert/fail to work.
> 
> e.g if the BAR resource size was 0x1000, kvmtool would return 0x1000
> instead of 0xFFFFF00x.

Ouch!

> 
> Fixed pci__config_wr() to return the size of the BAR in accordance with
> the PCI Local Bus specification, Implementation Notes.
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> ---
>  pci.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/pci.c b/pci.c
> index 689869c..9edefa5 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -8,6 +8,9 @@
>  #include <linux/err.h>
>  #include <assert.h>
>  
> +/* Macro to check that a value is a power of 2 */
> +#define power_of_2(pow) (((pow) != 0) && (((pow) & ((pow) - 1)) == 0))

That is probably correct, but a bit hard to read. What about defining a
static function instead? That would allow this to be written in multiple
lines. And to improve readability, the prototype should probably be:
static bool is_power_of_two(u32 value)

> +
>  static u32 pci_config_address_bits;
>  
>  /* This is within our PCI gap - in an unused area.
> @@ -173,9 +176,51 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	 * BAR there next time it reads from it. When the kernel got the size it
>  	 * would write the address back.
>  	 */
> -	if (bar < 6 && ioport__read32(data) == 0xFFFFFFFF) {
> -		u32 sz = pci_hdr->bar_size[bar];
> -		memcpy(base + offset, &sz, sizeof(sz));
> +	if (bar < 6) {
> +		/*
> +		 * According to the PCI local bus specification REV 3.0:
> +		 * The number of upper bits that a device actually implements
> +		 * depends on how much of the address space the device will
> +		 * respond to. A device that wants a 1 MB memory address space
> +		 * (using a 32-bit base address register) would build the top
> +		 * 12 bits of the address register, hardwiring the other bits
> +		 * to 0.
> +		 * Furthermore software can determine how much address space the
> +		 * device requires by writing a value of all 1's to the register
> +		 * and then reading the value back. The device will return 0's in
> +		 * all don't-care address bits, effectively specifying the address
> +		 * space required.
> +		 *
> +		 * The following code emulates this by storing the value written
> +		 * to the BAR, applying the size mask to clear the lower bits,
> +		 * restoring the information bits and then updating the BAR value.
> +		 */
> +		u32 bar_value;
> +		/* Get the size mask */
> +		u32 sz = ~(pci_hdr->bar_size[bar] - 1);

It's a bit confusing to read just "sz", when it's actually a mask.
Actually there is only one user, so to make the comment there more
meaningful, you can just use the mask expression there, and get rid of
"sz" altogether.

> +		/* Extract the info bits */
> +		u32 info = pci_hdr->bar[bar] & 0xF;

Just a nit, but I find it a bit confusing to see those variable
definitions mixed with comments, especially with those short type names
and after the big introductory comment. Can we just put the comment on the
same line as the declaration, at least?

> +
> +		/* Store the value written by software */
> +		memcpy(base + offset, data, size);
> +
> +		/* Apply the size mask to the bar value to clear the lower bits */
> +		bar_value = pci_hdr->bar[bar] & sz;
> +
> +		/* Warn if the bar size is not a power of 2 */
> +		WARN_ON(!power_of_2(pci_hdr->bar_size[bar]));

Is this actually useful? This would put out a warning to the console, but
is there something an admin could do about it? Looks more like a kvmtool
issue (for instance the VESA and pci-shmem devices don't use power-of-2
sizes at the moment)?

> +
> +		/* Restore the info bits */
> +		if ((info & 0x1) == 0x1) {
> +			/* BAR for I/O */
> +			bar_value = ((bar_value & ~0x3) | 0x1);
> +		} else {
> +			/* BAR for Memory */
> +			bar_value = ((bar_value & ~0xF) | info);
> +		}
> +
> +		/* Store the final BAR value */
> +		pci_hdr->bar[bar] = bar_value;
>  	} else {
>  		memcpy(base + offset, data, size);
>  	}
