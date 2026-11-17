Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794927837;
	b=iboA+CjsOpjRupLsyoZ/m2mlmolfA0ipSTSMuPu4+5j5fobqQLZiRYR3IsCyt0holK8c
	 GrpALsMKoU3ZxJW4ReOF6BoXbv4TC6XWRwAvHFBLvK1WbLaf+mwPuqvj+zg+apiGfo2A+
	 z4lAGReLbZqKEi+1U/cV6UPEYGBgeQ1MYcLh5KJYN/W2WGiHToQLWpxjrUdSiOChgBkAf
	 KHjJXjg3ZbH7y2qmIwje8HxuVvy2ZS/YYcW3btnou0pIAbvYZFpP3Na+OTAzLLv2pV0z+
	 nINlvTXYO+3M9DOBCsWPsFmCCv724Fqe+Nm0pf+W5YWt9XcVDNfWj8sjlZ9CmT6octA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=UR0Gfgv/fdEsWHImhEXrlTh92/mXRBGXB0/jlnan5Vo=;
	b=A59Qe3oaO++FfEUaZrPv0rAPWxjzrBUsGNzfm+bd3HPNgzy2ayUTGGnxl8xGhh9C9tI4
	 K/HWZN4wgR9S/ELfmRrDRlVFW+F+tArIBjwo5w3VsNdFnkd40XmVsJAoWi3dq4C50cf2/
	 Ku1zW9Sot/pW2QXac7mI+8ADfk/Q91J9N0FS+PQBF3OH/2k+2XxpUVYCZCA3jd3yeoYLu
	 PK/AFjZ9HQgxyz3sipwrhmFWZBUBRrrg0w0azk7FjOfMrixFqilLLD28YG9Vz8shQ7uZh
	 w/UVggSxXkFEcPzOlt/HyMoCoj7mOkPBr1fSiYkEPxqrdmwncehb9dLn+rQqJ0YwVYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nAqLFQJM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8093E606A32F
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 15:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8093E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nAqLFQJM
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so10201e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 07:03:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794927835; cv=none;
        d=google.com; s=arc-20260327;
        b=qk7B9Ki1LyQkAPszLpMFSNZlcuDGFqREF8lsu+eaRbbb0ATZUV+sd59aMJnyK5fnGN
         YIuQMcIxJyqJZkBQL95onOxSuCzN095P5tsticE6fUgAmBYpvZG12A89o272d8DUhpth
         WefUNKCYhv7ECT8sIoREiFEgoo/LgVaxPNG3C3JUNlgez3Nr535hN2MCSRmGXnqVDXeL
         D+lUK5bCjND44ycotmfCPU2p7vrr43dx/dHfn+ZSwz6RBDfGZA/Yit9NJXUEQH8DV/UQ
         1EuNkmnEPc7xj7q0jIstYki2/syNYceaQ9iNPvycE+eYBUjyqbOqXZMZlVLmRb201nZL
         RP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UR0Gfgv/fdEsWHImhEXrlTh92/mXRBGXB0/jlnan5Vo=;
        fh=uOxQBHs97p2MaRfGAGmAn6ACKVPVSF8Q0YIMiM56/wE=;
        b=QAZZfowU52L1sGgbHiW5hesLp0RWuiYdQrJP1cPxZUtKb6ua9cjJsUaKoutI+F28y8
         lcrKie/nR7FkQcu4tRD05QmJ2m+wn1KNr1K/F9Z5vGks94sGeyN6vkj6OuK6KZY1rfCi
         EnXJY1b9ZQLX8Kp1e8HLir9KAGCfyfzYdckZQJEB2dzr+S6fzda/z6zSJspuiwqFePCH
         mXsXYKu5YN3BGwF49GIbn5wy+kUWaE/4m7emaBy44MQPu6yoV/zd6kRgo8NKn8UNfjjh
         yaRyGp/iUYuBQ5bEgnSf0dbgzWula6/N/CeuYAlbaUjhvoqJ8l57TMIMkacNY2v8oX48
         EIHw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794927835; x=1795532635; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UR0Gfgv/fdEsWHImhEXrlTh92/mXRBGXB0/jlnan5Vo=;
        b=nAqLFQJMoe4GapOS4ddm5TFvMsplyb7Cn85pFXrd8SKGVbDDh2r7u2T7wqHvcOOLrc
         PyANY/tr0UA+Y4DrZXaQxdeNjNocQ30wYH7a6a1eyKQ5F+HuQAxxN3BEbIT+56BM3pJe
         O8DUTlzfS82ASOCw5Umj41OopgvSrmxE0/IRhD1weob6jy466dkxrp3fGlSOMUo2rxme
         Ot954oUSp01eT9nAA2OcTLL6zpFftiHNI0OnJkLAwgwWdZjb2VWDRKpbkEnBE16swYV2
         FVBhtYZnBUhVTXjQjROkwQP6KRt5l9rWKV5A1Wy/6diX9Dr9lG25lMm8ElIxKBT2XC0N
         IWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927835; x=1795532635;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UR0Gfgv/fdEsWHImhEXrlTh92/mXRBGXB0/jlnan5Vo=;
        b=Wj2VvIk6lzKpGQnGgr4/CpQDYtQZcb4vl42r8vLBQ93f4ALESVslrwYtyVNajlnQ4S
         Ve2jAPUzdWbFrQLfQf+rmSj5j1kTA/cvsaIew/f08eFBv4ILScInRm93vZFlzU3kJ/T9
         LrQEqLzjTFqXdv6j7fNw97uDDIv18Xc25wEoCLrMHvzWz6vA2rlQMfUqwU66N+3SPKek
         Yfsarl5iFpnBeMeKrBoaq/DSeiyJAGY88d51giqVWrokb773sZyV5cfghZVTDxasA6N5
         l5HBvm6TaobfbO3xk+mkyT0Ze/YrauMeWP6TgRYmNArKG4Ed1TbYRpibSST9CwYD0PCi
         m9PQ==
