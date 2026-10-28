Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209470;
	b=Labef47mEiOKhf9c9YuT6kgRqcLMWc2Fovof4A6xJUKeogq1PdAvdS/+OQhFMT0/NaQY
	 Ry8uGKhbVDlQEKdVmIjBRAifNuNfeGMp5mXw78Fw2lcO0WiM9rP+MO914NYL4sW5K8EeG
	 +iyWGKw0iGdqVeNxNDHV3g4PwdY7TVCXixHIXgiQ8XrLmRmU4OJ/Aw8nm5wFjU/vEjwYr
	 z24WXIgN8UPQefqVTNJQ6+YFQD/OVt7gGX/pfnl3zCjlGsgl6tAkI42c5xjggsqOiFH+Y
	 SGX5KQcmw5U7Gv9u+RrTZHvIoHKHG6rWAo+/BC5fXixhrMzULvGpemUBAiPQLiQfFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209470;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
	b=x6+fr1fJUMQsWqdIHms3QgvDfd7dvhIf1NgOy9pVdzVkMod2aJrC8i6gPbatbOIzyB/Z
	 tF9f69KXP3d0NKHOg1XNn3Qmggv4LF+WRU6CT7POoyZORbZK8Dy6so1aNsUkxGzrvxRTm
	 P1NduMPoEfNrt90fJ3xlYZEkLdZiyLUH6e9lw3BoKkGMdlx51SxlSOgxXZ3kgVLWvvYfK
	 j7p0mz5D7669r8O8DWRE61BgJoViIFgIKjCKwHpuQgWtu+5gEV0FAVeF38QLHInPUAJzi
	 eyaTYxIOGdnqt8A6L6L8CHWJHhsfOw+K3NezvDsC8tsqcJ2FMZC4dv07VljOxdDYfmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Gxumziso;
	arc=none smtp.remote-ip=209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D35606A31A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70D35606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Gxumziso
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc0892f92cso460832137.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793209469; x=1793814269; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
        b=Gxumziso31HnQN2AJZ8r/zNT26JeM9ws+ItmXhIQ+gdN6jFa7QgVwwNHIo4RkY9y8g
         NLg7Z8G+rb8sVNVmpp9UqAQhYv/OENBk4Cy+Kbwfkv9kGZjDR88RDBkKRhr2Di8n+rNh
         xhqASRiyt4n4KfXCvF6UZNytnIuGPD0+fd24W3nDwQExeNmvV82U0A6zuOlZBmyyOARm
         e/hzUmisD86etwwaUTdo4CuC4tWDmLC7/asx0xm/qnCyVHkty1ZltkAfabO54j9vVOXl
         Io6VubXHgVq2FpXWUPcUwfxhAk69psdJxTCss2jYEdS/WR1Trn0upseDgnlBfRpEX0T9
         79GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209469; x=1793814269;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
        b=TenEwzsJbULrwrhYFLa2jK79nFj5aHmcQaVvgIRrlXyQ7VMm/vUtdufv5q9X5F3dPJ
         DNlcYCKwRwIHw1ceqW6A2tAjuYHxGaW96O4RKBMS3NL+gdOoOlSoQstgGcSvGcNklD5H
         m4d6a/5fdmmymTLHStrAAdPaC0LuCj4Nid7q+gIYxFwTT2DmdwYVitbJW8ipnjDjgvMH
         i1UE95XCnALViBJ57u4O3AM/xDbI+6A7C67wo3cXyuOH5GWkq6VjFdI8GrwJbKqNU7HD
         A9ICDHiI4k72T/fB1ZQwbA32nUT7IlZqd5rEEZH0R77SAYK7oSKcU7xvLqGUoEDY4GkK
         4cCA==
X-Forwarded-Encrypted: i=1; AKwUvBxGuoJK40Almxdx95be5GCh5jRjy27r5HKGNJyW5ms2+KVwcU11xAYQlKfoXrJuB0sQy1cPvZI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLXyRkpZ+QSjYno+8qkdiWxj6SeSY1dpaQ8GoQFyl00NP3Pp/4V
	adIS2XqIwZNvtkd2djuUS0TdokBza1XLvBTCbVaQ42ZIx5Fmh4hyF5RiMAMOktWoxcs=
X-Gm-Gg: AYBFou0sh+SFLiwC+4dWGuFDFwy/LTtcdifpMU1+7IAuTBFavuXokMgKhm/J+ohB7fn
	zyf6Jnhd+JrKZ8Fi48r70XuaUg/YF8lrpqfkbcZXywItNGr5kB472JtqggCzcb/QYPOuiTW4kAW
	EF9hvMBF47flc9c+9zFbQ9QbDKgZdW2y41hgg/tzq+Nn0KFm8V3Isavy+y906SKgMAqpSXjtw11
	XNaijgKrABvIT9HlytmkWMsVqJIg3WkXVayHx9gQVAmJpPHmDl7k9Xi86kitLyMuTATndCx2EVM
	Q+M67gjwBlvaiyC7ar++thN1IkKnGnuJZX08kHz7B8txzPzFfakUQF92zykhJV1oaclaL72YxTg
	8ja5fr8i/po4OxtlBo813wQ7Ty/8Nm9vClLt7vflGZspq5A9ymW+iMIH+EkIG2FYbFFLQ7jG6SF
	33BtmulF0bNai/aSzElie1wrRDVnpbUS2jKc8VpsOxq9fuzVpr4IgehIqagis6iDIkc7B1Ozg5J
	lwCFC1i6Fk1dkjUuxOh9jYmqvdunwj7CdRcyAvm6sBmiPaMcHrlvVgMAwrXj5XsxpVnADHRrJuI
	9Xvmnk/v6EELzeVm4TRSxnAE5YdLGJ4iGA81RnVk1FhfcMlZHbfDMjHcmyZEzG/yN4Whq8VJ6Or
	MXO8++O/iXSZEEk2HyPQf2/iG9Kci4kjt
X-Received: by 2002:a05:6102:3e8d:b0:7a5:7282:1994 with SMTP id ada2fe7eead31-7d03a50a85cmr1269510137.7.1793209468986;
        Wed, 28 Oct 2026 10:44:28 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99125931983sm6616412241.2.2026.10.28.10.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:44:28 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:44:27 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, 
	seanjc@google.com, will@kernel.org, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auIvjVmWnsVPN_9g@google.com>
References: <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <2vxz8q3hoicx.fsf@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxz8q3hoicx.fsf@kernel.org>

On 10-28 18:17, Pratyush Yadav wrote:
> On Mon, Oct 26 2026, David Matlack wrote:
> 
> > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> >> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:
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

I agree, and we will discuss versioned vs. owned serialized data 
structures separately. With this series, we establish a common 
framework: size/feature flags and accessors, and we update most of our 
serialized structs to include them. All "shared" structs (e.g., KHO, 
FLB, radix-tree, block_sets, etc.) should have their own versioning.

kho_block_header_ser should have this header. 

Pasha

> 
> Anyway, not a problem this series needs to solve, but something we
> should eventually do.
> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav
