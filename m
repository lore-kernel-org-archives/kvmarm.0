Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C0F51CF46;
	Wed, 30 Sep 2026 21:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804935; cv=none; b=AD1QtKbIQ3HGyUGrJiUZqhvm7pbwjQHZI04Cf0vbo4Ldcd2i0dSrr+rq3u/yU94dTFBuFKlE5f4dnC48mNNCFMOVugpq2pIuBa5Msvt0pU2HveYUoFaYsJ6Qbaz57EM2nxBg6/aYKGaAFRdqFtEa1jZLT1way2Iwrm2YcBpGaXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804935; c=relaxed/simple;
	bh=v+tDIe2bYsLeFuxQFNRoHsarF1iqezQy1Lpm3BSHqxk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SmE98b900AiImQdsnYzlH++Jrai+HNtCIRsm5YmcYyBA4gLaKi2swo7yUAwlK6D2/3j8EVHyhpeOSZq1GPaN8Qseb2mcL5O1xojzwjlehTfgK9zRLonoLac6odkZgppXayRmtHuaBA4VV10CnNdsBCZRYev+3tTVxgdfbzILAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcLMukfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcLMukfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C71F00898;
	Wed, 30 Sep 2026 21:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804933;
	bh=bFy3jTIJd0CBUdXyZYoM8DX2iCT9pxoBv6EcSa0Ixd8=;
	h=From:Subject:Date:To:Cc;
	b=PcLMukfHRQaVJaWDLFBq+edP2aE+4+KzWQhIguSqkypvzPj8+SyBedZiYcEoMyGcz
	 t+8lRRVDFjteUni1aWozFjBEvpcMkurS4oEhDY6EDVVP8yTzkVkj+YTg9QgDz36cvB
	 EBns7khkqi3w7AFmBW1QYOsYKGVx01QLI8zK2nqzsnYvM2tCMoONvkLB1Fbjp3l9gk
	 LFOa+lpkPgzzfRlOtiqlS/LxXiNxaCgBo9NkZftl/UJ7aHKJ/uT8mr7uwIeAS8Stf2
	 PtsggXuMXm0+BmpHQdzKLcf5wHpncFee3gCMJ3jreIcoGcjaLznADGkdpCD8fiqnMi
	 5xwXONvhQOC6Q==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v21 00/15] KVM: arm64: Provide guest support for GCS
Date: Wed, 30 Sep 2026 22:48:10 +0100
Message-Id: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJuDvWoC/23US27bMBAG4KsEWlfFzPDdVe9RZMHH0Bba2IEUG
 A0C371kglqkaWglQh/J4fzUx7TxuvA2/Xj6mFa+LNtyPpUXwm9PUzz604HnJZWBiYAElGf264u
 W8yFuMwtEHyBZQ24q3we/8RxWf4rHKt5eXuvo68p5+fu5xK/n8n5ctrfz+v654gXr6NfcBnUz9
 wVnmENW2mQnQvD6529eT/zn+3k9THWaCzWUZEup0BQpYpIyEoeBioYKbKkoNKaUXXYWkrMDlTu
 1YFoqC9U2Zi/KlkG7gaqGErVUFeo4o8WUtCA5UH2jCOBaqgs1lpVK7L1MaaBmp9ivagolwCitC
 MkYNVD7n0qgrvEXW4/JZY7GaCM4D9TtVJNqqSsUshZSahdshoEi7NZC1x2EesbOMYVE6GDsLGK
 D+3KxJkpisOik4RjGepFa3B0z1kxJKhUXLIX2I76FSpYe9duuqSKiYGy5K8w8Ytni7ryw5kqVQ
 EFMGhw9qPkWLFW2DR2uyVIshEwebbBjslDv2GF/YDVbWgrFiqMw6cHKt3Dp+4uE5mtlFz1gQPm
 gZrtj28cLa75yslFCVj7Z8Rqia/DdtmvCHILyZQayPo5/Dtix61tFNWFZoFEQUvZ3NV+v139+G
 6CFMQUAAA==
