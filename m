Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC3136F8F9
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778875158; cv=none; b=bdn3j0AsFCUfpjH33VmM8LIVamMJi2S3odMBA1IPDoK2LNx0b7WZrJu5Y8R/pqWcaeRiBXd6URhMSQITSLD9KZu353raoDSNaolAjFanZWtlS5tSm5lBYc3LFX8Z0/8bujkLOAFm8ydiSmIlrK35XC4WhzjKwiNf35uwfXWVSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778875158; c=relaxed/simple;
	bh=QcLi9nOXGdtsBW9OJfP749hIUAI4GeEa0oT0K7mFMZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ak9qoCLN6ej2QVNkSqNx7Hu0Guo6AhG2s7rMSMCyD8CKZy4eyn6F+qtB76p4F4XeOG2tns3hGZjUy0xh0YGj5XRHvNzZFBnN+ES7MlpJs7HT8C6lYinybmF5h/orZ8CaxtvEhItVctm6vqhiaHnDtmsnwW7A52tWCxwZUKsPGBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lQ+zvmr2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lQ+zvmr2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7D3C1BF7;
	Fri, 15 May 2026 12:59:09 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00CEB3F85F;
	Fri, 15 May 2026 12:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778875154; bh=QcLi9nOXGdtsBW9OJfP749hIUAI4GeEa0oT0K7mFMZA=;
	h=From:To:Cc:Subject:Date:From;
	b=lQ+zvmr22w6KmGzdHqs9ITHCZKbFHbxFFNE8X+yyyhTFOhwHpxgCe6Q/+BsLcfMK0
	 jln7sf+/ssx8j7SC2l2hwzC8zZ98+rl2cR6l7THK6RMNo9dTSp9R35z2JWemn0wWP6
	 IGips3ebbW4FHZPtci4vjAfTCmppZZWy47+blKV8=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Optimize S2 page splitting
Date: Fri, 15 May 2026 20:59:01 +0100
Message-ID: <20260515195904.2466381-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2955; i=leo.bras@arm.com; h=from:subject; bh=QcLi9nOXGdtsBW9OJfP749hIUAI4GeEa0oT0K7mFMZA=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLYq1lEZh1Z7DdJ3q3C69CLVoWtTt4xyjo18jLbOo982 j1jRtK5jlIWBjEuBlkxRRbZR/NX8XyfknHkyo8FMHNYmUCGMHBxCsBErjAyMvTPXLCP4Yqt5YJA KbvtWYK/D/2bIRbCYsB7hztb9NL/6Q6MDM3/hJz/C0m7BPHxf5+6fu/fNwHWx71Ffum7yTebGvi K8gIA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

While playing with dirty-bit tracking, I decided to take a look on how page
splitting works. Found out all entries are walked, even though we can infer,
for instance that:
- If a level-3 entry is walked, it means the parent level-2 entry is split
- If a split just succeeded in an table entry, it means all children nodes
  are already split

So I tried to optimize it in a way that it does not break other users.

My main idea is to introduce positive return values that hint to the
pagetable walking mechanism that either siblings or children can be 
skipped. That should be contained to the visitor function, that returns
zero if no error was detected.

Numbers on above optimization are promising:
A 1GB VM, running on the model, splitting all at the beginning 
(no manual protect):
- Memory was already split (4k pages): 	-97.33% runtime (-172ms) - 20 runs
- THP backed memory: 			-19.82% runtime (-153ms) - 10 runs
- 1x1GB hugetlb memory:			-20.65% runtime (-150ms) - 10 runs

This is measured with this snippet[1].
I ran at least 10 times on different 1GB VMs, to make sure the numbers are 
consistent.

Ideas I considered:
- Using a negative return value, using kvm_pgtable_walk_continue to 
  filter it as a non-error, but decided that is kind of counter-intuitive
- Using the introduced return values to hint the split walker to not 
  splitting level-2 blocks (or level-1), if by adding a new parameter in
  kvm_pgtable_stage2_split() and carrying it over to the walker using 
  ctx->arg. (Splitting only up to given hugepage size)
- Looking at other walkers, and trying to think on scenarios to
  optimize them using the new return values.

Do you think it is worth doing this?
Please provide feedback!

Thanks!
Leo


[1]:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..6424e833b7be 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1272,22 +1273,26 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
        phys_addr_t start, end;
 
        lockdep_assert_held(&kvm->slots_lock);
 
        slots = kvm_memslots(kvm);
        memslot = id_to_memslot(slots, slot);
 
        start = memslot->base_gfn << PAGE_SHIFT;
        end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
+
        write_lock(&kvm->mmu_lock);
+       u64 sw = ktime_get_real_ns();
        kvm_mmu_split_huge_pages(kvm, start, end);
+       sw = ktime_get_real_ns() - sw;
+       printk("split from %llx to %llx took %llu ns\n", start, end, sw);
        write_unlock(&kvm->mmu_lock);
 }
 

Leonardo Bras (2):
  KVM: arm64: Introduce S2 walker SKIP return options
  KVM: arm64: Improve splitting performance by using SKIP return values

 arch/arm64/kvm/hyp/pgtable.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0

