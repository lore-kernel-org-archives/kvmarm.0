Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF23A12B67
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 15:29:56 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 185B7176B;
	Thu,  7 Sep 2023 08:30:34 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C01103F67D;
	Thu,  7 Sep 2023 08:29:54 -0700 (PDT)
Date: Thu, 7 Sep 2023 16:29:52 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when
 mpidr_data is available
Message-ID: <20230907152952.GC69899@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907100931.1186690-4-maz@kernel.org>

On Thu, Sep 07, 2023 at 11:09:29AM +0100, Marc Zyngier wrote:
> If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
> use it to recover the corresponding vcpu.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 30ce394c09d4..5b75b2db12be 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2395,6 +2395,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>  	unsigned long i;
>  
>  	mpidr &= MPIDR_HWID_BITMASK;
> +
> +	if (kvm->arch.mpidr_data) {
> +		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
> +
> +		vcpu = kvm_get_vcpu(kvm,
> +				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
> +		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
> +			vcpu = NULL;
> +
> +		return vcpu;
> +	}
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
>  			return vcpu;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
