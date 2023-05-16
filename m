Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F17B107A5
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 18:21:36 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684261294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DJIiUAqU0U9NkUHObypH6C3V+XIHAJcOTcw9BCe8MYk=;
	b=AHw2Mna4in3bpSeHQGOK9UcQF7Ic+VOu0Nw7bkq0HabAiT/rFsZvYkaBF9XhXdwjtPdiEu
	xzV+Y8j5JXJy5OlcaxwNvfBIe6HGtPlxoA/p8W4zkVXNH0ExAe24SB++k+sjde6N7MeG5d
	5286z7RvdDWfEjRAURN6C9kZ3JqLsJs=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	pbonzini@redhat.com,
	maz@kernel.org,
	yuzenghui@huawei.com,
	dmatlack@google.com
Cc: gshan@redhat.com,
	ricarkol@gmail.com,
	kvmarm@lists.linux.dev,
	qperret@google.com,
	suzuki.poulose@arm.com,
	bgardon@google.com,
	andrew.jones@linux.dev,
	rananta@google.com,
	catalin.marinas@arm.com,
	kvm@vger.kernel.org,
	reijiw@google.com,
	seanjc@google.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: Re: [PATCH v8 00/12] Implement Eager Page Splitting for ARM
Date: Tue, 16 May 2023 18:21:09 +0000
Message-ID: <168426111477.3193133.10748106199843780930.b4-ty@linux.dev>
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
References: <20230426172330.1439644-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 26 Apr 2023 17:23:18 +0000, Ricardo Koller wrote:
> Eager Page Splitting improves the performance of dirty-logging (used
> in live migrations) when guest memory is backed by huge-pages.  It's
> an optimization used in Google Cloud since 2016 on x86, and for the
> last couple of months on ARM.
> 
> Background and motivation
> =========================
> Dirty logging is typically used for live-migration iterative copying.
> KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
> to 4K pages from now on).  It does it by faulting on write-protected
> 4K pages.  Therefore, enabling dirty-logging on a huge-page requires
> breaking it into 4K pages in the first place.  KVM does this breaking
> on fault, and because it's in the critical path it only maps the 4K
> page that faulted; every other 4K page is left unmapped.  This is not
> great for performance on ARM for a couple of reasons:
> 
> [...]

Picking these patches up early, as I'd like to get some mileage on the
patches well in advance of 6.5.

Applied to kvmarm/next, thanks!

[01/12] KVM: arm64: Rename free_removed to free_unlinked
        https://git.kernel.org/kvmarm/kvmarm/c/c14d08c5adb2
[02/12] KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping CMOs and BBM TLBIs
        https://git.kernel.org/kvmarm/kvmarm/c/02f10845f435
[03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
        https://git.kernel.org/kvmarm/kvmarm/c/e7c05540c694
[04/12] KVM: arm64: Export kvm_are_all_memslots_empty()
        https://git.kernel.org/kvmarm/kvmarm/c/26f457142d7e
[05/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
        https://git.kernel.org/kvmarm/kvmarm/c/2f440b72e852
[06/12] KVM: arm64: Add kvm_pgtable_stage2_split()
        https://git.kernel.org/kvmarm/kvmarm/c/8f5a3eb7513f
[07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
        https://git.kernel.org/kvmarm/kvmarm/c/6bd92b9d8b02
[08/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
        https://git.kernel.org/kvmarm/kvmarm/c/ce2b60223800
[09/12] KVM: arm64: Split huge pages when dirty logging is enabled
        https://git.kernel.org/kvmarm/kvmarm/c/e7bf7a490c68
[10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
        https://git.kernel.org/kvmarm/kvmarm/c/3005f6f29447
[11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
        https://git.kernel.org/kvmarm/kvmarm/c/6acf51666d03
[12/12] KVM: arm64: Use local TLBI on permission relaxation
        https://git.kernel.org/kvmarm/kvmarm/c/a12ab1378a88

--
Best,
Oliver
