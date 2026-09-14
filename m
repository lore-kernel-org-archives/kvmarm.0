Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247E39EF12;
	Mon, 14 Sep 2026 12:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388798; cv=none; b=G0crNDBkRhWXVeaMcIIchLpoM4NMck3xpoLFAMOIX0qkleqO6YnRrnYYevj1AGXZSMJVaKAKnvTQPaFUrieXqLNxfqWPSn9wuXvmUyynTcByHsIvS+7j5s77IC1unwl71gCwuTO2TFkQNjj1LfdWgbQuhn7SdbObsR4/DGXGw94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388798; c=relaxed/simple;
	bh=78T28CfC11xHjAOl1sq7P1//hmjKZwVVx3B8uhlN6B0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=c03Podr4zC92BdhoIxxSr/wCaCsR/FhRQFggVwfDjuI9jWxumtaubsXl1eUdfDTkJN7UBTBVnRU8k0svH4vdwq4F6h21nPO4FISAiasGv1pgQ2x6vsKmfl43BA+HUJpmDux9C4PvkriTex9AJ9CP80O7p0gfkPAd6zdXcLAfDrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d93HJtdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d93HJtdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA711F000FF;
	Mon, 14 Sep 2026 12:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388796;
	bh=9cesBeWPjuV+79g9ggA9zyeW1Rrm2zGZzQyniKaIpEY=;
	h=From:Subject:Date:To:Cc;
	b=d93HJtdoydPWf6reyNoURC5DkuZ8G5KiwzBay4+9gTUwvF+pR2rj3EFS3bIBZBN7g
	 FxGmKbFYOhBHFiedgw7OPsYtD+GOJfvjNJHmJAVyOIQxlRNyk+CACHaL0I7ggH92RH
	 ORyAwk0wZoJkibOcWkc8f+YyAefPdTWukjsnc+zAzSegQ/x3hKgxONyN6La5ZAUu6W
	 QLH9XorGlUHYaISc0QmAHvRkZAMwHbmhjGXuiSgXysKTPxGdX0ES43OLO+HLaqLUeC
	 8MuHkkj8krkIIz/KkVoOKD7p3yBdg1OqmgkheUOs45Dm15FCJm+2pfgOAwJe340Iyq
	 LXzMLSdGKhEWg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/13] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Date: Mon, 14 Sep 2026 13:26:11 +0100
Message-Id: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NzQ6CMBCEX4Xs2TVtgxQ8+R6GQysLNPzUbLHRE
 N7dQjx6/GYy36wQiB0FuGYrMEUXnJ8TqFMGj97MHaFrEoMSqhClvOAQJzQ84ZOpNa9xwcraXEp
 blJVuIM32wr0P5b1O3LuweP4cD1Hu6U+m/siiRIGWWiqrXGuh6DYQzzSePXdQb9v2BT35Q8WxA
 AAA
X-Change-ID: 20260815-kvm-arm-prefault-9bb411b6897d
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6729; i=ljs@kernel.org;
 h=from:subject:message-id; bh=78T28CfC11xHjAOl1sq7P1//hmjKZwVVx3B8uhlN6B0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/8SfiQn4Crfqp5Tunp7OFssbAJj73/3V3whUM4qv
 Xx5vWRoRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaiVcPwz9x2H/vT1fx6AuIT
 0xa8ePFEr+LejULHuo4FDpoJ0+yy9zH8lWzd+KFJau406x87pi4p6JrxQNYrckEa7/P1SRM0JiS
 XcgEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

This series implements the KVM stage 2 page table pre-faulting feature for
arm64.

== Foundations ==

The series begins by establishing required foundations:

1. Updating kvm_s2_fault_desc to independently store the exception syndrome
   register (ESR) value, and updating all code paths to use this value
   exclusively.

This is needed so we can later generate a synthetic fault to perform the
pre-faulting - we need to be sure the code doesn't grab an incorrect ESR
from elsewhere.

2. Updating kvm_s2_fault_desc to independently store the kvm_s2_mmu and
   updating all code paths to use this value exclusively.

Similarly this is needed so we can generate a synthetic fault against the
canonical stage 2 MMU (it would make no sense for it to touch nested shadow
page tables) - we need to be sure that the code doesn't grab an incorrect
MMU from elsewhere.

3. Updating the abort paths which consume kvm_s2_fault_desc to also return
   a kvm_s2_fault_result data structure.

To perform pre-faulting the code must know the granule size of what was
just walked. So the abort paths have to tell us what that was.

4. Pass walk flags to kvm_pgtable_get_leaf() to permit walking page tables
   under the MMU read lock.

This is Jack's patch, verbatim, which allows the use of the
KVM_PGTABLE_WALK_SHARED flag to walk page tables under the MMU read lock.

