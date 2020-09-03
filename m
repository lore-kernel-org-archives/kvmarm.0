Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F5CC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 01:11:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63A982078E
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 01:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5XdRz4i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63A982078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C72104B0FF;
	Wed,  2 Sep 2020 21:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eB6wAp2SHy28; Wed,  2 Sep 2020 21:11:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B60A4B1ED;
	Wed,  2 Sep 2020 21:11:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23704B1DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 21:11:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LCMoUnZHsMS0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 21:11:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F0A4B0FF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 21:11:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599095507;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Em8U3W4MFt4u6xRGN4lhINCSaxZvgW80YlIQOgk2TF0=;
 b=F5XdRz4i87pFQyKqoFLzhbLRdvkR5kD+mnGl1OTRTbyspFYi4xuMCWCSQrLkwJpuC5opHi
 x/V3EuGijJlzyNHPOYK6gTNbKP0566qoF+qLqlDqNKbGwstZaHtSf5j0VfhyySYYbSsg5K
 FIaWIlR/ZtLHnF9umozHcakw9hEmQJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-T2rzYnjJMIyrK2FKEmulpQ-1; Wed, 02 Sep 2020 21:11:43 -0400
X-MC-Unique: T2rzYnjJMIyrK2FKEmulpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43B9285C733;
 Thu,  3 Sep 2020 01:11:42 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 459407EEB6;
 Thu,  3 Sep 2020 01:11:38 +0000 (UTC)
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
To: Will Deacon <will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
 <5ca35d7e-79c2-4e07-962c-cc2eb62f1acb@redhat.com>
 <20200902110233.GE5567@willie-the-truck>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <eedaf062-703c-6782-37f0-57b1b05e1d93@redhat.com>
Date: Thu, 3 Sep 2020 11:11:37 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200902110233.GE5567@willie-the-truck>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
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

On 9/2/20 9:02 PM, Will Deacon wrote:
> On Wed, Sep 02, 2020 at 04:31:32PM +1000, Gavin Shan wrote:
>> On 8/25/20 7:39 PM, Will Deacon wrote:
>>> The KVM page-table code is intricately tied into the kernel page-table
>>> code and re-uses the pte/pmd/pud/p4d/pgd macros directly in an attempt
>>> to reduce code duplication. Unfortunately, the reality is that there is
>>> an awful lot of code required to make this work, and at the end of the
>>> day you're limited to creating page-tables with the same configuration
>>> as the host kernel. Furthermore, lifting the page-table code to run
>>> directly at EL2 on a non-VHE system (as we plan to to do in future
>>> patches) is practically impossible due to the number of dependencies it
>>> has on the core kernel.
>>>
>>> Introduce a framework for walking Armv8 page-tables configured
>>> independently from the host kernel.
>>>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Quentin Perret <qperret@google.com>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>>>    arch/arm64/include/asm/kvm_pgtable.h | 101 ++++++++++
>>>    arch/arm64/kvm/hyp/Makefile          |   2 +-
>>>    arch/arm64/kvm/hyp/pgtable.c         | 290 +++++++++++++++++++++++++++
>>>    3 files changed, 392 insertions(+), 1 deletion(-)
>>>    create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
>>>    create mode 100644 arch/arm64/kvm/hyp/pgtable.c
> 
> [...]
> 
>>> +struct kvm_pgtable_walk_data {
>>> +	struct kvm_pgtable		*pgt;
>>> +	struct kvm_pgtable_walker	*walker;
>>> +
>>> +	u64				addr;
>>> +	u64				end;
>>> +};
>>> +
>>
>> Some of the following function might be worthy to be inlined, considering
>> their complexity :)
> 
> I'll leave that for the compiler to figure out :)
> 

Ok :)

