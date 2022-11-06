Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A92C433FE
	for <kvmarm@archiver.kernel.org>; Sun,  6 Nov 2022 21:06:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4C34B88C;
	Sun,  6 Nov 2022 16:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d1I5po4cBojP; Sun,  6 Nov 2022 16:06:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 789A64B8A3;
	Sun,  6 Nov 2022 16:06:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8794B8A1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 16:06:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 78Fw2YkHY94Z for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Nov 2022 16:06:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 408134B808
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 16:06:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667768807;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+DA4NmQNiOjUonEI2cHNDOXzF9gIkeMHW76hG0VbL0A=;
 b=ftut7mGIQxsgWmzJEgk4X/2hbZdTYbg2Fei9MNJCmNjEgea9tTEsoFzICCwsNNI+bfyGy4
 QnUKYAjt9A/ZzGdKb4DYG+H1PdtfuBrDYTQww9y8/HbBFAYSPZoCGcAOt3cCurTZrevfuH
 JW0NctglnI2mof3dQMCf3q8RPcwlbgw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-LkQd2iXfPu6RmwhghOkCRg-1; Sun, 06 Nov 2022 16:06:46 -0500
X-MC-Unique: LkQd2iXfPu6RmwhghOkCRg-1
Received: by mail-qk1-f197.google.com with SMTP id
 bm2-20020a05620a198200b006fa6eeee4a9so8739347qkb.14
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Nov 2022 13:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+DA4NmQNiOjUonEI2cHNDOXzF9gIkeMHW76hG0VbL0A=;
 b=lm6uD+4BYEkW5oHjmuiC+kulyVVckc5OcaZKBrymgUmuWLuntG5n16+q+HCnsdsR36
 QFK03jQ7Gg62+rdSSR5In5b3OHcu9Ggujzz9aDBQlWztZg3gIAkwuEAqSsRifb6mfT7T
 Kn6ntwpGIsTYWo7zndCP5uyfUipjXZBiXSvukPjLTTkX2AUwnVXuLEl98TJRWUjC7vCt
 Ld94+94D9XFARBGSLLw7SFfF9yYl7F2BDhSaw1dyjkO4qhvpfDnp1WkI9zXWSMtrZO5J
 khVE4agwJW8AbsXQCrG1JZlL9xny3pff20qpFJOkskW4QJ39DdROw73GydQjMfqQ/Sm1
 Qy7g==
X-Gm-Message-State: ACrzQf3IR2htQatIO3IDA6AMPk5gYNCgqDRO0RcPnBzOw/oIvmfUGfVO
 Zl4GL3RUKTftVFub1HMxfK9nmIesnNAATbj3S71HfACgl6XmsVTqICOMsK7OwyTWYRsv1Tk80V2
 /STQYd9cPk/cmLJ26ARYczkRS
X-Received: by 2002:a05:6214:27cc:b0:4c1:2cc7:2d7c with SMTP id
 ge12-20020a05621427cc00b004c12cc72d7cmr14767318qvb.95.1667768805858; 
 Sun, 06 Nov 2022 13:06:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7q0ohWcv/UJR31wQp4DpFc+MiUL5KSilBMUc9xT24+vyRdsz6Dr0AWP9j07T9XXNm64FuQ8A==
X-Received: by 2002:a05:6214:27cc:b0:4c1:2cc7:2d7c with SMTP id
 ge12-20020a05621427cc00b004c12cc72d7cmr14767290qvb.95.1667768805588; 
 Sun, 06 Nov 2022 13:06:45 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 r1-20020ac85e81000000b0039cc7ebf46bsm4548114qtx.93.2022.11.06.13.06.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 06 Nov 2022 13:06:44 -0800 (PST)
Date: Sun, 6 Nov 2022 16:06:43 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2gh4x4MD8BJvogH@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org> <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87iljrg7vd.wl-maz@kernel.org>
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

On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
> Hi Peter,
> 
> On Sun, 06 Nov 2022 16:22:29 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > Hi, Marc,
> > 
> > On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > > > +Note that the bitmap here is only a backup of the ring structure, and
> > > > +normally should only contain a very small amount of dirty pages, which
> > > 
> > > I don't think we can claim this. It is whatever amount of memory is
> > > dirtied outside of a vcpu context, and we shouldn't make any claim
> > > regarding the number of dirty pages.
> > 
> > The thing is the current with-bitmap design assumes that the two logs are
> > collected in different windows of migration, while the dirty log is only
> > collected after the VM is stopped.  So collecting dirty bitmap and sending
> > the dirty pages within the bitmap will be part of the VM downtime.
> > 
> > It will stop to make sense if the dirty bitmap can contain a large portion
> > of the guest memory, because then it'll be simpler to just stop the VM,
> > transfer pages, and restart on dest node without any tracking mechanism.
> 
> Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
> in general. It only makes sense if the source of the dirty pages is
> limited to the vcpus, which is literally a corner case. Look at any
> real machine, and you'll quickly realise that this isn't the case, and
> that DMA *is* a huge source of dirty pages.
> 
> Here, we're just lucky enough not to have much DMA tracking yet. Once
> that happens (and I have it from people doing the actual work that it
> *is* happening), you'll realise that the dirty ring story is of very
> limited use. So I'd rather drop anything quantitative here, as this is
> likely to be wrong.

Is it a must that arm64 needs to track device DMAs using the same dirty
tracking interface rather than VFIO or any other interface?  It's
definitely not the case for x86, but if it's true for arm64, then could the
DMA be spread across all the guest pages?  If it's also true, I really
don't know how this will work..

We're only syncing the dirty bitmap once right now with the protocol.  If
that can cover most of the guest mem, it's same as non-live.  If we sync it
periodically, then it's the same as enabling dirty-log alone and the rings
are useless.

> 
> >
> > [1]
> > 
> > > 
> > > > +needs to be transferred during VM downtime. Collecting the dirty bitmap
> > > > +should be the very last thing that the VMM does before transmitting state
> > > > +to the target VM. VMM needs to ensure that the dirty state is final and
> > > > +avoid missing dirty pages from another ioctl ordered after the bitmap
> > > > +collection.
> > > > +
> > > > +To collect dirty bits in the backup bitmap, the userspace can use the
> > > > +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
> > > > +and its behavior is undefined since collecting the dirty bitmap always
> > > > +happens in the last phase of VM's migration.
> > > 
> > > It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
> > > you have multiple devices that dirty the memory, such as multiple
> > > ITSs, why shouldn't userspace be allowed to snapshot the dirty state
> > > multiple time? This doesn't seem like a reasonable restriction, and I
> > > really dislike the idea of undefined behaviour here.
> > 
> > I suggested the paragraph because it's very natural to ask whether we'd
> > need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
> > be helpful as a reference to answer that.
> > 
> > I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
> > as fundamentally clear log is about re-protect the guest pages, but if
> > we're with the restriction of above (having the dirty bmap the last to
> > collect and once and for all) then it'll make no sense to protect the guest
> > page at all at this stage since src host shouldn't run after the GET_LOG
> > then the CLEAR_LOG will be a vain effort.
> 
> That's not for you to decide, but userspace. I can perfectly expect
> userspace saving an ITS, getting the bitmap, saving the pages and then
> *clearing the log* before processing the next ITS. Or anything else.

I think I can get your point on why you're not happy with the document, but
IMHO how we document is one thing, how it'll work is another.  I preferred
explicit documentation because it'll help the app developer to support the
interface, also more docs to reference in the future; no strong opinion,
though.

However if there's fundamental statement that was literally wrong, then
it's another thing, and we may need to rethink.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
