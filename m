Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86165C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:10:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F04BE611C0
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F04BE611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B89D4B166;
	Fri, 10 Sep 2021 04:10:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vQ0vWNflCy1V; Fri, 10 Sep 2021 04:10:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D7B4B167;
	Fri, 10 Sep 2021 04:10:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C22B04B164
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:10:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jv9ajgJY5NKC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 04:10:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECB84B163
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:10:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631261406;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=04dg9eLo5DobwnbTP7RmzFwFoUSaWkodvk2ic+H8548=;
 b=LItJBSy3DHmwpkZiTV8nTOaBEjmbjBx0MM7KbZrNZMAez1LrJIGSPPcqEHbwiV8aeJyN5g
 kHpSk6RZdlMFc4q2syUlTgELQewXUazzSyz+cwJIKNPrSue0+00Gd0zaPEQ8RFxRcv4ky8
 S6AQE+ufAUYsv0K5Ts66rbsL+Wix1LI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-jGuxmta2PQyTR_QrDLh7PQ-1; Fri, 10 Sep 2021 04:10:05 -0400
X-MC-Unique: jGuxmta2PQyTR_QrDLh7PQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 y23-20020a05600c365700b003015b277f98so67743wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 01:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=04dg9eLo5DobwnbTP7RmzFwFoUSaWkodvk2ic+H8548=;
 b=D2XMm9cgDrmhAb4ev+S2+iOoRuHkR+3zpAzZzvGNBx6OHOYXv81IwPo57fTvDCKwPT
 rrA+yCuT+VtvesoORVWdm2TVRy7CivFWhKiKUkxXmkZyV3/9s8ub+IulAKE3bwqz4zcz
 V1aWQzj45dso94chod8QdCc8xRVcJLihgBHYocUaFaBocuJ2J1oj5d5P7yIpyF6cgo25
 krruvwL96DITe7l9A9cr+/+nWqXGMhamisg6X3pLC1LU3HuO2Tf2zUNQDMrcLDsfw5pI
 h4GBtp2JKb+cDvTvrT1DK92xOPcQsSeiAtW30r9YClAVJTRbX9DqTMP6eQL/F29Yx4a0
 gnbw==
X-Gm-Message-State: AOAM532WjhhsXbxsqyIB+Fs46QkXliP1h6VKqeyAkalwyufvQ/416ibr
 bRmQo7kAZwkduatfUIhjWEl1L3qtZMMTSTNXkGVjRv51PlyrxXFz5zRcLcD5vpu9GwBH3BZVQFx
 2H2F5MazYRkx5evelFEGZpqI0
X-Received: by 2002:a05:600c:3b0e:: with SMTP id
 m14mr7171007wms.118.1631261403851; 
 Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznq/1Zr/LhNYqj/gZ4OdPBVawbvoIodEWaQXNr0cQS5ZYlI1VWvjYdpXqwAPwN0hOtTSUxVw==
X-Received: by 2002:a05:600c:3b0e:: with SMTP id
 m14mr7170994wms.118.1631261403703; 
 Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id j7sm322322wrr.27.2021.09.10.01.10.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
Date: Fri, 10 Sep 2021 10:10:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210910081001.4gljsvmcovvoylwt@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
 <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Thu, Sep 09, 2021 at 10:10:56AM -0700, Raghavendra Rao Ananta wrote:
> On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
...
> > > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > > +             vcpuid = vcpuid_map[i].vcpuid;
> > > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> >
> > We don't want this assert if it's possible to have sparse maps, which
> > it probably isn't ever going to be, but...
> >
> If you look at the way the array is arranged, the element with
> VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
> elements would lie before this. So, I don't think we'd have a sparse
> array here.

If we switch to my suggestion of adding map entries at vcpu-add time and
removing them at vcpu-rm time, then the array may become sparse depending
on the order of removals.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
