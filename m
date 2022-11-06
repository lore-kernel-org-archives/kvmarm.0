Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7ADC4332F
	for <kvmarm@archiver.kernel.org>; Sun,  6 Nov 2022 16:22:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254184B693;
	Sun,  6 Nov 2022 11:22:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YL3at5M1oHz4; Sun,  6 Nov 2022 11:22:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F464B7E8;
	Sun,  6 Nov 2022 11:22:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63554B7E8
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 11:22:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vu9Bp1zROx15 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Nov 2022 11:22:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 674854B7E7
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 11:22:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667751754;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
 b=WxZKXm8Z+MMHJaJh7i21cPPajvueLZ1t2Zv6RwJLHJ+t46Hl8uFwUNqYkJ9m8pH0MHj1OR
 bdBn/3w3q0q30ANccYb36AyJVKtxD8IS+D3PeotYMsZB7F30sLf6i1aSaPMOWGuSquWnlG
 dl6Dzjails/2PK/pl/ohhAXv9T1KDhM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-c1KGcyvMNACvAHKBSFyMCA-1; Sun, 06 Nov 2022 11:22:32 -0500
X-MC-Unique: c1KGcyvMNACvAHKBSFyMCA-1
Received: by mail-qk1-f199.google.com with SMTP id
 i17-20020a05620a249100b006fa2e10a2ecso8348153qkn.16
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
 b=wUdUVZY+B+lsZvemN6SzegycYIBtazKDGMH/YmIUtWPEr/JJm7O3V/YTsBwL8CufLa
 JyaRSTnty7E67aA+0b9oWOdiTJ07jO7UpuXS/6SvQmq6YjIxXv+kmyCo/C+tqj232WXO
 x3L+nx4glViUHvX+sfyEqmzNsdPzjqgt0jOPeOCRQfh9Vmlr+EQdfOWzjJSfJrPhbq/w
 QrkpyH3oH0+2+J5YqT5TyethlcA/LOy+KjeSNuy3c4qqF25yjCtGRoFCfkqIQ7UKcSf4
 dNZtrRxlQR9aUq8S9XF9e9gwrFR8Rb/5J9uFQs0q7XLveXMt6BC8IW5UsXwg53tNd6Q5
 czpw==
X-Gm-Message-State: ACrzQf0y+b/22yi48koRIhASQ0v9CKG/36h5T23ZoExmMx8ii1WW/Knj
 4j2xYzzdS8XmGgvrTlBbslSRmuOQiESoN4ybKTMtykedBH7wBGjATKco+FO8/jhrgvvVaT6EoGB
 aYShztT29frZozQspwZD+B6fH
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id
 k4-20020ad45be4000000b004bbe947c664mr35673916qvc.122.1667751752348; 
 Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4qXfWU3rRVYOMwffAULeycyo0cR3quhzthJX0gEGzox/PFp3S4akUblLJhi8FVLsZsWmuQug==
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id
 k4-20020ad45be4000000b004bbe947c664mr35673894qvc.122.1667751752071; 
 Sun, 06 Nov 2022 08:22:32 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 x18-20020a05620a259200b006e42a8e9f9bsm4650486qko.121.2022.11.06.08.22.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 06 Nov 2022 08:22:31 -0800 (PST)
Date: Sun, 6 Nov 2022 11:22:29 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ffRYoqlQOxgVtk@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87o7tkf5re.wl-maz@kernel.org>
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

Hi, Marc,

On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > +Note that the bitmap here is only a backup of the ring structure, and
> > +normally should only contain a very small amount of dirty pages, which
> 
> I don't think we can claim this. It is whatever amount of memory is
> dirtied outside of a vcpu context, and we shouldn't make any claim
> regarding the number of dirty pages.

The thing is the current with-bitmap design assumes that the two logs are
collected in different windows of migration, while the dirty log is only
collected after the VM is stopped.  So collecting dirty bitmap and sending
the dirty pages within the bitmap will be part of the VM downtime.

It will stop to make sense if the dirty bitmap can contain a large portion
of the guest memory, because then it'll be simpler to just stop the VM,
transfer pages, and restart on dest node without any tracking mechanism.

[1]

> 
> > +needs to be transferred during VM downtime. Collecting the dirty bitmap
> > +should be the very last thing that the VMM does before transmitting state
> > +to the target VM. VMM needs to ensure that the dirty state is final and
> > +avoid missing dirty pages from another ioctl ordered after the bitmap
> > +collection.
> > +
> > +To collect dirty bits in the backup bitmap, the userspace can use the
> > +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
> > +and its behavior is undefined since collecting the dirty bitmap always
> > +happens in the last phase of VM's migration.
> 
> It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
> you have multiple devices that dirty the memory, such as multiple
> ITSs, why shouldn't userspace be allowed to snapshot the dirty state
> multiple time? This doesn't seem like a reasonable restriction, and I
> really dislike the idea of undefined behaviour here.

I suggested the paragraph because it's very natural to ask whether we'd
need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
be helpful as a reference to answer that.

I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
as fundamentally clear log is about re-protect the guest pages, but if
we're with the restriction of above (having the dirty bmap the last to
collect and once and for all) then it'll make no sense to protect the guest
page at all at this stage since src host shouldn't run after the GET_LOG
then the CLEAR_LOG will be a vain effort.

I used "undefined" here just to be loose on the interface, also a hint that
we should never do that for this specific GET_LOG.  If we want, we can
ignore CLEAR_LOG in the future with ALLOW_BITMAP, and the undefined also
provides the flexibility, but that's not really that important.

The wording could definitely be improved, or maybe even avoid mentioning
the CLEAR_LOG might help, but IIUC the major thing to reach the consensus
is not CLEAR_LOG itself but on whether we can have that assumption [1] and
whether such a design of using dirty bmap is acceptable in general.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
