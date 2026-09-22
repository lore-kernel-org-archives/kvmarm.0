Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82597544D48;
	Tue, 22 Sep 2026 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086691; cv=none; b=M01CUOVax8hotZYmPro1wapGGMO51HFwaDClJXM8/swtIK3jwP99TSPBM9BmSXdrtZx/xlELr5KitlpvQPtsXjGCGz9nVdiiSUDVCfxRV9xc7DyqnRr8szj63PW6OAwrJMtV1DZ9LXtLSCoJPqJFNm3v4hK3MBd1xns7h36PJX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086691; c=relaxed/simple;
	bh=rNQEXQsaxDJSKzNBYt0YgJEboocRsjszFp6TuWfcKYQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rhmUqDtlasvYNQW3RvSRVOhZtTj7Kxn76FlqovMsFOXHC232pB6uvGL2eZgCHBRL3ZflmXsY59tvmNwFwJHqqnyzjVihiBX2v2GpmHrpiHwNULds4GddcrYS0bGXETSHa+fmGHqA45BGl+fVQlLT1mQF+uFYeKWxxT0U87D8fGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlCb2Du8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlCb2Du8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A3E1F000FF;
	Tue, 22 Sep 2026 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086689;
	bh=KdouqcGP2aK9amza9KjvVb0/pTilK0YyRjfvlBEitiA=;
	h=From:Subject:Date:To:Cc;
	b=BlCb2Du8PZQBNTSeRGSvWR+5/gkYm0aHN1A9FwF5whorJy4m166ZI9pfS1yQao2QS
	 Vl3TjcLds3vh/gCYUVvBszAvuiYhEpYt8eitWwG8JXHHgfIxRRh/dZhorU2hq3kt5S
	 nfp99fDINtl9dsld6IVGIzZMZSoi6kAv7fXieK9DQTOFP+k8KoLiOD1g9ziYIUofVC
	 Hc2D+QiwoGcBTByUnAXcVPapTGB0sqyrMXERGxHP/8wlKUJzd8VF6JL9yRljlGTO2s
	 UM5J4m3mEqFg4mKzuW9I10eE7sT84pi7W+kQUyIOconrqWPkewW6zCHPEyH8kMon+v
	 1P0pKl8MQTWZw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 00/14] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Date: Tue, 22 Sep 2026 15:17:54 +0100
Message-Id: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NwQ6CMAyA4VchOzuzjcmYJ9/DeGDSwQIM0+GiI
 by7g5gYE45/m36dSQB0EMg5mwlCdMGNPkV+yMi9rXwD1NWpiWCiYCU/0S4OtMKBPhBs9ewnqo2
 RnJui1Kom6WxduNdGXm+pWxemEd/bh8jX6RcTO1jklFEDFkotlWICLh2gh/44YkNWLYqfoLncE
 UQSRGGNVFZJo/I/YVmWD3n4KnfzAAAA
X-Change-ID: 20260815-kvm-arm-prefault-9bb411b6897d
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8027; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rNQEXQsaxDJSKzNBYt0YgJEboocRsjszFp6TuWfcKYQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29YlHi2R8Lbd5fX3TTMPNVyysdf6Hvy9812M+645f7
 u8O7riYjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAFwknOGftnX0t+5zm0LsOtQP
 r3AwlLWpqHpqwvDlkc30+jQJlWlJDH9lK+617ORjSZzxr/+K8JXEvo5ZpwMWvfvTW8y8N1BSVZQ
 HAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

This series implements the KVM stage 2 page table pre-faulting feature for
arm64.

== Foundations ==

1. Providing a generic kvm_arch_vcpu_allow_pre_fault_memory() hook.

This allows arm64 to reject an uninitialised vCPU from being specified on
pre-fault, avoiding loading a vCPU that is not correctly initialised yet.

2. Updating kvm_s2_fault_desc to independently store the exception syndrome
   register (ESR) value, and updating all code paths to use this value
   exclusively.

This is needed so we can later generate a synthetic fault to perform the
pre-faulting - we need to be sure the code doesn't grab an incorrect ESR
from elsewhere.

3. Updating kvm_s2_fault_desc to independently store the kvm_s2_mmu and
   updating all code paths to use this value exclusively.

Similarly this is needed so we can generate a synthetic fault against the
canonical stage 2 MMU (it would make no sense for it to touch nested shadow
page tables) - we need to be sure that the code doesn't grab an incorrect
MMU from elsewhere.

4. Updating the abort paths which consume kvm_s2_fault_desc to also return
   a kvm_s2_fault_result data structure.

To perform pre-faulting the code must know the granule size of what was
just walked. So the abort paths have to tell us what that was.

5. Pass walk flags to kvm_pgtable_get_leaf() to permit walking page tables
   under the MMU read lock.

This is Jack's patch which allows the use of the KVM_PGTABLE_WALK_SHARED
flag to walk page tables under the MMU read lock.

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

Additionally, in pKVM mode, the stage 2 page tables are owned by the
hypervisor rather than the host - the host can neither walk them nor
populate them directly, so it's not clear that the pre-fault mechanism
correctly maps onto pKVM.

== Credits ==

This series is based, with gratitude, on Jack Thomson's series and their
respins (links provided below) as well as the feedback he received.

The series includes Jack's v5 "KVM: arm64: Pass walk flags to
kvm_pgtable_get_leaf()" patch (verbatim bar a one-line rebase fixup) and
two of his test patches (with minor fixups), plus a nested pre-fault test
based on his.

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
v3:
* Rebased on next, fixed up a new caller to kvm_pgtable_get_leaf() to
  account for additional parameter passed.
* Adjusted: cover letter, added [ljs: ...] note to commit msg for 9/14 to
  reflect the fixup.
* Introduced and wired up kvm_arch_vcpu_allow_pre_fault_memory() as a
  separate commit at the start of the series, as per Oliver.
* Updated the pre-fault implementation to disallow uninitialised vCPU on
  pre-fault as per Oliver, and updated cover letter to reflect it.
* Extended pKVM reasoning in cover letter, commit message.

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
https://lore.kernel.org/r/20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org

v1:
https://lore.kernel.org/r/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org

---
Jack Thomson (3):
      KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
      KVM: selftests: Enable pre_fault_memory_test for arm64
      KVM: selftests: Add option for different backing in pre-fault tests

Lorenzo Stoakes (ARM) (11):
      KVM: Allow architectures to disallow pre-fault
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

 Documentation/virt/kvm/api.rst                     |  19 +-
 arch/arm64/include/asm/esr.h                       |  44 +++
 arch/arm64/include/asm/kvm_emulate.h               |  52 +---
 arch/arm64/include/asm/kvm_pgtable.h               |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   2 +-
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/arm.c                               |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  10 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   5 +-
 arch/arm64/kvm/mmu.c                               | 306 +++++++++++++++++----
 arch/arm64/kvm/nested.c                            |   2 +-
 include/linux/kvm_host.h                           |   1 +
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 158 +++++++++++
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 152 ++++++++--
 virt/kvm/kvm_main.c                                |   8 +
 17 files changed, 632 insertions(+), 138 deletions(-)
---
base-commit: 23ddf997ab16b5f4aa9f948f5a68f5b35e4e398f
change-id: 20260815-kvm-arm-prefault-9bb411b6897d

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

