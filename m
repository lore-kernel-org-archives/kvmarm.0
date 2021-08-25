Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF775C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 15:07:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B0376112D
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 15:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B0376112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA324B164;
	Wed, 25 Aug 2021 11:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TFyX8naeP7FR; Wed, 25 Aug 2021 11:07:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A98864B23C;
	Wed, 25 Aug 2021 11:07:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D56DB4B163
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 11:07:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MDtkAZFhiou for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 11:07:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75BA4B108
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 11:07:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629904044;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bQNqHBMuBkeoTzYem0GnsZ/oQSSfNMVJbT18ezuTAQA=;
 b=gwJx3LVVJBdGtiuXxNVH8sav+bV1Bnz+9ojbRXu7VE86Aay3Kl324913o5swxZ7END6UoM
 5ZRbEs6JtXJfa4DbSdyu7nhdtWIeiM3Iwo6yH8KKt4kvthNRfdVDdb778NRLoB6Lf70VDt
 lvhXnYldKSvnvBy3ZcSktI31rAT4tqY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-FlBLnIE-PBSjCuwglFpMdQ-1; Wed, 25 Aug 2021 11:07:22 -0400
X-MC-Unique: FlBLnIE-PBSjCuwglFpMdQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 eg56-20020a05640228b8b02903be79801f9aso12336567edb.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 08:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bQNqHBMuBkeoTzYem0GnsZ/oQSSfNMVJbT18ezuTAQA=;
 b=kBE0BiiFJi5ALz7nWzT5CZ0dUUT6+KyNEW9CQGGtyxUUV423oa4eO8j4X9IAPIfglO
 LF+jvEDqt5hiwtJVDS0TgtWQ6Cu9M8b8IJT+2lezceGA0wvF5kHAr1y2+x28KlI/s07N
 31Qw56xjpRHSCqSZ22ZKHsjGAWdBxbm7Nfw6ImDaNq0TUn9kR/siydqXmn+nPHPtfy7Q
 2zvq3eIElfw1UWMFlNZSQns7xuiU6VVsGDoZUM3sAPOnKecrkJ2IsvVCo8a3tD8pWDuM
 GREp4PgKflTFd5MbThgszrgEcXT8ku6ca9iqAbQ91uPSbBswgiozhwsQS3l+ZMKj1zYc
 XoZA==
X-Gm-Message-State: AOAM533pMS4D/dxWDwzHGGYpIVjLHZvOGmlD04vXa/6CLSrHuSrpocCK
 TDGo9bdMflI3ymdt/vwN9aZ+JTSklKSoPUcS9kI/v24H+k0yhlqw4SmHXFGCEXrxqChgB2gYN6H
 qZTT9HgznhWE00v4GWo8HeY4z
X-Received: by 2002:a17:907:d8c:: with SMTP id
 go12mr8506761ejc.140.1629904041724; 
 Wed, 25 Aug 2021 08:07:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTY3lB92Yi1ebNh2CEOIDeP0j1ZNq7wrUEgxpktG25+svvIvz+2VYNEl6A1MDbCHs2ZaUIhA==
X-Received: by 2002:a17:907:d8c:: with SMTP id
 go12mr8506730ejc.140.1629904041486; 
 Wed, 25 Aug 2021 08:07:21 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i6sm11089458ejr.68.2021.08.25.08.07.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 Aug 2021 08:07:20 -0700 (PDT)
