Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3712FD1B5
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783523992; cv=none; b=Bc+QQW29SKMKcIVNvQVUVzZuHPQbG1oeGC8zuD+YOhxEgZ91HseC8XqrBg4WoFLus7Y6snZKtJNrXFDZ3r74axniv2cGICQP91I2kC5ElnrACv40J32aNr5bL7gQnBDENK9RZugWHoDpa81n844S70PbN8xLxGeq2J7AgaAqwb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783523992; c=relaxed/simple;
	bh=Ql7KTdiruqwIMVFE4sjNG6lU7UucIdeojr9NCI04wLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvgT4UkbohQOpCN4XOhmWktPp5aDpThw+kyABf28uB4BpSXBTUSP/Ow/gMhnAxZa85R36hR5kLg/KOhCfc0HTEqvIabN8MzTDKTT7jtc3ociM164oPMh3Tm5dfOm/4dvYdFAvFEsfSYW5X0mpTbxoE1vymTUL/HGLqToXQffC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K602iJt8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K602iJt8"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so5806175e9.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783523989; x=1784128789; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DqR44mUfA9LKMBGDHZfmsXYR0vrldtmDsyb0BeR+gO0=;
        b=K602iJt8YKEJycKicUo7UvTMmN1BVPTwD8GvwSQODuFqx12hm2P9DQj1aazuD0ufSL
         tkLDUWhtZPVMpfQb6yCrf0uTejP+zSxd6T8AsT3cEerMqzoYLgrzRBtxvtZci+VIz0p0
         VrX8MLvaQaVCvlk+pS/5PimZTTH9MrU3KpOEth7iKJoAuNZDOyHfJjcz205cdJYTpIVM
         kTulrbVKQvYCW5xtuDghUNCsf4BELL5jhRhFQ686vzVchieSbTnDP8318P4BSKjSOzZq
         T6/weKmpo0PGtFYUzoUjNl5SYYJeLUWffGdEkgI4vMRI9zyU9Gs2sBtuqCgz5wkmCcg0
         vnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783523989; x=1784128789;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DqR44mUfA9LKMBGDHZfmsXYR0vrldtmDsyb0BeR+gO0=;
        b=a7tQtx+vflQjrAOqz4b9pHyrqaqVBSpSeeBcTdcyM0ivH2tcUc4WOMiaOHqFvJn41n
         YGafFWRyGK4Ou5Zug+cIOQG77D4GC2O70uQlJCAShE3ZFv6LoH7/m62uNbcIE71WAQ+U
         BBxTwTF7Upvx/vS0yuOTPONz8QTVZzptCFqfkToo9ufAPK7ee2fPdDj3BaKNhbFBEyhk
         3EU45t7qf6zS2mNheKrqYvhd36A/DZjF45obB5VKqHI6lMTsZDixRbb9qG6Tpd6+suR4
         gedf7XKZkG12GFY9dBSH1v6rlfqhIudtoGPBGzh/joZcLqwx5CvXkSXnHe/Uoz7WM6fG
         110A==
X-Gm-Message-State: AOJu0YxumxkCFWQekgJtWShWn8zbQEvfiaWdF5NfJ+yCC7P+ajWeUt3u
	B3LWOh2Gs29PghB4y2PPS+BTDJAD9XRwhTbSBx7ckC+xVODAFPGCh+OJbt1mAKB5JQ==