X-Change-ID: 20230303-arm64-gcs-e311ab0d8729
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Thiago Jung Bauermann <thiago.bauermann@linaro.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11678; i=broonie@kernel.org;
 h=from:subject:message-id; bh=v+tDIe2bYsLeFuxQFNRoHsarF1iqezQy1Lpm3BSHqxk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYOzUcUTCh61ohFa79m0Es/zHw4CYG/nUT95O
 QKR6/cCyDmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DswAKCRAk1otyXVSH
 0MvLB/44y/UytoybP5f3vbX03aCxLX4aCD6ucZqgje4CGMwrjD/KFdthDgUAfWPic5MaB5ikibV
 YVp1MXk8uOeO33goZK8pVWj9pwSO1OdNwXkkN/LfrW44P8af/YbqbOVFHSvUYtXbbsBKEQLTcPp
 51btDdhugIo+TKtKznfiprSPjb66RALVNRxGNUTiEEP6A6Qwe2UEDjDTjN0nP4L0x0FPOazCBhd
 NWsypJpQWibuF1Vc9rE+KHtEL6IWtEa+HVeS/rqSJZsY7MUzSI0Eie4UgXIO5hqbxumaIgD2LCq
 aJg2+rOaS2kPK64QajuaS3kNS9nOMVFyetXOa9HxHJl3Yfgz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The arm64 Guarded Control Stack (GCS) feature provides support for
hardware protected stacks of return addresses, intended to provide
hardening against return oriented programming (ROP) attacks and to make
it easier to gather call stacks for applications such as profiling.

When GCS is active a secondary stack called the Guarded Control Stack is
maintained, protected with a memory attribute which means that it can
only be written with specific GCS operations.  The current GCS pointer
can not be directly written to by userspace.  When a BL is executed the
value stored in LR is also pushed onto the GCS, and when a RET is
executed the top of the GCS is popped and compared to LR with a fault
being raised if the values do not match.  GCS operations may only be
performed on GCS pages, a data abort is generated if they are not.

The combination of hardware enforcement and lack of extra instructions
in the function entry and exit paths should result in something which
has less overhead and is more difficult to attack than a purely software
implementation like clang's shadow stacks.

This series implements support for managing GCS for KVM guests.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v21:
- Drop "KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP" which was
  applied as 089e4f3c4862.
- Reject creation of guests with GCS without S1PIE, or S1PIE/S1POE
  without TCR2.  Add selftest coverage for this.
- Flip order of GCSPR_EL2 and GCSCR_EL2 in el2_reg in get-reg-list.
- Remove ineffective selftest cases with HFGITR_EL2.ERET set.
- Formatting and clarity tweaks.
- Link to v20: https://patch.msgid.link/20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org

Changes in v20:
- Rebase onto v7.3-rc1.
- Relax GCSB DSYNCs, remove them when loading the vCPU and move them to
  vcpu_put() on the outgoing path.
- Make kvm_check_illegal_exlock_returns() mode change checks more
  similar to compute_exlock().
- Use kvm_has_gcs() in ctxt_has_gcs().
- Move some EL2 register saves under S1PIE checks.
- Link to v19: https://patch.msgid.link/20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org

Changes in v19:
- Fix accessor for GCSCR_EL2 in emulation.
- Correct locate_direct_register() for EL0 registers.
- Don't check for GCS without S1PIE when restoring vEL2.
- Move barriers to align better with nearby dsbs.
- Link to v18: https://patch.msgid.link/20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org

Changes in v18:
- Reinject all GCS exceptions from nested guests.
- Include GCSCRE0_EL1 and GCSPR_EL0 in the live CPU register accessors.
- Sort el2_regs in get-reg-list.
- Link to v17: https://patch.msgid.link/20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org

Changes in v17:
- Rebase onto v7.2-rc4.
- Fix mapping of HFGITR_EL2.nGCSEPP.
- Implement a test for NV emulation around EXLOCK.
- Fix NV exception emulation issues.
- Add GCS[PC]R_EL1 to locate_direct_register().
- Add barriers.
- Add ID_AA64PFR1_EL1.GCS to set_id_regs.
- Comment updates.
- Link to v16: https://lore.kernel.org/r/20250912-arm64-gcs-v16-0-6435e5ec37db@kernel.org

Changes in v16:
- Rebase onto v6.17-rc3.
- Also expose the feature to nested guests.
- Implement emulation of EXLOCK when returning from nested guests.
- Rename enter_exception_gcs() to compute_exlock().
- Move all ID_AA64PFR1_EL1 handling to the final kernel patch.
- Drop unneeded forwarding of GCS exceptions.
- Commit and cover message updates.
- Link to v15: https://lore.kernel.org/r/20250820-arm64-gcs-v15-0-5e334da18b84@kernel.org

