Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B09346AF1
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049204; cv=none; b=KMl84eCpilOT1ifxSa3wSI+QWgxcuJAY7f3jKPgD1F4/+3pRaiyoCzYgNavY7HnaTIIzj8WVNrJtlkzgXQqrmrlXooZJsHE4u/nIaVP53rUuC/29MQG8rBfDgm6FESemarW24pVW9p4hZcLAEv6Ui4CeWtI/8XEmYzxD5e7TpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049204; c=relaxed/simple;
	bh=mM6ORMwsn3ciSj/I+BINnrSvpkley7x+ARd/aZm1SEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oq5bXTSKcr81cgjYh61VaUdQVDRou/8LmUCfV4Rq1XfGMHXrDrwiv9wrNjkSEmjmhjVeSfDLxvW9MjfL+c7WsSidCf21YGUvP0IMJfFruotammuryITBdOcP/e+kMcZT2/G5ysBL57t4Ipx8sjWI3QqWt8MgwEnU61LIqDtAinA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=szgKrdiP; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="szgKrdiP"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso74135515e9.3
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 03:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780049201; x=1780654001; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lWH+duc/f4ADBksdBfKd+ApBGYaYEoTepCNzP0jT5tc=;
        b=szgKrdiPxUCIWfUu/P5ipBd/MtrsK1kmuZo9QhyDu9a3kpjdR/OxFjr56BDNdljk1J
         yU2LE493C22TG49ZVDT6DssVp/nLPeL4mAEy9xiSn6RUTbe06rUfMYJoqN/36r72Nw+n
         aPCRyApya5LXiHznJg86f60vgqoULprWUALoN/cQaQ+yTIxqw6Pm10AWhvvbmBYH2QV7
         LTp492Rxwi+qPki0X4yLsvdcDZYHfly0LeE8PbjxNxg+pKZF+ANygiBtIizuqycxhV9J
         gnI5K9Q16P1IwOPiNeK1abmK9fWrGssTjakmP/YZI/h3CHyawv7yzY9ZL6jdLBUG4rf0
         G4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780049201; x=1780654001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lWH+duc/f4ADBksdBfKd+ApBGYaYEoTepCNzP0jT5tc=;
        b=SohVHNLh3IQzGilUlwfAsbhhzL3GWHcDNinfLsuVYWGdy88pc7C/mmEjgIdtJVS3NP
         2BQ1RiEzFlbbuPaHmbiJfUewHxtNfIcwGJBGC42SLLr1iKZLNENPuS5qigXOv99caXus
         NjphW97GZAgZctSVkp726/Zxi8FHjQhGlUaDEOh5F+sTehDH1PLZUNtr3zLfsBcnult7
         dAn6dWzgq2PlLu05Pf8nKMAeCXxzyAleAd0epTNGax6XkgYv6b1qIiYvVuqMAIPeEa0k
         A9HEfXhgONW765TQnhZbm/B0t8lN2BIFq5j0L1/Rfh4SISkdm5JMecNEU31wUm+6GEPx
         a6Aw==
X-Forwarded-Encrypted: i=1; AFNElJ9lcS2JrYPTcK7paqMTdKpQJ0H3cmaCAbUTsM23ebc1uzkCOL+ld/vgo7+MwMjG5/5zb+uU04I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhfC9iaoDBlTy+pYuFU5ngTwqXFd3boKERofj6dX/aLLWqO+6v
	M9ER0vWoahDV+nPDFwAwrl7nvnkV5GCiqltLXgZqoaYL3xlR93AflP0NTcbTDGElag==
