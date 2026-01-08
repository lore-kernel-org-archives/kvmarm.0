Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958582E7F25
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 20:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903979; cv=none; b=POmCJUTY/OXhix67eIycIjzbSr+Zfd2faG+f2yYr8L0QEOaKZnYops/xPaHbC6F84HJbCkJ/BGhn8p4YHV1j0TIFXY5yf7yGduPvLNQFaiLcUINMaZhGjGxYxElPxjLUCGVdF+LyotcByCnZKGfH1Qi8fl3styPerFRxRledVKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903979; c=relaxed/simple;
	bh=Sdd4amalyUrWWlwupWxWmHu8yEjWHGcZK7d8qSJ/OPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pz+OBGf82WraPqfYo2G07gdJ8Lz1qgcxHTxlh7S6Lp5Z2k0ZZhEmkAs7bHdQWGiuPHhbzrBvS+3K3zWK/IKSM1IzSkMtv/wcj5hx9Snr/kLbJsUpyT1/zvYvZBFS/2qAwD+kzqc2Bicr9GGi+dUyqT41ClgoEBMsCqNEeQIujh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PMw7fKit; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PMw7fKit"
Date: Thu, 8 Jan 2026 20:26:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767903975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fwq273udHL84MC93sFKE2b+YO778RBmqz0tqmApt9d4=;
	b=PMw7fKitVdHrjyge5ljK6/L68v7R+4+vzO9D7MrAm90dsGbLRrjsBC9NHx8c3OlKqAGUK9
	RQOIL7n4eXlANPwfoUtyWD4bE7eFC4rCNTurJe+s9+e85FwgZizfMWhqRDh9j0WIuoS6J7
	lSSYP0wZh7tUajkrEiLaovdXVyWWH7s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
Message-ID: <kivowzryb3mbntaoud4kmhxjbix3usqjiy7phwihjc7p4rp4gk@ppilefrxpu35>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV_cLAlz4v1VOkDt@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 08, 2026 at 08:32:44AM -0800, Sean Christopherson wrote:
[..]
> @@ -106,12 +139,66 @@ static void l1_guest_code(void *data)
>  		l1_svm_code(data);
>  }
>  
> +static void test_handle_ucall_sync(struct kvm_vm *vm, u64 arg,
> +				   unsigned long *bmap)
> +{
> +	vm_vaddr_t gva = arg & ~(PAGE_SIZE - 1);
> +	int page_nr, i;
> +
> +	/*
> +	 * Extract the page number of underlying physical page, which is also
> +	 * the _L1_ page number.  The dirty bitmap _must_ be updated based on
> +	 * the L1 GPA, not L2 GPA, i.e. whether or not L2 used an aliased GPA
> +	 * (i.e. if TDP enabled for L2) is irrelevant with respect to the dirty
> +	 * bitmap and which underlying physical page is accessed.
> +	 *
> +	 * Note, gva will be '0' if there was no access, i.e. if the purpose of
> +	 * the sync is to verify all pages are clean.
> +	 */
> +	if (!gva)
> +		page_nr = 0;
> +	else if (gva >= TEST_MEM_ALIAS_BASE)
> +		page_nr = (gva - TEST_MEM_ALIAS_BASE) >> PAGE_SHIFT;
> +	else
> +		page_nr = (gva - TEST_MEM_BASE) >> PAGE_SHIFT;
> +	TEST_ASSERT(page_nr == 0 || page_nr == 1,
> +		    "Test bug, unexpected frame number '%u' for arg = %lx", page_nr, arg);
> +	TEST_ASSERT(gva || (arg & TEST_SYNC_NO_FAULT),
> +		    "Test bug, gva must be valid if a fault is expected");
> +
> +	kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
> +
> +	/*
> +	 * Check all pages to verify the correct physical page was modified (or
> +	 * not), and that all pages are clean/dirty as expected.
> +	 *
> +	 * If a fault of any kind is expected, the target page should be dirty
> +	 * as the Dirty bit is set in the gPTE.  KVM should create a writable
> +	 * SPTE even on a read fault, *and* KVM must mark the GFN as dirty
> +	 * when doing so.
> +	 */
> +	for (i = 0; i < TEST_MEM_PAGES; i++) {
> +		if (i == page_nr && arg & TEST_SYNC_WRITE_FAULT)

Micro nit: I think this is slightly clearer:
		if (i == page_nr && (arg & TEST_SYNC_WRITE_FAULT))

