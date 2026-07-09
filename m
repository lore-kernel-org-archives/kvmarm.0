Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20522274FDC;
	Thu,  9 Jul 2026 00:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558359; cv=none; b=o5GTXa8XBf12ttBuHtwujAEBtuy6+ygsu3xvZUtFWF4aJD9HMnfxzZ8K7Ae/8XE2SrBQe83l5v0DmvAI1z20zUV8fkLTJnMIIGFG8e9fvc1CzNaZkYJTQHGNbAXtrP5PeO27NGHegh+aydmwV7YF2qqk0LSwq9+h/Hv4kArps5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558359; c=relaxed/simple;
	bh=LHLJw48aKsJxtof2BI6dI8sSr+LkAmlQ2FH1YKQuAKs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XBiA0nkHUN96SKpucZoMEDkroAbtYaLGikoDHzS8LEMhTuELMWOW4R2nRBDcfmS3uKZobFxd2zUhBaqqw140dHWKnrfRFfddVcQ1u0ogdpESXHLj9C7wfkfTgn2kUr8p96X5TZtUzN1e2TRnLJhlS4/OQqkMvdJc9kLsSG5Y0hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrXd72Ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrXd72Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F601F000E9;
	Thu,  9 Jul 2026 00:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558357;
	bh=SUike172D6Qe/lcVjU7rsTELZii9Cy9VDwsOKZeStn0=;
	h=From:Subject:Date:To:Cc;
	b=KrXd72Ffh7Su9JJuIvvz0KMdbc1hzh+ctK7Z1xXbjrGqauKna22uOEgkfIJ4ryQRZ
	 uUfpSz94FM3223S1x9QAxdMrwLKp0rgCAzySv7G56IZ1m2PIzA4Um+cYBlNMa6RqJL
	 GRAhfZH8Zu5tO+655Tx+kdSQ7ZFL9m7rZfNG+wA4c/+egcfQJwfFhdIMShgS0Ptn7x
	 Y0frAPcWAf+t1sMfBxaESDvCO+ZcOFnC8iz51igfCWScpBSzs2X3RsBy5WZMNiNCWe
	 v/+lNwQ8V+/ioQIhzL3pSC2RqBFa0jJkIaRuZjtqDeQnuAAI6oG+QIg7+scGvgRK7e
	 PohTF6I0NjaNQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v11 00/29] KVM: arm64: Implement support for SME
Date: Thu, 09 Jul 2026 01:51:37 +0100
Message-Id: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJrwTmoC/2XSzW7DIAwH8Fepch4VNmBIT3uPaQcg0EZb2o500
 aaq7z6nVVstHLH42Xz8z82YSp/GZrM6NyVN/dgf9rwAeFk1cef32yT6jgsNSlRSSRAf0yB8GUi
 LcUhCkgfU1ClS1LAJfkwiFL+Pu1mdhuNcPZaU+5/rmLd3Xu/68XQov9epE8zVW/8WcdF/AiFFz
 uA6qwO2qXv9SGWfPteHsm3mVhM+OGDNkXnnESkGcDKEiqs718zlkivm0gQJLkLOqeb6zo1E0Eu
 u5+mkPTnwXYxYcfPkGuySm/numlqPncnG6orTkxOaJSfmADrmrPnssub2yV39dJa59WQ6h8EFk
 BV3T97KijvmGANC20YyFCvePji/vFrylrkLSTmyMTinKg7y7olzSVVu+OOEVtmSU17mYP81uNx
 CWdLXN0f+dEvmLbzxMAz9abOa7BpFicibL3/EeACdJwMAAA==
