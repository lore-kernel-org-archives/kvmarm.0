Return-Path: <SRS0=JFMI=2B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F7C00454
	for <kvmarm@archiver.kernel.org>; Wed, 11 Dec 2019 18:02:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 647AE20409
	for <kvmarm@archiver.kernel.org>; Wed, 11 Dec 2019 18:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 647AE20409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E016B4AEBB;
	Wed, 11 Dec 2019 13:02:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6sExWbnZfYTH; Wed, 11 Dec 2019 13:02:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BECA64AEB8;
	Wed, 11 Dec 2019 13:02:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5099C4AEB8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Dec 2019 13:02:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvb07sJWOFVp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Dec 2019 13:02:00 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25B414ACE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Dec 2019 13:02:00 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1if6JA-0000Td-Ug; Wed, 11 Dec 2019 19:01:56 +0100
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device
 mappings
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 11 Dec 2019 18:01:56 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <a8dbd580-ed09-8d46-6ec5-a54bac3a6695@arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
 <a8dbd580-ed09-8d46-6ec5-a54bac3a6695@arm.com>
Message-ID: <4b504f8d380e3587fab197921ab0c7e8@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Alex,

On 2019-12-11 17:53, Alexandru Elisei wrote:
> Hi,
>
> On 12/11/19 4:56 PM, Marc Zyngier wrote:
>> A device mapping is normally always mapped at Stage-2, since there
>> is very little gain in having it faulted in.
>>
>> Nonetheless, it is possible to end-up in a situation where the 
>> device
>> mapping has been removed from Stage-2 (userspace munmaped the VFIO
>> region, and the MMU notifier did its job), but present in a 
>> userspace
>> mapping (userpace has mapped it back at the same address). In such
>> a situation, the device mapping will be demand-paged as the guest
>> performs memory accesses.
>>
>> This requires to be careful when dealing with mapping size, cache
>> management, and to handle potential execution of a device mapping.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  virt/kvm/arm/mmu.c | 21 +++++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)

[...]

> I've tested this patch using the scenario that you described in the 
> commit
> message. I've also tested it with the following scenarios:
>
> - The region is mmap'ed as backed by a VFIO device fd and the memslot
> is created,
> it is munmap'ed, then mmap'ed as anonymous.
> - The region is mmap'ed as anonymous and the memslot is created, it
> is munmap'ed,
> then mmap'ed as backed by a VFIO device fd.
>
> Everything worked as expected, so:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks for that!

> Just a nitpick, but stage2_set_pte has a local variable iomap which 
> can be
> replaced with a call to is_iomap.

Yeah, I noticed. I'm just trying to keep the patch relatively small so
that it can be easily backported. The cleanup can come later! ;-)

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
