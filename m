Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C46E56A
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783865116; cv=none; b=rGG4de4FChQElx5AJwwLBTvau/REw+KcTG0GxEjypdQsfVYkl5DG4DnyGr8QRrS27IE025zR20Im3q2oKX2JzHaj9bkLqTVljM1Iu/uEXxwcrrVEex8L4oZSJm1tWcTCjW4lJrmK/+jk3W7suvBX8aNPYCHtr28FAGvWAv4SlwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783865116; c=relaxed/simple;
	bh=zlETQrh+zb1M3k0IDkCZ1454sDDOJ909Yw10SX8l0Rc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWWkleTxTEaOWMngvOwjjX4seIPABSoTlEpyvHfdKoHwr4WsdLYsiBgeUM7LKZaR/lZs7e9TpxM5vy+30OWCqXrTUBPOt2sdowMsOYWFNxyoeiVbQJVvw8V9udsY0aa0DdRpjZDhq5k7XjpZbURjoAvH/YHsvK328nHjOgC0R9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ocN1PgFt; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ocN1PgFt"
X-Forwarded-Encrypted: i=1; AHgh+Rob/ZTlmE3r790OeXW9OPgkAEKzKZH4bo7dCH4jDCv6evp8dkaqtNAFxEGP0L6v25E2Cdi6Rpg=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783865112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vb4CXjOYhJephSPRg1GYAn1FcT11xW7E+C+IHaTGnRA=;
	b=ocN1PgFtJzo6M4MsgTdJZJ2oHNK5y6qQiuPq02dmPw/QldxVY2EyoGajmLUJBderEJ62NW
	r4adD9TW75RrtyLN3eNDobjXddmAlkVJd8YL9hM9Jz4pTRwUJjHIfhgpqNBg5W5UXwUHRh
	O4/TfbKOAsj0921i55B693X+siEc75Y=
X-Gm-Message-State: AOJu0YxU3nPZlce9wzC7GAt28rJezjLWiv3POEZcM5bX2Bm+U0jqzdUT
	58wThmM/7dDE/AkzYUGLt0j9WnW2ic34vt3djaIgU8Tg0ZZLCS/Fs0RZRylDxAD94YQ9BWpv0LI
	TkteAgfUAK6m9sM5Z10lRVw2HFl8o8iN7hNjNIumN
X-Received: by 2002:ac8:7f83:0:b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-51cbe256fecmr10080301cf.6.1783865077019; Sun, 12 Jul 2026
 07:04:37 -0700 (PDT)
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
Date: Sun, 12 Jul 2026 15:03:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw4uz9UjezNdHynMV38P0jORwfcxSSv834nQ8Q1JqW0Jg@mail.gmail.com>
X-Gm-Features: AUfX_myW63-imtHJdWgzPdBSFtBgJh1hwYvcYTYKMljNHOhg6vU003wD_-aoyMo
Message-ID: <CA+EHjTw4uz9UjezNdHynMV38P0jORwfcxSSv834nQ8Q1JqW0Jg@mail.gmail.com>
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


On Thu, 9 Jul 2026 at 19:40, Mark Brown <broonie@kernel.org> wrote:
>
> [ Note: I've spoken with both Mark Rutland and James Morse both of whom
>   might potentially have some overlapping changes, they've both agreed
>   that they'll deal with any rebasing if it's a question of this getting
>   in or something else. ]
>
> I've removed the RFC tag from this version of the series, but the items
> that I'm looking for feedback on remains the same:
>
>  - The userspace ABI, in particular:
>   - The vector length used for the SVE registers, access to the SVE
>     registers and access to ZA and (if available) ZT0 depending on
>     the current state of PSTATE.{SM,ZA}.
>   - The use of a single finalisation for both SVE and SME.
>   - There was some review from the qemu people who seemed OK with the
>     structure, and there's some initial patches from them at:
>        https://patchew.org/QEMU/20260216034432.23912-1-richard.henderson@linaro.org/

