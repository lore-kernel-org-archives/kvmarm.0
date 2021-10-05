Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517F5C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:09:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE57B61354
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE57B61354
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3F94B2D3;
	Tue,  5 Oct 2021 04:09:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pIvOLzJ3MAIp; Tue,  5 Oct 2021 04:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFC44B2A7;
	Tue,  5 Oct 2021 04:09:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1444B270
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:09:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4KMxrOXS6Gey for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 04:09:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 035524B267
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:09:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633421370;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nquAsR0ARDMCBnBcdv/CquPP9i+YvWVE1XKBwQ6DiLg=;
 b=Csbe5aZzK09CL9lPsVuKqqo0CM6Yh1zzwnxuJjF0840v6IT7NcqdS7XJyc/GC+ULnjXN69
 LdHhqZuL+p4f7vjgAGKZK2jbjGBr4LzkdRBL6vNiuu8nNAH3qx6J0JNfDA7Y8hbplihiWj
 pzapk/7yqMN+sRk+7bEZlGjBTfQMGbI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-qSRtOO6EP-yK-z0l80Qa4A-1; Tue, 05 Oct 2021 04:09:29 -0400
X-MC-Unique: qSRtOO6EP-yK-z0l80Qa4A-1
Received: by mail-wr1-f71.google.com with SMTP id
 r16-20020adfb1d0000000b00160bf8972ceso9985wra.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 01:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=nquAsR0ARDMCBnBcdv/CquPP9i+YvWVE1XKBwQ6DiLg=;
 b=nlb5noZA/K8LeZuQs+evwCoLN9lTo2jpMNrAhB20JugjjDlGsq4U7Zvo971V4/zsgI
 5rCVebKW1wYI9H91ifh8WsG+3113AJ+1sRASM+VX+W5JN1pkoPvT28kVCTjPOUCSG9Uq
 43mslKhASMPL5UKNvwFtcwC/HetrpWYfE2MnmEUP4R/EIldzwfpz+p44fwbWmV74wJRC
 bo7nZOJpK5p66/BycqrlyBm7fZugKGvQi0dJzcectNky8pHEZ4KJ9rUA77STXnuBZofD
 r3LjM40nP6m2bujD+vWKmiaPsh4StMY0ndUeTAQlPIKEu72uSVTn9echyW4XU+AZbPhk
 MqJQ==
X-Gm-Message-State: AOAM530dRJq0uUTCVtt0an5HUT6/w3jYb6IYqKAQlaMETSzLgQfXQfpG
 J2e+X3N2NUw9aE5qhf3zgGvfJEF6lpW9f+LQxqI4o448pGq6K3bK8Bbh3W9H+SX59bDHoyH6zrO
 RFKPlXjvKrNWwScavcBwn/5sZ
X-Received: by 2002:a1c:ce:: with SMTP id 197mr1864227wma.178.1633421368729;
 Tue, 05 Oct 2021 01:09:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxsVUdnI7a+h0TboAUEJoLNIjUBagMKVxzbWn8ap+ZX8VrAJIoVcILvtxslkDleJ7yhLDddQ==
X-Received: by 2002:a1c:ce:: with SMTP id 197mr1864180wma.178.1633421368371;
 Tue, 05 Oct 2021 01:09:28 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l26sm1056133wmi.25.2021.10.05.01.09.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 01:09:27 -0700 (PDT)
Subject: Re: [PATCH v4 08/11] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-9-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <9e153c26-005c-d545-67b0-a8505d62ca4f@redhat.com>
Date: Tue, 5 Oct 2021 10:09:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-9-ricarkol@google.com>
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

Ricardo,

