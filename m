Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC787143735
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491431; cv=none; b=WF7VwjCzUpwnrm1uM/IWFwK9rRLIn7FcQiMI8LXjiYBCVzmzNk1J2RsUKkACBGYDc65ijuHjncNx7OH0uIDoe3oFDnUfcwY5jnEupwDIW7os/V6At56ja9sdGRJrBq2KxkhoMzsbpyLvhxcBWzISQuzqIYcdXbg8R3helT/fC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491431; c=relaxed/simple;
	bh=L7vaVXitbnHT23VpDnSPn+BGD/qid686IAqmHeVFCpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d2UlSEJ3q0qvQiC6waNqQG5fXsjIKKciTv/WmymCwLqtfewuKHVYmCw8h92DtD/6Ps5CPpxunAiHVJj7CbLcGwD1Zr0E0maIjm7GywwM8wV3ySzkcQNtd0mZpJVsMa4+WSX3D8wWUC54CugHuTNf38augd3gXrLR+L3aQZZCU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aZxZJO96; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aZxZJO96"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-61d35d266e7so5185137b3.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714491429; x=1715096229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7vaVXitbnHT23VpDnSPn+BGD/qid686IAqmHeVFCpg=;
        b=aZxZJO96S9XlZrEfToFnUUh4IKKDR9d66LDmY1ctrUck7u+krKBU+97uz0XNhsmB/R
         kwkiA/CNX/cC1OHTy6P/Dswfjsx+bNjcAV3YH+VKdknh6PlVonILcsfqH4Z5o45w5I5B
         KOpPe7QZXGVDuVo92gEGG8gbnzd6DH5JB2knCoPlZ0WCZLrz42Ync/emEhSU/CXU4Agu
         DYstf4RL8eTXFadGXQtUp4jj7OPGTRLwB/z1yZZwkmd9vj34kWyXJMAkExpJkluootto
         X4uwlc03WudkMFZN+niIs9NrIRJ8Oz5QTd2CzHibjcLhdCMDnbyKGfrktdonVbfWgcFm
         zdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714491429; x=1715096229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7vaVXitbnHT23VpDnSPn+BGD/qid686IAqmHeVFCpg=;
        b=FuASNbU3venxg9+/wyClxoHIT1+6pd5H2uCGCHA/2lJxcg1lrZluYH/pfGInnihJcW
         ZnhmVzIYIZgyE0IeKqs0BDLfM4ZskC3EskiCOC083SznhwqgMFnjD9WoPgujmlMYXr5i
         ehcpLemSMWBf2pwx6E63KfdwxShHVJIAwUKFjHdP0TbaVmv0Dj6+HnZBi5hMTuRHIrAP
         4Nex8sBA9227/zNhI9iV7ftsZeS8IG67OotKSUUT39HYrZopYf0cITT6dtqDdJ3uAEkt
         RjWLVl11Oq8A4laljGD4gNmkGfuOq+XAweOeWJQjxpzTz5W+ulsy1o2+Pswx9QCq6haP
         dlmg==
X-Gm-Message-State: AOJu0YySKBBY/ivRibrE9fHFAzxGFjQtukVZH+5Vuaac+TNwfutpKprU
	F0z0mBwwl/g5boAlX9G0CpgW/5rf1DV1HVd8CdTXt+Q3uOuTNLMmT0Tss9sLWIyujIhCCil/3QR
	wdgT8xmk3G94EdC28Me7N/rvy6scPcrd2PtUH
X-Google-Smtp-Source: AGHT+IEB0vaoKqdLucnzNy/WVYnc5III3xaA/fr1QLQ831vtFbrFzfOyf9kNbpQWZzE5796iz3CTfzBEz6nHRY0c5PE=
X-Received: by 2002:a05:690c:3343:b0:61b:3345:a349 with SMTP id
 fk3-20020a05690c334300b0061b3345a349mr17363276ywb.3.1714491428565; Tue, 30
 Apr 2024 08:37:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <ZjCn11tZ-XkD3doB@linux.dev>
In-Reply-To: <ZjCn11tZ-XkD3doB@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 30 Apr 2024 16:36:32 +0100
Message-ID: <CA+EHjTxVohmCnM7U=QPQ7MP-Dqo4BMc2gaqJc7kexQfR7pUtmA@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] KVM: arm64: Preamble for pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Tue, Apr 30, 2024 at 9:12=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Fuad,
>
> On Tue, Apr 23, 2024 at 04:05:08PM +0100, Fuad Tabba wrote:
> > Changes from V3 [0]:
> > - Rebased on latest kvmarm/next (dcbf421a8c08)
> > - Dropped atomic and locking patches for now, while we rework them
> > - Misc fixes (Oliver)
> >
> > We are getting closer to upstreaming the remaining part of pKVM
> > [1]. To make the process easier for us and for our dear
> > reviewers, we are sending out this patch series as a preamble to
> > the upcoming patches.
> >
> > This series is based on Linux 6.9-rc3 -- kvmarm/next
> > (dcbf421a8c08). Most of the patches in this series are
> > self-standing, and can be applied directly. Patches 1 to 13 are
> > fixes.
>
> Thanks for enduring my feedback. I think a lot of this looks good to go.
> I'm not convinced that some of the patches moving/refactoring things are
> a net positive _on their own_, but am happy to take them when they're
> paired with the feature that depends on them.

Thank you for your reviews! I'll resent these moving patches later
with the other ones in that case.

Cheers,
/fuad

>
> Marc, sorry to be annoying, but for patches 1-18, 20, 25-30:
>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
>
> --
> Thanks,
> Oliver
