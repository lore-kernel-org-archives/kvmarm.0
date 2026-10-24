Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.248
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826144;
	b=2aYySYPEa/QN61JRgCntEHzQdb6P2va+Bdhgbjm7dQGr1EK5w4w2GXb2SgcQoZ6bIidL
	 BZQoayLlscoXSIfj3IQuleN9foVb81LA17RIgMq0G3ndH1MHaEXjVkr5zH9tULbEzGk9r
	 /7Imn5rrYKo/unzOeO/h93I+7r/vFKw7OiDYHxESf7QjtaFzNrtSLWmIcLT+K+O/YRvLI
	 W29fCtfT6xOkzlM9Qv0YQ/S/bmmdq4rAaund5YUlQA8vxRLxg+hFfPo0eUlCuzpnMAWcu
	 sAx/tbhob6ysEUBdFbEcixg7P2Gl5EuuDyGXOqF+QfUBFKphhe388lLHhj8p3GbxhwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826144;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=xgVmkxubDRg1cJuzFYDYMiEdO1rVdRyOgY/ruAhYY2s=;
	b=TeL36547fTYzgTioP+NeWtpPft411FFSzgVe526otGSwZblhCmTTkQOx5y0yOip+fjAJ
	 4Nuc6uJOU3CMrLaeqxndEK48Byv/i90/kWYuOPb+tjxSgkReo5O9/I3gnyPhGpH57qE3J
	 0UALGB+JKP+6M7fjKg2iRxkvuhtDqse4IZ4CQ0U33ksxDAb3qg1fTe9Ai7muKbgFesmYn
	 i/pydlDsX8H+nLgb7Mlq03tpgyypxX/FcAgD4hKPneXLuYBWxL4fiMHEwyD/X6Bjcb0+i
	 yh4ofn7HiIShyRh7tBpztLY0/BNebPWbfQMcNugAXvUKVaBpM7vodwAaSa1P9bmCS0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Aq0BzqOU;
	arc=none smtp.remote-ip=95.215.58.248
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F483606A329
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 07:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F483606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Aq0BzqOU
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=fS8yvEoIwEhEI1jeJexTVj+BAmw6eQpccC70A0wbAfc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792826141; v=1; x=1793430941;
 b=Aq0BzqOUljMMR5tzh7Kyv5yeWxOAyaaYbi+YtLE2cbYreaefc5j4CG0NjIHVwo0ho3SqZvw2
 B3ItMWMKFEtqQK42Qs8JMJc5DwFX2OlfzfBZHUfNke7xZiq14Prb87oEQSVJi159DCwwACOL33r
 vimuLFtJZeiPgdofygAY/Xws=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d4f0141a09b42773;
	Sat, 24 Oct 2026 07:15:40 +0000
X-Mizu-Trace-ID: d4f0141a09b42773
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso2055e87.1
        for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 00:15:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZWBZvDBaAaMbFFu9hwAIlREP/lodnuCpoF91Bvz6s2MO90QaV0ndC9v4WCl22xAwy2oTsR+c=@lists.linux.dev
X-Gm-Message-State: AFq9FYK/uNyOQQa1U4nnKtfLv4e3ecNa79NkYUvBdcrFs5pjzkIM2/pD
	TMeox9ZJv89+aAlB1Z0PCgLONKaLvBKyokv5NQwLg+rM/gPn54JbElUNuj0GdcNdC+KNLsWrqGB
	5uEfthXYOt1WJEkLXetXDxHo0Xtk8EIDDIBDEBtor
X-Received: by 2002:a05:6512:3e1a:b0:5bf:b27b:6371 with SMTP id
 2adb3069b0e04-5bfb79f9850mr46341e87.10.1792826135785; Sat, 24 Oct 2026
 00:15:35 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
 <20261023070110.1833446-2-fuad.tabba@linux.dev> <86fqxwzul7.wl-maz@kernel.org>
 <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
 <86ecdgzp6m.wl-maz@kernel.org> <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
 <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com>
In-Reply-To: <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 24 Oct 2026 08:14:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com>
X-Gm-Features: AclHuK9QvFT6f4TAsNTrh2PdecgAYJ19yM-sYm9uDvK9gvirJINXHV46-ipXL60
Message-ID: <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Arnd,

On Fri, 23 Oct 2026 15:10:23 +0100, "Arnd Bergmann" <arnd@arndb.de> wrote:
[...]
> That sounds good. For reference, I have prototyped support for
> LS64_ACCDATA in Linux drivers based on the corresponding x86 code.
> The code is not yet tested on hardware, but it may help understand
> how this may be used in the future.

Thanks, that's useful to see.

[...]
> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
[...]
> @@ -254,6 +269,8 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
>          if (prev != next)
>                  __switch_mm(next);
>
> +        switch_iommu_mm(next, tsk); /* FIXME: is there a better place to do this? */

switch_mm() isn't enough when the same thread also runs a vCPU. In v2,
which I'll post soon, KVM will save and restore ACCDATA_EL1 only for
the guest, since nothing in the host uses it today. So after KVM_RUN
returns from a guest that has LS64_ACCDATA, the VMM thread's next
ST64BV0 would use the guest's value, unless KVM also saves and
restores the host's.

[...]
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
[...]
> +static bool try_enable_st64bv0(struct pt_regs *regs, unsigned long esr)
[...]
> +        isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
> +        if (!(isar1 & ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA))
> +                return false;

v2 will add an ARM64_HAS_LS64_ACCDATA cpucap, so this could test that
instead. As written it tests bits [1:0] of the register, not the LS64
field, since ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA is the unshifted field
value.

> +
> +        sysreg_clear_set(accdata_el1, ACCDATA_EL1_ACCDATA, pasid);
> +        sctlr = current->thread.sctlr_user;
> +        sctlr |= SCTLR_EL1_EnAS0;
> +        current->thread.sctlr_user = sctlr;
> +        update_sctlr_el1(sctlr);

On a host that runs at EL1 (nVHE or hVHE), this also requires
__init_el2_fgt to set nACCDATA_EL1 in HFGRTR_EL2 and HFGWTR_EL2, and
__init_el2_hcrx to set HCRX_EL2.EnAS0. Without them, the ACCDATA_EL1
access traps to EL2 and the hypervisor panics, and so does ST64BV0
once SCTLR_EL1.EnAS0 is set. Happy to write those and the KVM change
once you're ready to post this.

Cheers,
/fuad
