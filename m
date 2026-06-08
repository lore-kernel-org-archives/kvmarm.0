Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7093D75B1
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780930277; cv=none; b=nbUSe2iTI4KkbwjERpvPOmIBAIDTx3a3EGwlz4geqtpFqESKhdv7882njTPTIKO0use8mnbn/TJ9AEnhumjHH1iXsQbiNvobU8KC2VXzbbcXlNdvY7kBGHZlW9qvzlCgNdGEitAsHr7Bszcnx5uow80bH6ABeXi2niF0KtuOvtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780930277; c=relaxed/simple;
	bh=La7g/GyA5jGa6VE7XI8C/nWm5pFkkzQfJczImT5HajM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogdyc36p3HIEBETk9qtVUZwltQd/hi/DwHVbzXrwM0/0SEpPFCF2S8nDzWBVk2g1pz6MAQV4JvAxjrS7u/6SOvEUPmRNG3VQ1o2W4frN3ceCbzspGWxbFbpSIMfw15yzhaMprGcW3Q7SJ13Cs1hy34EWHtXDHgrOGry14j69i+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSOGkoX5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSOGkoX5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490bd64ca95so199555e9.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 07:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780930273; x=1781535073; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Rbn7wD4zfL1rg1LaDWefzl7m3050O9wzsCOn/zNYoU=;
        b=aSOGkoX5G6Jj78m1354Se/9wEy7K44tysj1XZF8UZYztNj/sOxO/SvEO7a10Fk0sbA
         Mbv15nIEP/TbDzzhfs2K0aXcz90IAfumJkbeHg/N1zQJCWqLBWT5TL9stfPCOguyvdZA
         7S5aPgpdelII0FH6aiB4rEYyJudwf1IW2R0KvvPtvw4Pxq1VayhXGMXsZmuwcxx5GP3r
         3/dMR8+Ak+Hn/DTaFwDQc3YHTwSWRf8Tnrk5kB9sC6D04p7qASsz/NnW0bh1+IdN/KAw
         nwuSUDEiz8MNHuo91llzxuVQ2O0zr14BFkFS+cnu/ghxxwJd4a0IupNhoOhhQG5uMLM8
         84mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780930273; x=1781535073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Rbn7wD4zfL1rg1LaDWefzl7m3050O9wzsCOn/zNYoU=;
        b=FyDP5wkp/VF99iHprnJztdWAFAdyz+8XnUn68FWhq3bBDIT9VwmebdeAjek5cZ0aUv
         pUnpz2yq/F/O+WmgHCJTdREx9lCM9vG7ZJpuC9h4SIclDq4LhJgyYa1gIYCId52/ahOn
         5+sZ+t/TmumyDsiocVbpXicXCl2WJlnqnu0Q0sDMVdpcXI60krTOUTyw/VSFYlAR59fH
         ozVRJ+llSP37XyH7qCbTXDo17pgNw0eD7djox8W62e55sg/Kg20tojITVLk82X5KMGKq
         ungvWVF0O2YETus04lo+pFsDlfIF0WVQk91pUi8AwEs+0Hy8zoJ29UEU7dDLGnxeWCSp
         i6xg==
X-Forwarded-Encrypted: i=1; AFNElJ/fh73hcTfKuodws7LG0w5RPQAehNY1p4R0XK/bO3llwQPFPDIAuPPS0Sy1AjIs0pIkHH4Ws9o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+2tjeRFxgYTdBnAJvancBcl8d5KdcT8RqNkqy3/kfeTsnmtLG
	VnAW7FqKt1aYSnfm2MD3g69d4QISNn8F4Im5QqAkzmCM+416qvjZvgd3iNyfSK8Ytg==
