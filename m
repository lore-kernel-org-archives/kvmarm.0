Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847367;
	b=xFq1kMbOpsQWpP1tO+l+1G1mBZgSn7Q1l80z3jU7DqvHnki86cP1xW0bX9Nt05AnQdxj
	 JRBFNQ5b4F+nJqVbwFl44gdyzYFVS83nBpJTf9AJj0UY4Q5TFvid65hheEnsHW2Pa5VIl
	 J7sMYYMgtMx/6CYyJ1uailAzh3In8Yli+4ZO9MfAmAlVVWOKJK6fEFVbPpn8dPd9av9Z1
	 PEo3c+R4lExWoMBs3jtCyq2jAYVPBskP5G6FhMlAVgsdaZjK380DIAJ+1Lw1kXFWLIKbx
	 zdsGEeUM7MQvxIsTNEkh1YvWvy9it8PjykcNy3rqUSIGo/OrSVKCzrgOh3kJCCcJPJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=IJ8laK9ppBsQ5w0QCVG99S6Wck2m41XXe6YgxVTshXQ=;
	b=C7cmArn7o5DiKXmApQGof+TPMfnd53P+zACzcE8dlSiD5b02+7L4JaHPZa3CHrhvubgw
	 NsmMEnfUqgWX0l0mODAdJrutdkBz9ccKwDhDe8mvy8uKWCFnRNpregOqlkYtrWPzcZPIP
	 5dOCYXV2Isef6t5ow3iwLBjAnsmmac9KqukGnKSm0sSz3yC+DSRqtUA0B5jdF9rg/iuD5
	 8yZtpTLK6fKHz56+KN8AtdqWANgqoYh28WM5NgtHoIWtQvwz4+9rQTR0UAeUVPcniwFcm
	 iSr1XiWvLNK8et9D3Jr+/c1uEQeao0HyX2dwGTYSTlL4VaF8L2edhaYhGMEJRT4IJjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ppSz8RsU;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B7C606A329
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 16:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6B7C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ppSz8RsU
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso218105e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 08:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794847365; x=1795452165; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IJ8laK9ppBsQ5w0QCVG99S6Wck2m41XXe6YgxVTshXQ=;
        b=ppSz8RsUQ20OS15HRh7cvMXr1sRcLL61bcPbjk0ioF/lLHgKrIiGci18nyh62iSHFM
         S/BbLrjQ8iIcDU39IJSIc/EN3yLRKngceBAkmd31pbzfF8MIADyuMXtEwj/0xiyPs8hm
         3Fdv7L5c5VYbAzxVjzVZdkvyhWotlAD6TLmD506i76wy+NILw5Wb+LzGiFwGcD+wnt/s
         pYVwOLLZlqkMNP9aHuZjoDWrTRTea+oHHuSTqzH4ukqt9RDuB1o6GGPC388WLUfEoEIq
         Cti8IY/CkK+vmi/rEjeh8iOliNUbry1p/6zx5lH+ByN4C5zr3mqSCllEYiV9oMZvGGHP
         B7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794847365; x=1795452165;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IJ8laK9ppBsQ5w0QCVG99S6Wck2m41XXe6YgxVTshXQ=;
        b=tnxCgMKbh6hEap5//xCV9DdF3sAXzz8nCq6hMIVjRDfXc/yweUETjCoUq7tll0g2Sr
         exvSviatB9C5TKXrhtPZoPsiBNXfSd9p/wV46PjBaBOYfGPUp1U9rR+ch0K/YHF7UAOl
         /zCtW6V/YjNVx61Gfa8ry85sOHipReHvHVy1kiKWiJFqt0lOgloMMe9ciihhC374ab6W
         CEyXWuHwvWoQCuxKt/4TMAgochfrP/gig/z7YVtIQKogaeZbqEOiiFW6PQHapFo2Mml+
         tuqRfIDn6QMRzyPGjoNS1tewcHZx9iUOwRLDaIEPyoiFbmGRuTlU5X2kBPKHWJLIt1NT
         mQwA==
