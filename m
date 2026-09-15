Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C954CA769
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789498319; cv=none; b=ZAgzlNJEKbx3QwtbdkiDJ5RwTPAOvOP+fu0u2NwGYa6uaGaUIp48+Xf8/nlXL8F7a+UzxjDIZ0fSuLmFfb9Hxs5LbxVAaI1C2RZsssvpI/H/A97zI/QHSaI2E1tCkr7xk8mP1Xv7GP0TpuedqhlfUr2JBLUXs3A6uNsHC9JyJII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789498319; c=relaxed/simple;
	bh=wDUSmz48AJ/AWECTgc5Y2mr8+N5AQyAKi5Db/DMYbBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LiM8nlrAkySbygzOICLGKGMi9SLiwE5boiWplcRqYli2PkyDvFge2vIkkH8Kq9l0wN1tKRFoxDSEK1P9m2LNLbppUzBnpbyXHk0iGw4JLnYkMy0nGgIiuw/wH5xLB81nFZ/av5+4GajOoJWlvdVKkzc06BVt9UdAi/cC18hIV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YwULGCbN; arc=none smtp.client-ip=91.218.175.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YwULGCbN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=wDUSmz48AJ/AWECTgc5Y2mr8+N5AQyAKi5Db/DMYbBU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789498313; v=1; x=1790103113;
 b=YwULGCbNeyF4AmcA857Udq8L1yp/B/HyiTnIpiduALFGUvjOTp4riKwKMnfh+dBlb+LEwmjl
 T+BlpckF8p4capP4szk1N1Z9bp/tFRurkEgNl0kV78050/5UwWiUsvTIs76taIkcxpDsdGT2ik6
 8M6qPF5ZXoz1cdWfdBo13Zgw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 506e1a48f87465cf;
	Tue, 15 Sep 2026 18:51:53 +0000
X-Mizu-Trace-ID: 506e1a48f87465cf
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so1316e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 11:51:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxMQXxG5yGwinAYncDhOyLhjXPhomJC7475sy8Lw28X24oDjedBzTi8avB1mWtDHT//DX1oF/s=@lists.linux.dev
X-Gm-Message-State: AFuF++mOcMYMgAAZRtlURgqEATj+RgJmtv6PwvQkjLAN/tDQPjWjeLCN
	qSyRVLptueXSGicIFZq3W8RUn3kNx6UTmWQnd4/kj2ywcXb+JZH4xX9Z4tpu0qbnvXwoCLTkDkm
	6ylYwJKU5HW8GaOh+xM4K9S+AW8kr5ROmUzpqtV5H
X-Received: by 2002:a05:6512:460f:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b8b5c60361mr12106e87.2.1789498308370; Tue, 15 Sep 2026
 11:51:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260911104715.307500-1-fuad.tabba@linux.dev> <868q5579ol.wl-maz@kernel.org>
In-Reply-To: <868q5579ol.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 19:51:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw0U0d91Cv4NYEJvUuT=JabwZeeYwpZ2P1xyVeOVX46Ew@mail.gmail.com>
X-Gm-Features: AcwNN1Wb_8an225Gnc8YhJ9UZVooFr4-IDtabofiCqvpuVnTcerWsfiGT6Va1mE
Message-ID: <CA+EHjTw0U0d91Cv4NYEJvUuT=JabwZeeYwpZ2P1xyVeOVX46Ew@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Xi Ruoyao <xry111@xry111.site>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Gavin Shan <gshan@redhat.com>, Yuan Yao <yaoyuan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 13 Sept 2026 at 11:00, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> >  static void cpu_hyp_init_context(void)
> >  {
> > + u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> > + u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> > +
>
> Why not directly read_sysreg(id_aa64pfr0_el1) and co?
> __read_sysreg_by_encoding() is useful when the encoding comes from a
> variable, but it looks odd in the case of a literal sysreg.

It applies the arm64.nompam override, which is what
finalise_el2_state() tests. With the override set, EL2 setup leaves
the MPAM traps alone, and a raw read_sysreg() would still see MPAM in
the ID registers, so KVM would write MPAM2_EL2 on exactly the firmware
the option exists for. I'll add a comment.

[...]
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
[...]
> > @@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
[...]
> >   /* trap guest access to MPAMIDR_EL1 */
> > - if (system_supports_mpam_hcr()) {
> > + if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
>
> This is going to suck under NV. The host hypervisor is of course going
> to set MPAMHCR_EL2.TRAP_MPAMIDR_EL1, and we're in for a recursive trap
> on the hottest possible path in KVM. Which is silly as the actual
> write to MPAMHCR_EL2 is free (it lands in NVMem[]).
>
> This really should be replaced by a flag called HAS_MPAM_HCR, just
> like you have HAS_MPAM.

I'll probe MPAMIDR_EL1.HAS_HCR once in cpu_hyp_init_context(), next to
HAS_MPAM, and test the flag in both trap functions instead.

I'll hold off on v4 until Will has had a chance to comment as well.

Cheers,
/fuad