Changes in v15:
- Rebase onto v6.17-rc1.
- Link to v14: https://lore.kernel.org/r/20241005-arm64-gcs-v14-0-59060cd6092b@kernel.org

Changes in v14:
- Rebase onto arm64/for-next/gcs which includes all the non-KVM support.
- Manage the fine grained traps for GCS instructions.
- Manage PSTATE.EXLOCK when delivering exceptions to KVM guests.
- Link to v13: https://lore.kernel.org/r/20241001-arm64-gcs-v13-0-222b78d87eee@kernel.org

Changes in v13:
- Rebase onto v6.12-rc1.
- Allocate VM_HIGH_ARCH_6 since protection keys used all the existing
  bits.
- Implement mm_release() and free transparently allocated GCSs there.
- Use bit 32 of AT_HWCAP for GCS due to AT_HWCAP2 being filled.
- Since we now only set GCSCRE0_EL1 on change ensure that it is
  initialised with GCSPR_EL0 accessible to EL0.
- Fix OOM handling on thread copy.
- Link to v12: https://lore.kernel.org/r/20240829-arm64-gcs-v12-0-42fec947436a@kernel.org

Changes in v12:
- Clarify and simplify the signal handling code so we work with the
  register state.
- When checking for write aborts to shadow stack pages ensure the fault
  is a data abort.
- Depend on !UPROBES.
- Comment cleanups.
- Link to v11: https://lore.kernel.org/r/20240822-arm64-gcs-v11-0-41b81947ecb5@kernel.org

Changes in v11:
- Remove the dependency on the addition of clone3() support for shadow
  stacks, rebasing onto v6.11-rc3.
- Make ID_AA64PFR1_EL1.GCS writeable in KVM.
- Hide GCS registers when GCS is not enabled for KVM guests.
- Require HCRX_EL2.GCSEn if booting at EL1.
- Require that GCSCR_EL1 and GCSCRE0_EL1 be initialised regardless of
  if we boot at EL2 or EL1.
- Remove some stray use of bit 63 in signal cap tokens.
- Warn if we see a GCS with VM_SHARED.
- Remove rdundant check for VM_WRITE in fault handling.
- Cleanups and clarifications in the ABI document.
- Clean up and improve documentation of some sync placement.
- Only set the EL0 GCS mode if it's actually changed.
- Various minor fixes and tweaks.
- Link to v10: https://lore.kernel.org/r/20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org

Changes in v10:
- Fix issues with THP.
- Tighten up requirements for initialising GCSCR*.
- Only generate GCS signal frames for threads using GCS.
- Only context switch EL1 GCS registers if S1PIE is enabled.
- Move context switch of GCSCRE0_EL1 to EL0 context switch.
- Make GCS registers unconditionally visible to userspace.
- Use FHU infrastructure.
- Don't change writability of ID_AA64PFR1_EL1 for KVM.
- Remove unused arguments from alloc_gcs().
- Typo fixes.
- Link to v9: https://lore.kernel.org/r/20240625-arm64-gcs-v9-0-0f634469b8f0@kernel.org

Changes in v9:
- Rebase onto v6.10-rc3.
- Restructure and clarify memory management fault handling.
- Fix up basic-gcs for the latest clone3() changes.
- Convert to newly merged KVM ID register based feature configuration.
- Fixes for NV traps.
- Link to v8: https://lore.kernel.org/r/20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org

Changes in v8:
- Invalidate signal cap token on stack when consuming.
- Typo and other trivial fixes.
- Don't try to use process_vm_write() on GCS, it intentionally does not
  work.
- Fix leak of thread GCSs.
- Rebase onto latest clone3() series.
- Link to v7: https://lore.kernel.org/r/20231122-arm64-gcs-v7-0-201c483bd775@kernel.org

Changes in v7:
- Rebase onto v6.7-rc2 via the clone3() patch series.
- Change the token used to cap the stack during signal handling to be
  compatible with GCSPOPM.
- Fix flags for new page types.
- Fold in support for clone3().
- Replace copy_to_user_gcs() with put_user_gcs().
- Link to v6: https://lore.kernel.org/r/20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org

