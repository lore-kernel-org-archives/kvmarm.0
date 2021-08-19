Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE35C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:33:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B963261156
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B963261156
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF704B0D1;
	Thu, 19 Aug 2021 06:32:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RWEgUcqueXU5; Thu, 19 Aug 2021 06:32:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670BD4B0F7;
	Thu, 19 Aug 2021 06:32:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8F1D4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:32:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlSqwanK0Ybz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 06:32:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C45DC4B0D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:32:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629369173;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bPjTLG6BnlhDR/yLVndhYDd5PxLKWVZhhC+KJM8dWd8=;
 b=ZK+ZBNbHtRj+c3HFVyZ7oY8knumaVnfbtcz1fUF1/4bzj8VQNPxClPg7M6hA3ksfMEuxtH
 uCUOv/vhoQxvjU1jsSfNv+2kgrwWxNk4EK2/cPGit2kVcwheAbBNVu2lbdPMv3p9eALQoG
 svjxKADCZriAcu9P7hnrWPcviZWtgKs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-d7MaZR7LPGutn0xIG3D_nQ-1; Thu, 19 Aug 2021 06:32:52 -0400
X-MC-Unique: d7MaZR7LPGutn0xIG3D_nQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 x24-20020aa7dad8000000b003bed477317eso2604885eds.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 03:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bPjTLG6BnlhDR/yLVndhYDd5PxLKWVZhhC+KJM8dWd8=;
 b=HTO1rSaXRZY4WZM2QniWmSP5LIclSVDKBGu3ecyfXuoLS54HZYC/AumvK0DKYeJ8Yh
 X9PLIVBs1E6AImJcm5w1oWMMQ+WphhF7UfgVT9cd0j39YBfzhj4LN9/is8SCtxPZNja6
 TOnEEZ/747nipGmQqgAdBtAPSCLFkgbWCG7a89ZPNjMmFrbgAB1UJjLPw8TqgWVwDxJk
 g0mhGlZ17L7SN3h7W2sh7d14aUfmixMkbFN/pWtuLdReR3sHAIIG2n3F6/tFh8XmSQKT
 jYZR2299xF3leUugJQgj5On0DfgPxAB27RTZwPz2P8YjqCLJIdX5pVRwYAK9xO16Yne/
 mYeg==
X-Gm-Message-State: AOAM531pZxQ9tRicqbqW65IdoflQaHHKEQ+bAKnXeIO1QNSOjx4J1kpe
 KntdgooNlXfTTyNGRsHISYpyWEvexom+rf8XRZppQgWK2xPzUt75QC0F3AP2+x8IwSpA4Avkd35
 avWWgI5opdXbLPv2KWSC/0Mg4
X-Received: by 2002:a05:6402:3589:: with SMTP id
 y9mr15674848edc.247.1629369171023; 
 Thu, 19 Aug 2021 03:32:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR6IEWZyk9DeLg8lf82gXwmeVWOMXFyQatDgyWvCcITeJWw3vhfAeY3/pITKDuLrOs2mEb6A==
X-Received: by 2002:a05:6402:3589:: with SMTP id
 y9mr15674834edc.247.1629369170833; 
 Thu, 19 Aug 2021 03:32:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id gw24sm1070469ejb.66.2021.08.19.03.32.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 Aug 2021 03:32:50 -0700 (PDT)
Date: Thu, 19 Aug 2021 12:32:47 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
Message-ID: <20210819103247.ifawa4zoibw3mbah@gator.home>
References: <20210818212940.1382549-1-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210818212940.1382549-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 18, 2021 at 09:29:40PM +0000, Oliver Upton wrote:
> An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
> the requested feature flags is not supported by the kernel/hardware.
> Detect the case when KVM doesn't support the requested features and skip
> the test rather than failing it.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
> Jade system.
> 
>  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..b1064a0c5e62 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  {
>  	struct kvm_vcpu_init default_init = { .target = -1, };
>  	uint64_t sctlr_el1, tcr_el1;
> +	int ret;
>  
>  	if (!init)
>  		init = &default_init;
> @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  		init->target = preferred.target;
>  	}
>  
> -	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +
> +	/*
> +	 * Missing kernel feature support should result in skipping the test,
> +	 * not failing it.
> +	 */
> +	if (ret && errno == ENOENT) {
> +		print_skip("requested vCPU features not supported; skipping test.");

", skipping test" will already be appended by print_skip().

> +		exit(KSFT_SKIP);
> +	}
> +
> +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> +		    ret, errno, strerror(errno));
>  
>  	/*
>  	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
>

I think I'd rather try to keep exit(KSFT_SKIP)'s out of the lib code. It'd
be better if the test gets to decide whether to skip or not. How about
moving this check+skip into the test instead?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
