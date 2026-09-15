Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335493BB10C
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482305; cv=none; b=nG/41yX2yFmMytOFPwXnyzdNBzpF/oaSv4y/5CLm0mpYmD3JX8dFMzA0EcKaChA0gcHTBfkU/efR/pVOTq2msX29cuBK1ZFoaQsmfO2P02bKM0exK/cY6F6PvsFrn6rZRgXfAQzC/0DFaNcn239ltQAQLp0ApZ2mEvtUHauGG9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482305; c=relaxed/simple;
	bh=8mB/84XSzLWci86yLhGv7ckIJ/MKNaS0kbBnHtIQq3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ew6thAAWrCOzQEh7k6uCNabtlA0P1A4by69odIIVybxbY4bu1PRohZroz9BreRlJZYJC1gC2EIVaHadHNr4yCmSjORsw4IIOESkBZ9dmxPvpMCI5fjx8C6Q3m0ZT7Xjmv8wv4UJIw+nuJS06bih8tRMMtSKK9B3EQVpzl1QHKCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l3g1gFvK; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l3g1gFvK"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8mB/84XSzLWci86yLhGv7ckIJ/MKNaS0kbBnHtIQq3I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789482301; v=1; x=1790087101;
 b=l3g1gFvKBEV+ujW1zQL621t++NUT8KUoYTP59bY5Gi2FOIhUU/oHs3kUd3ZapJ5Ng9Isay25
 Ro6tLcMCaAMCzMq+X9zf71qS+Snww4CPV8dCvnYGcsZl+60mzAH/a51H0ORU8gttxpKqeFKqsW3
 bd95jGsk4n+nSKJHTGQM4OBE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a34d87738ffef021;
	Tue, 15 Sep 2026 14:25:00 +0000
X-Mizu-Trace-ID: a34d87738ffef021
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so485e87.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:24:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcpSj5J1CI5SDpr17AclHBI6/JZ8UH2FvHuj3uYUG8D0S0EApiQXU2r44m/VhA1JEhjLgdsnw=@lists.linux.dev
X-Gm-Message-State: AFuF++lPm1sgUcbeUzkIXtRAmCcE6t5o2AR6rECyx14TsBKpn6CWJQ9E
	c8IR7RpPjov7YA64Xb/LQHFfOaHO3MrkWIAiEjxrEHwUpqGzBms6tS5C0bxY1GzNaMy6A8Sq8Bg
	x1lEhtfiUx1qlrC+R2dt5bV0D8sQovAwv0QGDP5OI
X-Received: by 2002:a05:6512:224d:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b8b2d0dd46mr158308e87.2.1789482295897; Tue, 15 Sep 2026
 07:24:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-8-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-8-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 15:24:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxCEfXeS+HHyZTcz2noKDXpWh9ZNdKUvnKoRhsDh5gwGQ@mail.gmail.com>
X-Gm-Features: AcwNN1WdffUDGaH0K4qtZGCCLrjwJKbs1nT14K5OlGCk62Z_-efTBPCTagEvW6Y
Message-ID: <CA+EHjTxCEfXeS+HHyZTcz2noKDXpWh9ZNdKUvnKoRhsDh5gwGQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Shadow the ITS command queue and
 setup emulation
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, tglx@kernel.org, vdonnefort@google.com, 
	vladimir.murzin@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Seb,

The approach looks right to me. A few things I'd fix, though:

On Fri, Aug 07, 2026 at 04:43:16PM +0000, Sebastian Ene wrote:

[...]

> Co-authored-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Could you switch this to Co-developed-by: and add Bart=C5=82omiej's
Signed-off-by after it?

[...]

> +void pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 off=
set, bool write, u64 *reg,
> +                              u8 reg_size)
> +{
[...]
> +        for (reg_handler =3D its_handlers; reg_handler->access_size; reg=
_handler++) {
> +                if (reg_handler->offset > offset ||
> +                    reg_handler->offset + reg_handler->access_size <=3D =
offset)
> +                        continue;
> +
> +                if (reg_handler->access_size < reg_size)
> +                        return;
> +
> +                if (write && reg_handler->write) {
> +                        hyp_spin_lock(&priv->its_lock);
> +                        reg_handler->write(region, offset, *reg);

The match could require the offset and size to be exact. The handlers
ignore offset, so a 4-byte access at GITS_CWRITER + 4 matches this
entry and runs as a full 64-bit one. (Sashiko)

> +static int pkvm_setup_its_shadow_cmdq(struct its_host_state *host_state)
> +{
> +        u64 start_pfn, num_pages, i;
[...]
> +        start_pfn =3D hyp_virt_to_pfn(host_state->cmd_host_copy);
> +        num_pages =3D host_state->cmdq_len >> PAGE_SHIFT;
[...]
> +        ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(host_state->cmd_o=
riginal), num_pages);

Should setup take the base and size from GITS_CBASER and reject a
mismatch? Nothing ties cmd_original or cmdq_len to it, so a wrong base
leaves the ITS on the real queue the host still writes, and a short
cmdq_len runs the cwriter_write() memcpy past the donated pages.
(Sashiko)

> +unshare_cmd_host:
> +        if (i =3D=3D 0)
> +                return ret;
> +
> +        for (i =3D i - 1; i >=3D 0; i--)
> +                __pkvm_host_unshare_hyp(start_pfn + i);
> +        return ret;

while (i--) would do it. i is a u64, so i >=3D 0 always holds and the
loop wraps at zero instead of ending. (Sashiko)

> +        priv_state->base =3D (void __iomem *)__hyp_va(dev_addr);
> +        priv_state->cmd_original =3D host_state->cmd_original;
> +        priv_state->cmd_host_copy =3D host_state->cmd_host_copy;
[...]
> +        its_reg->priv =3D priv_state;

An smp_store_release() here would order those writes and the memset
above against the region->priv read pkvm_its_emulate_handler() does
locklessly on other CPUs.

> +        ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(priv), priv_num_p=
ages);
[...]
> +err_with_priv:
> +        WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1));

priv_num_pages should come back here, not one, or the rest stay
hyp-owned. (Sashiko)

Cheers,
/fuad
