Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CADC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:54:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AC8D20809
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC8D20809
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3BC4B1A4;
	Thu, 10 Sep 2020 09:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k3UouBsKCPnp; Thu, 10 Sep 2020 09:54:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BAE94B1A6;
	Thu, 10 Sep 2020 09:54:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E1A4B19A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:54:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wv2eSNTReNmx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 09:54:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0AA4B191
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:54:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 566EB113E;
 Thu, 10 Sep 2020 06:54:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 135243F66E;
 Thu, 10 Sep 2020 06:54:51 -0700 (PDT)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
To: Will Deacon <will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-7-will@kernel.org>
 <f5939f12-56e8-794c-8d9b-9ae348bba3c0@arm.com>
 <20200910123404.GA18100@willie-the-truck>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ea9677c4-e6c6-6a2a-725b-df86adeefd94@arm.com>
Date: Thu, 10 Sep 2020 14:55:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910123404.GA18100@willie-the-truck>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 9/10/20 1:34 PM, Will Deacon wrote:
> On Thu, Sep 10, 2020 at 12:20:42PM +0100, Alexandru Elisei wrote:
>> On 9/7/20 4:23 PM, Will Deacon wrote:
>>> +static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>>> +				      kvm_pte_t *ptep,
>>> +				      struct stage2_map_data *data)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (!data->anchor)
>>> +		return 0;
>>> +
>>> +	free_page((unsigned long)kvm_pte_follow(*ptep));
>>> +	put_page(virt_to_page(ptep));
>>> +
>>> +	if (data->anchor == ptep) {
>>> +		data->anchor = NULL;
>>> +		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
>>> +	}
>> I had another look at this function. If we're back to the anchor entry, then that
>> means that we know from the pre-order visitor that 1. the mapping is supported at
>> this level and 2. that the pte was invalidated. This means that
>> kvm_set_valid_leaf_pte() will succeed in changing the entry. How about instead of
>> calling stage2_map_walk_leaf() -> stage2_map_walker_try_leaf() ->
>> kvm_set_valid_leaf_pte() we call kvm_set_valid_leaf_pte() directly, followed by
>> get_page(virt_to_page(ptep)? It would make the code a lot easier to follow
>> (stage2_map_walk_leaf() is pretty complicated, imo, but that can't really be
>> avoided), and also slightly faster.
> I'm not sure I agree. I would consider kvm_set_valid_leaf_pte() to be lower
> level, and not the right function to be calling here. Rather,
> stage2_map_walk_leaf() is what would have been called if we hadn't spotted
> the potential for a block mapping anyway, so I much prefer that symmetry. It
> also means that if stage2_map_walk_leaf() grows some extra logic in future
> that we need to take into account here, we won't miss anything.

Sure, that makes sense.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
