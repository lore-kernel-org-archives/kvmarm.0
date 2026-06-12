Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B2C36F90F
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 08:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781254375; cv=none; b=Dw8hAaZZBP2fY6Rvytv4JCbcDK9ooCyEfusSkh45XOekOEELgwVFon17fZy8pgqZike3plmscFirZCGd5mLHm5gKTXOFNW6SK7byy0fojw9wDFQqqW6wLW8e4xxPleNnwna1jOnIwhLFCl7dcsKC95UOdxzVbyGfjiR41rioDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781254375; c=relaxed/simple;
	bh=svNcQKQ4yr+nyo8MdRRL6FrGNPZqHBNgfoUJccKZlJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qkgMVQcsrpA+kZbjDb2scA7ppztXMnBQ9lxAr7/IqMLDQ6t6SBZQYMYDed6I9CkeOizn2gT6rpW1rv1lQQEq/F4i91SJP0aXMF5lN1984NhnmSZQGhIZtpFjnbUyGvv8GFezo4wW/l+L2PeuuYGoU2BHEB6sk4Ktu/iTXD0tP4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AMJAw5xk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMJAw5xk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781254373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOZXwEI5Y5B3Y02lgtWh42sCFLWWWettLEzpogbwuYA=;
	b=AMJAw5xkkjNiDaw31nweE5k3cfdYs3juz++9hClYJO50TyEWdMCb26hy4xYcntsT6xmFIj
	Yna3DD9MSN/bw8lzQMyhJ1aPhGwlnVLApueRyMab79/sTl6pP9l2hZmAc9vPEqza/Z3ndF
	Q+Ig6YnwK1PimCj2Y71UiyYnioZnBgo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-piR72m1jMY63FP647OKcug-1; Fri, 12 Jun 2026 04:52:48 -0400
X-MC-Unique: piR72m1jMY63FP647OKcug-1
X-Mimecast-MFC-AGG-ID: piR72m1jMY63FP647OKcug_1781254367
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490b5d2e394so4670795e9.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 01:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781254367; x=1781859167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OOZXwEI5Y5B3Y02lgtWh42sCFLWWWettLEzpogbwuYA=;
        b=ovVajL807e72wuSUhDXLnauHABK5sfb9Vun2KrEMURu1HwqaZ6rrbVtW/VNVh+E9wk
         Q0ROZp2Qu8CSO3XWgCkhDOx/yyxA7r9Juovyg1tolCTBfbmw0Z+fw5iBmaNQRCJX8YtB
         BXC3s6w3HBq/DpEzlPjPYy2NCohq9BnGbecGvVuVTkFSDGuvH/4s9lqSiCsK4ECZZcyf
         uckIlPoBpJ3OWz7kY7D8jkwUeVu3uWuPF8L4cXXwzhNmMkzyXjthNqSKl0iNg5TH5K/T
         o5d2sRr1zSWxFlA2JQ6BnYZAzthjljHBKaqAvNqmFvQha1FWBMr3m0D0cqTKSyDbSygX
         sY0A==
X-Forwarded-Encrypted: i=1; AFNElJ/wjt1881pIf50IMfaYd/yJlABO4UQJemBkUERnLWryRSnHJNRMt3q5R149LDRRODiiOrc8DOU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUbUXdlBAXkFsEErDhl+sQIcmpgoCuM8pl4KeKqqMPJ3BYHfIZ
	apKiyyDWvojLRFSOEj+xNW6kNfDeNrXdjNecQ8X/X1vEZQULG007ffXuO2THYqEf/MbOstZpz8H
	HbwMDXUkKepKdRCA8BMKePjuRUdR8J6XLwawtBzgyTKy1FFayjOVucdJbARocVKjro1F1UrxTfC
	E22vlL44Ar2rnGzaiWBfyjcskQrYZiKxqQ4zMRh95e
