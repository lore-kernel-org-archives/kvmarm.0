Return-Path: <SRS0=HAfI=OF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEF8C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 05:55:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3712A61166
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 05:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3712A61166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B814B08D;
	Wed, 15 Sep 2021 01:55:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e0w0Pnyjxs5h; Wed, 15 Sep 2021 01:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 854694B0C0;
	Wed, 15 Sep 2021 01:55:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7494B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Sep 2021 01:55:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WN5Qe4mSBAef for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Sep 2021 01:55:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0244B08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Sep 2021 01:55:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631685327;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1DwJ1KTIB7hUlgx6Gbyk1HsMO32BArQQYzWt/TxPxbA=;
 b=evz3Jt9u07hd6MWMzJ2/7f47N9wcSMPp2LgWQhn9mHorRYrC22ZTVvsqtoRcdF5A2jKVb/
 k78Fj8jo0WYE09TCEmB4zffPPNETDdqjwwLkDdnsZXNKqoUk64S/gPv5C6p7BB2DaH7QB2
 UcI2tw3uVT8Gt7941Apacv1qNNrwMN0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-CTNU3HgoNHaLGNfSsgY5Vw-1; Wed, 15 Sep 2021 01:55:26 -0400
X-MC-Unique: CTNU3HgoNHaLGNfSsgY5Vw-1
Received: by mail-ej1-f71.google.com with SMTP id
 r1-20020a17090609c100b005f2e44b96e9so916261eje.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 22:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1DwJ1KTIB7hUlgx6Gbyk1HsMO32BArQQYzWt/TxPxbA=;
 b=DvhJ+CE7Z4WiEl1uKHzgyKKfmssgMmBU5gGuvl0W3hoyfSopFxY7CJ/I3nJQ3cdZBe
 wU0v+jBWBlRpltSTK3pHhi3PlEfuBakPT/lN6IhCaX9rZU4pTRB+WsV9fe1JbVDW0Ons
 a9Gcvc90dL6EZCPCGVcqdFOsxrxo6fxEJfTRkzmTwS4AnT9AlY9IOOOV73RFVVWUeSAV
 E6zwSzr4qf3tVc72jk5P9Yvf14L+5DCUxmaQLbq2SwELGT2FK6eSgQoLCv2kdSt9h5fE
 yK3PocbbZI4KmvYnFqBXSFJnz3ltYR1UsF7ewXIMVFj9mthe2rutEvICbjOlXA2ArFjy
 ooWQ==
X-Gm-Message-State: AOAM5319QnDiUkVAwBa8GCRjYEWMAcasdtmGnjGSW3i+kniTbahpQ08S
 r0geccuXMDAW9FF5a1QCp5URuilcA9VD6vTOEgwAozyt6qHJzZccqrVLDltdgAUc+7WaC5iV1Ww
 n6uAU/ESKHCrchcIt1AUhw5mV
X-Received: by 2002:a17:906:7b54:: with SMTP id
 n20mr22648242ejo.525.1631685324891; 
 Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQnNewa/jHu06DPoH582l/z5Z2baVFnXYetWnCTZNqx//uBa4MP/NR9DVl2rwfSR6xCXaEnw==
X-Received: by 2002:a17:906:7b54:: with SMTP id
 n20mr22648222ejo.525.1631685324745; 
 Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id f30sm5681448ejl.78.2021.09.14.22.55.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
Date: Wed, 15 Sep 2021 07:55:22 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v7 10/15] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210915055522.o3wnygwk6bpr4zrx@gator.home>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-11-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210914223114.435273-11-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Sep 14, 2021 at 10:31:09PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..bcf05f5381ed 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  
> +uint32_t guest_get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 34f6bd47661f..b4eeeafd2a70 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
>  }
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> @@ -426,3 +427,8 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +uint32_t guest_get_vcpuid(void)
> +{
> +	return read_sysreg(tpidr_el1);
> +}
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
