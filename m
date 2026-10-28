Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793208282;
	b=ZqKfYslkNAyIslBEtAJtIWla0nMJu5Tq9ZGWXCIlyWf+sMMn3d0/zPFktR2jn7OU9e00
	 PxsulbZejBMvKMLaCYINaC/jR3tpTlE3LkjSszwMeXhi0Npj4CN1lS+xM98RHf899qVLx
	 1QA6yFtaH81H1RHCKJ8hpGN4WOf0714mNpqzFIePqAPlkl3T1kPUv1GYZipivxiOmDa7z
	 kvNe4AU0ty0OEbu0JESoYs2X+UFL+HrQSc0LcQLojsY5lS5h5Ze3Pd4RKqWyXeV+5arKh
	 tuOeof9BjY4rLdT27noxY9KhKXdainh4i8D0yosG2oP0Dt1gT4NXKMioystZFQDVGow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
	b=JHh8D4oMKUa1EK42OUUPLs9eS6EZGa4gszLsw5FNjoQ+meD5mGGRbEUtI/3JkUM+8l2n
	 J0xhTwwh5ZIoYIJjkXlgL46mvdxfczRcr4EZqfImBFL1Ci2eE+5aUzaZ8+oqMA4dWZGZb
	 l3VKMoVRh0/1cTXlNoB/XgbSf86i/LjoxmSHrp4M7fH0addOYpm9esVzasZtEtKxTKwfG
	 FarzIo0zvvEmAUxKoilFt0Fh3s5A4wHLZuMwzdqaHqv7Y5HacMgf42WK7ZT9v8i4adJiX
	 hzXZzXqwAJD9PfEmLa4V/KFsLhebt1h72sYiLy7upnTab8sFxdmMc84yG52m7eQaK1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BxLLHuiY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83586606A324
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83586606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BxLLHuiY
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1846bc43c28so1455410c88.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793208282; cv=none;
        d=google.com; s=arc-20260327;
        b=XyK94hDfAzMNpl1MgQboA404g2Y7quJNV3mqx9faNeba1WWtTNy7xJNUu22XIpnzm6
         KkAxHh4uNY5EQKS2D6MAnxIWV18R5RNG5uds69AZLlg8fNdp4LR54T7O7+bDg5YBLeA/
         zsBDoI25lhor8mu+T0AR5MWag46R8Md2CLyH/BueuCQUfOfTfoE9vuFeZ8Nab7WfDbU/
         CZxjgtnf3c1YHH9IFT0IsG280LSPvnfDrWFTb1/G/r5FMcaB5UGk5Uc8uzjSEMxr7Oe0
         qiQQHua4/kaCpBzOEkwAunkU196S6p4EToFB7+xJ7Csd44PcPfP3htsnOKfS97tn6Rp/
         Qi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        fh=604hQ/oke3eKjYrUDL9W2yhzU7n8N0B+jWuxUFTNl3c=;
        b=FZCj5WGb+DXp8NkdZIEK5kLg+13Vdl5ptzous7JZa85IZqzX5WvpUc87YJSNdnmI40
         Hy4OCWlpBgqSY/WCAycQ6yT5JUS51PS1kKL9ZqyCQbL8TpgY8XIF4h81fDtopLGFoYJ7
         bzfkhqfyFwxclhHbSDXpkwuHhMvSBPDaTA5p9GsnJoFJv7VjwggyvrAM/bkOs4HZpSrB
         jcjEXCDeGOBkuX/YGL/ISvST/AIaTSv+QglBs7muoihtlgLFQEF3CTZeb2+UyiLRM5S1
         X/cew/pErc3Qmc7FF2TDrVPHWWjqTPTG9Bn3wiCxSTcCc4HMJzMFs/mq6Q7ulTniINhu
         jj8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793208282; x=1793813082; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        b=BxLLHuiYh1uC9EuXGB+AGBqKcDcV/9pyXSKLixeBQRo8/abLN8/4zCAOhe50x9Youk
         osrRnnUvoLyCZBWsoXWku6u6z+7erxI5emCz5Pc5YhI4RoI0tGI6yPzq67GA3DO5rbgu
         iF9v7jS9rH+4+VJd9UZPaumViYXYPajFJUg2EMnGTqpr8zYsNLZqyavA3fiYqfLYcQ/r
         ubvn0Iu2u+3EcVPp2s8rWU1RK9fkMI7mzWRuEGHu4nkQK1/VD/rXAIAUYSjKXB+2+FDB
         yYO2d177K521s0oa8qGLI46gVSkV6A6XBHFwb7vVMmF+NZ/6jxH1WNnLGVo1v51tMivj
         cdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793208282; x=1793813082;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        b=KCwyfgYW0HwESLXMhCmL/yYa5DC5Wo46Zl16y1A7Sdu1a+pcAYnfiBpEZix0dd+OBh
         YzrCh2J+ICYJd5gZhsmvKJAO/exS2euUEkVlEQD4hVw20GXGdSqhmfG6qtScdUKUTnyU
         QR6P/9i5HKoRDlWg0wg8flrgIKRC+3K/ximp5f4v4jCrF7wEBxD87XFX+oz5PSPMrpf2
         rrLI2C48X0YbakWX53yWTToH5dDv1FEtpf/dNYeHsYlrXfelCaAQli19ezeLPmCBbFi1
         mTHrlXBo0W6FqSQ2bQBlmP2BmVhbdgzN9+Di/0rn2Uiuyjz+Elt/fveUE1Spwuv6F1Ok
         Bung==
