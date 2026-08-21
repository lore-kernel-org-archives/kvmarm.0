Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602C833D6D6
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321273; cv=none; b=cBdrN4ll3nYiiYxwIPnZka6jKW6z0tZPhZdfM9GBr0EjhKfNq/Wg8PSfDK35ot8r/dzNNe+l+/weIJg+Ari7w4VIHrdwbeqzaVCiQPQPCP7hOj4PqfaKKqVbTCRWRUABV8/M0QxXGsVVFhwiI6qs/Mizab7YFW8zjlYkdN9iA1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321273; c=relaxed/simple;
	bh=JCVdMMYyyY2M5FDk6kI1z8YBWx48BH6o/yTqAholXpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjCTpvQDYuAQTvhTaHROytTtO+ZjFupYRcW7vLUUOuV66jc0mYpvHrsoUFvfrDDsuelHllGt9BYYiCzGJkzKD+gZ4rSnWv1ZjfwqQz7luEBfDqtei2azcSIevK2lfdR0o5VNnlWQTELYFpyYy5VnwRzCesj1EXGDl5mr9V9ny/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TIx9PfyW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TIx9PfyW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE67714BF;
	Fri, 21 Aug 2026 07:07:46 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D3A83F8D6;
	Fri, 21 Aug 2026 07:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787321270; bh=JCVdMMYyyY2M5FDk6kI1z8YBWx48BH6o/yTqAholXpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TIx9PfyWkBjxOnF1Ik49l805DHl+r9+j/UKZI4i4c9xo3rcO/p9QApglM0XP2VIbQ
	 ZmNgoQnuAMe5ai4uQoIrF+ezzShF2WKxnFnOyquwLHjeX/D6nRK0ek2tTTQk+n/o0K
	 g5ITHTXpio2d27u9y2iNhsPMvPCaUuog/vbIr9Jk=
Date: Fri, 21 Aug 2026 15:07:36 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Mark Brown <broonie@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <up3nfebqc42ykeboaqng22ib3ndgkecuwtuz4bdstjzebsuesq@2fy6i736x4gj>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>

On Wed, Aug 12, 2026 at 08:12:02PM +0100, Mark Brown wrote:
> GCS introduces a number of system registers, on systems with GCS we need
> to context switch them and expose them to VMMs to allow guests to use
> GCS.
> 
> In order to allow guests to use GCS we also need to configure
> HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> CHKFEAT will report GCS as disabled.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h       |  3 +++
>  arch/arm64/include/asm/kvm_host.h          | 14 ++++++++++
>  arch/arm64/include/asm/vncr_mapping.h      |  2 ++
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 ++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 10 +++++++
>  arch/arm64/kvm/sys_regs.c                  | 42 ++++++++++++++++++++++++++++++
>  6 files changed, 102 insertions(+)
> 

[...]

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5..1f0da8988961 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h

[...]

> @@ -1648,6 +1658,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_sctlr2(k)				\
>  	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
>  
> +#define kvm_has_gcs(k)					\
> +	(system_supports_gcs() &&			\
> +	 kvm_has_feat((k), ID_AA64PFR1_EL1, GCS, IMP))
> +
>  static inline bool kvm_arch_has_irq_bypass(void)
>  {
>  	return true;

[...]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de..053d7b3c5104 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h

[...]

> @@ -131,6 +137,17 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>  	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>  
> +static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_GCS))
> +		return false;
> +
> +	vcpu = ctxt_to_vcpu(ctxt);
> +	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64PFR1_EL1, GCS, IMP);
> +}

This seems to duplicate some work done in kvm_has_gcs(), can we use
kvm_has_gcs() in this function?

static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt)
{
	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);

	return kvm_has_gcs(kern_hyp_va(vcpu->kvm));
}

Thanks,
Wei-Lin Chang

[...]
