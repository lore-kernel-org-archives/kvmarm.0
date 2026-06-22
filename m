Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9705739937C
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127359; cv=none; b=MVXoYaOKpoigjOSINmFFHO1IuL4uiaS6CHzkACn3FGDWDKWSncgvevqpFywGDbdpWqp7BZriQL/IDQHxzKLvUJgrE2rxn3k64JOogT/8mJQiyTd4uWYZOr9FF5mssiChz1WbB/GQbEXwgOjzloFoWovwoz0uSFLcs7t50RaIQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127359; c=relaxed/simple;
	bh=70B5mhzskHceq9SpN0r29f++IYglrvBZ5GQWolH6+k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tl2DVqbXgNNtFaReaAR+rkar8UGDe19ZfciJNsHCHEN9gbvBOAsQOob4PKAEDaP93dRM9miCilHP7wIuJScz4M72M+L4A+z/ZOImDfPwWR+gOrdrg1JKXWU69lXsw50s2s5nQ2YeX1gatjbN1MNDpNOKoApvlqo28j92IQ7IMbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z3TVBYCq; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z3TVBYCq"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4924c5fb51dso43355e9.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 04:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782127356; x=1782732156; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S1yY6fW7A2By32TyWMvRTUIRlB5g4qNh9tuneOqU99E=;
        b=Z3TVBYCqcJJzkMA8VfJsuCUQRuvTysRg/v1dtgprpC7khcFKY6XVQgNJwFyOQ+tIbf
         o3Wv5M6pseKcvEuFg6yA6VigYMJhdlg1XoN/FlDGEJAcVm30JMUtbRocsd66uXQxbzy7
         tknWX3RN14ysqnCecGfM48oi9rIwPScCuBSKxX1d9zkmMmty527+ryrP68hQ4AmSg+cX
         JIVhyFSgxnZCuut6Hf61AkdlZlusVwJapYrz9qOHB+jkb12r/pTw7iRE+2cXno0W5THp
         +o/pAwYBLVcVWeEYXoSf+m0IT8bUy+8xQoDwT+Z66JFV4yjd9UIzn8f82klQuBGZlVTR
         NR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782127356; x=1782732156;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1yY6fW7A2By32TyWMvRTUIRlB5g4qNh9tuneOqU99E=;
        b=UcsQCT9WR7liHYtMineAYvY8P6Mca3qcfWQaRGd2MDW8gbVi7maIdEJPTUi5xznvUI
         MLAxsFuttKQbqDCF3foPsh2HMjUfcDAGxPLag1D0EUm/rT1Fdb28F9eVXFkKqoAnuMjY
         57og6NGTRZ7u2rm+qE5OwpMNNuTbPRY75l11cHI/lN0xNFVGlMA74EKn97Mg4FTe9EJl
         Id9FdOup+Ijm27gz4E5Dzu9SmxZBvkVeXHAC1tK6giZCRsBo9+8WNL+MCCPhS95pmEpA
         yr/f9+S1OQj/9pfMBDyqPrHEak/9k5c9erR2HNDQKqzQfPFPzhNoRWr/AeJaVQeJ5QIz
         BBzw==
X-Forwarded-Encrypted: i=1; AFNElJ/4O6hMQFq8NmqL/YN1q+oKhc9FW7yu6SnDnY4/MoNDyHYbpGm+LRt1aKhjFFUybtjJvo90jNI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcGojVE/41Bp27N2hA/YQjowP1Ny1UGdVLekTVDOonK8YJ36pF
	2BvtEv4Cj3JQvyOjPLIv5OAZBNQMVMwsZiZiZRL0SYfRfMoWnDoQFT020+z009OLfg==
X-Gm-Gg: AfdE7cmO6gaP81HE78zgB/L1STOUay48TzhETeh+un8cLk3KqVKvCHCDQpQcPVmC+jv
	jSm6x3KFGTBDCG2ieA5V3vFyjU5KwlOMOEtOZ1QATQbgris+/W95jfX+myKKxY3FJv7BLAOdbuY
	JF0E5gAkWglM7bsAX43v+ft1tqHy+Li5ud2wTtrLX+/zlbN/S4T9X12nKzDP2py7pD8fzPRzmfJ
	ygW7GE5CIuctfV4iew+7nUmgUb4YNvjA27XZUw+zy/ZIGf3jX+jy+a2OHJN5mIOyAe8HFPysBNX
	YacSNPyWK43CMMQ/C4TrbJO2xT26fvkpUsi20aYCEoE0yYzHJz7VMr1noLzKVRVeQD/Cun/wvMA
	LsPHLKubWRr/i/fsxmgh38vpUSBCqdaXPZf/aQGBcrfUUQcecfa3207VlnAzil+tuThDrt5lJmP
	Mf7kd9RmyBqdWnFD7LLy60frrYfV5OgtBCGsvLgg9pimruVYUm0R9RNjfO8t1do606OEG1YA==
X-Received: by 2002:a05:600c:2254:b0:48a:5618:b4d4 with SMTP id 5b1f17b1804b1-49241527581mr2615965e9.1.1782127355433;
        Mon, 22 Jun 2026 04:22:35 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c579dfsm25252029f8f.31.2026.06.22.04.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 04:22:34 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:22:31 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 5/7] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <ajka9wZXKlYWlYDA@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-6-sebastianene@google.com>
 <ajQjOH9Cjk1UqdT-@google.com>
 <ajj_DkqiDwiF8imZ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajj_DkqiDwiF8imZ@google.com>

