Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82363CDBD3
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673044; cv=none; b=iFSCd1ug3Sp8ZHCJDx/J7ixMVbTrDnG5aIYJMoCJkbz4liFnrGTwd/pQJK4agoKlkKiq1lfb131teeVyWPiv5BLzMrAdAJsKGOqri84gkv+yNeShvMUYKQTSbRmuEBryKdU89DJVb+iVq93hGb7hT2CAcpvcYiI9wlktQfno8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673044; c=relaxed/simple;
	bh=WBqhhNaUo0Wti5P891QHXsZMh0Ox3ClSmdHtOCtrUIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HuActvmBtdlhvRz4Fk0UgJ7LWkbgHtCR4C9KZ+iWUwylb6M7PW3tODKnNCiAJC4J+QGVbDeKqDk2/l95aTeD+XbzRg7IbvKP9EmAc4OGRjArZ0ETuEftcJjSCDJTHwDsIs/CAFKJEQjm7m8Zan5Pymubl3fuR/bRqizjWpftoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IVrLQq/M; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IVrLQq/M"
X-Forwarded-Encrypted: i=1; AHgh+Rr7e7FKaJbCPoGlp9/qvbJ0a3HrOcUbwNOOUq8n03UfGSvLUHkTszl9g2smeHFWD9DJajnY8uE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783673039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=siduqZ2wtPSfCiwUG4eYK+3EbnxMFmH0JOEC1+cp3Go=;
	b=IVrLQq/MYYZRMw27PyHScXd04kBjscpRnUq0Iw5EEOOeUZJKcIhfz/J1Ufm6cekAR3yhp8
	uh2o3pSFQvSFwBiiMVgHpFW4HMRAYmK9lRRLKgcxkWrrmFWKyXojEW71ksoxzH+PhhAhAR
	HPte/k7g6lWT7AwuOt41XCEMDudN+8A=
X-Gm-Message-State: AOJu0Yw6btaa01UP0qJ8IZvvmhZAfcoM+Vyd+XV750h8IdsyjUelTwyW
	j2zNAKmFtvu8N1Gzp622MR5fNswvMD2/m9iVAeYTv9qvmq+HTNCyiNN2Q32h3VqmUnKQcU14HNi
	r41gWw0SVag3bL9TrdaVTfWmtwTjgHJq1iUty91Qm
X-Received: by 2002:a05:622a:5908:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51caa298ab4mr8006471cf.10.1783673035194; Fri, 10 Jul 2026
 01:43:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 10 Jul 2026 09:43:17 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzgFA0_Pu5FkSAx46Ax9hdGS0QYCVAf+UcFvjgWWgAfZw@mail.gmail.com>
X-Gm-Features: AUfX_mxrvzBv6NCMbjRMoOO6a2K0vxT04s13QWsrnVddbkkVnfBSRhldHB06vuw
Message-ID: <CA+EHjTzgFA0_Pu5FkSAx46Ax9hdGS0QYCVAf+UcFvjgWWgAfZw@mail.gmail.com>
Subject: Re: [PATCH v12 00/29] KVM: arm64: Implement support for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Mark,

[snip]

>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Gave this a spin on top of v7.2-rc2, applied cleanly and built fine.

Booted a host+guest with the host in VHE and in nVHE mode, and booted
both a normal guest and a protected guest under pKVM. All came up
cleanly. Note that a protected guest doesn't get SME, but it boots
fine without it.

Ran set_id_regs against a guest in all three host configurations (VHE,
nVHE, and protected/pKVM); all passed, with the new SME ID-register
checks actually executing rather than skipping, since QEMU's max CPU
exposes SME2.

Also ran get-reg-list, since patch 28 adds the SME registers to the
expected reg list, so it's the regression guard confirming the
guest-visible register set matches what the series intends to expose.
It passed too.

