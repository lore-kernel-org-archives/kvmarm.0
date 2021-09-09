Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E835C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:38:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF4EE611BF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:38:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF4EE611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DD234B149;
	Thu,  9 Sep 2021 09:38:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dOTukWwLH+0J; Thu,  9 Sep 2021 09:38:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1084B121;
	Thu,  9 Sep 2021 09:38:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1804B115
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FHLFnfXl8ADh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 09:38:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E1F4B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:38:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631194701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mIEy4vU6He4mxZAyPtvCnUdjgbnJN+ExybQr7N/yeGA=;
 b=VFK6/klLdEg9DSkSw3qlZYMTBM87+aX6PExCXrL8DPlb1NqcMkWWnV4+Pz4zERz7V+QjZZ
 sUxAhqkIth0njk5Ys/o78HcETw5dKnC9XEQczPNS9oTxsWPEG5IR8s2jTJKhmgvff07Bj/
 NACBye92x691snyNjnyhkoXXq0vWjBU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-wevMpAL3M-O4BGQruxOF4Q-1; Thu, 09 Sep 2021 09:38:18 -0400
X-MC-Unique: wevMpAL3M-O4BGQruxOF4Q-1
Received: by mail-wr1-f71.google.com with SMTP id
 j1-20020adff541000000b001593715d384so517388wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 06:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mIEy4vU6He4mxZAyPtvCnUdjgbnJN+ExybQr7N/yeGA=;
 b=cy27A6u0Av1jK8nbvKQ4FxykEbfBgXoP2Iw1kkfAkvicrfATHheig2HaqiGmEu6gjo
 ZTE3dg6bNSwmx0YaqnNO1STdxtdjGP6Er6OuZbA1ud6wBB4duwISgLyBZhO747lLqVFw
 eR9I9wdVaXvq9xSmcN0w1ocheDfR5Qs1cGNTL9iSDZd7XAMs+XohCaVToHSbkDJunMkl
 ZchPCod8w8wtTquRqSNH5cPAmtK7U6/nWLk+Ue/l7tUHNafTIqRQqe3Elnypq3F3ezPO
 r9+mjxSZlLhJz2XQOz+Em+tv39GRMGWmG7jZ2/9vZWQY3cvQeHeGav3VzJJcaSlduuP6
 kuBw==
X-Gm-Message-State: AOAM533mgn2qF15Lx81G2LT1avLSbhCv4YfUGB6rt8alJHsNtQldL/0a
 qAqSDT2Jt+s+OKDfX8HIbkNLOeTXFAyJM7xKdJXl3fQZdcrzbCKpt3qKSBM+dzuJZfDbyHgZQ4X
 DTTrA+S0esglFka3SN2vIXPm4
X-Received: by 2002:a05:6000:104e:: with SMTP id
 c14mr3672043wrx.130.1631194696913; 
 Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYhoRxlLOsZDoSKadFGu59kuAkRGfRF4uFoBJKfJmIsL3BnpQOfPdzBLXTxUvq41MnfbZmzg==
X-Received: by 2002:a05:6000:104e:: with SMTP id
 c14mr3672010wrx.130.1631194696645; 
 Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id t11sm1667345wmi.23.2021.09.09.06.38.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
Date: Thu, 9 Sep 2021 15:38:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG
 with ARM64_SYS_KVM_REG
Message-ID: <20210909133814.wsua43ya2erfw6gm@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-18-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210909013818.1191270-18-rananta@google.com>
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

On Thu, Sep 09, 2021 at 01:38:17AM +0000, Raghavendra Rao Ananta wrote:
> With the introduction of ARM64_SYS_KVM_REG, that takes the
> system register encodings from sysreg.h directly, replace
> all the users of ARM64_SYS_REG, relyiing on the encodings
> created in processor.h, with ARM64_SYS_KVM_REG.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
>  .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
>  .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
>  4 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 11fd23e21cb4..b28b311f4dd7 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
>  {
>  	uint64_t id_aa64dfr0;
>  
> -	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
> +	get_reg(vm, VCPU_ID, ARM64_SYS_KVM_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
>  	return id_aa64dfr0 & 0xf;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> index 018c269990e1..4c8aa7b8a65d 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> @@ -91,7 +91,8 @@ int main(void)
>  	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
>  	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> +	get_reg(vm, VCPU_ID_TARGET,
> +		ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &target_mpidr);

nit: I'd just leave this on one line. We don't mind long lines in this
part of town.

>  	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
>  	vcpu_run(vm, VCPU_ID_SOURCE);
>  
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 150f63101f4c..ee81dd3db516 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -16,16 +16,6 @@
>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>  			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>  
> -#define CPACR_EL1               3, 0,  1, 0, 2
> -#define TCR_EL1                 3, 0,  2, 0, 2
> -#define MAIR_EL1                3, 0, 10, 2, 0
> -#define MPIDR_EL1               3, 0,  0, 0, 5
> -#define TTBR0_EL1               3, 0,  2, 0, 0
> -#define SCTLR_EL1               3, 0,  1, 0, 0
> -#define VBAR_EL1                3, 0, 12, 0, 0
> -
> -#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> -
>  /*
>   * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
>   * SYS_* register definitions in sysreg.h to use in KVM
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9844b62227b1..d7b89aa092f5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -240,10 +240,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
>  	 * registers, which the variable argument list macros do.
>  	 */
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_CPACR_EL1), 3 << 20);
>  
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
> +	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), &sctlr_el1);
> +	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), &tcr_el1);
>  
>  	switch (vm->mode) {
>  	case VM_MODE_P52V48_4K:
> @@ -281,10 +281,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
>  	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), sctlr_el1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), tcr_el1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TTBR0_EL1), vm->pgd);
>  }
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> @@ -370,7 +370,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	extern char vectors;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
>  }
>  
>  void route_exception(struct ex_regs *regs, int vector)
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

I also agree with Oliver that this patch may be squashed into the one that
introduces ARM64_SYS_KVM_REG.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
