Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741CDC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:00:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9D5D6128A
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E9D5D6128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 642474A5A0;
	Tue, 21 Sep 2021 14:00:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c-R+XJpJOS7W; Tue, 21 Sep 2021 14:00:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5802140C88;
	Tue, 21 Sep 2021 14:00:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0444406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:00:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KyNW+3ik3o1T for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 14:00:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0A24A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:00:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632247206;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7JfYcZW2NbckggyMTPgWKycE7DRVJIAvYonCutHYoos=;
 b=QibDx4taHQKt5Yq5k2qILpdNAHAvXNK0fV1k+mB0l3OYIHx5uTz8E/OzCt+KRaxdlJxOvA
 D9hytIJB6hl8YyDLVoqAT1UsKAFLky5Rh3nnn3WhOvghseu5m2Id+tF6S+hvLndXeudE5h
 3jhcuvIGSeTe9LXGAwojnC9PTQrcRng=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-RH4JUlw-Ofif2Fwr-RwD1g-1; Tue, 21 Sep 2021 14:00:05 -0400
X-MC-Unique: RH4JUlw-Ofif2Fwr-RwD1g-1
Received: by mail-wr1-f70.google.com with SMTP id
 m1-20020a056000180100b0015e1ec30ac3so9501417wrh.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 11:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=7JfYcZW2NbckggyMTPgWKycE7DRVJIAvYonCutHYoos=;
 b=K/0lil12Dtd1m4EA9rkvgrqmKXyqQ6lxaYyJWohLV3qP+v11sGtRtq4XOisKYgwJFa
 mF6IzvU4j2JFAP6h3EeCeuzTO65Eset0DzJx6ssOeAVo6mFqCjRN3SFHKWdcgTzmhzin
 6vUJesy+sNQncX6wZtH4BGm/NUsDXmTb/SL76mO+LpYkWw7rTNVeH6FCUlmWgBB2zrm6
 WsjcDp5a6ttsqbimuwlIO/+3LPCD6T/mbtD676aofU3sIZDW4hP5T11NajF0MksxawJh
 u93vq/siMXDQBn3oDirhA+Pg9zfD7/ylzuqw4M8ABn+jCvVMGbMDggfA9m6FigiN8+Wx
 BzzA==
X-Gm-Message-State: AOAM531n32VtBztMbvCT8KDzwijdiC+Cssv54NUowH0vMJnwzYQr7Kvw
 LQfh/MxUviwsOT6a8Kg2DOckYIItjfHtUIv6KpGtlQ4K1z1Q8W47QihKzEQs9F6gyQWO3Cnoe1t
 s5kGH5k/zcpOf5Njh6OD+sXEo
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr36596955wrp.171.1632247204354; 
 Tue, 21 Sep 2021 11:00:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRzE0XDhDN+YzVRHql1Lso3OsD+/0fE4vZgdDKs5KMBqTMa32DRdaFtYAvn1nk3N1rLTZCjQ==
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr36596927wrp.171.1632247204162; 
 Tue, 21 Sep 2021 11:00:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id g131sm3526365wme.22.2021.09.21.11.00.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 11:00:03 -0700 (PDT)
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210818212940.1382549-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
Date: Tue, 21 Sep 2021 20:00:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818212940.1382549-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 18/08/21 23:29, Oliver Upton wrote:
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
>   .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..b1064a0c5e62 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>   {
>   	struct kvm_vcpu_init default_init = { .target = -1, };
>   	uint64_t sctlr_el1, tcr_el1;
> +	int ret;
>   
>   	if (!init)
>   		init = &default_init;
> @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>   		init->target = preferred.target;
>   	}
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
> +		exit(KSFT_SKIP);
> +	}
> +
> +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> +		    ret, errno, strerror(errno));
>   
>   	/*
>   	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
