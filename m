Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20D30DD18
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 22:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072065; cv=none; b=VuSl2J+yFpXkz1h+n6Syew5efnDOxWGymqbvxaW1hPwDobbx3ySifWJfRglkGKLZzQLT9QheOjKN6WwJmCS8D+sw00eFaP5THbdi1vuiXfmmX+CCJ0D9jX+H3bDJGnFjfiCE9ytVIxL+sm6UsstwZGbUbQ+N7wvXKJmBQpI34tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072065; c=relaxed/simple;
	bh=vg2n9jgyf6Un8yroS0eZ9RJEclmxHEAIxafM2FtYloU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFaLUVlRO++jxPx38MuagzGuPWPbEQPsCE5ByUGNVGmD9Q2/3yffX9kS5LdayKaQxe1VBjf3wua6qJFfILazjOZeDi10snM2rbL7jLAIqZ8JhglThrmMYvX8GbwMaSgyxm8dzL7jjAsxopE64Zr+yTba1/ORePjDgNKjQY6YJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNVe2/FW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNVe2/FW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477741542bcso18935e9.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072060; x=1763676860; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7JRornaiplk0uZKMqz9STwhUMyLeMRJwxelXDphyMs=;
        b=QNVe2/FWvCPKO2Tu7BclkO0avPgRHa9AQtkXmCfzD4e3Z2wT1x7NYwvs2ja1NGC6Hw
         hsHQNz4WP33y0PaJPfdcT/iJcvazISltmnxu+DNuBIA6tswkunqF9Y+C/zSlPUsky3bV
         H6NrGu8rEMDoY8xa5oYgiY0iRr33WFptn73Q4Fjo4WXIHMJItKLaRpvvcpDrmCysqd06
         GVtDouATzVBciO+h3rLGQ9SyjgBq/oq7XfhEKcOMz/+puk9IvRP/LrEmr9/aCmxTVLOy
         ZKP/7irPea2+Zkwb2y9RFrZIYZ/hueJh1iLCM75Y2wVnrWEuQW3f+m7KbmT/E+YJdKKC
         kL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072060; x=1763676860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f7JRornaiplk0uZKMqz9STwhUMyLeMRJwxelXDphyMs=;
        b=pv38teJjCFqCUNzeSaU9cLtdfz06Crx3g9hnh+HAFCTKWCbMzqGYfwqR81G46HOSKp
         r3iHciTUtd74o0eOSvQsASScqgJqo+/DLFijnK/Dh8KbzQwK/SkDWD5ZqHR6bOoEk8Ex
         yGt7VRCreAg2DFyiyTR3c4nPnoHn5p7UB62dz9ccNtGrdLsbPfst9uWde12E+sB4BmfG
         vOVP9hoERX/Y73dbb2TYglK+Q3TY6DR8HRZNME/Kz2g9PzuKSibAD7/w5mZZOyX2tB/M
         o2hutronS6JKwQ1OyUfxbspeNHptjyyFJwXGTAfBO1/93S5wWjaTDqaqse5/ji++QWj4
         hBew==
X-Forwarded-Encrypted: i=1; AJvYcCUQAke/nIHd+TW7POw7o+DFbqnYxV9DNm9EbIf5WSjsujSj8ZGHiip+FECUC5Lb7syVQ3wR14o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwI9b2unGaafAsyRQUQUJk1UPG/CdPHbtduNCwfzbDHs4cOZXtQ
	shvDjVvJfyaJClyiicjnVxwmXcx5nBKlcQXm69BFOWm6k5oaOfFbnO4B+qZeT3+P01f3osLNHV6
	H0RuOldjZ+43au75Uq42a9sGq2oCDYWz42qysp6AK
X-Gm-Gg: ASbGncvMGTSfmRkTb37SFemg3aoWi2ghkN7RZpXsdi8ukfCoTnUmi0RDCC+bghtXs2M
	8ur4TdeJK37/0Xvyts+Zu5hbXUMJrbFJSuLpbLBs4H3Z3eHCagJrk/zuuYBpzXE0QKLkcHUKsrY
	4/gDrqnel3l9vAYqmIBk987xwBmTlGx/hugyAXG658a7UfRc6XD7bQ9hKWA3Bo57G8KjhqmIz0f
	l+V8WqeyIrvd/+BI3coi2Oo27I1MeSQ8veEUTMi5wLjZRUkh5g1A7tU8u5gSIwHTfgt2vdN+SnU
	/OvFyFKcEDuzXijjrbJ6BpVIzw==
X-Google-Smtp-Source: AGHT+IH1dTN9h9lNDnRTlh4UyFd6aH1+EDMlfhkx9gNk7p2AjcKqv19bBUUeTsmBJjRKqPU2Xh2SmzFkyX1KkJheFqs=
X-Received: by 2002:a7b:cc99:0:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-47790b11bbdmr102735e9.7.1763072060296; Thu, 13 Nov 2025
 14:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
In-Reply-To: <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 13 Nov 2025 14:14:08 -0800
X-Gm-Features: AWmQ_bk6n8j-0ORtQ1jAf-pM3nvvAf6VB8V4V3Ju58iczpjKI42PYMXub9cNtfk
Message-ID: <CACw3F51cxSgd-=D46A6X6GptEZS8-JZ_MnB_yK_ZR1wktunYRA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: Oliver Upton <oupton@kernel.org>, oliver.upton@linux.dev
Cc: maz@kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, vsethi@nvidia.com, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 1:06=E2=80=AFPM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> On Mon, 13 Oct 2025 18:59:00 +0000, Jiaqi Yan wrote:
> > Problem
> > =3D=3D=3D=3D=3D=3D=3D
> >
> > When host APEI is unable to claim a synchronous external abort (SEA)
> > during guest abort, today KVM directly injects an asynchronous SError
> > into the VCPU then resumes it. The injected SError usually results in
> > unpleasant guest kernel panic.
> >
> > [...]
>
> I've gone ahead and done some cleanups, especially around documentation.
>
> Applied to next, thanks!

Many thanks, Oliver!

I assume I still need to send out v5 with typo fixed, comments
addressed, and your cleanups applied? If so, what specific tag/release
you want me to rebase v5 onto?

>
> [1/3] KVM: arm64: VM exit to userspace to handle SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/ad9c62bd8946
> [2/3] KVM: selftests: Test for KVM_EXIT_ARM_SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/feee9ef7ac16
> [3/3] Documentation: kvm: new UAPI for handling SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/4debb5e8952e
>
> --
> Best,
> Oliver
