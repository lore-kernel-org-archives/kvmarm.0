Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4ADC43461
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:49:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2476A206F0
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:49:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hACv0D8s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2476A206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE2C4B26C;
	Wed,  2 Sep 2020 06:49:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eHZaPLjJ-i3T; Wed,  2 Sep 2020 06:49:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DB0E4B273;
	Wed,  2 Sep 2020 06:49:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8155F4B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:49:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id emuFSeTsjJix for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 06:49:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86F2A4B249
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:49:47 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 502A3206F0;
 Wed,  2 Sep 2020 10:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599043786;
 bh=hqOEf2qbUyka1286fLRGcTR209PqnnwJFVWvIdjyW8k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hACv0D8s7mmgygZEOGEsT/nH8OZG7vWEOTo4LYe3KLyg8F3e0tq1fmPon0LMoEbAB
 Th4vJFQl6yB97K1T108QrBUvpvTSDTaw5Q7sd34S6OvYYxLuPHCliFI23AlUOzufgK
 0G7f7EpzXHDEJ3r7WQuBVL+5hgr1X/rCbpz9jRVc=
Date: Wed, 2 Sep 2020 11:49:42 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200902104941.GD5567@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
 <8afa26de-1839-7e5e-a324-351b241e0976@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8afa26de-1839-7e5e-a324-351b241e0976@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On Fri, Aug 28, 2020 at 04:51:02PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > [..]
> > +static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
> > +{
> > +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(__pa(childp));
> > +
> > +	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
> > +	pte |= KVM_PTE_VALID;
> > +
> > +	WARN_ON(kvm_pte_valid(old));
> > +	smp_store_release(ptep, pte);
> > +}
> > +
> > +static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
> > +				   u32 level)
> > +{
> > +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(pa);
> > +	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
> > +							   KVM_PTE_TYPE_BLOCK;
> > +
> > +	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
> > +	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
> > +	pte |= KVM_PTE_VALID;
> > +
> > +	/* Tolerate KVM recreating the exact same mapping. */
> > +	if (kvm_pte_valid(old))
> > +		return old == pte;
> > +
> > +	smp_store_release(ptep, pte);
> > +	return true;
> > +}
> 
> These two functions look inconsistent to me - we refuse to update a valid leaf
> entry with a new value, but we allow updating a valid table. Is there something
> that I'm not taking into account?

Well, the table code will WARN() so it's not like we do it quietly. I could
try to propagate the error, but I don't see what the gains us other than
complexity and code that likely won't get tested.

The leaf case is different, because some callers will handle the failure
and perform break-before-make; TLBI (e.g. because of an MMU notifier
changing the PTE).

Take a look at how stage2_map_walker_try_leaf() ends up being called from
kvm_set_spte_handler().

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
