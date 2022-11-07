Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E080C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 14:59:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC354B8B3;
	Mon,  7 Nov 2022 09:59:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DvEwQAXPSnP9; Mon,  7 Nov 2022 09:59:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFA54B877;
	Mon,  7 Nov 2022 09:59:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA534B846
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:59:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9UcBF8DFi2Jl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 09:59:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3940F4B843
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:59:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667833186;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
 b=GyTDFZ0J5feXTG3D5+SsiSaR1tr41w122wIOHAbTV2KmaFwumP5+lyjo34BzXnviKTk9BJ
 FqYTI/TdHBSx3O+HBL/Gv4qUzJkXU9oqA1jWUkEWqAM+MaihKyEj6k+MY31R6NtJ/zTCQQ
 Sil/Ka5BD2TS9CNGlrmVOOYNeZK21zM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-BsZUvWB-PEiMRBe8fLAzaQ-1; Mon, 07 Nov 2022 09:59:44 -0500
X-MC-Unique: BsZUvWB-PEiMRBe8fLAzaQ-1
Received: by mail-qt1-f198.google.com with SMTP id
 y8-20020ac87088000000b003a528a5b844so8199771qto.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
 b=uhD6gvuECGFcaePl8G82mAQFWrh362O4GaWJ2N4DKkretEp4Nk/Vmp8m2/6+UGnSNj
 HORxrc2N3Ei766QL+MRWTioqz5rtdudXv/akF6n23ZWK8+M5LOK8eFx41CXsmIYsdB0b
 miPozkq+VYtB95kM+W1co9c3moxUSvP0ExSd5jrNaMECcpJP5Id+ImyCtE4uUDDk1YVk
 dHvljOGEBzpRbWdJLKyB2eRvKG66ZX4lU8r2Y6U8LGj/AmTXjsXVpMWF4opKo059hmjZ
 lnSzPGuv6cRU/CecQtXiLyweNi0up++JE1Paxcl40yvtVQ4nOWudu0LEDZeLWEPnzpZj
 GC2g==
X-Gm-Message-State: ACrzQf3RshDix08QehEJF/irZW+YO8HbZBYSjxpXvyGotp60wLQykw3N
 /aKW75OYtrxupbqHZ4XprK+sRjTcm6GHUhaf9jxXLvenkx4RYBwQ5ij6dTqezlappb86MKkuSyp
 xq9EpFyHWaDsxzbuS8s6AA+ek
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id
 bs19-20020a05620a471300b006fa330cfb05mr734562qkb.73.1667833183461; 
 Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-Smtp-Source: AMsMyM65yBkuWsX7foV0D07w/+0OUFO1k03g8uWqP5eTrlq70LuV1+/X8Nl2aCAIrOhqBUEvgBBIiQ==
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id
 bs19-20020a05620a471300b006fa330cfb05mr734561qkb.73.1667833183175; 
 Mon, 07 Nov 2022 06:59:43 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 g10-20020a05620a40ca00b006f3e6933bacsm7057304qko.113.2022.11.07.06.59.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 06:59:42 -0800 (PST)
Date: Mon, 7 Nov 2022 09:59:41 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kdXTn6X3O08sFv@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org> <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org> <Y2gh4x4MD8BJvogH@x1n>
 <867d07qfvk.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <867d07qfvk.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, Nov 07, 2022 at 09:21:35AM +0000, Marc Zyngier wrote:
> On Sun, 06 Nov 2022 21:06:43 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
> > > Hi Peter,
> > > 
> > > On Sun, 06 Nov 2022 16:22:29 +0000,
> > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > Hi, Marc,
> > > > 
> > > > On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > > > > > +Note that the bitmap here is only a backup of the ring structure, and
> > > > > > +normally should only contain a very small amount of dirty pages, which
> > > > > 
> > > > > I don't think we can claim this. It is whatever amount of memory is
> > > > > dirtied outside of a vcpu context, and we shouldn't make any claim
> > > > > regarding the number of dirty pages.
> > > > 
> > > > The thing is the current with-bitmap design assumes that the two logs are
> > > > collected in different windows of migration, while the dirty log is only
> > > > collected after the VM is stopped.  So collecting dirty bitmap and sending
> > > > the dirty pages within the bitmap will be part of the VM downtime.
> > > > 
> > > > It will stop to make sense if the dirty bitmap can contain a large portion
> > > > of the guest memory, because then it'll be simpler to just stop the VM,
> > > > transfer pages, and restart on dest node without any tracking mechanism.
> > > 
> > > Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
> > > in general. It only makes sense if the source of the dirty pages is
> > > limited to the vcpus, which is literally a corner case. Look at any
> > > real machine, and you'll quickly realise that this isn't the case, and
> > > that DMA *is* a huge source of dirty pages.
> > > 
> > > Here, we're just lucky enough not to have much DMA tracking yet. Once
> > > that happens (and I have it from people doing the actual work that it
> > > *is* happening), you'll realise that the dirty ring story is of very
> > > limited use. So I'd rather drop anything quantitative here, as this is
> > > likely to be wrong.
> > 
> > Is it a must that arm64 needs to track device DMAs using the same dirty
> > tracking interface rather than VFIO or any other interface?
> 
> What does it change? At the end of the day, you want a list of dirty
> pages. How you obtain it is irrelevant.
> 
> > It's
> > definitely not the case for x86, but if it's true for arm64, then could the
> > DMA be spread across all the guest pages?  If it's also true, I really
> > don't know how this will work..
> 
> Of course, all pages can be the target of DMA. It works the same way
> it works for the ITS: you sync the state, you obtain the dirty bits,
> you move on.
> 
> And mimicking what x86 does is really not my concern (if you still
> think that arm64 is just another flavour of x86, stay tuned!  ;-).

I didn't mean so, I should probably stop mentioning x86. :)

I had some sense already from the topics in past few years of kvm forum.
Yeah I'll be looking forward to anything more coming.

> 
> > 
> > We're only syncing the dirty bitmap once right now with the protocol.  If
> > that can cover most of the guest mem, it's same as non-live.  If we sync it
> > periodically, then it's the same as enabling dirty-log alone and the rings
> > are useless.
> 
> I'm glad that you finally accept it: the ring *ARE* useless in the
> general sense. Only limited, CPU-only workloads can make any use of
> the current design. This probably covers a large proportion of what
> the cloud vendors do, but this doesn't work for general situations
> where you have a stream of dirty pages originating outside of the
> CPUs.

The ring itself is really not the thing to blame, IMHO it's a good attempt
to try out de-coupling guest size in regard of dirty tracking from kvm.  It
may not be perfect, but it may still service some of the goals, e.g., at
least it allows the user app to detect per-vcpu information and also since
there's the ring full events we can do something more than before like the
vcpu throttling that China Telecom does with the ring structures.

But I agree it's not a generic enough solution.  Hopefully it'll still
cover some use cases so it's not completely not making sense.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
