Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040522AF1C
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731345033; cv=none; b=McJUsqFscJtjGeQcUK/9YAY2l2nvfCYrir0Sy6nf0hsbpyB9C2iIXMTqjo3XFhFjxQ2QQi6bOwGtXjQX9Ova7KzqRIsNns/rh5kDiYHQZUxbrFClN3+jI6TAGikdF53tG/bmN8DS7KoOnzG0L8Vyc/w8xg3junCDAByaljbb+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731345033; c=relaxed/simple;
	bh=i5NhtbwOcLViUAJdqOOQbA/lmCYxIBb46SymhlGhA68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYVb58UEEdLDlVwxTyp7svBl8Xnja9qEcR5uGpHlxHl8P31oWr2UsleAV8kUdpEnn1w73whGeXWiieVVrDhd8y1FU6Y+ynz9Er+qLXhVdxrjBZk8zdgDdX1e8G/+Z/8XqAYTRg17gUmGyqL5HWgH/Yvjb4aHo+fw7hG9PMlVSRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nbEVn98p; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nbEVn98p"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c932b47552so20503a12.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 09:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731345030; x=1731949830; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZbeLLseB5b8+ehFZfsw37ALHDLGBMJMLyk1xIdLiNI=;
        b=nbEVn98plhTExN9AHM0Hw9S3NMn0qvMl46+3rQUPmxOHOYbpvm2whylepT3p7OPkF3
         UyC59l4EktninmJ2GJcegPpZ6n09W0KEgj9e36rQLVSnPNbK7gukVUl+MF+eocdNKAk/
         yM7aGg4gfHk2fAel42trSEjhnR6fwtP+QNG8ZvwOaMt8DqMO3allGuOYadWdRRzaJ0Dc
         Nblt15UX+j52JPnrLWyhNnRu3QYu3EpIz9N2SDmmtG2wL2ArggpWz/5mhT/uoCLq6yYU
         pDQ1yMVDprgi5xkqUyMQ4GmZy94EXYEAZRXgCbUM+BeAUJU6crvMM9XZ28JUAx3trSrf
         JAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731345030; x=1731949830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lZbeLLseB5b8+ehFZfsw37ALHDLGBMJMLyk1xIdLiNI=;
        b=wDXojHzzITiuyMu+k98/t8bs1HkPqdAv1CEiylsl9lYYXEV1k7JYthwypyNRrRh31r
         vbvJBGYxHFPolkSpbUeDeF18GmmHGVvIa0VdaQWrbO5cwEi/itRRPt7g2FDhW7x5SYkM
         0A1gXitHpDD50SVXXZi1KfggstA9jWQd3NLDj826WcoV+sXq+6swFhxO+KguHbMfNeSn
         PJNTKykkeSbjPmVmTrhAJLfCpd8xpnS2bAw1yibH1XEAdZ9B/7/fQiYXWy1SFAxUTXST
         K4UcAkudhvNVMKxgVJV9dFBlIJOjjxTRkPePWydkFbkOHIgW2BRWGV0EEBHdGn920A3h
         Uk8A==
X-Forwarded-Encrypted: i=1; AJvYcCVv4NU+mMs4ph2SuvML2Glz4HHiD0o/RLSKR3HbcS87kL1tXcLWQStOad5f6wn3fYMAhjkGccQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/m6R+0dwM6LoIEY9PVmDlUXjh68LnerXyBNktf1Sfi4zgqlsL
	/1qBtKWrr1y7Kaz9FYpdoptM82A1wnwSLaM/ocslid16Uf+FUzUPs4UwhpxgkFqiUwkx53JM0+B
	/ELE9ZwMNAwhTLE37DSRqT5I+r7wl55fED/Hn
X-Gm-Gg: ASbGncurBlQBtYYVWqlKzLGp6UjIw4rvHGqi+tG4aJscBODuZMe273aMRoSPUM3IzUL
	22did4k5aApNObeflVQF3PWmUk5IRGc9qAyW9SM30R52cMhnEhphrlBN2Z5KR1g==
X-Google-Smtp-Source: AGHT+IHgerBC9h2YwDfKDijAh6osZ2kMh3HmOgZnIMcMCgU4EDXSlgxbGcjXjle/6Rd24wYQJ071PNSrdzccO67zBYI=
X-Received: by 2002:a05:6402:7c2:b0:5c8:84b5:7e78 with SMTP id
 4fb4d7f45d1cf-5cf1c83cea9mr353370a12.4.1731345030142; Mon, 11 Nov 2024
 09:10:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241108211446.3304809-1-kaleshsingh@google.com> <86r07jz6uh.wl-maz@kernel.org>
In-Reply-To: <86r07jz6uh.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 11 Nov 2024 09:10:18 -0800
Message-ID: <CAC_TJvd=fNRx2VOcEEgjdkY53MwpR0Xa4dX1KTy=nNew7dg9Mw@mail.gmail.com>
Subject: Re: [PATCH] arm64: kvm: Make nvhe stack size configurable
To: Marc Zyngier <maz@kernel.org>
Cc: will@kernel.org, qperret@google.com, broonie@kernel.org, 
	mark.rutland@arm.com, keir@google.com, vdonnefort@google.com, 
	kernel-team@android.com, android-mm@google.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	D Scott Phillips <scott@os.amperecomputing.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Wang Jinchao <wangjinchao@xfusion.com>, 
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>, =?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2024 at 3:06=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> [that's an impressive Cc list...]
>
> On Fri, 08 Nov 2024 21:14:00 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > In order to make the nVHE stack size easily configurable,
> > introduce NVHE_STACK_SHIFT which must be >=3D PAGE_SHIFT.
> >
> > The default stack size remains 1 page (no functional change)
> >
> > Downstream vendor features which require a larger stack
> > can configure it by setting CONFIG_NVHE_STACK_SHIFT.
>
> We don't let make the stack size configurable for the rest of the
> kernel, do we? Why should a tiny portion be treated differently?
>
> Making this configurable means that testing is harder, and bugs harder
> to reproduce. It also seems specially designed to allow badly written
> code to run in hypervisor context. And once you allow two pages to be
> used (up to 128kB), what prevents the "downstream vendor" to push this
> to 4 or 8?
>
> If anything, I would prefer to see this (obviously out of tree) code
> isolated with its own stack instead of growing EL2's private stack. At
> least this would make the problems attributable to the guilty party.

Hi Marc,

Thanks for the comments.

I tried to be conservative with the configuration only allowing only
up to 2 pages. Your points are fair concerns, I can see how this still
may not be ideal for upstream. However, I think introducing
NVHE_STACK_SIZE as a refactor still has value, similar to how
OVERFLOW_STACK_SIZE is handled. If there are no objections, I=E2=80=99ll
resend a v2 of the patch, dropping the configuration parts and
focusing on the refactor to introduce NVHE_STACK_SIZE.

--Kalesh
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
