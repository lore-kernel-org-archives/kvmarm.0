Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C215746F
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 09:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780046510; cv=none; b=s9w3VRmJP8duJa7Q9hdgZvyY2pe7WAKDXYLEOnTj8/dx2xjujoORmZLrsiy7jShB/R5W8Q2jOqHR4AsxnzNvQhvyneU5rosuc8nStY5Scedgvh7kEh4ZmlaYCCCzB+kW+icpw/C3Co7R840L0ao653EMQZvLkqVb1oRM4JONewg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780046510; c=relaxed/simple;
	bh=jjFJRevPABeTTWmt7r98pZx1/KWmbzdlaoFhk5O6S0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXDRUSVqSNEx2aG8MLrxovmIosVQoLJfBXpdtS7IxS/oikuCuC0TjUipKx9YtcMvWfp0DgvjQbqRm7MTm0Rea2PLcSwS5mrY1hOtofztSku8lWj66AmIw5AcuZqWEyuC8F7zekUnKMm5mX8RNrpEDC1G6220x5g3UECnVn4Qgo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mFZC7XCv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mFZC7XCv"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48e6db3ff7eso71146405e9.0
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 02:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780046508; x=1780651308; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vqAhzSB+vg9kKyzDEDNMhRArlwjWlt4Tgxtrau4bCQU=;
        b=mFZC7XCvp7xP4+HWA7mmQXwp90RKmSTTSddH+1tmzNmbluv2aDB1btA8DDxlfsiBJA
         g27akXmJUFfw3t37SR8UnLI/uPzzwQIA8nBYmIZnsUvKzOKIq5FZ+1xKj669oXHE5/sq
         4i77okjSKsMbN6edCGx6+Ju4bjy+NX9hhP6PnlmwzGyW+x8Evi9WephC0uBG1yT3SSvD
         EBMoBrnawyNQivFuA+ZQg70vQZ64r9mEs1Mvnj8CNwFQYIs/bhyvksjpfhHMSU9uraIe
         8Vq+AgCiTKZqaKerTQd7puFIX/Fv+seU3KhvomNbXT3LjjxwvuJBHPQyC7W0Ar/uGYiW
         vCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780046508; x=1780651308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqAhzSB+vg9kKyzDEDNMhRArlwjWlt4Tgxtrau4bCQU=;
        b=fHzvFec07zts+p6SXouvgDv9nTWy3MIYKrnHiRM7SA/78/v2tpGm4j+F0M0mJ/vmid
         4E9Bt8jsyBENkZauzFCChnK/yOM5QdAvv6FN9R7ftTKgG+/cNtC2SP0Vp1moRD4gukwf
         YGWQdYxuyHhXOmbZwt79FfpPmgRuih9hcpYISQ2XNOxbFGWvf4V8uno4sU5U0wN4Ycv9
         MztW/tn2TjOTQbGu7BRo3R84h0JUw6GtynojIqc3orJxT8qLiXxHcphGdxTfjp8QDFoR
         gBJFEGC3AaZgNZHeJ2EEgqVR6kInlNbEorsoW2gC9UtWNADS7b6hbyFCOQfvWaY04KmF
         2OWw==
X-Forwarded-Encrypted: i=1; AFNElJ8p5R7ANTaCAGRy7IN+8F3jKNJM5FXLC6XmQoKLgD2+K0V9nMe7SOcpSvrLwQ+Yxsa0At33Fts=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoeQIB6zgpJW43Y8RoQh8/74U0+vKkveHhq7Yd3z2fll9+9sCu
	shr7C6fIXGPJBBwVKa2au7fyDeVNrqr215Uc0YQ4wYM2anUsN3ytf3t/wNB+wDzpZg==
