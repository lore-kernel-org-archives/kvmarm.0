Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F804C2B9F7
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 11:54:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C6C36128B
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 11:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C6C36128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28BB404F8;
	Wed, 26 May 2021 07:53:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QlaaA-CxVcdW; Wed, 26 May 2021 07:53:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A505E4A4A3;
	Wed, 26 May 2021 07:53:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3373349F92
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 07:53:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VO7xj1LHZXFw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 07:53:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F519404F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 07:53:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622030036;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=J4tfG3Iivr0UDU/243VjSMS2UCgnXJX6AdyOu5WgiuE=;
 b=PepEzagc5d/caNfCIpX6LBJRnxCa8SdMosTmSQd//fELCvLn3hEykomlWJqanA9nf2qpx/
 VvDI0qQg+62iHaRR8jL0iIuDfdB73Bk6Vbs6GER1ODysGLyz324ZgMoCQ60dqr4DXIE27A
 NesIC523jnkUO/tEasKGL/UNNdqv9H4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-lJ7XyFXjOxa4bjxkxBqh6w-1; Wed, 26 May 2021 07:53:54 -0400
X-MC-Unique: lJ7XyFXjOxa4bjxkxBqh6w-1
Received: by mail-ed1-f70.google.com with SMTP id
 w22-20020a05640234d6b029038d04376b6aso400351edc.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 04:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J4tfG3Iivr0UDU/243VjSMS2UCgnXJX6AdyOu5WgiuE=;
 b=NQoEjhoe5OT8GAjEWdXY8sGpSF/pGwil1Gm446M/uQBSRqSUPRhsN3pQE3ErWfmudc
 qEh+SWO1vkruHMt4ORt9M3nEImURsrtqLNRvxPkOUxinptxk9edeKq+cCIxIrNmHxwuF
 b9xRuj3iY+4jvNvm3MeiBGkpgZvbz3x+8XROL2DAjxOJUtbelkpkAA8MISjZr2KQrlus
 FyzmHaNx3RSGdGkld55lORzcuHtzielzsAiXYd0hGDBD3tdubyf9Gmg7GseC43OSlIZF
 dWgJfCdcc7zbiSDn4NrEAWeR0Q3R/PmdtT0KmrsPfrumXmBinIEi4mW5xZPZLh37v4pA
 GDkg==
X-Gm-Message-State: AOAM5310CPeY294WMYmfRjlnhdFwZBrzxqb5T4D6n4twEveG5DZX8WQS
 c4hz8iX+lSaXaiPcy3hoOe0cHiaNpNQtQxf+rRzOtnlS2BIUP9mtkbUnrDdOAaTdTmcRr3nyet1
 F2veMy0lYClonRFHFTqchc/AC
X-Received: by 2002:a17:906:e0d5:: with SMTP id
 gl21mr33494699ejb.93.1622030033169; 
 Wed, 26 May 2021 04:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxt8+d1iX+DqR1qPCPmxp6q8NikFchjRljNvew5YHy3SdlULrSNFp6cnmOS2D/UnyGUZ2Y1FA==
X-Received: by 2002:a17:906:e0d5:: with SMTP id
 gl21mr33494666ejb.93.1622030032758; 
 Wed, 26 May 2021 04:53:52 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id n24sm12465472edv.51.2021.05.26.04.53.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 May 2021 04:53:52 -0700 (PDT)
Date: Wed, 26 May 2021 13:53:50 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <20210526115350.t72q34km2wyxtmpn@gator.home>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com> <87zgwhvq7r.wl-maz@kernel.org>
 <20210526093211.loppoo42twel6inw@gator.home>
 <87y2c1vm1m.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87y2c1vm1m.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, May 26, 2021 at 11:15:01AM +0100, Marc Zyngier wrote:
