Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3101CC2B9F7
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 09:32:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92DF26117A
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 09:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92DF26117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5BA4A49C;
	Wed, 26 May 2021 05:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hx3BFm-t5NOx; Wed, 26 May 2021 05:32:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D125D4A3B4;
	Wed, 26 May 2021 05:32:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C62C44A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 05:32:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7gFGx9Dyw7cB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 05:32:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5AC84A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 05:32:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622021537;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=z0QEwaUio+l4PhkxpW6dJzymlevSAwmMq8o5++mT+tA=;
 b=h+mHZFzoN/k51A1ca4vKQ/5RbvewiuL7DkucU14qi9F1nEKkHyOk6t8cVveaswUcPAF8z7
 n63NGmLb+knHnWEIPLyMwvHxwGEK8wmufRnkbr2tawP7c8rYxoK1VkXxbryPPkgeQ/EQyE
 rJeZaVYdzzEsoTxD3R9mjnENHwBuvbA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-7Zx4bg8-MpyB4eUTsUAhEQ-1; Wed, 26 May 2021 05:32:15 -0400
X-MC-Unique: 7Zx4bg8-MpyB4eUTsUAhEQ-1
Received: by mail-ej1-f71.google.com with SMTP id
 j16-20020a1709062a10b02903ba544485d0so231941eje.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 02:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=z0QEwaUio+l4PhkxpW6dJzymlevSAwmMq8o5++mT+tA=;
 b=lDoDhjoJ2VJPr8dVK+I1WRRIyEKLLEdwQlmkfsuRk31c+7lzziq4r68c+GV1DuH6CU
 qY+tV33E2b/8Qu6cXDzi4QEMmabi8vyNfyBp+dbqqzaCfxDKPYXSldgBaJxc3/2oObAz
 bODl/23NDXr1DA/4V2ga2vMzs/cWKILQ6/YVbU/frm/6FIE8z62j5gJo2GkcVnvYuUDI
 pzJqNcqDWba828XCqPyrWLQa4Sc0vn0czJdUNDky/01fXlUmeuZJMJnk3BHaiLb6z1Ba
 6Hz1qNJ7eDY8cFAjyYNlwOatQUOBg0zxW6jwBQxMk5t/B7VQrNy3HdEh6IQa+T3IffxP
 V+Cg==
X-Gm-Message-State: AOAM533PSeWzFn5uSj7hNLCezm20WFzXBFh1vQ+kcUNcZ4k/0trW9iUh
 L42mJmu+4r0z6zlpTSgLb1vKxQ2J8Z5s5TQLy7+8JNnZwOg5sZb0S63Sz1C6B72wA5ZxwWB26c/
 dgO7kw5OmXukmIIZQkSjflRTE
X-Received: by 2002:aa7:cfcd:: with SMTP id r13mr36849863edy.177.1622021534480; 
 Wed, 26 May 2021 02:32:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPhQgu+2Xa4WvCvZ9JhZjf/o7+Rz7zOlbTCKXBmJU13BofbOV20+LAx3eU4Sorf/UglLOV4w==
X-Received: by 2002:aa7:cfcd:: with SMTP id r13mr36849841edy.177.1622021534250; 
 Wed, 26 May 2021 02:32:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id c10sm12168911eds.90.2021.05.26.02.32.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 May 2021 02:32:13 -0700 (PDT)
Date: Wed, 26 May 2021 11:32:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <20210526093211.loppoo42twel6inw@gator.home>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com> <87zgwhvq7r.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87zgwhvq7r.wl-maz@kernel.org>
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

On Wed, May 26, 2021 at 09:44:56AM +0100, Marc Zyngier wrote:
> On Tue, 25 May 2021 21:09:22 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
> > > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > > userspace when not available") the get-reg-list* tests have been
> > > failing with
> > > 
> > >   ...
> > >   ... There are 74 missing registers.
> > >   The following lines are missing registers:
> > >   ...
> > > 
> > > where the 74 missing registers are all PMU registers. This isn't a
> > > bug in KVM that the selftest found, even though it's true that a
> > > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > > flag, but still expecting the PMU registers to be in the reg-list,
> > > would suddenly no longer have their expectations met. In that case,
> > > the expectations were wrong, though, so that KVM userspace needs to
> > > be fixed, and so does this selftest. The fix for this selftest is to
> > > pull the PMU registers out of the base register sublist into their
> > > own sublist and then create new, pmu-enabled vcpu configs which can
> > > be tested.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> > >  1 file changed, 38 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > index dc06a28bfb74..78d8949bddbd 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > @@ -47,6 +47,7 @@ struct reg_sublist {
> > >  struct vcpu_config {
> > >  	const char *name;
> > >  	bool sve;
> > > +	bool pmu;
> > >  	struct reg_sublist sublists[];
> > >  };
> > 
> > I think it's possible that the number of sublists keeps increasing: it
> > would be very nice/useful if KVM allowed enabling/disabling more
> > features from userspace (besides SVE, PMU etc).
> 
> [tangential semi-rant]
> 
> While this is a very noble goal, it also doubles the validation space
> each time you add an option. Given how little testing gets done
> relative to the diversity of features and implementations, that's a
> *big* problem.

It's my hope that this test, especially now after its refactoring, will
allow us to test all configurations easily and therefore frequently.

> 
> I'm not against it for big ticket items that result in a substantial
> amount of state to be context-switched (SVE, NV). However, doing that
> for more discrete features would require a radical change in the way
> we develop, review and test KVM/arm64.
>

I'm not sure I understand how we should change the development and
review processes. As for testing, with simple tests like this one,
we can actually achieve exhaustive configuration testing fast, at
least with respect to checking for expected registers and checking
that we can get/set_one_reg on them. If we were to try and setup
QEMU migration tests for all the possible configurations, then it
would take way too long.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
