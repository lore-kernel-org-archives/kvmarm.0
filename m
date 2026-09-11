Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BA14749C9
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789132590; cv=none; b=Lgkrom0eX1Hyd/kI6WDRE4wtVDHkrNg/v6RuL/djPmvcTRnOVGqcQUX8I7wuRcxWRmPQj3Znlu2j6zhRiQyspo7SXXLFkc3p6R0cfPXh8S1iEDfwvj4E1WzcgiDgzTWt7AcItrNo3SD1xrYnP6hmrwHJ8R+8D+BpPkgenSw/a/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789132590; c=relaxed/simple;
	bh=rAPjrIWKifje2rtdcSgWJSLMEJH9EivwHOgVHlZZ3dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuvWo9RCmaZ4GWjnvts5b4wyHcwtr35jdk4x74CLCcweq4J0HmvhwuwzM2kMBzNcK8HnTF8ly2Zd+CuX05tu5XjiU4BR+qZ6kA3Atj5441R1HpbrG4lpwvwOoZhAJbGeJSGhQhijX8hu6hVzT3zTlI2xCX8piUjg62xTy6VfrjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r0tu6ZAf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r0tu6ZAf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E92EF1655;
	Fri, 11 Sep 2026 06:16:23 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB89C3F59E;
	Fri, 11 Sep 2026 06:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789132587; bh=rAPjrIWKifje2rtdcSgWJSLMEJH9EivwHOgVHlZZ3dE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r0tu6ZAf4lq5MRFWS31tTOfRDtHvinmOQ29Vtb1/B0tftDLqhhW9HxUovv78dAyTZ
	 HTwUhytsEIBHJGdWEgSNtLuAg6dikEXWnoGt77bmZGNluHbmTQHaLcOfbz4uZgX7+5
	 D3tOkF0c+Au2ERScqBpcT3/fF96wVnhS+IuQXLTg=
Date: Fri, 11 Sep 2026 14:16:18 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <gerjpm62a2gszzggc6vuai22bf3prfquvfsp7ueumps7vz2ev3@odlmovaklg2b>
References: <20260810205038.118843-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810205038.118843-1-weilin.chang@arm.com>

On Mon, Aug 10, 2026 at 09:50:32PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v5 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.

I did a more targetted test of this series in a (ad-hoc) way similar to
pkvm_ownership_selftest(). I allocated and initialized an in kernel VM,
its locks, 2 nested_mmus, and a memcache.

By calling kvm_pgtable_stage2_map(), kvm_record_guest_s2_mapping()
together I create mappings and track them, then
kvm_nested_unmap_cipa_range() simulates mmu notifier unmaps, and
kvm_stage2_unmap_range() simulates L1 TLBIs.

Combining these I tried a few scenarios:

1. Mapping the same CIPA in two nested mmus, and checked that
   unmapping the CIPA it removes both mappings, but keeps unrelated
   mappings.

2. Mapping a block and a page to an overlapping CIPA region, checked
   that unmapping the overlapping CIPA regions removes both mappings.

3. Unmapping CIPA of the last page of a block, checking that the block
   is removed, but keeps unrelated mappings.

4. Unmapping a CIPA range that starts in an empty region, checking that
   it finds and removes the mappings inside the range, keeps unrelated
   mappings.

5. First map NIPA -> CIPA1, unmap that NIPA, then create NIPA -> CIPA2,
   and check that unmapping the CIPA1 leaves the new mapping alone.

6. Creating multiple identical mappings, and checked unmapping the
   CIPA once removes the mapping.

The dumped shadow page tables all contain the expected mappings.

Thanks,
Wei-Lin Chang

[...]