> On Wed, 26 May 2021 10:32:11 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Wed, May 26, 2021 at 09:44:56AM +0100, Marc Zyngier wrote:
> > > On Tue, 25 May 2021 21:09:22 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
> > > > > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > > > > userspace when not available") the get-reg-list* tests have been
> > > > > failing with
> > > > > 
> > > > >   ...
> > > > >   ... There are 74 missing registers.
> > > > >   The following lines are missing registers:
> > > > >   ...
> > > > > 
> > > > > where the 74 missing registers are all PMU registers. This isn't a
> > > > > bug in KVM that the selftest found, even though it's true that a
> > > > > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > > > > flag, but still expecting the PMU registers to be in the reg-list,
> > > > > would suddenly no longer have their expectations met. In that case,
> > > > > the expectations were wrong, though, so that KVM userspace needs to
> > > > > be fixed, and so does this selftest. The fix for this selftest is to
> > > > > pull the PMU registers out of the base register sublist into their
> > > > > own sublist and then create new, pmu-enabled vcpu configs which can
> > > > > be tested.
> > > > > 
> > > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > > ---
> > > > >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> > > > >  1 file changed, 38 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > index dc06a28bfb74..78d8949bddbd 100644
> > > > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > > @@ -47,6 +47,7 @@ struct reg_sublist {
> > > > >  struct vcpu_config {
> > > > >  	const char *name;
> > > > >  	bool sve;
> > > > > +	bool pmu;
> > > > >  	struct reg_sublist sublists[];
> > > > >  };
> > > > 
> > > > I think it's possible that the number of sublists keeps increasing: it
> > > > would be very nice/useful if KVM allowed enabling/disabling more
> > > > features from userspace (besides SVE, PMU etc).
> > > 
> > > [tangential semi-rant]
> > > 
> > > While this is a very noble goal, it also doubles the validation space
> > > each time you add an option. Given how little testing gets done
> > > relative to the diversity of features and implementations, that's a
> > > *big* problem.
> > 
> > It's my hope that this test, especially now after its refactoring, will
> > allow us to test all configurations easily and therefore frequently.
> > 
> > > 
> > > I'm not against it for big ticket items that result in a substantial
> > > amount of state to be context-switched (SVE, NV). However, doing that
> > > for more discrete features would require a radical change in the way
> > > we develop, review and test KVM/arm64.
> > >
> > 
> > I'm not sure I understand how we should change the development and
> > review processes.
> 
> I'm worried that the current ratio of development vs review vs testing
> is simply not right. We have a huge reviewing deficit, and we end-up
> merging buggy code. Some of the features we simply cannot test. It was
> OK up to 3 years ago, but I'm not sure it is sustainable anymore.
> 
> So making more and more things optional seems to go further in the
> direction of an uncontrolled bitrot.

I guess the optional CPU features are just going to keep on coming. And,
while more reviewers would help, there will never be enough. I think the
only solution is to get more CI.

> 
> > As for testing, with simple tests like this one,
> > we can actually achieve exhaustive configuration testing fast, at
> > least with respect to checking for expected registers and checking
> > that we can get/set_one_reg on them. If we were to try and setup
> > QEMU migration tests for all the possible configurations, then it
> > would take way too long.
> 
> I'm not worried about this get/set thing. I'm worried about the full
> end-to-end migration, which hardly anyone tests in anger, with all the
> variability of the architecture and options.

It does get tested downstream, but certain configurations will likely
be neglected. For example, we've rarely, if ever, tested with the PMU
disabled. Also, testing downstream is a bit late. It'd be better if
tests were running on upstream branches, before even being merged to
master.

As for testing migration of devices other than the CPU, we do have
some QEMU unit tests for that which gate merger to QEMU master.

Anyway, while unit tests like this one may seem too simple to be useful,
assuming the tests mimic key parts of the fully integrated function, and
are run frequently, then they may catch regressions sooner, even during
development. The less frequently run integrated tests which happen later,
and with limited configs, may then be sufficient.

BTW, kvm-unit-tests can also test migrations. The VM configs are limited,
but CPU feature combinations could be tested thoroughly without too
much difficulty. That would at least include QEMU in the integration
testing, but unless we modify the tests to migrate between hosts with
different kernel versions (it's nice to try and support older -> newer),
then we're not testing the same type of thing that we're testing here with
this test.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
