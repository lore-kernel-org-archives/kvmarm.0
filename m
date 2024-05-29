Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B2F1C8FAB
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016643; cv=none; b=WBbo/zlgqOFPCcJSK944TnezyUZTgGoG+LsNeDLMgoFaWSoWF8IGciNDDxIwJqCvQDZnbJy0Gh51n0qitGpd+it+j+zdJN2eYiczudVObge+Zaaj6+gWcvggEtwdzo4Chd3+MBLtLAzGbrtCiHW/GVjki36vWrv0Dtoj4QRzsaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016643; c=relaxed/simple;
	bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egTcnN1UqHFtNdpncIU8I8EhkATSJhoSqvPOl400kLGxA8qrKy3sKAS24/XsKDEMpBJxnE/jW2MmEjHDzBBb/7tB+2ZnoGTQZKX20kL0/Y+eX9MTAs3xoWIgMSP2OlQG+srnEHSGAbDFdZ1TsiNX0XGwRYH9GtW2Z9+9OSA7M8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rkdt4o8L; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rkdt4o8L"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-420107286ecso21655e9.0
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 14:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717016640; x=1717621440; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
        b=Rkdt4o8LfwzPBlUNRA5smYlonui9uqXjjBf17LOAEVfWJdEQojPJsMVbS4m3ajA0Ht
         a/rFMZ8jxdKyWumGKgZQvq/vcqe+BzXwMyp/Xn/Sm5JKE5Uo83UpmE2Mptip2H9fxESm
         p4tPnByEn+A61wFXTCEEwOHkj6UTbUGbvpAq+3CgkP+4TMQKg/K9O90F9MbDrVUbhDS2
         OHHCoHdUbH8Mma03kexZuT3v1S10airPX1bxLsVe24HBdJ8RZTd0Tz8HVOOdzDQCBKlo
         yQIYkUQohEl7YUjAkiLq/SOPh5MxrH8ncXgmWR5nmTdvFx2vqm0+p0xQzgyC2yWcne0e
         YTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717016640; x=1717621440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
        b=FKulc+BpPFNyshEyGqk5XMQr160p/OFXQS3eUJxNsaY6qG4OLY1OtQ6GvW2TAWjfLy
         kLIbjrEtNtndU2FqRq55t4iFmn8BI1TjBf7yNL6v89Wflk2Dy2gQ6ActSMEKA+Pw4GXT
         RC4+dPCLMCIJ/wOnHVd3I8IKTnkZDHo0McdU/sETYkpgC0ScmpJuNCc7pR2fxlbAjaKE
         rhaUJ73f+Otr9Umk1dVAZxge+sPpPkFwYmNi7GfXKGegRCUWYvqPyhfztFL5boOgrzP3
         z306i817jC0k5wEV8abV3ZwgTcSLTJVEVUvwns+G1teE8WFukFTM7wlM6sfnfDjDYrFX
         b6mw==
X-Forwarded-Encrypted: i=1; AJvYcCWzw8nXPGoV7RzGt/SZgH/AF52XycZTOqOag4iSj8i5wGqnVGsEhAdU1sPdn4VXlVOT4q3eaAGlGZnX+7pnVpJSTUcQma3A
X-Gm-Message-State: AOJu0YzTxen66MWGCXRZwT5uug1JYosZkhDanvpjnakebYP1cOCXZhDe
	GNZVWEQtnFw3sBGRLXrxzlwUTXF0Xw/DGOGRWY3d5oaG2vJpmKKU2YSTbayDka2pJweOaGKx0/P
	QRAYbu37HoxEC2GG0PCYSt2dZzFSRX2XRp6D6
X-Google-Smtp-Source: AGHT+IHwVBgFo5das5shZb/z5hgC8KCkV+Jkj5w99z9LyfmWhmSM4ldtkdm2dxotNGGlvICz4N/Nu5ZLrwoOjjiw7Io=
X-Received: by 2002:a05:600c:3b85:b0:41b:4c6a:de7a with SMTP id
 5b1f17b1804b1-42127ec7dbdmr148185e9.3.1717016639372; Wed, 29 May 2024
 14:03:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com> <20240529180510.2295118-3-jthoughton@google.com>
In-Reply-To: <20240529180510.2295118-3-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 29 May 2024 15:03:21 -0600
Message-ID: <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@google.=
com> wrote:
>
> Secondary MMUs are currently consulted for access/age information at
> eviction time, but before then, we don't get accurate age information.
> That is, pages that are mostly accessed through a secondary MMU (like
> guest memory, used by KVM) will always just proceed down to the oldest
> generation, and then at eviction time, if KVM reports the page to be
> young, the page will be activated/promoted back to the youngest
> generation.

Correct, and as I explained offline, this is the only reasonable
behavior if we can't locklessly walk secondary MMUs.

Just for the record, the (crude) analogy I used was:
Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
but you are only allowed to pick up 10 of them (and put them in your
pocket). A smart move would be to survey the room *first and then*
pick up the largest ones. But if you are carrying a 500 lbs backpack,
you would just want to pick up whichever that's in front of you rather
than walk the entire room.

MGLRU should only scan (or lookaround) secondary MMUs if it can be
done lockless. Otherwise, it should just fall back to the existing
approach, which existed in previous versions but is removed in this
version.

> Do not do look around if there is a secondary MMU we have to interact
> with.
>
> The added feature bit (0x8), if disabled, will make MGLRU behave as if
> there are no secondary MMUs subscribed to MMU notifiers except at
> eviction time.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

This is not what I suggested, and it would have been done in the first
place if it hadn't regressed the non-lockless case.

NAK.
