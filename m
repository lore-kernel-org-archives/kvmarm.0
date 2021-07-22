Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C9FC63797
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 13:25:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C64861289
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 13:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C64861289
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130424B085;
	Thu, 22 Jul 2021 09:25:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qAyKbikIMndZ; Thu, 22 Jul 2021 09:25:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E85B04B0AD;
	Thu, 22 Jul 2021 09:25:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DDDF4B085
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 09:25:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pmIxSTsS8zBf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 09:25:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB524A418
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 09:25:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626960320;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=JAnmeuIfQdncCUiW75D8IzEpkqgkah2ZNrMDpLBYjTo=;
 b=iLlI69Nmr/bfh+f/nL4Jl2NViZ7djwp10TLqaUW2YNfMGymStQd/x/pCCweC3401OZSrZy
 5H4Xh4q2bKCMbvckuCm+Ox/l+N1u+Uu5fhzsmfXvJ5QqKlZcn1l40q3+70LtJJi1d098Yz
 W2I5dLbpJn3Hi2R4Kh0T99xrtAq0nC4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-JT-IgQk0N7OhHpysWC019w-1; Thu, 22 Jul 2021 09:25:19 -0400
X-MC-Unique: JT-IgQk0N7OhHpysWC019w-1
Received: by mail-il1-f200.google.com with SMTP id
 b8-20020a92c8480000b0290208fe58bd16so3584978ilq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 06:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JAnmeuIfQdncCUiW75D8IzEpkqgkah2ZNrMDpLBYjTo=;
 b=ox6SPTEeqesCWrInpjvRzXD+2MSmtzIpq6xX5nQIeFyYDu+zox2PTZJCg0qnKnv7xz
 lxhT2h5I2ZNfYxaU6DxwTffacktoT3KH8cCA1vQinyia1mo9FCRWH/EKS/0beMLOPLLE
 vcrGnm4hugA/8eXxD+soNAubzY/nri4LAifvV2EulAOqHXS/hggKuM/ha+YF8E/jiW/e
 aOTXB5vXN/vHbpblk67gh8vGexGCdeUldKN5ZoHFQLAI+c75iU1m0G2w93hBg+B4IXqZ
 Gxm+umhKJg91nk6PYdC13h8kkMQ9tE2tC27f4YrvmPQz5XpYb7NU3jcN2Sd9MO6gzyny
 uTjw==
X-Gm-Message-State: AOAM533aliLvYF4pZ+WoRLXF7r83VenLuUG+TRrjTS48RWkisfJTkDR2
 MO7/gY1oURTfEyl5AHT4JOU3hKT+t1Zx1VTlG3Jj/CRgZedtEOr4KAackkb3sKnjghtnVrhw9VU
 4z1uD3MtXpzWf51K7hnURQvLT
X-Received: by 2002:a6b:f101:: with SMTP id e1mr17328424iog.118.1626960318897; 
 Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO7B6+/GK3ldKKhKw6OpJsBYn9h5NNBp2v0iNDfsc4BXVWjBxmWixYMqcWppyKDhuCURsoJA==
X-Received: by 2002:a6b:f101:: with SMTP id e1mr17328405iog.118.1626960318688; 
 Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id z6sm14874865ilz.54.2021.07.22.06.25.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
Date: Thu, 22 Jul 2021 15:25:15 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 00/16] KVM: arm64: MMIO guard PV services
Message-ID: <20210722132515.y66qi23r6ty3anax@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210721214243.dy6d644yznuopuqx@gator>
 <874kcm3byd.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <874kcm3byd.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, will@kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kernel-team@android.com,
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

On Thu, Jul 22, 2021 at 11:00:26AM +0100, Marc Zyngier wrote:
> On Wed, 21 Jul 2021 22:42:43 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:43PM +0100, Marc Zyngier wrote:
> > > KVM/arm64 currently considers that any memory access outside of a
> > > memslot is a MMIO access. This so far has served us very well, but
> > > obviously relies on the guest trusting the host, and especially
> > > userspace to do the right thing.
> > > 
> > > As we keep on hacking away at pKVM, it becomes obvious that this trust
> > > model is not really fit for a confidential computing environment, and
> > > that the guest would require some guarantees that emulation only
> > > occurs on portions of the address space that have clearly been
> > > identified for this purpose.
> > 
> > This trust model is hard for me to reason about. userspace is trusted to
> > control the life cycle of the VM, to prepare the memslots for the VM,
> > and [presumably] identify what MMIO ranges are valid, yet it's not
> > trusted to handle invalid MMIO accesses. I'd like to learn more about
> > this model and the userspace involved.
> 
> Imagine the following scenario:
> 
> On top of the normal memory described as memslots (which pKVM will
> ensure that userspace cannot access),

Ah, I didn't know that part.

> a malicious userspace describes
> to the guest another memory region in a firmware table and does not
> back it with a memslot.
> 
> The hypervisor cannot validate this firmware description (imagine
> doing ACPI and DT parsing at EL2...), so the guest starts using this
> "memory" for something, and data slowly trickles all the way to EL0.
> Not what you wanted.

Yes, I see that now, in light of the above.

> 
> To ensure that this doesn't happen, we reverse the problem: userspace
> (and ultimately the EL1 kernel) doesn't get involved on a translation
> fault outside of a memslot *unless* the guest has explicitly asked for
> that page to be handled as a MMIO. With that, we have a full
> description of the IPA space contained in the S2 page tables:
> 
> - memory described via a memslot,
> - directly mapped device (GICv2, for exmaple),
> - MMIO exposed for emulation
> 
> and anything else is an invalid access that results in an abort.
> 
> Does this make sense to you?

Now I understand better, but if we're worried about malicious userspaces,
then how do we protect the guest from "bad" MMIO devices that have been
described to it? The guest can request access to those using this new
mechanism.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
