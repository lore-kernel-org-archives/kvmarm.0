Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D1C3A1C9;
	Tue, 25 Aug 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673674; cv=none; b=I1nCyaNfSFVqczc+wlyrv8XacZrmTay2PfDnSm6pHcHBnlabhaV8YVe0hEkUmWc1j3/7K9LGb2aXLzho+SZhop64QLHq6f8s+gUda4i+/0ZeClSzvAJeepOgX4bao94dVjdKabBxe08frnyzeEWrQPy2ml92hSpJnDUYdoJZ7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673674; c=relaxed/simple;
	bh=shQu2ja8FKYpxwmft95PQDnR4lutE8cOna4MUXeJkaA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=t6s738wO3q0xXWz2/+km2yNlJv8ELbyJV/86SVFB6J+FjCJ0DzyVt+brGAuW0DeV0aDG5i9iyGAmYPQs4VAHpcc9JGZg+BorJbi0aU68fmwWtkgacwPj2LHk1uNKLyCiCZlesJTGLulnExGA16uamusQ1Ek46G1rhW5EzsGxJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ar2uwwun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ar2uwwun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5681F000E9;
	Tue, 25 Aug 2026 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673673;
	bh=0UWZ5amjuDuz5NxB+UBQVKLusjTJjNvSXdFmO8uoJLU=;
	h=From:Subject:Date:To:Cc;
	b=Ar2uwwun9E+GAnctXWPBo12NcRgbRk8j7SLZV8gbV1A3osQAyzyUx4CPw/tOz/kPp
	 XEXxZ4DgeolskSEIGxUXXSP8OkioSdv3k4urTIPJsg59Vna8moQ/DmcAcq22P6ALH1
	 KyA5ngiOVDGxFU6oybyDKr74CTlBbS7fsl0bThU0iogWxKi42cHP02vWV0QsTwXb6X
	 5TEIf6o6guYYaPPpSt30Ep96YTrqC57eBz7n4bIB7D4u2p8qdzlmIVTinMoSZ0mXxu
	 pY97bxnxk5iczGyJPPLO2T1NMv/pGx5UYLv/HVpnMdFj0q7ZzSLBC+q6TtjG3c0dBW
	 DGx77mzSKlyYw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/8] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Date: Tue, 25 Aug 2026 17:00:34 +0100
Message-Id: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDC0NT3eyyXN3EolzdgqLUtMTSnBJdy6QkE0PDJDMLS/MUJaA2kERmBdj
 I6NjaWgB0ns9XYgAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=shQu2ja8FKYpxwmft95PQDnR4lutE8cOna4MUXeJkaA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ69zgpbqu+wXsyfM3+Pc//BZRP4Cm8mpD614CD7UqQZ
 u+nDgnfjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEn5fhr4DtqQdGhxvvP3QR
 2MYn/Dtv1t6g6QIb81smzJjoLfGX0ZKR4YGBQYXBhTUqu1RXv7r2oPr9grcsFpPrw273vjvVtdV
 5CQcA
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

Jack's original test suite is also included in the series.

== Credits ==

This series is based, with gratitude, on Jack Thomson's series and their
respins (links provided below) as well as the feedback he received.

The series includes Jack's v5 "KVM: arm64: Pass walk flags to
kvm_pgtable_get_leaf()" patch verbatim, and all three of his test patches,
two of which required minor fixups.

Link: https://patch.msgid.link/20260612162354.73378-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20260113152643.18858-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20251119154910.97716-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20251013151502.6679-1-jackabt.amazon@gmail.com/
Link: https://patch.msgid.link/20250911134648.58945-1-jackabt.amazon@gmail.com/

== Reviewer Notes ==

I synced with maintainers on this who asked me to take a look, as there hadn't
been progress on the series for some time.

Am happy to rebase again after -rc1.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Jack Thomson (4):
      KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
      KVM: selftests: Enable pre_fault_memory_test for arm64
      KVM: selftests: Add option for different backing in pre-fault tests
      KVM: selftests: Add nested pre-fault test for arm64

Lorenzo Stoakes (ARM) (4):
      KVM: arm64: Propagate and use esr in s2fd when handling guest aborts
      KVM: arm64: Propagate and use mmu in s2fd when handling guest aborts
      KVM: arm64: Propagate and use kvm_s2_fault_result on S2 fault
      KVM: arm64: Implement KVM_PRE_FAULT_MEMORY

 Documentation/virt/kvm/api.rst                     |  17 +-
 arch/arm64/include/asm/esr.h                       | 129 +++++---
 arch/arm64/include/asm/kvm_emulate.h               |  52 +---
 arch/arm64/include/asm/kvm_pgtable.h               |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   2 +-
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/arm.c                               |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   5 +-
 arch/arm64/kvm/mmu.c                               | 324 +++++++++++++++++----
 arch/arm64/kvm/nested.c                            |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 206 +++++++++++++
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 152 ++++++++--
 14 files changed, 736 insertions(+), 172 deletions(-)
---
base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
change-id: 20260815-kvm-arm-prefault-9bb411b6897d

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

