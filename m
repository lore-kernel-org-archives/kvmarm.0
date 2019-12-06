Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311A0C2D0B1
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 10:11:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B388B2464E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 10:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B388B2464E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3724AF43;
	Fri,  6 Dec 2019 05:11:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0D2V8JmWUkUD; Fri,  6 Dec 2019 05:10:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A024AF0C;
	Fri,  6 Dec 2019 05:10:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0694AF08
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 05:10:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xCCdavbBgjge for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 05:10:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F154ACE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 05:10:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E175DDA7;
 Fri,  6 Dec 2019 02:10:56 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA3713F718;
 Fri,  6 Dec 2019 02:10:54 -0800 (PST)
Subject: Re: [PATCH] KVM: arm: get rid of unused arg in cpu_init_hyp_mode()
To: linmiaohe <linmiaohe@huawei.com>, "maz@kernel.org" <maz@kernel.org>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "will@kernel.org" <will@kernel.org>,
 "andre.przywara@arm.com" <andre.przywara@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
References: <8efe4ab7f8c44c48a70378247c511edc@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <11f06523-54ce-7025-a6ba-58c29769da60@arm.com>
Date: Fri, 6 Dec 2019 10:10:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8efe4ab7f8c44c48a70378247c511edc@huawei.com>
Content-Language: en-US
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On 30/11/2019 07:20, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> As arg dummy is not really needed, there's no need to pass NULL when calling cpu_init_hyp_mode(). So clean it up.

It looks like the requirement for this dummy arg was removed in
67f691976662 ("arm64: kvm: allows kvm cpu hotplug"). FWIW:

Reviewed-by: Steven Price <steven.price@arm.com>

>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>> virt/kvm/arm/arm.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 86c6aa1cb58e..a5470f1b1a19 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1315,7 +1315,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>> 	}
>> }
>>
>> -static void cpu_init_hyp_mode(void *dummy)
>> +static void cpu_init_hyp_mode(void)
>> {
>> 	phys_addr_t pgd_ptr;
>> 	unsigned long hyp_stack_ptr;
>> @@ -1349,7 +1349,7 @@ static void cpu_hyp_reinit(void)
>> 	if (is_kernel_in_hyp_mode())
>> 		kvm_timer_init_vhe();
>> 	else
>> -		cpu_init_hyp_mode(NULL);
>> +		cpu_init_hyp_mode();
>>
>> 	kvm_arm_init_debug();
>>
> friendly ping ...
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