X-Gm-Gg: Acq92OFSY1ZcJu/0yIQsJQJKFGcatT4tBXNwovC3eBtv6gRAuJOqkcno2MkJTpoTonT
	JK2o4G6tPDnEou8EoWP2z7w6l/IQTQ081TWYuAf76sESFjyzyiyimbnI3iP0k4IGkaero7TzIo5
	iOc/0EUC6xQlu+hsEJTvTOABRtlBUaPC4cpAUaTOwZLAz/55QW/yndpgu7Xl6G+9IYvkUIpm3t3
	BZnsmByOSBGCBuO4P0jfwONFDlt9IflfdidLzmgsuWydbw9JhCKnEZAOKUwlTI/vPIMQSJq191D
	QtpD1nqXl+CfhLmqeh/Jf+KNTxRtvOHyZxqfMd6cfjVKPdMOmZyQJX8AHMvizLRRFHwNS4RuxDp
	6RByNzjfb2nilNsqJIF4IMMILacsSocdvT2vvVVhxiwAf8+zjsvfG2W8c2RR2NZdWOfvL7r3FAw
	7+3nq42iH3FyAiKNmle98wKct9qT6vBjetIDECbz0Ybm2m0UOqqFxuXifldtmAlps4Z4TckQWrw
	6snsA==
X-Received: by 2002:a05:600c:8582:b0:48f:e230:72fc with SMTP id 5b1f17b1804b1-4909c0cbd2dmr25839285e9.33.1780046507168;
        Fri, 29 May 2026 02:21:47 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6f3612sm26265365e9.12.2026.05.29.02.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 02:21:46 -0700 (PDT)
Date: Fri, 29 May 2026 10:21:42 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
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
Message-ID: <ahlapmZj4wnce__B@google.com>
References: <20260529074341.2271950-1-tabba@google.com>
 <ahlIJQU-1b0mayPP@google.com>
 <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com>
 <86a4tivdh3.wl-maz@kernel.org>
 <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>

On Fri, May 29, 2026 at 09:20:50AM +0100, Fuad Tabba wrote:
> On Fri, 29 May 2026 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 29 May 2026 09:05:35 +0100,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > >
> > > > On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > > > > Hi folks,
> > > > >
> > > > > Yet another bug I found while testing Sashiko locally with fixes to
> > > > > review-prompts.
> > > > >
> > > > > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > > > > maintain a host-side RB-tree mirroring the set of pages shared with
> > > > > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > > > > EL2 refcount still held), but neither cleans up on failure:
> > > > >
> > > > > - share_pfn_hyp() inserts the tracking node before the hypercall
> > > > >   and leaves it in the tree on failure, leaking the allocation and
> > > > >   presenting a phantom share to a later unshare.
> > > > >
> > > > > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> > > > >   on failure the host loses its record while EL2 still owns the
> > > > >   share, breaking later operations on the same pfn.
> > > > >
> > > > > Severity is low (no isolation impact) and the failure paths are rare
> > > > > in practice, but the desync is real. Both patches are independent and
> > > > > apply cleanly to current mainline. In other words, this can wait for
> > > > > 7.2.
> > > >
> > > >
> > > > I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> > > > as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> > > > So I haven't sent a v2.
> > >
> > > At the very least we need to add a comment, otherwise, people like me
> > > and LLMs like Sashiko would stumble upon it.
> > >
> > > That said, this fix adds no real overhead, makes the code clearer, and
> > > guards us against a future where that call might fail.
> > > Self-documenting in essense.
> > >
> > > WDYT?
> >
> > If a hypercall really cannot fail, why does it have a return value?
> 
> Good point. If we know it cannot fail, how about just `void`?
> 
> That said, Vincen't exact words are: `very much unlikely`, not the
> same as cannot fail :)
> 
> https://lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com/

The error would happen only if the host tries to share/unshare a page with the
wrong state. This would only happen in the case of a misbehaving host.

And Quentin's point was that this is anyway incomplete. To handle this error
properly, kvm_share_hyp/kvm_unshare_hyp would also need to rollback things...
The callers of the unshare should also leak the memory which couldn't be
unshared properly. This isn't the case now, (however we do WARN_ON).

> 
> /fuad
> 
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
