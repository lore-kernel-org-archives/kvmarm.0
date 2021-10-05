Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B75CC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:45:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C988261506
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C988261506
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4529E4B2D9;
	Tue,  5 Oct 2021 09:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OFaxFM7DRIjI; Tue,  5 Oct 2021 09:45:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C33B4B305;
	Tue,  5 Oct 2021 09:45:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 554A14B2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:45:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F1c-7V4EX8Fg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:45:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E73F44B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:45:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633441544;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=42UgaX+yPPSur2IHewijgtsVBHiFLbM3G0lScESYZo4=;
 b=MhNY0cB+S5GAl0sjrZYMnJPhu65Wu+ZiM9lqAWbX9ewIFjEzt4EeswRZSPOoJwCCVNCSuc
 iuucxMoDStXMDupZmplWtVuzPTx1MjmqCwXtu5YK/E+M405NtVCtsVBerl49kxS2jwtfgu
 C/CdwO50MyFYuX18dcwgMi2R25ZZriQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-_GZxGiKIPdyuGk-qjNjNGg-1; Tue, 05 Oct 2021 09:45:43 -0400
X-MC-Unique: _GZxGiKIPdyuGk-qjNjNGg-1
Received: by mail-ed1-f72.google.com with SMTP id
 y15-20020a50ce0f000000b003dab997cf7dso17175674edi.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=42UgaX+yPPSur2IHewijgtsVBHiFLbM3G0lScESYZo4=;
 b=2boXzJM6KO6MMD5lfzdSA2VH3qFxFZkY8msTIRcqsY4IhQRjCVurMi2/K064BH12Om
 WVGTSyE4moB6M+6DJBi2JOQQMemPtN49KzgUwyRP3vnS4eWrt3NMZhHAqg8yxpOQo+Vp
 53BYLXOFT6WhbBauX3+WoUrJ/036ciI/KBXBAm0NYmJGkDPv2S5gc+9PpCd1S5puAUyY
 3Re8AgXpyb8ImqDoUa/Ilq/IS0dcp1DGNLWKR0K8YV93Ol2iLkLUUDlA6PePY4dcJGPK
 pYFVqtLbz+T6yOBp0QW+5teP5SsmqhX4uRqPbU5g2ZaHS/ozTxwbIcBBRtbn7UMgybTK
 C9Kw==
X-Gm-Message-State: AOAM530nKjBvzndOv3NQZwAPL3sHm/1QxCf9zY5oRBMV5Xi8HZT6fF3F
 iIiL9GlBTdnqgpohQ+JPHJMG4WN+7FGcCPSmG4wjw5BAiMwN3ThqdRsFxVvToFF/td6yw7HnQhj
 PrKnB77huSazIhG0TaYfpSOFh
X-Received: by 2002:a17:907:77c8:: with SMTP id
 kz8mr19917207ejc.406.1633441542553; 
 Tue, 05 Oct 2021 06:45:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHs6aQU5utBmnbI84MI2Vww5ChForJLtR0LWAJm21f+VNfybnM0FYZWxhpyBNbkbiUjUdlGA==
X-Received: by 2002:a17:907:77c8:: with SMTP id
 kz8mr19917184ejc.406.1633441542365; 
 Tue, 05 Oct 2021 06:45:42 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id de36sm8145995ejc.72.2021.10.05.06.45.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:45:41 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:45:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
Message-ID: <20211005134539.s7kzhqlg2pykfcam@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-11-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-11-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> Split up the current test into several helpers that will be useful to
> subsequent test cases added to the PSCI test suite.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
>  1 file changed, 45 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 8d043e12b137..90312be335da 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
>  	return res.a0;
>  }
>  
> -static void guest_main(uint64_t target_cpu)
> +static void guest_test_cpu_on(uint64_t target_cpu)
>  {
>  	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
>  	uint64_t target_state;
> @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
>  	vcpu_set_mp_state(vm, vcpuid, &mp_state);
>  }
>  
> -int main(void)
> +static struct kvm_vm *setup_vm(void *guest_code)
>  {
> -	uint64_t target_mpidr, obs_pc, obs_x0;
>  	struct kvm_vcpu_init init;
>  	struct kvm_vm *vm;
> -	struct ucall uc;
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  	kvm_vm_elf_load(vm, program_invocation_name);
> @@ -83,31 +81,28 @@ int main(void)
>  	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
>  	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
>  
> -	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> -	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> +	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> +	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
>  
> -	/*
> -	 * make sure the target is already off when executing the test.
> -	 */
> -	vcpu_power_off(vm, VCPU_ID_TARGET);
> +	return vm;
> +}
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> -	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> -	vcpu_run(vm, VCPU_ID_SOURCE);
> +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct ucall uc;
>  
> -	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> -	case UCALL_DONE:
> -		break;
> -	case UCALL_ABORT:
> +	vcpu_run(vm, vcpuid);
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
>  		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
>  			  uc.args[1]);
> -		break;
> -	default:
> -		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> -	}
> +}
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	uint64_t obs_pc, obs_x0;
> +
> +	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> +	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
>  
>  	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
>  		    "unexpected target cpu pc: %lx (expected: %lx)",
> @@ -115,7 +110,34 @@ int main(void)
>  	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
>  		    "unexpected target context id: %lx (expected: %lx)",
>  		    obs_x0, CPU_ON_CONTEXT_ID);
> +}
>  
> +static void host_test_cpu_on(void)
> +{
> +	uint64_t target_mpidr;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = setup_vm(guest_test_cpu_on);
> +
> +	/*
> +	 * make sure the target is already off when executing the test.
> +	 */
> +	vcpu_power_off(vm, VCPU_ID_TARGET);
> +
> +	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> +	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +
> +	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> +		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> +
> +	assert_vcpu_reset(vm, VCPU_ID_TARGET);
>  	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	host_test_cpu_on();
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
>

Hard to read diff, but I think the refactoring comes out right. Please do
this refactoring before adding the new test in the next revision, though.

Anyway, ignoring the new test context, which I think is changing with the
next revision

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