X-Forwarded-Encrypted: i=1; AKwUvBzh02M1JjkUwQrnWICgbAj7jeHuzz9Mvx4mnxH+mim1s3A3g+OsEx3yA77ZnEMVgGf38ISUHHw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLm22S1IraBmM2cYUrEb/EEHkCHqFxNi1BMyZh0vpMwOgX7u4eQ
	4Eo9ZFW/OEB5ohXt0Wb/CU9nWDOxuqeqguFMXOhRq/+Q9sTnwCfcE9nqTt03jBDV6zzYclS+0j1
	IcO5wHZKV6WYqnRNWDKyprIa1nuEmhlV75SNRvzOD
X-Gm-Gg: AYBFou0KkciRDC5RMpQZZQih3JAYz8z6i9MJK8W7mhmYkoOp/f8ZZz6Oh3fw+0zYd57
	/a5FPczsesFxQ4sbhF0uOE+TUmzBPbohH303vpVzfWq4TtouZLDOIWuX/lAaZdRHsnyLtKFlw9t
	yy05Y8ElNZTAm4Kg3CgXss3RIsJJMj5hjoIcy7h5z8m+m6AKd20AQOi5eWr6OfVfg3IH75UCMN5
	CLf6a1xAPQH4gRtx1crNP2cEYT/+sfwaEQNoegItSxsu5RsJRJfnFTqcelWSZgHb0wvpRbeIrHh
	P0xysUWmr2ArWnMjPJ+mtLbufBXxTsPuvF0kWBZDcRC5+I39DZ65ZHw6Z1yaqkwYFRdiL2Yc2Xv
	95uz8dB5JVBa5rAMtfXYWXZQsPDUDYBtUjgR5Tw==
X-Received: by 2002:a05:701b:2813:b0:143:6525:f9f6 with SMTP id
 a92af1059eb24-1a6cd3a1575mr3454907c88.13.1793208280541; Wed, 28 Oct 2026
 10:24:40 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com> <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com> <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com> <2vxz8q3hoicx.fsf@kernel.org>
In-Reply-To: <2vxz8q3hoicx.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 28 Oct 2026 10:24:10 -0700
X-Gm-Features: AclHuK8mtDBrFSk6j3m-QjfmBC0Hg3WdAbJ_jeR4OTytlWOkEsZuDbAniPHpdm0
Message-ID: <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, 
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, jgg@nvidia.com, 
	robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, 
	pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 10:17=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Mon, Oct 26 2026, David Matlack wrote:
>
> > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> >> On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google=
.com> wrote:
> >
> [...]
> >> The reason I care about keeping the header compact is that we are
> >> defining a foundational kernel ABI and want to use this header across
> >> almost every serialized data structure so we can evolve them later
> >> without breaking compatibility. While some top-level structs are on
> >> sparse folios today, other serialized structs are tightly packed, and
> >> we are looking to add KHO slab support in the future where tightly
> >> packed allocations will be common.
> >
> > My intuition is we will have a small number of headers per preserved
> > file and per preserved FLB. One for the top-level struct and then
> > optionally a few more for sub-structs like arch-specific data. That is
> > why I am less worried 8 bytes per header, even if we fix the folio
> > problem.
> >
> > Maybe where our visions differ is when there are collections of
> > serialized structs, like KHO blocks. For collections I don't think the
> > elements will each have their own headers. Otherwise the elements could
> > be different sizes.
>
> kho_block today doesn't store entry_size in the serialized payload. It
> relies on its caller to do so. With extensible structures, this can get
> messy. Sure, the owner of the kho_block_set can track the size somewhere
> in its payload, but perhaps we should store the size in
> kho_block_header_ser to begin with?

+1000

KHO block should track the entry size automatically and not rely on
the caller. Otherwise every caller is going to have to store the entry
size in the struct that owns the KHO block, like I had to do in the
PCI v10 series :(

> Anyway, not a problem this series needs to solve, but something we
> should eventually do.