X-Forwarded-Encrypted: i=1; AL+hErErHWVCmdDE7jrveBqgmx6TLLVsA+FVHT99xSfD0IUbT+At0YUdG8wg0mYTQ83XwoqAlhMRzNM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9meNekdAbtOdFZUgWXLpP0vrmZYGSKA4Ahp+nS4lnu4TBFfwYC
	fhlUL0qrdhI2iXc9CqU/dbAyCck8wQLipj9xbJv+G9wA0fejvuC39JqvXV7cX0E4RdOO5GDvKzv
	gfJuF+3LJqgHsogi3dIvJfjxMBuPh+Qs9Pej6XPFK
X-Gm-Gg: AYBFou10sWfyUUI2wN/rtmKj4yXucEaqkdH06f0teeVTeKwgdg2O4pA1D7JSofOny1V
	1hy1rhSAk/q6Z52fZkhKDJ4ZH8IFNsBIu/a8ORaokT9XmJMU1hspWPgX4FPd1yS2a3CpO+RXo6P
	qr+2jT+PUHqrkW0Hy1Mze9+vsvZxroj1stCCpOaiJO4+l9SjZf0hg7DmKurHE17umr5qJFdl9db
	sfj1k7ajpwxgs0jAyIwtYDoZoRwzeKeTlCevT4o0iXjSy4MA7TXSPCJiFc31v3jskIDDq/QtZ+e
	d701z6thVmuo4onyk3V0yYTGLn1s6vrFtGE2qleMSD35y+TC5WRCTUlpwEyobIS/XzeUCWEJMG9
	5t1YIDbaj1cUUxzK3KM8pxrXjxrNvkruaDS0magrOK9mTQQJB/L1NM8xfhemP+3/QZQ0OnJ0Icq
	6osxVc1kzkm1u9tjg6NYUFPTwN
X-Received: by 2002:a05:6512:2249:b0:5c1:543d:2e3e with SMTP id
 2adb3069b0e04-5c1a2166b35mr171174e87.7.1794927834031; Tue, 17 Nov 2026
 07:03:54 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-11-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-11-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 15:02:00 +0000
X-Gm-Features: AclHuK_cslY3zjG6J6IGbNXJdnealsL3yNGOi2bev9GDyOWEmQLYI5dVsAlimaY
Message-ID: <CA+EHjTy-0k08Ukyo+4mmzqVn9UjRnvhy=BQT9kxSj7CBzzwO_Q@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] KVM: arm64: Dispatch stage-2 destruction by VM flavor
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Mon, 16 Nov 2026 16:43:56 +0000, Steven Price <steven.price@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
>  static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>  {
>          struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> -        unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
> -
> -        /*
> -         * Realm RTTs are inaccessible to the host and may contain stale data
> -         * after the RMM has released them. The non-root RTTs are explicitly
> -         * destroyed through RMI before the RD is destroyed; only the root PGD
> -         * pages remain to be freed here.
> -         */
> -        if (!kvm_vm_is_realm(kvm))
> -                stage2_destroy_range(pgt, 0, BIT(ia_bits));

Could this patch go before patch 4? Then patch 4 wouldn't need to add
this check.

Cheers,
/fuad
