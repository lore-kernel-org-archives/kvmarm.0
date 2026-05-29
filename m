Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E3E3B2FCC
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 08:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041777; cv=none; b=JkT/6PwIiA5tyL81QM0MgRwUcGu91PbYP2b2v+lcCmz3eeMvTUqdaxQb4mQFJX7TUzQ7V6+SMe5vEq7Dqy4TFq00BIne84ey2y2vH/grIlJF6FJAyI4QGlCYpVvubfJODGtUlTnmm4hrr+3HjKBBlWAgPz5iJOPN5O8IYgF1hRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041777; c=relaxed/simple;
	bh=/1pir3LF79JOz5u0/10ODgRwehHuX74Gb0sQ5Udr+nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBQFNnmYPnPbQEk7hTgzd0AG795RAt/8C4OftYsadmczoY1hog8uvglCqP5u4L+4l+KTlG8ny+cCZNHgrfElwQcU0mb/b+kT+DI2bqFzTGr0o35ToObZ20lK6Nonzptelf+uuSX+QCi1daz5TB82BDPvb3SOew0hfHSe/oGo4D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtTcec9A; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtTcec9A"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso118229455e9.2
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 01:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780041773; x=1780646573; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EEpP20QLYbUafDoJ1/D4YHhW2s2jVmPtJASihmV02YE=;
        b=MtTcec9Ak4I+3lR/+LHlT53a3jcVfOSObXUyiL4Cw5tahGAlBYJ1zcow8hAlsbaA8D
         Kj8SJrs0UrnmDyg7I9jyxsRSSZVxLbvAWGHph80MhrHXsBU8zFP4EAvrFdCQqy9qGDos
         giHnvs4ZueosQp8Ya2qnh/MnIA+qn6nkVQGWSO9OWOfNt0+8Zfdxz+NQSkLKUuAnHgXl
         6D6JzJl/bxfDc/CmtFd/OUbWLQvEzqao99PL8xfOWpP2XhZfD9huuIqfsqrzHQxShkvT
         cDgdc3pZdFMOxgvyhPrY7TL2ZAG1BbJs4DZzg3Y4L4mKXCrVJY2vGFym+kF55BJ1Vy8H
         WnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780041773; x=1780646573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EEpP20QLYbUafDoJ1/D4YHhW2s2jVmPtJASihmV02YE=;
        b=JMfMzg0u5qeXWNt42yFvrZimg+HacVvep4EV8zql1c70f6FFU96iDvotx+nMQ0FiUG
         Vx8qdjYzcnnYCB9SX+E2rIMyNaRm/tJJXxK1bvu0f0vSkffvnlTR0UdnvnpAH8oz7C5v
         itR59ColHiYDL8tL8fjLUuKo89CtDK3quYBhPbgFx49qxAh/nPLAGOBJUzbSSXQAsd4P
         ua1gbchIXKuNON9msr9nZV54HpqsRHEIcnlMBNJc6In5vw2QX6byL+NsHMu2chfQccPo
         ZbPEBqYePUh9L/XqwGrdufYPqK/vL0tN68RGBSpz/mBMfA7uSbMjaKPGr2u0iZmfR5R6
         Sqgg==
X-Forwarded-Encrypted: i=1; AFNElJ+sSFqLSIEZHymDGOYRHR9/DqZsV4TwiVjEjVi/1Nv0s4tCgfP/JBrvPX82G0Qq1zAmYkeEboA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm1uRzKwZyHrOeJmNTF2Tg5FYSxKRVcH1Yf1/yVvrg0YWR+lbJ
	CpK9Bq962DcO/iSV0nyDBF4FpGPmcdKd7DBQNTeK7AHJPeUHrtjaypr9PUA3WNTipw==
X-Gm-Gg: Acq92OGNyRQzoJrSe0ZjkY5bssIvmZNuu3QGfPsSE7rGoxumRBAShR9GWyxCR7KW7e3
	CWhWjyb238SGcskpFs9SY5xMhKemtVsCRHMJxZIla/ASBZGhkuK5j6lakOxX7VO0QxJAZgK0VaY
	mFEFPyGXxsWFS/asBaT7kW5eZ+igP03V3bzQpu4hPzCO3Fw8xj0FpEkb6YhFZrCHJgYMsBEeGW0
	eYSCkv065kP3PeHnDU7udFCxBjF8O7eSb3WajXsFpdDCcSqX3Vh843SJLI7prpRHcVDm+pAseYA
	+3YDsEChOGl5RPjZB5/+rrVo/XoBunTMlpStKjFF3xDX/MiysfeSAXx8I+gU4eF5zt+Qvhs0su8
	SuDcYU+kynrekm88+dv4w89hoOQ2UQJGR+NC6Do75+CGk+ux4z00Zh03kgC6zs3LFVHIIYsTPuK
	Sv2LV0iE0wjTwZFlVY9JhkRCbFliMdOnZusN0VKe0M1WFFzE+uy1j2L3EWlxhJooK4wsSJYq5a/
	RRMsw==
X-Received: by 2002:a05:600c:c16b:b0:48a:563c:c8c0 with SMTP id 5b1f17b1804b1-4909d2e8ff7mr29149015e9.7.1780041772883;
        Fri, 29 May 2026 01:02:52 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c12b6ddsm8900445e9.33.2026.05.29.01.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 01:02:51 -0700 (PDT)
Date: Fri, 29 May 2026 09:02:45 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
Message-ID: <ahlIJQU-1b0mayPP@google.com>
References: <20260529074341.2271950-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529074341.2271950-1-tabba@google.com>

On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> Hi folks,
> 
> Yet another bug I found while testing Sashiko locally with fixes to
> review-prompts.
> 
> share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> maintain a host-side RB-tree mirroring the set of pages shared with
> EL2. Both invoke a hypercall that can fail (page-state mismatch,
> EL2 refcount still held), but neither cleans up on failure:
> 
> - share_pfn_hyp() inserts the tracking node before the hypercall
>   and leaves it in the tree on failure, leaking the allocation and
>   presenting a phantom share to a later unshare.
> 
> - unshare_pfn_hyp() erases the tracking node before the hypercall;
>   on failure the host loses its record while EL2 still owns the
>   share, breaking later operations on the same pfn.
> 
> Severity is low (no isolation impact) and the failure paths are rare
> in practice, but the desync is real. Both patches are independent and
> apply cleanly to current mainline. In other words, this can wait for
> 7.2.


I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
So I haven't sent a v2.

> 
> Cheers,
> /fuad
> 
> Fuad Tabba (2):
>   KVM: arm64: Free hyp-share tracking node when share hypercall fails
>   KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure
> 
>  arch/arm64/kvm/mmu.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> -- 
> 2.54.0.929.g9b7fa37559-goog
> 
