Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E73815F9
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787600916; cv=none; b=N2L8IoV3YuWlXhzXMqVe/NQLIE7i7E0x+9wFO6zKthJlIxJMOvM7sS425PzukYIKiY2O47Vb07ByM95Zd8tXs/qiLLU23xb2UImRYlQaEdrdGMM1ccHKQveIcHiN1fWNWRH7lfy/djhv4EXCtaWbTmezoBy2k9dYR23+FyL7zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787600916; c=relaxed/simple;
	bh=ofC7kb0lNN6W4gvYkqZp34eZwnwmen/Oc03rk6eRWko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IgUrviJXKMN9jMHwRHfTlYOJ/92Rw9Q1zZLVvTu9TKeT1udO6pEvHdlAe7jn7413juA91diRHSkVMIerQRf27Bo9sbZbf3hHpBCLWxJYE2s6Y0tINzRh/VtLy8FQkuVfLoj7qRm3RBIFw/CWGqe1t2kIoAkffDEydESv1oyC4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8TWOLAR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8TWOLAR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787600912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ai1QZFLNFxImTcwGdJTINCJXHn62zwOssrDH0GDVjvA=;
	b=G8TWOLARxsWpW6e5Fp+wIkVn4osA3YHbg9CsYMcwG2xEc3MxXc2WG9D+C+zg4dd9rvwgZZ
	da1nt1MPLqjtTnvdmz2QRv1IOAOtYWc/k8ho+UtUxezXJ36SPTI+iOCIRYchGLBsH3XZQG
	szYtF/B/wn2pn1bXxdKPX0AiffmWx0o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-RHbleXGzMuWrAIQTeBqcfQ-1; Mon, 24 Aug 2026 15:48:30 -0400
X-MC-Unique: RHbleXGzMuWrAIQTeBqcfQ-1
X-Mimecast-MFC-AGG-ID: RHbleXGzMuWrAIQTeBqcfQ_1787600909
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f4bff865cso1925586f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 12:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787600909; x=1788205709;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ai1QZFLNFxImTcwGdJTINCJXHn62zwOssrDH0GDVjvA=;
        b=hF6mrRe4IyF6Mc/YBujwH8czMJlPF6S5wFKIA87MEd/PzRtww88gsy6kVhi9n7TgmJ
         Y+TnDa7Q3Bc0H7Q0TC6jvIVE6OpC2OgfAep3yY/+RpWpIFc0utmmB2RLsujcRfTgVKuI
         opD83kAVM72jJLLWg92Kl6nc44v7T8clHRETSY7pwMOV05vrfXeJgq9kla5/bIVwZm06
         cXNX5+AYyla+9PB57BKDK4wdTvEV+WJmVkG/FTf5jpvKgHyteT5Vt978Ys8tXywG1v5A
         d2Ofndk0vZfIDE4zctNxplIc4jEhLmSyvA/252U9ZHtXXz1C17NHCOKSwIw4T8PPznAV
         TLzw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Dz4ciOmQ5sIBexLwXJbY2Fa3g+oPicRsu7NiZs9ix8PVtDyBDyhUMxjpE9Gfz0heKteaviI=@lists.linux.dev
X-Gm-Message-State: AFuF++mon8CpQee35woON6nqxxoD6y2Pq1TIPJbsLodqA4uvp8PKexm/
	5j2zIwEfcPz9tvc7a1ThNMazQRBYPt0+co0fcaLr0oMVqcSOps3gTxFiVcqYMpItXMH3CjYHWOZ
	p3bnSQ9c1r02cNvT2/H/of/A1S0tu7fUjgdGa3A81eZ1f+qtHVqkEvZ+W04GyqgwXBw4PkMWts0
	yNrdPK8WFizeR/+E0EaeC8X/oGJB4r3lCp
X-Gm-Gg: AR+sD10hgkrkqryn+QlhmHcAFTSVeNLU68v6LT18Pi6uvHMATcuDYtkF88v2Tp0kjjb
	kFGSi8CNcgAjICyhRCrjCXZ4fHN6eMBqlwkK27KR1gs94uSsUERwK/1HYHV80Jlyyoqz7wHwgiw
	sAfWNCJFbBujN7LlzPk2DyUFFnJn+6eUfi9qC6Rz38KjDuzv3tgp3vdB3GM2y75SWL9VidzkGUi
	tg2ZckuMJ2mWaWkYEqF21Vyy7Pivi29KdSOr3M5SMjOhZJXrnrb6ZYIW78=