On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add some GICv2 tests: general KVM device tests and DIST/CPUIF overlap
> tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> in vgic_init GIC version agnostic.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 111 +++++++++++++-----
>  1 file changed, 79 insertions(+), 32 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 7521dc80cf23..cb69e195ad1d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -79,74 +79,120 @@ static void vm_gic_destroy(struct vm_gic *v)
>  	kvm_vm_free(v->vm);
>  }
>  
> +struct vgic_region_attr {
> +	uint64_t attr;
> +	uint64_t size;
> +	uint64_t alignment;
> +};
> +
> +struct vgic_region_attr gic_v3_dist_region = {
> +	.attr = KVM_VGIC_V3_ADDR_TYPE_DIST,
> +	.size = 0x10000,
> +	.alignment = 0x10000,
> +};
> +
> +struct vgic_region_attr gic_v3_redist_region = {
> +	.attr = KVM_VGIC_V3_ADDR_TYPE_REDIST,
> +	.size = NR_VCPUS * 0x20000,
> +	.alignment = 0x10000,
> +};
> +
> +struct vgic_region_attr gic_v2_dist_region = {
> +	.attr = KVM_VGIC_V2_ADDR_TYPE_DIST,
> +	.size = 0x1000,
> +	.alignment = 0x1000,
> +};
> +
> +struct vgic_region_attr gic_v2_cpu_region = {
> +	.attr = KVM_VGIC_V2_ADDR_TYPE_CPU,
> +	.size = 0x2000,
> +	.alignment = 0x1000,
> +};
> +
>  /**
> - * Helper routine that performs KVM device tests in general and
> - * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
> - * device gets created, a legacy RDIST region is set at @0x0
> - * and a DIST region is set @0x60000
> + * Helper routine that performs KVM device tests in general. Eventually the
> + * ARM_VGIC (GICv2 or GICv3) device gets created with an overlapping
> + * DIST/REDIST (or DIST/CPUIF for GICv2). Assumption is 4 vcpus are going to be
> + * used hence the overlap. In the case of GICv3, A RDIST region is set at @0x0
> + * and a DIST region is set @0x70000. The GICv2 case sets a CPUIF @0x0 and a
> + * DIST region @0x1000.
>   */
> -static void subtest_v3_dist_rdist(struct vm_gic *v)
> +static void subtest_dist_rdist(struct vm_gic *v)
>  {
>  	int ret;
>  	uint64_t addr;
> +	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
> +	struct vgic_region_attr dist;
> +
> +	rdist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_redist_region
> +						: gic_v2_cpu_region;
> +	dist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_dist_region
> +						: gic_v2_dist_region;
>  
>  	/* Check existing group/attributes */
>  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			      KVM_VGIC_V3_ADDR_TYPE_DIST);
> +			      dist.attr);
>  
>  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
> +			      rdist.attr);
>  
>  	/* check non existing attribute */
> -	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
> +	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
>  	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
>  
>  	/* misaligned DIST and REDIST address settings */
> -	addr = 0x1000;
> +	addr = dist.alignment / 0x10;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 dist base not 64kB aligned");
> +				 dist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "GIC dist base not aligned");
>  
> +	addr = rdist.alignment / 0x10;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 redist base not 64kB aligned");
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
>  
>  	/* out of range address */
>  	if (max_ipa_bits) {
>  		addr = 1ULL << max_ipa_bits;
>  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +					 dist.attr, &addr, true);
>  		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
>  
>  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +					 rdist.attr, &addr, true);
>  		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
>  	}
>  
>  	/* set REDIST base address @0x0*/
>  	addr = 0x00000;
>  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +			  rdist.attr, &addr, true);
>  
>  	/* Attempt to create a second legacy redistributor region */
>  	addr = 0xE0000;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EEXIST, "GICv3 redist base set again");
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
>  
> -	/* Attempt to mix legacy and new redistributor regions */
> -	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> -	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
> +	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
> +	if (!ret) {
> +		/* Attempt to mix legacy and new redistributor regions */
> +		addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> +		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
> +					 &addr, true);
> +		TEST_ASSERT(ret && errno == EINVAL,
> +			    "attempt to mix GICv3 REDIST and REDIST_REGION");
> +	}
>  
>  	/*
>  	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
>  	 * on first vcpu run instead.
>  	 */
> -	addr = 3 * 2 * 0x10000;
> -	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
> -			  &addr, true);
> +	addr = rdist.size - rdist.alignment;
> +	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  dist.attr, &addr, true);
>  }
>  
>  /* Test the new REDIST region API */
> @@ -254,14 +300,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>   * VGIC KVM device is created and initialized before the secondary CPUs
>   * get created
>   */
> -static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> +static void test_vgic_then_vcpus(uint32_t gic_dev_type)
>  {
>  	struct vm_gic v;
>  	int ret, i;
>  
>  	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
>  
> -	subtest_v3_dist_rdist(&v);
> +	subtest_dist_rdist(&v);
>  
>  	/* Add the rest of the VCPUs */
>  	for (i = 1; i < NR_VCPUS; ++i)
> @@ -274,14 +320,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
>  }
>  
>  /* All the VCPUs are created before the VGIC KVM device gets initialized */
> -static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
> +static void test_vcpus_then_vgic(uint32_t gic_dev_type)
>  {
>  	struct vm_gic v;
>  	int ret;
>  
>  	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
>  
> -	subtest_v3_dist_rdist(&v);
> +	subtest_dist_rdist(&v);
>  
>  	ret = run_vcpu(v.vm, 3);
>  	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
> @@ -550,9 +596,10 @@ int test_kvm_device(uint32_t gic_dev_type)
>  
>  void run_tests(uint32_t gic_dev_type)
>  {
> +	test_vcpus_then_vgic(gic_dev_type);
> +	test_vgic_then_vcpus(gic_dev_type);
> +
>  	if (VGIC_DEV_IS_V3(gic_dev_type)) {
> -		test_v3_vcpus_then_vgic(gic_dev_type);
> -		test_v3_vgic_then_vcpus(gic_dev_type);
>  		test_v3_new_redist_regions();
>  		test_v3_typer_accesses();
>  		test_v3_last_bit_redist_regions();

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
