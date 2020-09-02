Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFDAC433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:10:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA4C9207D3
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9fLSkVE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA4C9207D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F51D4B294;
	Wed,  2 Sep 2020 07:10:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QmtprW5nlZxp; Wed,  2 Sep 2020 07:10:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0899B4B288;
	Wed,  2 Sep 2020 07:10:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 633B64B273
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:10:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VA5KsVNxkhYo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:10:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FB9A4B211
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:10:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 001E32072A;
 Wed,  2 Sep 2020 11:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599045042;
 bh=+mexwcK/m9cTF5bW21XF1zhgb/tKJu6piyh+tSeZCz8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=t9fLSkVEkelRwZB2tc7tNfyJbnCEdo3QgJ+Fe/SC33hxKAcxNrkmffooi0RqxGc8L
 PjX7g66A1N75bJr0LYHeeu6B5DoWf0CD0FfOu+C2eXk1ldH3jJD6JJ2DfXVAJARavy
 nmlcVtVyy6NWdSSFIqa+y7vKQnaCY3lYLezdk4Nk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDQf2-008Yog-Gm; Wed, 02 Sep 2020 12:10:40 +0100
MIME-Version: 1.0
Date: Wed, 02 Sep 2020 12:10:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
In-Reply-To: <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, gshan@redhat.com,
 kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com
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

On 2020-09-02 11:59, Alexandru Elisei wrote:
> Hi,
> 
> On 8/22/20 3:44 AM, Gavin Shan wrote:
>> Depending on the kernel configuration, PUD_SIZE could be equal to
>> PMD_SIZE. For example, both of them are 512MB with the following
>> kernel configuration. In this case, both PUD and PMD are folded
>> to PGD.
>> 
>>    CONFIG_ARM64_64K_PAGES   y
>>    CONFIG_ARM64_VA_BITS     42
>>    CONFIG_PGTABLE_LEVELS    2
>> 
>> With the above configuration, the stage2 PUD is used to backup the
>> 512MB huge page when the stage2 mapping is built. During the mapping,
>> the PUD and its subordinate levels of page table entries are unmapped
>> if the PUD is present and not huge page sensitive in 
>> stage2_set_pud_huge().
>> Unfornately, the @addr isn't aligned to S2_PUD_SIZE and wrong page 
>> table
>> entries are zapped. It eventually leads to PUD's present bit can't be
>> cleared successfully and infinite loop in stage2_set_pud_huge().
>> 
>> This fixes the issue by checking with S2_{PUD, PMD}_SIZE instead of
>> {PUD, PMD}_SIZE to determine if stage2 PUD or PMD is used to back the
>> huge page. For this particular case, the stage2 PMD entry should be
>> used to backup the 512MB huge page with stage2_set_pmd_huge().
> 
> I can reproduce this on my rockpro64 using kvmtool.
> 
> I see two issues here: first, PUD_SIZE = 512MB, but S2_PUD_SIZE = 4TB 
> (checked
> using printk), and second, stage2_set_pud_huge() hangs. I'm working on
> debugging them.

I have this as an immediate fix for the set_pud_huge hang, tested
on Seattle with 64k/42bits.

I can't wait to see the back of this code...

         M.

 From 2a345a826a47f9061bb37045a1d89ea54b51fb80 Mon Sep 17 00:00:00 2001
 From: Marc Zyngier <maz@kernel.org>
Date: Wed, 2 Sep 2020 11:18:29 +0100
Subject: [PATCH] KVM: arm64: Do not try to map PUDs when they are folded 
into
  PMD

For the obscure cases where PMD and PUD are the same size
(64kB pages with 42bit VA, for example, which results in only
two levels of page tables), we can't map anything as a PUD,
because there is... erm... no PUD to speak of. Everything is
either a PMD or a PTE.

So let's only try and map a PUD when its size is different from
that of a PMD.

Cc: stable@vger.kernel.org
Fixes: b8e0ba7c8bea ("KVM: arm64: Add support for creating PUD hugepages 
at stage 2")
Reported-by: Gavin Shan <gshan@redhat.com>
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
  arch/arm64/kvm/mmu.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ba00bcc0c884..c3a92fa537fd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1970,7 +1970,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
  		(fault_status == FSC_PERM &&
  		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));

-	if (vma_pagesize == PUD_SIZE) {
+	if (PUD_SIZE != PMD_SIZE && vma_pagesize == PUD_SIZE) {
  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);

  		new_pud = kvm_pud_mkhuge(new_pud);
-- 
2.28.0


-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
