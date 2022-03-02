Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6026C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Mar 2022 11:20:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25EE049EE4;
	Thu,  3 Mar 2022 06:20:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lWg04BWpjEwT; Thu,  3 Mar 2022 06:20:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F6E49EED;
	Thu,  3 Mar 2022 06:20:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E0049E10
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:25:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mv4ZdgRRBKAB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:25:05 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6B2B40256
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:25:05 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id m6so3872502wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 09:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=bz7qotst5wZ2RH1Ycd9IIg729giMypmnjudyWeu+UwU=;
 b=lvmC6OwysBVJcR6sJCUrR+wOrgbPj+ANTmN1KXU72r/93w/a8+Hdqgb8MfLsG43iYE
 zYMxmv0GrzTjXS2FAs2VhCWlRf5n+pYIN590AcBgJ36WqobqzS6erQN+QMF2T+8TDk33
 DPCZ7tKakr8buBALDa2Iv8OIsfNJbvTneuAs7N5W9Rex4CrI4onp2LZYLTghetUf4JCc
 tR/VEWRSHJwl243How9otm9mr2PKSNztegqbAjdO5gWLxDRvIXKUZnCP2HdYtIdflf/g
 Cmffy3GqwRa/C+Ycx0agEajPx9vlD3SIWg6+9NoAkyTlAE+ItKPy3tly4uLagG267KHe
 xupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bz7qotst5wZ2RH1Ycd9IIg729giMypmnjudyWeu+UwU=;
 b=Kyq0ZEIZJEOWexjEOGd4XqOjEhpExpySY49eV2KNCZTzdCoOLgI9Jp2Jv6h+9j19TR
 N3BoboVLz9psF8gJNEv/+6yIYf8EAuN1nAxuEh+kGrkklsjGq5m+nJN2h4t6xsRzdM2Y
 6QWv2ZjNyTmNO4gi/Od5gb3wTSCRRUwq5U0zgcWOUu/gYsIsz6unxidTURuI6FaLBYSe
 0TRT4XGvSRFu/Q25RlnA1Zl07lt0scW5u5yAkAt0R0b95McNC7KTbsEQ6YJZLIaSLi/c
 Yk20trr76QefDx5H9XnveWc3ErMZ8qlbg+5fP53P69Y503Yw2qU036BgNQbu3X5J3Fvu
 wYJA==
X-Gm-Message-State: AOAM5337DYuh/js24RfItGzsVv1yr6U/qMiAof1hVNvULl44E2uO7Wb5
 l7chY1DZDaT5NAB9y/VLZPPmpZU4IadHfql2tYExhw==
X-Google-Smtp-Source: ABdhPJyvAVYsK6bS1ULRzdVEwTranzJPFva6nkK9r8cZMojwnXMSs7MamfTIXIP3rnb2zflw1aKln/RKLG3YyPjdHWc=
X-Received: by 2002:adf:ca08:0:b0:1ed:c0bc:c212 with SMTP id
 o8-20020adfca08000000b001edc0bcc212mr23553444wrh.577.1646241904615; Wed, 02
 Mar 2022 09:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
 <20220225033548.1912117-3-kaleshsingh@google.com>
 <87v8ww6bl0.wl-maz@kernel.org>
In-Reply-To: <87v8ww6bl0.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 2 Mar 2022 09:24:53 -0800
Message-ID: <CAC_TJvfTZP9+EKFFXQUeGOWJb=WK2Wkd53bPOX2gaz0Gh5o8OA@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] KVM: arm64: Introduce pkvm_alloc_private_va_range()
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Thu, 03 Mar 2022 06:20:26 -0500
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

On Tue, Mar 1, 2022 at 11:46 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 25 Feb 2022 03:34:47 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > pkvm_hyp_alloc_private_va_range() can be used to reserve private VA ranges
> > in the pKVM nVHE hypervisor (). Also update __pkvm_create_private_mapping()
> > to allow specifying an alignment for the private VA mapping.
> >
> > These will be used to implement stack guard pages for pKVM nVHE hypervisor
> > (in a subsequent patch in the series).
> >
> > Credits to Quentin Perret <qperret@google.com> for the idea of moving
> > private VA allocation out of __pkvm_create_private_mapping()
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v4:
> >   - Handle null ptr in pkvm_alloc_private_va_range() and replace
> >     IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
> >   - Fix kernel-doc comments format, per Fuad
> >   - Format __pkvm_create_private_mapping() prototype args (< 80 col), per Fuad
> >
> > Changes in v3:
> >   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
> >
> > Changes in v2:
> >   - Allow specifying an alignment for the private VA allocations, per Marc
>
> I probably badly expressed my earlier concern.
>
> Yes, an alignment is necessary. But how often do we want an alignment
> that isn't naturally aligned to the size of the allocation (i.e. the
> power of 2 >= the size of the allocation)? This is what the rest of
> the kernel does (get_order() and co), and I thing we should follow
> this.

Hi Marc,

Thanks for clarifying. I think making the alignment implicitly based
on the size here will create unnecessary holes where PAGE_SIZE
alignment would be ok and potentially overflow the private VA space
earlier. Is it not a concern?

- Kalesh
>
> This applies to both this patch and the previous one.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
