Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF57C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 09:16:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 501C164F1E
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 09:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 501C164F1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C28A44B3FF;
	Thu,  4 Mar 2021 04:16:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rCKdSC24IVPK; Thu,  4 Mar 2021 04:16:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1C54B405;
	Thu,  4 Mar 2021 04:16:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA784B3FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 04:16:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iHv0QCT1DiZg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 04:16:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 780F24B3FC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 04:16:30 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 94BE264EBB;
 Thu,  4 Mar 2021 09:16:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lHk5p-00HDh3-Hy; Thu, 04 Mar 2021 09:16:25 +0000
MIME-Version: 1.0
Date: Thu, 04 Mar 2021 09:16:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Justin He <Justin.He@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
In-Reply-To: <AM6PR08MB437695640C272E4F065A8B2DF7979@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210303024225.2591-1-justin.he@arm.com>
 <20210303112934.GA18452@willie-the-truck> <87mtvkys1y.wl-maz@kernel.org>
 <20210303211325.GA20055@willie-the-truck>
 <AM6PR08MB437695640C272E4F065A8B2DF7979@AM6PR08MB4376.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <5bd4fa0b0590e548288b8f6dc3659ea5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Justin.He@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, James.Morse@arm.com,
 julien.thierry.kdev@gmail.com, Suzuki.Poulose@arm.com, Catalin.Marinas@arm.com,
 gshan@redhat.com, wangyanan55@huawei.com, qperret@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-03-04 00:46, Justin He wrote:
> Hi Marc
> 
>> -----Original Message-----
>> From: Will Deacon <will@kernel.org>
>> Sent: Thursday, March 4, 2021 5:13 AM
>> To: Marc Zyngier <maz@kernel.org>
>> Cc: Justin He <Justin.He@arm.com>; kvmarm@lists.cs.columbia.edu; James
>> Morse <James.Morse@arm.com>; Julien Thierry 
>> <julien.thierry.kdev@gmail.com>;
>> Suzuki Poulose <Suzuki.Poulose@arm.com>; Catalin Marinas
>> <Catalin.Marinas@arm.com>; Gavin Shan <gshan@redhat.com>; Yanan Wang
>> <wangyanan55@huawei.com>; Quentin Perret <qperret@google.com>; 
>> linux-arm-
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu 
>> walking
>> 
>> On Wed, Mar 03, 2021 at 07:07:37PM +0000, Marc Zyngier wrote:
>> > From e0524b41a71e0f17d6dc8f197e421e677d584e72 Mon Sep 17 00:00:00 2001
>> > From: Jia He <justin.he@arm.com>
>> > Date: Wed, 3 Mar 2021 10:42:25 +0800
>> > Subject: [PATCH] KVM: arm64: Fix range alignment when walking page tables
>> >
>> > When walking the page tables at a given level, and if the start
>> > address for the range isn't aligned for that level, we propagate
>> > the misalignment on each iteration at that level.
>> >
>> > This results in the walker ignoring a number of entries (depending
>> > on the original misalignment) on each subsequent iteration.
>> >
>> > Properly aligning the address at the before the next iteration
>> 
>> "at the before the next" ???
>> 
>> > addresses the issue.
>> >
>> > Cc: stable@vger.kernel.org
>> > Reported-by: Howard Zhang <Howard.Zhang@arm.com>
>> > Signed-off-by: Jia He <justin.he@arm.com>
>> > Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker
>> infrastructure")
>> > [maz: rewrite commit message]
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > Link: https://lore.kernel.org/r/20210303024225.2591-1-justin.he@arm.com
>> > ---
>> >  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> > index 4d177ce1d536..124cd2f93020 100644
>> > --- a/arch/arm64/kvm/hyp/pgtable.c
>> > +++ b/arch/arm64/kvm/hyp/pgtable.c
>> > @@ -223,7 +223,7 @@ static inline int __kvm_pgtable_visit(struct
>> kvm_pgtable_walk_data *data,
>> >  		goto out;
>> >
>> >  	if (!table) {
>> > -		data->addr += kvm_granule_size(level);
>> > +		data->addr = ALIGN(data->addr, kvm_granule_size(level));
> 
> What if previous data->addr is already aligned with 
> kvm_granule_size(level)?
> Hence a deadloop? Am I missing anything else?

Indeed, well spotted. I'll revert to your original suggestion
if everybody agrees...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
