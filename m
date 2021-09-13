Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E937C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 21:21:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8365D6113D
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 21:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8365D6113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 101514B1D0;
	Mon, 13 Sep 2021 17:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iSDkd5z2caRg; Mon, 13 Sep 2021 17:21:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032234B1D5;
	Mon, 13 Sep 2021 17:21:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CAD94B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 17:21:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RWl1BDKp-CTx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 17:21:54 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3918B4B1C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 17:21:54 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id j1so7330635pjv.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fWNyNuWnfBEyX//B3PcmZaO6uYna7uC+39up3Pmvm+8=;
 b=VNbYPScpWdu/+9kJQYujI627m1cbPd5AK0q3W7rUtsjD+wQqf5uxTRUPkyNLcI+vsQ
 95ls9st99bgw1HEG0Lg2EnQtls8De5iWrAA1e8dA6kh+GcSy+cQi+FQaCdfsLKjo25sM
 vlVpDN7nfXWECP+z3ri6WMc3A2iYS3cqkW6Gppp2HlyhbcyOJVCH8kRBKwlxialjStqK
 9CR9Oo1Bmn654iRbxkf5vE6oPSYOMxNOKwU8ABELek1ptfDV3XlL6eDmnWRy3x8yD2ch
 2471SYHeslbj40c3FpwZTJgvANBUZxfrTM5K+vimM47ItTxkgOkK3Qd736c7HNwuu2vy
 gVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fWNyNuWnfBEyX//B3PcmZaO6uYna7uC+39up3Pmvm+8=;
 b=wSw54wQoDraV+k7RMdPtApRJWpaY51Q69LF9Cya5ZDzzBvM/dH7ATuhr3TDrna6jaA
 6TrdGvLI/7d1EKtZRmNK5fhzJGPUtG1hVJhBzKdaRgdLZHOLt5S2KuU1NQsRO8P7RhZs
 jKJCVF6Jl2AZNt1u/8WolFHmCkJWCF09jzSaJc3tIxawbs8x8uddYWtO90EM3jjJ0ti7
 3G55HnVmSIBAhstiZ0R1VlNiF4dEywrxPHUl1WHJu0uCDaqGU8AJkaImJX4JaIlCFiPK
 Rs3CPivaTz7VvmhW09jmENs2bHBmgpYWmBcjl/PxspbCrBNHQnsDT1D7t4Md/BUp1n0G
 vsFA==
X-Gm-Message-State: AOAM532ipvD6r/A49zV9xPVRXl0mJ7GPZmuGiRpYnLwrVRXxxQIYPyuO
 r46oeM2eWt9Fr7Od2UhEwFuNLg==
X-Google-Smtp-Source: ABdhPJwvIW9IiYxlpkcbkQt8tmAgik541eS8PeQM06VAFcAI9aAjBD1MujGdRq9Puie33WX2z1QICg==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id
 w16-20020a170902a710b029012b9b9fc461mr12262098plq.59.1631568113182; 
 Mon, 13 Sep 2021 14:21:53 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h4sm9572790pgn.6.2021.09.13.14.21.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 14:21:52 -0700 (PDT)
Date: Mon, 13 Sep 2021 14:21:49 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <YT/A7YcsxxaBZTCn@google.com>
References: <20210913204930.130715-1-rananta@google.com>
 <20210913204930.130715-10-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210913204930.130715-10-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Mon, Sep 13, 2021 at 08:49:25PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
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
> -- 
> 2.33.0.309.g3052b89438-goog
>

Very nice!

Reviewed-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