X-Gm-Gg: AfdE7cmC4oFvgvmFyjLo4LRhGfxlSen7X5e/whYeRas0lCPhVSk9+TYjeOlI19a/hZJ
	PKCZOZ23wDdE4T1qKhvZUnTSKWPvjApJpOo5GE3YdeJQi48Qbz9fTM5HJCwAefT55NRZhdv6Qx3
	JFHfhuzO4Z7Sec6tdXKHAGUgf2t/cVY3cACdDR31kIro80lOF3YBJE9RhcfUuAOQEiihgoyQ8Z6
	Bx37RIwEydIoJ1NckLuSvAhvf/j3qDsdsrlY1bbdr5JYmmJkuZraJl6f1zgJlN1v2ooIuM9lIZv
	lJWiAlUara0WFjFDSkuB98rDjU9aGsqQ6404EkIXe/I7SkgbvXcyuAixvEcKzKuz8WZm/+pC4nU
	ANoL+37ynmGwZZFVNKvnYgZJuoe+Hlon8a/IZY2sdqVs5thhZXfzNCG1L1CK7tjwsqymVbZ9Unw
	X92QeVMdnvI8h1USIhnU1z1+gZLIFwDfmTi899WcpuoZKJB2ZtXdc=
X-Received: by 2002:a05:600d:6450:20b0:493:b2c1:b2f9 with SMTP id 5b1f17b1804b1-493e6898c5bmr25566325e9.8.1783523988694;
        Wed, 08 Jul 2026 08:19:48 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e736sm47041125f8f.7.2026.07.08.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 08:19:47 -0700 (PDT)
Date: Wed, 8 Jul 2026 16:19:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix potential leak in
 hyp_trace_buffer_alloc_bpages_backing
Message-ID: <ak5qjzhwSooBcjsZ@google.com>
References: <20260707165029.3410701-1-vdonnefort@google.com>
 <20260707170245.3967E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260707170245.3967E1F000E9@smtp.kernel.org>

On Tue, Jul 07, 2026 at 05:02:44PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] trace_remote_alloc_buffer leaks page allocations on the error path if a per-CPU ring buffer allocation fails.
> --
> 
> --- Patch [1]: [PATCH] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing ---
> commit 21f10293a05c7439f7a1d1be691e92ef2d36331a
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
> 
> In the very unlikely event of a failure in __map_hyp, the allocated
> backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
> this by freeing the pages on error.
> 
> Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2411b4c32932c..5fbbfd40376f7 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
> >  	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
> >  	size_t backing_size;
> >  	void *start;
> > +	int ret;
> >  
> >  	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
> >  				  num_possible_cpus());
> > @@ -171,7 +172,11 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
> >  	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
> >  	trace_buffer->desc->bpages_backing_size = backing_size;
> >  
> > -	return __map_hyp(start, backing_size);
> > +	ret = __map_hyp(start, backing_size);
> > +	if (ret)
> > +		free_pages_exact(start, backing_size);
> > +
> > +	return ret;
> >  }
> 
> [Severity: High]
> This is a pre-existing issue, but since this patch fixes a memory leak in the 
> trace buffer allocation, I noticed a potential leak in a related error path.
> 
> In kernel/trace/trace_remote.c:trace_remote_alloc_buffer(), if an allocation
> fails, the code jumps to the err label:
> 
> 	rb_desc->meta_va = (unsigned long)__get_free_page(GFP_KERNEL);
> 	if (!rb_desc->meta_va)
> 		goto err;
> 
> 	for (id = 0; id < nr_pages; id++) {
> 		rb_desc->page_va[id] = (unsigned long)__get_free_page(GFP_KERNEL);
> 		if (!rb_desc->page_va[id])
> 			goto err;
> 
> 		rb_desc->nr_page_va++;
> 	}
> 	desc->nr_cpus++;
> 
> Because desc->nr_cpus is only incremented after all pages for the current CPU
> are allocated, any successfully allocated pages for the failing CPU are left
> out of the count.
> 
> When the error path calls trace_remote_free_buffer(), it iterates based on
> desc->nr_cpus:
> 
> 	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
> 		unsigned int id;
> 
> 		free_page(rb_desc->meta_va);
> 
> 		for (id = 0; id < rb_desc->nr_page_va; id++)
> 			free_page(rb_desc->page_va[id]);
> 	}
> 
> Does this skip the partially initialized ring buffer for the failing CPU and 
> leak its allocated pages?

https://lore.kernel.org/all/20260708133201.295072-1-vdonnefort@google.com/

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260707165029.3410701-1-vdonnefort@google.com?part=1
> 
