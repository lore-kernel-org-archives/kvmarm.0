From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Tue, 14 Nov 2017 16:00:52 +0000
Message-ID: <5A0B1334.7060500@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA6A49D52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:00:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GoHULHFPnknE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Nov 2017 11:00:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DEBA49D6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:00:33 -0500 (EST)
In-Reply-To: <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: wuquanming@huawei.com, linux-doc@vger.kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, corbet@lwn.net, rjw@rjwysocki.net, linux@armlinux.org.uk, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, linux-arm-kernel@lists.infradead.org, huangshaoyu@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 10/11/17 19:54, Dongjiu Geng wrote:
> If it is not RAS SError, directly inject virtual SError,
> which will keep the old way. If it is RAS SError, firstly
> let host ACPI module to handle it.

> For the ACPI handling,
> if the error address is invalid, APEI driver will not
> identify the address to hwpoison memory and can not notify
> guest to do the recovery.

The guest can't do any recover either. There is no recovery you can do without
some information about what the error is.

This is your memory corruption at an unknown address? We should reboot.

(I agree memory_failure.c's::me_kernel() is ignoring kernel errors, we should
try and fix this. It makes some sense for polled or irq notifications, but not
SEA/SEI).


> In order to safe, KVM continues
> categorizing errors and handle it separately.

> If the RAS error is not propagated, let host user space to
> handle it. 

No. Host user space should not know anything about the kernel or platform RAS
support. Doing so creates an ABI link between EL3 firmware and Qemu. This is
totally unmaintainable.

This thing needs to be portable. The kernel should handle the error, and report
any symptoms to user-space. e.g. 'this memory is gone'.

We shouldn't special case KVM.


> The reason is that sometimes we can only kill the
> guest effected application instead of panic whose guest OS.
> Host user space specifies a valid ESR and inject virtual
> SError, guest can just kill the current application if the
> non-consumed error coming from guest application.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Quanming Wu <wuquanming@huawei.com>

The last Signed-off-by should match the person posting the patch. It's a chain
of custody for GPL-signoff purposes, not a 'partially-written-by'. If you want
to credit Quanming Wu you can add CC and they can Ack/Review your patch.


> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 7debb74..1afdc87 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -178,6 +179,66 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>  	return arm_exit_handlers[hsr_ec];
>  }
>  
> +/**
> + * kvm_handle_guest_sei - handles SError interrupt or asynchronous aborts
> + * @vcpu:	the VCPU pointer
> + *
> + * For RAS SError interrupt, firstly let host kernel handle it.
> + * If the AET is [ESR_ELx_AET_UER], then let user space handle it,
> + */
> +static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	unsigned int esr = kvm_vcpu_get_hsr(vcpu);
> +	bool impdef_syndrome =  esr & ESR_ELx_ISV;	/* aka IDS */
> +	unsigned int aet = esr & ESR_ELx_AET;
> +
> +	/*
> +	 * This is not RAS SError
> +	 */
> +	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
> +		kvm_inject_vabt(vcpu);
> +		return 1;
> +	}

> +	/* The host kernel may handle this abort. */
> +	handle_guest_sei();

This has to claim the SError as a notification. If APEI claims the error, KVM
doesn't need to do anything more. You ignore its return code.


> +
> +	/*
> +	 * In below two conditions, it will directly inject the
> +	 * virtual SError:
> +	 * 1. The Syndrome is IMPLEMENTATION DEFINED
> +	 * 2. It is Uncategorized SEI
> +	 */
> +	if (impdef_syndrome ||
> +		((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)) {
> +		kvm_inject_vabt(vcpu);
> +		return 1;
> +	}
> +
> +	switch (aet) {
> +	case ESR_ELx_AET_CE:	/* corrected error */
> +	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
> +		return 1;	/* continue processing the guest exit */

> +	case ESR_ELx_AET_UER:	/* The error has not been propagated */
> +		/*
> +		 * Userspace only handle the guest SError Interrupt(SEI) if the
> +		 * error has not been propagated
> +		 */
> +		run->exit_reason = KVM_EXIT_EXCEPTION;
> +		run->ex.exception = ESR_ELx_EC_SERROR;
> +		run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
> +		return 0;

We should not pass RAS notifications to user space. The kernel either handles
them, or it panics(). User space shouldn't even know if the kernel supports RAS
until it gets an MCEERR signal.

You're making your firmware-first notification an EL3->EL0 signal, bypassing the OS.

If we get a RAS SError and there are no CPER records or values in the ERR nodes,
we should panic as it looks like the CPU/firmware is broken. (spurious RAS errors)


> +	default:
> +		/*
> +		 * Until now, the CPU supports RAS and SEI is fatal, or host
> +		 * does not support to handle the SError.
> +		 */
> +		panic("This Asynchronous SError interrupt is dangerous, panic");
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
>   * proper exit to userspace.



James