X-Gm-Gg: Acq92OH+sAd7rMSSxJLKCf+iRfCGK2S68IYvU1pkH6rislzs4Rkr40SY3kADeaIL7Fe
	vE4FFDklbG5+h0hwqbpm1ppiSu8kxycEyBnX7snZTUUUkqNfVyut0wf7TlKOeBggX9u9rv0EP7r
	UtQBWMdkECKDvHV8QuApO64ZT/a+y7HHhyhffc/5r0ujkl/bG624fI5HqP0C2EbgKMDNRFbiaP6
	1+PUQ48cWnU3kq7Rq1s6aictlx3AnSQZRNxSyi0QCjo8eiEbF5Sk+IMFfDWld7C+SfaUotT24Jk
	hG4asg==
X-Received: by 2002:a05:600d:15a:20b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-490ec4fb51fmr15350115e9.21.1781254367112;
        Fri, 12 Jun 2026 01:52:47 -0700 (PDT)
X-Received: by 2002:a05:600d:15a:20b0:490:bbc4:76a6 with SMTP id
 5b1f17b1804b1-490ec4fb51fmr15349825e9.21.1781254366732; Fri, 12 Jun 2026
 01:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612084835.2992552-1-maz@kernel.org>
In-Reply-To: <20260612084835.2992552-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 12 Jun 2026 10:52:35 +0200
X-Gm-Features: AVVi8CdX7owDuivueK1-dJeSaKhgMulywKYC_yrCRr9BJkyYkQ7RP3nuvUevgwM
Message-ID: <CABgObfZToG=W=g3ex21LSHUgXF7tNDRTH9CX_g9AcDJpkv+1FQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 7.2
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, Jackie Liu <liuyun01@kylinos.cn>, Joey Gouly <joey.gouly@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <zenghui.yu@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dYkUU-bU6S_y7SLa0IXq2jOdy96JHtzC-kztqoL-xUo_1781254367
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2026 at 10:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> This is a bit of an odd merge window on the KVM/arm64 front. There is
> absolutely no new feature in the pull request. It is purely fixes,
> because it is simply becoming too hard to review new stuff when so
> many AI-fuelled fixes hit the list. And even then, I've arbitrarily
> tagged the branch today, knowing that there is quite a backlog of
> fixes that I will send very shortly, probably before -rc1.

No problem. Since I usually wait for the arch code to be merged before
sending my PRs, you have almost a week to send them and have them
included in the very first PRs.

Pulled these for now, thanks.

Paolo

