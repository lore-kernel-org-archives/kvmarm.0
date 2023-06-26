Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E80BE72
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 16:49:01 +0000 (UTC)
Date: Mon, 26 Jun 2023 16:48:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687798139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IQ+NC27aMgv0ztxLiP3ByfmiLxp7At8i5hTjCGM9ejY=;
	b=mqylp3I9H/ncx04BkpRwGJ9pnni5kauhllqjjtjjFibwYf4eQFYOYr6K0iffCQh3mkrfd3
	LHgw7nOAhJu0TRrGXNGjI9xzLrSg/78AuU5wGin4TZJYHShlB9VPEyoGGop+dmON74F0u0
	ZgBiH1lPsb/a5J+VaCDj/gLrypd/bms=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
Message-ID: <ZJnBdtkzeQuPqQGO@linux.dev>
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-4-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607194554.87359-4-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 07, 2023 at 07:45:53PM +0000, Jing Zhang wrote:
> Return an error if userspace tries to set SVE field of the register
> to a value that conflicts with SVE configuration for the guest.
> SIMD/FP/SVE fields of the requested value are validated according to
> Arm ARM.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3964a85a89fe..8f3ad9c12b27 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1509,9 +1509,36 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  
>  	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
>  
> +	if (!system_supports_sve())
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
> +

If the system doesn't support SVE, wouldn't the sanitised system-wide
value hide the feature as well? A few lines up we already mask this
field based on whether or not the vCPU has the feature, which is
actually meaningful.

>  	return val;
>  }
>  
> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       u64 val)
> +{
> +	int fp, simd;
> +	bool has_sve = id_aa64pfr0_sve(val);
> +
> +	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_AdvSIMD_SHIFT);
> +	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP_SHIFT);
> +	/* AdvSIMD field must have the same value as FP field */
> +	if (simd != fp)
> +		return -EINVAL;
> +
> +	/* fp must be supported when sve is supported */
> +	if (has_sve && (fp < 0))
> +		return -EINVAL;
> +
> +	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> +	if (vcpu_has_sve(vcpu) ^ has_sve)
> +		return -EPERM;

Same comment here on cross-field plumbing.

-- 
Thanks,
Oliver
