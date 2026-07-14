Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF735CDF1;
	Tue, 14 Jul 2026 00:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989030; cv=none; b=hQZOF1pjV290pvFUvBol1MVpslWWAcmreHdCsYbKm1RU0s0ufzPzHyirgyPug2nMPYD2TN0isndW/BliiWhI5e+u1xxJRiNOzlB+x2Q5hZxpA+xapbe1cvoZMsnGxaF4hrQEw9jimsJuxi9fJnIpqJwEyC3hv/VMa8zcI/3HElo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989030; c=relaxed/simple;
	bh=PqPoGVhgrrR8E2OVoBi1CU17djVHEEF/PVTGy3XqHwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9t5/ICUhdXFMG2yvtJoyQ5Z8WRbWywy8QnOMpzzSGCd+wMz2wd/cYLvSJhZjj3OobfcUq2HcTYMLebHidpQXq3pggGsnJbsm2wY86l/OYd7E7Akt5mljOAKl6PcbMKMsmCDcgHF1hkaoPUXbFG13VAFOHFlm0JDU8k0ROi0zPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZfpObAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZfpObAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9045A1F000E9;
	Tue, 14 Jul 2026 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783989028;
	bh=HwJZ5fDbgmSR+ahAQmiwhuMgMix6CJj7qh6ixmGfCak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XZfpObAHeg8LWfDAIVeaDnwOHoYt6s07qQxfji5bFHlBxmhmIi1GMBms0Ei3w6+HH
	 UsY1hf8lvwjnTyET7dQG2mLbyPs0GSc9BeTORNQmfEDWMNY//0fLRIga60d0lZnGRS
	 qe13vDplIlSV1+gM/FB4GIY+ImjGiz2kFiOEFzDadMCZ7YLeezyGsGJh+DMl6teH4g
	 JnfXTO3ORKkLDFqBv6hnFDT13VRatuMaTj3TusR3Nu/wpQMaU8OlZwbSWuEdTyY+HB
	 2QbOaJs8+zI0hztq691GAgedgDDhO4ejk48hTqZ/i28LoOYTSXHPbdntgq7vHG27xC
	 3zZ6+U7pL1rsg==
Date: Mon, 13 Jul 2026 17:30:27 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Message-ID: <alWDI7uj9YFedXET@kernel.org>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
 <20260706095927.560795-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706095927.560795-3-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Jul 06, 2026 at 10:59:21AM +0100, Fuad Tabba wrote:
> The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> shared with hyp code. exception.c already wraps them in
> __vcpu_{read,write}_sys_reg(), which pick the host- or hyp-side accessor
> via has_vhe() and so are valid in any context.
> 
> Move those wrappers to kvm_emulate.h as kvm_vcpu_{read,write}_sys_reg()
> and switch the callers over, so a follow-up series can share that
> emulation code at EL2.
> 
> No functional change intended.
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++---
>  arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
>  2 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c7..80b30fead3d16 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
> +static inline u64 kvm_vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	if (has_vhe())
> +		return vcpu_read_sys_reg(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void kvm_vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	if (has_vhe())
> +		vcpu_write_sys_reg(vcpu, val, reg);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +}
> +

Can you instead name the wrappers vcpu_{read,write}_sys_reg() and rename
the current implementations, like __vcpu_{read,write}_sysreg_vhe()?

Just want to avoid confusion between kvm_vcpu_ and vcpu_

Thanks,
Oliver
