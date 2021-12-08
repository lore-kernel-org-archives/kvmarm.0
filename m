Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF3BC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 09:51:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6064B0F7;
	Wed,  8 Dec 2021 04:51:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XYdE0-33bemV; Wed,  8 Dec 2021 04:51:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419CB4B106;
	Wed,  8 Dec 2021 04:51:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC7D4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 04:51:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zee11zOiyMGr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 04:51:37 -0500 (EST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 434494B0B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 04:51:37 -0500 (EST)
Received: by mail-wr1-f44.google.com with SMTP id q3so3046945wru.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 01:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gldA+GhZIOtvn7+srlMnzCuMOvxYrv7KuJt8R9mUOr8=;
 b=I5USUv0adWNsdFOcjZGJioG32G+/SMDOX9D0A47diifl3032llJ03dZ67rehpoLcCo
 JjpPRT5bCYVQtH2wnYBwb221+dl1foyrCt+6Jp7wWFty3J06d2XkD5St37KRmlPjvn/s
 CqYzhyYp9D9nLG6dGbT8Nol8FixWbpt2QLUih88qo78XOqHxkHpPHLSHaGJITiNzabyx
 F0nmTWFLUYlFNarepQzJirszXMLPerNtjhhGrzZET76OPBMZHuFZb+23iGyq9HG7ZByR
 s5kL1etsmKS5plFGaEYrteLeuZEd1mr51zyRoE4O2aPaeoRR8l83W/96SxpJR4JrBExi
 u17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gldA+GhZIOtvn7+srlMnzCuMOvxYrv7KuJt8R9mUOr8=;
 b=C2ckcHN3UtAd8JvlOZzFHwFrfncsEzZMpnI8VGdqBsJV5sMKfhSi2QR44Hl8ZAMYbc
 hKkFaibaHzY0AphRjkSw7jksMvSXJV/KgHmw9BiQ1boFDds8bQ+TxQ/wve3SGZrFxaGo
 2fquLcCERGu3mNqgkSNm+3uh1ndXOWV3yGHU8o9mpMyTMy4vtVhY5SwT1Pt7apXL11Nu
 /RckBxCOxThhOi9oiFkgxt7iLuYMPXSDtmANDm5dlUEWjC09OwVy54ang3xkaYDxwgRj
 vENS098mO+IyJqZCwhLHCrZeo6x0VZkDeGmbDjdmrOUA51WWuCiy9ODTWT4u5iv8Jc+W
 cPcw==
X-Gm-Message-State: AOAM533S0WFisTUI8bJgKg2U+i67nXNWAd/eOeeDIQcsHNyzkdaTZ+qE
 W6kkmu7Ppdi6mhVOw9tZS5zO4g==
X-Google-Smtp-Source: ABdhPJxaWkQKHRy5eAGnuxAI4kVzboOgvmSfrlkZLSE9/5OHNPgsC5xZJ2qp6NyzrRB0QnSt+lERWg==
X-Received: by 2002:a5d:4312:: with SMTP id h18mr58432938wrq.626.1638957095995; 
 Wed, 08 Dec 2021 01:51:35 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:27b8:d9b2:cac1:a973])
 by smtp.gmail.com with ESMTPSA id d15sm2940100wri.50.2021.12.08.01.51.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Dec 2021 01:51:35 -0800 (PST)
Date: Wed, 8 Dec 2021 09:51:33 +0000
From: Quentin Perret <qperret@google.com>
To: Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Implement kvm_pgtable_hyp_unmap()
 at EL2
Message-ID: <YbCAJZAqUXngvjZ2@google.com>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-7-qperret@google.com>
 <CA+_y_2EEP5tYbBTd17c1wuOeZ2jSfhgu0M2b=CpGKjKRgU-=gw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+_y_2EEP5tYbBTd17c1wuOeZ2jSfhgu0M2b=CpGKjKRgU-=gw@mail.gmail.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Andrew,

On Tuesday 07 Dec 2021 at 14:47:14 (+0000), Andrew Walbran wrote:
> On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > From: Will Deacon <will@kernel.org>
> >
> > Implement kvm_pgtable_hyp_unmap() which can be used to remove hypervisor
> > stage-1 mappings at EL2.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 21 ++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 63 ++++++++++++++++++++++++++++
> >  2 files changed, 84 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 027783829584..9d076f36401d 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -251,6 +251,27 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
> >  int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
> >                         enum kvm_pgtable_prot prot);
> >
> > +/**
> > + * kvm_pgtable_hyp_unmap() - Remove a mapping from a hypervisor stage-1 page-table.
> > + * @pgt:       Page-table structure initialised by kvm_pgtable_hyp_init().
> > + * @addr:      Virtual address from which to remove the mapping.
> > + * @size:      Size of the mapping.
> > + *
> > + * The offset of @addr within a page is ignored, @size is rounded-up to
> > + * the next page boundary and @phys is rounded-down to the previous page
> > + * boundary.
> > + *
> > + * TLB invalidation is performed for each page-table entry cleared during the
> > + * unmapping operation and the reference count for the page-table page
> > + * containing the cleared entry is decremented, with unreferenced pages being
> > + * freed. The unmapping operation will stop early if it encounters either an
> > + * invalid page-table entry or a valid block mapping which maps beyond the range
> > + * being unmapped.
> 
> How is the caller expected to break up the block mapping? Why not
> handle that within this function?

We don't really use block mappings for the hyp stage-1, since pretty
much forever (see the loop in pkvm_create_mappings_locked() for ex), so
handling it here would be somewhat unnecessary complexity. Handling this
in the pgtable code itself (which I assume would mean proactively
re-mapping the rest of the range with page-granularity mappings or
something along those lines) is tricky because of BBM and concurrency,
so I'd rather avoid handling same-level aborts at EL2 and all that mess
unless we have a good reason. Is there a use-case where you think that'd
be needed?

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
