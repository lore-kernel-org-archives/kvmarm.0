Return-Path: <SRS0=lOre=5X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99F8C2BA16
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 08:50:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E7C420719
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 08:50:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E7C420719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 882524B0F8;
	Tue,  7 Apr 2020 04:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNDP3rSCVo1u; Tue,  7 Apr 2020 04:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74E124B0F9;
	Tue,  7 Apr 2020 04:50:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EB384B0FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 04:50:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wc1kXoIZ1bdi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Apr 2020 04:50:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB4E4B0F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 04:50:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CAA430E;
 Tue,  7 Apr 2020 01:50:46 -0700 (PDT)
Received: from [10.163.1.2] (unknown [10.163.1.2])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D21EE3F73D;
 Tue,  7 Apr 2020 01:50:36 -0700 (PDT)
Subject: Re: [PATCH 0/6] Introduce ID_PFR2 and other CPU feature changes
To: Will Deacon <will@kernel.org>
References: <1580215149-21492-1-git-send-email-anshuman.khandual@arm.com>
 <20200406170911.GA7446@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <05f6eb1e-a82c-bd02-1871-e44ea00683d8@arm.com>
Date: Tue, 7 Apr 2020 14:20:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200406170911.GA7446@willie-the-truck>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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



On 04/06/2020 10:39 PM, Will Deacon wrote:
> On Tue, Jan 28, 2020 at 06:09:03PM +0530, Anshuman Khandual wrote:
>> This series is primarily motivated from an adhoc list from Mark Rutland
>> during our ID_ISAR6 discussion [1]. Besides, it also includes a patch
>> which does macro replacement for various open bits shift encodings in
>> various CPU ID registers. This series is based on linux-next 20200124.
>>
>> [1] https://patchwork.kernel.org/patch/11287805/
>>
>> Is there anything else apart from these changes which can be accommodated
>> in this series, please do let me know. Thank you.
> 
> The latest Arm ARM also talks about DFR1 and MMFR5. Please can you include

Sure, will do.

> those too? Might also be worth checking to see if anything is missing on
> the 64-bit side as well (I didn't look).

Yeah. Now there some missing ones, will add those as well.

> 
> Will
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
