Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6119CC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 22:00:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA8B261157
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 22:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA8B261157
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205574B0E6;
	Wed,  8 Sep 2021 18:00:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYX45F+T3T+8; Wed,  8 Sep 2021 18:00:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170794B090;
	Wed,  8 Sep 2021 18:00:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70E8F4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 18:00:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ns2c-OBQxla for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 18:00:52 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25BBC49FB7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 18:00:52 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id g14so5925241ljk.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 15:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GDe9/Ly5F2n1g5YILCIvzMoK8BHDpL9Shfxx8ob78n4=;
 b=ejEiHkTbeEbIe67154apcT6mUJBjbEHtHjSH6KVMwCN8+RT2TpS8G0QlBpEgX0pUJX
 LzgWU3tVcaSU7vKRiDKGv9cm6pBYL0hv+hs5sIy/jbtxngC97nN7EwipCaUbadrIGRsq
 Sl1aUxqaKsteQoj9w7oiv1ZeuxRPJNvIjuqVGNiI2sZ1+xU9p0CspL8j+F2+n+x6oR3z
 Hb0ULJLmgmce9LYYuL9thl9cimbDBD6CNRrwdbShlRAIWAJ2/1MCGN/WvNdxDPeu0Ca3
 /N9f3PB9u2TD92YzD7weC0FRLI4n0pkw1azmceDiMcdd654fsUrQhAbRji62whb2iPVg
 v59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GDe9/Ly5F2n1g5YILCIvzMoK8BHDpL9Shfxx8ob78n4=;
 b=eo/5kG6KSNR+I7deBK3CT1iyDY7rA5wtfr0OncK9AMTwFf28DfJoMBiFkWUr/s7Sel
 UQ0QDO+psE9TSUcPMQiYAMJzD1cxcpmzZM2fibo1xwcd75U32ak/oynYaMSb42ke5xfv
 j6STbe4Du97ul066WaU2+hRB9G6hgj+V3m3QOrpPL2TGF8ucYE3YmIpAsp4T/tIFb0eB
 HQRoWHRW4AiOyCUDhd1X1OJegMl40/OTfcm7ybscKTJ7M/XSOcYj1MH9Anbo3TV+6aBs
 dwGltcvmbBnAJMhLXYdP2CZsiLy5MnQRoJ+0Df5g1BNFUUyRqKfLqa8hoL3ajkhR8Owg
 LlHw==
X-Gm-Message-State: AOAM532AJS2RPySTJzJNR8bA7CrCX5aC4I7c28sr2LjWDs1GAj8UUXwE
 PkWbEAe7a3mtgpmra39jsllpWb6arCjYRgdqp49m4w==
X-Google-Smtp-Source: ABdhPJxPzpIxpaq3ZMzFadWNqfu8YiOXjvgiyHMV9g8NIse80i9fIoc1m0TkP2py7fGZEiT8oipYK0+5WfGzQIekGMc=
X-Received: by 2002:a2e:5c9:: with SMTP id 192mr359998ljf.337.1631138450633;
 Wed, 08 Sep 2021 15:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <YTkr1c7S0wPRv6hH@google.com> <YTkwGHdBcy7v/mSA@google.com>
In-Reply-To: <YTkwGHdBcy7v/mSA@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 8 Sep 2021 18:00:39 -0400
Message-ID: <CAOQ_QsjZMSXYz_BES8JBQncSN5ubdPhs5GrF3OU8KkLf=TiSfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 8, 2021 at 5:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Sep 08, 2021 at 09:32:05PM +0000, Oliver Upton wrote:
> > Hi Ricardo,
> >
> > On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> > > Extend vgic_v3_check_base() to verify that the redistributor regions
> > > don't go above the VM-specified IPA size (phys_size). This can happen
> > > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> > >
> > >   base + size > phys_size AND base < phys_size
> > >
> > > vgic_v3_check_base() is used to check the redist regions bases when
> > > setting them (with the vcpus added so far) and when attempting the first
> > > vcpu-run.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > > index 66004f61cd83..5afd9f6f68f6 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> > >             if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> > >                     rdreg->base)
> > >                     return false;
> >
> > Can we drop this check in favor of explicitly comparing rdreg->base with
> > kvm_phys_size()? I believe that would be more readable.
> >
>
> You mean the integer overflow check above? in that case, I would prefer
> to leave it, if you don't mind. It seems that this type of check is used
> in some other places in KVM (like kvm_assign_ioeventfd and
> vgic_v3_alloc_redist_region).

I would expect rdreg->base to exceed kvm_phys_size() before wrapping,
but we do derive rdreg->count from what userspace gives us. In that
case, your addition in combination with this makes sense, so no real
objections here.

> > > +
> > > +           if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > > +                   kvm_phys_size(kvm))
> > > +                   return false;
> > >     }
> > >
> > >     if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> > > --
> > > 2.33.0.153.gba50c8fa24-goog
> > >
> >
> > --
> > Thanks,
> > Oliver

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
