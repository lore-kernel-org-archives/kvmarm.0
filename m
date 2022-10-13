Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4153205
	for <kvmarm@lists.linux.dev>; Thu, 13 Oct 2022 14:09:20 +0000 (UTC)
Date: Thu, 13 Oct 2022 16:09:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665670153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m4OT6t/hF2QZxwP8g/89k5+woQDdrKhIkPj7KFIFu+M=;
	b=qoFO2n4LWMAwtxat68aciJa0fWzzXGCWd4h2xV6/hkJM+JDOHbIJOOSMXtTHYqbi3o53YQ
	kAsbsYGiqzf5850K4x5mWHS5Rhhq6qoWZHdKvpK+4zzDHf3k1BXe8Y3tFBnfnmKeyzeGy6
	ep5PtDI9xNBtPQMAHfNwOtgGL0FsQRU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
	seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
	oupton@google.com, reijiw@google.com, rananta@google.com,
	bgardon@google.com, dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v9 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
Message-ID: <20221013140911.izpjfm72ar6nq2vs@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-9-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-9-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221013140911.fNGna5NMxUbcnvKJ8zju6pM1yzyLGfhfTkWJWtY9PqQ@z>

On Tue, Oct 11, 2022 at 01:06:22AM +0000, Ricardo Koller wrote:
> Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
> aarch64 to fix the alignment of parameters in a couple of calls. This will
> make it easier to fix the alignment in a future commit that adds an extra
> parameter (that happens to be very long).
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
>  .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
>  2 files changed, 30 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
