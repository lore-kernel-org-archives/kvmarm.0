Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6561FA930
	for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 18:10:34 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678817432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/e8hGKQr30b5ZvdSDvuiuWs97jzQhjwuRhF+vuhvk8=;
	b=To69XkfxqTbOxl5n49kjumMJ7t3j0izNLm88VXspv8c8B1+4S6tHPjESl9RFvOvz5Jh7DF
	lkTAuaGZs3L9wVaF4ymnTYNduKWZbOGf4ywCvG2CXyclM04KVH2tsFAlgx56LqPoYUMb4+
	OJMdIAmSGztCai6SQVzNcJxb7j0U+ik=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	David Matlack <dmatlack@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org,
	Christoffer Dall <c.dall@virtualopensystems.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Retry fault if vma_lookup() results become invalid
Date: Tue, 14 Mar 2023 18:10:18 +0000
Message-Id: <167881740956.623301.15796552782250010868.b4-ty@linux.dev>
In-Reply-To: <20230313235454.2964067-1-dmatlack@google.com>
References: <20230313235454.2964067-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 13 Mar 2023 16:54:54 -0700, David Matlack wrote:
> Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
> detect if the results of vma_lookup() (e.g. vma_shift) become stale
> before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
> VMA could be changed by userspace after vma_lookup() and before KVM
> reads the mmu_invalidate_seq, causing KVM to install page table entries
> based on a (possibly) no-longer-valid vma_shift.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Retry fault if vma_lookup() results become invalid
      https://git.kernel.org/kvmarm/kvmarm/c/13ec9308a857

--
Best,
Oliver