X-Received: by 2002:a5d:5f96:0:b0:47f:8ac0:282 with SMTP id ffacd0b85a97d-482c0ba3344mr38751600f8f.17.1787600909061;
        Mon, 24 Aug 2026 12:48:29 -0700 (PDT)
X-Received: by 2002:a5d:5f96:0:b0:47f:8ac0:282 with SMTP id
 ffacd0b85a97d-482c0ba3344mr38751534f8f.17.1787600908421; Mon, 24 Aug 2026
 12:48:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aoaG4cyg3gRQH_8S@kernel.org>
In-Reply-To: <aoaG4cyg3gRQH_8S@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 24 Aug 2026 21:48:13 +0200
X-Gm-Features: AcwNN1UDRkRMy6gfy8grhSa8xS6yDrRe6lIhY3AtoAlV9sJLtCwTwarkFj6pp9s
Message-ID: <CABgObfbaqnaQPzQ+3rs2kc0XkD6Lqft4tOxS-XgcA1VkN583JQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 changes for 7.3
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fRSmjVMOsWWkPES8RWR7a-HmKbXl8gKxyzN53ldYqVI_1787600909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 6:47=E2=80=AFAM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> Hi Paolo,
>
> Apologies for the delay on sending you 7.3 content. I've been _mostly_ on
> family leave for the past while but Marc + the entire reviewer crew has
> helped significantly with getting this release into shape. Seriously,
> thanks y'all.
>
> Continuing with the current trend, this release is extremely fix heavy,
> although we were able to get some new features in for PMU, nested, and pK=
VM
> this time around.
>
> There are two minor conflicts, one with the powerpc tree [1] and the othe=
r
> with arm64 [2]. Resolutions for both are straightforward (e.g. add/add co=
llision
> in uapi.h)
>
> Details found in the tag, please pull.

Done, thanks.

Paolo

