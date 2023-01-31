Received: from out-74.mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB57A922
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:14:53 +0000 (UTC)
Date: Tue, 31 Jan 2023 18:05:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675188357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h53EfclF6xTMn55rYCYLJq2rEuaWHMBV+S/ooTaHdfw=;
	b=Pu4XWE6VT6VyVYPR/b8rZm1XPTPWiODoFlp6iD6k7q/fSRYQIWn8sQIZcuJOM9+8mvUjA0
	tY6tE2HyMyNYhK/WftJyCxoqv/VXWEP74cSb6P5dHmPBw7GHJPgfeYR/xMiowx0YtmZ+c/
	n/sBYT5JqeMZjNibizy9+P7DJWZVDPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
Message-ID: <Y9lYd1ONY06BEnBk@google.com>
References: <20230126184025.2294823-1-dmatlack@google.com>
 <20230126184025.2294823-3-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126184025.2294823-3-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 26, 2023 at 10:40:20AM -0800, David Matlack wrote:
> Use kvm_arch_flush_remote_tlbs() instead of
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> problem, allowing architecture-specific code to provide a non-IPI
> implementation of remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
> two mechanisms.
> 
> Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