> So here it is: only fixes and very minor improvements, all over the
> place. Details in the tag below.
>
> Please pull,
>
>         M.
>
> The following changes since commit 5200f5f493f79f14bbdc349e402a40dfb32f23=
c8:
>
>   Linux 7.1-rc4 (2026-05-17 13:59:58 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-7.2
>
> for you to fetch changes up to 1ee27dacbe5dc4def481794d899d67b0d4570094:
>
>   Merge branch kvm-arm64/nv-mmu-7.2 into kvmarm-master/next (2026-06-12 0=
9:29:34 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 7.2
>
> * New features:
>
>   - None. Zilch. Nada. Que dalle.
>
> * Fixes and other improvements:
>
>   - Significant cleanup of the vgic-v5 PPI support which was merged in
>     7.1. This makes the code more maintainable, and squashes a couple
>     of bugs in the meantime.
>
>   - Set of fixes for the handling of the MMU in an NV context,
>     particularly VNCR-triggered faults. S1POE support is fixed
>     as well.
>
>   - Large set of pKVM fixes, mostly addressing recurring issues
>     around hypervisor tracking of donated pages in obscure cases
>     where the donation could fail and leave things in a bizarre
>     state.
>
>   - Fixes for the so-called "lazy vgic init", which resulted in
>     sleeping operations in non-preemptible sections. This turned
>     out to be far more invasive than initially expected...
>
>   - Reduce the overhead of L1/L2 context switch by not touching
>     the FP registers.
>
>   - Fix the way non-implemented page sizes are dealt with when
>     a guest insist on using them for S2 translation.
>
>   - The usual set of low-impact fixes and cleanups all over the map.
>
> ----------------------------------------------------------------
> Fuad Tabba (5):
>       KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
>       KVM: arm64: Fix __deactivate_fgt macro parameter typo
>       KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
>       KVM: arm64: Pre-check vcpu memcache for host->guest share
>       KVM: arm64: Pre-check vcpu memcache for host->guest donate
>
> Hyunwoo Kim (2):
>       KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCP=
U
>       KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
>
> Jackie Liu (1):
>       KVM: arm64: vgic-its: Make ABI commit helpers return void
>
> Marc Zyngier (29):
>       KVM: arm64: nv: Track L2 to L1 exception emulation
>       KVM: arm64: nv: Don't save/restore FP register during a nested ERET=
 or exception
>       KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to kvm=
_timer_{pending,enabled}()
>       KVM: arm64: Simplify userspace notification of interrupt state
>       KVM: arm64: timer: Kill the per-timer irq level cache
>       KVM: arm64: pmu: Kill the PMU interrupt level cache
>       KVM: arm64: vgic-v2: Force vgic init on injection outside the run l=
oop
>       KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt inj=
ection
>       KVM: arm64: vgic-v5: Add for_each_visible_v5_ppi() iterator
>       KVM: arm64: vgic-v5: Move PPI caps into kvm_vgic_global_state
>       KVM: arm64: vgic-v5: Remove use of __assign_bit() with a constant
>       KVM: arm64: vgic-v5: Drop pointless ARM64_HAS_GICV5_CPUIF check
>       KVM: arm64: vgic: Constify struct irq_ops usage
>       KVM: arm64: vgic: Consolidate vgic_allocate_private_irqs_locked()
>       KVM: arm64: vgic-v5: Drop defensive checks from vgic_v5_ppi_queue_i=
rq_unlock()
>       KVM: arm64: vgic: Rationalise per-CPU irq accessor
>       KVM: arm64: vgic-v5: Limit support to 64 PPIs
>       KVM: arm64: Key CPTR_EL2.E0POE propagation on FEAT_S1POE
>       KVM: arm64: Wire AT S1E1A in the system instruction handling table
>       arm64: cpufeature: Expose ID_AA64ISAR2_EL1.ATS1A to KVM
>       KVM: arm64: nv: Avoid dereferencing NULL VNCR pseudo-TLB
>       KVM: arm64: nv: Hold kvm->mmu_lock while initialising vcpu->arch.vn=
cr_tlb
>       Merge branch kvm-arm64/no-lazy-vgic-init into kvmarm-master/next
>       Merge branch kvm-arm64/nv-fp-elision into kvmarm-master/next
>       Merge branch kvm-arm64/nv-granule-sizes into kvmarm-master/next
>       Merge branch kvm-arm64/pkvm-fixes-7.2 into kvmarm-master/next
>       Merge branch kvm-arm64/vgic-v5-PPI-fixes into kvmarm-master/next
>       Merge branch kvm-arm64/misc-7.2 into kvmarm-master/next
>       Merge branch kvm-arm64/nv-mmu-7.2 into kvmarm-master/next
>
> Oliver Upton (5):
>       KVM: arm64: Don't leak PFN when kvm_translate_vncr() races MMU noti=
fier
>       KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vnc=
r()
>       KVM: arm64: nv: Inject SEA TTW when desc update can't write to GPA
>       KVM: arm64: Restart instruction upon race in __kvm_at_s12()
>       KVM: arm64: nv: Restart stage-1 walk if stage-2 desc update fails
>
> Sascha Bischoff (9):
>       KVM: arm64: vgic-v5: Add missing trap handing for NV triage
>       KVM: arm64: vgic-v5: Atomically assign bits to PPI DVI bitmap
>       KVM: arm64: selftests: Add missing GIC CDEN to no-vgic-v5 selftest
>       KVM: arm64: selftests: Cleanup unused vars in GICv5 PPI selftest
>       KVM: arm64: selftests: Improve error handling for GICv5 PPI selftes=
t
>       Documentation: KVM: Fix typos in VGICv5 documentation
>       Documentation: KVM: Clarify that PMU_V3_IRQ IntID requirements for =
GICv5
>       irqchip/gic-v5: Immediately exec priority drop following activate
>       KVM: arm64: Fix arch timer interrupts for GICv3-on-GICv5 guests
>
> Vincent Donnefort (4):
>       KVM: arm64: Reset page order in pKVM hyp_pool
>       KVM: arm64: Fix __pkvm_init_vm error path
>       KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate=
_host
>       KVM: arm64: Set a Linux errno on SMCCC error in kvm_call_hyp_nvhe()
>
> Wei-Lin Chang (5):
>       KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
>       KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
>       KVM: arm64: nv: Use literal granule size in TLBI range calculation
>       KVM: arm64: Fallback to a supported value for unsupported guest TGx
>       KVM: arm64: Fix block mapping validity check in stage-1 walker
>
> Will Deacon (1):
>       KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
>
> Zenghui Yu (Huawei) (1):
>       KVM: arm64: Remove @arch from __load_stage2()
>
> tabba@google.com (4):
>       KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM guests
>       KVM: arm64: Free hyp-share tracking node when share hypercall fails
>       KVM: arm64: Avoid host/hyp share desync on unshare hypercall failur=
e
>       KVM: arm64: Roll back partial shares on kvm_share_hyp() failure
>
>  Documentation/virt/kvm/devices/arm-vgic-v5.rst |   6 +-
>  Documentation/virt/kvm/devices/vcpu.rst        |   7 +-
>  arch/arm64/include/asm/kvm_host.h              |   8 +-
>  arch/arm64/include/asm/kvm_hyp.h               |   1 +
>  arch/arm64/include/asm/kvm_mmu.h               |   3 +-
>  arch/arm64/kernel/cpufeature.c                 |   1 +
>  arch/arm64/kernel/hyp-stub.S                   |   4 +-
>  arch/arm64/kvm/arch_timer.c                    | 137 +++++++--------
>  arch/arm64/kvm/arm.c                           |  41 +++--
>  arch/arm64/kvm/at.c                            | 146 +++++++++++----
>  arch/arm64/kvm/emulate-nested.c                |  12 ++
>  arch/arm64/kvm/fpsimd.c                        |  26 +++
>  arch/arm64/kvm/hyp/include/hyp/switch.h        |   2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h  |   3 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c             |  21 ++-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c          |  37 ++--
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c           |  21 ++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 |   4 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c               |   2 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                  |   4 +-
>  arch/arm64/kvm/hyp/vgic-v5-sr.c                |  82 ++-------
>  arch/arm64/kvm/hyp/vhe/switch.c                |   2 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c                   |   4 +-
>  arch/arm64/kvm/mmu.c                           |  39 ++++-
>  arch/arm64/kvm/nested.c                        | 234 ++++++++++++++++---=
------
>  arch/arm64/kvm/pmu-emul.c                      |  31 +---
>  arch/arm64/kvm/sys_regs.c                      |  20 +--
>  arch/arm64/kvm/vgic/vgic-init.c                |  45 ++---
>  arch/arm64/kvm/vgic/vgic-irqfd.c               |   6 +
>  arch/arm64/kvm/vgic/vgic-its.c                 |  21 +--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c          |   9 +-
>  arch/arm64/kvm/vgic/vgic-v5.c                  |  51 ++----
>  arch/arm64/kvm/vgic/vgic.c                     |  33 ++--
>  arch/arm64/kvm/vgic/vgic.h                     |   3 +
>  drivers/irqchip/irq-gic-v5.c                   |  13 +-
>  include/kvm/arm_arch_timer.h                   |   7 +-
>  include/kvm/arm_pmu.h                          |   5 +-
>  include/kvm/arm_vgic.h                         |  19 +-
>  tools/testing/selftests/kvm/arm64/no-vgic.c    |   1 +
>  tools/testing/selftests/kvm/arm64/vgic_v5.c    |  10 +-
>  40 files changed, 651 insertions(+), 470 deletions(-)
>

