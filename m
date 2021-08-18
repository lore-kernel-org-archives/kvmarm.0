Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F64C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 16:15:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D8F160238
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 16:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D8F160238
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1B949F82;
	Wed, 18 Aug 2021 12:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cw0iXV2mvQSj; Wed, 18 Aug 2021 12:15:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C912E4A198;
	Wed, 18 Aug 2021 12:15:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E1049FB0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 12:15:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IgWETkX-tEWT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 12:15:48 -0400 (EDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A346F49F82
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 12:15:48 -0400 (EDT)
Received: by mail-lf1-f48.google.com with SMTP id i28so5809063lfl.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 09:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=TEwIWTOJnfQKmJV+qBIqJECmU7WSd1FB63B1/YrgHdo=;
 b=JVjxnq5Ac0AQvgcOOvMtjdDPsrN54xX4jVMn5RGZCrTef9yRqK3/QpW/c90fA12Ke8
 lN2XkJNKxx+qy1Bk5sJE8Xuhu4MDo6tYI7/sR6MVwhbTSsKTUHPZHcFPYcHCP0AavmHq
 hdJMhXF1/gLrEAKpnc/oEkd25jaieCRSdUJBm3Yt76qiviUFUxW973pWfHu5MjimOxiE
 91pqHKW6d5oN9mFioICJAqCSGPJ7PmUODJWLT9bmphvJxbtx3FB6gr9IsHubalMUrpuA
 QYf9tiwU0NAvZur53Hdf9XUhdVxy3cuHYI6+NcWU9o3Klll/j3NDBWD2vJyEzgrf86bh
 ri0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=TEwIWTOJnfQKmJV+qBIqJECmU7WSd1FB63B1/YrgHdo=;
 b=J+yB5f4DrzAaUkf/AgiMPakgzMLwObmtdzLMA0gGwDMR45nOkAKiQGIZUkWExcwA9S
 rJL3FIVZakQ/8Ufus51HalWMKiMm3aVTqJMXHTU0yi3GG6xWw+rJudwpjIP5srCr4GMA
 c7FyzUHnoGbWkOy2BdexLan7DiF7g0+bSlKSIIIG8FJ7mfQ0zhbS4LsNgXsbbu+V1nnn
 xM4QbqaMmJ94ZFz17ykKUKhOPwKlYPws2f3UcejS+A7Oh3flZ2LkaCWV+TEyC9nB5BFa
 4lW0iIz6KxqgdETeGV1h3IXlPviDBbHabjTpQMJIro9q9eqoElP5btpIRKcUFB0dEu1Q
 tWkQ==
X-Gm-Message-State: AOAM533UQMipbzHMccii/MMUmb5m96rXRKzbx+iTMAy2OQ7MB9AUYbYr
 VFcasxGuGgYfYntDaLTFpm6BSroXQkkYYbhTtemCFw==
X-Google-Smtp-Source: ABdhPJyE8PY3a0d08H2Xg5YuBgSUNy+RLivU5nzt1SmeEwZPucMWxSqfCxYh3qHqdjE1MeGo7wziEo0rVOSB5wGguRc=
X-Received: by 2002:a05:6512:31ce:: with SMTP id
 j14mr3107800lfe.646.1629303347173; 
 Wed, 18 Aug 2021 09:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210817002639.3856694-1-jingzhangos@google.com>
 <87v943rx32.wl-maz@kernel.org>
In-Reply-To: <87v943rx32.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 18 Aug 2021 09:15:36 -0700
Message-ID: <CAAdAUtjFdEX73fTDu-+gGfPR=KqvvSzVRZ=vVGJe=8=iAJOv1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Marc,

On Wed, Aug 18, 2021 at 1:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 01:26:39 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a new stat that counts the number of times a remote TLB flush is
> > requested, regardless of whether it kicks vCPUs out of guest mode. This
> > allows us to look at how often flushes are initiated.
>
> nit: this is a very x86-centric view of things. On arm64, TLB
> invalidation is broadcast in HW, and does not interrupt the guest
> execution.
>
Understood. Thanks.
> >
> > Original-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c      | 1 +
> >  include/linux/kvm_host.h  | 3 ++-
> >  include/linux/kvm_types.h | 1 +
> >  virt/kvm/kvm_main.c       | 1 +
> >  4 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 0625bf2353c2..f5bb235bbb59 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -80,6 +80,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> >   */
> >  void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  {
> > +     ++kvm->stat.generic.remote_tlb_flush_requests;
> >       kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> >  }
>
> We already have this queued for 5.15 [1].
I guess you mean the change for "remote_tlb_flush" has been queued,
not "remote_tlb_flush_requests"?
These two counters would have the same value for arm64, but not for
others (at least x86).
>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20210727103251.16561-1-pbonzini@redhat.com
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
