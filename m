Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FB2CA9EBC
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 10:43:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1AB02084C
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 10:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1AB02084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8264A52E;
	Fri, 25 Oct 2019 06:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t+-5J+KntaOo; Fri, 25 Oct 2019 06:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 002F44A51F;
	Fri, 25 Oct 2019 06:43:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21DDF4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 06:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d0ndBFClUqi2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 06:43:16 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBCFE4A4A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 06:43:15 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iNx3o-00039M-NY; Fri, 25 Oct 2019 12:43:12 +0200
To: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Subject: Re: [PATCH RFC 0/7] Support KVM being compiled as a kernel module on
 arm64
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 25 Oct 2019 11:43:12 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <18653462-38dc-cce1-d0a1-2a7e891163da@linux.alibaba.com>
References: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
 <8cbd81d6-4ab8-9d2a-5162-8782201cd13d@arm.com>
 <c17e8b0f32902a0811cc6a4ed71e607e@www.loen.fr>
 <18653462-38dc-cce1-d0a1-2a7e891163da@linux.alibaba.com>
Message-ID: <66e983b383d9f99df0007a717e084fe6@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, christoffer.dall@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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

On 2019-10-25 03:48, Shannon Zhao wrote:
> On 2019/10/24 21:41, Marc Zyngier wrote:
>> On 2019-10-24 11:58, James Morse wrote:
>>> Hi Shannon,
>>>
>>> On 24/10/2019 11:27, Shannon Zhao wrote:
>>>> Curently KVM ARM64 doesn't support to compile as a kernel module. 
>>>> It's
>>>> useful to compile KVM as a module.
>>>
>>>> For example, it could reload kvm without rebooting host machine.
>>>
>>> What problem does this solve?
>>>
>>> KVM has some funny requirements that aren't normal for a module. On
>>> v8.0 hardware it must
>>> have an idmap. Modules don't usually expect their code to be
>>> physically contiguous, but
>>> KVM does. KVM influences they way some of the irqchip stuff is set 
>>> up
>>> during early boot
>>> (EOI mode ... not that I understand it).
>> We change the EOImode solely based on how we were booted (EL2 or 
>> not).
>> KVM doesn't directly influences that (it comes in the picture much
>> later).
>>
>>> (I think KVM-as-a-module on x86 is an artifact of how it was 
>>> developed)
>>>
>>>
>>>> This patchset support this feature while there are some 
>>>> limitations
>>>> to be solved. But I just send it out as RFC to get more suggestion 
>>>> and
>>>> comments.
>>>
>>>> Curently it only supports for VHE system due to the hyp code 
>>>> section
>>>> address variables like __hyp_text_start.
>>>
>>> We still need to support !VHE systems, and we need to do it with a
>>> single image.
>>>
>>>
>>>> Also it can't call
>>>> kvm_update_va_mask when loading kvm module and kernel panic with 
>>>> below
>>>> errors. So I make kern_hyp_va into a nop funtion.
>>>
>>> Making this work for the single-Image on v8.0 is going to be a
>>> tremendous amount of work.
>>> What is the payoff?
>> I can only agree. !VHE is something we're going to support for the 
>> foreseeable
>> future (which is roughly equivalent to "forever"), and modules have 
>> properties
>> that are fundamentally incompatible with the way KVM works with 
>> !VHE.
>
> Yes, with this patchset we still support !VHE system with built-in 
> KVM. While for VHE system we could support kernel module and check at 
> module init to avoid wrong usage of kvm module on !VHE systems.

How do you reconcile this with the need to have a single kernel image 
that
is full-featured on all architecture revisions? In your view of the 
world,
it is OK to have a VHE-specific kernel that won't have KVM on a v8.0 
system.
 From my point of view, this simply isn't acceptable.

>> If the only purpose of this work is to be able to swap KVM 
>> implementations
>> in a development environment, then it really isn't worth the effort.
>
> Making KVM as a kernel module has many advantages both for 
> development and real use environment. For example, we can backport and 
> update KVM codes independently and don't need to recompile kernel. Also 
> making KVM as a kernel module is a basic for kvm hot upgrade feature 
> without shutdown VMs and hosts. This is very important for Cloud 
> Service Provider to provides non-stop services for its customers.

The goal is certainly commendable.

But pretending that KVM is fully independent from the rest of the 
kernel is
an intellectual fallacy. Most of the issues that affect KVM at any 
given time
are actually core kernel issues that cannot be solved by just updating 
the
KVM module. You need to update the whole thing, not just the tiny bit 
that
switches between host and guests.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
