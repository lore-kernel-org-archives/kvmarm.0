Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDA81791F4
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 06:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728974875; cv=none; b=h74t7WjLZcusOca3N/te0pLRNIJPkWiWjD8AA2w6v745re2hqui2eh+/ju5gFjGGv0rjxE6nqFn0wORc74RZH/qstw8SiJe/n6hrK/NYgnznQg6yR91ElqP2iJ/VWPMGp8dJAQwPfvxpG4CVaPntdlkgP+YaQWNvmgryaUeacrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728974875; c=relaxed/simple;
	bh=f+iwX7UEizM9j8dLIpnFyt93Chuij2gS7tr4VcdPMwg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=bVN12SzP4fmY12r/Wuylg5r372h6MWJijNwN0p3gTPKRVZnIB8JkwWuY2IhCbRjLSahMY3CYsfDvkZJHPxxE6gjHRKmXJLmBmfyvjCzqYU98Sbie+6/u8MCeHsy8KJ18VU7cQyFhS0FaIvoAQWYYCZlISkI0Dzv4pbt6FfhRk8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 630231007;
	Mon, 14 Oct 2024 23:48:22 -0700 (PDT)
Received: from [10.162.16.109] (a077893.blr.arm.com [10.162.16.109])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E06723F71E;
	Mon, 14 Oct 2024 23:47:49 -0700 (PDT)
Message-ID: <0d3f7e60-48e3-4b02-90d7-207868d3311f@arm.com>
Date: Tue, 15 Oct 2024 12:17:47 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 0/5] arm64/mm: Drop PXD_TABLE_BIT
To: Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <0ef88192-2523-418f-8ab7-442766a1c444@arm.com>
Content-Language: en-US
In-Reply-To: <0ef88192-2523-418f-8ab7-442766a1c444@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/24 19:02, Ryan Roberts wrote:
> On 05/10/2024 13:38, Anshuman Khandual wrote:
>> Clearing PXD_TABLE_BIT i.e bit[1] on a page table entry always operates on
>> the assumption that subsequent PXD_VALID i.e bit[0] is set. That's because
>> bits[1:0]="01" makes a block mapping. So it is prudent to treat bits[1:0]
>> as a single register field, which should be updated as block or table etc.
>> Although mk_[pmd|pud]_sect_prot() helpers go to some extent in using these
>> PXD_TYPE_SECT macros, their usage is not really consistent else where.
>>
>> This series removes these table bit clearing for block mapping creation and
>> eventually completely drops off those table macros.
> Given the issue I just noticed in patch 2, I'm not sure if it's going to be
> practical to remove the table bit after all? Sorry I didn't spot this before.

Now that arch_make_huge_pte() seems to be all good in patch 1, and there might
be a solution for pmd_present() via de-coupled pmd_mkinvalid(), would it still
not possible to drop PXD_TABLE_BIT ?
