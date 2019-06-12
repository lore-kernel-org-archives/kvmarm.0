Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5FDC31E48
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 08:50:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DDFD206E0
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 08:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DDFD206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B4F4A522;
	Wed, 12 Jun 2019 04:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o4w3F4XhjA3L; Wed, 12 Jun 2019 04:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6CE4A515;
	Wed, 12 Jun 2019 04:49:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0484A4EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 04:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6U2Scs1MhPU8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 04:49:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 259944A4DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 04:49:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE6E82B;
 Wed, 12 Jun 2019 01:49:55 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BC543F246;
 Wed, 12 Jun 2019 01:49:54 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
From: Julien Thierry <julien.thierry@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-2-marc.zyngier@arm.com>
 <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
Message-ID: <37a7411c-e7e0-e601-b88b-c12e8ebf9861@arm.com>
Date: Wed, 12 Jun 2019 09:49:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
Content-Language: en-US
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>
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



On 12/06/2019 09:16, Julien Thierry wrote:
> Hi Marc,
> 
> On 11/06/2019 18:03, Marc Zyngier wrote:

[...]

>> +
>> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	unsigned int sz;
>> +	int i;
>> +
>> +	if (!list_empty(&dist->lpi_translation_cache))
>> +		return;
>> +
>> +	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
>> +
>> +	for (i = 0; i < sz; i++) {
>> +		struct vgic_translation_cache_entry *cte;
>> +
>> +		/* An allocation failure is not fatal */
>> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
>> +		if (WARN_ON(!cte))
>> +			break;
>> +
>> +		INIT_LIST_HEAD(&cte->entry);
>> +		list_add(&cte->entry, &dist->lpi_translation_cache);
> 
> Going through the series, it looks like this list is either empty
> (before the cache init) or has a fixed number
> (LPI_DEFAULT_PCPU_CACHE_SIZE * nr_cpus) of entries. And the list never
> grows nor shrinks throughout the series, so it seems odd to be using a
> list here.
> 
> Is there a reason for not using a dynamically allocated array instead of
> the list? (does list_move() provide a big perf advantage over swapping
> the data from one array entry to another? Or is there some other
> facility I am missing?
> 

Scratch that, I realized having the list makes it easier to implement
the LRU policy later in the series.

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