Pre-faulting requires it to be able to work in parallel as specified by the
API. The read lock precludes page tables being torn down behind our back.

== Implementation ==

Pre-faulting is implemented in kvm_arch_vcpu_pre_fault_memory() whose job
is to pre-fault the stage 2 page tables which map a specific GPA (which,
for arm64, is the guest's IPA).

This function is called by kvm_vcpu_pre_fault_memory() for each GPA in the
range, which itself is ultimately invoked by userland via the
KVM_PRE_FAULT_MEMORY ioctl.

The implementation is simple - try to walk to the stage 2 page table
mapping the GPA - if unmapped, fault it in through a synthetic page fault.

pKVM is not supported regardless of whether the VM is protected or
not.

This is because pKVM instantiates vCPUs upon run, but pre-faulting is
typically performed before a vCPU is run. It would be confusing and
inconsistent to error out on non-running vCPUs but to pre-fault running
ones.

== Credits ==

This series is based, with gratitude, on Jack Thomson's series and their
respins (links provided below) as well as the feedback he received.

The series includes Jack's v5 "KVM: arm64: Pass walk flags to
kvm_pgtable_get_leaf()" patch verbatim and two of his test patches (with
minor fixups), plus a nested pre-fault test based on his.

Link: https://patch.msgid.link/20260612162354.73378-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20260113152643.18858-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20251119154910.97716-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20251013151502.6679-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20250911134648.58945-1-jackabt.amazon@gmail.com/

== Reviewer Notes ==

I synced with maintainers on this who asked me to take a look, as there hadn't
been progress on the series for some time.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Split series - Added 1/13 for the esr.h helpers, 2/13 for converting
  callers to use them, and move what was 1/8 to 3/13 to propagate
  s2fd->esr, as per Marc.
* Made esr helpers __always_inline as per Marc.
* Renamed esr_trap_get_class() -> esr_get_ec() + dropped churn as per Marc.
* Updated 5/13 (was 3/8) to drop the kvm_s2_fault_result.mapped flag.
* Also updated 5/13 so abort handlers return -EAGAIN instead of swallowing, as
  per Marc.
* Split implementation patch further -> topup_mmu_memcache() change to 6/13,
  EHWPOISON change -> 7/13 and docs change -> 10/13, as per Marc.
* No longer mkyoung existing walked ranges, updated docs to reflect, as per
  Marc.
* Eliminated s2fd->pre_fault as per Marc.
* Eliminated the redundant page table level in pre_fault_s2() as per Marc.
* Put the commit message for 9/13 on a diet as per Marc.
* Fixed up commit message for 11/13 (was 6/8) to correct reasoning about
  exit-reason assert, as per Fuad.
* Simplified: nested test 13/13 (was 8/8), dropping the empty nested-S2
  setup and using test_supports_el2() to handle NV=0 opt-out, as per
  Wei-Lin and Fuad.
* Re-authored patch 13/13 to me as the changes are substantial enough to
  require it. Updated commit message to give Jack credit for original.

v1:
https://lore.kernel.org/r/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org

---
Jack Thomson (3):
      KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
      KVM: selftests: Enable pre_fault_memory_test for arm64
      KVM: selftests: Add option for different backing in pre-fault tests

Lorenzo Stoakes (ARM) (10):
      arm64: Add ESR fault helpers
      KVM: arm64: Use ESR helpers in guest abort handling
      KVM: arm64: Propagate and use esr in s2fd when handling guest aborts
      KVM: arm64: Propagate and use mmu in s2fd when handling guest aborts
      KVM: arm64: Propagate and use kvm_s2_fault_result on S2 fault
      KVM: arm64: Size the stage-2 memcache from the fault MMU
      KVM: arm64: Propagate EHWPOISON in kvm_s2_fault_pin_pfn()
      KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
      Documentation: KVM: document arm64 KVM_PRE_FAULT_MEMORY
      KVM: selftests: Add nested pre-fault test for arm64

 Documentation/virt/kvm/api.rst                     |  18 +-
 arch/arm64/include/asm/esr.h                       |  44 +++
 arch/arm64/include/asm/kvm_emulate.h               |  52 ++--
 arch/arm64/include/asm/kvm_pgtable.h               |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   2 +-
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/arm.c                               |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   5 +-
 arch/arm64/kvm/mmu.c                               | 300 +++++++++++++++++----
 arch/arm64/kvm/nested.c                            |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 158 +++++++++++
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 152 +++++++++--
 14 files changed, 615 insertions(+), 137 deletions(-)
---
base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
change-id: 20260815-kvm-arm-prefault-9bb411b6897d

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

