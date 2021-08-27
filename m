Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E255C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:40:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FEF560FDA
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8FEF560FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2072F4B093;
	Fri, 27 Aug 2021 03:40:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hpoC6+BYbUnp; Fri, 27 Aug 2021 03:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B1CD4B097;
	Fri, 27 Aug 2021 03:40:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A95E4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L6KMoS9mPqik for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 03:40:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2BA4B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:40:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630050017;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Rii/zgRLd6hCVDVQRt0tyZE6ehMX8WY/dl6bs0+yEDI=;
 b=IjX0aBVWRp/3QDYD8PGXMWRB/4XtlZe432PqN8J0xJ4hYFzZSwZgPg+Wkw7YIE93Ok7xT/
 m5rK2FDBXux4EL/9EWQ6DsO2/cgKZgK61WV+nT46W/bPT3IOdad1QNYbf21+PQ9wyI7jm+
 B91ot8zgEWgRljWkRuE7H7bGEqdKndY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-Aemg1hAzNiiwhS41dHi7Kw-1; Fri, 27 Aug 2021 03:40:15 -0400
X-MC-Unique: Aemg1hAzNiiwhS41dHi7Kw-1
Received: by mail-ed1-f69.google.com with SMTP id
 k13-20020aa7c04d000000b003bf04c03fc4so2844580edo.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 00:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Rii/zgRLd6hCVDVQRt0tyZE6ehMX8WY/dl6bs0+yEDI=;
 b=Cv4aL5B11Wl70SqWfpscd84Y3qEZzZcE4nPT1eQWLfn/tBxMvUTZWUX5Q1WnjXTNk0
 oY1n0kFGigMFwogj2tmmxPPCYA5/Dt6T4QdGqv1ntmzgKWPOrrpOzETyTgokJoJJFsKA
 3pxt69iWoMShaPshN5lXDRRokXLT2bqJa4Qvhfqkt4qUvL/G7JV1pTOFBRy/I022cekl
 A/D82lZAAlbqNmrYd1vO3mBmrD7GwVNWqsazBxJVhkWfFBcRHHg/fHomZ1avv1uYBynP
 Yv7TqPg8/pR7P4IGyTFmlIj3wXVNVn0F4vsjfNPL+raun17HK/hqPnWF7dQabcNdcrAe
 H2hw==
X-Gm-Message-State: AOAM533rkKY5iyINy2hQmHZ1d1cg8F9F6L0399G4+Zc+JmmbCfZw+BQa
 JDVC9sN7YA+YO86sZZUdWqcZA71aS8XecN4CID/Z5UR1OwryszMFc5Ntd6/bvAHnTzZHs62m0oi
 PCnHw0coh8NGmy9g3f27lLHNF
X-Received: by 2002:a17:906:7802:: with SMTP id
 u2mr8568601ejm.325.1630050014003; 
 Fri, 27 Aug 2021 00:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlEI4c4uSGsWYzam6QjM0CnHAaEPMYHwHg4H4eCO8Seu3DwRP7jsyPigOg5ReqAEUGy+6+5A==
X-Received: by 2002:a17:906:7802:: with SMTP id
 u2mr8568574ejm.325.1630050013822; 
 Fri, 27 Aug 2021 00:40:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id ca4sm2433570ejb.1.2021.08.27.00.40.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Aug 2021 00:40:13 -0700 (PDT)
Date: Fri, 27 Aug 2021 09:40:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
 <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
MIME-Version: 1.0
In-Reply-To: <YSfiN3Xq1vUzHeap@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pshier@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Aug 26, 2021 at 06:49:27PM +0000, Oliver Upton wrote:
> On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> > On Wed, 25 Aug 2021 19:14:59 +0100,
> > Oliver Upton <oupton@google.com> wrote:
> > > 
> > > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> > 
> > [...]
> > 
> > > > Thanks for including me Marc. I think you've mentioned all the examples
> > > > of why we don't generally expect N+1 -> N migrations to work that I
> > > > can think of. While some of the examples like get-reg-list could
> > > > eventually be eliminated if we had CPU models to tighten our machine type
> > > > state, I think N+1 -> N migrations will always be best effort at most.
> > > >
> > > > I agree with giving userspace control over the exposer of the hypercalls
> > > > though. Using pseudo-registers for that purpose rather than a pile of
> > > > CAPs also seems reasonable to me.
> > > >
> > > > And, while I don't think this patch is going to proceed, I thought I'd
> > > > point out that the opt-out approach doesn't help much with expanding
> > > > our migration support unless we require the VMM to be upgraded first.
> > > >
> > > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > > work as expected, since the source enforce opt-out, but the destination
> > > > won't.
> > > 
> > > Right, there's going to need to be a fence in both kernel and VMM
> > > versions. Before the fence, you can't rollback with either component.
> > > Once on the other side of the fence, the user may freely migrate
> > > between kernel + VMM combinations.
> > >
> > > > Also, since the VMM doesn't key off the kernel version, for the
> > > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > > leaving it to the user to ensure they consider everything. opt-in
> > > > usually only needs the user to consider what machine type they want to
> > > > launch.
> > > 
> > > Going the register route will implicitly require opt-out for all old
> > > hypercalls. We exposed them unconditionally to the guest before, and
> > > we must uphold that behavior. The default value for the bitmap will
> > > have those features set. Any hypercalls added after that register
> > > interface will then require explicit opt-in from userspace.
> > 
> > I disagree here. This makes the ABI inconsistent, and means that no
> > feature can be implemented without changing userspace. If you can deal
> > with the existing features, you should be able to deal with the next
> > lot.
> >
> > > With regards to the pseudoregister interface, how would a VMM discover
> > > new bits? From my perspective, you need to have two bitmaps that the
> > > VMM can get at: the set of supported feature bits and the active
> > > bitmap of features for a running guest.
> > 
> > My proposal is that we have a single pseudo-register exposing the list
> > of implemented by the kernel. Clear the bits you don't want, and write
> > back the result. As long as you haven't written anything, you have the
> > full feature set. That's pretty similar to the virtio feature
> > negotiation.
> 
> Ah, yes I agree. Thinking about it more we will not need something
> similar to KVM_GET_SUPPORTED_CPUID.
> 
> So then, for any register where userspace/KVM need to negotiate
> features, the default value will return the maximum feature set that is
> supported. If userspace wants to constrain features, read out the
> register, make sure everything you want is there, and write it back
> blowing away the superfluous bits. Given this should we enforce ordering
> on feature registers, such that a VMM can only write to the registers
> before a VM is started?

That's a good idea. KVM_REG_ARM64_SVE_VLS has this type of constraint so
we can model the feature register control off that.

> 
> Also, Reiji is working on making the identity registers writable for the
> sake of feature restriction. The suggested negotiation interface would
> be applicable there too, IMO.

This this interesting news. I'll look forward to the posting.

> 
> Many thanks to both you and Drew for working this out with me.
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