Will start reviewing soon. For now:
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
> Changes in v12:
> - Resend with commit rather than tag object specified as the base.
> - Link to v11: https://patch.msgid.link/20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org
>
> Changes in v11:
> - Rebase onto v7.2-rc2.
> - Rework VL enumeration.
> - Refactor ZCR and SMCR value generation for the host into helper
>   functions.
> - Add handling of FEAT_IDST for hidden system registers.
> - Ensure we manage traps correctly for emulated EL2.
> - Always allocate space for ZT0 if the hardware supports it.
> - Tighten the register enumeration ABI to reflect current VM state.
> - Sanitise SMIDR_EL1.
> - Fix generation of invalid values in set_id_regs.
> - Various smaller fixups, including from Jean-Phillipe's review.
> - Link to v10: https://patch.msgid.link/20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org
>
> Changes in v10:
> - Define and use a SME_VQ_INVALID for the case where there is no
>   virtuablisable SME VL.
> - Fix handling of SMCR_EL2 accesses.
> - Correct VNCR constant for SMPRI_EL2.
> - Correct trapping for SMPRI_EL1.
> - Reject userspace access to FFR when in streaming mode without FA64.
> - Constrain the VL set by sme_cond_update_smcr() to fit within LEN.
> - Reject userspace access to ZA and ZT0 when SVCR.SM is 0.
> - Use -EACCESS for inaccessible SME registers.
> - Remove some unused functions.
> - Further bugfixes from review.
> - Commit log typo fixes.
>
> - Link to v9: https://patch.msgid.link/20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org
>
> Changes in v9:
> - Rebase onto v6.19-rc1.
> - ABI document clarifications.
> - Add changes dropping asserts on single bit wide bitfields in set_id_regs.
> - Link to v8: https://lore.kernel.org/r/20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org
>
> Changes in v8:
> - Small fixes in ABI documentation.
> - Link to v7: https://lore.kernel.org/r/20250822-kvm-arm64-sme-v7-0-7a65d82b8b10@kernel.org
>
> Changes in v7:
> - Rebase onto v6.17-rc1.
> - Handle SMIDR_EL1 as a VM wide ID register and use this in feat_sme_smps().
> - Expose affinity fields in SMIDR_EL1.
> - Remove SMPRI_EL1 from vcpu_sysreg, the value is always 0 currently.
> - Prevent userspace writes to SMPRIMAP_EL2.
> - Link to v6: https://lore.kernel.org/r/20250625-kvm-arm64-sme-v6-0-114cff4ffe04@kernel.org
>
> Changes in v6:
> - Rebase onto v6.16-rc3.
> - Link to v5: https://lore.kernel.org/r/20250417-kvm-arm64-sme-v5-0-f469a2d5f574@kernel.org
>
> Changes in v5:
> - Rebase onto v6.15-rc2.
> - Add pKVM guest support.
> - Always restore SVCR.
> - Link to v4: https://lore.kernel.org/r/20250214-kvm-arm64-sme-v4-0-d64a681adcc2@kernel.org
>
> Changes in v4:
> - Rebase onto v6.14-rc2 and Mark Rutland's fixes.
> - Expose SME to nested guests.
> - Additional cleanups and test fixes following on from the rebase.
> - Flush register state on VMM PSTATE.{SM,ZA}.
> - Link to v3: https://lore.kernel.org/r/20241220-kvm-arm64-sme-v3-0-05b018c1ffeb@kernel.org
>
> Changes in v3:
> - Rebase onto v6.12-rc2.
> - Link to v2: https://lore.kernel.org/r/20231222-kvm-arm64-sme-v2-0-da226cb180bb@kernel.org
>
> Changes in v2:
> - Rebase onto v6.7-rc3.
> - Configure subfeatures based on host system only.
> - Complete nVHE support.
> - There was some snafu with sending v1 out, it didn't make it to the
>   lists but in case it hit people's inboxes I'm sending as v2.
>
> ---
> Mark Brown (29):
>       arm64/sysreg: Define full value read/modify/write helpers
>       arm64/fpsimd: Update FA64 and ZT0 enables when loading SME state
>       arm64/fpsimd: Decide to save ZT0 and streaming mode FFR at bind time
>       arm64/sve: Factor virtualizable VL discovery out of SVE specific code
>       arm64/fpsimd: Determine maximum virtualisable SME vector length
>       KVM: arm64: Handle FEAT_IDST for guest accesses to hidden registers
>       KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
>       KVM: arm64: Rename SVE finalization constants to be more general
>       KVM: arm64: Define internal features for SME
>       KVM: arm64: Rename sve_state_reg_region
>       KVM: arm64: Store vector lengths in an array
>       KVM: arm64: Factor SVE code out of fpsimd_lazy_switch_to_host()
>       KVM: arm64: Document the KVM ABI for SME
>       KVM: arm64: Implement SME vector length configuration
>       KVM: arm64: Support SME control registers
>       KVM: arm64: Support TPIDR2_EL0
>       KVM: arm64: Support SME identification registers for guests
>       KVM: arm64: Support SME priority registers
>       KVM: arm64: Support userspace access to streaming mode Z and P registers
>       KVM: arm64: Flush register state on writes to SVCR.SM and SVCR.ZA
>       KVM: arm64: Expose SME specific state to userspace
>       KVM: arm64: Context switch SME state for guests
>       KVM: arm64: Handle SME exceptions
>       KVM: arm64: Expose SME to nested guests
>       KVM: arm64: Provide interface for configuring and enabling SME for guests
>       KVM: arm64: selftests: Remove spurious check for single bit safe values
>       KVM: arm64: selftests: Skip impossible invalid value tests
>       KVM: arm64: selftests: Add SME system registers to get-reg-list
>       KVM: arm64: selftests: Add SME to set_id_regs test
>
>  Documentation/virt/kvm/api.rst                   | 124 +++++---
>  arch/arm64/include/asm/fpsimd.h                  |  17 +-
>  arch/arm64/include/asm/kvm_emulate.h             |  16 +
>  arch/arm64/include/asm/kvm_host.h                | 113 ++++++-
>  arch/arm64/include/asm/kvm_hyp.h                 |   2 +-
>  arch/arm64/include/asm/kvm_nested.h              |   2 +
>  arch/arm64/include/asm/kvm_pkvm.h                |   2 +-
>  arch/arm64/include/asm/sysreg.h                  |   8 +
>  arch/arm64/include/asm/vncr_mapping.h            |   2 +
>  arch/arm64/include/uapi/asm/kvm.h                |  34 +++
>  arch/arm64/kernel/cpufeature.c                   |   2 -
>  arch/arm64/kernel/fpsimd.c                       | 134 ++++----
>  arch/arm64/kvm/arm.c                             |  10 +
>  arch/arm64/kvm/config.c                          |  12 +-
>  arch/arm64/kvm/emulate-nested.c                  |   6 +-
>  arch/arm64/kvm/fpsimd.c                          |  27 +-
>  arch/arm64/kvm/guest.c                           | 369 ++++++++++++++++++++---
>  arch/arm64/kvm/handle_exit.c                     |  14 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h          | 234 +++++++++++---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h       |  96 +++---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c               | 129 ++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                   |  90 ++++--
>  arch/arm64/kvm/hyp/nvhe/switch.c                 |   2 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c               |   6 +
>  arch/arm64/kvm/hyp/vhe/switch.c                  |  17 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c               |   7 +
>  arch/arm64/kvm/inject_fault.c                    |  15 +
>  arch/arm64/kvm/nested.c                          |   8 +-
>  arch/arm64/kvm/reset.c                           | 159 +++++++---
>  arch/arm64/kvm/sys_regs.c                        | 152 +++++++++-
>  include/uapi/linux/kvm.h                         |   1 +
>  tools/testing/selftests/kvm/arm64/get-reg-list.c |  15 +-
>  tools/testing/selftests/kvm/arm64/set_id_regs.c  |  96 +++++-
>  33 files changed, 1554 insertions(+), 367 deletions(-)
> ---
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> change-id: 20230301-kvm-arm64-sme-06a1246d3636
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
