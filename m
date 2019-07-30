Return-Path: <SRS0=XAfE=V3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B99C0650F
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 14:08:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F1DC20651
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 14:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F1DC20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA27E4A52B;
	Tue, 30 Jul 2019 10:08:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hHT8jF7yQzN9; Tue, 30 Jul 2019 10:08:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84AF04A533;
	Tue, 30 Jul 2019 10:08:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B83DA4A52B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 10:08:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqEIP6-oMz8L for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jul 2019 10:08:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB334A51C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 10:08:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E47AE28;
 Tue, 30 Jul 2019 07:08:35 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FD2A3F694;
 Tue, 30 Jul 2019 07:08:35 -0700 (PDT)
Subject: Re: [PATCH 11/59] KVM: arm64: nv: Inject HVC exceptions to the
 virtual EL2
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-12-marc.zyngier@arm.com>
 <c83d9421-a027-9edf-021b-5d41a7a1884b@arm.com>
Message-ID: <e0e78eea-0e84-7afd-2b4f-2887f07d99aa@arm.com>
Date: Tue, 30 Jul 2019 15:08:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c83d9421-a027-9edf-021b-5d41a7a1884b@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

On 6/25/19 2:13 PM, Alexandru Elisei wrote:
> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> Now that the psci call is done by the smc instruction when nested
> This suggests that we have support for PSCI calls using SMC as the conduit, but
> that is not the case, as the handle_smc function is not changed by this commit,
> and support for PSCI via SMC is added later in patch 22/59 "KVM: arm64: nv:
> Handle PSCI call via smc from the guest". Perhaps the commit message should be
> reworded to reflect that?
>> virtualization is enabled, it is clear that all hvc instruction from the
>> VM (including from the virtual EL2) are supposed to handled in the
>> virtual EL2.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/handle_exit.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 516aead3c2a9..6c0ac52b34cc 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -30,6 +30,7 @@
>>  #include <asm/kvm_coproc.h>
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_nested.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/traps.h>
>>  
>> @@ -52,6 +53,12 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  			    kvm_vcpu_hvc_get_imm(vcpu));
>>  	vcpu->stat.hvc_exit_stat++;
>>  
>> +	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
>> +	if (nested_virt_in_use(vcpu)) {
>> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +		return 1;
>> +	}

According to ARM DDI 0487E.a, when HCR_EL2.HCD = 1, HVC instructions are
undefined at EL2 and EL1.

Thanks,
Alex
>> +
>>  	ret = kvm_hvc_call_handler(vcpu);
>>  	if (ret < 0) {
>>  		vcpu_set_reg(vcpu, 0, ~0UL);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