On Mon, Jun 22, 2026 at 09:23:26AM +0000, Sebastian Ene wrote:
> On Thu, Jun 18, 2026 at 05:56:24PM +0100, Vincent Donnefort wrote:
> > On Wed, Jun 17, 2026 at 02:51:28PM +0000, Sebastian Ene wrote:
> > > Prevent the pKVM hypervisor from making assumptions that the
> > > endpoint memory access descriptor (EMAD) comes right after the
> > > FF-A memory region header.
> > > Prior to FF-A version 1.1 the header of the memory region
> > > didn't contain an offset to the endpoint memory access descriptor.
> > > The layout of a memory transaction looks like this from 1.1 onward:
> > > Type | Field name | Offset
> > > [ Header | ffa_mem_region  | 0
> > >   EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
> > > ]
> > > Verify that the offset to the first endpoint memory access descriptor
> > > is within the mailbox buffer bounds.
> > > 
> > > Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
> > > should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.
> > > 
> > > Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 29 +++++++++++++++++++++--------
> > >  1 file changed, 21 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 2d211661952e..1a2abd0154c6 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -476,11 +476,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> > >  	DECLARE_REG(u32, fraglen, ctxt, 2);
> > >  	DECLARE_REG(u64, addr_mbz, ctxt, 3);
> > >  	DECLARE_REG(u32, npages_mbz, ctxt, 4);
> > > +	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
> > >  	struct ffa_mem_region_attributes *ep_mem_access;
> > >  	struct ffa_composite_mem_region *reg;
> > >  	struct ffa_mem_region *buf;
> > > -	u32 offset, nr_ranges, checked_offset;
> > >  	int ret = 0;
> > > +	size_t mem_region_len = !FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) ?
> > > +		offsetof(struct ffa_mem_region, ep_mem_offset) :
> > > +		sizeof(struct ffa_mem_region);


While talking with Vincent about this change, we agreed that it would be
easier to introduce a helper that will get the size of the struct
ffa_mem_region which is different based on the ff-a version.

This would hopefully increase the readability of this. The description
of the struct ffa_mem_region can be found in (Table 5.19: Lend, donate or
share memory transaction descriptor) from DEN0077A.

I will spin a new version to address this and collect the review tags.

> > >  
> > >  	if (addr_mbz || npages_mbz || fraglen > len ||
> > >  	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > > @@ -488,8 +491,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> > >  		goto out;
> > >  	}
> > >  
> > > -	if (fraglen < sizeof(struct ffa_mem_region) +
> > > -		      sizeof(struct ffa_mem_region_attributes)) {
> > > +	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {
> > 
> > Can't we replace mem_region_len with ffa_mem_desc_offset()? that pretty much
> > looks like the same thing.
> > 
> 
> We can't because `ffa_mem_desc_offset` dereferences struct
> ffa_mem_region to extract ep_mem_offset as per the latest updates. 
> 
> > 
> > >  		ret = FFA_RET_INVALID_PARAMETERS;
> > >  		goto out;
> > >  	}
> > > @@ -508,8 +510,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> > >  	buf = hyp_buffers.tx;
> > >  	memcpy(buf, host_buffers.tx, fraglen);
> > >  
> > > -	ep_mem_access = (void *)buf +
> > > -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > > +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > > +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> > 
> > This check looks like ffa_mem_desc_offset() with count to 1.
> > 
> >
> > > +		ret = FFA_RET_INVALID_PARAMETERS;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	ep_mem_access = (void *)buf + em_mem_access_off;
> > >  	offset = ep_mem_access->composite_off;
> > >  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
> > >  		ret = FFA_RET_INVALID_PARAMETERS;
> > > @@ -574,9 +581,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> > >  	DECLARE_REG(u32, handle_lo, ctxt, 1);
> > >  	DECLARE_REG(u32, handle_hi, ctxt, 2);
> > >  	DECLARE_REG(u32, flags, ctxt, 3);
> > > +	u32 offset, len, fraglen, fragoff, em_mem_access_off;
> > >  	struct ffa_mem_region_attributes *ep_mem_access;
> > >  	struct ffa_composite_mem_region *reg;
> > > -	u32 offset, len, fraglen, fragoff;
> > >  	struct ffa_mem_region *buf;
> > >  	int ret = 0;
> > >  	u64 handle;
> > > @@ -599,8 +606,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> > >  	len = res->a1;
> > >  	fraglen = res->a2;
> > >  
> > > -	ep_mem_access = (void *)buf +
> > > -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > > +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > > +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> > 
> > ditto. ffa_mem_desc_offset()
> > 
> > > +		ret = FFA_RET_INVALID_PARAMETERS;
> > > +		ffa_rx_release(res);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	ep_mem_access = (void *)buf + em_mem_access_off;
> > >  	offset = ep_mem_access->composite_off;
> > >  	/*
> > >  	 * We can trust the SPMD to get this right, but let's at least
> > > -- 
> > > 2.54.0.1136.gdb2ca164c4-goog
> > > 
> 
> Thanks,
> Sebastian