X-Gm-Gg: Acq92OGjGC+XBb43HaKaSPdU+mjdAagnswHNWtHHL4BHwbzSX+JaR95sEvkLsKCkVEj
	qwQIfM7YvUPY+Tj+z44WVoWYrZ2DuPB8byLBwpQXAiYoVzCh46zGKiv7FZtCNMHWTjaek75kgaV
	8hJWrrORbLJHgPzRINFNMo7TvnKigEt3FGZtm6pc/CDuRju/6ViH4IbPGY3jviOB5RDglzVb6HV
	sOg24dttNJO3zE2ByHo1/OojN6rhWVuwPZ6LCe4HyORR+Tfbvth7O6c3AImAAYljcOOKQjAhPAh
	CwHJTTDOQlw2efe7R/UBNpKEt0jA52uccZ1sBGZ2082SCEVgv97sGetRqwvZ0FLjv4ZB8X4NA6b
	LQYCsWX/Ky1S9TFeo81EjjzEDkCk9taiioIXbxRpxTEdWjNx741ftDHnJwk5GKSJUTnW0aWEYd8
	EyLH5fYuzrjWzCXaCatMg1xJr3JzJprc68doInvSnhiWrlfW+GlmKiM5FcmORY1gwByfIvyypa4
	S/RMAek
X-Received: by 2002:a05:600c:4711:b0:490:c2b6:de6d with SMTP id 5b1f17b1804b1-490c2c9d9e4mr5232255e9.14.1780930273097;
        Mon, 08 Jun 2026 07:51:13 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d40sm52211734f8f.26.2026.06.08.07.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:51:12 -0700 (PDT)
Date: Mon, 8 Jun 2026 14:51:08 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	oupton@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <aibW3HH-TyzSpeAu@google.com>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
 <af3fW468-f1KXCrC@google.com>
 <ahmxiFXXTupafbXw@willie-the-truck>
 <aibQHiYimPP1ylk3@google.com>
 <aibUXmzfDsVWcZjY@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibUXmzfDsVWcZjY@willie-the-truck>

On Mon, Jun 08, 2026 at 03:40:30PM +0100, Will Deacon wrote:
> Hey Seb,
> 
> On Mon, Jun 08, 2026 at 02:22:22PM +0000, Sebastian Ene wrote:
> > On Fri, May 29, 2026 at 04:32:24PM +0100, Will Deacon wrote:
> > > I'd probably structure it as a separate patch per call, tbh. That way,
> > > the commit message can talk about the specific fields that are reserved
> > > for a given call. See below.
> > > 
> > > > Refactor the handling logic in pKVM FF-A proxy to support checking for
> > > > SBZ/MBZ values. While at it, drop the do_ffa_mem_xfer macro and replace
> > > > it with two functions that make it clear that we re-write the
> > > > function-id with a 64-bit variant, to keep the same behavior as before.
> > > > Keep each handler in an array of structures together with a mask that
> > > > corresponds to the SBZ registers the spec expects.
> > > 
> > > Although I agree that we should be enforcing SBZ/MBZ paramaters (because
> > > we have no idea what they might do in future versions of the spec), I
> > > also think that doing this at the register level is too coarse.
> > > 
> > > For example, the VM ID parameter to FFA_NOTIFICATION_BITMAP_CREATE has bits
> > > 31:16 as MBZ. So I think we probably need to do the checking on a
> > > per-function basis, like Per is doing in his series:
> > > 
> > > https://lore.kernel.org/r/20260501-host-direct-messages-v6-0-3f4af727ed85@google.com
> > > 
> > 
> > For the newly added calls like FFA_NOTIFICATION_* we can do that in a
> > separate functions, but what about the other existing calls that have
> > MBZ registers ? that was the reason for the inline proposal in :
> > https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> > (to avoid duplicate checks).
> 
> For unused parameter registers that are SBZ, I think you could just add
> a helper, e.g.:
> 
> 	ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int reg);
> 
> which takes the index of the first unused register and then checks that
> all the registers from there to the last unused parameter register are
> zero. You can then just call that directly before you start parsing the
> SBZ/MBZ fields on the used parameter registers and there's no need for
> the table-based indirection in [1].

I see, will do that, thanks.

Sebastian

> 
> Will
> 
> [1] https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
