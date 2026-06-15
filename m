Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54414071C0
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538820; cv=none; b=EM7yqGAxxnB5qksn6Jj2KCSlrQHD7DIVhFxumwwhP+evBgcn+Kdqlo/s8ORAsZP41VpCFCFaGTg4RQzxZ5AkGqBdpavaWNH9csUQswjweNVEWc/ZefJGlMYzMFh8EpUGg6zzXISD2B5RczB3HBe5cCQbOTWIBTLY2V7OVY2IOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538820; c=relaxed/simple;
	bh=cc2Jw+bSMrXT1kH7gubW713jYpPmyCTcIGhtT+kL3L8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=J+x9/yJVF5pj4DF7Hd1pESTNuYQaqWQUliRvwD4pmGTMGDPvUzcTJykW8NxRQ/ua16LHlvNrojWvVc61Jctxi34071Ry1krN7BRX/9hjcdQ9yVJVFfN9Aml62RhFmHtAk8v09tiWvdEMF6X5payhXPqS31KqCfkFJ50YfuoIA9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AF4BUiUI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AF4BUiUI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47D0124E9;
	Mon, 15 Jun 2026 08:53:32 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AFB03FA1F;
	Mon, 15 Jun 2026 08:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781538817; bh=cc2Jw+bSMrXT1kH7gubW713jYpPmyCTcIGhtT+kL3L8=;
	h=From:To:Subject:Date:From;
	b=AF4BUiUImutl/tiXAlq1UadNlcJhq3hXaUKmgrMOdQYwkSUE6OlZdfO4ZHqAs2T4h
	 irDufS+TEbgfJGLLle+mrUWlKdFcefHZt/jCl1ixcpdkgWhizHyeMYEBqhITnS1mEI
	 fbsL5/Q2eH1fyrM7zWu6Yc/LKBTGulWvQ4JvWfe0=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	seanjc@google.com,
	david.hildenbrand@arm.com,
	mark.rutland@arm.com
Subject: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
Date: Mon, 15 Jun 2026 16:52:44 +0100
Message-ID: <20260615155244.183044-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
memory provider for the virtual machine is the guest_memfd file, not the
userspace mapping. Faults are resolved using the guest_memfd page cache,
and the permissions for the secondary MMU mapping depends exclusively on
the memslot (i.e, if the memslot is read-only). How userspace happens to
have the memory mmaped at fault time, or even if the memory is mapped at
all into userspace, is not taken into consideration.

guest_memfd memory is not evictable, is not movable and there's no backing
storage. Once memory is allocated for an offset in guest_memfd file, the
offset will not change, and that memory is not freed unless userspace
explicitly punches a hole in the file. As a result, memory reclaim, page
migration, page aging and dirty page tracking for the userspace mapping
serve little purpose.

Despite this, KVM's MMU notifiers still modify the secondary MMU page
tables, similar to ordinary memslots, only for the same memory to be
remapped next time a guest accesses it. Make the disconnect between the
user mapping and the secondary MMU page tables explicit by ignoring the MMU
notifiers for guest_memfd-only memslots.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
The only theoretical instance where the MMU notifiers are invoked for the
userspace mapping of a guest_memfd-only memslot that I was able to find was
automatic NUMA balancing with a non-NULL NUMA policy for the guest_memfd
file. I wasn't able to test it in practice. Also my knowledge of MM is very
limited, so there might be other cases where it happens, or I might be
wrong and today the MMU notifiers are never invoked.

Either way, when and if it happens, having memory unmapped from the
seconday MMU in the case of guest_memfd-only memslot is at most a
performance issue (it causes unnecessary guest faults), but I wanted to
start a conversation about this because having memory that stays mapped at
stage 2 (unless userspace explicitly unmaps it from the VM) is needed for a
Arm feature (called SPE, Statistical Profiling Extension) that I'm working
to upstream. This patch aims to provide the guarantee that memory won't be
unmapped from the secondary MMU behind the VMMs back, which is what happens
for non guest_memfd memslots.

 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 881f92d7a469..8c4158996928 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			unsigned long hva_start, hva_end;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
+
+			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
+				continue;
+
 			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
 			hva_end = min_t(unsigned long, range->end,
 					slot->userspace_addr + (slot->npages << PAGE_SHIFT));

base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.54.0

