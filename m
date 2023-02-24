Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAE25CBD
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 15:12:41 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8AB11042;
	Fri, 24 Feb 2023 07:13:23 -0800 (PST)
Received: from [10.1.196.177] (eglon.cambridge.arm.com [10.1.196.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E1623FB75;
	Fri, 24 Feb 2023 07:12:38 -0800 (PST)
Message-ID: <b10d117a-3d3d-c273-9885-3bfecfa8304d@arm.com>
Date: Fri, 24 Feb 2023 15:12:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v2 5/6] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, Salil Mehta <salil.mehta@huawei.com>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-6-oliver.upton@linux.dev>
From: James Morse <james.morse@arm.com>
In-Reply-To: <20230211013759.3556016-6-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 11/02/2023 01:37, Oliver Upton wrote:
> In anticipation of user hypercall filters, add the necessary plumbing to
> get SMCCC calls out to userspace. Even though the exit structure has
> space for KVM to pass register arguments, let's just avoid it altogether
> and let userspace poke at the registers via KVM_GET_ONE_REG.
> 
> This deliberately stretches the definition of a 'hypercall' to cover
> SMCs from EL1 in addition to the HVCs we know and love. KVM doesn't
> support EL1 calls into secure services, but now we can paint that as a
> userspace problem and be done with it.
> 
> Finally, we need a flag to let userspace know what conduit instruction
> was used (i.e. SMC vs. HVC). Redefine the remaining padding in
> kvm_run::hypercall to accomplish this. Let's all take a moment
> to admire the flowers and see how 'longmode' tied up a full u32 in the
> UAPI. Weep.

> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 45b8371816fd..f095c048730a 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -161,6 +161,17 @@ static u8 kvm_hvc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
>  	return KVM_SMCCC_FILTER_DENY;
>  }
>  
> +static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id, bool smc)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	run->exit_reason = KVM_EXIT_HYPERCALL;

> +	run->hypercall.nr = func_id;

This is a bit weird. The func_id is the x0 value, so it would more naturally live in
run->hypercall.args[0].

User-space also needs the SMC/HVC immediate value, as that is only available in the ESR.
It makes more sense to put the immediate value here.


> +	if (smc)
> +		run->hypercall.flags = KVM_HYPERCALL_EXIT_SMC;
> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;


Thanks,

James
