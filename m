From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH roundup 2/4] ARM: KVM: avoid "HYP init code too big" error
Date: Mon, 9 Mar 2015 19:09:47 +0000
Message-ID: <20150309190947.GF8656@n2100.arm.linux.org.uk>
References: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
 <1425652482-31411-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F87483B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 15:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgO7qKTQCccX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 15:03:44 -0400 (EDT)
Received: from pandora.arm.linux.org.uk (pandora.arm.linux.org.uk
 [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740D4483AE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 15:03:43 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1425652482-31411-3-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: arnd@arndb.de, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 06, 2015 at 03:34:40PM +0100, Ard Biesheuvel wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When building large kernels, the linker will emit lots of veneers
> into the .hyp.idmap.text section, which causes it to grow beyond
> one page, and that triggers the build error.
> 
> This moves the section into .rodata instead, which avoids the
> veneers and is safe because the code is not executed directly
> but remapped by the hypervisor into its own executable address
> space.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> [ardb: move the ALIGN() to .rodata as well, update log s/copied/remapped/]
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/kernel/vmlinux.lds.S | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index b31aa73e8076..2787eb8d3616 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -22,11 +22,15 @@
>  	ALIGN_FUNCTION();						\
>  	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
>  	*(.idmap.text)							\
> -	VMLINUX_SYMBOL(__idmap_text_end) = .;				\
> +	VMLINUX_SYMBOL(__idmap_text_end) = .;
> +
> +#define IDMAP_RODATA							\
> +	.rodata : {							\

We already have a .rodata section defined by RO_DATA().  Quite how this
interacts with the existing .rodata section, I don't know, but it
probably won't be right.  Have you checked what effect this has?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
