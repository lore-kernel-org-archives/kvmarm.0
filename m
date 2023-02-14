Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26417C5E2
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 20:40:48 +0000 (UTC)
Date: Tue, 14 Feb 2023 21:23:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676406220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+uBN9Bn2ZufBVKlwHRxv10F6vgU620kjCUdcZKd8LN0=;
	b=J1dnPyP40TZIIf3EXmMWR8Sy0k3Cl7OfJaR61pboItEB7m++uBeq1RykPIfCz5HgClTF+C
	KATPEZUpRNjyCXN1qeQO1FFiMSlm6/kT/Bz7q13GwzuK8ijqzI5ifoo5BosxWrMlZwTvgN
	999CDfJbQO41Lxf49rihbwlytGl+Gbw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm/arm64: teach
 virt_to_pte_phys() about block descriptors
Message-ID: <20230214202334.dk22gk4fzy2rkdty@orel>
References: <20221124152816.22305-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124152816.22305-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 24, 2022 at 03:28:14PM +0000, Alexandru Elisei wrote:
> I was writing a quick test when I noticed that arm's implementation of
> __virt_to_phys(), which ends up calling virt_to_pte_phys(), doesn't handle
> block mappings and returns a bogus value. When fixing it I got confused
> about mmu_get_pte() and get_pte(), so I (hopefully) improved things by
> renaming mmu_get_pte() to follow_pte().
> 
> Changes since v1:
> 
> - Dropped patch #1 ("lib/vmalloc: Treat virt_to_pte_phys() as returning a
>   physical address") because it was incorrect.
> - Dropped the check for pte_valid() for the return value of mmu_get_pte() in
>   patch #1 because mmu_get_pte() returns NULL for an invalid descriptor.
> 
> Lightly tested on a rockpro64 (4k and 64k pages, arm64 and arm, qemu only)
> because the changes from the previous version are trivial.
> 
> Alexandru Elisei (2):
>   arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
>   arm/arm64: mmu: Rename mmu_get_pte() -> follow_pte()
> 
>  lib/arm/asm/mmu-api.h |  2 +-
>  lib/arm/mmu.c         | 88 +++++++++++++++++++++++++------------------
>  2 files changed, 53 insertions(+), 37 deletions(-)
> 
> -- 
> 2.37.0
>

Applied, thanks
