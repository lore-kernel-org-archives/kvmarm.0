Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C101AC64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:13:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 233FA221EB
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:13:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 233FA221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E53B4B397;
	Wed,  2 Dec 2020 09:13:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IrKF5qj-yDYM; Wed,  2 Dec 2020 09:13:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE394B394;
	Wed,  2 Dec 2020 09:13:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC21D4B342
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:13:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RUxeR-qEqjO6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 09:13:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BDD34B323
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:13:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0523D30E;
 Wed,  2 Dec 2020 06:13:46 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 455963F718;
 Wed,  2 Dec 2020 06:13:45 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 03/10] arm/arm64: gic: Remove memory
 synchronization from ipi_clear_active_handler()
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-4-alexandru.elisei@arm.com>
 <038402be-a119-c162-04f2-d32db26e8a96@redhat.com>
 <df9e2243-008b-3f93-e499-98b887b6c848@arm.com>
Message-ID: <7c18deb2-cdfc-0c74-f9d6-d08ace616060@arm.com>
Date: Wed, 2 Dec 2020 14:14:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <df9e2243-008b-3f93-e499-98b887b6c848@arm.com>
Content-Language: en-US
Cc: andre.przywara@arm.com
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

Hi,

On 12/2/20 2:02 PM, Alexandru Elisei wrote:

> Hi Eric,
>
> On 12/1/20 4:37 PM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>>> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
>>> checks that the interrupt has been received as expected. There is no need
>>> to use inter-processor memory synchronization primitives on code that runs
>>> on the same CPU, so remove the unneeded memory barriers.
>>>
>>> The arrays are modified asynchronously (in the interrupt handler) and it is
>>> possible for the compiler to infer that they won't be changed during normal
>>> program flow and try to perform harmful optimizations (like stashing a
>>> previous read in a register and reusing it). To prevent this, for GICv2,
>>> the smp_wmb() in gicv2_ipi_send_self() is replaced with a compiler barrier.
>>> For GICv3, the wmb() barrier in gic_ipi_send_single() already implies a
>>> compiler barrier.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  arm/gic.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arm/gic.c b/arm/gic.c
>>> index 401ffafe4299..4e947e8516a2 100644
>>> --- a/arm/gic.c
>>> +++ b/arm/gic.c
>>> @@ -12,6 +12,7 @@
>>>   * This work is licensed under the terms of the GNU LGPL, version 2.
>>>   */
>>>  #include <libcflat.h>
>>> +#include <linux/compiler.h>
>>>  #include <errata.h>
>>>  #include <asm/setup.h>
>>>  #include <asm/processor.h>
>>> @@ -260,7 +261,8 @@ static void check_lpi_hits(int *expected, const char *msg)
>>>  
>>>  static void gicv2_ipi_send_self(void)
>>>  {> -	smp_wmb();
>> nit: previous patch added it and this patch removes it. maybe squash the
>> modifs into the previous patch saying only a barrier() is needed for self()?
> You're right, this does look out of place. I'll merge this change into the
> previous patch.
>>> +	/* Prevent the compiler from optimizing memory accesses */
>>> +	barrier();
>>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>>>  }
>>>  
>>> @@ -359,6 +361,7 @@ static struct gic gicv3 = {
>>>  	},
>>>  };
>>>  
>>> +/* Runs on the same CPU as the sender, no need for memory synchronization */
>>>  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>>  {
>>>  	u32 irqstat = gic_read_iar();
>>> @@ -375,13 +378,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>>  
>>>  		writel(val, base + GICD_ICACTIVER);
>>>  
>>> -		smp_rmb(); /* pairs with wmb in stats_reset */
>> the comment says it is paired with wmd in stats_reset. So is it OK to
>> leave the associated wmb?
> This patch removes multi-processor synchronization from the functions that run on
> the same CPU. stats_reset() can be called from one CPU (the IPI_SENDER CPU) and
> the variables it modifies accessed by the interrupt handlers running on different
> CPUs, like it happens for the IPI tests. In that case we do need the proper
> barriers in place.

Sorry, got confused about what you were asking. The next patch removes the
smp_wmb() from stats_reset() which became redundant after the barriers added to
the GIC functions that send IPIs. This patch is about removing barriers that were
never needed in the first place because the functions were running on the same
CPU, it's not dependent on anyGIC changes.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
