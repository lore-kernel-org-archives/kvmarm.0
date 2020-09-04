Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70CAC43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:59:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A557206B7
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="by52AOjO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A557206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 926C44B1B5;
	Thu,  3 Sep 2020 20:59:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id loTCg64zIv8Y; Thu,  3 Sep 2020 20:59:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 625AA4B312;
	Thu,  3 Sep 2020 20:59:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5EB34B1B2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:59:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sCq0zR0oaSMq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 20:59:54 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C23D64B18D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:59:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599181194;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tvS6xJPLv1TBLxud+l3myHQoIPwg5S5xF1lgH6xv3II=;
 b=by52AOjOPlFlP12hhWOh7yuUKlE8r6uSw5zu90VOpU5XCX9jOEyM8gZxqlhTqoghE1AKYi
 IIhpiKQ8GzBKyxndSDYfKDjj9CYzPipGTKWvzx6Wyvr2YowXIbNLzlbblnQtCIdDqgQH11
 4I/J0H2DCJ7cDaI80VE3Y5wO9lExyOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-c44Z_jsvPI-oFkILqi6vEA-1; Thu, 03 Sep 2020 20:59:50 -0400
X-MC-Unique: c44Z_jsvPI-oFkILqi6vEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C921E81F035;
 Fri,  4 Sep 2020 00:59:48 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51B1978B38;
 Fri,  4 Sep 2020 00:59:46 +0000 (UTC)
Subject: Re: [PATCH v3 20/21] KVM: arm64: Remove unused 'pgd' field from
 'struct kvm_s2_mmu'
To: Will Deacon <will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-21-will@kernel.org>
 <f0a64bb2-5371-9f44-1c64-035cbc6dcf5b@redhat.com>
 <20200903165020.GC7791@willie-the-truck>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <7911796d-9124-cb7c-ace5-51e3b6d2dc28@redhat.com>
Date: Fri, 4 Sep 2020 10:59:44 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200903165020.GC7791@willie-the-truck>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Will,

On 9/4/20 2:50 AM, Will Deacon wrote:
> On Thu, Sep 03, 2020 at 03:07:17PM +1000, Gavin Shan wrote:
>> On 8/25/20 7:39 PM, Will Deacon wrote:
>>> The stage-2 page-tables are entirely encapsulated by the 'pgt' field of
>>> 'struct kvm_s2_mmu', so remove the unused 'pgd' field.
>>>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Quentin Perret <qperret@google.com>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>>>    arch/arm64/include/asm/kvm_host.h | 1 -
>>>    arch/arm64/kvm/mmu.c              | 2 --
>>>    2 files changed, 3 deletions(-)
>>>
>>
>> I think this might be folded into PATCH[18] as both patches are
>> simple enough. I'm not sure the changes introduced in PATCH[19]
>> prevent us doing this.
>>
>> There is another question below.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 0b7c702b2151..41caf29bd93c 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -79,7 +79,6 @@ struct kvm_s2_mmu {
>>>    	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
>>>    	 * canonical stage-2 page tables.
>>>    	 */
>>> -	pgd_t		*pgd;
>>>    	phys_addr_t	pgd_phys;
>>>    	struct kvm_pgtable *pgt;
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index ddeec0b03666..f28e03dcb897 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -384,7 +384,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>>>    	mmu->kvm = kvm;
>>>    	mmu->pgt = pgt;
>>>    	mmu->pgd_phys = __pa(pgt->pgd);
>>> -	mmu->pgd = (void *)pgt->pgd;
>>>    	mmu->vmid.vmid_gen = 0;
>>>    	return 0;
>>> @@ -470,7 +469,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>    	spin_lock(&kvm->mmu_lock);
>>>    	pgt = mmu->pgt;
>>>    	if (pgt) {
>>> -		mmu->pgd = NULL;
>>>    		mmu->pgd_phys = 0;
>>>    		mmu->pgt = NULL;
>>>    		free_percpu(mmu->last_vcpu_ran);
>>>
>>
>> I guess mmu->pgd_phys might be removed either because kvm_get_vttbr()
>> is the only consumer.
> 
> Hmm, but kvm_get_vttbr() is still used after these patches, so I think
> the pgd_phys field needs to stick around.
> 

Yes, kvm_get_vttbr() is the only consumer. The corresponding physical
address can be figured out in the function, we needn't have the physical
address and cache it in advance. However, it's not a big deal. I probably
post one patch to remove it after this series gets merged.

    baddr = __pa(mmu->pgt->pgd);

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
