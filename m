Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E81BC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 07:35:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14C2661027
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 07:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14C2661027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92F4E4B1CB;
	Mon, 13 Sep 2021 03:35:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9G09efS5Qa7A; Mon, 13 Sep 2021 03:35:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D38F4B163;
	Mon, 13 Sep 2021 03:35:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51EFD4B163
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 03:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sH+VrJFu0clz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 03:35:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 756B54A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 03:35:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631518520;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=txB9+Bj+JLchSp76fL8uLRsQPIdKrDGsk0rjMYnMz1Q=;
 b=O4m9h3kxAOsq+rpNGTuKs8uZ2LjRJvr6MQTU8U8nCqIfByznZiCIs9wgkXj1LUEDKESC+/
 rhi57Z/NZ1oM9qo7sKVlP6P5Mh7M28xNawmKZQcActRHrP+7juO3JKKFcZqYoy/FLLzfTd
 Zc4pl9nU4ngZWI+UKKbhgXp2A3DYK8A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-061HHRovNzCn7ib82VvD2g-1; Mon, 13 Sep 2021 03:35:16 -0400
X-MC-Unique: 061HHRovNzCn7ib82VvD2g-1
Received: by mail-ed1-f70.google.com with SMTP id
 h15-20020aa7de0f000000b003d02f9592d6so4106001edv.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 00:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=txB9+Bj+JLchSp76fL8uLRsQPIdKrDGsk0rjMYnMz1Q=;
 b=HHGy1WU7J3nkO450yb47fkanm8lejQpzP2nkoKSS1xuDgVkvew2uQI6A9ttyyuYeKg
 wZKDMQp452b8lbV7xXpMegmw567K+y0THLQvpBmvrNX5hk+WXkrD7RhIrQykMNQe+qaM
 +74lr3XMxHNgazeIOHr/+EVvTMIEzvPLHnLEKEouCITG+n0PD/7FyEsx8lspfqUsx5Zr
 uMAdnjfmre4t9fk4p5+1rEJ+8GMFKcv4vaPzfSfokP8WF0IpjIxd4wQfGrWpc3MBfXxG
 mM5LJKnkD/lZbox+TuYpmKhfifxn4Y0c+DeyVfYHjioXvrEb5GRoaFYEIgUGd/19wVqZ
 8LzA==
X-Gm-Message-State: AOAM532EWMEby/3PdKba8J+KFsJ+FALBXLqt+DCHhNWBVBaEhDfo8WhD
 liBp/fdJl/Q8EaPqKfVcB+TBcQ0RY5WGsDArYJAFMVkjzRJuXNbskniO1KdERZXfyPzu+lGF3jP
 uKajYH24F7p3dz1FAFCsuoWD8
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr11894384eds.27.1631518515108; 
 Mon, 13 Sep 2021 00:35:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVgB6s5bJyAZu+VmEyjboOiIjrZIP1yaryEsV7Gwlmg0qg2QOLW//vgArN2DC67y9ypKSyXA==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr11894369eds.27.1631518514975; 
 Mon, 13 Sep 2021 00:35:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i6sm2978691ejd.57.2021.09.13.00.35.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 00:35:14 -0700 (PDT)
Date: Mon, 13 Sep 2021 09:35:12 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210913073512.x774i5hi3s4wmopx@gator.home>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Sun, Sep 12, 2021 at 12:05:22AM -0700, Reiji Watanabe wrote:
> Hi Raghu and all,
> 
> On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > At times, such as when in the interrupt handler, the guest wants
> > to get the vcpuid that it's running on. As a result, introduce
> > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > initialization and exports the map to the guest for it to read.
> 
> How about using TPIDR_EL1 to hold the vcpuid ?
> i.e. have aarch64_vcpu_setup() set the register to vcpuid and
> guest_get_vcpuid() simply return a value of the register.
> This would be a simpler solution to implement.

That is a great suggestion. It's arch-specific, but maybe the
other architectures can mimic it with their own capabilities.
And, in the unlikely event a unit test wants that register for
itself, then it can build its own mpidr-vcpuid map if necessary.
Ship it :-)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
