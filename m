Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89F1F09A5;
	Thu,  1 Oct 2026 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851860; cv=none; b=ImilzA2k2YunX7HCxf+9e7/k8Ox/ahm0lgntQLuR90QmEa1pwPN4hfD6w85KoW+o97NXwLKCBo2WniEOnEQeciT+TMcY/1u5fiXYWe2hdmJxSvlsVFby5lkZFVlYVYOQ96s5K8J8PNtVRxDF0QCkPLU1n2W/Fivl4BphLkqK1a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851860; c=relaxed/simple;
	bh=i1e5atsAyug6xkqquAcMBMvETVmH2j/Jas3w3W4pt+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l5HiBjOjOjsvRIDGdJc9NiT6Y7m6neiellgLleT1t7s23cW2IcG9BfKyTQV7E3/X9ubdqJEwu9gpqBDGq/TSW+pt9HhYxpkVOBHFtySOjyJd/1I+2CImLqq4le2XvpzRn0VAar0cJ1SZnPClCYIUnmeVqxYJ+V2Y7SyaJsGwWlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/0f4Qi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/0f4Qi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A46E1F000FF;
	Thu,  1 Oct 2026 10:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790851858;
	bh=xHk+A5Sdr78XfGzIL/hT9Sc/BCLMrjVL63nMxl+dTOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F/0f4Qi1BcZboIFrJ8gvrQdKLcHA689Xa+ziPcEImnPg59/XyNF0X4WCkbq2x3T5T
	 iOqpbm4jE/zo8FvcldMI9OWZX/ySs/0+U0x/TM+17FS4Q3HwX/fmvlEH7E4TW6Adl8
	 CcZ6Di5+gzxs8F3M39gsocZJkxPirxl3ldGTV64YQHZLQoCFGdFmbgNdrr5Sx6OG8B
	 Rf5xq4yWeXQIozISHrooVwHzlA+LOCPZsU0wVIjGHJEazkeDYSA8aNRwFO8psAkHfZ
	 9jSBMsd5HLL2ZfQf5Gf6O2qYy6a99kc69zR4PKlN3GehsPwVszioku+gciX+bAcdga
	 JI9wNQYCcOGQA==
Date: Thu, 1 Oct 2026 11:50:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <ar4yT297fh45gwM6@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:12PM +0100, Mark Brown wrote:

> Fixes: 663abf04ee4d ("KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX")
> Signed-off-by: Mark Brown <broonie@kernel.org>

Great, this looks like the most sensible way of resolving the issue with
userland being able to trigger a kernel oops due to the save/restore
registers optimisations.

It's also entirely sensible to disallow completely broken configurations
like this.

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d..3ae293798b27 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

> @@ -5928,6 +5946,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  		kvm_vgic_finalize_idregs(kvm);
>  	}
>
> +	if (!kvm_validate_id_regs(vcpu->kvm))
> +		return -EINVAL;
> +

Seems like the right place to put it as part of the finalisation process,
run once per VM and guaranteeing the invariant so it's guaranteed that
ctx_has_s1pie() -> ctxt_has_tcrx() and ctx_has_s1poe() -> ctxt_has_tcrx().

(Just working it through for my own understanding), tracing through it ends
up at struct kvm_arch->id_regs[]:

kvm_has_tcr2()
  -> kvm_has_feat()
    -> __kvm_has_feat()
      -> kvm_cmp_feat()
        -> kvm_cmp_feat_unsigned()
	  -> get_idreg_field_unsigned()
	    -> kvm_read_vm_id_reg()
	      -> __vm_id_reg()
	        -> ka->id_regs[]

Which will all have been populated by here. however failing at this point
will stop KVM_ARCH_FLAG_HAS_RUN_ONCE from being set (also obviously your
other series separately fixes the issue with KVM_ARCH_FLAG_FGU_INITIALIZED
being set with !KVM_ARCH_FLAG_HAS_RUN_ONCE).

--
Cheers, Lorenzo
