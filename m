Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E766A49B46E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099254; cv=none; b=T+lRHuXSztzO8XQNfAsrCFVWm/RxhO7z9lZq5IZP+l1brm5iJgU4Wxd4yAvMmeUMS3hZHcAEtEeKFh9h3wzPskTao+27CRrDf50WmAx6prnt1EpCLkQ8WGIGcSUMmC5HcSNL36sK8rA9tl6/wpLlAxWWqmSi7oixVe4hY3iirtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099254; c=relaxed/simple;
	bh=Yj7QpJ6iyLJp+q4iSF4BxN/HXKQJV7Rin6lEq+jWuVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qI274B+qJTEvpnOv+oKtF977CFM6brII2jcuDgYC3kzVo3KVEbxo2+gL8Q6b/yyZaLQRZVb+g6SXCVajj/t/x48U4bxxnuNqvcjZZUix7PbP3sCXcPWlkZqeGCD25ZFaZb+KxM05+IUiFJzLjgvF4LDzjHI8oFpza/aCkLxF/e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPX6WjOL; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPX6WjOL"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a18617ae90so22705e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099250; x=1792704050; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/SCp3soHlE0ZHF/n58Ck0SA2pQz3WeYqKxv+5snRHI=;
        b=JPX6WjOLAa9zW1lb2gC3oX44X6AAGStFK+D19g9asM1c1w5fnVIl9LaQDyPB2M/bZl
         C46U8tOUlSsjNjlpVyoM1C4o1vT6BG9uzv84eGQMStBHSGQ1uuxsp874QK5GivE9tLLg
         86tkgkc8vUFCV4ZiCxqBGYjyInQ0mj6h4GnBTJ67aUqwwhXxeIpHVkAq9OVEO3Kyw7FK
         hfxRfXZvsFZDfvbddFe25d9xjg0jXTpR3j9C5ELBcwmL3KOnc/mV/JD2f+vWSCAltYLD
         9tOK0Y1wHVCNh2sLRcG7G3/1MInlYi9vMrD2pGl2F4ZClz//P4oQG/oyJEYbQaAzOUbp
         Fd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099250; x=1792704050;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=d/SCp3soHlE0ZHF/n58Ck0SA2pQz3WeYqKxv+5snRHI=;
        b=dsl02BQcnSCFsl+IRvBcy28/nVfXa0G6Pqc0zq1c1E3zom3I/9yzu8NsSJ9STMZ1Mg
         OIAxTqjcYYeReEC0CQ9firwZm5rc6H/p+c6ZtjPfCPNaE+QygaRh1jzUeB8ZFhxZr6Ta
         26ByjLWmPkEQYG+wOhMdybLPwEwZfRsJvwx6UqyasBje0K9nSLBUH2abRmsP1S3HcMx8
         dsJrnxs49pzep/9r++gqjc3bCmSXB9dUHKbDUStq4/r1UOnbUpLYwgo7+lIDpFH2oekq
         FjpcOJyMBMXQRE7nGkZ6V8LnX/ds01efLNLmCj+BYlXycxUsLq1NQKNyiOCO6OqNjTEz
         38sA==
X-Gm-Message-State: AFq9FYIG2z2j/71nD9bA9zPMcj4CKQaEhnAZVA25cEZNW3naM6PwRq7b
	rdH6jmyFyk+8jkgptjJx3P+jdkaKrBXbq79B8A2j0YLTQN5O28sHCrey8o+X79tMrA==
X-Gm-Gg: AYBFou2nDukRjrHSC2+80qkhSomqmGCarfvGKnRBYY+XO/pSP80KNpSVMOwLrVkBd9/
	ucFV2WP7idmDRbdzYM0DgR9IqzptmGc82q5SfISIyP7WohTaaz1gpps7qyogjuT3AKpQdMarnzk
	Jrt2TAvYXY4hRYkj6RYDN/4b0q9ZZfyLmAOdwllG65g1NLUJgF0+2gC3Kg0Tyi1CUzZnJqvqbU5
	eTIXmUbCm4Oz69Snz1aYlv1QdENZik/ITMPzk3iOZXgQrtnENgWHgIt4j3SktbIua3CFqf0FDCa
	gJDL44HFUoMLAWt9y7SYSAa96cYHrCRjwng73za/LNj3dm0Ci3CW4Jh+bSfa+E+NbHUI43BfYu6
	TQiWF9hVNqGsRUd1+VXPGtR5x/xcM3yHH5gQto/9wayyng3fOaBdiUIR4k03VS/v+lj2ElYhLlk
	vmtAJkefzuNIMBPvwFTaEi+K5mCtAgr+slrFtKDMEutsw1nj3z7KV3CrrcweaqpYvMfKPjfeEPa
	KUPCUAadphm5zRjnAuXNHkbLuyXSjgy5K6aIkMy
