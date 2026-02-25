Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0538E119
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772011362; cv=none; b=ZEoGYukn6wBi3QkFrbt4R7nF82JDLd1KZy8QOlXie06WsZ1yEy1pEpcTCmudy17zMGaeNvdr9W/Kxfa00DAjoLMCg1bx9alHy/wmK/4o/2X5XcKMHk9XanrN3o6d/hJlt1Cv9GKOXXin5qJ18z/T85zeYZCCjCLOaNXbmsftohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772011362; c=relaxed/simple;
	bh=Fl7LDcwloEYYSrRYhs41Ef8t1sJ/mzLn9ohsJEcU+Fs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=C62MJMIXrz2A6ZzD7YedbL386iPfMz616BmpWp+GkJHTpVlHVBj84QBukjASV+8Cjx2VNTgH9jMrir2qDpLYsaQ7MdsAMV7GANU4FUBcM1b8DlDrwK5pkowQeMtZJseqvyeVX7ec+ro8KuSvOcgcsiN304z2cvXvjxZia+OL15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g592cHUv; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g592cHUv"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b88593aa4dcso898234766b.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 01:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772011359; x=1772616159; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGuxkMX0kM60aNE9QHAj3qrKDisClRlnBUy8ZVl16+8=;
        b=g592cHUv1e4KpOpCu8GJ4tKW0f2UfsQO9JNFjhdxDib9GMff4YDCU6Mhn0LSmt+w+j
         LGT4uBp8Nho2cvBhrp+KajWOq9HuA2XVWYF0gtHFYOrdA9S9Jq4lViaiLKO5SF5bJ56i
         PkfErKYlqKLmN6ItNzKSb2ymyYubHw+M54StES0dyq3p4Q5je3oScY0t2vvk673lwxCB
         MOUbD1dDTv270y/AGLrZ5o07NpySvfsqEd6fCsgLX3rT6SW2c15BO5iMk5DZsMffM98n
         MgFRZBsn80FaW+ypENZ8k8Q/FWZxK0BEuB2rrsnprfzIjCgQqysohcL0os3hivQSZAZq
         QP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772011359; x=1772616159;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OGuxkMX0kM60aNE9QHAj3qrKDisClRlnBUy8ZVl16+8=;
        b=ggmORf9AeI6U1tPyOfLJh3BLTlYBouHsIaOzRRfqPZukcei3qziJdRC57ajOkmMjlI
         ImftLLG9Ysp77jdwCEqgbNfRJEYId4G6wAdDc1Sc5egDl7cX5r2QmbJop1AfPZJkiie5
         wyR3zFCkQZ7ABrwoUsoIjWgUoXsaMCtot3CP8VPBsEqZtViDesc31nKSGc7x5DmXGEtx
         RGHYPVl9PV0EndDQpYkKqmWpaV9OtewqO0pIcVM+rRbjWkXGy1e2jDxIgYqvpS04tkQk
         WQOHw6X5KlFNs4tZVoo/Lfaawyk4zqvh4T92dFnf5SpSywcHBkG7j6dDSsLXnI2gYzm2
         o3WA==
X-Forwarded-Encrypted: i=1; AJvYcCVYNahZ3tNrjZAFLuNqeW5iBChWFpjXtewram08rHMa+J9nrGYN4gg5AQCi7b0WpNuxmcTe3cY=@lists.linux.dev
X-Gm-Message-State: AOJu0YziV1UCSwQygidKOyGGwc5BpR0gvzFZ7+9a30EazYKZqB09YKu8
	mvleCLgkMXV1iZaobu2z/3SIIz+AwkUXwG8Cte+89j/ICL85zH3D377O+OBhWF4cZcI=
X-Gm-Gg: ATEYQzzdsoZb/QUceRknzMfbHC4qY5kqR3qWbeQDZXtyuuAJALmX0YiLhYsyzRuF0SM
	F17Q+/6WbCD63fMtrsFnieUkVGjgURRh6r1POluyOUPY3QeMAZA7G1vAtRjQKv0UlLuars/7BJg
	K/uv+H7vt+nuFu0QE1VNAB6kZ/ASV2/1mdeFItB/qsb0IpwT9JxzoZ8qIZcCr2Fto/6KBiipqiC
	iggRUzgQE1R7wMc5eXn8sSFDo+syPG7dv8aeh5OruleYex6onb7R0uDiOpsmsEkHcPT6gX5/825
	D2D4PIFxom+LW+npWB+yIY5tAZuO50b9M3/kA3pHD4l+/4TNpiiEha9dBWz7E2LJhuuHnvtQkhG
	A0u0m5oWlAFB0nn9bicsgFMrNTrM30rR9jJ49Komm7O1KLZ6wyuf7iwQpHg+oUAKXQ89paDfSwa
	etPD5q58FlUJ78lxcviOcNfFE=
