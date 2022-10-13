Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B863205
	for <kvmarm@lists.linux.dev>; Thu, 13 Oct 2022 14:14:46 +0000 (UTC)
Date: Thu, 13 Oct 2022 16:14:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665670479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YTnR3sTpueMD1WOCKjn13lgOyfXnFgP1FGLusy0IRdQ=;
	b=o8iWPUfoQGziwzej5BerN5CcyiIwIgIJX1BIPhpwk1A3iUth1ltoEDYJ5RgytnN8fxDsFE
	09J30ihjCMewpdUEKnz7/NFKmvIhtCq9EUwJd3uexhjD1ECAFaFNPxcaBIzPTV7p96Oxaz
	1WNityOODlONHfzCXCTeiTbpZu7U+44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
	seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
	oupton@google.com, reijiw@google.com, rananta@google.com,
	bgardon@google.com, dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v9 09/14] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <20221013141431.datybmwzfdeqxobv@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-10-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221013141431.R9fraLj0MiSiNB3MmoREoe4sUgl2MTzKmssN7h5Vdy8@z>

On Tue, Oct 11, 2022 at 01:06:23AM +0000, Ricardo Koller wrote:
> Now that kvm_vm allows specifying different memslots for code, page tables,
> and data, use the appropriate memslot when making allocations in
> common/libraty code. Change them accordingly:
> 
> - code (allocated by lib/elf) use the CODE memslot
> - stacks, exception tables, and other core data pages (like the TSS in x86)
>   use the DATA memslot
> - page tables and the PGD use the PT memslot
> - test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
>   memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 12 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  8 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  8 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 65 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
