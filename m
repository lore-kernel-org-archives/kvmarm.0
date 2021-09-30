Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA19C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:17:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFEAC61882
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DFEAC61882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5B04A7FD;
	Thu, 30 Sep 2021 03:17:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bCtCC+0fIXfF; Thu, 30 Sep 2021 03:17:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 464D24B0C3;
	Thu, 30 Sep 2021 03:17:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB064A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:17:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQUgUlF+8i7h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 03:17:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E480F4A534
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:17:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632986254;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=snWeCx4RgtM1wdiRtH9U6Dyc5Jjpi/gorOCqlOq2GLc=;
 b=NxPssNS8NBV6Ipfj95CTre9syfC7olCtoKIPay30fKIBmNl3vKN5TDbPkB/DsngYYgqhIj
 ZFSLnQrOfkqU9YuRCj0yFdVuEEy1069fe8yvmPYiARx7HaEw7ro83P7CDYZ3z0WY/z2eF9
 8ghd2iOivfjut+dUN+SaT6JR9bFBzo8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-rDt-TaDBOxK-MtUqc6bGSA-1; Thu, 30 Sep 2021 03:17:33 -0400
X-MC-Unique: rDt-TaDBOxK-MtUqc6bGSA-1
Received: by mail-wr1-f71.google.com with SMTP id
 j15-20020a5d564f000000b00160698bf7e9so1329063wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 00:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=snWeCx4RgtM1wdiRtH9U6Dyc5Jjpi/gorOCqlOq2GLc=;
 b=x1GA4zHx8GidABEYrztOCEa9cIdeab5CXl5KyOcQMK9H34X/fTmTV5haMuPh1RuxNJ
 VyBP94Pz2PocGj207HHTD4AjNigUHGhwrNjaQHIfy565/NGa1qteoigc//rK1TVrZPeW
 ltm37lRKWXMxkLUDkC259E3gH/mXqZLgDZO0qBCWEhXjVaF7Ic6CKhxV3QgIU6BZaNxN
 ycHklcWyRbYDfGQ0CfQR+Vt37YOpl+YHCBe9847sagomIGxCK93LcJlvjOme/JXn4/pX
 cPd26sDV/e9M/iIE3485dbu6SpgLjpRq0+Up0d9BfolzY4ZyIsdaZiQe8181jfwA1Bco
 LsnQ==
X-Gm-Message-State: AOAM530a22nIp78VPRIOl6TEyl+aBwdak6l8GZt5cwA0NrxWslcuxha2
 l3YTn2sPScBqGWxilQPQVmctiz4VOCeqWlrWp6pZgHNC0fuUe2ZLuZbxyWTn+rSH51OiAuBfAQV
 +pKjluRwHICid9A4qEr3i+0eu
X-Received: by 2002:a05:6000:1889:: with SMTP id
 a9mr4368356wri.300.1632986251996; 
 Thu, 30 Sep 2021 00:17:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDQeHb7TkaFHnACphcx/QYkXIfwXwftiA6MXlQ9vXrFzaqnyru1pkmOI8TGf+0NQkMPIzhjw==
X-Received: by 2002:a05:6000:1889:: with SMTP id
 a9mr4368325wri.300.1632986251801; 
 Thu, 30 Sep 2021 00:17:31 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n7sm2097815wra.37.2021.09.30.00.17.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 00:17:30 -0700 (PDT)
Subject: Re: [PATCH v3 06/10] KVM: arm64: selftests: Make
 vgic_init/vm_gic_create version agnostic
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-7-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <7c4d6409-4a49-4046-ccb4-f89851180e9e@redhat.com>
Date: Thu, 30 Sep 2021 09:17:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-7-ricarkol@google.com>
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



On 9/28/21 8:48 PM, Ricardo Koller wrote:
> Make vm_gic_create GIC version agnostic in the vgic_init test. Also
> add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.
>
> No functional change.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 21 +++++++++++--------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 896a29f2503d..b24067dbdac0 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -28,6 +28,7 @@
>  struct vm_gic {
>  	struct kvm_vm *vm;
>  	int gic_fd;
> +	uint32_t gic_dev_type;
>  };
>  
>  static int max_ipa_bits;
> @@ -61,12 +62,13 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
>  	return 0;
>  }
>  
> -static struct vm_gic vm_gic_v3_create(void)
> +static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
>  {
>  	struct vm_gic v;
>  
> -	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
> -	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	v.gic_dev_type = gic_dev_type;
> +	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
> +	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
>  
>  	return v;
>  }
> @@ -153,6 +155,8 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>  	uint64_t addr, expected_addr;
>  	int ret;
>  
> +	TEST_ASSERT(VGIC_DEV_IS_V3(v->gic_dev_type), "Only applies to v3");
Is that really needed? why here and not in other locations. I would remove.
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric
> +
>  	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
>  	TEST_ASSERT(!ret, "Multiple redist regions advertised");
> @@ -257,8 +261,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
>  	struct vm_gic v;
>  	int ret, i;
>  
> -	v.vm = vm_create_default(0, 0, guest_code);
> -	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
>  
>  	subtest_v3_dist_rdist(&v);
>  
> @@ -278,7 +281,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
>  	struct vm_gic v;
>  	int ret;
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
>  
>  	subtest_v3_dist_rdist(&v);
>  
> @@ -295,7 +298,7 @@ static void test_v3_new_redist_regions(void)
>  	uint64_t addr;
>  	int ret;
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
>  			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> @@ -306,7 +309,7 @@ static void test_v3_new_redist_regions(void)
>  
>  	/* step2 */
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  
>  	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
> @@ -320,7 +323,7 @@ static void test_v3_new_redist_regions(void)
>  
>  	/* step 3 */
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  
>  	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