>>> +static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>>> +{
>>> +	struct kvm_pgtable pgt = {
>>> +		.ia_bits	= ia_bits,
>>> +		.start_level	= start_level,
>>> +	};
>>> +
>>> +	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>>> +}
>>> +
>>
>> It seems @pgt.start_level is assigned with wrong value here.
>> For example, @start_level is 2 when @ia_bits and PAGE_SIZE
>> are 40 and 64KB separately. In this case, __kvm_pgd_page_idx()
>> always return zero. However, the extra page covers up the
>> issue. I think something like below might be needed:
>>
>> 	struct kvm_pgtable pgt = {
>> 		.ia_bits	= ia_bits,
>> 		.start_level	= KVM_PGTABLE_MAX_LEVELS - start_level + 1,
>> 	};
> 
> Hmm, we're pulling the start_level right out of the vtcr, so I don't see
> how it can be wrong. In your example, a start_level of 2 seems correct to
> me, as we'll translate 13 bits there, then 13 bits at level 3 which covers
> the 24 bits you need (with a 16-bit offset within the page).
> 
> Your suggestion would give us a start_level of 1, which has a redundant
> level of translation. Maybe you're looking at the levels upside-down? The
> top level is level 0 and each time you walk to a new level, that number
> increases.
> 
> But perhaps I'm missing something. Please could you elaborate if you think
> there's a problem here?
> 

Thanks for the explanation. I think I was understanding the code in wrong
way. In this particular path, __kvm_pgd_page_idx() is used to calculate
how many subordinate pages needed to hold PGDs. If I'm correct, there are
16 pages for PGDs to the maximal degree. So current implementation looks
correct to me.

There is another question, which might not relevant. I added some logs
around and hopefully my calculation is making sense. I have following
configuration (values) in my experiment. I'm including the kernel log
to make information complete:

    [ 5089.107147] kvm_arch_init_vm: kvm@0xfffffe0028460000, type=0x0
    [ 5089.112973] kvm_arm_setup_stage2: kvm@0xfffffe0028460000, type=0x0
    [ 5089.119157]    kvm_ipa_limit=0x2c, phys_shift=0x28
    [ 5089.123936]    kvm->arch.vtcr=0x00000000802c7558
    [ 5089.128552] kvm_init_stage2_mmu: kvm@0xfffffe0028460000
    [ 5089.133765] kvm_pgtable_stage2_init: kvm@0xfffffe0028460000, ia_bits=0x28,start_level=0x2

    PAGE_SIZE:       64KB
    @kvm->arch.vtcr: 0x00000000_802c7558
    @ipa_bits:       40
    @start_level:    2

    #define KVM_PGTABLE_MAX_LEVELS            4U

    static u64 kvm_granule_shift(u32 level)
    {
         return (KVM_PGTABLE_MAX_LEVELS - level) * (PAGE_SHIFT - 3) + 3;
    }

    static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
    {
         u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
         u64 mask = BIT(pgt->ia_bits) - 1;

         return (addr & mask) >> shift;

         // shift = kvm_granule_shift(2 - 1) = ((3 * 13) + 3) = 42
         // mask  = ((1UL << 40) - 1)
         // return (0x000000ff_ffffffff >> 42) = 0
         //
         // QUESTION: Since we have 40-bits @ipa_bits, why we need shift 42-bits here.
    }

I was also thinking about the following case, which is making sense
to me. Note I didn't add logs to debug for this case.

    PAGE_SIZE:     4KB
    @ipa_bits:     40
    @start_level:  1

    static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
    {
         u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
         u64 mask = BIT(pgt->ia_bits) - 1;

         return (addr & mask) >> shift;

         // shift = kvm_granule_shift(1 - 1) = ((4 * 9) + 3) = 39
         // mask  = ((1UL << 40) - 1)
         // return (0x000000ff_ffffffff >> 39) = 1
    }

>>> +static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>>> +{
>>> +	u32 idx;
>>> +	int ret = 0;
>>> +	struct kvm_pgtable *pgt = data->pgt;
>>> +	u64 limit = BIT(pgt->ia_bits);
>>> +
>>> +	if (data->addr > limit || data->end > limit)
>>> +		return -ERANGE;
>>> +
>>> +	if (!pgt->pgd)
>>> +		return -EINVAL;
>>> +
>>> +	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
>>> +		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>>> +
>>> +		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
>>> +		if (ret)
>>> +			break;
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>
>> I guess we need bail on the following condition:
>>
>>          if (data->addr >= limit || data->end >= limit)
>>              return -ERANGE;
> 
> What's wrong with the existing check? In particular, I think we _want_
> to support data->end == limit (it's exclusive). If data->addr == limit,
> then we'll have a size of zero and the loop won't run.
> 

I was thinking @limit is exclusive, so we need bail when hitting the
ceiling. The @limit was figured out from @ia_bits. For example, it's
0x00000100_00000000 when @ia_bits is 40-bits, and it's invalid adress
to the guest, but I'm still wrong in this case :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