X-Change-ID: 20230301-kvm-arm64-sme-06a1246d3636
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11982; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LHLJw48aKsJxtof2BI6dI8sSr+LkAmlQ2FH1YKQuAKs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvC5/pMh8cyatVqV5w/emjLIK16ol/zwNwjdQ
 bmZ2FFXikGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wuQAKCRAk1otyXVSH
 0KrAB/sE0ET7wTKkoeteoWOTUrKyvkYUd6adE11KArb5zvN/avxNYDoeIF7KpasDvXU2SQwp18s
 aPa2e8x/E8vi+zhah3tsntdW/vWlk9rAuP5gI2BDPETLNAe0OA9sb/xyPdMgJhuF8Lt+Ln6Iu+t
 J7soiwPKi1aZ6ZAk59IwbWYhVzZ2pyo+hMKHgaXlSuydG83q1TRhPkvDheQC+9nV4+Mmrreg1Ke
 xU0PFaaexNHH5t90HCs2MpXrePnDjopzIhp54PC/IIwQGHvNUd4rntSP9/QXR/IUZ30larS/Iya
 lRi6XJJZoW3LMl5pPXfUH9GuEJl3AHsxCoLQj5cBE1Dftf8r
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

[ Note: I've spoken with both Mark Rutland and James Morse both of whom
  might potentially have some overlapping changes, they've both agreed
  that they'll deal with any rebasing if it's a question of this getting
  in or something else. ]

I've removed the RFC tag from this version of the series, but the items
that I'm looking for feedback on remains the same:

 - The userspace ABI, in particular:
  - The vector length used for the SVE registers, access to the SVE
    registers and access to ZA and (if available) ZT0 depending on
    the current state of PSTATE.{SM,ZA}.
  - The use of a single finalisation for both SVE and SME.
  - There was some review from the qemu people who seemed OK with the
    structure, and there's some initial patches from them at:
       https://patchew.org/QEMU/20260216034432.23912-1-richard.henderson@linaro.org/

This series implements support for SME use in non-protected KVM guests.
Much of this is very similar to SVE, the main additional challenge that
SME presents is that it introduces a new vector length similar to the
SVE vector length and two new controls which change the registers seen
by guests:

 - PSTATE.ZA enables the ZA matrix register and, if SME2 is supported,
   the ZT0 LUT register.
 - PSTATE.SM enables streaming mode, a new floating point mode which
   uses the SVE register set with the separately configured SME vector
   length.  In streaming mode implementation of the FFR register is
   optional.

It is also permitted to build systems which support SME without SVE, in
this case when not in streaming mode no SVE registers or instructions
are available.  Further, there is no requirement that there be any
overlap in the set of vector lengths supported by SVE and SME in a
system, this is expected to be a common situation in practical systems.

Since there is a new vector length to configure we introduce a new
feature parallel to the existing SVE one with a new pseudo register for
the streaming mode vector length.  Due to the overlap with SVE caused by
streaming mode rather than finalising SME as a separate feature we use
the existing SVE finalisation to also finalise SME, a new define
KVM_ARM_VCPU_VEC is provided to help make user code clearer.  Finalising
SVE and SME separately would introduce complication with register access
since finalising SVE makes the SVE registers writeable by userspace and
doing multiple finalisations results in an error being reported.
Dealing with a state where the SVE registers are writeable due to one of
SVE or SME being finalised but may have their VL changed by the other
being finalised seems like needless complexity with minimal practical
utility, it seems clearer to just express directly that only one
finalisation can be done in the ABI.

Access to the floating point registers follows the architecture:

 - When both SVE and SME are present:
   - If PSTATE.SM == 0 the vector length used for the Z and P registers
     is the SVE vector length.
   - If PSTATE.SM == 1 the vector length used for the Z and P registers
     is the SME vector length.
 - If only SME is present:
   - If PSTATE.SM == 0 the Z and P registers are inaccessible and the
     floating point state accessed via the encodings for the V registers.
   - If PSTATE.SM == 1 the vector length used for the Z and P registers
 - The SME specific ZA and ZT0 registers are only accessible if SVCR.ZA is 1.

The VMM must understand this, in particular when loading state SVCR
should be configured before other state.  It should be noted that while
the architecture refers to PSTATE.SM and PSTATE.ZA these PSTATE bits are
not preserved in SPSR_ELx, they are only accessible via SVCR.

There are a large number of subfeatures for SME, most of which only
offer additional instructions but some of which (SME2 and FA64) add
architectural state. These are configured via the ID registers as per
usual.

