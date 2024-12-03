Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503991E5721
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733231442; cv=none; b=k1HLPG0h/dbrzF0prePbqMlDsPLshm868Tt6cADzedi4YqdqxKGCqrA7wEdufLyMAF5fHXYr1R0cLbxLO7eMqTt/yqkcHd7y1AyMyzxXAJaZESvy/gJlHQn678hgQGM/f4FQKWFR+GuHib1+XCci7P5H7J+3/JBbnpnG+3RmogA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733231442; c=relaxed/simple;
	bh=E9wjGXkxZXo6et0AHWDrNIJNLH9shVHbKvVG/BUzYXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBd9i/RO6RBDaWQcttwRKIm1dwaofxW4a5ZyoLHfq5TZ04kMwLnP5N4xyNBJIiz2xAYkCiYRUgA3Tf7k7QXhpG5/8VVDSNXk9mLLEOYOPQaaAHPDPJieroRGD+uagG3XtCL6FooQVziXv+axn28tkkq8rnO053bVu6Jjhq8oVnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MwCQdVbv; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MwCQdVbv"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7b66ea49407so484417185a.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 05:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733231439; x=1733836239; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9DpOBXLLjyiG+N3LVHSh4lonGnoLSvX4rvZN0nDjDN0=;
        b=MwCQdVbvpZnAOxQ1ZfAWsNMK1PLXuDkFzn7p/x9BHAI0P80KAOGvqq323sEg2L6UIW
         R41HQBc/QKokTdnYCx2NTqlIxkwlgd0X89OrxDOlwrf2WnkY8BHcLWcNH+zS+IifAWyM
         1x/52jM00/vahgyhLJZPHUCqFltsjw7Yx/jV+khN1XpFpwXIaXwiY7Rrq0L+XFANZFii
         qK/oNy+6rs2xXyIWjk7BbaLkeP799VPqNou8OUFntH/yJE/Ue5EtMPhY9OIlxIJaKC4h
         7ZpP6RDES2R124LNjDjMKjoWgdS6rTdlmbLRZ6ga02XO7BuvDCbwsbIPgCOg4bJneAMH
         Nmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733231439; x=1733836239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DpOBXLLjyiG+N3LVHSh4lonGnoLSvX4rvZN0nDjDN0=;
        b=HH6HbqZRH0Q52Bj7yspvNDVdU3+BhsHJjBe6eYNovHxEpXm6N4Gay0NZXINXB974F4
         B4PXVLIbJuOtqgql8QFhKftPwCo2vg/1YPocXg+b553+CEULyRNgQoDCd2ycFr016vsW
         dqkSpI4DhGw246UVFF6tw6THtiRxmKoxvhO4+U/ikOGnYHVtSTVO4aRNSwuNXFNJ/GX1
         PP27cSXqktvl0juTNf7APJ9rDJhTEiRzdCcFxGLAvrWHrPFnYWwpx+tMXDDOhCfkfN/T
         Zsbd5lSDloop/OZ234mouuRxjXuLaRYYZM6tW21atYbbf8OGIvhvlb/CFVfHWsqYsjOC
         thfA==
X-Forwarded-Encrypted: i=1; AJvYcCVi+/2xpDyKmcF71HXsHYU4PsZZhtygoycWRbIZFY6l0+t+uxlyDVBHRZItxKr9cHjrGlhap54=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywn050ebqhHihO7HrWu6Ge2hciKWyoDP1JdBdmxm2FH9yHjPYeE
	BIGmoYfz2+JyuhZdDcEj2s3J0tF2yZRsd94K64Q9kUlY5B4QesvZl77Iky9g9YySilu7CBXizur
	aQB/9CEeeg1chvuJuhUuJwHgj/l8MgRy+/Wwpqw==
X-Gm-Gg: ASbGncsEzdGuTl/Fs0IXpx00jrPIvYFqIUrLhRPhntC5rO/oAgcPfDyr6t1BRkgzkGO
	BCno3gAT1W/YN8Dp2S30tGrsld7pT21ou
X-Google-Smtp-Source: AGHT+IHDdU+9VCqufyt3SzpXC2DAP0G4i5+riHGBhVvX00dwFRQDOUu4q0kbXbYL0xF/WekUeH65LcXOP02DnOppu3U=
X-Received: by 2002:a05:620a:1729:b0:7ac:e8bf:894a with SMTP id
 af79cd13be357-7b683a2cff9mr3767847985a.20.1733231439209; Tue, 03 Dec 2024
 05:10:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+G9fYu95a2Dy-R-duaieHVOM9E+zeKu1EF+YJydnaD7nxnhQg@mail.gmail.com>
 <2024120306-sniff-labored-f6fa@gregkh>
In-Reply-To: <2024120306-sniff-labored-f6fa@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Dec 2024 18:40:27 +0530
Message-ID: <CA+G9fYvhOH4iGf597VK61g_LuSU0dtohDObNzOu23H0SLP-CZw@mail.gmail.com>
Subject: Re: stable-rc: queues: 5.15: arch/arm64/kvm/vgic/vgic-its.c:870:24:
 error: implicit declaration of function 'vgic_its_write_entry_lock' [-Werror=implicit-function-declaration]
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lkft-triage@lists.linaro.org
Cc: linux-stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>, kvmarm@lists.linux.dev, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Dec 2024 at 14:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2024 at 12:00:46AM +0530, Naresh Kamboju wrote:
> > The arm64 queues build gcc-12 defconfig-lkftconfig failed on the
> > Linux stable-rc queue 5.15 for the arm64 architectures.
> >
> > arm64
> > * arm64, build
> >  - build/gcc-12-defconfig-lkftconfig
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build errors:
> > ------
> > arch/arm64/kvm/vgic/vgic-its.c:870:24: error: implicit declaration of
> > function 'vgic_its_write_entry_lock'
> > [-Werror=implicit-function-declaration]
> >   870 |                 return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
> >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: some warnings being treated as errors
> >
> > Links:
> > ---
> > - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/log
> > - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/history/
> > - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/details/
> >
> > Steps to reproduce:
> > ------------
> > - tuxmake \
> >         --runtime podman \
> >         --target-arch arm64 \
> >         --toolchain gcc-12 \
> >         --kconfig
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config
> >
> > metadata:
> > ----
> >   git describe: v5.15.173-312-gc83ccef4e8ee
> >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >   git sha: c83ccef4e8ee73e988561f85f18d2d73c7626ad0
> >   kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config
> >   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/
> >   toolchain: gcc-12
> >   config: gcc-12-defconfig-lkftconfig
> >   arch: arm64
> >
> > --
>
> Conflicting commit now dropped, thanks.

Thank you.
I see the reported issues on 6.1 branch also.

/arch/arm64/kvm/vgic/vgic-its.c:870:24: error: implicit declaration of
function 'vgic_its_write_entry_lock'
[-Werror=implicit-function-declaration]
  870 |                 return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors


Links:
---
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2phryzHX4rmjhKAc2d5Wtq7QijV/
- https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_6.1/build/v6.1.119-434-g5bbf9d2a0ecf/testrun/26175571/suite/build/test/gcc-13-defconfig-lkftconfig/history/

- Naresh
