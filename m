Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A2DC2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:11:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA91F20737
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA91F20737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940D14B254;
	Wed, 15 Apr 2020 09:11:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c+Ztk8hKPhKb; Wed, 15 Apr 2020 09:11:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 615FC4B226;
	Wed, 15 Apr 2020 09:11:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0284B229
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:11:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svYyrqC6QFMK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 09:11:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 172974B204
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:11:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CA731063;
 Wed, 15 Apr 2020 06:11:04 -0700 (PDT)
Received: from [10.37.12.1] (unknown [10.37.12.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21F3B3F6C4;
 Wed, 15 Apr 2020 06:11:01 -0700 (PDT)
Subject: Re: [PATCH 3/8] arm64: cpufeature: Add CPU capability for AArch32 EL1
 support
To: will@kernel.org
References: <20200414213114.2378-1-will@kernel.org>
 <20200414213114.2378-4-will@kernel.org>
 <a83a19eb-9051-0a43-0bac-353f67d93d79@arm.com>
 <20200415101444.GC12621@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <7978a5a9-463e-5e96-7ea9-d8472b7b051c@arm.com>
Date: Wed, 15 Apr 2020 14:15:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200415101444.GC12621@willie-the-truck>
Content-Language: en-US
Cc: saiprakash.ranjan@codeaurora.org, anshuman.khandual@arm.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, dianders@chromium.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 04/15/2020 11:14 AM, Will Deacon wrote:
> On Wed, Apr 15, 2020 at 11:13:54AM +0100, Suzuki K Poulose wrote:
>> On 04/14/2020 10:31 PM, Will Deacon wrote:
>>> Although we emit a "SANITY CHECK" warning and taint the kernel if we
>>> detect a CPU mismatch for AArch32 support at EL1, we still online the
>>> CPU with disastrous consequences for any running 32-bit VMs.
>>>
>>> Introduce a capability for AArch32 support at EL1 so that late onlining
>>> of incompatible CPUs is forbidden.
>>>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>
>> One of the other important missing sanity check for KVM is the VMID width
>> check. I will code something up.
> 
> Cheers! Do we handle things like the IPA size already?

Good point. No, we don't. I will include this too.

Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
