Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D8E23C3
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 15:28:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1089D75;
	Thu,  7 Sep 2023 08:29:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 730D63F67D;
	Thu,  7 Sep 2023 08:28:32 -0700 (PDT)
Date: Thu, 7 Sep 2023 16:28:26 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
Message-ID: <20230907152826.GA69899@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907100931.1186690-2-maz@kernel.org>

On Thu, Sep 07, 2023 at 11:09:27AM +0100, Marc Zyngier wrote:
> By definition, MPIDR_EL1 cannot be modified by the guest. This
> means it is pointless to check whether this is loaded on the CPU.
> 
> Simplify the kvm_vcpu_get_mpidr_aff() helper to directly access
> the in-memory value.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 3d6725ff0bf6..b66ef77cf49e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -465,7 +465,7 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  
>  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> +	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
