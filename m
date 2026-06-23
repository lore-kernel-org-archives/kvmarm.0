Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11B330BF69;
	Tue, 23 Jun 2026 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782231929; cv=none; b=R9y3SI+FeP076VJSph/Cpz+4ebjB/Skxy2JdCpo6DzmbXWmg2jK2H6kI093BhcwAJm8+5dOEQ56DlD+VIVAzqf3uaRIq64zfKjeGXG7uUs5VXbxJm8q5DlNijG5a4OAAbPptQj9NEQWoxDS5CEbLMXJoe3YdFPk5t84cbq7bZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782231929; c=relaxed/simple;
	bh=A9b1qj9ZOucQZxjyGKq2JtcMUc5nmPfYRn4al3aMuHs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=RpX4CbdxdQ7wUwIEk3H1gv+D0vV7zKtzuabK/xNzX1OeKAVAU96+BF/Ulp7lQHDi31j7xaJMy8Thv0ym+1Py20Bi3agT1Us8mDF98Bxzj0YQWfHHP+xkDCyOg2DbS73M8fg8dTmYdmYXf++1ZHpkii7LGUuDo0nX6BVOjYyJdcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=rmSgft4C; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="rmSgft4C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782231926;
	bh=+MlFDV6R4/8LsKAGUeFYJGeVdItFyu6+yzn/vIkbPHU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=rmSgft4C2Xy/Mh28b+zQRZGdQ/f2x4uXuY0qh8UMiK0RfRmAtdsdmc5pV5ApmXpFn
	 sfwKMjTuXaQhFXzfugJnFaB423HIKVzcb3OGDyEz21T5kTKJnil5E2csVr51JoEKEy
	 kilfKcSVugGrFD7XxvmFzpwC4Zr2h2iRVkBB/9qg=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gl9Qt1QMqz110b;
	Tue, 23 Jun 2026 16:25:26 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gl9Qs3H97z110W;
	Tue, 23 Jun 2026 16:25:25 +0000 (UTC)
Date: Tue, 23 Jun 2026 17:25:25 +0100
From: Bradley Morgan <include@grrlz.net>
To: sashiko-reviews@lists.linux.dev, sashiko-bot@kernel.org
CC: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_KVM=3A_arm64=3A_skip_pKVM_cac?=
 =?US-ASCII?Q?he_flushes_for_non_cacheable_mappings?=
In-Reply-To: <20260623161545.EA08E1F000E9@smtp.kernel.org>
References: <20260623160339.15143-1-include@grrlz.net> <20260623161545.EA08E1F000E9@smtp.kernel.org>
Message-ID: <59984F6D-06F2-4302-BDD7-92DF334E8FA0@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On June 23, 2026 5:15:45 PM GMT+01:00, sashiko-bot@kernel.org wrote:
>Thank you for your contribution! Sashiko AI review found 1 potential
>issue(s) to consider:
>
>Pre-existing issues:
>- [Critical] Handling a permission fault that upgrades a mapping to a huge page skips memcache top-up, leading to a NULL pointer dereference in `pkvm_pgtable_stage2_map()`.
>--
>
>commit d1dad1f606a114503ffa8d910f3c79c232636e5c
>Author: Bradley Morgan <include@grrlz.net>
>
>KVM: arm64: skip pKVM cache flushes for non cacheable mappings
>
>This patch adds a cacheable flag to pKVM mappings to avoid flushing
>non-cacheable stage 2 mappings. It updates pkvm_pgtable_stage2_map to
>record this attribute and pkvm_pgtable_stage2_flush to skip flushing.
>
>[ ... ]
>
>> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>> index 053e4f733e4be..efede6b5640e0 100644
>> --- a/arch/arm64/kvm/pkvm.c
>> +++ b/arch/arm64/kvm/pkvm.c
>> @@ -473,6 +473,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt,
>u64 addr, u64 size,
>>  	mapping->gfn = gfn;
>>  	mapping->pfn = pfn;
>>  	mapping->nr_pages = size / PAGE_SIZE;
>
>[Severity: Critical]
>This is a pre-existing issue, but could this lead to a NULL pointer
>dereference if the memcache wasn't topped up?
>
>In arch/arm64/kvm/mmu.c:user_mem_abort(), topup_mmu_memcache() is skipped
>for permission faults when dirty logging is not active:
>
>	memcache = get_mmu_memcache(s2fd->vcpu);
>	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
>			    kvm_is_write_fault(s2fd->vcpu))) {
>		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>		if (ret)
>			return ret;
>	}
>
>If a guest triggers a permission fault on an address backed by a
>transparent
>huge page (where the existing stage-2 mapping is a page-level mapping),
>kvm_s2_fault_map() will upgrade the mapping to a block and call
>pkvm_pgtable_stage2_map().
>
>For non-protected VMs on a pKVM host, pkvm_pgtable_stage2_map() then
>unshares
>the old mapping, sets mapping = NULL, and swaps it with cache->mapping:
>
>	swap(mapping, cache->mapping);
>	mapping->gfn = gfn;
>
>Because the top-up was skipped, cache->mapping is NULL, meaning
>mapping->gfn
>dereferences NULL, allowing an untrusted guest to crash the host.
>
>> +	mapping->cacheable = !(prot & (KVM_PGTABLE_PROT_DEVICE |
>> +				       KVM_PGTABLE_PROT_NORMAL_NC));
>>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
>>  
>>  	return ret;

Nice catch!

I'll add the lore link

The issue was discovered [1] by Sashiko.

[1]
https://lore.kernel.org/all/20260623161545.EA08E1F000E9@smtp.kernel.org/

To my second (fixes this) patches desc.
>

Thanks!
