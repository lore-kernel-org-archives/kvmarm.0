Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE30C48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 07:07:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46E656128C
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 07:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46E656128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AD4407B0;
	Tue, 22 Jun 2021 03:07:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0bnGE0fj2JBd; Tue, 22 Jun 2021 03:07:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3174079A;
	Tue, 22 Jun 2021 03:07:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07EAB406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:07:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BNeYy6ZNjJBI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 03:07:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165ED402C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:07:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624345657;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=BpxLvUdEN4UOwGk1JTOpTM4c5SQrD6XCtpiY9c/D+sc=;
 b=EIYBMf+rG8kVVz4uIswDKQsu9Ix+kOXBbqGDNutUMqr35oa+dslmrOyCwnGh7ZrXLCwYYV
 Tbx4vpOf1TKXFJvMfqLRD44jKCLkOeQTPGcuzQk+hnKezJwSaSFm1GPXkDcax/ZLVQ9Hn5
 BVf/Um45QSJ2WqBQQNkVKrTGi3GjdHI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-d-7eJTf0NMCXbAgVZv4tFg-1; Tue, 22 Jun 2021 03:07:36 -0400
X-MC-Unique: d-7eJTf0NMCXbAgVZv4tFg-1
Received: by mail-ed1-f70.google.com with SMTP id
 t11-20020a056402524bb029038ffacf1cafso8976601edd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 00:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BpxLvUdEN4UOwGk1JTOpTM4c5SQrD6XCtpiY9c/D+sc=;
 b=mG+r7wy35OzvdeliA/A34L/HTnYoT76I4jybqsXt580kkkoELgKo68RsgYyQt8/KQt
 twPAorUZIbo2ts5gfHI6uKQnTAPe5ft3tzXovePsuMxGmtZxEmaSFAFxsEn0RVGXgVYJ
 YhDFMsB17R2DuHMw92KSgFBkDYuWK2/24YtNC3VbnVgekpFzHjbayZebPaYzZEuwFkoG
 k1lFgud6M1Ee0YlSRqho/ne5/XdngoEtqFOsI1rz5BSWCEgsNfYOoKgIKrJlXcHqp+NW
 YS2qCbe8/mXz33gTQqXTGlr+/SYBNS07PWeTJQK9ZiKEtQ3ZLt4JWUmjWnG9sO2M4oH1
 WePg==
X-Gm-Message-State: AOAM5321g2SderQmkYKWxut0uB1dq+zKI52/rBmF8YTi6VPzF/Oy3TWV
 vj3LoyTouolONs/Qdj/jEeBd7RiW8ifONTqPHVPja58mhbq2vgEP/Uh9DDOW8wb3NUC6eMcGBhV
 1jZk9jzIO7g3sp0CGFdMKO+tM
X-Received: by 2002:a17:906:670c:: with SMTP id
 a12mr2323242ejp.249.1624345655076; 
 Tue, 22 Jun 2021 00:07:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIRL7kFdSnYi6ayAi9cWByQS1oJPIkRm7y2jVnBDl937Rh9GVFkpzhNuSsQPogXJRPDSPj+A==
X-Received: by 2002:a17:906:670c:: with SMTP id
 a12mr2323214ejp.249.1624345654861; 
 Tue, 22 Jun 2021 00:07:34 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id h20sm5416875ejl.7.2021.06.22.00.07.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Jun 2021 00:07:34 -0700 (PDT)
Date: Tue, 22 Jun 2021 09:07:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 0/5] KVM: arm64: selftests: Fix get-reg-list
Message-ID: <20210622070732.zod7gaqhqo344vg6@gator>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, pbonzini@redhat.com
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

On Mon, May 31, 2021 at 12:33:39PM +0200, Andrew Jones wrote:
> v3:
>  - Took Ricardo's suggestions in order to avoid needing to update
>    prepare_vcpu_init, finalize_vcpu, and check_supported when adding
>    new register sublists by better associating the sublists with their
>    vcpu feature bits and caps [Ricardo]
>  - We now dynamically generate the vcpu config name by creating them
>    from its sublist names [drew]
> 
> v2:
>  - Removed some cruft left over from a previous more complex design of the
>    config command line parser
>  - Dropped the list printing factor out patch as it's not necessary
>  - Added a 'PASS' output for passing tests to allow testers to feel good
>  - Changed the "up to date with kernel" comment to reference 5.13.0-rc2
> 
> 
> Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> userspace when not available") the get-reg-list* tests have been
> failing with
> 
>   ...
>   ... There are 74 missing registers.
>   The following lines are missing registers:
>   ...
> 
> where the 74 missing registers are all PMU registers. This isn't a
> bug in KVM that the selftest found, even though it's true that a
> KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> flag, but still expecting the PMU registers to be in the reg-list,
> would suddenly no longer have their expectations met. In that case,
> the expectations were wrong, though, so that KVM userspace needs to
> be fixed, and so does this selftest.
> 
> We could fix the test with a one-liner since we just need a
> 
>   init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> 
> in prepare_vcpu_init(), but that's too easy, so here's a 5 patch patch
> series instead :-)  The reason for all the patches and the heavy diffstat
> is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
> With the refactoring done in this series, we should now be able to easily
> add register sublists and vcpu configs to the get-reg-list test, as the
> last patch demonstrates with the pmu fix.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (5):
>   KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
>   KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
>     at once
>   KVM: arm64: selftests: get-reg-list: Provide config selection option
>   KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
>   KVM: arm64: selftests: get-reg-list: Split base and pmu registers
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 -
>  tools/testing/selftests/kvm/Makefile          |   1 -
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
>  .../selftests/kvm/aarch64/get-reg-list.c      | 439 +++++++++++++-----
>  4 files changed, 321 insertions(+), 123 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> 
> -- 
> 2.31.1
>

Gentle ping.

I'm not sure if I'm pinging Marc or Paolo though. MAINTAINERS shows Paolo
as all kvm selftests, but I think Marc has started picking up the AArch64
specific kvm selftests.

Marc, if you've decided to maintain AArch64 kvm selftests, would you be
opposed to adding

  F: tools/testing/selftests/kvm/*/aarch64/
  F: tools/testing/selftests/kvm/aarch64/

to "KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
