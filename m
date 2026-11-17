Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794901479;
	b=Lm59HvgDt4eZrmu0mU8gt9YQafgWUrpQIHo2mtsRlsr8TVf6CHcIkt20VQz89yhFFpe5
	 wtBeNd729Bz9PWZvo61/6ZSklxzv3+HLAX855LchBc3yCUQCFN7+HV06jwCSuuEObfx74
	 8sgJRKVoyfmLvx0AA6TZ6RlrlYGf7IXPUWiMstqtDivmiMiZPFJRDtbkgRBA/iN+ATPxO
	 plmcUI4A/d2/VN+4Va/yB9yVysXkUCjBhJixjN4j9vgnBI7MMfhFWDSTvnJk4XA+9enBr
	 RhXbIZyUmMtrspIvV6eDciT57jqAxxQz9BLoRzq65yqaGzv3U6HRBdEWy5LTLNb1qSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794901479;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Rl4xRoRlviJF83L8a++G0tQD5YC9ot3wz0cKjEEe7IY=;
	b=fF0v/M3TufErAmoJpT3L/dsjk0dAQcxjGTg2OnFMxEG3bj5YSaRc6NImcfnMGaQsYhaC
	 +DtgFHLW0MtsotpKTC/h1jPjojex2VhBDExrr+LpkJZRAa2eKgr1zKcVG6HrdqTPiJRDV
	 7qfuM4GLtA/ecoSxhF8qnr/5HJierRfWSx4ycZpT/lcmjPmRgARsGzaE0aLhUFpevQT4Z
	 OBfL5hyE+2OZpKRx8Sd72TleqJ3Wy3MU8G+Kl43tMZv9lo8+HJFwAJNXpgYy1lNPC49Ci
	 Txu/plxSblWeBRGu42DAKwypXPARbc5IoDqjk07TbWLpDIuI6OQCrXOKc5A4po9jpLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ri9HY3+5;
	arc=none smtp.remote-ip=95.215.58.162
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56346606A33E
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 07:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56346606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ri9HY3+5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9BrR57hqg/zFL8xuQddS4bc5O1Q7cExjeJpeA9SlXoQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794901476; v=1; x=1795506276;
 b=ri9HY3+5c4WUbrUk9G9uH2UiphPaqM8sZFV47rQp55xCD3GfWb9Ek1RVxGLmIigeGG5fJ7jB
 nKudNa5RrRiq3G9P4/fuLsbtgXet6c6nD1eV9QgRd8D9DUi4GXxbTH1V2QpwHsvUYBPAHQE45CZ
 xJr5IE5Y9zFPCMltgMZzItd8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 89916f160498b322;
	Tue, 17 Nov 2026 07:44:36 +0000
X-Mizu-Trace-ID: 89916f160498b322
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty ring is full
Date: Tue, 17 Nov 2026 07:44:27 +0000
Message-ID: <20261117074428.7544-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117074428.7544-1-fuad.tabba@linux.dev>
References: <20261117074428.7544-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pre-faulting can map a dirty-logged page writable, which pushes it to
the vCPU's dirty ring. KVM_RUN exits with KVM_EXIT_DIRTY_RING_FULL
before the ring overflows, but the pre-fault loop never checks it, so
one call can push more entries than the ring has free, which trips the
WARN in kvm_dirty_ring_push() and overwrites entries userspace hasn't
harvested. On x86:

  WARNING: arch/x86/kvm/../../../virt/kvm/dirty_ring.c:225 at kvm_dirty_ring_push+0x7a/0xd0
  Call Trace:
   make_spte+0x2cc/0x450
   kvm_tdp_mmu_map+0x5e1/0x7f0
   kvm_tdp_page_fault+0x12c/0x1b0
   kvm_mmu_do_page_fault+0x181/0x250
   kvm_arch_vcpu_pre_fault_memory+0x136/0x1d0
   kvm_vcpu_pre_fault_memory+0xcf/0x180
   kvm_vcpu_ioctl+0x455/0x770

Stop the loop once the ring is soft full, with the check KVM_RUN makes
before entering the guest. Return the pages already processed, or
-ENOSPC when there aren't any, since a retry can't succeed until
userspace harvests and resets the ring. s390 has the ioctl but no ring,
so give kvm_dirty_ring_check_request() a stub.

The check also sets run->exit_reason, and arm64's KVM_RUN completes a
pending MMIO exit only if exit_reason is still KVM_EXIT_MMIO. If a
pre-fault stops on a full ring while an MMIO exit is pending, the next
KVM_RUN doesn't complete the exit and the guest repeats the MMIO
access. Userspace can avoid that by completing the exit with KVM_RUN
before it pre-faults.

Fixes: bc1a5cd002116 ("KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate guest memory")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst | 9 +++++++--
 include/linux/kvm_dirty_ring.h | 5 +++++
 virt/kvm/kvm_main.c            | 5 +++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e95c9cda085d9..89eb6be9bc6e3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6544,6 +6544,7 @@ Errors:
   ENOENT     The specified `gpa` is outside defined memslots.
   ENOEXEC    The vCPU has not been initialised (arm64).
   EINTR      An unmasked signal is pending and no page was processed.
+  ENOSPC     The vCPU's dirty ring is full and no page was processed.
   EFAULT     The parameter address was invalid.
   EHWPOISON  A poisoned host page was encountered.
   EOPNOTSUPP Mapping memory for a GPA is unsupported by the
@@ -6588,7 +6589,9 @@ case, the ioctl can be called in parallel.
 
 When the ioctl returns, the input values are updated to point to the
 remaining range.  If `size` > 0 on return, the caller can just issue
-the ioctl again with the same `struct kvm_map_memory` argument.
+the ioctl again with the same `struct kvm_pre_fault_memory` argument.
+If that fails with ENOSPC, the vCPU's dirty ring has to be harvested
+and reset first.
 
 On x86, shadow page tables cannot support this ioctl because they
 are indexed by virtual address or nested guest physical address.
@@ -8957,7 +8960,9 @@ Therefore, the ioctl must be called *before* reading the content of
 the dirty pages.
 
 The dirty ring can get full.  When it happens, the KVM_RUN of the
-vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL.
+vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL, and
+KVM_PRE_FAULT_MEMORY on the vcpu will process no more pages until the
+ring has been harvested and reset.
 
 The dirty ring interface has a major difference comparing to the
 KVM_GET_DIRTY_LOG interface in that, when reading the dirty ring from
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index eb10d87adf7d5..729615ae0cf4d 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -60,6 +60,11 @@ static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
 {
 }
 
+static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring,
 						   u32 offset)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf4cb586f1407..ac8b94a386e4a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4461,6 +4461,11 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 			break;
 		}
 
+		if (kvm_dirty_ring_check_request(vcpu)) {
+			r = -ENOSPC;
+			break;
+		}
+
 		r = kvm_arch_vcpu_pre_fault_memory(vcpu, range);
 		if (WARN_ON_ONCE(r == 0 || r == -EIO))
 			break;
-- 
2.47.3

