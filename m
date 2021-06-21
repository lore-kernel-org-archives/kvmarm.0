Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CC0C49EA2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 08:27:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69F74611CC
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 08:27:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69F74611CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC948406E0;
	Mon, 21 Jun 2021 04:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L0Q2ffNDAJ8F; Mon, 21 Jun 2021 04:27:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D6540573;
	Mon, 21 Jun 2021 04:27:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06CEF40617
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 04:27:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iafyVK1VaaJV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 04:27:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C020F401A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 04:27:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 644EDD6E;
 Mon, 21 Jun 2021 01:27:51 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B66793F718;
 Mon, 21 Jun 2021 01:27:48 -0700 (PDT)
Subject: Re: [PATCH v16 1/7] arm64: mte: Handle race when synchronising tags
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20210618132826.54670-1-steven.price@arm.com>
 <20210618132826.54670-2-steven.price@arm.com>
 <20210618144013.GE16116@arm.com>
 <3551d8ea9c9464e982d75acdd5f855b4@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <2437e23c-2871-765e-2637-7a6823d80a52@arm.com>
Date: Mon, 21 Jun 2021 09:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3551d8ea9c9464e982d75acdd5f855b4@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 18/06/2021 16:42, Marc Zyngier wrote:
> On 2021-06-18 15:40, Catalin Marinas wrote:
>> On Fri, Jun 18, 2021 at 02:28:20PM +0100, Steven Price wrote:
>>> mte_sync_tags() used test_and_set_bit() to set the PG_mte_tagged flag
>>> before restoring/zeroing the MTE tags. However if another thread were to
>>> race and attempt to sync the tags on the same page before the first
>>> thread had completed restoring/zeroing then it would see the flag is
>>> already set and continue without waiting. This would potentially expose
>>> the previous contents of the tags to user space, and cause any updates
>>> that user space makes before the restoring/zeroing has completed to
>>> potentially be lost.
>>>
>>> Since this code is run from atomic contexts we can't just lock the page
>>> during the process. Instead implement a new (global) spinlock to protect
>>> the mte_sync_page_tags() function.
>>>
>>> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is
>>> mapped in user-space with PROT_MTE")
>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> Although I reviewed this patch, I think we should drop it from this
>> series and restart the discussion with the Chromium guys on what/if they
>> need PROT_MTE with MAP_SHARED. It currently breaks if you have two
>> PROT_MTE mappings but if they are ok with only one of the mappings being
>> PROT_MTE, I'm happy to just document it.
>>
>> Not sure whether subsequent patches depend on it though.
> 
> I'd certainly like it to be independent of the KVM series, specially
> as this series is pretty explicit that this MTE lock is not required
> for KVM.

Sure, since KVM no longer uses the lock we don't have the dependency -
so I'll drop the first patch.

> This will require some rework of patch #2, I believe. And while we're
> at it, a rebase on 5.13-rc4 wouldn't hurt, as both patches #3 and #5
> conflict with it...

Yeah there will be minor conflicts in patch #2 - but nothing major. I'll
rebase as requested at the same time.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
