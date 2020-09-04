Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7D2C43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:02:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97F49206D4
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zd3dMbNI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97F49206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2734B32F;
	Fri,  4 Sep 2020 06:02:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id in6LTnzrHOtd; Fri,  4 Sep 2020 06:02:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 298164B335;
	Fri,  4 Sep 2020 06:02:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E4D24B337
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wF90neRl2akT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 06:02:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75EC34B32F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:02:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4A8E3206D4;
 Fri,  4 Sep 2020 10:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599213762;
 bh=qlCqTB3DmML4H9RpKM9UtFjoUSVv80a7NHXXOmkdv04=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Zd3dMbNIP9jiHcHjpN8bH4rB5z7i63Up40w4Fqpy7AFNJfZRtSk5LeU0VsAu9b4Bh
 SBWa02xVSreu0W6jhMARTKrhZglo/PPRDG6JqdKLOrqVTOm9jLDRF5bxFb/Cr/aK14
 Owi1vhEXxkoMrRA2DS7bKg3w+3h3SaBazjVRvHeY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kE8YK-0097zt-Pi; Fri, 04 Sep 2020 11:02:40 +0100
MIME-Version: 1.0
Date: Fri, 04 Sep 2020 11:02:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 20/21] KVM: arm64: Remove unused 'pgd' field from
 'struct kvm_s2_mmu'
In-Reply-To: <7911796d-9124-cb7c-ace5-51e3b6d2dc28@redhat.com>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-21-will@kernel.org>
 <f0a64bb2-5371-9f44-1c64-035cbc6dcf5b@redhat.com>
 <20200903165020.GC7791@willie-the-truck>
 <7911796d-9124-cb7c-ace5-51e3b6d2dc28@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <66b19fd347823e7111aafdb8d8251c14@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-09-04 01:59, Gavin Shan wrote:
> Hi Will,
> 
> On 9/4/20 2:50 AM, Will Deacon wrote:
>> On Thu, Sep 03, 2020 at 03:07:17PM +1000, Gavin Shan wrote:
>>> On 8/25/20 7:39 PM, Will Deacon wrote:
>>>> The stage-2 page-tables are entirely encapsulated by the 'pgt' field 
>>>> of
>>>> 'struct kvm_s2_mmu', so remove the unused 'pgd' field.
>>>> 
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Quentin Perret <qperret@google.com>
>>>> Signed-off-by: Will Deacon <will@kernel.org>
>>>> ---
>>>>    arch/arm64/include/asm/kvm_host.h | 1 -
>>>>    arch/arm64/kvm/mmu.c              | 2 --
>>>>    2 files changed, 3 deletions(-)
>>>> 
>>> 
>>> I think this might be folded into PATCH[18] as both patches are
>>> simple enough. I'm not sure the changes introduced in PATCH[19]
>>> prevent us doing this.
>>> 
>>> There is another question below.
>>> 
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> 
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>>>> b/arch/arm64/include/asm/kvm_host.h
>>>> index 0b7c702b2151..41caf29bd93c 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -79,7 +79,6 @@ struct kvm_s2_mmu {
>>>>    	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
>>>>    	 * canonical stage-2 page tables.
>>>>    	 */
>>>> -	pgd_t		*pgd;
>>>>    	phys_addr_t	pgd_phys;
>>>>    	struct kvm_pgtable *pgt;
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index ddeec0b03666..f28e03dcb897 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -384,7 +384,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct 
>>>> kvm_s2_mmu *mmu)
>>>>    	mmu->kvm = kvm;
>>>>    	mmu->pgt = pgt;
>>>>    	mmu->pgd_phys = __pa(pgt->pgd);
>>>> -	mmu->pgd = (void *)pgt->pgd;
>>>>    	mmu->vmid.vmid_gen = 0;
>>>>    	return 0;
>>>> @@ -470,7 +469,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>>    	spin_lock(&kvm->mmu_lock);
>>>>    	pgt = mmu->pgt;
>>>>    	if (pgt) {
>>>> -		mmu->pgd = NULL;
>>>>    		mmu->pgd_phys = 0;
>>>>    		mmu->pgt = NULL;
>>>>    		free_percpu(mmu->last_vcpu_ran);
>>>> 
>>> 
>>> I guess mmu->pgd_phys might be removed either because kvm_get_vttbr()
>>> is the only consumer.
>> 
>> Hmm, but kvm_get_vttbr() is still used after these patches, so I think
>> the pgd_phys field needs to stick around.
>> 
> 
> Yes, kvm_get_vttbr() is the only consumer. The corresponding physical
> address can be figured out in the function, we needn't have the 
> physical
> address and cache it in advance. However, it's not a big deal. I 
> probably
> post one patch to remove it after this series gets merged.
> 
>    baddr = __pa(mmu->pgt->pgd);

I'd rather you didn't. The NV patches need it for the AT emulation code,
so it might as well stay in place.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
