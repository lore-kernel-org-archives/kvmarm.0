Return-Path: <SRS0=YLka=FS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977E2C4361B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 14:03:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E94B922B40
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 14:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E94B922B40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4EF4B650;
	Mon, 14 Dec 2020 09:03:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cDAP5dOp5htt; Mon, 14 Dec 2020 09:03:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 259DC4B657;
	Mon, 14 Dec 2020 09:03:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 949EF4B64E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 09:02:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xVEnsvmy+i5s for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Dec 2020 09:02:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F94C4B644
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 09:02:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90F8130E;
 Mon, 14 Dec 2020 06:02:56 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0CC73F66E;
 Mon, 14 Dec 2020 06:02:55 -0800 (PST)
Subject: Re: [PATCH 5/5] KVM: arm64: Remove redundant call to
 kvm_pmu_vcpu_reset()
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
 <20201201150157.223625-6-alexandru.elisei@arm.com>
 <9f68ed5e-371e-6c0c-7ba3-b14ff059430f@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <eba17923-3e33-3e3d-0cf0-8f66d389146b@arm.com>
Date: Mon, 14 Dec 2020 14:02:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <9f68ed5e-371e-6c0c-7ba3-b14ff059430f@redhat.com>
Content-Language: en-US
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

Hi Eric,

Thanks for having a look!

On 12/14/20 1:48 PM, Auger Eric wrote:
> Alexandru,
>
> On 12/1/20 4:01 PM, Alexandru Elisei wrote:
>> KVM_ARM_VCPU_INIT ioctl calls kvm_reset_vcpu(), which in turn resets the
>> PMU with a call to kvm_pmu_vcpu_reset(). The function zeroes the PMU
>> chained counters bitmap and stops all the counters with a perf event
>> attached. Because it is called before the VCPU has had the chance to run,
>> no perf events are in use and none are released.
>>
>> kvm_arm_pmu_v3_enable(), called by kvm_vcpu_first_run_init() only if the
>> VCPU has not been initialized, also resets the PMU. kvm_pmu_vcpu_reset() in
> This sounds strange to me. kvm_vcpu_first_run_init() only is called if
> kvm_vcpu_initialized(vcpu) is true.

Typo on my part, the "not" should not be there. kvm_vcpu_first_run_init() is
called only if kvm_vcpu_initialized() returns true in kvm_arch_vcpu_ioctl_run().

>> this case does the exact same thing as the previous call, so remove it.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 398f6df1bbe4..4ad66a532e38 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -850,8 +850,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>>  		   return -EINVAL;
>>  	}
>>  
>> -	kvm_pmu_vcpu_reset(vcpu);
>> -
> this patch does not apply for me (vcpu->arch.pmu.ready = true; ?)

I should have mentioned it in the cover letter, this is on top of Marc's pmu-undef
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-undef

it should work on top of commit 7521c3a9e630 ("KVM: arm64: Get ready of the PMU
ready state"), the branch was rebased since I sent the patches.

Thanks,
Alex
>
> Thanks
>
> Eric
>>  	return 0;
>>  }
>>  
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
