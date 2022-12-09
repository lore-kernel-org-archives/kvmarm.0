Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A84A35
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 08:24:35 +0000 (UTC)
Date: Fri, 9 Dec 2022 09:24:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670574267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Ujz0yDFlzjy73eRFThISN+4ybbqpoYq14hTZV0v3A8=;
	b=X1tn0ibWUZ9h8j6sycvZQrHaBQ/KIgXvJq3J+tF/hK7yE9U1924sn4kaJn5IdxS8U+CH+l
	erTziAmwd8ZLP3fbSUZwztsRMog4NkcuIVZXe4ICqNhgLLBqlAQtn9e7R1qii1iIV8nEVQ
	AhmX6RPI+5XaqXe6KdrIDjh2oMrc7V8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <20221209082423.yideydkw6ig6x5zg@kamzik>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221209082423.AgKOv1NPCk12cPq6vAkeQhi_6JJBakC7dG37PQsTFts@z>

On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>  - Collect R-b from Sean (thanks!)
>  - Use a common routine for split and contiguous VA spaces, with
>    commentary on why arm64 is different since we all get to look at it
>    now. (Sean)
>  - Don't identity map the ucall MMIO hole
>  - Fix an off-by-one issue in the accounting of virtual memory,
>    discovered in fighting with #2
>  - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>    ucall_init() v. kvm_vm_elf_load() ordering issue
> 
> Mark Brown (1):
>   KVM: selftests: Fix build due to ucall_uninit() removal
> 
> Oliver Upton (6):
>   KVM: selftests: Setup ucall after loading program into guest memory
>   KVM: selftests: Mark correct page as mapped in virt_map()
>   KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
>   KVM: arm64: selftests: Don't identity map the ucall MMIO hole
>   KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
>   KVM: selftests: Avoid infinite loop if ucall_alloc() fails
> 
>  .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
>  .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
>  5 files changed, 68 insertions(+), 15 deletions(-)
> 
> 
> base-commit: 89b2395859651113375101bb07cd6340b1ba3637

This commit doesn't seem to exist linux-next or kvm/queue, but the patch
context seems to match up with linux-next pretty well. Anyway,

For the series

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
