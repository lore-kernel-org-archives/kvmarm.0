Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF05348C79;
	Mon,  6 Jul 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783345350; cv=none; b=reowY+s5DQPwxv0ljoiTlpCBycJOeZpKb3mom7Oof07GFLbCftTl1s5+TmIs/9VgvDt0tzByDgvppbvYWtUCU6s3jR5cmWA5LyUr0WKH2nsbHEiluBsqlIRvFFFq53CtYzBKApz8JDGdtE2SSwErltj6C4/cV0eJglpEZRFkGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783345350; c=relaxed/simple;
	bh=XAFY2PT6pdsrqzojrYs8JZ6/o40ZFesVrGhqlhhlBHU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HAizfsSCtizZurK9wFdCxErf9xJoMJbldvd/VJCcZpZqp/3uR7o5KGwPMqG+9VOxm1+9pQqcyIzXWY+9Dk0NJU+0ZfhKGLftFOjBh40X0Xaa68T9ro/a3aas9j96kUnaLXj2NiCj/B6WPYsLdC1Kk9s3NPlNcdz+q27Mwn9uRYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyTUEFo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyTUEFo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CE11F000E9;
	Mon,  6 Jul 2026 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345348;
	bh=gXQkycuyZrdfubY+a8etURqHKk4IqlvevFVov045YPE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MyTUEFo+V8Urr2g/vi7rndXCyW+0VLn2hck1DNdkKhva7mSObnt3GYs6H3d1v3hK2
	 1TEFyhfmmbXArlLTvIQhrsqFCwqyADwS+LVYNQ6G2RN7xDV96Hgd1pKXP/BOR0qEY6
	 YIVYXs3JBwYYR5wjRxTrhFGO6SlfmE/XW880EnxFSxulA3EzvwnoyGuQS4G7OwJlmU
	 tE3cwfhh4IxggHX4IMOWUIWlcOf/88vGjd6IlfgFYkaD8pYIBT3VuvHANC8OLDoHIA
	 k0BAKkE0+1fxXVDXVUMFu0kRSY3YlZ4x0Ca+73lDkNDaDGsrE54C4a3ECtbhgV9uen
	 Bzo4jyQVdJExA==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 02/10] irqchip/gic-v3-its: Align shared ITS
 allocations to the CoCo shared granule size
In-Reply-To: <86ik6sp7fc.wl-maz@kernel.org>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
 <20260706060432.1375570-3-aneesh.kumar@kernel.org>
 <86ik6sp7fc.wl-maz@kernel.org>
Date: Mon, 06 Jul 2026 19:12:17 +0530
Message-ID: <yq5a7bn8i69y.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 06 Jul 2026 07:04:24 +0100,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> 
>> ITS tables allocated by the coco guest are shared with the hypervisor.
>> These allocations must satisfy the host shared-buffer granule size so that
>> the full converted range is safe for host access.
>> 
>> Allocate ITS pages using a size rounded up to the shared granule size and
>> use the same allocation order when encrypting, decrypting and freeing the
>> memory. Also grow the ITT cache in shared-granule sized chunks instead of
>> assuming PAGE_SIZE is sufficient.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index b57d81ad33a0..5d6d38aa0dae 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -213,16 +213,17 @@ static gfp_t gfp_flags_quirk;
>>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>>  					 unsigned int order)
>>  {
>> +	unsigned int alloc_order;
>>  	struct page *page;
>>  	int ret = 0;
>>  
>> -	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
>> -
>> +	alloc_order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
>> +	page = alloc_pages_node(node, gfp | gfp_flags_quirk, alloc_order);
>>  	if (!page)
>>  		return NULL;
>>  
>>  	ret = set_memory_decrypted((unsigned long)page_address(page),
>> -				   1 << order);
>> +				   1 << alloc_order);
>>  	/*
>>  	 * If set_memory_decrypted() fails then we don't know what state the
>>  	 * page is in, so we can't free it. Instead we leak it.
>> @@ -241,13 +242,16 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
>>  
>>  static void its_free_pages(void *addr, unsigned int order)
>>  {
>> +	int alloc_order;
>> +
>> +	alloc_order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
>>  	/*
>>  	 * If the memory cannot be encrypted again then we must leak the pages.
>>  	 * set_memory_encrypted() will already have WARNed.
>>  	 */
>> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
>> +	if (set_memory_encrypted((unsigned long)addr, 1 << alloc_order))
>>  		return;
>> -	free_pages((unsigned long)addr, order);
>> +	free_pages((unsigned long)addr, alloc_order);
>
> The comments I had in [1] are still applicable.
>
> 	M.
>
> [1] https://lore.kernel.org/all/86zf2ozrb8.wl-maz@kernel.org/
>

I renamed it to alloc_order to make it clear that it refers to the
allocation order rather than the requested order. If you feel strongly
about not introducing another variable, I'll drop the new variable.

-aneesh
