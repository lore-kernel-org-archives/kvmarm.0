Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF34EC433E2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:42:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35604208D5
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35604208D5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5F74BD7F;
	Fri, 28 Aug 2020 11:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E6VVtXBkQLnZ; Fri, 28 Aug 2020 11:42:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 745D74BCD6;
	Fri, 28 Aug 2020 11:42:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A90194BBCB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:42:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xEy76s+Cv9xS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 11:42:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D8D4BA1E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:42:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D73C5D6E;
 Fri, 28 Aug 2020 08:42:27 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1F253F71F;
 Fri, 28 Aug 2020 08:42:26 -0700 (PDT)
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
 <9de812eb-1067-08bf-69cd-eb205dfbda35@arm.com>
Message-ID: <c4fce7a6-352e-ff01-65e6-5da49f24224c@arm.com>
Date: Fri, 28 Aug 2020 16:43:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <9de812eb-1067-08bf-69cd-eb205dfbda35@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
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

Hi,

I've had another good look at the code, and I now I can answer some of my own
questions. Sorry for the noise!

On 8/27/20 5:27 PM, Alexandru Elisei wrote:
> [..]
> +
> +	if (!table) {
> +		data->addr += kvm_granule_size(level);
> +		goto out;
> +	}
> +
> +	childp = kvm_pte_follow(pte);
> +	ret = __kvm_pgtable_walk(data, childp, level + 1);
> +	if (ret)
> +		goto out;
> +
> +	if (flags & KVM_PGTABLE_WALK_TABLE_POST) {
> We check that ptep is a valid table when we test the KVM_PGTABLE_WALK_TABLE_PRE
> flag, why aren't we doing that here?

That's because the function goes to out if the leaf visitor didn't turn the leaf
entry into a table.

>
>> +		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
>> +					     KVM_PGTABLE_WALK_TABLE_POST);
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> [..]
>> +}
>> +
>> +static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>> +{
>> +	u32 idx;
>> +	int ret = 0;
>> +	struct kvm_pgtable *pgt = data->pgt;
>> +	u64 limit = BIT(pgt->ia_bits);
>> +
>> +	if (data->addr > limit || data->end > limit)
>> +		return -ERANGE;
>> +
>> +	if (!pgt->pgd)
>> +		return -EINVAL;
>> +
>> +	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
>> +		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
> I'm sorry, but I just don't understand this part:
>
> - Why do we skip over PTRS_PER_PTE instead of visiting each idx?
>
> - Why do we use PTRS_PER_PTE instead of PTRS_PER_PGD?
>
> Would you mind explaining what the loop is doing?
>
> I also don't see anywhere in the page table walking code where we take into
> account that we can have concatenated tables at level 1 or 2, which means we have
> more entries than PTRS_PER_P{U,M}D.

I think I understand the code better now, __kvm_pgtable_walk will visit all
entries in the range ptep[0..PTRS_PER_PTE-1], that's why every iteration we
increment by PTRS_PER_PTE.

>
>> +
>> +		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>> +		     struct kvm_pgtable_walker *walker)
>> +{
>> +	struct kvm_pgtable_walk_data walk_data = {
>> +		.pgt	= pgt,
>> +		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
>> +		.end	= PAGE_ALIGN(walk_data.addr + size),
> [..]
>
> What happens if addr < PAGE_SIZE - 1? It looks to me that according to the
> definition of ALIGN_DOWN, addr will wrap around.

My mistake again, ALIGN_DOWN will subtract PAGE_SIZE - 1, but __ALIGN_KERNEL will
add PAGE_SIZE - 1, and the result is what we expect (no wrapping around).

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