The state-dependent Z/P view and SVCR.ZA gating make sense to me, and
lossless: the inaccessible state is only reachable via an SM/ZA
transition, which zeroes the affected registers.

Single finalisation via KVM_ARM_VCPU_VEC makes sense too: splitting it
would leave the SVE registers writable while their VL could still
move.

Unrelated: on the get-reg-list restructuring you mention deferring to
a separate series: since ZA, ZT0 and SME_VLS are the
migration-critical SME state, it'd be good if that series also covered
a save/restore round-trip for them, not just get-reg-list enumeration.

Cheers,
/fuad


> This series implements support for SME use in non-protected KVM guests.
> Much of this is very similar to SVE, the main additional challenge that
> SME presents is that it introduces a new vector length similar to the
> SVE vector length and two new controls which change the registers seen
> by guests:
>
>  - PSTATE.ZA enables the ZA matrix register and, if SME2 is supported,
>    the ZT0 LUT register.
>  - PSTATE.SM enables streaming mode, a new floating point mode which
>    uses the SVE register set with the separately configured SME vector
>    length.  In streaming mode implementation of the FFR register is
>    optional.
>
> It is also permitted to build systems which support SME without SVE, in
> this case when not in streaming mode no SVE registers or instructions
> are available.  Further, there is no requirement that there be any
> overlap in the set of vector lengths supported by SVE and SME in a
> system, this is expected to be a common situation in practical systems.
>
> Since there is a new vector length to configure we introduce a new
> feature parallel to the existing SVE one with a new pseudo register for
> the streaming mode vector length.  Due to the overlap with SVE caused by
> streaming mode rather than finalising SME as a separate feature we use
> the existing SVE finalisation to also finalise SME, a new define
> KVM_ARM_VCPU_VEC is provided to help make user code clearer.  Finalising
> SVE and SME separately would introduce complication with register access
> since finalising SVE makes the SVE registers writeable by userspace and
> doing multiple finalisations results in an error being reported.
> Dealing with a state where the SVE registers are writeable due to one of
> SVE or SME being finalised but may have their VL changed by the other
> being finalised seems like needless complexity with minimal practical
> utility, it seems clearer to just express directly that only one
> finalisation can be done in the ABI.
>
> Access to the floating point registers follows the architecture:
>
>  - When both SVE and SME are present:
>    - If PSTATE.SM == 0 the vector length used for the Z and P registers
>      is the SVE vector length.
>    - If PSTATE.SM == 1 the vector length used for the Z and P registers
>      is the SME vector length.
>  - If only SME is present:
>    - If PSTATE.SM == 0 the Z and P registers are inaccessible and the
>      floating point state accessed via the encodings for the V registers.
>    - If PSTATE.SM == 1 the vector length used for the Z and P registers
>  - The SME specific ZA and ZT0 registers are only accessible if SVCR.ZA is 1.
>
> The VMM must understand this, in particular when loading state SVCR
> should be configured before other state.  It should be noted that while
> the architecture refers to PSTATE.SM and PSTATE.ZA these PSTATE bits are
> not preserved in SPSR_ELx, they are only accessible via SVCR.
>
> There are a large number of subfeatures for SME, most of which only
> offer additional instructions but some of which (SME2 and FA64) add
> architectural state. These are configured via the ID registers as per
> usual.
>
> Protected KVM is supported, with the implementation maintaining the
> existing restriction that the hypervisor will refuse to run if streaming
> mode or ZA is enabled.  This both simplfies the code and avoids the need
> to allocate storage for host ZA and ZT0 state, there seems to be little
> practical use case for supporting this and the memory usage would be
> non-trivial.  SME is not made available to protected guests, only normal
> guests.
>
> The new KVM_ARM_VCPU_VEC feature and ZA and ZT0 registers have not been
> added to the get-reg-list selftest, the idea of supporting additional
> features there without restructuring the program to generate all
> possible feature combinations has been rejected.  I will post a separate
> series which does that restructuring.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
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
