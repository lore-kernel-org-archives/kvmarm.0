Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEBF2EC081;
	Tue, 22 Sep 2026 06:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060107; cv=none; b=pB+FQYvEijyJq04kS2dENg53k1DuO2UuuDS1w55t5/SssyMRjHJZ7PUDc34CSCe+/qH/IRlyuuiPMchZ1nUzammghO1Zkq4vRDdnOCHuh26N1zvRWYb/jmDpKaxTVnhBUcwKLvEwAxdNdrEDaEUgWIcwvgvRwAvkUo02GuNPois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060107; c=relaxed/simple;
	bh=UD/Wey0mlBHk4woxCvw/WFilxzvjerSV6mWFxQdTJFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ea+4ZNv0lrcdUrE4hF8cIXpA+Y7cxEmVPk3465i/YSlDjjrLSFIiVd/QyA2WH8CyPlYCGZ8gdKEtBIo8z/e+HL4Rhqe4ioko1+bp9/F7y/hEbAAnnP8rcQcUcWQrjGVFABrG5j60IN2RP7UmeCE/8whoGBR9EtytwlISF3cO7Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+XhOINw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+XhOINw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D001F000FF;
	Tue, 22 Sep 2026 06:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790060100;
	bh=wLtGitIi2OiQg65dHRRJxop72DcmDI+o2e1E/zKQ5w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y+XhOINwZrcWlKpSEiXQdt3+zD3L2auPC/GvaE9XFlhSeO55CilXFon618dPN5Bdv
	 uxufpsWcq93lGy2ApXIVLgqzT4PjyICZ1lbQpGF0GOaBTqi6nWl6MQ3RkEIcLDiE2U
	 1ckswNCmhQBlLRHZCgtcbzXOGstotD8lln9xpOUS9r9QXeAGj/Cm0nBiV9oCKAxQFl
	 eQYTiy4mTW3KSjJdc6ebQ7N+m3pkfwVFX4ENoNkHpVEfIwmu2f0wj+6X8n/yRhXl4c
	 TPqME9qdENyh0vk1zkBEOzJMe9tLlQXGXnxJ2lbdnHBmDNjtmshkXm0g8gZfz0evXa
	 ErmpPYPKqeVTQ==
Date: Mon, 21 Sep 2026 23:54:59 -0700
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
Subject: Re: [PATCH v11 09/21] KVM: arm64: PMU: Recreate events after
 MDCR_EL2 changes
Message-ID: <arImQ6SG7s1k9uJk@kernel.org>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-9-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-hybrid-v11-9-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>

On Sun, Sep 20, 2026 at 08:15:50PM +0900, Akihiko Odaki wrote:
> +void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val)
> +{
> +	u64 changed = old ^ val;
> +
> +	/*
> +	 * HPMN determines which counters HPMD and HLP apply to. Changes to
> +	 * these fields require new perf event filters and sample periods.
> +	 */
> +	if (changed & (MDCR_EL2_HPMN | MDCR_EL2_HPMD | MDCR_EL2_HLP))
> +		kvm_pmu_request_recreate(vcpu);
> +	else if (changed & MDCR_EL2_HPME)
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +}
> +

Urgh... I'm not a fan of this. Can you just modify kvm_vcpu_reload_pmu()
to discard all backing perf events and recompute them only for enabled
PMCs? We set KVM_REQ_RELOAD_PMU pretty rarely.

>  	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
>  	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 75624725adf1..7dd2cafce247 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3114,17 +3114,22 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>  	}
>  
>  	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
> -
> -	/*
> -	 * Request a reload of the PMU to enable/disable the counters
> -	 * affected by HPME.
> -	 */
> -	if ((old ^ val) & MDCR_EL2_HPME)
> -		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +	kvm_pmu_apply_mdcr(vcpu, old, val);
>  
>  	return true;
>  }

> +static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 val)
> +{
> +	u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +
> +	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
> +	kvm_pmu_apply_mdcr(vcpu, old, val);
> +
> +	return 0;
> +}
> +

Just keep the old ^ new test inline for access_mdcr() and set the
request unconditionally from set_mdcr(). In the usual case
KVM_REQ_RELOAD_PMU is already set on a vCPU that userspace is restoring.

Thanks,
Oliver
