Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F02C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 00:20:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E84E061262
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 00:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E84E061262
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1054B090;
	Tue, 28 Sep 2021 20:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCXZqMF3uToF; Tue, 28 Sep 2021 20:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20042407E7;
	Tue, 28 Sep 2021 20:20:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A974B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 20:20:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2eUxo-rheegW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 20:20:05 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FCC74B099
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 20:20:05 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 il14-20020a17090b164e00b0019c7a7c362dso2875975pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VW5ROBZ57Bc3bmxw0lo66kLteeQHzsOCYqDBMl9HovU=;
 b=IwO12wLFAGMbs4S8k3EBPxDqzfGlfvR+OKcZUdMbTIBhNhrceUQYW8zoGRfiddsnyq
 D7Ny01TeGzwgmEZY32eDldRV7tydMoEHqGn9NpAm1vn6lRbYHcBVDGPEp0KBo8xHHV0G
 keNcBYwWK9yRXyi4QkBSZnGJCbQKpY4J8v2iOuh5rJT8LAZoTNaQoxFQrHxocZ0zGJug
 x0P+wKHMEp7wXNJtx/HSR1cYKMb05yr+hCRso8ZQVT32gqWp2HljvrGiDXI5V8aFCnXj
 DYsBF6ZxcBiCFUhLQQAhEuzDdkujCWVNx4YHOuxYo/RGzwsUKidRt7e+MZBMXqokuRKB
 LjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VW5ROBZ57Bc3bmxw0lo66kLteeQHzsOCYqDBMl9HovU=;
 b=x7SkFQ8q/kk6slThuFGvFfg9r/alO1Nhw3I5wqwlxBUqE7vh7eCC+GFGuY9+yBRWSq
 9G8V6t8NqnxOYEGuQUl02MKtmdGOXYHhf0QBYVUPJjuprI4ysPvrnnR12GFTPwBJudJb
 lywoBa6QSeYNwmiv3XPBNsYGh8smBZaHDBd8fQatvxyX0T0lx+CwYcsrzBA9Kz79lgxT
 /zZVr+pbf/kMQQRFQ0osFA+LJIQCmtsvvslmWYv0b2hg0EdnAj+0rHK1aDFSDs/Rkx06
 JZEp+hRIvPUmnICECBvj8RyNUXtAH5sD0bz1sVSj3P5mQRPTzrpxUukGwEjrHdOhfQ6i
 QouA==
X-Gm-Message-State: AOAM531HpYqllLfTlnqVnGiH5yyI+5ASLnWM2ip/fVX6bmQ1Yi+yFoif
 7v7ceMxXGNTyONTWdqWXWcGPEw==
X-Google-Smtp-Source: ABdhPJx6YGh7ixXXr0JV5zyepV3FpPhXhE8lTfYur7l6549ETUjoRZlxE1xg0lypH+pneZh5+S7TDQ==
X-Received: by 2002:a17:90a:ab94:: with SMTP id
 n20mr3136878pjq.146.1632874803871; 
 Tue, 28 Sep 2021 17:20:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id y6sm256924pfb.64.2021.09.28.17.20.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 17:20:03 -0700 (PDT)
Date: Tue, 28 Sep 2021 17:19:59 -0700
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
Message-ID: <YVOxLz3/JPOjWd2d@google.com>
References: <20210928201157.2510143-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210928201157.2510143-1-ricarkol@google.com>
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

On Tue, Sep 28, 2021 at 01:11:57PM -0700, Ricardo Koller wrote:
> Add some ITS device tests: general KVM device tests (address not defined
> already, address aligned) and tests for the ITS region being within the
> addressable IPA range.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 417a9a515cad..180221ec325d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
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
> @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
> +		test_v3_its_region();
>  	}
>  }
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Please ignore this email. This patch is already included in the right trhread.

Sorry and thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
