Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134CCC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:15:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84F3861211
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84F3861211
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBD14066E;
	Tue, 21 Sep 2021 14:15:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pWjh88h3JmxS; Tue, 21 Sep 2021 14:15:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB89D40C88;
	Tue, 21 Sep 2021 14:15:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A02A4066E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S8aIoOQ-wAVw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 14:15:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F7B40191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:15:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632248120;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7Y+LZFJjnOBJ8l+4LgEza9wG6jZfQeGN1fAATCstXMA=;
 b=C3sFyEF/s7S8P4CMHXb2IK1lf5RKvbjiZXKiJAiDtU0xJ9ajhoazHhA77YIAGIER3aGcQy
 xG/53Y0xMcBgwnOGHLvojij7sukSfRyo1nlJ/TPEWaTR27Aye2QBv/PH4EyomGc4Cidr7Q
 XZuyvU6LDqTyKU60x2pdCT9KNJtSl0s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-klSdpUpJNdid8oTKIrv0OA-1; Tue, 21 Sep 2021 14:15:18 -0400
X-MC-Unique: klSdpUpJNdid8oTKIrv0OA-1
Received: by mail-ed1-f69.google.com with SMTP id
 b7-20020a50e787000000b003d59cb1a923so18995721edn.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 11:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7Y+LZFJjnOBJ8l+4LgEza9wG6jZfQeGN1fAATCstXMA=;
 b=CfisjU8g/whj+ChRWLT64qZ4Jhoqxrk8kgQBMWKsp4lVjWhCJ5xG9oxpEYuP3Pwwne
 zLfXG5FaMX8b1XSra2K5KLH1GsNZZLEkKocYWLu5yAgy22A/rV0HL5duP1ObpidU/GDy
 pNQYSYTks6gJp4CIaB+731UxGZTvLs63rHs0tb5LoFg3zvRWxGZ/N7faIavBCAb+YqNv
 yIIDjhKB/+NGrE6KnDe021PtfOzzuwFqsXhOvgZOcAsFEW9lRNobex8YjYKSheGc/yu9
 klUUd2YBPUGvpkSwfeKNYkOs122LRCI912pzHkz1dx2E8rtkg8yA3WoswJZv1TQGQpTU
 sRrQ==
X-Gm-Message-State: AOAM533NS7Sy9k+AIm+BFyoZnjAA6JpIeUNN0kJht84omDdbTWd1HxPs
 OJLoBk/c0WxmzrMOAQUO+crToYDqhpf/B89wWxk+QA+EApnzqA/ZKhI9OIMhAicWzBNEQiAA/MX
 00FWWOywJXeDjYj0I+M+kY1/z
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr22926554edk.196.1632248117828; 
 Tue, 21 Sep 2021 11:15:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfHWJ4wAe2ChpPcagdjNe/66n3H1pQckVdJn25bnW5kRCJAWG1M9fYCNrB0/pDsYWHus9+OQ==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr22926532edk.196.1632248117560; 
 Tue, 21 Sep 2021 11:15:17 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id d15sm6112895ejo.4.2021.09.21.11.15.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 11:15:13 -0700 (PDT)
Date: Tue, 21 Sep 2021 20:15:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
Message-ID: <20210921181510.senhdb3itkcjfonb@gator.home>
References: <20210818212940.1382549-1-oupton@google.com>
 <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
MIME-Version: 1.0
In-Reply-To: <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 21, 2021 at 08:00:02PM +0200, Paolo Bonzini wrote:
> On 18/08/21 23:29, Oliver Upton wrote:
> > An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
> > the requested feature flags is not supported by the kernel/hardware.
> > Detect the case when KVM doesn't support the requested features and skip
> > the test rather than failing it.
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> > Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
> > Jade system.
> > 
> >   .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
> >   1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 632b74d6b3ca..b1064a0c5e62 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >   {
> >   	struct kvm_vcpu_init default_init = { .target = -1, };
> >   	uint64_t sctlr_el1, tcr_el1;
> > +	int ret;
> >   	if (!init)
> >   		init = &default_init;
> > @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >   		init->target = preferred.target;
> >   	}
> > -	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> > +	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> > +
> > +	/*
> > +	 * Missing kernel feature support should result in skipping the test,
> > +	 * not failing it.
> > +	 */
> > +	if (ret && errno == ENOENT) {
> > +		print_skip("requested vCPU features not supported; skipping test.");
> > +		exit(KSFT_SKIP);
> > +	}
> > +
> > +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> > +		    ret, errno, strerror(errno));
> >   	/*
> >   	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> > 
> 
> Queued, thanks.
> 

I'd rather we don't queue this. It'd be better, IMO, for the unit test to
probe for features and then skip the test, if that's what it wants to do,
when they're not present. I'd rather not have test skipping decisions
made in the library code, which may not be what the unit test developer
expects. Anyway, the 'skipping test' substring would be printed twice with
this patch.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