X-Forwarded-Encrypted: i=1; AL+hErE+aRrFJsYZpbpqYGyIL0AaU1v6a2cAAzfvPH68S4joXH0icDLSfehRz7SefOLX9hvIQQolYFc=@lists.linux.dev
X-Gm-Message-State: APuU4Z8LlSVUkscUlLDM5OEmvolBtatiFwYqHUUIvrR0c795mBFx0+VP
	MeOuLJxkCv5tCVSZrEF0BQ1GnpC7Q/QGuR/Lp8Zhl3ETDUcPLD5MCkhA7EsNJbGDOw==
X-Gm-Gg: AYBFou0FihkOxk6IIr7It4Y+hL2W/hSvM6oR54Uiym/aRPrIyeGjlhDGFykuRt6upg4
	Up1NAAFvn7bw5Gr/OqdfwJt5CK+8sXWCZ/+uKCziph5Cd1AUpjXg4vtcYtygTWIalaUq/wIJeMc
	PDc8lOpWjR6Wg/qR42iQmPNJ4AwTexlVe1FJ7wc11bc93dEJdAjNoCvbevs/BTQdtzaHnjTVQZD
	g+CqcPh8/KBRW0U4e1j1s+uQ9qvYNCf5HSvGRzghjvf8UlEXQoUq7ztLBjkuKJ/lPBw9tGZlYoc
	lceOo+CJFRoap86wD9Djudxo/8R7rGE8chOYEMpwaXlUJuuKG+Nd2x5BzsunHXf69YJIen4ckSM
	89Esuqzv9FmykVEXXflLsreKYQrxVzxIvB3WA+ddK0PgpGMqlSlDhX2wxA0f3r0nvCHtDaW7l9N
	jFR0fKoOq90HvRzd5pK/q8ZjWxDpnCKf4yVD/DrmIwPxB81yqaxpSTrTiFZV6lv73b/C5mvGaPg
	HVBJ+9m3FJH3D31CQzrAsrsjwuizfqcxPna5Kd7nTuH/15zjhdk34QXwCG4PanNRr0gHYEzcbJU
	WsgbGQ1Qie5XqQJcXvPbXDlG4D+ov74rIyswG7ApnbKTM8iVv6LNb01GtHjyS0upw/XPiPtu3yg
	3wdar/kwjOls=
X-Received: by 2002:a05:600c:5012:b0:4b4:a551:681a with SMTP id 5b1f17b1804b1-4bb7837264cmr1312695e9.3.1794847364743;
        Mon, 16 Nov 2026 08:42:44 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783965d4sm791855e9.7.2026.11.16.08.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:42:43 -0800 (PST)
Date: Mon, 16 Nov 2026 16:42:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
Message-ID: <avsygB0HdGxR6psB@google.com>
References: <20261116110549.1863653-1-fuad.tabba@linux.dev>
 <avro44jUWOARFzul@google.com>
 <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>
 <avsNdPissIDAb1hA@google.com>
 <CA+EHjTwuvhAPWje63TJRR_d+VHT0xwORktQ4zxrcV7KMaHxupQ@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwuvhAPWje63TJRR_d+VHT0xwORktQ4zxrcV7KMaHxupQ@mail.gmail.com>

On Mon, Nov 16, 2026 at 04:32:40PM +0000, Fuad Tabba wrote:
> On Mon, 16 Nov 2026 at 14:04, Vincent Donnefort <vdonnefort@google.com> wrote:
> [...]
> > Ha yes of course, that's the host s2 we are mapping into. And on the guest side,
> > we are only changing the software bits, so no CMO. Actually I should have read
> > the comment in stage2_map_walker_try_leaf() more carefully.
> >
> > That said, I wonder if that shouldn't be handled by the hypervisor, just like
> > hyp_poison_page() do the cache clean.
> >
> > That would be slightly slower than letting the guest (who has a mapping already)
> > do it, but pKVM is enforcing isolation between host and guest, and it feels like
> > it should do it by default no matter the memory transition.
> 
> After the discussion on the related thread [1], if we have the zeroing
> here, we need the clean here as well. So I think that this patch is
> the right fix now.
> 
> Cheers,
> /fuad
> 
> 
> [1] https://lore.kernel.org/all/CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com/
> 
> 
> >
> > --
> > Vincent

While I don't disagree with having the memset in CMOs in the guest, I still
believe the hypervisor should do it as well.

Linux is not the only virtualised guest and they all should be able to trust the
hypervisor to do the right thing for them, which it doesn't.

-- 
Vincent
