Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635111;
	b=xjgB7h/vHpk2rEQ/BrpgEUvtvbWV/LheqVeWzd2mTMS/yad20NAF1f4bvq1p9cfmrfVp
	 E83kYFf1I8VMdYUAxm9P5sQ5lpabU8lrC0CWBmXkQYyNImLGDBCUv++pAR/z8uxOTWwq2
	 LPOVl8dvZYRDfEf/IP98e1ztm5pzvOEo1/uGkzFiYrI/olvS5PsNg0AtLqJNZRFvrJyiW
	 kQ7S64tck1LnE4+34m5bxKtrZkIwTYaK/+xgkTn1CHECtuMVPgcycy7K5zUu8zt74Fcci
	 2Vc4jhbkKaCkDd0OGN6f7Q2mxFxUb5CaP0isjQQ4l1oWdv2j/JE7UBj8bwePFRBmUdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635111;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Zqk5EosFBXrVefcK+m2mlV2/eICrUeTU+WY9gyPrY4E=;
	b=zOs3XYojRJF0tP56c3jDGLvCxmERVumtVqF1n4M2IRvZ3F88DN7SPACiFEaM86zbxGm3
	 9+DsGCyikEGb5mCEmboZr52wQI3Pw/Jg4254hJG/KFgQ20LOPic90//1LEuA+TQVPsFV7
	 FufB7kPXECbqgmSG/CL68m0wm1w7BFjno/TVPafUFMAAYKWz6d5Ena90b4HxUmD4GeIH4
	 boqP3FHs6uhpg3jeeHJnlZ5OA6ZFLWEkI2dtFwy8jC80UJMuuDahTByAfnySfosEAxigU
	 0eRGw1H43zrdduWyDd/bzGmAesgx5hjHYelibQJfL+9LgEBg9larUsOFyX6Zxy4HP3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QwNXfuJw;
	arc=none smtp.remote-ip=91.218.175.45
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C676075282
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 15:58:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5C676075282
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QwNXfuJw
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IOueXIDbWvxDU66CPZpA4KpxoAIR1G1INRDIBFHDNvQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793635108; v=1; x=1794239908;
 b=QwNXfuJwaKs1o4ABMkLKUVBTCEyDR+KMCnAl6GNrPDGAjd+qbTg0t0bHDuIUAMIbUjAcHF8v
 8mPYURAhbPvsKXAmF6G9j1a+58gv/UMhQnnJISBh+o7LVOrpq7zfTFHRjeUqOD0FX1mnPDxuwqq
 uq9GSSNH4MOVO+1aL1OlDQXM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cfd6e5551e85fa68;
	Mon, 02 Nov 2026 15:58:28 +0000
X-Mizu-Trace-ID: cfd6e5551e85fa68
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so11208e87.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 07:58:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx76CiLn1qKk99cHMvklkUqmGPqqFGqb4TKlhc6rLqAcSKlTBiF3g/Ea+DVnCeaTugHADMTTUs=@lists.linux.dev
X-Gm-Message-State: APuU4Z+fzh3KmYTpEL07rO4jIxc2z5EjA/kLRVPfFMqIxicIIGRy8rbq
	2EFh6YZfSFZeq93wKW8uyaTQuTxXTf1jlTYbVaZKye/z43Qg5w7uij1OZSNucfSSa32f5OITqyK
	yedX4pD/SPjJuuiJ7jFP/mWAodEoKco0qpgfFe0yY
X-Received: by 2002:a05:6512:118f:b0:5bf:a911:7ee3 with SMTP id
 2adb3069b0e04-5bfd13d8cdbmr607141e87.3.1793635107619; Mon, 02 Nov 2026
 07:58:27 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102094748.2638468-2-ardb+git@google.com> <auiXMN5td-2QlDkd@willie-the-truck>
In-Reply-To: <auiXMN5td-2QlDkd@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 2 Nov 2026 15:57:51 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
X-Gm-Features: AclHuK9bY5GhZz09yeG7qP1mqDl9dnGaY92IKxCsC7wirWm_wSZDIj5t5JuS5VU
Message-ID: <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault IPA
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 02 Nov 2026 14:17:10 +0000, Will Deacon <will@kernel.org> wrote:
> On Mon, Nov 02, 2026 at 02:09:25PM +0000, Marc Zyngier wrote:
> > On Mon, 02 Nov 2026 13:59:12 +0000,
> > Will Deacon <will@kernel.org> wrote:
[...]
> > > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
[...]
> > > >  static inline bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu,
> > > >                                                 u64 *exit_code)
> > > >  {
> > > > -        if (!__populate_fault_info(vcpu))
> > > > +        if (!__populate_fault_info(vcpu)) {
> > >
> > > Presumably we need a barrier (DSB?) here, to ensure that the TLBI happens
> > > after the AT instruction?

I don't think the TLBI requires a barrier before it, because it
doesn't matter if the AT's walk allocates entries after the TLBI.
Anything it allocates matches memory, and the stage-2 descriptor the
AT faulted on has AF clear, so that descriptor can't be cached:

R_XCLRD: Translation table entries that generate a Translation
fault, an Address size fault, or an Access flag fault are never cached
in a TLB.

The stale entries the guest keeps hitting were already there before
the TLBI, and the dsb(nsh) and isb after it are what complete it
against them.

[... your other reply ... ]
> > Alternatively, VMALLE1 or even VAE1 should be enough to get rid of the
> > S1 TLB.
>
> Ah, sorry, VMALLE1 is what I meant to ask about. I basically haven't
> understood the need to invalidate the stage-2.

The guest's walk can also go through a stage-2 entry for its
page-table page, cached before the aging cleared that page's AF, and
nothing requires the AT to use that entry:

R_NPZWX: When an address translation instruction is executed, it is
IMPLEMENTATION DEFINED whether the result can be returned from a TLB,
or a translation table walk occurs.

So if my reading is correct, on a CPU whose AT walks memory instead,
the AT keeps failing while the guest's walk goes through the stale
entry, and the guest takes the same permission fault again. VMALLE1
and VAE1 only cover stage 1, so they'd leave that loop in place.

Cheers,
/fuad
