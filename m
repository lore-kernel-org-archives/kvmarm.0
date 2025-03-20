Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10424A1D
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742466827; cv=none; b=ZHdM78Xbd1LAkNkZH2WCfEf1Yt0TJhaoTzgCaSSV/6vLCdWxE9KglNlSMaArK/+IxfqzkPj65LJbUaqi4T3xVOkEkURVDqafO3VhogQV/1m+/tGXjn/ICCQz5WEEYznqMbnnKI3jM3mIpUyGq8vo4lZ/T/9jSg//1PAkmyWhbuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742466827; c=relaxed/simple;
	bh=xJY57fFKt0geDFWUIjkhpA/COD633fJgusXPp3/Xy2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajd/CKZS0MN+C6Aci0Ne6S3ogmzFDz6iTLq9S+Svuh575BtkojXndK1BhwSnKIEStzNkmTglkdy4IOtrsyzErBPqzgFElIhm63/mKSNg6+AHvoHjGzNkQQ/JB/Qa4PJqG5PsK4sD2+TtaXFK+LoqI1ps8Vx35pXX3pLUrBgnAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r1+X+tuZ; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r1+X+tuZ"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-8670fd79990so222140241.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 03:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742466823; x=1743071623; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BKKpQAQ6JgcOkfxottrkVvBcXRW0On7hjY41tdShDfI=;
        b=r1+X+tuZy/uCoCSWR8IpnBlw+yvZjmdvzm2gS/PgRV36zUU2eRnP3SbLsMnR1GsxQm
         kHI3wLrhzXto9ye/ECHpgew7m+GHkIoKTikBgH0iXC+8mXjxGnPFdRABOsIZ5kEFmvOu
         b7pXmW5223bXIxOgXbDOCQAcT5WsJohT8uqyXeI6X/DYFzu3HUbjdM0yzrR+RPCgmQ+w
         kqMVC7NTl4gg/L33T0F+LHGDDS7/uBUR1v0uPMPFUCc9l43qxqTFFM8k+gpQi6NRF7u/
         sK7YaNDOrWJxviNJfQU8pi0FBWPEpimWEgROEnxGcW3skLxlLYRh+mpEDwmPP92GoWzu
         jMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742466823; x=1743071623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BKKpQAQ6JgcOkfxottrkVvBcXRW0On7hjY41tdShDfI=;
        b=dLNlqvUGPoabPxs0u0dAAIFo2EKyYGBlSZCuxBoWne0Oiwm5oWsk/ITabOrWfRJ58f
         mv6Du3pdBq/Ao0PddGsYrtDxq/ndqHZBDsUbOTlmUTpiwsyMO//jZV6S9G0yyT+8wCsg
         m2ac61A2IbluZirg+7uCr4+tXig9sj9dKHIycABHBstyI+l+jPazrNsCEJKLDDz6Sz2K
         efsAJ3Qt5hExGofKzCdQ1cbwOyQN+oZ1HRyKUchpFACnBmLH9hS8rWWvjH1KBZq2zJwr
         MPpxkTM4cfxs4kyNJm8y+jzL6P/lljzNGBocTZ9Vq9w1IIQYDEzDYcRVfPF+6/j6+MRR
         eVYw==
X-Forwarded-Encrypted: i=1; AJvYcCWFQOUsQCbryA/rs5AyyktNsI0iL0f884iUp22DG5zzr+2vPqvNqUbqz7MxW91TqKgy6zfnMtc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqfNl8S9MeLfXOIK48JfNkVbwJMIwQthRylr2H/z8wFHFzRxAS
	cMZjswCAGBT/S+53QoHiHDecs/q1fxP1pN16EO/uuzTWfVqi1EJa2mXQXg+bWn+BkAbnWFGMeRA
	4ror8cD4AlIZ2cVByqc8Dk2+KUNFOtuFE/QASsQ==