Changes in v6:
- Rebase onto v6.6-rc3.
- Add some more gcsb_dsync() barriers following spec clarifications.
- Due to ongoing discussion around clone()/clone3() I've not updated
  anything there, the behaviour is the same as on previous versions.
- Link to v5: https://lore.kernel.org/r/20230822-arm64-gcs-v5-0-9ef181dd6324@kernel.org

Changes in v5:
- Don't map any permissions for user GCSs, we always use EL0 accessors
  or use a separate mapping of the page.
- Reduce the standard size of the GCS to RLIMIT_STACK/2.
- Enforce a PAGE_SIZE alignment requirement on map_shadow_stack().
- Clarifications and fixes to documentation.
- More tests.
- Link to v4: https://lore.kernel.org/r/20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org

Changes in v4:
- Implement flags for map_shadow_stack() allowing the cap and end of
  stack marker to be enabled independently or not at all.
- Relax size and alignment requirements for map_shadow_stack().
- Add more blurb explaining the advantages of hardware enforcement.
- Link to v3: https://lore.kernel.org/r/20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org

Changes in v3:
- Rebase onto v6.5-rc4.
- Add a GCS barrier on context switch.
- Add a GCS stress test.
- Link to v2: https://lore.kernel.org/r/20230724-arm64-gcs-v2-0-dc2c1d44c2eb@kernel.org

Changes in v2:
- Rebase onto v6.5-rc3.
- Rework prctl() interface to allow each bit to be locked independently.
- map_shadow_stack() now places the cap token based on the size
  requested by the caller not the actual space allocated.
- Mode changes other than enable via ptrace are now supported.
- Expand test coverage.
- Various smaller fixes and adjustments.
- Link to v1: https://lore.kernel.org/r/20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org

---
Mark Brown (15):
      arm64/gcs: Ensure FGTs for EL1 GCS instructions are disabled
      KVM: arm64: Refuse to start a guest with S1PIE or S1POE but not TCR2
      KVM: arm64: Manage GCS access and registers for guests
      KVM: arm64: Ensure GCS memory effects are visible
      KVM: arm64: Set PSTATE.EXLOCK when entering an exception
      KVM: arm64: Validate GCS exception lock when emulating ERET
      KVM: arm64: Forward GCS exceptions to nested guests
      KVM: arm64: Enforce EXLOCK for SPSR and ELR
      KVM: arm64: Allow GCS to be enabled for guests
      KVM: selftests: arm64: Check that invalid feature combinations are rejected
      KVM: selftests: arm64: Add GCS registers to get-reg-list
      KVM: selftests: arm64: Add GCS to set_id_regs
      KVM: selftests: arm64: Only restore SPSR_EL1 and ELR_EL1 if they change
      tools: Synchronise the kernel esr.h
      KVM: selftests: arm64: Add GCS EXLOCK exception emulation test

 arch/arm64/include/asm/el2_setup.h                 |   5 +
 arch/arm64/include/asm/kvm_emulate.h               |  11 +
 arch/arm64/include/asm/kvm_host.h                  |  14 +
 arch/arm64/include/asm/kvm_nested.h                |  32 ++
 arch/arm64/include/asm/vncr_mapping.h              |   2 +
 arch/arm64/include/uapi/asm/ptrace.h               |   1 +
 arch/arm64/kvm/arm.c                               |   7 +
 arch/arm64/kvm/emulate-nested.c                    |   5 +-
 arch/arm64/kvm/handle_exit.c                       |  18 +-
 arch/arm64/kvm/hyp/exception.c                     |  37 +++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  27 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   7 +
 arch/arm64/kvm/hyp/vhe/switch.c                    |   4 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  10 +
 arch/arm64/kvm/nested.c                            |   3 +-
 arch/arm64/kvm/sys_regs.c                          | 113 ++++++-
 tools/arch/arm64/include/asm/esr.h                 | 113 ++++++-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/gcs_exceptions.c | 336 +++++++++++++++++++++
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  12 +
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |  95 ++++++
 tools/testing/selftests/kvm/lib/arm64/handlers.S   |  10 +
 22 files changed, 840 insertions(+), 23 deletions(-)
---
base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
change-id: 20230303-arm64-gcs-e311ab0d8729

Best regards,
--  
Mark Brown <broonie@kernel.org>

