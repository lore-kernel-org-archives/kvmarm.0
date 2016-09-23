From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: Add support for ARMv8 AArch32 execution
 state
Date: Fri, 23 Sep 2016 11:25:50 +0200
Message-ID: <20160923092550.GG9101@cbox>
References: <1474614805-18629-1-git-send-email-b18965@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A152A41267
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:16:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNeUajNIMOuw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 05:16:31 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AE8F40B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:16:31 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id b130so18859728wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 02:25:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1474614805-18629-1-git-send-email-b18965@freescale.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alison Wang <b18965@freescale.com>
Cc: jason.jin@nxp.com, kvm@vger.kernel.org, marc.zyngier@arm.com, alison.wang@nxp.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 23, 2016 at 03:13:25PM +0800, Alison Wang wrote:
> The ARMv8 architecture supports two execution state, AArch64 and
> AArch32. To support KVM in AArch32 execution state for ARMv8, Cortex-A53
> and Cortex-A72 need to be added for target-specific checks.
> 
> Signed-off-by: Alison Wang <alison.wang@nxp.com>
> ---
>  arch/arm/include/asm/cputype.h | 2 ++
>  arch/arm/kvm/guest.c           | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
> index 754f86f..4f8c632 100644
> --- a/arch/arm/include/asm/cputype.h
> +++ b/arch/arm/include/asm/cputype.h
> @@ -75,6 +75,8 @@
>  #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
>  #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
>  #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
> +#define ARM_CPU_PART_CORTEX_A53_AARCH32	0x4100d030
> +#define ARM_CPU_PART_CORTEX_A72_AARCH32	0x4100d080
>  #define ARM_CPU_PART_MASK		0xff00fff0
>  
>  /* DEC implemented cores */
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 9aca920..462a099 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -252,6 +252,8 @@ int __attribute_const__ kvm_target_cpu(void)
>  {
>  	switch (read_cpuid_part()) {
>  	case ARM_CPU_PART_CORTEX_A7:
> +	case ARM_CPU_PART_CORTEX_A53_AARCH32:
> +	case ARM_CPU_PART_CORTEX_A72_AARCH32:

huh?  why are we mapping A53 and A72 cores to an A7 core?

-Christoffer