X-Received: by 2002:a05:600c:530e:b0:4a0:1ca4:2741 with SMTP id 5b1f17b1804b1-4a1c8ac51acmr127955e9.9.1792099249597;
        Thu, 15 Oct 2026 14:20:49 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd503862sm524181f8f.46.2026.10.15.14.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:20:48 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:20:45 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Message-ID: <atFDraQXAgVAEJlS@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-18-smostafa@google.com>
 <sashiko-outbox-173398@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173398@kernel.org>

On Thu, Oct 15, 2026 at 08:30:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] iommu/arm-smmu: missing length check for STRTAB_BASE corrupts hyp state
> - [Low] iommu/arm-smmu-v3-kvm: Incorrect WARN_ON usage panics hypervisor on invalid host config
> --
> 
> commit 9c237aa634fe8fc969bb3e8a3f07ec53bd303b77
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Shadow stream table
> 
> This commit allocates the shadow stream table per SMMU, sized up to 1MB
> for the 2-level host table case. Host writes remain passthrough for now,
> and the stream table is shared/unshared on SMMU enable/disable.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -441,6 +502,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> [ ... ]
> > +static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
> > +	if (WARN_ON(!is_cmdq_enabled(smmu)))
> > +		return;
> > +
> > +	WARN_ON(smmu_update_ste_shadow(smmu, true));
> > +}
> 
> [Severity: Low]
> Does this panic the hypervisor on invalid host configuration?  These
> assertions evaluate host-supplied states and configurations, which causes a
> fatal EL2 BUG() when the host makes an invalid transition.
> 
> According to the pKVM Threat Model, host availability against itself is not
> guaranteed, making this a hardening improvement rather than a security bug.
> However, per the pKVM WARN_ON semantics guide, WARN_ON must only be used
> for EL2 internal invariant violations.  Validating host-supplied inputs with
> WARN_ON is a correctness violation, as the hypervisor should gracefully
> handle or ignore invalid state transitions rather than panicking.

Same as replied in v8:
https://lore.kernel.org/all/arKjzVDb56JmHJMc@google.com/

> 
> [ ... ]
> > @@ -528,7 +629,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		}
> >  	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_STRTAB_BASE:
> > +		if (is_write) {
> > +			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
> > +			if (is_smmu_enabled(smmu))
> > +				break;
> > +			smmu->host_ste_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> 
> [Severity: High]
> Is a length check missing here?  The missing len == sizeof(u64) check
> allows a 32-bit access to capture the full 64-bit CPU register, corrupting
> host_ste_base.
> 
> A 32-bit write to STRTAB_BASE will assign the entire 64-bit
> regs->regs[rd] (including uninitialized upper 32 bits) to
> smmu->host_ste_base.  Unlike the ARM_SMMU_CMDQ_BASE trap handler which
> explicitly ensures the access is the correct width (if (len !=
> sizeof(u64)) break;), this handler omits the validation.
> 

Yes, for bisectability, that is fixed next.

> >  	case ARM_SMMU_STRTAB_BASE_CFG:
> > +		if (is_write) {
> > +			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
> > +			if (is_smmu_enabled(smmu))
> > +				break;
> > +			smmu->host_ste_cfg = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> 
> [Severity: High]
> Similarly, is a length check missing for this 32-bit register?  The missing
> len == sizeof(u32) check allows 64-bit writes to pass through to a 32-bit
> register offset.
> 
> A 64-bit write to STRTAB_BASE_CFG will invoke writeq_relaxed() on a
> 32-bit register offset (0x88), causing an unaligned or oversized write to
> Device memory which triggers a fatal EL2 alignment fault.

Same as above.

Thanks,
Mostafa

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=17
