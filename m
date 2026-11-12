Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489716;
	b=sk1ckTOjPLvagEPg5E0P6lINaNUVluTYvLlMK90QuzN2K6LpUjr0G9fTO5xy8NCPgC7m
	 tMlz27SZty2Pin12VDH1slazsSkBUcakL56Dkwi5/CBTYVwbzIJiJfnYr/G8O0VAwxnc8
	 qAw5s6Ul3ZXBC1fkivNGNVidHeHOpj6Ug6evyXsv+I2GOwwZrNuMideFR9h0eq+sx9VZb
	 /xu0VcxcL7+Fkb0NE3buBP8zkOtVREwiCdloJGOqZIbtOWMpJdispW8Ds5CaXDkUylH9C
	 wbsbY7eNcrmYbeMDRXekTv5hALfeZqDEOZS/f/7TIhb178SrkuNuj41qkdkyFSCLDsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=b99RC4xUVHz5+r54XJPAJ+7aAz26Esc5EYF+ctOn57U=;
	b=Zeb4Z7FACPbKJqgj6QDZd/Usc/8IXF35ZnxqmHYuaRlLHG2OxbszlBidhZBoiBNj78fF
	 zvAV7BInwkj+HcfKq1Q3yrS6HXqKjI/DZztbx3Fdh6nXBmGQI3Q0laFcq3Kg87UjV2OYv
	 OLsDgMKaB/xFCypMfbfyaU+4QD9hgZQlBoPlKymwZ2zJF9CM+RK/sDHybivA687CvuVhT
	 XJdIl2emaMcy6lpqKBgLCdZ5wNlhQKw07ulsKBPhXimuu5vlaWYMaowAiFjSGErfhCz8w
	 zDjgTvitgobIr59emUnKls9vvwl84NFQw05ITfEJPkVvW0naD6QgfgznLMQQAqp246w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SOpVnzKa;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3977606A31C
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 13:21:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3977606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SOpVnzKa
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so10094115e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 05:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794489714; x=1795094514; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b99RC4xUVHz5+r54XJPAJ+7aAz26Esc5EYF+ctOn57U=;
        b=SOpVnzKaSMPLWivaH8K10/tz33Tl8/L6W8EL+eW8QYCHdYHlDOwhkn30J240FvxSCR
         gpSg7io0m8ZIEdFZifGO2TjqTrrz9Yv5AeFVAODOcOSHfwT1hOUwp2oEtU9DB/8q1YNs
         I/eMWP1jo7229wtnRorAQ/jCBkmSDIi7IF4wPLTABJQ7IbvADcBYuNDrIgpEVXhFVeXx
         1wuV3KF/3SDw5+e7mYtnBEzAbAGINYqCuJKnUO7lwhomgiGfcDtEwCANygwVCsYcZugh
         EtFcE2kri0k2WGm65OG/8wKTRobzhnX3/+y5s0K2Z3qcu5QITgcXUTbMSL1CzFYYrcxg
         Yd4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489714; x=1795094514;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=b99RC4xUVHz5+r54XJPAJ+7aAz26Esc5EYF+ctOn57U=;
        b=g9bYQvpu+BVv7XrechrP+NUY0ULHW/d45ZWcF7CQduBD/PBRX/Kakd3wNzV3Lbn+xA
         kxMruVABkbajHqNAXYbwxlDy+/eVcxNr1C1FvmxlZkn4FTxGGf2GyApHG/Qai/+5lYyB
         TQ3nTffh7IbxZqQ0CcqVBRB+3R8hCnd3AO2oUK4lZsyQ2Nj7GQ/1PnU/4C8NUKpQUmAv
         bUNqwVU2g8mqH7y5snZOgNjWVR5uHPJdFPGvHQggXFpzAJ699Qy9dIVJvWCNU/bKAcJB
         re2lL2GeKzgNHEfJC0OcExmqF+CnzwNI6IQf4B41KaROi228MiRnqaFrp0LfmBIgzl6v
         YRyg==
X-Gm-Message-State: APuU4Z+T9zQcC23m1mUqI1Wxmrqt2+Jbx3c/CIBVP5kVBF8VamNykSwy
	lzRvD4/MGsgmgHMoIYpPgEfx+NVUes3Xi/CY0trSw9BTlxEhv9hCM5EfV5p3cq/sDw==
X-Gm-Gg: AYBFou2SuLB1z76pGAvPem0wHwadszIGYa8Mb9zT8BNQbQ3ZSCejHt+xWsZbbSJ0roJ
	k78bfay6yEXk6ih4iD/m1UId2hSnm8BN+Vtf5u2rMIAI8fXAHTWdn3PSWDrDVIm4CuJ8nx/civV
	3ZNmMUuoSeZzR+yQC/j4a0cBfXxhZOEtyLR+bq1mf8WtgpjxfVnypB0Hlx0/+VO/NNr3yK0xu0f
	YaKjBwVxo/es1L5TTEnVS10y7qlO9WwP9zXJnpj+0DrZ3KSd3l52UPMBcP0z9+mNMV0Owf6rocN
	u1F+jaOMoxmj7paReC4eBE+aMEfwE3axm/GtPUyp9gCjeeu3Jqv5ENbS7rug2mBx32Rj84gvOrn
	JlgLnkGmY33j4NytsrM+xsP7lQRcY8DNUq5IeU9SqE+JoPZzQ8KsuyITAwfdulb1LfXRjPcSoGu
	OiRhHRznKfE8RPLic4R04BnYkq41mXGidKEOhPI1RPIqPH23L7n7FDwuH5VjHdDdxjzSEt+vVpA
	GaR1is+ioLM92VSyFtyof0eQJVX7WVNdKzK2lKbMk/sVwZWSEpdxghbxGKr46wL1c9vhhyP0srn
	1L05tIcDYhWJi6anWkmtV1Mh/Lt5aOH4FOP51/sF85pyLFqzK/S9a7fUy5TCa4Y7jw==
