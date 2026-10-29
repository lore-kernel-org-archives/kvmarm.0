Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793311517;
	b=rdvg+vxT0MIqIBUeFQ6zvchSU1jTnMRS+Miw+nfRXUR2rkth3mrYkEeJPEpGBD9U1B/z
	 XHEXmXH+ZZuutRdfYMSVizBgEmQl/0vpm3zkuxV3QHlXN+eNue0KhdZeAdGmvy10f+tFK
	 XfJvyrHYDl817VOEIymCCpDmMSlqEyMhNQnjEx8wsaNfS/Dbl+S79X088aGG6J98tTaG6
	 37Q6p7z6TAGyAbD4rAYzzyhVF3UShNf/Eyr3IvBEC5dQTbDvOnZgoSm1QccDzWPuXIbui
	 tK29754QD+o+YVS6QI334Ot6KEIVfB7qzU1O+sL8tAtV61V4KsqVIU3jPAIchsJCIxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793311517;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BOIOVIeuoZTPYLCw9qgl59aa+oUmsxHGBfBI4tPDjNk=;
	b=J3dYdFVa43jx8gdzvabDdFWJdriDQoY0HxG3btUUg+KDelMu9JZDK6ZR3o8E9BeLii6G
	 RQUxaQQKjGFBXQ74YeRHJWc6SEsgeGgCWkoahsUXVM2QdmHewzIS9CtbfrFuqDUTWHb9c
	 UMNdmHKn5c3BD4MtYyH6l9o1BBNFwAWCJbR9G7bABNqAWqpZWb2yaqrAlPuIRuWJWLMd8
	 AXr6ogdwaC7FWIQOlPvwOchztdRqdCFBGFJnLsRfC+jalvUXfRlzX3OSgGNFOaOfx3RO9
	 A9U6Z2zDcUbMSpcNW3p7IkMdgTJeRWfhn5iEdMyd6nPWGTXNeqrX0nnw0DeQCOL/5Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Q1HLeuNJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76975606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76975606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Q1HLeuNJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDA4815A1;
	Thu, 29 Oct 2026 15:05:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE5AD3F673;
	Thu, 29 Oct 2026 15:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793311515; bh=Ijs585yEk7skk5Tt9uzpTzRD8zZrNST3f/danWDydDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q1HLeuNJ6kUbLgKJbyCy8NiFp2jr5MnpfDLave9KjaLtv7f17AEgdwnAF7e5lb6Ro
	 tVVtAHTLlFvSsEdFncJ6eGP961Hg7yMz4IR1dHygDt/zYxGNOmAmFdq9mHa/82Rt1J
	 eh9vd1QlT9ochELhnF9vdn4cxoch5nBM4dVrR9B0=
Date: Thu, 29 Oct 2026 22:05:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm64: mte: Add mte_clear_folio_tags()
Message-ID: <auPDF0KIpU_WjK_k@arm.com>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
 <20261021110700.493315-5-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021110700.493315-5-fuad.tabba@linux.dev>

On Wed, Oct 21, 2026 at 12:07:00PM +0100, Fuad Tabba wrote:
> mte_sync_tags(), sanitise_mte_tags() and kvm_vm_ioctl_mte_copy_tags()
> each open-code the loop that clears the tags of every page in a hugetlb
> folio. Add mte_clear_folio_tags() and use it in all three.
> kvm_vm_ioctl_mte_copy_tags() then tests for hugetlb first, as it does
> where it sets the tagged flag below.
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
