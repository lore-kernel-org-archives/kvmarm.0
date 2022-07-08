Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9957C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jul 2022 13:58:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2274A4B5BD;
	Fri,  8 Jul 2022 09:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8X7VL-tAud0W; Fri,  8 Jul 2022 09:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D0740FD6;
	Fri,  8 Jul 2022 09:58:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A84364B765
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 09:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VtSm7pxStYIz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 09:58:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576164B736
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 09:58:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657288698;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DkINNwNj/wvMhz9e5/8WZEdU3d3i4BXmoSion7M+nwg=;
 b=Jrk0P2WhZsRj65XheLM9MApi7X2GAhQ4XGFGbDzkzF7eo9v+kx4JTSXKIAx8XmmAydsHCZ
 XPSgxF0v+1sX4mj+NXACcH0kP16zrUBUTe4MYPbhDQJdvtlLAMB8qN2z3cHPWuURwvGhyE
 CJyHsOUleEfsc9epm9K4DJhciZ5p3vo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-rP_DfADkOJ2sDXu2R9Txgg-1; Fri, 08 Jul 2022 09:58:15 -0400
X-MC-Unique: rP_DfADkOJ2sDXu2R9Txgg-1
Received: by mail-qt1-f199.google.com with SMTP id
 f14-20020ac8068e000000b0031e899fabdcso9882477qth.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jul 2022 06:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DkINNwNj/wvMhz9e5/8WZEdU3d3i4BXmoSion7M+nwg=;
 b=WH5mp7E0jEr1mdHJ9unvr0riLpAnIfbTMWsD7xHsjKzz7x/LjsdoSu23sONTZ3a2vK
 NejwdGB6E4umSLHvV46F8LoyYvbE7dzkyzN0Tiy1YuYX3TKlUbDWAw+HLXPyMEI2YVjC
 UJwfTIXEuSb6JhQlcxUIvoWqBtw+3IsRO4S6zcRnyh9wDNQrn8Sz3Sukg6C/PdYTMvMU
 XdE1OFmGdQa1w4swJz+VAJehUxdeyZYcOyZBjh8ly49FrnQxs6sWe+B8JiMB/j75UBEr
 7XCHlZN6X0tUMu2VtSlucEqhofljxiNIpqzxTf4WHh/nimQuFUjTTEp6cQ+QWolf48+A
 Mepw==
X-Gm-Message-State: AJIora9oNtFsBEDNmAgVL+e4ZFtPioDHzBlG+Wc04zRoLiogNg4dR+6F
 bS/bw/8ZxOlfBiOL899/E1sqNmslQIn9uR/Ratw8tl+Ml/cLKdRrEDfeP5W7HB3Y+ANb7Rk+jgn
 s1q68RGeh+PinoAjBi8qlhBeE
X-Received: by 2002:a0c:dd11:0:b0:473:34ad:8e06 with SMTP id
 u17-20020a0cdd11000000b0047334ad8e06mr2839866qvk.4.1657288694405; 
 Fri, 08 Jul 2022 06:58:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vxJv/NEyo15Tw1UQuhMw6BYWdDy7KEWS/QMrPgjBkRPoWXy9uvRkJMzNBM4QKpJ3PeU0utMg==
X-Received: by 2002:a0c:dd11:0:b0:473:34ad:8e06 with SMTP id
 u17-20020a0cdd11000000b0047334ad8e06mr2839830qvk.4.1657288694053; 
 Fri, 08 Jul 2022 06:58:14 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
 by smtp.gmail.com with ESMTPSA id
 m14-20020a05620a24ce00b006af59e9ddeasm28327532qkn.18.2022.07.08.06.58.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Jul 2022 06:58:12 -0700 (PDT)
Date: Fri, 8 Jul 2022 09:58:09 -0400
From: Peter Xu <peterx@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <Ysg38XZSzPk8tYwK@xz-m1.local>
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
 <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com> <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com>
 <871qv12hqj.fsf@redhat.com>
 <b91ae197-d191-2204-aab5-21a0aabded69@arm.com>
 <87bktz7o49.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <87bktz7o49.fsf@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Marc Zyngier <maz@kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>,
 Andy Lutomirski <luto@amacapital.net>, Peter Collingbourne <pcc@google.com>,
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

On Fri, Jul 08, 2022 at 03:03:34PM +0200, Cornelia Huck wrote:
> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
> 
> > On 04/07/2022 13:19, Cornelia Huck wrote:
> >> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
> >> 
> >>> On 29/06/2022 09:45, Catalin Marinas wrote:
> >>>> On Mon, Jun 27, 2022 at 05:55:33PM +0200, Cornelia Huck wrote:
> >>>
> >>>>> [Postcopy needs a different interface, I guess, so that the migration
> >>>>> target can atomically place a received page and its metadata. I see
> >>>>> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
> >>>>> has there been any follow-up?]
> >>>>
> >>>> I don't follow the qemu list, so I wasn't even aware of that thread. But
> >>>> postcopy, the VMM needs to ensure that both the data and tags are up to
> >>>> date before mapping such page into the guest address space.
> >>>>
> >>>
> >>> I'm not sure I see how atomically updating data+tags is different from
> >>> the existing issues around atomically updating the data. The VMM needs
> >>> to ensure that the guest doesn't see the page before all the data+all
> >>> the tags are written. It does mean lazy setting of the tags isn't
> >>> possible in the VMM, but I'm not sure that's a worthwhile thing anyway.
> >>> Perhaps I'm missing something?
> >> 
> >> For postcopy, we basically want to fault in any not-yet-migrated page
> >> via uffd once the guest accesses it. We only get the page data that way,
> >> though, not the tag. I'm wondering whether we'd need a 'page+metadata'
> >> uffd mode; not sure if that makes sense. Otherwise, we'd need to stop
> >> the guest while grabbing the tags for the page as well, and stopping is
> >> the thing we want to avoid here.
> >
> > Ah, I think I see now. UFFDIO_COPY atomically populates the (data) page
> > and ensures that no thread will see the partially populated page. But
> > there's currently no way of doing that with tags as well.
> 
> Nod.
> 
> >
> > I'd not looked at the implementation of userfaultfd before and I'd
> > assumed it avoided the need for an 'atomic' operation like this. But
> > apparently not! AFAICT either a new ioctl would be needed (which can
> > take a tag buffer) or a new flag to UFFDIO_COPY which would tighten the
> > alignment requirements of `src` and would copy the tags along with the data.
> 
> I was thinking about a new flag that implies "copy metadata"; not sure
> how we would get the same atomicity with a separate ioctl. I've only
> just started looking at userfaultfd, though, and I might be on a wrong
> track... One thing I'd like to avoid is having something that is too
> ARM-specific, I think there are other architecture features that might
> have similar issues.

Agreed, to propose such an interface we'd better make sure it'll be easily
applicable to other similar memory protection mechanisms elsewhere.

> 
> Maybe someone more familiar with uffd and/or postcopy can chime in?

Hanving UFFDIO_COPY provide a new flag sounds reasonable to me.  I'm
curious what's the maximum possible size of the tags and whether they can
be embeded already into struct uffdio_copy somehow.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
