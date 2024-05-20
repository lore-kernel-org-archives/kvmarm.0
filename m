Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25744137936
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228017; cv=none; b=aS6I05+ImlmX/V6YvnxYT3eDgIJ7RRMCs2LUaMJG7qx/OjAVP9H6hHrqpUFXnoPQpZ/Rphktc12emxys612KcUlboyA4s2GwpvVYj3oBF3MbF8kgofA2QaE+jRa2a6zTbUrct7Rs70R6wpONX8Sme4KlUI8Z0LQq9xUfcNjuiOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228017; c=relaxed/simple;
	bh=FxG50QTn7t5OqycyoEHUumgg2C2ZNF4QpsBdnB3+lDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qiUEggO82p7Pmo5d3vzZXvWEFEd68zWib0k5q0M1bvNdVetyNY3jZRU2KWVrlJLoI7kFxCx5mUIaM2+XZJ+bP93lnxAtvpTYt5USZWDhtKqxKiSWegkzh2eHfYauG3v9QNBopZbIwRYEyixb+6Qst4BPxqwq9cAbYagE6TaMOfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JA9Klmst; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JA9Klmst"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-47eeb28c44bso564917137.1
        for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716228015; x=1716832815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxG50QTn7t5OqycyoEHUumgg2C2ZNF4QpsBdnB3+lDg=;
        b=JA9KlmstGsINIZCINUCSDE0q2bBZl2384wmEb2e3UW++wY2CbmRuBXFXUB5bV2MUjU
         gvwRAE/7dUe6hvGkGAJDi/9dVSNAI3rs3RjHIQ4cmaHAVXr1GDWJJTbHUT9lYu3WmGC2
         +bmw+YiU+16Cw2imv9gDdeeI6V7keauKwikT4M+6XV0cBo7AYv54VbgOlyYP95aKxkyW
         Q+M62BqdvX/+4NpRtNPk5isP0DRj4ROgwG+FSYKXdACSPMFL2TF6nVOLxZ1gIVg+tafE
         28v2IzEbU+l1x/9863VPTtpPOPmKC3o2Lcg8TTzbD6VEmMCtUj0UcqClLLOWW5L4FMWo
         e7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716228015; x=1716832815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FxG50QTn7t5OqycyoEHUumgg2C2ZNF4QpsBdnB3+lDg=;
        b=TXzGAzliXeQQtPMWekUFdtlzmF5ogS/7p/fpqvEzhfwI2L2swuyY8JyP+QHCb/y+07
         10QZXJy5hkPU1ujc5762EmAuY/lcOu4QTTNzYbfBZNPvgLTkwVwH+CQqSDRdJ0TJXaZj
         VvaIC1q7TAweG5+7Ti/JMPBmsGAg1NqlXRImK8OR22gVOQF/rit3xBa4qusO8Cep+EKZ
         Ids8U7EoPBo9qGUr6Q0ZQ7FHr+D9zBZH4OLQ8Go2600fikp3bvD0C8n5zoXdakWxtTeL
         6VJAarLT2F3UdrvV5ximB7uDeCbDNf+cjs0iJwIMlGhdJXYWBlx1AUgcDImz62wLHjMo
         dmwg==
X-Forwarded-Encrypted: i=1; AJvYcCXrasS8lkGRtcJh2E8NpalUWRWJPox2nWHVgSUbMuudlJzBQjRZr+Lo3qalng90j90n+sBG6R+4atZbeRkeE2Evk3+Hixaa
X-Gm-Message-State: AOJu0YyQYbsW8FkF+TJVQrNxLorIJhWzqZFbLRrxZ0JavTkdx6Q3r6bd
	wIGPSzX2Xpx8bGYP7EV8Z+xtOXOHIA98WiUowIG5Ub7s50YXtWcblrToSpQLcCZS3yi3uB2wRzh
	36pPDcsEglg1o0TJnJ0wJoZY/dmRw7d7ZE+66
X-Google-Smtp-Source: AGHT+IEiZHubyFxmn2k7Dw4LNeyl+rFfmeHNN7KjUQAXcnmFJK4HISNA6q54jcuh4aAy0pkC1VxQuqbOgU6iZmZRTu8=
X-Received: by 2002:a05:6102:3585:b0:485:af2b:be14 with SMTP id
 ada2fe7eead31-485af2bbf37mr12444546137.9.1716228014941; Mon, 20 May 2024
 11:00:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk> <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org> <ZkuKYA6-u-eZmBOO@linux.dev> <d68fe061-867e-4afb-b7d1-b99196a1080f@sirena.org.uk>
In-Reply-To: <d68fe061-867e-4afb-b7d1-b99196a1080f@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 May 2024 18:59:37 +0100
Message-ID: <CA+EHjTz-__B=rw8ym58rUBcwO8V748KUO81f047aRjrrE_kdkQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 6:53=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Mon, May 20, 2024 at 05:37:36PM +0000, Oliver Upton wrote:
>
> > Wouldn't it be equally valid to just zero the state that will not be
> > preserved regardless of whether or not the guest used fpsimd/sve?
>
> FWIW I've had this benchmarked for some implementations as causing a low
> single digits percentage overhead on syscalls (as you'd expect there's
> additional overhead when VLs over 128 are supported).

Interesting. Is this an argument in favor of zeroing (i.e., the
overhead is low and acceptable), or against (it is still an overhead)?

Thanks,
/fuad
