Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81752C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:31:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8ECF6056C
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:31:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E8ECF6056C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A86407E7;
	Wed, 11 Aug 2021 01:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QfjwdxoQmsSx; Wed, 11 Aug 2021 01:31:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E76C449DE3;
	Wed, 11 Aug 2021 01:31:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCAC407E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YE1yohXRyFoo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 01:31:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298E840016
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:31:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1BE71FB;
 Tue, 10 Aug 2021 22:31:15 -0700 (PDT)
Received: from [10.163.67.241] (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41B5F3F40C;
 Tue, 10 Aug 2021 22:31:13 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as
 page size
To: Will Deacon <will@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
 <20210810132015.GA2946@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <7ac63cc6-d35a-d455-f629-abea2932d312@arm.com>
Date: Wed, 11 Aug 2021 11:02:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210810132015.GA2946@willie-the-truck>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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



On 8/10/21 6:50 PM, Will Deacon wrote:
> On Tue, Aug 10, 2021 at 12:32:37PM +0530, Anshuman Khandual wrote:
>> All instances here could just directly test against CONFIG_ARM64_XXK_PAGES
>> instead of evaluating via PAGE_SHIFT or PAGE_SIZE. With this change, there
>> will be no such usage left.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/pgtable.c | 6 +++---
>>  arch/arm64/mm/mmu.c          | 2 +-
>>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> Why is this better?

There are two improvements here.

1. Avoids using hard coded numerical shift values to determine the page size

	e.g PAGE_SHIFT = 16 for 64K

2. There are already instances of IS_ENABLED() construct checking for the page
   size. After this change there will be just a single method to test page size
   , rather than checking for either config, PAGE_SHIFT or PAGE_SIZE etc through
   out arm64. This change helps in that unification around IS_ENABLED().

There is another patch which drops remaining usage for PAGE_SIZE as well.

https://patchwork.kernel.org/project/linux-arm-kernel/patch/1628569782-30213-1-git-send-email-anshuman.khandual@arm.com/ 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
