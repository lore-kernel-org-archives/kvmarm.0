Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2384D50267
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 08:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773383; cv=none; b=qVAU77MxBrNnOQ6XH8HKUvVqRVRn/hDlfDx6iMFf/gb0mgWlfaY/3kYS299gcLa1WFoqwaogHF4CrQcAdUACD8xwdg3V3zR8P0tVz4UHpwcCdK7fmgEELU2Nj7tnPGSQaJXqga6RhfaS3+r1AEnEqRiVq+O1rUrvnxEG1/guO8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773383; c=relaxed/simple;
	bh=r6t24FzqSmzOwmkatLq5kljkt6r4RKtS+P3CAx/70LI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u0CBoE63iS+HyqQNqZx6Te7Eyu0i4vC3Ox5DntEeRfMraRV2Qa7WS7qaozI0QfioTeLPRl7yiX7hXK4kmwmZyiTbJ8jqYy6beGe3aI78mOjzX6gLA/gjrFWhu16MOZDZV6TOCW1NfKlCsUKK84PoYSUWCOB60s22wciZC2fxTVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DUXDNwfB; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DUXDNwfB"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-7ec9c994c27so200530241.2
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 01:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713773381; x=1714378181; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6t24FzqSmzOwmkatLq5kljkt6r4RKtS+P3CAx/70LI=;
        b=DUXDNwfBocjHPRbfkTmbzS83VAdn5rP/bhYqaqSHmQVZ/jd2v3fo5+OkL22SyDYVIN
         nfa4K5YHC8TkYE7iQ3j8SctpTnKvJJ+AR6ZDoBPwbyl2Gv6x36mC2eJzdLp/f4e7tSeA
         cQC22/iiFG1AlF8YZ7wX/IO6O3BHwKYLAMc989ZoO/zvshi6EbIb5gr/TvKBGqJjFXoI
         Z3iflARJuWPP+PxrE6XHW9N64RRmbVLLtkaRUhqkZT3QB+fQ/EWvE9dEUmZ279TvCeng
         ppai37jVJHofc3Aqch6tuU8W+mdEXMGDdL/X7DpPOZ1tQZgr4d9bb0F3e6fux73BYUuB
         PE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713773381; x=1714378181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6t24FzqSmzOwmkatLq5kljkt6r4RKtS+P3CAx/70LI=;
        b=sc7fci37dnPLJnAQKPJCx+jHca1vBPmUgSCSahRE2loMsU99o1ORpiuRnsKdyeexm5
         Ye/JPsLxR4xkT5Sxy57Tem7Y6FdwrZJTHJ1fDGWf1rlfFNWHN5YbjMEhYMrUcQH378oL
         O6bQr20VawvMKeoMBdCx7DO3dBjcymZs6N6o3DMWrbn4BokQYpvjss+E5p3Fwd8JCFsp
         qCzv8XUHvFmSBW4wyiy6bkj2qFL1PTikU69S9dp+ecp/skyM2+7esmFGtFb3bMEsb229
         LLAQfc8RId3vIiMSdyIjqNYW3T2eCjjxwGs7s7yDOaO+S1j9JfI5JzbQJsm/qPtFyiwg
         KXzw==
X-Gm-Message-State: AOJu0YyH2qOGNjfJmKktsLzYII6FOWgl2VPIWclrhW/qgGfu43UB9o7Y
	Vv1yZV5PkJ/jrSzZXI+0tFx//VuTSDLvKx5Ea9I59+wAjSZ/TTo9GF37EuuYVd6PwlrCBGEM8lQ
	olPazJ2MY75JJOUmVBIWPuC7obcwrbNzf7C/a
X-Google-Smtp-Source: AGHT+IEVciGwM45zjp3H7XfVQsO5UQoXgb2bRnJ5rXOiaVupReko9ZxSKav9V1+U2F6/ZOwSpIYb4OpIbXiiLFTT3zo=
X-Received: by 2002:a05:6102:12c6:b0:47b:b944:fb9e with SMTP id
 jd6-20020a05610212c600b0047bb944fb9emr6749945vsb.29.1713773380864; Mon, 22
 Apr 2024 01:09:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com> <20240419075941.4085061-12-tabba@google.com>
 <ZiLXMo1nFkgXGS-H@linux.dev>
In-Reply-To: <ZiLXMo1nFkgXGS-H@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Apr 2024 09:09:04 +0100
Message-ID: <CA+EHjTx7G91aSt8Zdat7XaQnKFNAiWXdezu2_COZn9gk2JnD4A@mail.gmail.com>
Subject: Re: [PATCH v3 11/31] KVM: arm64: Remove locking from EL2 allocation fast-paths
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Apr 19, 2024 at 9:42=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Apr 19, 2024 at 08:59:21AM +0100, Fuad Tabba wrote:
> > From: Will Deacon <will@kernel.org>
> >
> > hyp_{get,put}_page() are called extensively from the page-table code
> > to adjust reference counts on page-table pages. As a small step towards
> > removing reader serialisation on these paths, drop the 'hyp_pool' lock
> > in the case where the refcount remains positive, only taking the lock
> > if the page is to be freed back to the allocator.
>
> Surely the ordering of these patches is wrong... The refcount accessors
> are non-atomic until patch 27.

Yup. This is the patch sender's fault (i.e., mine), not the author's.
I'll fix this on the respin.

Thanks!
/fuad

> --
> Thanks,
> Oliver