Date: Wed, 25 Aug 2021 17:07:13 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <20210825150713.5rpwzm4grfn7akcw@gator.home>
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87fsuxq049.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, pshier@google.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Aug 25, 2021 at 11:39:34AM +0100, Marc Zyngier wrote:
> On Wed, 25 Aug 2021 11:02:28 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > On Wed, Aug 25, 2021 at 2:27 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > Exposing new hypercalls to guests in this manner seems very unsafe to
> > > > me. Suppose an operator is trying to upgrade from kernel N to kernel
> > > > N+1, which brings in the new 'widget' hypercall. Guests are live
> > > > migrated onto the N+1 kernel, but the operator finds a defect that
> > > > warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
> > > > Any guests that discovered the 'widget' hypercall are likely going to
> > > > get fussy _very_ quickly on the old kernel.
> > >
> > > This goes against what we decided to support for the *only* publicly
> > > available VMM that cares about save/restore, which is that we only
> > > move forward and don't rollback.
> > 
> > Ah, I was definitely missing this context. Current behavior makes much
> > more sense then.
> > 
> > > Hypercalls are the least of your
> > > worries, and there is a whole range of other architectural features
> > > that will have also appeared/disappeared (your own CNTPOFF series is a
> > > glaring example of this).
> > 
> > Isn't that a tad bit different though? I'll admit, I'm just as guilty
> > with my own series forgetting to add a KVM_CAP (oops), but it is in my
> > queue to kick out with the fix for nVHE/ptimer. Nonetheless, if a user
> > takes up a new KVM UAPI, it is up to the user to run on a new kernel.
> 
> The two are linked. Exposing a new register to userspace and/or guest
> result in the same thing: you can't rollback. That's specially true in
> the QEMU case, which *learns* from the kernel what registers are
> available, and doesn't maintain a fixed list.
> 
> > My concerns are explicitly with the 'under the nose' changes, where
> > KVM modifies the guest feature set without userspace opting in. Based
> > on your comment, though, it would appear that other parts of KVM are
> > affected too.
> 
> Any new system register that is exposed by a new kernel feature breaks
> rollback. And so far, we only consider it a bug if the set of exposed
> registers reduces. Anything can be added safely (as checked by one of
> the selftests added by Drew).
> 
> < It doesn't have to be rollback safety, either. There may
> > simply be a hypercall which an operator doesn't want to give its
> > guests, and it needs a way to tell KVM to hide it.
> 
> Fair enough. But this has to be done in a scalable way, which
> individual capability cannot provide.
> 
> > > > Have I missed something blatantly obvious, or do others see this as an
> > > > issue as well? I'll reply with an example of adding opt-out for PTP.
> > > > I'm sure other hypercalls could be handled similarly.
> > >
> > > Why do we need this? For future hypercalls, we could have some buy-in
> > > capabilities. For existing ones, it is too late, and negative features
> > > are just too horrible.
> > 
> > Oh, agreed on the nastiness. Lazy hack to realize the intended
> > functional change..
> 
> Well, you definitely achieved your goal of attracting my attention :).
> 
> > > For KVM-specific hypercalls, we could get the VMM to save/restore the
> > > bitmap of supported functions. That would be "less horrible". This
> > > could be implemented using extra "firmware pseudo-registers" such as
> > > the ones described in Documentation/virt/kvm/arm/psci.rst.
> > 
> > This seems more reasonable, especially since we do this for migrating
> > the guest's PSCI version.
> > 
> > Alternatively, I had thought about using a VM attribute, given the
> > fact that it is non-architectural information and we avoid ABI issues
> > in KVM_GET_REG_LIST without buy-in through a KVM_CAP.
> 
> The whole point is that these settings get exposed by
> KVM_GET_REG_LIST, as this is QEMU's way to dump a VM state. Given that
> we already have this for things like the spectre management state, we
> can just as well expose the bitmaps that deal with the KVM-specific
> hypercalls. After all, this falls into the realm of "KVM as VM
> firmware".
> 
> For ARM-architected hypercalls (TRNG, stolen time), we may need a
> similar extension.
> 

Thanks for including me Marc. I think you've mentioned all the examples
of why we don't generally expect N+1 -> N migrations to work that I
can think of. While some of the examples like get-reg-list could
eventually be eliminated if we had CPU models to tighten our machine type
state, I think N+1 -> N migrations will always be best effort at most.

I agree with giving userspace control over the exposer of the hypercalls
though. Using pseudo-registers for that purpose rather than a pile of
CAPs also seems reasonable to me.

And, while I don't think this patch is going to proceed, I thought I'd
point out that the opt-out approach doesn't help much with expanding
our migration support unless we require the VMM to be upgraded first.
And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
work as expected, since the source enforce opt-out, but the destination
won't. Also, since the VMM doesn't key off the kernel version, for the
most part N+1 VMMs won't know when they're supposed to opt-out or not,
leaving it to the user to ensure they consider everything. opt-in
usually only needs the user to consider what machine type they want to
launch.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