Protected KVM is supported, with the implementation maintaining the
existing restriction that the hypervisor will refuse to run if streaming
mode or ZA is enabled.  This both simplfies the code and avoids the need
to allocate storage for host ZA and ZT0 state, there seems to be little
practical use case for supporting this and the memory usage would be
non-trivial.  SME is not made available to protected guests, only normal
guests.

The new KVM_ARM_VCPU_VEC feature and ZA and ZT0 registers have not been
added to the get-reg-list selftest, the idea of supporting additional
features there without restructuring the program to generate all
possible feature combinations has been rejected.  I will post a separate
series which does that restructuring.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v11:
- Rebase onto v7.2-rc2.
- Rework VL enumeration.
- Refactor ZCR and SMCR value generation for the host into helper
  functions.
- Add handling of FEAT_IDST for hidden system registers.
- Ensure we manage traps correctly for emulated EL2.
- Always allocate space for ZT0 if the hardware supports it.
- Tighten the register enumeration ABI to reflect current VM state.
- Sanitise SMIDR_EL1.
- Fix generation of invalid values in set_id_regs.
- Various smaller fixups, including from Jean-Phillipe's review.
- Link to v10: https://patch.msgid.link/20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org

Changes in v10:
- Define and use a SME_VQ_INVALID for the case where there is no
  virtuablisable SME VL.
- Fix handling of SMCR_EL2 accesses.
- Correct VNCR constant for SMPRI_EL2.
- Correct trapping for SMPRI_EL1.
- Reject userspace access to FFR when in streaming mode without FA64.
- Constrain the VL set by sme_cond_update_smcr() to fit within LEN.
- Reject userspace access to ZA and ZT0 when SVCR.SM is 0.
- Use -EACCESS for inaccessible SME registers.
- Remove some unused functions.
- Further bugfixes from review.
- Commit log typo fixes.

- Link to v9: https://patch.msgid.link/20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org

Changes in v9:
- Rebase onto v6.19-rc1.
- ABI document clarifications.
- Add changes dropping asserts on single bit wide bitfields in set_id_regs.
- Link to v8: https://lore.kernel.org/r/20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org

Changes in v8:
- Small fixes in ABI documentation.
- Link to v7: https://lore.kernel.org/r/20250822-kvm-arm64-sme-v7-0-7a65d82b8b10@kernel.org

Changes in v7:
- Rebase onto v6.17-rc1.
- Handle SMIDR_EL1 as a VM wide ID register and use this in feat_sme_smps().
- Expose affinity fields in SMIDR_EL1.
- Remove SMPRI_EL1 from vcpu_sysreg, the value is always 0 currently.
- Prevent userspace writes to SMPRIMAP_EL2.
- Link to v6: https://lore.kernel.org/r/20250625-kvm-arm64-sme-v6-0-114cff4ffe04@kernel.org

Changes in v6:
- Rebase onto v6.16-rc3.
- Link to v5: https://lore.kernel.org/r/20250417-kvm-arm64-sme-v5-0-f469a2d5f574@kernel.org

Changes in v5:
- Rebase onto v6.15-rc2.
- Add pKVM guest support.
- Always restore SVCR.
- Link to v4: https://lore.kernel.org/r/20250214-kvm-arm64-sme-v4-0-d64a681adcc2@kernel.org

Changes in v4:
- Rebase onto v6.14-rc2 and Mark Rutland's fixes.
- Expose SME to nested guests.
- Additional cleanups and test fixes following on from the rebase.
- Flush register state on VMM PSTATE.{SM,ZA}.
- Link to v3: https://lore.kernel.org/r/20241220-kvm-arm64-sme-v3-0-05b018c1ffeb@kernel.org

Changes in v3:
- Rebase onto v6.12-rc2.
- Link to v2: https://lore.kernel.org/r/20231222-kvm-arm64-sme-v2-0-da226cb180bb@kernel.org

Changes in v2:
- Rebase onto v6.7-rc3.
- Configure subfeatures based on host system only.
- Complete nVHE support.
- There was some snafu with sending v1 out, it didn't make it to the
  lists but in case it hit people's inboxes I'm sending as v2.

