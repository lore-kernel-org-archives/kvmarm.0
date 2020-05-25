Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631FAC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 12:39:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC89420849
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 12:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC89420849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 197D84B1E6;
	Mon, 25 May 2020 08:39:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VWaZVZs+uoOh; Mon, 25 May 2020 08:39:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E054F4B1C4;
	Mon, 25 May 2020 08:39:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A604B1BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 08:39:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mh2KsB9Ddwe1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 08:39:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC424B1B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 08:39:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B57DF31B;
 Mon, 25 May 2020 05:39:47 -0700 (PDT)
Received: from [10.163.77.62] (unknown [10.163.77.62])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B1F43F52E;
 Mon, 25 May 2020 05:39:45 -0700 (PDT)
Subject: Re: [PATCH V4 00/17] arm64/cpufeature: Introduce ID_PFR2, ID_DFR1,
 ID_MMFR5 and other changes
To: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <1589881254-10082-1-git-send-email-anshuman.khandual@arm.com>
 <159007243559.201193.1705879548179051424.b4-ty@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <15a06377-4f65-3154-3a5f-bd393e22614f@arm.com>
Date: Mon, 25 May 2020 18:09:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <159007243559.201193.1705879548179051424.b4-ty@kernel.org>
Content-Language: en-US
Cc: catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, maz@kernel.org
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



On 05/21/2020 08:49 PM, Will Deacon wrote:
> On Tue, 19 May 2020 15:10:37 +0530, Anshuman Khandual wrote:
>> This series is primarily motivated from an adhoc list from Mark Rutland
>> during our previous ID_ISAR6 discussion [1]. The current proposal also
>> accommodates some more suggestions from Will and Suzuki.
>>
>> This series adds missing 32 bit system registers (ID_PFR2, ID_DFR1 and
>> ID_MMFR5), adds missing features bits on all existing system registers
>> (32 and 64 bit) and some other miscellaneous changes. While here it also
>> includes a patch which does macro replacement for various open bits shift
>> encodings for various CPU ID registers. There is a slight re-order of the
>> patches here as compared to the previous version (V1).
>>
>> [...]
> 
> Applied to arm64 (for-next/cpufeature), thanks!
> 
> [01/17] arm64/cpufeature: Add explicit ftr_id_isar0[] for ID_ISAR0 register
>         https://git.kernel.org/arm64/c/2a5bc6c47bc3
> [02/17] arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register
>         https://git.kernel.org/arm64/c/1ed1b90a0594
> [03/17] arm64/cpufeature: Make doublelock a signed feature in ID_AA64DFR0
>         https://git.kernel.org/arm64/c/e965bcb06256
> [04/17] arm64/cpufeature: Introduce ID_PFR2 CPU register
>         https://git.kernel.org/arm64/c/16824085a7dd
> [05/17] arm64/cpufeature: Introduce ID_DFR1 CPU register
>         https://git.kernel.org/arm64/c/dd35ec070457
> [06/17] arm64/cpufeature: Introduce ID_MMFR5 CPU register
>         https://git.kernel.org/arm64/c/152accf8476f
> [07/17] arm64/cpufeature: Add remaining feature bits in ID_PFR0 register
>         https://git.kernel.org/arm64/c/0ae43a99fe91
> [08/17] arm64/cpufeature: Add remaining feature bits in ID_MMFR4 register
>         https://git.kernel.org/arm64/c/fcd6535322cc
> [09/17] arm64/cpufeature: Add remaining feature bits in ID_AA64ISAR0 register
>         https://git.kernel.org/arm64/c/7cd51a5a84d1
> [10/17] arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register
>         https://git.kernel.org/arm64/c/011e5f5bf529
> [11/17] arm64/cpufeature: Add remaining feature bits in ID_AA64PFR1 register
>         https://git.kernel.org/arm64/c/14e270fa5c4c
> [12/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR0 register
>         (no commit info)
> [13/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR1 register
>         (no commit info)
> [14/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR2 register
>         (no commit info)
> [15/17] arm64/cpufeature: Add remaining feature bits in ID_AA64DFR0 register
>         (no commit info)
> [16/17] arm64/cpufeature: Replace all open bits shift encodings with macros
>         (no commit info)
> [17/17] arm64/cpuinfo: Add ID_MMFR4_EL1 into the cpuinfo_arm64 context
>         https://git.kernel.org/arm64/c/858b8a8039d0
> 
> Note that Suzuki had comments on 12-16, so assume you'll respin those (I fixed
> up the trivial comments on earlier patches myself).
[PATCH 15/17] might need some more investigation and rework. Hence planning to
defer that for later and respin the remaining patches (12, 13, 14, 16) for now.

- Anshuman
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
