Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB19C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  3 Mar 2022 17:46:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D5049E21;
	Thu,  3 Mar 2022 12:46:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jvmqipBzNMTv; Thu,  3 Mar 2022 12:46:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEFF440FD6;
	Thu,  3 Mar 2022 12:46:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856E740CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2022 12:46:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LDRLlyU-TC5W for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2022 12:46:04 -0500 (EST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DEB7408F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2022 12:46:04 -0500 (EST)
Received: by mail-wr1-f52.google.com with SMTP id d3so9027351wrf.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Mar 2022 09:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xVrdfQqHlQRP17iPWD96K5pPQc2M9YlWOrUbW8e69bs=;
 b=YIA+zL+kU0ofCJmfw4aARQaZOj9MfhEDi0pzl1d8NoGqLgiDmPKkfVmoOXJlM6uFVF
 ceTNTFW/japJNqxiYw+3IweAwAAk5ZZYZYuINGB3MzB9K/9V+gJ87mCQzQoZRN25096m
 yfgGeZdhYM1jqlSZKJ5xY8+GKNauKY0pvK+OU6WKDq9BcHkV9pd9jbPkqVTwMWJVfnM0
 jg44WFBfWkmBJHKuI4isL1Spq+CjW97hvqK7xNum7H04Zx8JQ0XKhwckVB4uxgrbr0SD
 gMdUABbEkb3XyE5G7ltokcgEJZA4QDZ8sSITsFLGGbI8F2gclRd3nn3CWma9S2e8uu8P
 UHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xVrdfQqHlQRP17iPWD96K5pPQc2M9YlWOrUbW8e69bs=;
 b=zgsJwYoTP0r1d1FC3CSEraxxGRR+DS5JTDT5xIQMciB9vKsUB/GBCNB/R/EUTBMY+p
 9qPh0J7IxfQhmQNJsH8H5fuCQWd3UpaQfEcK0k/MLzBZNWBR/o9O0GT3nxcWmZCJBAXb
 az8hzwVuMkWemj7sP8mEwo/v2j7hRamDOdAEIekEXzVQv4kDgCXV+ugTNvQvwyaMv57x
 g7k1HgmXm7Yd4zwqBvO54fLcBF4IHKZrW+fZ6ZK4Hm/HStcecWlk/d2f+BJAbInDzYNb
 QMuFkUSPHMchU5EorXlXItJ6aD6Pt1uclFuDMle6Hr1zq7thiG/CkUbXbjighk3KOOpk
 qCTA==
X-Gm-Message-State: AOAM530Gy1D3KWztPHZUdaSKuhudGGn31LwkqrKsKFCdADklu3p7xiKQ
 rIFwrfXliWJKngdUWe3bpbHgft9HvfFtAAlkcPsfCw==
X-Google-Smtp-Source: ABdhPJwzr4xFCzbsMj9ho2v2/HHIFz7d8+4DPwLZfPz9RmdehzhMeXAuERztFCAYQF/MCAcmbdp3Dc2Vb4kn4Om4ePM=
X-Received: by 2002:a5d:4c83:0:b0:1ed:e255:2c5 with SMTP id
 z3-20020a5d4c83000000b001ede25502c5mr27290854wrs.649.1646329562968; Thu, 03
 Mar 2022 09:46:02 -0800 (PST)
MIME-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
 <20220225033548.1912117-3-kaleshsingh@google.com>
 <87v8ww6bl0.wl-maz@kernel.org>
 <CAC_TJvfTZP9+EKFFXQUeGOWJb=WK2Wkd53bPOX2gaz0Gh5o8OA@mail.gmail.com>
 <87r17j0wsi.wl-maz@kernel.org>
In-Reply-To: <87r17j0wsi.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 3 Mar 2022 09:45:51 -0800
Message-ID: <CAC_TJvcA8F1x_ynYco9wXeVguOW+OmTB7Z0J-8ES4wVPMxMyFg@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] KVM: arm64: Introduce pkvm_alloc_private_va_range()
To: Marc Zyngier <maz@kernel.org>
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 LKML <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Mar 3, 2022 at 9:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Kalesh,
>
> On Wed, 02 Mar 2022 17:24:53 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > On Tue, Mar 1, 2022 at 11:46 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 25 Feb 2022 03:34:47 +0000,
> > > Kalesh Singh <kaleshsingh@google.com> wrote:
> > > >
> > > > pkvm_hyp_alloc_private_va_range() can be used to reserve private VA ranges
> > > > in the pKVM nVHE hypervisor (). Also update __pkvm_create_private_mapping()
> > > > to allow specifying an alignment for the private VA mapping.
> > > >
> > > > These will be used to implement stack guard pages for pKVM nVHE hypervisor
> > > > (in a subsequent patch in the series).
> > > >
> > > > Credits to Quentin Perret <qperret@google.com> for the idea of moving
> > > > private VA allocation out of __pkvm_create_private_mapping()
> > > >
> > > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > > > ---
> > > >
> > > > Changes in v4:
> > > >   - Handle null ptr in pkvm_alloc_private_va_range() and replace
> > > >     IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
> > > >   - Fix kernel-doc comments format, per Fuad
> > > >   - Format __pkvm_create_private_mapping() prototype args (< 80 col), per Fuad
> > > >
> > > > Changes in v3:
> > > >   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
> > > >
> > > > Changes in v2:
> > > >   - Allow specifying an alignment for the private VA allocations, per Marc
> > >
> > > I probably badly expressed my earlier concern.
> > >
> > > Yes, an alignment is necessary. But how often do we want an alignment
> > > that isn't naturally aligned to the size of the allocation (i.e. the
> > > power of 2 >= the size of the allocation)? This is what the rest of
> > > the kernel does (get_order() and co), and I thing we should follow
> > > this.
> >
> > Hi Marc,
> >
> > Thanks for clarifying. I think making the alignment implicitly based
> > on the size here will create unnecessary holes where PAGE_SIZE
> > alignment would be ok and potentially overflow the private VA space
> > earlier. Is it not a concern?
>
> I don't think we should worry too much about this. Even when building
> the kernel with a very small VA space (commonly 39 bits), we still
> have a quarter of that reserved for private EL2 mappings. That's
> pretty big.
>
> We will use a bit more of the memory that is set aside for EL2 page
> tables, but this shouldn't be a problem either.

Hi Marc,

Thanks for the explanations. I'll update as suggested in the next version.

- Kalesh

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
