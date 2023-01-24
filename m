Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956188BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 17:17:44 +0000 (UTC)
Date: Tue, 24 Jan 2023 17:17:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674580662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GXyW90IOjnXJvIfMtjFFfhTG4Pl/WIRVVHctvw+l3qI=;
	b=b3syj6I9kUIPksw9zSGRrhxPXAmMEZkQmhx+mXT+MrQl4aIrYCXkgsuSj22vzS/C5c2dJ4
	Zky5SMa1QnMvd5iE8GqhFTc26az6rzVKeq0SARVDo3SkdoTamaRZ/ugvM0qzMqxRPHIFIf
	UYIqetKi0gix/Ay/grdqiC6hRE2jAdY=
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
Subject: Re: [PATCH 6/7] KVM: Allow range-based TLB invalidation from common
 code
Message-ID: <Y9ASsTwZlZDxx5pv@google.com>
References: <20230119173559.2517103-1-dmatlack@google.com>
 <20230119173559.2517103-7-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119173559.2517103-7-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 19, 2023 at 09:35:58AM -0800, David Matlack wrote:
> Make kvm_flush_remote_tlbs_range() visible in common code and create a
> default implementation that just invalidates the whole TLB.
> 
> This paves the way for several future cleanups:
>  - Introduction of range-based TLBI on ARM.

nit: this is definitely a new feature, not a cleanup :)

--
Thanks,
Oliver
