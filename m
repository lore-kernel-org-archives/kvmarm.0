Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8B4C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 07:03:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E1A361164
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 07:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1E1A361164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D5EE4B1AB;
	Tue, 14 Sep 2021 03:03:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JqHerWEYaC-s; Tue, 14 Sep 2021 03:03:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BD134B11F;
	Tue, 14 Sep 2021 03:03:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FFC94B106
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 03:03:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSNoo+2lEXRb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 03:03:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122FE4B105
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 03:03:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631603025;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DtVBH46SHKoKIwsFmytf76PwR5kg53yG9EF+y3kvUPg=;
 b=HOpy1xKoHjeoiwDskV3zVevE904JYUcsFTNMeqXweL3orhPqC/rPWV+yywP/6cJw0wWXUr
 AyqyKBhPikEus7TItY3kVyXF9uCT+wnf+GyfufRCPRdJ4VCIFN6bxbScqME0reVq93g/y9
 Ej5jb8tpJDUO21KcbWWbnka4r04Aq7s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-hOMxPtUqPPKYsEoCRK4CtQ-1; Tue, 14 Sep 2021 03:03:44 -0400
X-MC-Unique: hOMxPtUqPPKYsEoCRK4CtQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 ga42-20020a1709070c2a00b005dc8c1cc3a1so4850662ejc.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 00:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DtVBH46SHKoKIwsFmytf76PwR5kg53yG9EF+y3kvUPg=;
 b=2ZtiTI63iWiGQXksTToi+XOEixgdcX598pioot6EniPrsMujpCTSE3M/TXLr8JT1Qn
 eGmvLQsJitgI732zlTBrhnJR7bt5Of2w+O3Z/o001ziBCQQSa42RxBiw4qPTQrDzwXLN
 OwjYv0f9vxJSjhOGazM89c7r2e2/dsIMrPnvCNhC/nEScJWPwnV+8pzqjO07L8x+EEW9
 uIhCI0HuS1f1UsZUzhOLMfy+ndB+GbGd7tdNXTF3HEnTrC5b2qlR1qw9fiFuJ2MR3N+d
 qWVAovMu3GzIZrjHMSY1AcUIIYvNnlPIh+rtB+xbZ10RcYQ2YaaZya5OcUp7zQ7YWmy8
 ZbSQ==
X-Gm-Message-State: AOAM5318fWKpQsm+m4Nkr2sBKsEk2U4HrmyLs4SLlbknJfGWLsGqtpfy
 K72FetpIo+toNFyr2S6UNoC6h+K3cRWhpR0FZlEzLIUy23UtODij9sofud/dbfDqS674Smr4zPE
 aQHW8qBi4kV6DzCGgLDmKgyrv
X-Received: by 2002:a05:6402:b51:: with SMTP id
 bx17mr3708301edb.193.1631603023664; 
 Tue, 14 Sep 2021 00:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0u6Qmz0LoEVgIkKptzeNa1oFg+cIIJwCsprxz814Q0ubDMMz/MEr05MP7ZdWlQt3KbrYwPQ==
X-Received: by 2002:a05:6402:b51:: with SMTP id
 bx17mr3708282edb.193.1631603023377; 
 Tue, 14 Sep 2021 00:03:43 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id bq4sm4460079ejb.43.2021.09.14.00.03.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Sep 2021 00:03:42 -0700 (PDT)
Date: Tue, 14 Sep 2021 09:03:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210914070340.u6fp5zo7pjpxdlga@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-10-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210913230955.156323-10-rananta@google.com>
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

On Mon, Sep 13, 2021 at 11:09:50PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..5770751a5735 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  
> +int guest_get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index db64ee206064..f1255f44dad0 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini

x86's vcpu_setup strangely uses 'int' for vcpuid even though everywhere
else we use uint32_t. Unfortunately that strangeness got inherited by
aarch64 (my fault). We should change it to uint32_t here (as a separate
patch) and...

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
> +int guest_get_vcpuid(void)
> +{
> +	return read_sysreg(tpidr_el1);
> +}

...return uint32_t here.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
