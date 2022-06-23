Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF03BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 19:51:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E4F49F28;
	Thu, 23 Jun 2022 15:51:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaTMI0ZyJzgG; Thu, 23 Jun 2022 15:51:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 429644B216;
	Thu, 23 Jun 2022 15:51:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF7D49E45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 14:12:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKYu6ZsqNvO0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 14:12:31 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EA4049E42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 14:12:30 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 l2-20020a05600c4f0200b0039c55c50482so2035031wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 11:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fE/hn8d1SxB+WF9l62z81tDfQAMtVscZwT7QZwLa4i4=;
 b=awzDMxUoNHvZgy6lw0yBYzcMwwUE/rsgv7EdfwAqAZvk/FYB5MjxT96L6VpUeCLdMM
 q+SqS4u02xnPBg03TFxz9GvCgyRYTwD8N1MtNFAB8w51dBzCjFxfokktX8VWoQUszl5k
 9DLa8yc6QltXFWgLehCCVo1oq8FqxP9LskAgCwEorWgzMbm3Z+cXVxkxMeFzLDambLK3
 nF4urVFAKtau9c5dSF0vAKMO+Lh7znaIPsBVUzXFn8176xONMWqPio5LvM+64CkHK/D5
 rKcvMR8DBqpNBf3fbL9EIbJtuu5gs0lWSXgdnuez9QkLbOcQ/54chwV9VHX083qfTrJq
 0LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fE/hn8d1SxB+WF9l62z81tDfQAMtVscZwT7QZwLa4i4=;
 b=T7IIgo2Tx1KttzyAXgrQ4NmKxQ0I31qFWMtSt+hHUao3HsPLIeMEr216ZQXfEbrq4D
 OjupShFsMKvLix9ncC/HJVK3xZZsVU7R4CdPXx4S6fT8O2ct/Puzwa1VAOhROttQdSkB
 jyifu/fJFtZ+BnWIMPh73jmNm2J4EiMY4KBhi0k5WMCgGMRm97EfHy6VU15z5Kqhu8jt
 gvcyCN7gSFJOkqDtR05JTPea1M+T5s7kiSFqDWunrvzBIV0xPR4rNkjj/ATvf88zf3NQ
 4/qr+4EFxRP90OCBDoqkZZdr2xVht1YtA+cpuwWr+Q5qDOKTem2ZvjroGB90WX+Hg607
 I+lQ==
X-Gm-Message-State: AJIora94pqOoQwLyVZczZkzBRTGPoY7jQo9aU9lYJ9M27tGKkibiRqEg
 OPjtfeMzxgiQqdxQkgAnEZUlvtQqBefzqtXnAMMWeQ==
X-Google-Smtp-Source: AGRyM1s/fZccnSKBWvj+dourDgZr/O+gW7wossFeEqxf1vrMwtrpiVhU64nQC1w8oOn2ieqVBklFfi39qtIUPXd9XTE=
X-Received: by 2002:a1c:7418:0:b0:39c:6ead:321c with SMTP id
 p24-20020a1c7418000000b0039c6ead321cmr5508368wmc.171.1656007949830; Thu, 23
 Jun 2022 11:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
 <20220623021926.3443240-2-pcc@google.com>
 <YrRmmrY24Pv6hyAO@google.com>
In-Reply-To: <YrRmmrY24Pv6hyAO@google.com>
From: Peter Collingbourne <pcc@google.com>
Date: Thu, 23 Jun 2022 11:12:17 -0700
Message-ID: <CAMn1gO4RyNCh8aYxrbHqff0xK5vSaV9iaRt20Utb8x9wQA2BYg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Thu, 23 Jun 2022 15:51:40 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jun 23, 2022 at 6:12 AM Quentin Perret <qperret@google.com> wrote:
>
> Hi Peter,
>
> On Wednesday 22 Jun 2022 at 19:19:24 (-0700), Peter Collingbourne wrote:
> > @@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >       /*
> >        * The refcount tracks valid entries as well as invalid entries if they
> >        * encode ownership of a page to another entity than the page-table
> > -      * owner, whose id is 0.
> > +      * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
> >        */
> > -     return !!pte;
> > +     return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
> >  }
>
> I'm not sure to understand this part? By not refcounting the PTEs that
> are annotated with PKVM_ID_NOBODY, the page-table page that contains
> them may be freed at some point. And when that happens, I don't see how
> the hypervisor will remember to block host accesses to the disowned
> pages.

This was because I misunderstood the code and thought that this was
for maintaining a count from PTEs to the pages that they reference
(which would make the refcounting unnecessary for pages owned by
nobody). Reading the code more carefully my understanding is now that
the refcounts are instead for tracking the number of non-zero PTEs in
the page table, so that the hypervisor knows that it can free up a
page table when it becomes all zeros i.e. no longer contains any
information that needs to be preserved (so the "references" that are
being counted are implicit in the location of the PTE). So it doesn't
make sense to not track PTEs owned by nobody here. I'll remove this
part in v2.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
