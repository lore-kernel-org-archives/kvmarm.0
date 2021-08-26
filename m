Return-Path: <SRS0=T8IC=NR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44FEC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 18:49:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F60A61038
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 18:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F60A61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1444B102;
	Thu, 26 Aug 2021 14:49:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qJaHaJyViQYc; Thu, 26 Aug 2021 14:49:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB78A4B0C3;
	Thu, 26 Aug 2021 14:49:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A24C94B0C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 14:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72qXBKlC0yt3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 14:49:32 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7016E4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 14:49:32 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id a21so5037793ioq.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=RVUTQwfXwIWJ8KSHNLLKmgxbQdeuJteYiwLVXKrHs2E=;
 b=RlH7+pWHb6AHxbU3UBBJJ37bcoBxFJ+OtQc00AVbSygJknZ/usx11UO93s13G1kXX9
 CcZJrRyf0UdTbKCwUaojenkX5SVnXL9NHwvsqqAY/zQ//p0C+YM4cQD7FneQjJ3tB8Aa
 cMrJUpb9BQzx2jUWBC1kV31Q8634J4jt38JtglF1vnnYuD+EgmbxuiAdKNe0yIPy5viO
 tbjYlVlNGUw9dtSd01/0cTaV2aGVOlCz1pzGl7CAV/zNmDWjdq1bz6VMh9cU5i4GYnxj
 4F3MA1cOOAlb0UtfQ1G0jAbM/WTqp+4jaVkgoa7ZNZ7B4nBPcn1mEfwDWFAId+KT8PYw
 UaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=RVUTQwfXwIWJ8KSHNLLKmgxbQdeuJteYiwLVXKrHs2E=;
 b=dF1gpkP+ZN3yCZvPHTIpaumNKsMcAj1NboE7nO0hV3l2Pgc/fVEQWgNoClnzA6IWdT
 fcAi1a8scDO43HeCZvnXPqCWUjfRM9T1KJe9w4EGs05w8uKSQJaXi73fEmFNCJ2lNw7N
 bI1+q+XpvVpeCo8e+GHqK98wl94vg8GpkWffIQWm+TqcGcNG3IhwBCpTYwXYWquJrH/H
 BGE1SybRSaUa45y2kwmmlEqcE/0qq8YxxKGgQzdqRW9QyD21ovpb5etcKrHJcj3TGZOM
 TusWrXia8fPfUOv9fqMW4VelzyL+bnuwHZSjdIGnbTB5AuZ7/deCdkBHDLZo1Zh/pPiO
 GiVw==
X-Gm-Message-State: AOAM5309L+LC0+LdZHe62cpOMaxSgRC9PZvROzZsu4+DQj4tEMDZ6lIv
 VqQcM3/XyCTt4xAynguixOUfrw==
X-Google-Smtp-Source: ABdhPJx5cxoJqj5jt4PGdlUhbRpwDMVgyY3ef2R2HYspFPIJb/ORtT336DtZE2lfPru1xakwQbOqEA==
X-Received: by 2002:a6b:3c16:: with SMTP id k22mr4252523iob.130.1630003771571; 
 Thu, 26 Aug 2021 11:49:31 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id a11sm2067749ilf.79.2021.08.26.11.49.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 26 Aug 2021 11:49:30 -0700 (PDT)
Date: Thu, 26 Aug 2021 18:49:27 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YSfiN3Xq1vUzHeap@google.com>
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
 <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877dg8ppnt.wl-maz@kernel.org>
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

On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> On Wed, 25 Aug 2021 19:14:59 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> 
> [...]
> 
> > > Thanks for including me Marc. I think you've mentioned all the examples
> > > of why we don't generally expect N+1 -> N migrations to work that I
> > > can think of. While some of the examples like get-reg-list could
> > > eventually be eliminated if we had CPU models to tighten our machine type
> > > state, I think N+1 -> N migrations will always be best effort at most.
> > >
> > > I agree with giving userspace control over the exposer of the hypercalls
> > > though. Using pseudo-registers for that purpose rather than a pile of
> > > CAPs also seems reasonable to me.
> > >
> > > And, while I don't think this patch is going to proceed, I thought I'd
> > > point out that the opt-out approach doesn't help much with expanding
> > > our migration support unless we require the VMM to be upgraded first.
> > >
> > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > work as expected, since the source enforce opt-out, but the destination
> > > won't.
> > 
> > Right, there's going to need to be a fence in both kernel and VMM
> > versions. Before the fence, you can't rollback with either component.
> > Once on the other side of the fence, the user may freely migrate
> > between kernel + VMM combinations.
> >
> > > Also, since the VMM doesn't key off the kernel version, for the
> > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > leaving it to the user to ensure they consider everything. opt-in
> > > usually only needs the user to consider what machine type they want to
> > > launch.
> > 
> > Going the register route will implicitly require opt-out for all old
> > hypercalls. We exposed them unconditionally to the guest before, and
> > we must uphold that behavior. The default value for the bitmap will
> > have those features set. Any hypercalls added after that register
> > interface will then require explicit opt-in from userspace.
> 
> I disagree here. This makes the ABI inconsistent, and means that no
> feature can be implemented without changing userspace. If you can deal
> with the existing features, you should be able to deal with the next
> lot.
>
> > With regards to the pseudoregister interface, how would a VMM discover
> > new bits? From my perspective, you need to have two bitmaps that the
> > VMM can get at: the set of supported feature bits and the active
> > bitmap of features for a running guest.
> 
> My proposal is that we have a single pseudo-register exposing the list
> of implemented by the kernel. Clear the bits you don't want, and write
> back the result. As long as you haven't written anything, you have the
> full feature set. That's pretty similar to the virtio feature
> negotiation.

Ah, yes I agree. Thinking about it more we will not need something
similar to KVM_GET_SUPPORTED_CPUID.

So then, for any register where userspace/KVM need to negotiate
features, the default value will return the maximum feature set that is
supported. If userspace wants to constrain features, read out the
register, make sure everything you want is there, and write it back
blowing away the superfluous bits. Given this should we enforce ordering
on feature registers, such that a VMM can only write to the registers
before a VM is started?

Also, Reiji is working on making the identity registers writable for the
sake of feature restriction. The suggested negotiation interface would
be applicable there too, IMO.

Many thanks to both you and Drew for working this out with me.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
