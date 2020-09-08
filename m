Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C03C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 12:41:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EBC82220D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 12:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ka0gEu9g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EBC82220D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4A04B43C;
	Tue,  8 Sep 2020 08:41:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wFYViXRlp0AI; Tue,  8 Sep 2020 08:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C614B4E8;
	Tue,  8 Sep 2020 08:41:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B57E14B307
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 08:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jSFCerqnG9Ws for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 08:41:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 826304B2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 08:41:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9A4A42220E;
 Tue,  8 Sep 2020 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599568889;
 bh=6jInsqpug0Y3OElx1xnCMGY0Czk38wlXeWMfORjZC7s=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ka0gEu9gC2nY+tFnZPLGiOxTFu1bWrvc5ey032h+z6ojb7n9ZpfY8JiBR2vdaTeJI
 kdLLY0BRjazRkhAoLJVN+UsmyCdDcl/K8OZXAdMZWloZsbGBOw8Jzgtavs/iVkGVAD
 6G8ROR+499sqzA4P68avokSvhlyepm2aDTNddSqQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kFcwB-00A3Vp-PL; Tue, 08 Sep 2020 13:41:27 +0100
MIME-Version: 1.0
Date: Tue, 08 Sep 2020 13:41:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Try PMD block mappings if PUD mappings
 are not supported
In-Reply-To: <4002ad2c-59a2-00a6-2bb5-797cf62763c9@arm.com>
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-3-alexandru.elisei@arm.com>
 <87sgbx7ti5.wl-maz@kernel.org>
 <4002ad2c-59a2-00a6-2bb5-797cf62763c9@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <1997ea2bb47f81dcc689489dba596e2d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-09-08 13:23, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 9/4/20 10:58 AM, Marc Zyngier wrote:
>> Hi Alex,
>> 
>> On Tue, 01 Sep 2020 14:33:57 +0100,
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>> When userspace uses hugetlbfs for the VM memory, user_mem_abort() 
>>> tries to
>>> use the same block size to map the faulting IPA in stage 2. If stage 
>>> 2
>>> cannot use the same size mapping because the block size doesn't fit 
>>> in the
>>> memslot or the memslot is not properly aligned, user_mem_abort() will 
>>> fall
>>> back to a page mapping, regardless of the block size. We can do 
>>> better for
>>> PUD backed hugetlbfs by checking if a PMD block mapping is possible 
>>> before
>>> deciding to use a page.
>>> 
>>> vma_pagesize is an unsigned long, use 1UL instead of 1ULL when 
>>> assigning
>>> its value.
>>> 
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  arch/arm64/kvm/mmu.c | 19 ++++++++++++++-----
>>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 25e7dc52c086..f590f7355cda 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1871,15 +1871,24 @@ static int user_mem_abort(struct kvm_vcpu 
>>> *vcpu, phys_addr_t fault_ipa,
>>>  	else
>>>  		vma_shift = PAGE_SHIFT;
>>> 
>>> -	vma_pagesize = 1ULL << vma_shift;
>>>  	if (logging_active ||
>>> -	    (vma->vm_flags & VM_PFNMAP) ||
>>> -	    !fault_supports_stage2_huge_mapping(memslot, hva, 
>>> vma_pagesize)) {
>>> +	    (vma->vm_flags & VM_PFNMAP)) {
>>>  		force_pte = true;
>>> -		vma_pagesize = PAGE_SIZE;
>>>  		vma_shift = PAGE_SHIFT;
>>>  	}
>>> 
>>> +	if (vma_shift == PUD_SHIFT &&
>>> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
>>> +		vma_shift = PMD_SHIFT;
>>> +
>>> +	if (vma_shift == PMD_SHIFT &&
>>> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>>> +		force_pte = true;
>>> +		vma_shift = PAGE_SHIFT;
>>> +	}
>>> +
>>> +	vma_pagesize = 1UL << vma_shift;
>>> +
>>>  	/*
>>>  	 * The stage2 has a minimum of 2 level table (For arm64 see
>>>  	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
>>> @@ -1889,7 +1898,7 @@ static int user_mem_abort(struct kvm_vcpu 
>>> *vcpu, phys_addr_t fault_ipa,
>>>  	 */
>>>  	if (vma_pagesize == PMD_SIZE ||
>>>  	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>>> -		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>>> +		gfn = (fault_ipa & ~(vma_pagesize - 1)) >> PAGE_SHIFT;
>>>  	mmap_read_unlock(current->mm);
>>> 
>>>  	/* We need minimum second+third level pages */
>> Although this looks like a sensible change, I'm a reluctant to take it
>> at this stage, given that we already have a bunch of patches from Will
>> to change the way we deal with PTs.
>> 
>> Could you look into how this could fit into the new code instead?
> 
> Sure, that sounds very sensible. I'm in the process of reviewing Will's 
> series,
> and after I'm done I'll rebase this on top of his patches and send it
> as v2. Does
> that sound ok to you? Or do you want me to base this patch on one of
> your branches?

Either way is fine (kvmarm/next has his patches). Just let me know
what this is based on when you  post the patches.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
