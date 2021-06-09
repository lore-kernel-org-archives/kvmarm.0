Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAA4C48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:51:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B84461287
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:51:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B84461287
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FAEE407A0;
	Wed,  9 Jun 2021 06:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V+3wp2Qr4vWl; Wed,  9 Jun 2021 06:51:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E06F4048B;
	Wed,  9 Jun 2021 06:51:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E31C4029C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 06:51:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fftyiI2BnDGD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 06:51:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D41254024F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 06:51:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04FCC11B3;
 Wed,  9 Jun 2021 03:51:38 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5727F3F694;
 Wed,  9 Jun 2021 03:51:35 -0700 (PDT)
Subject: Re: [PATCH v14 1/8] arm64: mte: Handle race when synchronising tags
To: Marc Zyngier <maz@kernel.org>
References: <20210607110816.25762-1-steven.price@arm.com>
 <20210607110816.25762-2-steven.price@arm.com> <875yynz5wp.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <e65943cb-9643-c973-9626-ebf56723ea14@arm.com>
Date: Wed, 9 Jun 2021 11:51:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <875yynz5wp.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 09/06/2021 11:30, Marc Zyngier wrote:
> On Mon, 07 Jun 2021 12:08:09 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> mte_sync_tags() used test_and_set_bit() to set the PG_mte_tagged flag
>> before restoring/zeroing the MTE tags. However if another thread were to
>> race and attempt to sync the tags on the same page before the first
>> thread had completed restoring/zeroing then it would see the flag is
>> already set and continue without waiting. This would potentially expose
>> the previous contents of the tags to user space, and cause any updates
>> that user space makes before the restoring/zeroing has completed to
>> potentially be lost.
>>
>> Since this code is run from atomic contexts we can't just lock the page
>> during the process. Instead implement a new (global) spinlock to protect
>> the mte_sync_page_tags() function.
>>
>> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/kernel/mte.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index 125a10e413e9..a3583a7fd400 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -25,6 +25,7 @@
>>  u64 gcr_kernel_excl __ro_after_init;
>>  
>>  static bool report_fault_once = true;
>> +static DEFINE_SPINLOCK(tag_sync_lock);
>>  
>>  #ifdef CONFIG_KASAN_HW_TAGS
>>  /* Whether the MTE asynchronous mode is enabled. */
>> @@ -34,13 +35,22 @@ EXPORT_SYMBOL_GPL(mte_async_mode);
>>  
>>  static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
>>  {
>> +	unsigned long flags;
>>  	pte_t old_pte = READ_ONCE(*ptep);
>>  
>> +	spin_lock_irqsave(&tag_sync_lock, flags);
> 
> having though a bit more about this after an offline discussion with
> Catalin: why can't this lock be made per mm? We can't really share
> tags across processes anyway, so this is limited to threads from the
> same process.

Currently there's nothing stopping processes sharing tags (mmap(...,
PROT_MTE, MAP_SHARED)) - I agree making use of this is tricky and it
would have been nice if this had just been prevented from the beginning.

Given the above, clearly the lock can't be per mm and robust.

> I'd also like it to be documented that page sharing can only reliably
> work with tagging if only one of the mappings is using tags.

I'm not entirely clear whether you mean "can only reliably work" to be
"is practically impossible to coordinate tag values", or whether you are
proposing to (purposefully) introduce the race with a per-mm lock? (and
document it).

I guess we could have a per-mm lock and handle the race if user space
screws up with the outcome being lost tags (double clear).

But it feels to me like it could come back to bite in the future since
VM_SHARED|VM_MTE will almost always work and I fear someone will start
using it since it's permitted by the kernel.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
