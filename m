Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1C32FF672;
	Tue, 22 Sep 2026 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059401; cv=none; b=uXMocVp/Cs9OqwayN5jADKtOGZnbFl37KhmasEUrCM5w+81n3a3EoDogGAtUq5P+vLHNw1cFqdVGoO03p45RcnrFRF54rYVj18lpWtZj+iipunyQQPvRI0uPVB18AMuK1IphzDhqr9BcDpMOH8pYhTPxqFtYZ6pCn+1qDHvmfdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059401; c=relaxed/simple;
	bh=/JTvVwAa8wp2p8UY5azd/n4TXS07TMF1QBglfodrLWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RezzVq71dMSk9cyenjhdD3fMNT7nn56CRxdvtg+yx/J1HJFEtaJz1kE0Lws6odVKEikjppT5GShFpB7pVxFpxR9XTcvHcL9P+way8MSNJQSSwBZ66idr8PGSpVER1YDckL3r2utM3M65yVsuo5BTho5nR+Uwrw9aj6DByntlW9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdX9Ya7V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdX9Ya7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537431F000FF;
	Tue, 22 Sep 2026 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059399;
	bh=ZNn+S45uuHSM1MevwqL8L/OLU6cXbDvK1jrtFFoJQRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MdX9Ya7V1NXVARco19qfnbcVEbNm56zISiZkNG3b9akDoeSs0/EYgTd7QCnlnaoa6
	 j2PV5pmtakJaak1Co1gKLHuRiQlcvuwsQVoRCQbgks6IvTtVgn5Ypxr4Iu5PrPl4IA
	 Yf1e8Snkoq3cpLt6pTMAUx7tdUM6zilk6a/UUJ2ClgIao2M5/Wb7me08izuBgK/1Ar
	 kwpLRIdauWOmK9foRBd5P1ZbFjUQcVNcqytK16X+JIl4Pf6Xkg75w+lZFanHIgdaFK
	 +kL6xFN42h9oNj9HCgbS9x9NuXH6tolh7CmaQg6Vd8tWkKZB02d1OZutpNm+t8BUfG
	 ITmBh1WGyx0Kw==
Date: Mon, 21 Sep 2026 23:43:18 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shannon Zhao <shannon.zhao@linaro.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 08/21] Revert "KVM: arm64: PMU: Reload when resetting"
Message-ID: <arIjhlqqzt4AKTOr@kernel.org>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-8-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-hybrid-v11-8-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>

Hi Akihiko,

On Sun, Sep 20, 2026 at 08:15:49PM +0900, Akihiko Odaki wrote:
> This reverts commit fe53538069bb4f625bc8734103ba044a83138fea.
> 
> Restore PMU event teardown before system-register reset so existing
> perf events cannot retain configuration from the previous run. All
> counters are disabled by the reset PMCR_EL0 and MDCR_EL2 values, so
> reset does not need to request a PMU reload.

Sorry, I'm not following the intent here. KVM_REQ_RELOAD_PMU should
already be discarding + recomputing perf events based on the state of
the vPMU. What's the problem?

Thanks,
Oliver

> Assisted-by: Codex:gpt-6-astra
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> ---
>  arch/arm64/kvm/pmu-emul.c | 14 ++++++++++++++
>  arch/arm64/kvm/reset.c    |  3 +++
>  arch/arm64/kvm/sys_regs.c |  3 ---
>  include/kvm/arm_pmu.h     |  2 ++
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a5ccb6ae44d5..14fcdbdb4587 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -258,6 +258,20 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>  		pmu->pmc[i].idx = i;
>  }
>  
> +/**
> + * kvm_pmu_vcpu_reset - reset pmu state for cpu
> + * @vcpu: The vcpu pointer
> + *
> + */
> +void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
> +	int i;
> +
> +	for_each_set_bit(i, &mask, 32)
> +		kvm_pmu_stop_counter(kvm_vcpu_idx_to_pmc(vcpu, i));
> +}
> +
>  /**
>   * kvm_pmu_vcpu_destroy - free perf event of PMU for cpu
>   * @vcpu: The vcpu pointer
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 10eb7249aa9e..adcb460a5287 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -185,6 +185,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reset_state.reset = false;
>  	spin_unlock(&vcpu->arch.mp_state_lock);
>  
> +	/* Reset PMU outside of the non-preemptible section */
> +	kvm_pmu_vcpu_reset(vcpu);
> +
>  	preempt_disable();
>  	loaded = (vcpu->cpu != -1);
>  	if (loaded)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1481dd5c99a8..75624725adf1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5388,9 +5388,6 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>  	}
>  
>  	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> -
> -	if (kvm_vcpu_has_pmu(vcpu))
> -		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>  }
>  
>  /**
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 6b4a118d17ca..51f5e4ca3326 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -48,6 +48,7 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
>  u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
>  u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
>  void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
> +void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
>  void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
> @@ -125,6 +126,7 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
> 
> -- 
> 2.55.0
> 
