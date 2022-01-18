Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A94C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 16:35:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281FB49DED;
	Tue, 18 Jan 2022 11:35:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MmyQSbfn55Tj; Tue, 18 Jan 2022 11:35:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08D940D01;
	Tue, 18 Jan 2022 11:35:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 035224087B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:35:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fimAigjp+O3A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 11:35:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D62405F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:35:20 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D7011FB;
 Tue, 18 Jan 2022 08:35:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 066513F774;
 Tue, 18 Jan 2022 08:35:17 -0800 (PST)
Date: Tue, 18 Jan 2022 16:35:26 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 15/69] KVM: arm64: nv: Inject HVC exceptions to the
 virtual EL2
Message-ID: <YebsTgBggC8YcCOm@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-16-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-16-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:56PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> As we expect all PSCI calls from the L1 hypervisor to be performed
> using SMC when nested virtualization is enabled, it is clear that
> all HVC instruction from the VM (including from the virtual EL2)
> are supposed to handled in the virtual EL2.
> 
> Forward these to EL2 as required.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: add handling of HCR_EL2.HCD]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..1fd1c6dfd6a0 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -16,6 +16,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/traps.h>
>  
> @@ -40,6 +41,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
>  			    kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> +	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
> +	if (nested_virt_in_use(vcpu)) {
> +		if (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_HCD)
> +			kvm_inject_undefined(vcpu);
> +		else
> +			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
> +		return 1;
> +	}

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +
>  	ret = kvm_hvc_call_handler(vcpu);
>  	if (ret < 0) {
>  		vcpu_set_reg(vcpu, 0, ~0UL);
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
