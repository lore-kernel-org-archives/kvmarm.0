Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96FE282F2C;
	Mon,  3 Aug 2026 23:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798829; cv=none; b=sdiVPmqTOYa1rq0OfgeJSOUEJlaPP45oWVTTRGom9AmOOuBHwIs5OXyIZVrP/K/zo0ykLKCzf7mOE+OxEPRvvJ+BKkIV1/e3KZXFXSXEFfCES5+NqqvbpRK4lwriwjMctX5L6od2c1pkp5KFd7OY+2AJblddDxk4DmQJ4ZWpl7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798829; c=relaxed/simple;
	bh=Ab4p/MqR7LN7IvK2N/6V3akekXpZzuxPbOmhbiC+Nks=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YBZuygpjBqnNnPM9MRfn/lC9bR2P55LCWe2SX1nkvNeADCdMSRcDOEQohC33rLrSRWhSD+oLsTOLr6iQUz2+v53fG20OcHTP330XoY7teuLO5fqqd5nefu10GHMtblXplOMlLP4OhquCVksAMhLbbMi2TXSRdtBSMaeKu4+r5YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrCmJHSW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrCmJHSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF5F1F000E9;
	Mon,  3 Aug 2026 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798825;
	bh=AF07H15U4EdCg1KGMq2/3bFrHZHCIA4q47G/HWUcADg=;
	h=From:Subject:Date:To:Cc;
	b=CrCmJHSWEuTOhou76n6sjkwII3a5Rp8pFcym6CkEGBHGc0NE60rFwzntzETGirdUS
	 gYf08pijzTK32eN5AvJoGPeYEY2bEso4drO6z98Jhk13R8F66j1w2z32UZSNPOt9w+
	 ZzgPQmej24NFJ9j7LhfNtkt2s+nsgmXq/01cgHZBio9TuOSOfGIuWlGjT6fmcX/lSO
	 itmIpkSX9d1gdUKyO3z9B0cGEfbSPbsr1BgvuPtbzRJNVnvUlzGyp77RzROFLjt6Vr
	 7p/h9T/DrLZXunPURa4h9CiWvcLnM/4AbugBnLT11+pthBv0kOqXu2LbRaHBGmeiuu
	 iMPnMiYQJIpsg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v18 00/14] KVM: arm64: Provide guest support for GCS
Date: Mon, 03 Aug 2026 23:56:45 +0100
Message-Id: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK4ccWoC/23T227bMAwG4FcpfD0PJEWderX3GHqhA5UYW5PCL
 oIORd59Uosl8lT4yoI/UaR+v0+brIts0+PD+7TKZdmW86m+oPv2MKVjOB1kXnJdmAhIQX3msD4
 bng9pm0UhhgjZWfJT/T6GTea4hlM6NvH6/NJWX1Ypy9tHiZ9P9f24bK/n9c9HxQu21c+9LZpu7
 wvOMMeijS1exRjMj1+ynuT39/N6mNo2F+oocU+p0pwoYWZOJHGgqqMKe6oqTTkXX7yD7N1A+U4
 d2J5ypcalElQ9Mhg/UN1Rop7qSr0UdJizUcQDNTeKAL6nplLrROssIXDOA7V3ivuqtlICTOxUz
 Nbqgbp/lIF2F39xbUy+SLLWWCVloP5ODeme+kqhGMVsfHQFBopwtw52t4PQZuy9UMyEHsabRez
 wvl1siWKMDj1bSXHsF6nHuzFjyxRT7bhiViaM+BYqrne0P3ZLFRFF6+q/IiIj5h7v5oUtV7oGC
 lI24OmLnm/B0vXYsMMtWVqU4hzQRTcmC80de9wPrGXLsNKiJSmbv6h8C5f5/0dC+1nZpwAYkfc
 9X6/XvwOGncJ6BAAA
X-Change-ID: 20230303-arm64-gcs-e311ab0d8729
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Thiago Jung Bauermann <thiago.bauermann@linaro.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10269; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Ab4p/MqR7LN7IvK2N/6V3akekXpZzuxPbOmhbiC+Nks=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCZWi7VJYZALdObIJM2iG2KgDNTw7pA9em4U
 c1kbRNWEQiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgmQAKCRAk1otyXVSH
 0ABYB/9MDHwbcIqmmLIqL13MIEZXAuIk2aSB6D//mq7MoU8OMT1aXhfhuagJW/2wYcavz4R4nAs
 OhzUFoQq6qvAPk31WVGsI8UOHhmZNLamXWg0mBaqxrJ8yVPSakQ+9KhnJT+5sV5a0yjOR4/SkVQ
 EKMMZDXxQFHtMVhPzp+8tFBF7MdVbw5HYvacwW411zFOyPuWcuNL+lo8aa7S1KDfDdweNbdZin2
 v60AFBs+MRokxKU5FMLiSS9gC05ml0opjhUiQuOiG1ZDfoQsxlu9p2dn0GD+26ABSRFugQIvt43
 5EsHicvxcf857Mi3G9xzMYFhGIe17tY+Y78Pl+kxLgUR6srO
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
Mark Brown (14):
      arm64/gcs: Ensure FGTs for EL1 GCS instructions are disabled
      KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
      KVM: arm64: Manage GCS access and registers for guests
      KVM: arm64: Ensure GCS memory effects are visible
      KVM: arm64: Set PSTATE.EXLOCK when entering an exception
      KVM: arm64: Validate GCS exception lock when emulating ERET
      KVM: arm64: Forward GCS exceptions to nested guests
      KVM: arm64: Enforce EXLOCK for SPSR and ELR
      KVM: arm64: Allow GCS to be enabled for guests
      KVM: selftests: arm64: Add GCS registers to get-reg-list
      KVM: selftests: arm64: Add GCS to set_id_regs
      KVM: selftests: arm64: Only restore SPSR_EL1 and ELR_EL1 if they change
      tools: Synchronise the kernel esr.h
      KVM: selftests: arm64: Add GCS EXLOCK exception emulation test

 arch/arm64/include/asm/el2_setup.h                 |   5 +
 arch/arm64/include/asm/kvm_emulate.h               |  11 +
 arch/arm64/include/asm/kvm_host.h                  |  14 +
 arch/arm64/include/asm/kvm_nested.h                |  39 +++
 arch/arm64/include/asm/vncr_mapping.h              |   2 +
 arch/arm64/include/uapi/asm/ptrace.h               |   1 +
 arch/arm64/kvm/emulate-nested.c                    |   7 +-
 arch/arm64/kvm/handle_exit.c                       |  18 +-
 arch/arm64/kvm/hyp/exception.c                     |  37 +++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  31 ++
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  13 +
 arch/arm64/kvm/hyp/vhe/switch.c                    |   4 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  24 ++
 arch/arm64/kvm/nested.c                            |   3 +-
 arch/arm64/kvm/sys_regs.c                          |  89 +++++-
 tools/arch/arm64/include/asm/esr.h                 | 113 ++++++-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/gcs_exceptions.c | 346 +++++++++++++++++++++
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  12 +
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   1 +
 tools/testing/selftests/kvm/lib/arm64/handlers.S   |  10 +
 21 files changed, 757 insertions(+), 24 deletions(-)
---
base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
change-id: 20230303-arm64-gcs-e311ab0d8729

Best regards,
--  
Mark Brown <broonie@kernel.org>

