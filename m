Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F604C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:06:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1575561507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1575561507
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B344B2DA;
	Tue,  5 Oct 2021 04:06:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7I-M2oZSLkQK; Tue,  5 Oct 2021 04:06:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781C14B2B4;
	Tue,  5 Oct 2021 04:06:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B024B2AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:06:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5iUDHSwEAEfI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 04:06:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77EC44B286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:06:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633421188;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vhjykuBR6EQX00L0VGf5i7raTTT82lQIt3kyQcFUbRI=;
 b=XummsF73EDq2kdV/4Stc9+7awRPlMZXcvrjNQPvpqkj8x9ZlGIbx4W5mw9f/y8XMNJUzhI
 62Wl7KQnkjzo29LlOa8bVsTp7dVLSxnXM9fog5sIhOFlXnM93frZlgj7hR1JhUJyY3ICB4
 moScOWq1q4GKdu1naGwOZqJG6P1sG/w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-ZiXzFygTNOGlF5OXmoXC-w-1; Tue, 05 Oct 2021 04:06:27 -0400
X-MC-Unique: ZiXzFygTNOGlF5OXmoXC-w-1
Received: by mail-wr1-f71.google.com with SMTP id
 e11-20020a5d500b000000b001609d035ea5so2576943wrt.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 01:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=vhjykuBR6EQX00L0VGf5i7raTTT82lQIt3kyQcFUbRI=;
 b=HcYz+VCLf2RgsgO5L/P7Bbli6aca9FBpAXFRhm0o4WXnZ9deW71DKeDkYvb8VYyucF
 /Ps+MJqyD1cb5vbZtyHMsz3ZH19OvPj7hpDTj3H9bvZU2akP6iqr1uEVDvJarEdaQ/fk
 sozds5mJsK4aUDE58Qxbr1Kt2xe3ggf3SJ7xTXbsBOHvVcddkxh7qdqmzeJ8Q1Y49oTf
 LlENs5fwDf3/IibHg7X61jeYH8VgJEFLQ6SMHkJPxY/K+D2ypPr9+T6ZAQNFA/z8rQVX
 simuCv3Nu9YswAqTZ+iCltlvzY5mOT2oRojy7WQMNM5pSeu/EhCPQfF1h0xH62SyYZ0Q
 SjuA==
X-Gm-Message-State: AOAM533bYmD+jP35MAKx2N7uptZMeaBpSjzqT7nq1No9xQeh107Kvrs5
 PlDMufZs0tlDzavTWNUyL86BYSfV+HNOaz8sfkPSgOOp9rK6VTLEf2Ls2DhpticE7CbL+ykTg6x
 bOwkz/bCbJ/vCUUJ2TMiZksKs
X-Received: by 2002:adf:e309:: with SMTP id b9mr19580251wrj.81.1633421186297; 
 Tue, 05 Oct 2021 01:06:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1n5X+5Mw7xswtFTlINtzSIttQkeQeko39X/73gUrdJh9mS6qkvianazsge358CdgTo8lYBw==
X-Received: by 2002:adf:e309:: with SMTP id b9mr19580229wrj.81.1633421186151; 
 Tue, 05 Oct 2021 01:06:26 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id c185sm1047398wma.8.2021.10.05.01.06.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 01:06:25 -0700 (PDT)
Subject: Re: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-12-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <42b14187-3865-6b56-8c09-b0dde4884487@redhat.com>
Date: Tue, 5 Oct 2021 10:06:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-12-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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



On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add some ITS device init tests: general KVM device tests (address not
> defined already, address aligned) and tests for the ITS region being
> within the addressable IPA range.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 80be1940d2ad..c563489ff760 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -598,6 +598,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_v3_its_region(void)
> +{
> +	struct vm_gic v;
> +	uint64_t addr;
> +	int its_fd, ret;
> +
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
> +	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
> +
> +	addr = 0x401000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +		"ITS region with misaligned address");
> +
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"register ITS region with base address beyond IPA range");
> +
> +	addr = max_phys_size - 0x10000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"Half of ITS region is beyond IPA range");
> +
> +	/* This one succeeds setting the ITS base */
> +	addr = 0x400000;
> +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +
> +	addr = 0x300000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
> +
> +	close(its_fd);
> +	vm_gic_destroy(&v);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -650,6 +691,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
> +		test_v3_its_region();
>  	}
>  }
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
