Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E25448BAD
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772371; cv=none; b=V1o9rvfw3wW3uAIqSjo90V1wmrkWrjMiziwcCl0CVfufacBAHqpMezZsywvC5lfjpo2hZMN6zG6jzDHLpDrqQ5HBFFNMvA9NIz2OUnLm1cVGvSBdPqpJn6Vrpih7kc1rdd8XEPFS0Q9Y+VuPgFtv01AuGAtTzJ3vMXOuUwU96eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772371; c=relaxed/simple;
	bh=b5mlbXk6fTQVCjjSD+1qABe2aGImP9DMon8rowjjymw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBujPFzik6dM91D9XQWR67c4Fg1ADJW+9i2FUjxOAq8zsZk3GZsX5fLXL9gdXmHpxS0/rNQ5Kc5BT7ieJe7MJVkES3i9IsCav5PmHPU0NjFW7Y7bnBwWGOq/IdablSYuEPyyAsLHojsl/6iXSo+vIuO90Hr5NdOKeIiIOe0oINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nL1F9MnP; arc=none smtp.client-ip=91.218.175.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nL1F9MnP"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=b5mlbXk6fTQVCjjSD+1qABe2aGImP9DMon8rowjjymw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788772365; v=1; x=1789377165;
 b=nL1F9MnP/nvDGrt65GRm2JG0PhRlMYIprqvnnaN//c9FGNJv3Q8T7lMdyKxbLjHi+iWE5CuP
 aDv4Zb28aBvxRGRG0VSgb9I/nj+L2JDcsrtmOKfFopIm+kkjoRfndu0ZnjaKe36ASJdPBK3wW6z
 MSLzx2FTUhgbYtxOBhEfLKOs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c3f1ca538e05a060;
	Mon, 07 Sep 2026 09:12:45 +0000
X-Mizu-Trace-ID: c3f1ca538e05a060
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so7288e87.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 02:12:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxZ62HopARerVs9uddeTUkrJZ9AfQWzyCl8GGfBFwrPdfY21qkNgxZW50SFO6g3FIv2wZeUjFw=@lists.linux.dev
X-Gm-Message-State: AFuF++kaqyYYZJgt5+FSh7Qh5Iq7fzwE83pMj7kRNeN+7d5DXfG23ZHx
	g+XouEInKY19jE4/Ji9H/HVVFu/7PrqDPX2I+YGeuIM4ZvUES0Wm1M7VMeobl2gDwNJbRyAYrKy
	AFOb3rC8M/kHDwyzL679TqH9usoDtjM3E6+K1jqM5
X-Received: by 2002:a05:6512:33ca:b0:5ae:b0ee:f737 with SMTP id
 2adb3069b0e04-5b74d2f95d7mr138507e87.9.1788772360628; Mon, 07 Sep 2026
 02:12:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-7-fuad.tabba@linux.dev> <20260907071617.2BB6D1F00A3A@smtp.kernel.org>
In-Reply-To: <20260907071617.2BB6D1F00A3A@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 7 Sep 2026 10:12:04 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy65qJ3XJt755JsUGgSMekqkd6t3Jd3hvY3iN1xsJucqg@mail.gmail.com>
X-Gm-Features: AcwNN1WaNCUb5rkXGyfhe_y7Hsn2qMzl61r6PtrL0PEg_-AyW6g7mNs0iZLRpYw
Message-ID: <CA+EHjTy65qJ3XJt755JsUGgSMekqkd6t3Jd3hvY3iN1xsJucqg@mail.gmail.com>
Subject: Re: [PATCH v2 06/17] KVM: arm64: Add system register reset framework
 for protected VMs
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sept 2026 at 08:16, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Medium] Missing EL1 system registers from the pKVM reset array `pvm_sy=
s_reg_reset_vals`.
> - [Medium] Invalid numeric comparison (>=3D) over sparse `enum vcpu_sysre=
g` values to enforce fragile array sorting.

Nope...

> --
>
> commit 7a5dc29475a7c4550659db2df410ae56a785635e
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> Subject: KVM: arm64: Add system register reset framework for protected VM=
s
>
> This patch introduces the system register reset framework for protected V=
Ms,
> adding kvm_reset_pvm_sys_regs() and its driving array pvm_sys_reg_reset_v=
als.
> It populates reset values for sysregs that need to be reset to UNKNOWN or
> explicit values for pKVM guests.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 8758c68017765..03d2c2447e0fd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
>
> [ ... ]
>
> > +/* Sorted ascending by reg; kvm_check_pvm_sysreg_table() enforces it. =
*/
> > +static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] =3D {
> > +     RESET_FUNC(MPIDR_EL1, reset_mpidr),
> > +     RESET_UNKNOWN(TPIDR_EL0),
> > +     RESET_UNKNOWN(TPIDRRO_EL0),
> > +     RESET_UNKNOWN(TPIDR_EL1),
>
> [Severity: Medium]
> Are we missing several EL1 system registers from this array? The commit
> message mentions this table is supposed to hold the registers that
> sys_regs.c resets to UNKNOWN. However, it seems to omit several newer
> architectural registers (like PIR_EL1, PIRE0_EL1, POR_EL1, POR_EL0,
> TFSR_EL1, TFSRE0_EL1) which __sysreg_restore_state_nvhe() explicitly rest=
ores
> for a protected vCPU.

It doesn't restore any of them for a protected vCPU. PIR_EL1,
PIRE0_EL1 and POR_EL[01] are loaded only when the VM has S1PIE or
S1POE, which pvm_calc_id_reg() never sets (it returns 0 for
ID_AA64MMFR3_EL1), and TFSR_EL1 and TFSRE0_EL1 only with MTE, which
kvm_pkvm_ext_allowed() doesn't allow. The table holds what the switch
loads, as the message says.


...
> [Severity: Medium]
> Is it safe to use a numeric comparison (>=3D) over the .reg field here?
> Since pvm_sys_reg_reset_vals[].reg contains enum vcpu_sysreg values,
> and these are indexed by their VNCR-page byte offset rather than in
> declaration order, a layout change or new enum value could reorder their
> integer values.
>
> If that happens, the static array's manually sorted order would break,
> triggering a fatal BUG_ON() at boot during hypervisor initialization.
> Should this enforce an explicit allowlist or a different sorting mechanis=
m
> instead of a numeric range check?

Nothing searches the reset table: kvm_reset_pvm_sys_regs() walks it
linearly, only pvm_sys_reg_descs[] is searched. The check on it buys
nothing, and I'll drop it in v3.

/fuad


/fuad
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.33=
33525-1-fuad.tabba@linux.dev?part=3D6
