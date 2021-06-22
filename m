Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56244C2B9F4
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 07:48:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF3C36128A
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 07:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF3C36128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1943F40799;
	Tue, 22 Jun 2021 03:48:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Op3Jwhf4Mlk6; Tue, 22 Jun 2021 03:48:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4254A4079A;
	Tue, 22 Jun 2021 03:48:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3672D406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RhkiQWBcZgMm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 03:48:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4FD740413
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:48:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624348128;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=w3/ExjzsF+2HstscGugNhVD5aJGwY7/sJV7g6WW6sRQ=;
 b=cYJndzzW8sTOonBAYLMz5ExKEvcaYvyXTlsLy65Z3NQQwiuO3e8YzUJIlP/JwU8rpxdiR/
 PWOnmZLD1yai4ZSU6rU8yIAm3kqvRcDH2s4Dnb/FHpUp6E4epkA8sX32W6hREA0D3z5WNe
 ueKcu9NI0PQXzeaScvADHiOScWtddog=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-Gt6f9KBnPeC2ynxejAYoxA-1; Tue, 22 Jun 2021 03:48:45 -0400
X-MC-Unique: Gt6f9KBnPeC2ynxejAYoxA-1
Received: by mail-ed1-f71.google.com with SMTP id
 i19-20020a05640200d3b02903948b71f25cso6947716edu.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 00:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=w3/ExjzsF+2HstscGugNhVD5aJGwY7/sJV7g6WW6sRQ=;
 b=ldpThRYW93nXD2Ex8EZp4InP0W4meQ4n/AU4NXL3OIjmDgixtvxaOJF1cPvTJHID3R
 2jdPDvjhOZjq0HmBDRmUjAkFkiXDpRDBhk9KmcCMnGgbHA88jROzIL+0zXlHgMMp+vFK
 2qVBmKFQi26FVm7Sl4EbgH+YfH4u3tpBH60w6eGjj9TOMQo1tFsoYrXo/8mw16qeFTCc
 jtaxdnOwsJJ+XFQ0ae512BgpoW+jGHvYWfYJFaPN9OyldQWuAMa243h3zd4WVfgLlN7P
 0E5FqM+49mYqN2vRvu7MpAiy1iMENCoepJdBmrIPI6Q47ab/o4An9iJXid70vPCWveHs
 jxGA==
X-Gm-Message-State: AOAM531WEiazGchYu785wm8wXSaepYgHOANKyw5psoH8F81muaEeEBTL
 xb3dAy+0EIh4LBoWG6op3/+yj9qa4FYhKkdxr6YF93RpNnnnhylTZHIlO5YqaMbmKC43lwqftkP
 4n6ujkSztRX7MDmJtFO0sN6fZ
X-Received: by 2002:a17:907:2651:: with SMTP id
 ar17mr2588845ejc.135.1624348123862; 
 Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQPANaf1gnr3VrtMggQ7XkKBkZxYQrVYm1TCYwqOu7GPYzFbd0SPFej6fHnHmwig2VtLVGZg==
X-Received: by 2002:a17:907:2651:: with SMTP id
 ar17mr2588817ejc.135.1624348123579; 
 Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id g8sm11771648edw.89.2021.06.22.00.48.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
Date: Tue, 22 Jun 2021 09:48:41 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: selftests: Fix get-reg-list
Message-ID: <20210622074841.in2halgoakruglzs@gator>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210622070732.zod7gaqhqo344vg6@gator>
 <878s32cq1o.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <878s32cq1o.wl-maz@kernel.org>
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

On Tue, Jun 22, 2021 at 08:32:51AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Tue, 22 Jun 2021 08:07:32 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Mon, May 31, 2021 at 12:33:39PM +0200, Andrew Jones wrote:
> > > v3:
> > >  - Took Ricardo's suggestions in order to avoid needing to update
> > >    prepare_vcpu_init, finalize_vcpu, and check_supported when adding
> > >    new register sublists by better associating the sublists with their
> > >    vcpu feature bits and caps [Ricardo]
> > >  - We now dynamically generate the vcpu config name by creating them
> > >    from its sublist names [drew]
> > > 
> > > v2:
> > >  - Removed some cruft left over from a previous more complex design of the
> > >    config command line parser
> > >  - Dropped the list printing factor out patch as it's not necessary
> > >  - Added a 'PASS' output for passing tests to allow testers to feel good
> > >  - Changed the "up to date with kernel" comment to reference 5.13.0-rc2
> > > 
> > > 
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
> > > be fixed, and so does this selftest.
> > > 
> > > We could fix the test with a one-liner since we just need a
> > > 
> > >   init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> > > 
> > > in prepare_vcpu_init(), but that's too easy, so here's a 5 patch patch
> > > series instead :-)  The reason for all the patches and the heavy diffstat
> > > is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
> > > With the refactoring done in this series, we should now be able to easily
> > > add register sublists and vcpu configs to the get-reg-list test, as the
> > > last patch demonstrates with the pmu fix.
> > > 
> > > Thanks,
> > > drew
> > > 
> > > 
> > > Andrew Jones (5):
> > >   KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
> > >   KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
> > >     at once
> > >   KVM: arm64: selftests: get-reg-list: Provide config selection option
> > >   KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
> > >   KVM: arm64: selftests: get-reg-list: Split base and pmu registers
> > > 
> > >  tools/testing/selftests/kvm/.gitignore        |   1 -
> > >  tools/testing/selftests/kvm/Makefile          |   1 -
> > >  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 439 +++++++++++++-----
> > >  4 files changed, 321 insertions(+), 123 deletions(-)
> > >  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> > > 
> > > -- 
> > > 2.31.1
> > >
> > 
> > Gentle ping.
> > 
> > I'm not sure if I'm pinging Marc or Paolo though. MAINTAINERS shows Paolo
> > as all kvm selftests, but I think Marc has started picking up the AArch64
> > specific kvm selftests.
> 
> I'm happy to queue this series.
> 
> > Marc, if you've decided to maintain AArch64 kvm selftests, would you be
> > opposed to adding
> > 
> >   F: tools/testing/selftests/kvm/*/aarch64/
> >   F: tools/testing/selftests/kvm/aarch64/
> > 
> > to "KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"?
> 
> No problem to add this, but I *will* rely on you (and whoever wants to
> part-take) to do the bulk of the reviewing. Do we have a deal?

It's a deal. Thanks!

drew

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
