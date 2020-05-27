Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE56BC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 08:59:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 586012078B
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 08:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tvrGcnXk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 586012078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E72AC4B1C3;
	Wed, 27 May 2020 04:59:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JWcM-2yrE6r4; Wed, 27 May 2020 04:59:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9CA24B1FF;
	Wed, 27 May 2020 04:59:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E612C4B1E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 04:59:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qd2Vjn+9QI-z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 04:59:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B50FD4B1C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 04:59:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9A4A920723;
 Wed, 27 May 2020 08:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590569989;
 bh=rPHAc5eimetXVqweeSipTURrEuy4V6ve5PkutgmKEtA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tvrGcnXkSNJG9A+/gWnqyD9xa0wya4IQJK0PY/BHByHP6dRgqxXsEdBNg2uTPoBQo
 JY/4zMhBU/iygu/eMKo4uXCxEP6Az72mtKngAC968FsAm2meKbE6qBtYtiFyZ/DzLK
 5mqMTqrzs/Knxjpm6gR83sMhQZAcAg/K8J2q4/No=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdrue-00FeLV-31; Wed, 27 May 2020 09:59:48 +0100
MIME-Version: 1.0
Date: Wed, 27 May 2020 09:59:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
In-Reply-To: <20200513090648.GA193035@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
 <20200507151321.GH237572@google.com>
 <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
 <20200513090648.GA193035@google.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <7a2a533088ecc77f2c5a473e2c1c3004@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, james.morse@arm.com, kvm@vger.kernel.org,
 andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, gcherian@marvell.com,
 prime.zeng@hisilicon.com, catalin.marinas@arm.com, will@kernel.org,
 Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-05-13 10:06, Andrew Scull wrote:
> On Tue, May 12, 2020 at 01:04:31PM +0100, James Morse wrote:
>> Hi Andrew,
>> 
>> On 07/05/2020 16:13, Andrew Scull wrote:
>> >> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
>> >>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
>> >>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
>> >>  	stage2_pud_clear(kvm, pud);
>> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>> >>  	stage2_pmd_free(kvm, pmd_table);
>> >>  	put_page(virt_to_page(pud));
>> >>  }
>> >> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
>> >>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
>> >>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>> >>  	pmd_clear(pmd);
>> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>> >>  	free_page((unsigned long)pte_table);
>> >>  	put_page(virt_to_page(pmd));
>> >>  }
>> >
>> > Going by the names, is it possible to give a better level hint for these
>> > cases?
>> 
>> There is no leaf entry being invalidated here. After clearing the 
>> range, we found we'd
>> emptied (and invalidated) a whole page of mappings:
>> |	if (stage2_pmd_table_empty(kvm, start_pmd))
>> |		clear_stage2_pud_entry(mmu, pud, start_addr);
>> 
>> Now we want to remove the link to the empty page so we can free it. We 
>> are changing the
>> structure of the tables, not what gets mapped.
>> 
>> I think this is why we need the un-hinted behaviour, to invalidate 
>> "any level of the
>> translation table walk required to translate the specified IPA". 
>> Otherwise the hardware
>> can look for a leaf at the indicated level, find none, and do nothing.
>> 
>> 
>> This is sufficiently horrible, its possible I've got it completely 
>> wrong! (does it make
>> sense?)
> 
> Ok. `addr` is an IPA, that IPA is now omitted from the map so doesn't
> appear in any entry of the table, least of all a leaf entry. That makes
> sense.
> 
> Is there a convention to distinguish IPA and PA similar to the
> distinction for VA or does kvmarm just use phys_addr_t all round?
> 
> It seems like the TTL patches are failry self contained if it would be
> easier to serparate them out from these larger series?

They are. This whole series is a mix of unrelated patches anyway.
Their only goal is to make my life a bit easier in the distant
future.

I'll repost that anyway, as I have made some cosmetic changes.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
