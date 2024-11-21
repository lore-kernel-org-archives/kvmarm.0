Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2830F1D4325
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 12:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732193862; cv=none; b=dAY45K3qenkNCq5RI/Kw+e5ptmIk6kZefAonvga3OqzlujfpqFZK+3c58wmdb+5c7OHd06NO+UY9fFMJr3KD3uKbipoLlmuzQOvliVpLLdPYBeOooSvQWYtNqlZFIaYcchq9SqC7Lum6auAAiYuvKcIY2PvRd3e8HjlNBgkfUcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732193862; c=relaxed/simple;
	bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SEILKM7fPIv1r3wFf3cq7xjwh7vxqRIIsXhp1eS98WppVVZc6liSts3mhPDz2t0pNvq8ao34btzzgMlDlLujAsrWsm2tidzeq2IqlT4y17pVx8BkY9tsSaI4Bz8bPtcTvdDUDXkAfd9yA7EW/GERlqQ1ev4KSi1NwGYtOpBbUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=N9P3jtRW; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="N9P3jtRW"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83ab5b4b048so31509439f.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 04:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1732193860; x=1732798660; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
        b=N9P3jtRWiPc2jPVEw3cwDh7VtZd7HwxmWb6Fxo9bRo+eQJ8dY8d8ZtK60bf1Q4Zv8j
         3IMdLxH8AoXmwNbvXZNjoSv4TbCuvj4QhlF7pZdxfvPh+X6ozJuf1ZKpQxaixHdI8zGl
         7606aSCMAcGhIzp3B57I8FhOZoeP9Qz45kvklHPAvuaMSLaO4YjR4rGG4A2R/f3/qhDj
         fiH+KpqFb0mQ0NYzSzo/gu5kKIbY1Hr6EPODrj7gEC+Wx9z+7OKAzHoWd8JKncCg/D0q
         p9fpzAmjnrSbLDaiSW0m0YE706k1n5O+wf7aC7ElStxs1C1Bg0RLZnyY4xxdGnckBT7q
         zU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732193860; x=1732798660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
        b=nJUVPqayBMBYdVB2la9o52hYQ/fGGYrtQVHcq9MrShT6wXrTtoe3lEBR662oHGtiwc
         j4p4HJsXtAqE/6CBNcLV5fKZeTGZ3zIaRkhSd1HMRU+RLAz5G/oJXhy50kQJt1ekuVpI
         +SRdSdXlH4+qREvfkfVWkswLjjekd2oTR6spJqhDrKqXN0//xkd5/L/YW+6h9wOTk31c
         quRorJlsspxuGPYW5t6kSv4uItedUXf7DPsQ6ryuJs0tAIxZmdZAWiDmVTKLGytfhMuI
         i3QYd7LNRLyORrYbUEcBA2emr2HTDFkTh+eGBHJ3b4WwAnUEQHH337PoNzRxUuB83cvP
         O0Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXdb7LCc8Nj/yWo5BJ3DvdHjutlQMj4j+Kza29CWrOSFqYZMQmK62suVWC6WrYoYi/WPTcvV28=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHB6j6xJ37cTx3OS/jkf0MzztXKiEKvQKQIKxJRS44WeY6wh4h
	uzNp5xLP5sOAHKPI/XARe6UA/Al/3Bkg8KlqPGkoLc5XBXRA+0oHdy/CSdtkZkMQv6EFgPG3ZG2
	4ZyQJ6dpEreGke5iWAHcqoNMClmjoZSv7p9btFw==
X-Gm-Gg: ASbGnct6W4ylP2m1U6h56bkt82FXqyBeUR068eVzJx70yb1Q/4QfeoKTHuUDaGgSYgc
	wYDW97AUWG5R4SDbf3gCPtB3sAblQbkBF
X-Google-Smtp-Source: AGHT+IEuMAfheTfDdr4+8Y1kED12kvt+khaXLolzlsHEkGdCT5FWGNrCEZ8eDC0cqfJZJ30dpcXdBsCszFTBAkK5hm8=
X-Received: by 2002:a05:6602:1646:b0:83a:f443:875 with SMTP id
 ca18e2360f4ac-83eb60dc727mr748423239f.15.1732193860201; Thu, 21 Nov 2024
 04:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zz7vLEbLFXuRSPeo@linux.dev> <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
In-Reply-To: <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 21 Nov 2024 18:27:29 +0530
Message-ID: <CAAhSdy0fwv+0NFM5H3UYFhJf9fwrTTKe1UupHj9me=OhHXfDyw@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM/arm64 fixes for 6.13
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 4:31=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Thu, Nov 21, 2024 at 9:28=E2=80=AFAM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > Hi Paolo,
> >
> > Had a surprising amount of fixes turn up over the past few days so it i=
s
> > probably best to send the first batch your way. The LPI invalidation an=
d
> > compilation fix are particularly concerning, rest of the details found =
in
> > the tag.
>
> Sure. Anup, if your second PR is ready please send it already.

Done.

Thanks,
Anup