X-Received: by 2002:a05:600c:37c8:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4bb4e28d48emr55762105e9.13.1794489713607;
        Thu, 12 Nov 2026 05:21:53 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm69714915e9.4.2026.11.12.05.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:21:53 -0800 (PST)
Date: Thu, 12 Nov 2026 13:21:49 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 22/23] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest
 to host sharing
Message-ID: <avW9bSKHM7_asKwN@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-23-vdonnefort@google.com>
 <sashiko-outbox-194183@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-194183@kernel.org>

On Mon, Nov 02, 2026 at 09:10:24PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM: arm64: unwanted block split and latent panic in pkvm_memunshare_call()
> --
> 
> commit 8b44fbe0de868cf9681f0eef63a65d11368c1c9d
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
> 
> This commit raises a PKVM_HYP_REQ_SPLIT hypervisor request and rewinds
> ELR_EL2 when a guest MEM_SHARE or MEM_UNSHARE hypercall encounters a huge
> stage-2 block mapping (-E2BIG) so that the host can split the block and
> replay the hypercall.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index d92f4da1c1807..6c126fcc3831b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> 
> [ ... ]
> 
> > @@ -1197,17 +1218,29 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
> >  	return false;
> >  }
> >  
> > -static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
> > +static bool pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
> >  {
> >  	struct pkvm_hyp_vcpu *hyp_vcpu;
> >  	u64 ipa = smccc_get_arg1(vcpu);
> > +	u64 gfn = hyp_phys_to_pfn(ipa);
> >  
> >  	if (!PAGE_ALIGNED(ipa))
> > -		return;
> > +		goto out_guest;
> >  
> >  	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
> > -	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
> > +	switch (__pkvm_guest_unshare_host(hyp_vcpu, gfn, 1)) {
> > +	case 0:
> >  		ret[0] = SMCCC_RET_SUCCESS;
> > +		goto out_guest;
> > +	case -E2BIG:
> > +		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
> > +		goto out_host;
> > +	}
> 
> [Severity: Medium]
> Should pkvm_memunshare_call() request a block split when
> __pkvm_guest_unshare_host() returns -E2BIG?
> 
> In arch/arm64/kvm/hyp/nvhe/mem_protect.c, __pkvm_guest_unshare_host() calls
> get_valid_guest_pte() before checking whether the page state is
> PKVM_PAGE_SHARED_OWNED:
> 
> arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_guest_unshare_host() {
> 	...
> 	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
> 	if (ret)
> 		goto unlock;
> 
> 	ret = -EPERM;
> 	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_SHARED_OWNED)
> 		goto unlock;
> 	...
> }
> 
> If a protected guest issues ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID on
> an IPA backed by an unshared (PKVM_PAGE_OWNED) PMD block mapping,
> get_valid_guest_pte() sees size == PAGE_SIZE against the level-2 block leaf
> and immediately returns -E2BIG.
> 
> With this change, pkvm_memunshare_call() catches -E2BIG and exits to the
> host via pkvm_request_split() to shatter the unshared 2MB block in both
> guest and host stage-2 page tables (and split its pkvm_mapping into 512
> entries), only for the replayed MEM_UNSHARE hypercall to fail the
> PKVM_PAGE_SHARED_OWNED check with -EPERM.

That would mean a bad behaving guest and it isn't a security issue...

> 
> Furthermore, if a PMD block were ever shared with the host in the future as
> mentioned in the commit message, __pkvm_guest_share_host() ->
> __host_set_page_state_range() installs a valid PKVM_HOST_MEM_PROT entry in
> host_mmu.pgt (replacing the invalid donation metadata PTE). If
> pkvm_memunshare_call() then triggers PKVM_HYP_REQ_SPLIT on that shared
> block, the host split path calls:
> 
>   __pkvm_host_split_guest()
>     -> host_stage2_split_gfn_meta()
>       -> host_stage2_decode_gfn_meta()
> 
> which hits WARN_ON(kvm_pte_valid(pte)) and panics EL2:
> 
> arch/arm64/kvm/hyp/nvhe/mem_protect.c:host_stage2_decode_gfn_meta() {
> 	...
> 	if (WARN_ON(kvm_pte_valid(pte)))
> 		return -EINVAL;
> 	...
> }
> 
> Would it be better not to request PKVM_HYP_REQ_SPLIT in
> pkvm_memunshare_call() while MEM_SHARE is single-page only (or check the
> guest PTE state before returning -E2BIG)?

... but indeed let's not make this code more complicated than it already is. I
can drop that.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261102204628.401871-1-vdonnefort@google.com?part=22

-- 
Vincent
