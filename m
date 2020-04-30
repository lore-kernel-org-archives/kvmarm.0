Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F64C83004
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 03:00:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71A572073E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 03:00:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71A572073E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2D8E4B4E5;
	Wed, 29 Apr 2020 23:00:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IhHHH+auJLr2; Wed, 29 Apr 2020 23:00:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B02364B4EA;
	Wed, 29 Apr 2020 23:00:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C85D14B4E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2020 23:00:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gRkfX7369pbF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2020 23:00:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 539494B4BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2020 23:00:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8F5B1063;
 Wed, 29 Apr 2020 20:00:15 -0700 (PDT)
Received: from [10.163.71.104] (unknown [10.163.71.104])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56ACE3F68F;
 Wed, 29 Apr 2020 20:00:13 -0700 (PDT)
Subject: Re: [PATCH V2 00/16] arm64/cpufeature: Introduce ID_PFR2, ID_DFR1,
 ID_MMFR5 and other changes
To: Will Deacon <will@kernel.org>
References: <1586857710-17154-1-git-send-email-anshuman.khandual@arm.com>
 <6749304e-8a4d-f4b9-eb40-91f0dd13166e@arm.com>
 <20200429212614.GD8604@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <da15c0f0-f8ec-c2bc-bd5b-907a75119dc1@arm.com>
Date: Thu, 30 Apr 2020 08:29:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200429212614.GD8604@willie-the-truck>
Content-Language: en-US
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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



On 04/30/2020 02:56 AM, Will Deacon wrote:
> Hi Anshuman,
> 
> On Wed, Apr 29, 2020 at 03:07:15PM +0530, Anshuman Khandual wrote:
>> On 04/14/2020 03:18 PM, Anshuman Khandual wrote:
>>> This series is primarily motivated from an adhoc list from Mark Rutland
>>> during our previous ID_ISAR6 discussion [1]. The current proposal also
>>> accommodates some more suggestions from Will and Suzuki.
>>>
>>> This series adds missing 32 bit system registers (ID_PFR2, ID_DFR1 and
>>> ID_MMFR5), adds missing features bits on all existing system registers
>>> (32 and 64 bit) and some other miscellaneous changes. While here it also
>>> includes a patch which does macro replacement for various open bits shift
>>> encodings for various CPU ID registers. There is a slight re-order of the
>>> patches here as compared to the previous version (V1).
>>>
>>> This series is based on v5.7-rc1. All feature bits enabled here can be
>>> referred in ARM DDI 0487F.a specification. Though I have tried to select
>>> appropriate values for each new feature being added here, there might be
>>> some inconsistencies (or mistakes). In which case, please do let me know
>>> if anything needs to change. Thank you.
>>>
>>> [1] https://patchwork.kernel.org/patch/11287805/
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com> 
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: James Morse <james.morse@arm.com>
>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Cc: kvmarm@lists.cs.columbia.edu
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>>
>>> Changes in V2:
>>>
>>> - Added Suggested-by tag from Mark Rutland for all changes he had proposed
>>> - Added comment for SpecSEI feature on why it is HIGHER_SAFE per Suzuki
>>> - Added a patch which makes ID_AA64DFR0_DOUBLELOCK a signed feature per Suzuki
>>> - Added ID_DFR1 and ID_MMFR5 system register definitions per Will
>>> - Added remaining features bits for relevant 64 bit system registers per Will
>>> - Changed commit message on [PATCH 5/7] regarding TraceFilt feature per Suzuki
>>> - Changed ID_PFR2.CSV3 (FTR_STRICT -> FTR_NONSTRICT) as 64 bit registers per Will
>>> - Changed ID_PFR0.CSV2 (FTR_STRICT -> FTR_NONSTRICT) as 64 bit registers per Will 
>>> - Changed some commit messages
>>
>> Just a gentle ping. I am wondering if you had a chance to glance
>> through this updated series.
> 
> Please can you resend based on for-next/cpufeature?

Sure, will do.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
