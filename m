Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2837E2E0
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770650337; cv=pass; b=bhndAt/CnAK9NCD/OZzh1R9Uf+AJfyaXC1xxKVUFmuCoF8U84cT2f2pycdBF/VXxyf8jzFZXNQl1ZxkCtcLU7ogZDtwMu3lZjR1tKRm7nolZNlpaBcnZFvYqwGawzBi98CYP6yKBTLZs00SIavZm1BUXi5uDWQvzKISiKKORacY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770650337; c=relaxed/simple;
	bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLu5vUwsbyoH+rTqvPQ6N8CuoH9FM4eBR8Kkcm7XC0u94jjtuZ0IHoEYOUpvFXg1cr2LfYfyxdRG0FuBMHGL5KVdXOz/18V8jWlLHaqy09UHkMqmFrCyir8PbSf6V8TJCk3s7DSoWf0oVQi+LrKs+ReoDQ7SRCIDMTlVtJ6urXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HjyZG973; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HjyZG973"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7963aa14dbbso20831947b3.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 07:18:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770650336; cv=none;
        d=google.com; s=arc-20240605;
        b=leawGkkgG0vZyUCcwx4s5xbOjo0QKYCkEB48d8g9HZI68sjwE0FVWeW0yELR35MUT/
         ExDCYw48qn3aZ3vSmUO7TbmZqmHhsMs9V7Ac1A5SNmTj7SvQDGVIxmIyAlz4riRYKSV7
         OK3vNrsXZ6X7VkICkSJOuyGKuspnlUU3rFKlaGVOogSyz0VHS7jhPAzDUNlXkNKj7Plz
         u/LojdUDUKUvr94ZbNSlh6yBM4oy2bYi0Y99fxoZzBNW6y1bJPu3e2NAfb1Rxn/sha5c
         ByzBzT9L0u1z1fryAAge2nydTQDltHIm4fl5/z/ekT/z4EwmIKPK6O1VcyW2Pb249YIf
         Gs+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        fh=4FVpQOxbhoeUercaKzxu0InetTKxeAT4ZmwimlBlFoU=;
        b=A5+i9XurZskvDwyGxKWu49nv0TZ1CFyMMUMmGwXNmS0g707nbokTVzqVrL9HDcYbN/
         ih4uJlDGLXRraIdTdC9e+Jsk2xGElpBve5zocmyOEwj8/Xm4X7n7ArV4pzUONOCYTNum
         cm1bdxSxCxAaQtVtbsc3AmEpyWAMHnJ46ZoJa9g9OS8Q8io3HQy6664zZqyFLBaFUe9C
         ExvFD6G6rYNXF5qX2sanh1yPLbvEz778gCdVTbPfuRF/Z2d8KWvxi3H/J2eelhsPFt3+
         Ek0ruDUH6H1U0gPe7QrqwGBHrsVciEvL3bjHvYsRmTYDlBJj7K1qZLmKhLsUnC7ajb8+
         5CnQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770650336; x=1771255136; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        b=HjyZG973MvlwwGPvOQartl8xuwhhcZzv4dDSE4cOmiBKnkiYVn9qPrN5dlnZSENJEg
         BiQNJVcDf29xX39D8OcJF4gzlnlWOLEApgsRFK1uHC+ub2gVhkKKvMNx8wBEnp38Vvzr
         z4C2hZGgReFNPu0xr0PFuCDLGS5Yr/tYFWT9K7B+5/AOnHxDPwCmz5Q2Qxc0PX9/zYOt
         AHobyGitRIu5Huu2lS6QhLaAMqBxXzaQg8dYa2dJbmJbwP7tVL6xvK+zHWhvgvMe/yYd
         YpfyJLrqsUGOZg/+D2xNEkH+sU768sBIQ009ZKTPZHM4RKL1QnZWrBA9d5zZbBrRzVJu
         55vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770650336; x=1771255136;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        b=soUnlq4pRKaCB0BW1Q537wpBF37n6/OxPZTbaVC83xeGtaKZ6c3hkMmrZZO4pniAv+
         D1HtMcddvz1uDhUnskuAH1/SIt4cWb43BIJQM7GPY99X1+zCm4KXqzo3Ue5Q5rz/rjR8
         teDMAJsuktQ24nyD4dFYcuNme58tN7VRMRWB52tSpulB4GOhNgimj7PVUXptV6hlUx/V
         08VzsHFUlKcCeOORmSE8012RIMUJCfAlBJ+cVh8CXT7U/4SrrQChpCkjucfLuaHqE4FW
         3YQ/3gcURF0KKExKNcnC+49/rLG/+DBCWwYrXK6IM0YMHvvD8uEfhXDJ9arDMIhz5Lrq
         vveQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw77+Ow/TV+rXANkVIGuzLhyPZjzDIKlUy/198+ZbjrbmKnMzJrFI7ywTbtkF5K3ukCk0THk4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMgoc/UFvc8FfwhuCGHYjrL4GZGD3/tg2+fGmXBNOKn4pNeAVX
	wcKKVNS7HdJejKtEfSPjq6QZIhSPOQjJVkwnqcwrEdlxkRgiQcMyqtkDDGBMZjEEYGqapgengou
	dkLLTLgTxfDN194Gfas6d7wp4+q5HskK3tnQLvxMfUA==
X-Gm-Gg: AZuq6aKlNuXnQJn1VHyiL59YYB22tgd3NpLq8U3KoxHLP3i33iUsJwkuH7nQODTThUg
	04advspNNQT0372EqmvGXANK29s0zi/Bkw1knP+Fk9lpUVQUxf8kvMTUuWPeZU7cM0AY7L2Shzx
	gKOsnej/EcNpLGahtsgedVtGTjzpvNnlf7HoQm8W3FCO1Ibe+KInONwhaZrEJUeP8tFGJMtHVCC
	MDxKBX6X8EW73elJgDbFfN+MjhbWty9S8kVhZESUupnVxyzY7/at+2GTpbdN1QJwIFNW6Ro7OhT
	w9nHxdw/y164FcsSbrqpG8NrXJ0/wGI5uw+t5leLiemjXJTUBjuy/Ac=
X-Received: by 2002:a05:690c:e08:b0:794:87bf:76ef with SMTP id
 00721157ae682-7952a63ec7amr99106367b3.7.1770650335943; Mon, 09 Feb 2026
 07:18:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-10-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-10-8be3867cb883@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 9 Feb 2026 15:18:43 +0000
X-Gm-Features: AZwV_Qj3JfZxsU8iVNrT9S4IUwlHEkuMD3WG7W3HRrHxULDnwFPH-_uH0mM-meA
Message-ID: <CAFEAcA-nhHdwuQODmT4-dBCEuiut-jbHsCGVYByoMF77-UWbCg@mail.gmail.com>
Subject: Re: [PATCH v9 10/30] KVM: arm64: Document the KVM ABI for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> SME, the Scalable Matrix Extension, is an arm64 extension which adds
> support for matrix operations, with core concepts patterned after SVE.

A late reply, but I just noticed that the cover letter says:

> Userspace access to ZA and (if configured) ZT0 is always available, they
> will be zeroed when the guest runs if disabled in SVCR and the value
> read will be zero if the guest stops with them disabled. This mirrors
> the behaviour of the architecture, enabling access causes ZA and ZT0 to
> be zeroed, while allowing access to SVCR, ZA and ZT0 to be performed in
> any order.

but the doc patch itself says:

> +Access to the ZA and ZT0 registers is only available if SVCR.ZA is set
> +to 1.

Which one is the intention here ?

thanks
-- PMM
