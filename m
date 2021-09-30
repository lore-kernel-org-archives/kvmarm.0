Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5C7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:00:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 937916197A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 937916197A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA434B0DB;
	Thu, 30 Sep 2021 05:00:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0F6iowg2UAq8; Thu, 30 Sep 2021 05:00:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C15C14B0BD;
	Thu, 30 Sep 2021 05:00:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B820649DE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:00:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F8Sr-afir0bu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 05:00:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A3140762
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:00:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632992433;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=moU+7B0e6GAwk20kCPZuVoIHcKpWH+cvFU2qvdImZH8=;
 b=XAcsJnAa3hE5So46lJSmKDd6A2eOCe9WucaYhPcSuNWO3Pht4MYijoyDxYPLt8H5xsFPDn
 QvzV2jl0FxxS67E2CpLK2QP2JnEY8j0BgjlSVMlg+zXt8c9A3tDpqmduUimQNqSH/AxfNE
 OSAxHampurK9WY/iJf1cqztSFs8iHLM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-BczFNSAbMsyjzEPTFqw-8A-1; Thu, 30 Sep 2021 05:00:32 -0400
X-MC-Unique: BczFNSAbMsyjzEPTFqw-8A-1
Received: by mail-wm1-f69.google.com with SMTP id
 z137-20020a1c7e8f000000b0030cd1800d86so2629969wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 02:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=moU+7B0e6GAwk20kCPZuVoIHcKpWH+cvFU2qvdImZH8=;
 b=jnL6jLFLIb5p5bvlxUydRRS61Pb4vqXH8MvvM00tUvC7Q4N4o7BerZ+FqVkxU3rTJg
 Co7scVPSsXtdf6wneIabNTsddr8MKn4W01ptrNDzh5MXdlGADRm8iNGAsLnSlLuc/CFl
 +nrJnL+xNL3AIiy+CTl68BKGWMVrdb5YZ3JMVYZRVXJqPwyX3NayHujLTFJkkkmYU6CI
 UEr37Lb5hol4FwKipFGsxJrwBPS9x8t/7U0n9NbsQKrs3xJOuS9ydsVxhAeq4OtUpQ2P
 hbbMwgnfXgnsF9J2mPHh1JnlkLDNKF/kJR/9OZUzXYO4bqg9b742LQwxtVuHb6EZT5RW
 cr5w==
X-Gm-Message-State: AOAM5332NHlCKb1q2qt7qQNE33LxepxjbvaIMjbf/nVYoWHFRRjK2krk
 YT5Zqewn4pDBDh3TQiYLJWU8ACMQgtW3KZNM948eJoiqSpyUoiBADlRazATbdPPEGxRjN9BoSha
 QDjrtxm6OL5mggopeXHzrE6TH
X-Received: by 2002:a5d:5255:: with SMTP id k21mr4845896wrc.421.1632992431083; 
 Thu, 30 Sep 2021 02:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOLCH0kASjSLU5nF/dpC0BtrKbKaslmi2d2ORJoeYA7immIc46GSd/795Jm2ytJfdQZ7YycA==
X-Received: by 2002:a5d:5255:: with SMTP id k21mr4845868wrc.421.1632992430873; 
 Thu, 30 Sep 2021 02:00:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d8sm2508461wrv.80.2021.09.30.02.00.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 02:00:30 -0700 (PDT)
Subject: Re: [PATCH v3 09/10] KVM: arm64: selftests: Add test for legacy GICv3
 REDIST base partially above IPA range
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-10-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <b97a5ef9-d598-78f5-3ccf-d650ecc256c8@redhat.com>
Date: Thu, 30 Sep 2021 11:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-10-ricarkol@google.com>
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
> Add a new test into vgic_init which checks that the first vcpu fails to
> run if there is not sufficient REDIST space below the addressable IPA
> range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
> as the required REDIST space is not know when setting the DIST region.
>
> Note that using the REDIST_REGION API results in a different check at
> first vcpu run: that the number of redist regions is enough for all
> vcpus. And there is already a test for that case in, the first step of
> test_v3_new_redist_regions.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 77a1941e61fa..417a9a515cad 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -570,6 +570,39 @@ static void test_v3_last_bit_single_rdist(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +/* Uses the legacy REDIST region API. */
> +static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
> +{
> +	struct vm_gic v;
> +	int ret, i;
> +	uint64_t addr;
> +
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
> +
> +	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
> +	addr = max_phys_size - (3 * 2 * 0x10000);
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +
> +	addr = 0x00000;
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +
> +	/* Add the rest of the VCPUs */
> +	for (i = 1; i < NR_VCPUS; ++i)
> +		vm_vcpu_add_default(v.vm, i, guest_code);
> +
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	/* Attempt to run a vcpu without enough redist space. */
> +	ret = run_vcpu(v.vm, 2);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +		"redist base+size above PA range detected on 1st vcpu run");
> +
> +	vm_gic_destroy(&v);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -621,6 +654,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_typer_accesses();
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
> +		test_v3_redist_ipa_range_check_at_vcpu_run();
>  	}
>  }
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
