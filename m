Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0EC148850
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778260837; cv=none; b=GXQS4dXbipb23QDv35T5CuGpA9TDK1OFmSDLRKR9jTZh5jKhN8ozp4hkZnFxVb12LyDwRY/AgXLpDNseVtmqa/d5ESNR3uXF6gDmEDf/vIW+aI7m1Le+lzQRLDX37pOyd+0qfrpUeST/q2cz5yIIe+ZI8kBPVOyeL/nQRrKJHik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778260837; c=relaxed/simple;
	bh=VIpaIdq08wjRpBWfnPXJEwTJDQEICZVJcS3hyR9NLpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfLRBQtWTTIiZBV2qkeA3ZttEWFCCOSwD9YVsWPj8dXvmun0CxlUYVj2JLU9n1CF7kLBK/VT8axScz22n+FSdSxeC2fiA5i98ULgmBSO9vOYhShGRD1MF5qgz0387nwGuiNET5/EB+Qs04CYN5N4kprWfwaMK53R141zv0/rvW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oZlzpBvM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oZlzpBvM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F3DC22D7;
	Fri,  8 May 2026 10:20:30 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1A783F836;
	Fri,  8 May 2026 10:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778260835; bh=VIpaIdq08wjRpBWfnPXJEwTJDQEICZVJcS3hyR9NLpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oZlzpBvM3kB4R3YSBeQz6gKgJmqfggBligCcpTqgEZXTpNWvuOS6tcb8YSZFF1+Fp
	 kWnWUogxR1+d6Lsf9g9rsdrHZqLJNTKjJ1N1dWhsJRabhzYObA4PglPOeM69C9nq/z
	 qCOQcg0gdCUWunQoEjjmnB+fLCkzhxF+ZBpNE7M4=
Date: Fri, 8 May 2026 18:20:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 15/30] KVM: arm64: Support SME control registers
Message-ID: <af4bWxiOogfPz_dp@J2N7QTR9R3>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-15-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-15-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:01:07PM +0000, Mark Brown wrote:
> SME is configured by the system registers SMCR_EL1 and SMCR_EL2, add
> definitions and userspace access for them.  These control the SME vector
> length in a manner similar to that for SVE and also have feature enable
> bits for SME2 and FA64.  A subsequent patch will add management of them
> for guests as part of the general floating point context switch, as is
> done for the equivalent SVE registers.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h  | 14 ++++++++++++
>  arch/arm64/include/asm/kvm_host.h     |  2 ++
>  arch/arm64/include/asm/vncr_mapping.h |  1 +
>  arch/arm64/kvm/sys_regs.c             | 42 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..7a11dd7d554c 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -89,6 +89,14 @@ static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
>  	kvm_inject_nested_sync(vcpu, esr);
>  }
>  
> +static inline void kvm_inject_nested_sme_trap(struct kvm_vcpu *vcpu)
> +{
> +	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SME) |
> +		  ESR_ELx_IL;
> +
> +	kvm_inject_nested_sync(vcpu, esr);
> +}

This implicilty has the SMTC field as 0b000, which is correct for traps
of SMCR_EL{1,2} due to SMEN, but wouldn't be right for other traps (e.g.
traps of ZT0).

If we only use this for traps of SMCR_EL{1,2}, that's ok, but I think
it's worth a comment, and possibly a more specific name. Perhaps
kvm_inject_nested_sme_smen_trap() for now.

[...]

> +static bool access_smcr_el2(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	unsigned int vq;
> +	u64 smcr;
> +
> +	if (guest_hyp_sme_traps_enabled(vcpu)) {
> +		kvm_inject_nested_sme_trap(vcpu);
> +		return false;
> +	}
> +
> +	if (!p->is_write) {
> +		p->regval = __vcpu_sys_reg(vcpu, SMCR_EL2);
> +		return true;
> +	}
> +
> +	smcr = p->regval & ~SMCR_ELx_RES0;
> +	if (!vcpu_has_fa64(vcpu))
> +		smcr &= ~SMCR_ELx_FA64;
> +	if (!vcpu_has_sme2(vcpu))
> +		smcr &= ~SMCR_ELx_EZT0;
> +
> +	vq = SYS_FIELD_GET(SMCR_ELx, LEN, smcr) + 1;
> +	vq = min(vq, vcpu_sme_max_vq(vcpu));
> +	smcr &= ~SMCR_ELx_LEN_MASK;
> +	smcr |= SYS_FIELD_PREP(SMCR_ELx, LEN, vq - 1);

I'm not sure this sanitization is correct or necessary, and the same
concern applies to ZCR_ELx.LEN.

AFAICT, none of the values for the SMCR_ELx.LEN and ZCR_ELx.LEN fields
are reserved or unallocated. Thus all the bits of those fields should be
stateful, and a read should observe the last value written, regardless
of the effective value of the field.

That means that the following at EL2 or vEL2 shouldn't produce a
warning:
		
	int len_write, len_read;

	for (len_write = 0; len_write < 16; len_write++) {
		write_sysreg_s(len_write, SYS_SMCR_EL2);

		len_read = read_sysreg_s(SYS_SMCR_EL2) & SMCR_ELx_LEN_MASK;
		WARN_ON(len_read != len_write);
	}

Either what we're doing is wrong, or the architcture requires a
clarification to say that values corresponding to unimplmented vector
lengths are reserved.

If those bit are always stateful, the the logic to sanitize the LEN
field shouldn't live here, and that will need to happen when consuming
the effective value.

Mark.
