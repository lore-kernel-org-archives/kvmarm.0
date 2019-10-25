Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4C4CA9EAF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 02:48:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CE3221929
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 02:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CE3221929
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD914A5EE;
	Thu, 24 Oct 2019 22:48:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vkZnm9hmefDp; Thu, 24 Oct 2019 22:48:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5B44A541;
	Thu, 24 Oct 2019 22:48:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F844A522
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 22:48:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qadUS1yKok4B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 22:48:50 -0400 (EDT)
Received: from out30-130.freemail.mail.aliyun.com
 (out30-130.freemail.mail.aliyun.com [115.124.30.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54DC44A4E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 22:48:50 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R681e4; CH=green; DM=||false|;
 FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01451; MF=shannon.zhao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0Tg7T0fg_1571971726; 
Received: from 30.43.121.138(mailfrom:shannon.zhao@linux.alibaba.com
 fp:SMTPD_---0Tg7T0fg_1571971726) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 25 Oct 2019 10:48:46 +0800
Subject: Re: [PATCH RFC 0/7] Support KVM being compiled as a kernel module on
 arm64
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>
References: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
 <8cbd81d6-4ab8-9d2a-5162-8782201cd13d@arm.com>
 <c17e8b0f32902a0811cc6a4ed71e607e@www.loen.fr>
From: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Message-ID: <18653462-38dc-cce1-d0a1-2a7e891163da@linux.alibaba.com>
Date: Fri, 25 Oct 2019 10:48:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c17e8b0f32902a0811cc6a4ed71e607e@www.loen.fr>
Content-Language: en-US
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2019/10/24 21:41, Marc Zyngier wrote:
> On 2019-10-24 11:58, James Morse wrote:
>> Hi Shannon,
>>
>> On 24/10/2019 11:27, Shannon Zhao wrote:
>>> Curently KVM ARM64 doesn't support to compile as a kernel module. It's
>>> useful to compile KVM as a module.
>>
>>> For example, it could reload kvm without rebooting host machine.
>>
>> What problem does this solve?
>>
>> KVM has some funny requirements that aren't normal for a module. On
>> v8.0 hardware it must
>> have an idmap. Modules don't usually expect their code to be
>> physically contiguous, but
>> KVM does. KVM influences they way some of the irqchip stuff is set up
>> during early boot
>> (EOI mode ... not that I understand it).
> 
> We change the EOImode solely based on how we were booted (EL2 or not).
> KVM doesn't directly influences that (it comes in the picture much
> later).
> 
>> (I think KVM-as-a-module on x86 is an artifact of how it was developed)
>>
>>
>>> This patchset support this feature while there are some limitations
>>> to be solved. But I just send it out as RFC to get more suggestion and
>>> comments.
>>
>>> Curently it only supports for VHE system due to the hyp code section
>>> address variables like __hyp_text_start.
>>
>> We still need to support !VHE systems, and we need to do it with a
>> single image.
>>
>>
>>> Also it can't call
>>> kvm_update_va_mask when loading kvm module and kernel panic with below
>>> errors. So I make kern_hyp_va into a nop funtion.
>>
>> Making this work for the single-Image on v8.0 is going to be a
>> tremendous amount of work.
>> What is the payoff?
> 
> I can only agree. !VHE is something we're going to support for the 
> foreseeable
> future (which is roughly equivalent to "forever"), and modules have 
> properties
> that are fundamentally incompatible with the way KVM works with !VHE.
> 
Yes, with this patchset we still support !VHE system with built-in KVM. 
While for VHE system we could support kernel module and check at module 
init to avoid wrong usage of kvm module on !VHE systems.

> If the only purpose of this work is to be able to swap KVM implementations
> in a development environment, then it really isn't worth the effort.
> 
Making KVM as a kernel module has many advantages both for development 
and real use environment. For example, we can backport and update KVM 
codes independently and don't need to recompile kernel. Also making KVM 
as a kernel module is a basic for kvm hot upgrade feature without 
shutdown VMs and hosts. This is very important for Cloud Service 
Provider to provides non-stop services for its customers.

Thanks,
Shannon
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
