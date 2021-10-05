Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35A0C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:13:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60F656115B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60F656115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3EA14B2BC;
	Tue,  5 Oct 2021 04:13:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WjZXSLy0L1tY; Tue,  5 Oct 2021 04:13:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9044B2B2;
	Tue,  5 Oct 2021 04:13:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E934B2B2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:13:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WLt60zubl7OW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 04:12:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 067F54B2AB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:12:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633421578;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XjQ1/3iE4M+xISPrEkRaQBTN9sLKqhZlK9JKGdWWFPA=;
 b=AG0Uo0VIpxM4s+F97dNTcZ8j1TDr2kZkdgRs7ALvt2LpRabjnFLuWlBZSYiQAjNBIIPEvD
 bHKgpJCao7gTW8ZOAoVRuSXDVEkexxbqucn+wB9C0/1dgkPkBdooFlvIB85WpUvf8GLNUR
 Xip0lSGbXRV/HXKs9OvWSgHAzkknTSU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-sj6Fq6zsMcuo4cFHoaBU3w-1; Tue, 05 Oct 2021 04:12:56 -0400
X-MC-Unique: sj6Fq6zsMcuo4cFHoaBU3w-1
Received: by mail-wm1-f70.google.com with SMTP id
 x3-20020a05600c21c300b0030d2b0fb3b4so7358346wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 01:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=XjQ1/3iE4M+xISPrEkRaQBTN9sLKqhZlK9JKGdWWFPA=;
 b=g5et+gs21hy08tKQiS6FRb86Y2lAeTALgoEYmlewnrcaq+ORHtYqH80bUiYzla/DYu
 1v1fSqAoUOmvLGoBN6j+gqpNVbtqH6e+BA8hjgniyt4NZjV46USIZ3076efgRE1Rhjx6
 8+T6WsP4a+5URqCkgGAom3NKrY5rUNQ7RvKkQjnOlR7tl/us+AipSaK+zT8rKrRgMfXO
 JhmP6b2ESaA0qtxJ3pG9HPthQ1WLOxCP2hg7vSxa+74c8Zdzyjlmdh9WZgrAlMAGYcEF
 zZIggh0HsXBGHTuD8P+1Mhc/GbM6sfXFrTmbmojbUNX59YMFi1sbDVQO3y+qAKC36MSE
 yJPQ==
X-Gm-Message-State: AOAM533nrN92IU4dtSopkB83pF678atwOFFUq5Xo0SVEOCUwUtfvdohe
 DLsZSAuS5ZvGyjgV81gT3aQCkALKlbJVrcLT+v//Pvs4vIXDqa3BLv1eYGhst3hqyEUypreQqtK
 6r154uPbnMsL/cwBlRFxiNzDD
X-Received: by 2002:a7b:c314:: with SMTP id k20mr1932035wmj.50.1633421575676; 
 Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5JjnFWO0IRALy8LbJuimfozYaSNNcNoqrFLt/UG8KArCfpQH6NJkJJjBCnwWe/cUNT8ynDA==
X-Received: by 2002:a7b:c314:: with SMTP id k20mr1932016wmj.50.1633421575476; 
 Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id z18sm10150526wro.25.2021.10.05.01.12.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
Subject: Re: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-10-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <741f4f59-c4e7-1bd8-f517-9d2536968772@redhat.com>
Date: Tue, 5 Oct 2021 10:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-10-ricarkol@google.com>
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
On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add tests for checking that KVM returns the right error when trying to
> set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> addressable IPA range. Also tighten the IPA range by replacing
> KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> guest (i.e., the default).
>
> The check for the GICv3 redistributor created using the REDIST legacy
> API is not sufficient as this new test only checks the check done using
> vcpus already created when setting the base. The next commit will add
> the missing test which verifies that the KVM check is done at first vcpu
> run.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
>  1 file changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index cb69e195ad1d..eadd448b3a96 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -31,7 +31,7 @@ struct vm_gic {
>  	uint32_t gic_dev_type;
>  };
>  
> -static int max_ipa_bits;
> +static uint64_t max_phys_size;
>  
>  /* helper to access a redistributor register */
>  static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> @@ -152,16 +152,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
>  	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
>  
>  	/* out of range address */
> -	if (max_ipa_bits) {
> -		addr = 1ULL << max_ipa_bits;
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 dist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 dist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
>  
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 rdist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> -	}
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> +
> +	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
> +	addr = max_phys_size - dist.alignment;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +			"half of the redist is beyond IPA limit");
>  
>  	/* set REDIST base address @0x0*/
>  	addr = 0x00000;
> @@ -250,12 +255,19 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
>  
> -	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
> +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
>  	TEST_ASSERT(ret && errno == E2BIG,
>  		    "register redist region with base address beyond IPA range");
>  
> +	/* The last redist is above the pa range. */
> +	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		    "register redist region with top address beyond IPA range");
> +
>  	addr = 0x260000;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> @@ -610,8 +622,10 @@ void run_tests(uint32_t gic_dev_type)
>  int main(int ac, char **av)
>  {
>  	int ret;
> +	int pa_bits;
>  
> -	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> +	max_phys_size = 1ULL << pa_bits;
>  
>  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
>  	if (!ret) {

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
