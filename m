Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908184;
	b=24uQpHx1aKFxLbJfhdms7C3xTKzI+VCa7H1hAUjrEU5kjch9rb+1WY+fs8ERNA9s3Sa+
	 4DiBu7teLelyUy8fvTRh+dgyyw3Avxr0ZuIvdn/P0z1Vt5Sq0a6W4KNcpgJpcbcqks2A6
	 EeUpK96vju/3Tg85SsoSTIFQrG/lpAgqELI+u/KHoxnvgvjVtl3wboSONhWpDo8q/0zg2
	 xx2MyjAZFFHSSM6louq0XOFP/MuCXdnjXwjlgJDPc4ok0zddM21a84IwflFpiH+OTej9H
	 TdSBpVB7cWYQsxPCRAqDPBLP3XB3UdommbtoQhNjx+Rz+YUvxuC7KKa6B17ijwlY5BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908184;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Ohk8fjJcBK9UzrBV+dt2XFBrhhVb8zdE0nF0K/taFC8=;
	b=TXU+/6IFD+oQDb4BnUh+QZn6S7L+u2zOk2ZMcSUo+QBeM9Er532h0zp4q7OPLy3nBMu7
	 nP1+J+lA/wyYm9Uf0s7lRj1fQ7MxHZ9TeaexN/vRLCM83cETWHpdi7dLL4k2r2MOQfoSp
	 jgUotzhlVS6ffBjs2rBNTIrFLpqeShqNWX5PLW02d3OlzTXYFSmncI4I9/Xj657Yfhs4Q
	 Sqcov5qu7za55O98VUJVMCVqDuo5emoWhAg7QQb0n60Iv/sUlK7mHDqoXGbgrZ891AFib
	 ZH2lEOtn0E1+abfYHf/ZHGLqLmvwukaXNMZQzEmXZRRMjET1RonfEDtWVo9Ai5PZ/4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TLyqchkq;
	arc=none smtp.remote-ip=95.215.58.99
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE63C607531E
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 19:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE63C607531E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TLyqchkq
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ohk8fjJcBK9UzrBV+dt2XFBrhhVb8zdE0nF0K/taFC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793908179; v=1; x=1794512979;
 b=TLyqchkqOZt/DtlVYwdrSUXx/dQb2voUuzu/1DK0ROKF9lGdVixSHWdqSbho4P4ggx6CDdCK
 N1psN8/3tnUAlOBXHA8POiClwq8TTNpT7OaXx4ex9SQ6w96P2zcyob28/LC80FP1KwAMIBi2O8r
 aVnCkYn/uC7CQOhfUQxoKWA8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ea1550a6afc68c14;
	Thu, 05 Nov 2026 19:49:39 +0000
X-Mizu-Trace-ID: ea1550a6afc68c14
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so1444e87.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Nov 2026 11:49:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwZLrF6808rxmF7rksFFfmxLe4EjgMTp00tD2G6oP0fvowcDrCCfl3ZZeXf2ugkSNssfk//fTw=@lists.linux.dev
X-Gm-Message-State: APuU4Z+WJVIL6gCWStt8Dzs9XZODpYvl5ORB9v/M6lEQlPhxkgjwF1OE
	XsTpN+CjKG5eAFDG/rt2hPm8feLo2JxGutDSFBO5tH5vyHCoKbFWWHeebu4eYvfqWuxouYYadVt
	3EVaYFfi/1Ym13x/Jp5Da0LDI3D7XblDN9nRobZmX
X-Received: by 2002:a05:6512:33ce:b0:5bf:c3e1:532b with SMTP id
 2adb3069b0e04-5c0030a8446mr18363e87.5.1793908174490; Thu, 05 Nov 2026
 11:49:34 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104124451.2148724-1-fuad.tabba@linux.dev> <56rrmewwluy2iw52zmusrys3qfqcdhtsgzpqtskr6zt4xhmhfo@hzlwy5ol47kd>
In-Reply-To: <56rrmewwluy2iw52zmusrys3qfqcdhtsgzpqtskr6zt4xhmhfo@hzlwy5ol47kd>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 5 Nov 2026 19:48:58 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxms6TaXi1ghx=hPU3fG1EQUwQYeX+d0jjJ=AzhDv0u_Q@mail.gmail.com>
X-Gm-Features: AclHuK8cooP5vM3_YGu4N0f2LHYPXd6jDq8nHFV8TmXlzVrLCE4RbmmBQjeYTg4
Message-ID: <CA+EHjTxms6TaXi1ghx=hPU3fG1EQUwQYeX+d0jjJ=AzhDv0u_Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Stop stage-2 teardown scaling with the
 IPA size
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Wei-Lin,

On Thu, 05 Nov 2026 18:59:55 +0000, Wei-Lin Chang <weilin.chang@arm.com> wrote:
[...]
> I haven't looked very closely, but do functions that use
> stage2_apply_range() suffer a similar problem?
>
> If I'm not mistaken we previously realized unmapping a full IPA with
> kvm_vm_stage2_unmap_range() is slow partly for the same reason.

Yes, when the range is the whole IPA, as you found on your reverse map
series [1].

> I'm not sure whether optimizing stage2_destroy_range() and
> stage2_apply_range() together in a single series is preferrable though.

I think it should be a separate series. Returning where the walk
stopped was a small change for teardown, which runs on an unlinked
table with no lock held. The stage2_apply_range() callbacks are shared
(kvm_pgtable_stage2_unmap() has EL2 callers that treat a non-zero
return as an error), and the walks drop the mmu_lock between chunks,
so it's a different change. Only NV passes stage2_apply_range() the
whole IPA.

Cheers,
/fuad

[1] https://lore.kernel.org/all/eylfcgxs2xzu57czyuhkpmum45lpxyccyu2yh3mipr67aq3xo6@xinygxzavoja/