X-Received: by 2002:a17:907:d8c:b0:b8f:a8bc:a081 with SMTP id a640c23a62f3a-b9081a02587mr927550166b.19.1772011358547;
        Wed, 25 Feb 2026 01:22:38 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba1375dsm4099202a12.21.2026.02.25.01.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 01:22:37 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id EAB235F834;
	Wed, 25 Feb 2026 09:22:36 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v9 00/30] KVM: arm64: Implement support for SME
In-Reply-To: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> (Mark
	Brown's message of "Tue, 23 Dec 2025 01:20:54 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
User-Agent: mu4e 1.14.0-pre1; emacs 30.1
Date: Wed, 25 Feb 2026 09:22:36 +0000
Message-ID: <87fr6p2n4z.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> I've removed the RFC tag from this version of the series, but the items
> that I'm looking for feedback on remains the same:
>
>  - The userspace ABI, in particular:
>   - The vector length used for the SVE registers, access to the SVE
>     registers and access to ZA and (if available) ZT0 depending on
>     the current state of PSTATE.{SM,ZA}.
>   - The use of a single finalisation for both SVE and SME.
>

Hi Mark,

Richard has posted an initial QEMU RFC series here:

  Message-ID: <20260216034432.23912-1-richard.henderson@linaro.org>
  Date: Mon, 16 Feb 2026 13:44:19 +1000
  Subject: [RFC PATCH 00/13] target/arm: Support SME for KVM
  From: Richard Henderson <richard.henderson@linaro.org>

For those that would like to test. Given the residency of SME2 context
and the timing of running everything under TCG it might be worth adding
some SME2 workloads to the kvm-unit-tests similar to how the GIC ITS
migration is tested.

>  - The addition of control for enabling fine grained traps in a similar
>    manner to FGU but without the UNDEF, I'm not clear if this is desired
>    at all and at present this requires symmetric read and write traps like
>    FGU. That seemed like it might be desired from an implementation
>    point of view but we already have one case where we enable an
>    asymmetric trap (for ARM64_WORKAROUND_AMPERE_AC03_CPU_38) and it
>    seems generally useful to enable asymmetrically.
>
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
>    - If PSTATE.SM =3D=3D 0 the vector length used for the Z and P registe=
rs
>      is the SVE vector length.
>    - If PSTATE.SM =3D=3D 1 the vector length used for the Z and P registe=
rs
>      is the SME vector length.
>  - If only SME is present:
>    - If PSTATE.SM =3D=3D 0 the Z and P registers are inaccessible and the
>      floating point state accessed via the encodings for the V registers.
>    - If PSTATE.SM =3D=3D 1 the vector length used for the Z and P registe=
rs
>  - The SME specific ZA and ZT0 registers are only accessible if SVCR.ZA i=
s 1.
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
> Protected KVM supported, with the implementation maintaining the
> existing restriction that the hypervisor will refuse to run if streaming
> mode or ZA is enabled.  This both simplfies the code and avoids the need
> to allocate storage for host ZA and ZT0 state, there seems to be little
> practical use case for supporting this and the memory usage would be
> non-trivial.
>
> The new KVM_ARM_VCPU_VEC feature and ZA and ZT0 registers have not been
> added to the get-reg-list selftest, the idea of supporting additional
> features there without restructuring the program to generate all
> possible feature combinations has been rejected.  I will post a separate
> series which does that restructuring.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v9:
> - Rebase onto v6.19-rc1.
> - ABI document clarifications.
> - Add changes dropping asserts on single bit wide bitfields in set_id_reg=
s.
> - Link to v8: https://lore.kernel.org/r/20250902-kvm-arm64-sme-v8-0-2cb21=
99c656c@kernel.org
>
> Changes in v8:
> - Small fixes in ABI documentation.
> - Link to v7: https://lore.kernel.org/r/20250822-kvm-arm64-sme-v7-0-7a65d=
82b8b10@kernel.org
>
> Changes in v7:
> - Rebase onto v6.17-rc1.
> - Handle SMIDR_EL1 as a VM wide ID register and use this in feat_sme_smps=
().
> - Expose affinity fields in SMIDR_EL1.
> - Remove SMPRI_EL1 from vcpu_sysreg, the value is always 0 currently.
> - Prevent userspace writes to SMPRIMAP_EL2.
> - Link to v6: https://lore.kernel.org/r/20250625-kvm-arm64-sme-v6-0-114cf=
f4ffe04@kernel.org
>
> Changes in v6:
> - Rebase onto v6.16-rc3.
> - Link to v5: https://lore.kernel.org/r/20250417-kvm-arm64-sme-v5-0-f469a=
2d5f574@kernel.org
>
> Changes in v5:
> - Rebase onto v6.15-rc2.
> - Add pKVM guest support.
> - Always restore SVCR.
> - Link to v4: https://lore.kernel.org/r/20250214-kvm-arm64-sme-v4-0-d64a6=
81adcc2@kernel.org
>
> Changes in v4:
> - Rebase onto v6.14-rc2 and Mark Rutland's fixes.
> - Expose SME to nested guests.
> - Additional cleanups and test fixes following on from the rebase.
> - Flush register state on VMM PSTATE.{SM,ZA}.
> - Link to v3: https://lore.kernel.org/r/20241220-kvm-arm64-sme-v3-0-05b01=
8c1ffeb@kernel.org
>
> Changes in v3:
> - Rebase onto v6.12-rc2.
> - Link to v2: https://lore.kernel.org/r/20231222-kvm-arm64-sme-v2-0-da226=
cb180bb@kernel.org
>
> Changes in v2:
> - Rebase onto v6.7-rc3.
> - Configure subfeatures based on host system only.
> - Complete nVHE support.
> - There was some snafu with sending v1 out, it didn't make it to the
>   lists but in case it hit people's inboxes I'm sending as v2.
>
> ---
> Mark Brown (30):
>       arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
>       arm64/fpsimd: Update FA64 and ZT0 enables when loading SME state
>       arm64/fpsimd: Decide to save ZT0 and streaming mode FFR at bind time
>       arm64/fpsimd: Check enable bit for FA64 when saving EFI state
>       arm64/fpsimd: Determine maximum virtualisable SME vector length
>       KVM: arm64: Pay attention to FFR parameter in SVE save and load
>       KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
>       KVM: arm64: Move SVE state access macros after feature test macros
>       KVM: arm64: Rename SVE finalization constants to be more general
>       KVM: arm64: Document the KVM ABI for SME
>       KVM: arm64: Define internal features for SME
>       KVM: arm64: Rename sve_state_reg_region
>       KVM: arm64: Store vector lengths in an array
>       KVM: arm64: Implement SME vector length configuration
>       KVM: arm64: Support SME control registers
>       KVM: arm64: Support TPIDR2_EL0
>       KVM: arm64: Support SME identification registers for guests
>       KVM: arm64: Support SME priority registers
>       KVM: arm64: Provide assembly for SME register access
>       KVM: arm64: Support userspace access to streaming mode Z and P regi=
sters
>       KVM: arm64: Flush register state on writes to SVCR.SM and SVCR.ZA
>       KVM: arm64: Expose SME specific state to userspace
>       KVM: arm64: Context switch SME state for guests
>       KVM: arm64: Handle SME exceptions
>       KVM: arm64: Expose SME to nested guests
>       KVM: arm64: Provide interface for configuring and enabling SME for =
guests
>       KVM: arm64: selftests: Remove spurious check for single bit safe va=
lues
>       KVM: arm64: selftests: Skip impossible invalid value tests
>       KVM: arm64: selftests: Add SME system registers to get-reg-list
>       KVM: arm64: selftests: Add SME to set_id_regs test
>
>  Documentation/virt/kvm/api.rst                   | 120 ++++++++---
>  arch/arm64/include/asm/fpsimd.h                  |  26 +++
>  arch/arm64/include/asm/kvm_emulate.h             |   6 +
>  arch/arm64/include/asm/kvm_host.h                | 163 ++++++++++++---
>  arch/arm64/include/asm/kvm_hyp.h                 |   5 +-
>  arch/arm64/include/asm/kvm_pkvm.h                |   2 +-
>  arch/arm64/include/asm/vncr_mapping.h            |   2 +
>  arch/arm64/include/uapi/asm/kvm.h                |  33 +++
>  arch/arm64/kernel/cpufeature.c                   |   2 -
>  arch/arm64/kernel/fpsimd.c                       |  89 ++++----
>  arch/arm64/kvm/arm.c                             |  10 +
>  arch/arm64/kvm/config.c                          |  11 +-
>  arch/arm64/kvm/fpsimd.c                          |  28 ++-
>  arch/arm64/kvm/guest.c                           | 252 +++++++++++++++++=
+++---
>  arch/arm64/kvm/handle_exit.c                     |  14 ++
>  arch/arm64/kvm/hyp/fpsimd.S                      |  28 ++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h          | 168 +++++++++++++--
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h       | 110 ++++++----
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c               |  86 ++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                   |  85 ++++++--
>  arch/arm64/kvm/hyp/nvhe/switch.c                 |   4 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c               |   6 +
>  arch/arm64/kvm/hyp/vhe/switch.c                  |  17 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c               |   7 +
>  arch/arm64/kvm/nested.c                          |   3 +-
>  arch/arm64/kvm/reset.c                           | 156 ++++++++++----
>  arch/arm64/kvm/sys_regs.c                        | 140 ++++++++++++-
>  arch/arm64/tools/sysreg                          |   8 +-
>  include/uapi/linux/kvm.h                         |   1 +
>  tools/testing/selftests/kvm/arm64/get-reg-list.c |  15 +-
>  tools/testing/selftests/kvm/arm64/set_id_regs.c  |  84 ++++++--
>  31 files changed, 1367 insertions(+), 314 deletions(-)
> ---
> base-commit: 3e7f562e20ee87a25e104ef4fce557d39d62fa85
> change-id: 20230301-kvm-arm64-sme-06a1246d3636
>
> Best regards,

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
