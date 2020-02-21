Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E3CC35656
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 14:57:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7432524650
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 14:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7432524650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF9E4AEE4;
	Fri, 21 Feb 2020 09:57:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id txh6LvdUmTX5; Fri, 21 Feb 2020 09:57:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F864AF03;
	Fri, 21 Feb 2020 09:57:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D47C64AEE4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 09:57:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ml7-HkYX-eiP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 09:57:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F5F4AEDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 09:57:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43E641FB;
 Fri, 21 Feb 2020 06:57:51 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26EAA3F703;
 Fri, 21 Feb 2020 06:57:50 -0800 (PST)
Subject: Re: [PATCH 0/3] KVM: arm64: Ask the compiler to __always_inline
 functions used by KVM at HYP
To: Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20200220165839.256881-1-james.morse@arm.com>
 <cb56f509ea0a4a9e1809af76f319daa2@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <228ef9d9-1ded-05ee-22e5-0158a0e47d82@arm.com>
Date: Fri, 21 Feb 2020 14:57:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cb56f509ea0a4a9e1809af76f319daa2@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 21/02/2020 12:55, Marc Zyngier wrote:
> On 2020-02-20 16:58, James Morse wrote:
>> It turns out KVM relies on the inline hint being honoured by the compiler
>> in quite a few more places than expected. Something about the Shadow Call
>> Stack support[0] causes the compiler to avoid inline-ing and to place
>> these functions outside the __hyp_text. This ruins KVM's day.
>>
>> Add the simon-says __always_inline annotation to all the static
>> inlines that KVM calls from HYP code.
>>
>> This series based on v5.6-rc2.
> 
> Many thanks for going through all this.
> 
> I'm happy to take it if Catalin or Will ack the arm64 patches.
> It case we decide to go the other way around:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> One thing I'd like to look into though is a compile-time check that
> nothing in the hyp_text section has a reference to a non-hyp_text
> symbol.

Heh, that hypothetical tool would choke on things like arch/arm64/kvm/hyp/tlb.c:
| static void __hyp_text __tlb_switch_to_guest_vhe(...)
| {

[...]

|	local_irq_save(cxt->flags);

which calls trace_hardirqs_off() ... which is absolutely fine because this only happens on
VHE.

To do it purely with the section information, you'd need to separate all the VHE code...
(maybe as a debug option that only runs when VHE is turned off?)


> We already have checks around non-init symbols pointing to init symbols,
> and I was wondering if we could reuse this for fun and profit...

I think objtool is the tool-of-the-future that can do this. You need something that
believes everything behind has_vhe() is unreachable...


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