---
Mark Brown (29):
      arm64/sysreg: Define full value read/modify/write helpers
      arm64/fpsimd: Update FA64 and ZT0 enables when loading SME state
      arm64/fpsimd: Decide to save ZT0 and streaming mode FFR at bind time
      arm64/sve: Factor virtualizable VL discovery out of SVE specific code
      arm64/fpsimd: Determine maximum virtualisable SME vector length
      KVM: arm64: Handle FEAT_IDST for guest accesses to hidden registers
      KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
      KVM: arm64: Rename SVE finalization constants to be more general
      KVM: arm64: Define internal features for SME
      KVM: arm64: Rename sve_state_reg_region
      KVM: arm64: Store vector lengths in an array
      KVM: arm64: Factor SVE code out of fpsimd_lazy_switch_to_host()
      KVM: arm64: Document the KVM ABI for SME
      KVM: arm64: Implement SME vector length configuration
      KVM: arm64: Support SME control registers
      KVM: arm64: Support TPIDR2_EL0
      KVM: arm64: Support SME identification registers for guests
      KVM: arm64: Support SME priority registers
      KVM: arm64: Support userspace access to streaming mode Z and P registers
      KVM: arm64: Flush register state on writes to SVCR.SM and SVCR.ZA
      KVM: arm64: Expose SME specific state to userspace
      KVM: arm64: Context switch SME state for guests
      KVM: arm64: Handle SME exceptions
      KVM: arm64: Expose SME to nested guests
      KVM: arm64: Provide interface for configuring and enabling SME for guests
      KVM: arm64: selftests: Remove spurious check for single bit safe values
      KVM: arm64: selftests: Skip impossible invalid value tests
      KVM: arm64: selftests: Add SME system registers to get-reg-list
      KVM: arm64: selftests: Add SME to set_id_regs test

 Documentation/virt/kvm/api.rst                   | 124 +++++---
 arch/arm64/include/asm/fpsimd.h                  |  17 +-
 arch/arm64/include/asm/kvm_emulate.h             |  16 +
 arch/arm64/include/asm/kvm_host.h                | 113 ++++++-
 arch/arm64/include/asm/kvm_hyp.h                 |   2 +-
 arch/arm64/include/asm/kvm_nested.h              |   2 +
 arch/arm64/include/asm/kvm_pkvm.h                |   2 +-
 arch/arm64/include/asm/sysreg.h                  |   8 +
 arch/arm64/include/asm/vncr_mapping.h            |   2 +
 arch/arm64/include/uapi/asm/kvm.h                |  34 +++
 arch/arm64/kernel/cpufeature.c                   |   2 -
 arch/arm64/kernel/fpsimd.c                       | 134 ++++----
 arch/arm64/kvm/arm.c                             |  10 +
 arch/arm64/kvm/config.c                          |  12 +-
 arch/arm64/kvm/emulate-nested.c                  |   6 +-
 arch/arm64/kvm/fpsimd.c                          |  27 +-
 arch/arm64/kvm/guest.c                           | 369 ++++++++++++++++++++---
 arch/arm64/kvm/handle_exit.c                     |  14 +
 arch/arm64/kvm/hyp/include/hyp/switch.h          | 234 +++++++++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h       |  96 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c               | 129 ++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                   |  90 ++++--
 arch/arm64/kvm/hyp/nvhe/switch.c                 |   2 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c               |   6 +
 arch/arm64/kvm/hyp/vhe/switch.c                  |  17 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c               |   7 +
 arch/arm64/kvm/inject_fault.c                    |  15 +
 arch/arm64/kvm/nested.c                          |   8 +-
 arch/arm64/kvm/reset.c                           | 159 +++++++---
 arch/arm64/kvm/sys_regs.c                        | 152 +++++++++-
 include/uapi/linux/kvm.h                         |   1 +
 tools/testing/selftests/kvm/arm64/get-reg-list.c |  15 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c  |  96 +++++-
 33 files changed, 1554 insertions(+), 367 deletions(-)
---
base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
change-id: 20230301-kvm-arm64-sme-06a1246d3636

Best regards,
--  
Mark Brown <broonie@kernel.org>

