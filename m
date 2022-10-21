Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0D6AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52096C433D7;
	Fri, 21 Oct 2022 23:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393422;
	bh=otDNrZF+/9sPcbGQ5ikh9MD6L0QP/JOLKi7iq3be1Js=;
	h=From:To:Cc:Subject:Date:From;
	b=WDlfDYNVHAB4VqvoRbsR53TUDQT7TcXtndZzY3zc4+9bnWb6hgjOS8mltKqb/yKp6
	 M8LzYNkort7irlClMjJquAT5NfWRiOmvJnwMfrCqdErQzrmzw9YPAm+pkKs2HS6vys
	 PXbeRUBKKMVVfc88YuEfddj24ppu0fv3uwCq3hwFuDIyQTDvDmIm5R0o2LOUMW4dmi
	 WNovCfEJ5KWjgIMOSoCY4PfQ/0rwr1KKYNfKrLZnsNk6KgZiOiJQajjP8JQeNd4GnK
	 wblJBO4GcjoSduP7/IJ6U5daL5dGO1sV5lObK0N8WBzPE7pOBOtQ3ieOSbU1PRKylC
	 fsmeY59tJhebg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 0/8] arm64/sve: Clean up KVM integration and optimise syscalls
Date: Sat, 22 Oct 2022 00:03:13 +0100
Message-Id: <20221021230321.1159287-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5151; i=broonie@kernel.org; h=from:subject; bh=otDNrZF+/9sPcbGQ5ikh9MD6L0QP/JOLKi7iq3be1Js=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyUwoBtGFlKn8G7Q8LEE9/5GcDrBWqjwaCIP9gz6 lqot5zKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlMAAKCRAk1otyXVSH0Pt8B/ oCamP+ujA6iruMB+anz6cCEGp3JtPzf1AJH66zupqUoBEQPfaeQIpPfSA4RaTNnFoxNHi1BW3VS82l 6W3Wa/bPGiUhFtdCdnQavqp4uQSggkMqo7u4k6Uep/rjcKnw63zTSjov5dZXRgwg+3Lyzq++obVdnE uZjY7PI4ZdyR6u8N7QjTr74XRuiriv5iSyTMbUGflcAQNp+gtW0gDlrsyxlMns8QBJ2nX75RMTZ1Ow lJnUbfkN+VVaHNwv/GqBUXUGJAbqxGNFE8Tbwpcs6p8o8izocW3Yn+IzMwgPgmgszjk8E2npHo9Vem jEOEJBtQXav0gkUx1pTir9/32KGNGU
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

This patch series attempts to clarify the tracking of which set of
floating point registers we save on systems supporting SVE, particularly
with reference to KVM, and then uses the results of this clarification
to improve the performance of simple syscalls where we return directly
to userspace in cases where userspace is using SVE.

At present we track which register state is active by using the TIF_SVE
flag for the current task which also controls if userspace is able to
use SVE, this is reasonably straightforward if limiting but for KVM it
gets a bit hairy since we may have guest state loaded in registers. This
results in KVM modifying TIF_SVE for the VMM task while the guest is
running which doesn't entirely help make things easy to follow. To help
make things clearer the series changes things so that in addition to
TIF_SVE we explicitly track both the type of registers that are
currently saved in the task struct and the type of registers that we
should save when we do so. TIF_SVE then solely controls if userspace
can use SVE without trapping, it has no function for KVM guests and we
can remove the code for managing it from KVM.

The refactoring to add the separate tracking is initially done by adding
the new state together with checks that the state corresponds to
expectations when we look at it before subsequent patches make use of
the separated state, the goal being to both split out the more repetitive
bits of tha change and make it easier to debug any problems that might
arise.

With the state tracked separately we then start to optimise the
performance of syscalls when the process is using SVE. Currently every
syscall disables SVE for userspace which means that we need to trap to
EL1 again on the next SVE instruction, flush the SVE registers, and
reenable SVE for EL0, creating overhead for tasks that mix SVE and
syscalls. We build on the above refactoring to eliminate this overhead
for simple syscalls which return directly to userspace by keeping SVE
enabled unless we need to reload the state from memory, meaning that if
syscalls do not block we avoid the overhead of trapping to EL1 again on
next use of SVE.

The series also includes a tangentially related patch which simplifies
the interface to fpsimd_bind_state_to_cpu(), reducing the very large
number of arguments that the function takes. This is already an issue
regardless of this series but is further amplified by the series, if
this approach is OK for people we could potentially build on this to
use the struct in more places. In order to avoid the user visible
improvements getting held up behind code cleanups this patch is placed
last.

v4:
 - Rebase onto v6.1-rc1.
 - Only call fpsimd_kvm_prepare() on systems supporting FPSIMD.
 - Reorder field in kvm_vcpu_arch for pahole.
 - Rename the enum fp_state to fp_type, we still use a single type for
   both the saved state and target state since naming two very similar
   closely related types with their constants clearly and concisely gets
   tricky.
 - Reword a comment in fpsimd_save().
 - Add KVM specific comment about FPSIMD vs SVE states.
 - Further clarifications and expansion in several commit messages and
   comments.
 - Add a patch on the end improving the API for fpsimd_bind_state_to_cpu()
v3:
 - Rebase onto my series "arm64/sme: SME related fixes" since there is a
   direct dependency on the signal fix and testing is much easier with
   the bug fixes rolled in.
 - s/type/fp_type/ in struct fpsimd_last_state_struct.
 - Add comment about the V register storage being ignored when data is
   stored in SVE format.
 - Move dropping of special casing for FPSIMD register state in SME
   into a separate patch later in the series.
 - Simplify logic in task_fpsimd_load().
 - Remove support for leaving the SVE state not shared with FPSIMD
   untouched, keep the unconditional flush.
v2:
 - Rebase onto v5.19-rc3.
 - Don't warn when restoring streaming mode SVE without TIF_SVE.

Mark Brown (8):
  KVM: arm64: Discard any SVE state when entering KVM guests
  arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
  arm64/fpsimd: Have KVM explicitly say which FP registers to save
  arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
  arm64/fpsimd: Load FP state based on recorded data type
  arm64/fpsimd: SME no longer requires SVE register state
  arm64/sve: Leave SVE enabled on syscall if we don't context switch
  arm64/fp: Use a struct to pass data to fpsimd_bind_state_to_cpu()

 arch/arm64/include/asm/fpsimd.h    |  17 ++-
 arch/arm64/include/asm/kvm_host.h  |  12 ++-
 arch/arm64/include/asm/processor.h |   7 ++
 arch/arm64/kernel/fpsimd.c         | 165 ++++++++++++++++++++---------
 arch/arm64/kernel/process.c        |   2 +
 arch/arm64/kernel/ptrace.c         |   5 +-
 arch/arm64/kernel/signal.c         |   7 +-
 arch/arm64/kernel/syscall.c        |  19 +---
 arch/arm64/kvm/fpsimd.c            |  26 +++--
 9 files changed, 180 insertions(+), 80 deletions(-)


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.30.2