X-Gm-Gg: Acq92OGRkI1wtVkWmHZZPk0D0sccmSoj54vTplOUrasBSIvb3/98oHojFMtZznUAb8R
	blbrUycmZwgXH1rfmxFXGmyApy6etHD9HcikPtynkO4N/AAykMpG8i/2lVyhT50VNwSJo+zXODi
	I+8ompXOwWLxsVWVM9XcoRQIsDkpLJbqV4tte9eopq40xurlDGT27XjOciCaxdyqwNXPJLMQbhx
	Y/XbEcY87pRWt5NoRQpnAmd/Vh52ZCOVBWVv+Mb+ePWpJh7EyvZUfOaWocxJPjZ29ev9iSVOOi4
	tE8Amqh7qkfNPDl7WX0gA0EsvgHjIL+lXzJHkgP6s85Nhyk6AP+zQXtQX8Em0y/mhrvtj+8M/Z1
	UZCTWL/2g2kpmj6rObwuKIo/Z8uNRlerJ2gKGjoISMrc+hiFKsOrreLIbR0X8N1PwmoCXYzdExd
	iG7tpKDQhbucDxF+bY1z1o284qRh6LtNQSjPKgR1a/nh1mYJigZ6zduxfXRgGmeWcw1vtHt87vZ
	NM/Gw==
X-Received: by 2002:a05:600c:2e49:b0:490:5191:6e26 with SMTP id 5b1f17b1804b1-4909c0acb54mr23069455e9.18.1780049199966;
        Fri, 29 May 2026 03:06:39 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c09adedsm11457715e9.2.2026.05.29.03.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 03:06:39 -0700 (PDT)
Date: Fri, 29 May 2026 11:06:33 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
Message-ID: <ahllKRPojfwqw4yE@google.com>
References: <20260529074341.2271950-1-tabba@google.com>
 <ahlIJQU-1b0mayPP@google.com>
 <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com>
 <86a4tivdh3.wl-maz@kernel.org>
 <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>
 <867bomva0r.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bomva0r.wl-maz@kernel.org>

On Fri, May 29, 2026 at 10:29:40AM +0100, Marc Zyngier wrote:
> On Fri, 29 May 2026 09:20:50 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> > 
> > On Fri, 29 May 2026 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 29 May 2026 09:05:35 +0100,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > >
> > > > > On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > > > > > Hi folks,
> > > > > >
> > > > > > Yet another bug I found while testing Sashiko locally with fixes to
> > > > > > review-prompts.
> > > > > >
> > > > > > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > > > > > maintain a host-side RB-tree mirroring the set of pages shared with
> > > > > > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > > > > > EL2 refcount still held), but neither cleans up on failure:
> > > > > >
> > > > > > - share_pfn_hyp() inserts the tracking node before the hypercall
> > > > > >   and leaves it in the tree on failure, leaking the allocation and
> > > > > >   presenting a phantom share to a later unshare.
> > > > > >
> > > > > > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> > > > > >   on failure the host loses its record while EL2 still owns the
> > > > > >   share, breaking later operations on the same pfn.
> > > > > >
> > > > > > Severity is low (no isolation impact) and the failure paths are rare
> > > > > > in practice, but the desync is real. Both patches are independent and
> > > > > > apply cleanly to current mainline. In other words, this can wait for
> > > > > > 7.2.
> > > > >
> > > > >
> > > > > I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> > > > > as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> > > > > So I haven't sent a v2.
> > > >
> > > > At the very least we need to add a comment, otherwise, people like me
> > > > and LLMs like Sashiko would stumble upon it.
> > > >
> > > > That said, this fix adds no real overhead, makes the code clearer, and
> > > > guards us against a future where that call might fail.
> > > > Self-documenting in essense.
> > > >
> > > > WDYT?
> > >
> > > If a hypercall really cannot fail, why does it have a return value?
> > 
> > Good point. If we know it cannot fail, how about just `void`?
> > 
> > That said, Vincen't exact words are: `very much unlikely`, not the
> > same as cannot fail :)
> > 
> > https://lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com/
> 
> I think the rules are simple:
> 
> - if something can fail, we need to handle the failure

Looking at kvm_share_hyp() it should then rollback the shared pages. I think
that is fine.

> 
> - if something should not fail and has the potential of compromising
>   the system, we should panic

Then kvm_unshare_hyp() being void, should BUG_ON(unshare_pfn_hyp(pfn));

> 
> - if something absolutely cannot fail, then there is nothing to handle
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