> Thanks,
> Oliver
>
> [1]: https://lore.kernel.org/linux-next/ans20_e3b_8XJsvA@sirena.org.uk/
> [2]: https://lore.kernel.org/linux-next/anXu1CnuHQo-fKId@sirena.org.uk/
>
> The following changes since commit f5098b6bae761e346ebcd9da7f95622c04733c=
ff:
>
>   Linux 7.2-rc5 (2026-07-26 14:45:48 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-7.3
>
> for you to fetch changes up to aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2:
>
>   Merge branch 'kvm-arm64/misc-7.3' into next (2026-08-19 14:08:24 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 changes for 7.3
>
>  - Add support for 'slot' based PMU events, paired with new UAPI that
>    compels the user to select a specific PMU implementation
>
>  - Lazy save/restore of vCPU state for pKVM, along with various fixes
>    and cleanups to the management of vCPU state between the untrusted
>    host and pKVM hypervisor
>
>  - Disable traps of EL1 registers for nested hypervisors when FEAT_NV2p1
>    is present, guaranteeing that EL2-specific register bits are stateful
>    in the EL1 counterpart
>
>  - Leverage FEAT_NV3 to avoid unnecessary ERET/TLBI traps when the scope
>    of those instructions remains 'in host' (i.e. L1 kernel/userspace)
>
>  - Pile of fixes for the management of the VNCR pseudo-TLB, such as
>    under-invalidations and races with concurrent TLBIs on other vCPUs
>
>  - Consolidate the non-protected and pKVM view of ICH_VTR_EL2 to a
>    runtime-patched constant, allowing the same data to be shared with
>    pKVM prior to dropping host privileges
>
>  - Considerable pile of LLM-assisted fixes around the shop but mostly in
>    the VGIC, our in-kernel generator of bugs (and sometimes interrupts)
>
> ----------------------------------------------------------------
> Bradley Morgan (2):
>       KVM: arm64: Skip cache maintenance for non-cacheable pKVM mappings
>       KVM: arm64: Top up stage-2 memcache for dirty logging faults
>
> Congkai Tan (3):
>       KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
>       KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAP=
I
>       KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature
>
> Fuad Tabba (21):
>       KVM: arm64: Drop the unused EL2-side is_created write
>       KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
>       KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
>       KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
>       KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
>       KVM: arm64: selftests: Add a userspace watchpoint test
>       KVM: arm64: Extract MPIDR computation into a shared header
>       KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
>       KVM: arm64: Factor out reusable vCPU reset helpers
>       KVM: arm64: Move PSCI helper functions to a shared header
>       KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>       KVM: arm64: Top up the memcache for pKVM permission faults
>       KVM: arm64: Skip pKVM stage-2 flush when FWB is enabled
>       KVM: arm64: Don't WARN on pKVM stage-2 map failures
>       KVM: arm64: Don't advertise eager page splitting under pKVM
>       KVM: arm64: selftests: Add stage-2 block transition test
>       KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT sa=
ve
>       KVM: arm64: vgic: Don't leak the SPI array when init is retried
>       KVM: arm64: vgic-its: Don't save collections the table cannot hold
>       KVM: arm64: vgic-its: Point saved ITEs at the next valid entry
>       KVM: arm64: vgic: Reset in_kernel on private IRQ allocation failure
>
> Kajetan Puchalski (1):
>       KVM: arm64: vgic: Fix detection of MI on no pending LR
>
> Karl Mehltretter (2):
>       KVM: arm64: Preserve GPRs for AArch32 CP64 reads generating an UNDE=
F
>       KVM: arm64: GICv2: Don't WARN on out-of-range GICV_DIR INTID
>
> Marc Zyngier (48):
>       KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field =
symbols
>       KVM: arm64: Move GICv3 broken SEIS implementation detection to a CP=
U errrata
>       KVM: arm64: Add a helper providing an inlined literal value for ICH=
_VTR_EL2
>       KVM: arm64: Convert most ICH_VTR_EL2 accesses to inlined literal va=
lue
>       KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
>       KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2
>       KVM: arm64: Add host and hypervisor vCPU lookup primitives
>       KVM: arm64: Minimise EL2's exposure of host VGIC state during world=
 switch
>       KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
>       arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions
>       arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
>       KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
>       KVM: arm64: Drop __HCRX_EL2_* masks
>       KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
>       KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL register
>       KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET f=
ast path
>       arm64: Add ARM64_HAS_NV2P1 capability
>       KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present
>       KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
>       KVM: arm64: Expose FEAT_NV2p1 to NV guests
>       arm64: Add FEAT_NV2p1 detection
>       arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
>       arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
>       arm64: Add ARM64_HAS_NV3 capability
>       KVM: arm64: Split NV-specific exit fixups from the non-NV handling
>       KVM: arm64: Add NV3 control bits to HCRX_EL2 sanitisation
>       KVM: arm64: Add kvm_has_nv{2,3}() predicates
>       KVM: arm64: Make HCR_EL2 a non-VNCR register
>       KVM: arm64: Add sanitisation for NVHCR_EL2
>       KVM: arm64: Add NVHCR_EL2 handling to the sysreg array
>       KVM: arm64: Add routing for NVHCR_EL2 trap
>       KVM: arm64: Add NVHCR_EL2 context switching
>       KVM: arm64: Engage NV3 ERET trap elision
>       KVM: arm64: Engage NV3 TLBI trap elision
>       KVM: arm64: Add FEAT_NV3 detection
>       KVM: arm64: Expose FEAT_NV3 to guests
>       KVM: arm64: selftest: Add NVHCR_EL2 to get-reg-list
>       arm64: Add override for ID_AA64MMFR4_EL1.NV_frac
>       KVM: arm64: Remove VM-wide VNCR mapping counter
>       KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluat=
ion
>       KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
>       KVM: arm64: Correctly handle end of VA space TLBI invalidation
>       KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR =
unmapping
>       KVM: arm64: Sign-extend VA for range-based TLBI invalidation
>       KVM: arm64: Make VNCR invalidation participate in MMU invalidation =
retry
>       KVM: arm64: Add VNCR TLB tracking again
>       KVM: arm64: Make timer_get_offset() work in all contexts
>       KVM: arm64: Correctly cap TLBI Range to the architural limit
>
> Mostafa Saleh (4):
>       KVM: arm64: Avoid naming collision in tracing
>       KVM: arm64: Optimize protected mode with FWB and DIC
>       KVM: arm64: Fix timer offsets for non-protected VMs
>       KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
>
> Oliver Upton (7):
>       KVM: arm64: Ignore writes to PMCR_EL0.N when using strict UAPI
>       Merge branch 'kvm-arm64/pmu-7.3' into next
>       Merge branch 'kvm-arm64/pkvm-7.3' into next
>       Merge branch 'kvm-arm64/feat-nv3' into next
>       Merge branch 'kvm-arm64/vncr-fixes' into next
>       Merge branch 'kvm-arm64/vtr-patch' into next
>       Merge branch 'kvm-arm64/misc-7.3' into next
>
> Qihang (1):
>       KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_=
tables
>
> Sascha Bischoff (4):
>       KVM: arm64: vgic: Free gic_kvm_info on initialization failure
>       KVM: arm64: vgic: Prevent speculative SPI array underflow
>       KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
>       KVM: arm64: Validate GICv5 timer PPIs before claiming ownership
>
> Vincent Donnefort (1):
>       KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
>
> Will Deacon (1):
>       KVM: arm64: Avoid mismatched accesses to 'struct kvm_nvhe_init_para=
ms'
>
>  Documentation/virt/kvm/api.rst                     |  11 +
>  Documentation/virt/kvm/devices/vcpu.rst            |  11 +-
>  arch/arm64/include/asm/cpufeature.h                |   1 +
>  arch/arm64/include/asm/kvm_arm.h                   |  27 +-
>  arch/arm64/include/asm/kvm_asm.h                   |   4 +-
>  arch/arm64/include/asm/kvm_emulate.h               | 107 +++++++-
>  arch/arm64/include/asm/kvm_host.h                  |  14 +-
>  arch/arm64/include/asm/kvm_nested.h                |  20 ++
>  arch/arm64/include/asm/kvm_pkvm.h                  |   8 +-
>  arch/arm64/include/asm/vncr_mapping.h              |   2 +-
>  arch/arm64/include/uapi/asm/kvm.h                  |   1 +
>  arch/arm64/kernel/asm-offsets.c                    |   1 -
>  arch/arm64/kernel/cpu_errata.c                     |  17 +-
>  arch/arm64/kernel/cpufeature.c                     |  18 +-
>  arch/arm64/kernel/image-vars.h                     |   2 +
>  arch/arm64/kernel/pi/idreg-override.c              |  10 +
>  arch/arm64/kvm/arch_timer.c                        |  15 +-
>  arch/arm64/kvm/arm.c                               |  26 +-
>  arch/arm64/kvm/at.c                                |   2 -
>  arch/arm64/kvm/config.c                            |  27 +-
>  arch/arm64/kvm/emulate-nested.c                    |  18 +-
>  arch/arm64/kvm/handle_exit.c                       |  40 ++-
>  arch/arm64/kvm/hyp/exception.c                     |  34 +--
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  42 ++--
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  11 +
>  arch/arm64/kvm/hyp/include/nvhe/clock.h            |   8 +-
>  arch/arm64/kvm/hyp/nvhe/clock.c                    |   4 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |  11 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 | 271 +++++++++++++++=
+++---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   7 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  15 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +-
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  10 +-
>  arch/arm64/kvm/hyp/nvhe/trace.c                    |   4 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  43 +---
>  arch/arm64/kvm/hyp/vhe/switch.c                    |  62 +++--
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  21 +-
>  arch/arm64/kvm/mmu.c                               |   9 +-
>  arch/arm64/kvm/nested.c                            | 190 ++++++++++-----
>  arch/arm64/kvm/pkvm.c                              |  34 +--
>  arch/arm64/kvm/pmu-emul.c                          |  54 +++-
>  arch/arm64/kvm/psci.c                              |  30 +--
>  arch/arm64/kvm/reset.c                             |  60 +----
>  arch/arm64/kvm/sys_regs.c                          | 152 ++++++++++--
>  arch/arm64/kvm/sys_regs.h                          |  19 ++
>  arch/arm64/kvm/vgic-sys-reg-v3.c                   |   8 +-
>  arch/arm64/kvm/vgic/vgic-init.c                    |   8 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |  26 +-
>  arch/arm64/kvm/vgic/vgic-v2.c                      |   3 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               |   2 +-
>  arch/arm64/kvm/vgic/vgic-v3.c                      | 107 +++++---
>  arch/arm64/kvm/vgic/vgic-v5.c                      |   5 +-
>  arch/arm64/kvm/vgic/vgic.c                         |   7 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  19 +-
>  arch/arm64/tools/cpucaps                           |   3 +
>  arch/arm64/tools/gen-sysreg.awk                    |   8 +-
>  arch/arm64/tools/sysreg                            |  42 +++-
>  include/kvm/arm_arch_timer.h                       |  34 ++-
>  include/kvm/arm_pmu.h                              |   4 +
>  include/kvm/arm_psci.h                             |  27 ++
>  include/kvm/arm_vgic.h                             |   4 +-
>  include/uapi/linux/kvm.h                           |   1 +
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  .../testing/selftests/kvm/arm64/debug-exceptions.c |  41 ++++
>  tools/testing/selftests/kvm/arm64/get-reg-list.c   |   3 +
>  .../selftests/kvm/arm64/stage2_block_transitions.c | 226 +++++++++++++++=
++
>  66 files changed, 1580 insertions(+), 477 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/stage2_block_transi=
tions.c
>

