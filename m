Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7D1BE66
	for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710315726; cv=none; b=WS5t2TduvZcCv9A/UQHX2WcUF+UUdfIXc+MXDgJSgXB3q7wxoeSsTlBld1EpIM+9rf7l0V21eXU7KgWjocu2g75nRNv6jUgA7Av1/Hj03GoOfW0C10gOE7Av6IpwPld5j7IefHXjd8f4d3HqMlstWrctRssBXexahR8iEW5U9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710315726; c=relaxed/simple;
	bh=fuYTIC3nVUj5MyFc0eZVYlQzJDxs+W00tM5m6Wwk9wI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQ4ZNQZ4PPnxRwUKQ1H3XFj0cDtm6e3kdL/dKrzCCbmGN53Tz7c9mb/heiZml3bcINDoIv9n940lMztdzQhigar5s7heeANsoKiNRyolT/bcgWL02uoUPiFwqS+opnamhp18Gthw4EWA+7v6t8Buh1iI2L+l4P+ITKWJ+oirhWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6aA1uBH; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6aA1uBH"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-563bb51c36eso7342215a12.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710315723; x=1710920523; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB9ZKn1WQyo25KpHERFSuVdjhh2lPDjMXTJozAJQBhA=;
        b=T6aA1uBHZO4s7IXZYiNTJSZmP9c0kyaBpf3UNoKQPfTja+ZIqjmek8fyEUNra0t7Kq
         +onD4nSjiK72q8c+t9IJ1t+9mQgygzqdRkG8t+Z4/PCuGyXxq5Zo2WZsxjFOtPE6tgnv
         X6oauZCXsOVhoK9nZTjxOaelgsf3mvNM8sXE6ExW4USYkEoquO+RrSYw9DGX31y9ADZm
         I2H6R9WpydNPFGFkCM7MUtmJNT88R0OigIYtCjaK7WEuBlZ7yxuOqXvE6uRIVgRC/fFE
         z65pLFvPnAK2zFXKl8DUe7XEVHwPN/qz6LZg3RtPF8I73l+uQBFLrnyEo9zh8rhEF/6R
         EgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710315723; x=1710920523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JB9ZKn1WQyo25KpHERFSuVdjhh2lPDjMXTJozAJQBhA=;
        b=wN17unBjnWN214BsAQqBhpdqhGh2pgG2GqAj/d0mVJjPk29B/+DsoeCwvIhGcZbTW1
         MdObGaTXisQXRcZE950YbAjtTWnV9J+cALtX4ioJBsUu/8ZVGuQEbbgjzOJ/OYtN3f/C
         0JUROanj9l1Wyf2g2nqYLMN5cOraKvr3/WqGMHM3pX39m0FSZxpUtYcD99ErAh1OZQUb
         sBi4ytvta5DzB7xm1u3CEU30EG7gqUb55YxXL6OsVMaxuYyqhu00QqRC7dWj0kpdDxW0
         6UWZu3VyR70L9Y4svPPOG9oTDI+wfGLeymSFEy4JoC4KtJiKIoCvmegmXALROXXeV3E+
         cg5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPYcXt7gVPPoNqbjsWoYVaFnEeTGHu2WiHcDfzaBQshdA+DMQd3u3v1Zfnt+XWWtY53tZ3+kvBtY9DkhFAaAleq6OHCPVI
X-Gm-Message-State: AOJu0YwteHfPJpAQntBrOfQdxUZjDjMJeGd7hpM9quG7SH1cbq03eDAN
	nAD96LOp3A1Uz2BpFlpAFCUf6exMCuir+1/y3BfZx5Wt10RwlsbPVTrbDY9dL6Z9MHLv0hGlViQ
	8pQa3OEwPRxJid+LnNc3fvLTKXpo=
X-Google-Smtp-Source: AGHT+IE9GcGZtZ7tNVNDUWfdNp47jXNvjT7qH+jP4m7epLAE8uVbmKGfY0phd254UGioaKZGPPU709mx3bHF2KdDHQs=
X-Received: by 2002:a17:906:cd13:b0:a43:9857:8112 with SMTP id
 oz19-20020a170906cd1300b00a4398578112mr6590474ejb.20.1710315722600; Wed, 13
 Mar 2024 00:42:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAKHoSAurcujiErjTeWM+ZGkSVVOj3zQu2ED5rZsSLq-+FXb1qQ@mail.gmail.com>
 <ZfE41uSsTUmbtl6A@thinky-boi>
In-Reply-To: <ZfE41uSsTUmbtl6A@thinky-boi>
From: cheung wall <zzqq0103.hey@gmail.com>
Date: Wed, 13 Mar 2024 15:41:51 +0800
Message-ID: <CAKHoSAsZRg5sTuLMTzSxmuP0_qBKrXvMYR2R1SZt_wNH9ONbLg@mail.gmail.com>
Subject: Re: WARNING in kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Oliver, I have confirmed the situation about the sha1 in the
path that is my fault. I will test this crash in the latest new linux
arm version. Meanwhile, more batches of the reports will be provided
after validation on the new experiment.

Best,
Cheung Wall

On Wed, Mar 13, 2024 at 1:25=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi,
>
> On Wed, Mar 13, 2024 at 01:02:10PM +0800, cheung wall wrote:
> > Hello,
> >
> > when using Syzkaller to fuzz the latest Linux Kernel arm64 version,
> > the following crash
>
> First, thank you. Glad to see folks are fuzzing KVM/arm64 now.
>
> > was triggered on:
> >
> > HEAD commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a  (tag: v6.7)
>
> In order for these sorts of bug reports to be actionable, they really
> need to be against a close-to-upstream tree. 6.8 is out now, and 6.9-rc1
> is right around the corner.
>
> Having said that, I think there might be an issue or two with your bot
> because...
>
> > git tree: upstream
> >
> > console output: https://pastebin.com/raw/3NCyqPUn
> >
> > kernel config: https://pastebin.com/raw/mXEg4abU
> >
> > C reproducer: https://pastebin.com/raw/N0gEqk5x
>
> This reproducer doesn't work on upstream (tested kvmarm-6.9 tag), and
>
> > WARNING: CPU: 0 PID: 711 at arch/arm64/kvm/mmu.c:1592
> > kvm_age_gfn+0x64/0xdc
> > data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/ar=
ch/arm64/kvm/mmu.c:1592
>
> The SHA1 in this path is suspiciously the same as 6.1.61. Are you
> certain the bot is working on the correct tree? Nevertheless, I think
> the WARN and associated bug were addressed in commit df6556adf27b
> ("KVM: arm64: Correctly handle page aging notifiers for unaligned
> memslot").
>
> Last thing -- I'm guessing your syzkaller runs will dredge up quite a bit
> of low-hanging bugs given how little exposure this code has had. Could
> you please aggregate the first batch of reports and send as a single
> series of email? Makes it much easier to keep track of.
>
> --
> Thanks,
> Oliver
