Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003C0C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:54:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9609A611F2
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9609A611F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38FB84B15A;
	Thu,  9 Sep 2021 09:54:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XkqGufp48opl; Thu,  9 Sep 2021 09:54:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DE84B163;
	Thu,  9 Sep 2021 09:54:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 338764B15A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:54:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qbQ67JwNtZcM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 09:54:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 103414B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:54:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631195676;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xFZbxgj8R3amtjBawkP8XVm2i9AJag/7vP3QeWu31hQ=;
 b=FbgHNq+nTZ2kYQcdrb11Xpx9OIMhV7Vn/yTnpxAmVyxTzpmynYqBPISR3XZCSJ1fnx6Sko
 Y8oUo58rfoprMLgP7krJqXtuNtjKQnR2x/zvm8YmtunEDAdoL4WGurdu6/sFL1vhSVwYBj
 qobEiUM86POffj4CtRRAsnlOcsDiczQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-RTr70p_POoW2HmbIGuzpvQ-1; Thu, 09 Sep 2021 09:54:35 -0400
X-MC-Unique: RTr70p_POoW2HmbIGuzpvQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 r3-20020a05600c35c300b002fbb0888a42so803993wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 06:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=xFZbxgj8R3amtjBawkP8XVm2i9AJag/7vP3QeWu31hQ=;
 b=3Q0JvUmcQDCQbZWgNb9doz01B0WiwFBUTbGFQoAGOuO37FozISIQwNKROVhUwQQBBd
 WgnQehW2VlYiBd7cXJIAAe7HJRauEUB2lyEUNzAzl5rPgN9DIS3QvitLeLIUfSBq0zE6
 iZWGAmJQ4BLsLjQd058To2IZQ8TpmxiomWe/6f+vwlEKALFVubGNCLRaID+483ysGP6B
 T+N6iz/ba0bMxig4UuhIEIX3HEQD4f8mZWVgXajizvLo6D/GVX9xTPlcJQABbjOv7hQl
 D0QO8avldNpZSw/E1HxUrVliruKix2Pm7Eh1ql2CzmsV96PtlFpulkf7y1wVnjByWTZd
 xhdg==
X-Gm-Message-State: AOAM531L/DjlckgthfD0ouRaadDZ6ZHCbB9W6kqJa3mKvSC3kmAy28S8
 3M76dgky2yGEIn7KnK2jIHZCl9xC/0+ifRNefWL79hWywXVzeh8fm0E6mBRhega/ewVuMovh2tm
 1EUz4oAE0KZN9ZP1PyI/9UeNF
X-Received: by 2002:adf:ea0c:: with SMTP id q12mr3821512wrm.392.1631195673097; 
 Thu, 09 Sep 2021 06:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRPTzKGXmbntvIGfNCpfEK2WxpRguCDUXFlVS1CKNB3zc/RmHvQ0VrA9rIG5hJQfEz4egnmg==
X-Received: by 2002:adf:ea0c:: with SMTP id q12mr3821500wrm.392.1631195672929; 
 Thu, 09 Sep 2021 06:54:32 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id i5sm1509373wmq.17.2021.09.09.06.54.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Sep 2021 06:54:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: test for vgic redist above the
 VM IPA size
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-3-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <83282104-ca04-c4f5-3570-c884a22ab667@redhat.com>
Date: Thu, 9 Sep 2021 15:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210908210320.1182303-3-ricarkol@google.com>
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

Hi Ricardo,

On 9/8/21 11:03 PM, Ricardo Koller wrote:
> This test attempts (and fails) to set a redistributor region using the
> legacy KVM_VGIC_V3_ADDR_TYPE_REDIST that's partially above the
> VM-specified IPA size.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 623f31a14326..6dd7b5e91421 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -285,6 +285,49 @@ static void test_vcpus_then_vgic(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_redist_above_vm_pa_bits(enum vm_guest_mode mode)
> +{
> +	struct vm_gic v;
> +	int ret, i;
> +	uint32_t vcpuids[] = { 1, 2, 3, 4, };
> +	int pa_bits = vm_guest_mode_params[mode].pa_bits;
> +	uint64_t addr, psize = 1ULL << pa_bits;
> +
> +	/* Add vcpu 1 */
> +	v.vm = vm_create_with_vcpus(mode, 1, DEFAULT_GUEST_PHY_PAGES,
> +				    0, 0, guest_code, vcpuids);
> +	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +
> +	/* Set space for half a redist, we have 1 vcpu, so this fails. */
> +	addr = psize - 0x10000;
> +	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "not enough space for one redist");
> +
> +	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
> +	addr = psize - (3 * 2 * 0x10000);
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);

I think you need to test both the old API (KVM_VGIC_V3_ADDR_TYPE_REDIST)
and the new one (KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION).

Can't you integrate those new checks in existing tests,
subtest_redist_regions() and subtest_dist_rdist() which already tests
base addr beyond IPA limit (but not range end unfortunately). look for
E2BIG.

Thanks

Eric
> +
> +	addr = 0x00000;
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +
> +	/* Add three vcpus (2, 3, 4). */
> +	for (i = 1; i < 4; ++i)
> +		vm_vcpu_add_default(v.vm, vcpuids[i], guest_code);
> +
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	/* Attempt to run a vcpu without enough redist space. */
> +	ret = run_vcpu(v.vm, vcpuids[3]);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +			"redist base+size above IPA detected on 1st vcpu run");
> +
> +	vm_gic_destroy(&v);
> +}
> +
>  static void test_new_redist_regions(void)
>  {
>  	void *dummy = NULL;
> @@ -542,6 +585,7 @@ int main(int ac, char **av)
>  	test_kvm_device();
>  	test_vcpus_then_vgic();
>  	test_vgic_then_vcpus();
> +	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
>  	test_new_redist_regions();
>  	test_typer_accesses();
>  	test_last_bit_redist_regions();

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
