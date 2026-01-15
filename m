Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251083A9006
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768492175; cv=none; b=s3F8B6iMS043mMTMHvvrqEgBlA3akw0IEzffx9KtR4aUniPCK12mcIr79V2qFgE0nGy3Jgq6PgXQcaoElFkb/GLORv1OzSI9iNmHs1G02pLeaQRRyc0dGYBYbGueKwWGPji0sOOLnD44XxwuMR44LiRA7Vycjn3piRcfk+JiNsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768492175; c=relaxed/simple;
	bh=DJosCagNxl42FnOET8OWwknghA7dpDe3mYQUJhuz+b4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mu8s1dNG+IbCbfaS5+S2vCESq7UE55Rj31jHevEtokaN3qioxhdf3jgrK+kGMDXDypuCwHaN5EBo4lG0BPRyCK5QscEq++bSWbF/A28k1+VGARWvP7mkt25vXnqpuG3C45Z3b/m/FFyT/QnAQsRdo2mSXrcQKR9Miu6HTX5AqEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AzxaXADS; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AzxaXADS"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso1595999a12.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 07:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768492172; x=1769096972; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJosCagNxl42FnOET8OWwknghA7dpDe3mYQUJhuz+b4=;
        b=AzxaXADSaHo4T3Ynel2NO8vp7S5qkVAE+M0KSRkZ9C7qqlZU74qdGDvqDbjouXLbJt
         SYU8CuvPRh6ie3wVkMd3kPQDcgu4zI3B29LOMNtBRgG5QvXkHmkKpCeGXPpYeCsCSFy1
         YTyEYj04kmnPoWkYLhWdZM/wBv2zbBV8/idmu44+3OTjmQQ0EhEoPlO/QWRe/PNXXFNF
         nf86bEA1TP7ipeONwLkyIROFxMfQcimSpWRu7WKUKcYrZvP3UOw6Q6nL2XgyRjVtFJwt
         c8ymWGj18rj1/6uL0Vw3nIY6wfBn9D63BuljYyPYS0n7srBOSd+NYmZS9vAYe1VtQjlB
         vSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768492172; x=1769096972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DJosCagNxl42FnOET8OWwknghA7dpDe3mYQUJhuz+b4=;
        b=RfLlDENdbXFazPuvZAwcmqTZ72+wMwOd3wiByl/JQnf8lJMTJZYNvKlTSTTP1C5u91
         L7KHkZOUF2uhpCLt6X0uUWX3ZRIyP8rGCtYuNnpnRt5pdgFjC+YJqTMRXIAVdGGMjRYe
         /lbjQ3xy4EQqyhu68b3O8mFjKw+EXcBJnfbd3vGqChrrTEDaVryCapKT3YclfxWHWmjD
         kLmxrwvhneE7KD/C2WmY49iMbesfYSP4UenA5cIxZyLOt+2ShVu71RSS3BXYaRzPn3qg
         fOlLIOSBh7gDd6G9Rh1rnWvrLYL1tTuCfNO4wMjV0Z8RoLchkKAL+Ka0zXwAmuMdfZrN
         fRXw==
X-Forwarded-Encrypted: i=1; AJvYcCUvpXt4PdcP/Vrb0B5vBe3ustN/n5QmWy3iIjPDv2LoA6d6RQVaauwGY/5LEj/0ITHPHjeYheA=@lists.linux.dev
X-Gm-Message-State: AOJu0YykYiw/Y9r/GuCjXMNKntxA/ToGECOhhyuUue5/33hkZuMiBD5G
	n67kI1B5linRZPurSeTqqDSz6REeVnciWPB+5J9Z/emvcFTEPuq9VuvMWassr7nyu9Q0tTiousQ
	er3OllO8vpsOAQPFhG5dLK3rPNHGguzt1wkr+tH4h
X-Gm-Gg: AY/fxX6pB8LyqBMOwt4ZPveck3MmVOKqEr9gIdBT3a3F2jmeOVh42fs+J3QgfbIGnkF
	nKq4CQw7BOAgI+BP8kGpkWOmK/ovKLnp2XlebBjCPks4o55gdD8iiV3flS3WH3I5/3QrKIrwHHK
	6JTOtcWv+w6yfRPwta7XBNo9IDahQ6HycqH+4iyuyCwz8E1jNycSNZ3evvky85AxVDfzSPIttlU
	WQgnKNsYQ3TMllcLifL6vcWcYDI8fooKMQrbTgEkzz43/tjMVWd4vbHFoJgWY7a7w6Wh7IMgJwZ
	XxzZ0aKRg1yeZjZltSVtU39HywhQHGTy+fJ3
X-Received: by 2002:a17:907:7201:b0:b73:4d06:bc8 with SMTP id
 a640c23a62f3a-b8793038b15mr3226666b.53.1768492172042; Thu, 15 Jan 2026
 07:49:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260112165914.4086692-1-ben.horgan@arm.com> <20260112165914.4086692-30-ben.horgan@arm.com>
In-Reply-To: <20260112165914.4086692-30-ben.horgan@arm.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 15 Jan 2026 16:49:20 +0100
X-Gm-Features: AZwV_QgJIFOY7mytVZj-oToaIVE2HXo1QdZ-MKrOSwI7DjzIv776hEYevEscmU0
Message-ID: <CALPaoCh+mRLJEfhKBve3hRf+vHHoObjvWRt74OfpopgtR9g9FQ@mail.gmail.com>
Subject: Re: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm counters
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com, 
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com, 
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com, 
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com, 
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com, 
	reinette.chatre@intel.com, rohit.mathew@arm.com, scott@os.amperecomputing.com, 
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, 
	catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, maz@kernel.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, Jan 12, 2026 at 6:02=E2=80=AFPM Ben Horgan <ben.horgan@arm.com> wro=
te:
>
> From: James Morse <james.morse@arm.com>
>
> resctrl has two types of counters, NUMA-local and global. MPAM has only
> bandwidth counters, but the position of the MSC may mean it counts
> NUMA-local, or global traffic.
>
> But the topology information is not available.
>
> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
> probably NUMA-local. If the memory controller supports bandwidth monitors=
,
> they are probably global.

Are remote memory accesses not cached? How do we know an MBWU monitor
residing on a cache won't count remote traffic?

Thanks,
-Peter