X-Gm-Gg: ASbGncuXoLR/YCHvH+JSdcgm7erRWi/uFg7DcfkbN2kChMdMTWsi8FZgautl1CWJwLI
	j7+yKt8SfEs8F0LayFH4Y5mWdBJHG5X+muVcb3VbItMsWOUNj38BYrQ7E4q/KZif3cLx7ZAno6T
	08I5qsIFGRfJhjfBvSpxBBc+iRDjUUeKmaYAne8hmt6nD1+T0h045uY7VUnakQNWXrWQ==
X-Google-Smtp-Source: AGHT+IEL8RynGDkzUn1M8qBaw1QSAu13l5oOS82op5r8NMWrFV9NMAszQoaAc7xxXxzXjG7O12MUPb/cR4HugdfzEyg=
X-Received: by 2002:a05:6102:26c1:b0:4c1:9526:a635 with SMTP id
 ada2fe7eead31-4c4ec82702amr4521750137.17.1742466823418; Thu, 20 Mar 2025
 03:33:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+G9fYvPu+MQKhYyPZSSDpAn-zhRGmeHQ8hJksT_cdDdxfbB-g@mail.gmail.com>
 <Z9ra3I2axii2HRVb@J2N7QTR9R3>
In-Reply-To: <Z9ra3I2axii2HRVb@J2N7QTR9R3>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Mar 2025 16:03:32 +0530
X-Gm-Features: AQ5f1JqkKZULx7GkLi5GllTgOKMVJsQK1_wwFux-C6kOWnMYdf-RK7BCgTRrZ5A
Message-ID: <CA+G9fYuw_jXCz07Dsk46QXQr3+y5-NfkC30ZNh+XmyeWgibQhA@mail.gmail.com>
Subject: Re: Fast model boot failure with Linux next-20250312
To: Mark Rutland <mark.rutland@arm.com>
Cc: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring <robh@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Aishwarya TCV <aishwarya.tcv@arm.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 20:25, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Wed, Mar 19, 2025 at 08:07:47PM +0530, Naresh Kamboju wrote:
> > Regressions on the arm64 Fast Model (FVP-AEMvA) caused boot failures starting
> > with Linux next-20250312 and persisting through next-20250319.
> >
> > First seen on the next-20250312
> >  Good: next-20250311
> >  Bad:  next-20250312 .. next-20250319
> >
> > Regressions found on FVP:
> >  - boot
> >
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducible? Yes
> >
> > Boot regression: Fast model boot failure with Linux next-20250312
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Anders bisected this to this commit id,
> >
> > # first bad commit:
> >   [858c7bfcb35e1100b58bb63c9f562d86e09418d9]
> >   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> >
> > NOTE:
> >   LKFT is currently running FVP Fast Models version 11.24.
> >   Planned upgrade to the Fast Models version 11.28 in this sprint.
>
> What firmware (and version therof) are you running within the model?

Fast Models [11.24.11 (Nov 29 2023)]
Booting Trusted Firmware
BL1: v2.9(release):v2.9.0
BL2: v2.9(release):v2.9.0
BL31: v2.9(release):v2.9.0
UEFI firmware (version  built at 22:31:25 on May 26 2023)
UEFI v2.70 (EDK II, 0x00010000)

We need to update the firmware version at our end.

>
> For example, if the EL3 firmware lacks support for FEAT_FGT2 or
> FEAT_PMUv3p9, the kernel will trap to EL3 early during boot and die.
>
> It would be really helpful if you could capture that in the report in
> future.
>
> Mark.
>
> >
> > ## Boot log
> >   <No crash log on the console>
> >
> > ## Source
> > * Kernel version: 6.14.0-rc7
> > * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > * Git sha: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
> > * Git describe: next-20250319
> > * Project details:
> > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319
> > * DUT: arm64 Fast Model (FVP-AEMvA)
> > * Toolchains: gcc-13 and clang-20
> >
> > ## Build
> > * Build log: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/log
> > * Build history:
> > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675685/suite/boot/test/gcc-13-lkftconfig/history/
> > * Build details:
> > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/
> > * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/
> > * Kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/config
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
> >

- Naresh
