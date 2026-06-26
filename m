Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C21F1513
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 09:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782465900; cv=none; b=KC/Vln3He/h+HT0GxrNf+j7IzEl4qrU18BgPUEwkMMn+HfYkogBXAVzpDVXQUBiM7gW31xmcUsXMlf9YFSN3bCULNg/w5NHUzQiCivXjLYlU43E59EzxzrtzoVKkr44B+7oGuqWSOmD5gQdv6eZ/S4z/Z1qPTBnqXdRSC6JPxoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782465900; c=relaxed/simple;
	bh=UX1LcxIS8tpJdRXXjA5HICZHQL/uQ/FeevsH/uSwcnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObvodJE9CMNSN12NVq1ghdDCFTW6w7+UiVdcyu2lkcaKCFUtJKNCXTePI75L6TwtkmEI/BkYzdBrIfoCgQzXmYZrVvB4jQBNT81Ajna4BLHGHZI3Htvrep10xxtBHhOQpQu3I7bzdkilYNWtNhTDjdPN1oc+lGnoLlhBIMOEp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XVpNK7Js; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XVpNK7Js"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4924933d072so31525e9.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782465898; x=1783070698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yxYemHQPrdk3fS8tD+TpeUcazBw+tvGubw+zL762ZGc=;
        b=XVpNK7JsfkAsHIAtwUePVUE2V/moAyCFdkNbdYwflUBwNCjf0/sLjzCCpc1czq9x0h
         SNj+EHVXtsfDwfYGu8rM+719GkYmwBRRXUQOOjLz6cKlM2AfLYJavUYGHbN2Ofroap7S
         TbObODqnYnm+lYz9XkcCI9RWIL2aSMqkRGEHlHLizRQyKyck2BRdxqGoWSlCjt+Kx1Ne
         6lrmb1R0e2g5fSmXucEKvAJwu8s4ioMyk25XQsSUYKFy2Z3Wy5khTiuOc7CbXObLOHo8
         9RINfSxuaKYFvf97dLAol/DmSXP0M/4BMwGI+1FNytcgKxaW0cjQo2IXtLkj5iLWSU+7
         GNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782465898; x=1783070698;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yxYemHQPrdk3fS8tD+TpeUcazBw+tvGubw+zL762ZGc=;
        b=Acd4lPC1sWm+UHVebac9mOkxq3Pk3o3MMvoIVDTitcCxxbQc6oWCtxAld13hxJpfjk
         VRLcuoaf16zi469zjkiF6malitNpk8IUsJ0th7uVdxju1YaSertye/3dnyTbq/0cP2wH
         bfiw0bbUF2FIxDKjwMOaLKAJn0mt6Tjis3aouVqHtni4edIQygzAuoPxgWSWmvUBVMXd
         2VLZDUBRbfT3BARKaxFxyHC2EXZue8ty4/fKBZkZUFCIwbxr1gqYpnHl8sFAPI3k5w7H
         o7ft56x8ifgJT4O/THZbJIVQcPji0m2exp5BXnb8TYbdOr41e0wVOvN431Xi0FQSQJeg
         TqMw==
X-Forwarded-Encrypted: i=1; AFNElJ/erWA889ne6Xc5+rFjbJ++X1TLZpFMEKjyY1NrDnAOZnW+FU6AAcw2RuyPXeX4E3uoWDTwyUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsrOEMSbzo7O/7EPdXYleC3bBk0R/YLxsJuEnc6p728+fH0IMH
	likYHqKBxng4AUCsaF8fpe5b6cbHFmLEPi4Rm6fqGtNFTCj+picID1ZocKtBYFvf/g==
X-Gm-Gg: AfdE7ck0TKkFww3gia3mU4h0lRwb66rDWcoQ0v8VtX1p0X3phDpRsW4T5lX19Rysp9a
	rC4pB1zjVKsU3aA7tozSjw+eVPBc6rTvduelNVIn86k2iPkRo9gXVUT/dOmNNvya85+2rQ5020B
	vXwZ/zSPEotkrCZcjYal/xolb4BEWGP5czlB8cIfsj8yWV/tUuNnJ46dTY/aaEKFk0SK7gNBUOL
	6BEceXBKulNYIHc+3iV9s56YHx+pG4BLIgakaHhjwCxWzvI1n8ZZN4v7UrBNH4e4JA8ppe9w3xF
	a6RPlvFVmXYGQpSPSqkclEz/9KOEcZO+xHB2EgCgK2WxaX4Eq/ZhdnhYKp3fP5AZyRR9uNwjWgv
	ZywofLbX6iNOOsz7y87ebwWhwr3WHHDElPlpGUhbdYbWUT65YqXJmRYReoq1JR5eha1DMrZCeim
	XZ4MREwLVXLnuNQAI5UDbm2ZoE20vQeOel+pX8Emnt7MbpzD6BLQ7h4MZloNs=
X-Received: by 2002:a05:600c:3e05:b0:48a:5d55:c194 with SMTP id 5b1f17b1804b1-49269ffaa9amr983445e9.7.1782465897233;
        Fri, 26 Jun 2026 02:24:57 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm24794653f8f.21.2026.06.26.02.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 02:24:56 -0700 (PDT)
Date: Fri, 26 Jun 2026 09:24:52 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v6 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <aj5FZBO7FJ4r219O@google.com>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-8-sebastianene@google.com>
 <aj5CMsyQ25xuxISV@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj5CMsyQ25xuxISV@willie-the-truck>

On Fri, Jun 26, 2026 at 10:11:14AM +0100, Will Deacon wrote:
> On Fri, Jun 26, 2026 at 07:45:45AM +0000, Sebastian Ene wrote:
> > Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> > arguments checking when the hypervisor acts as a relayer between the
> > host and Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 95 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 712811e89435..bd50ddc5b61c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -74,6 +74,21 @@ static u32 hyp_ffa_version;
> >  static bool has_version_negotiated;
> >  static hyp_spinlock_t version_lock;
> >  
> > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > +{
> > +	DECLARE_REG(u32, func_id, ctxt, 0);
> > +	int reg, end_reg = 7;
> > +
> > +	if (FFA_MINOR_VERSION(hyp_ffa_version) >= 2)
> > +		end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> 
> This looks like an accident waiting to happen if we don't check the major
> number as well.
> 
> I think you should just check:
> 
> 	if (hyp_ffa_version >= FFA_VERSION_1_2)
> 
> instead.
> 
> You should also add a comment.

We restrict hyp_ffa_version major to 1.0 here
https://elixir.bootlin.com/linux/v7.1.1/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L962
but since this is an easy fix I will include it.

> 
> Will

Sebastian
