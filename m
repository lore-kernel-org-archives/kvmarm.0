Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96DC8248C
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753483153; cv=none; b=gndDR+VoEzT3J2Zzcrkg9Shy9+LO+IcjzkwoEIRPn0inS7Vzjo++S1a/XMenXYCGPQl0KI1Lp5GWhrmPC3UeaXx32hA3FgiZxJrM+wOmoiKcOqLcaPQac8Sj80d/rneYuuqvu3FIJhj4Wq67i/Gu/C/C6h90oUkfbtXmGs0VpM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753483153; c=relaxed/simple;
	bh=D7Oa2WAJGVlMSA3lhM4bJCeIiMf/9/5+L3BSd4d0QzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bzlPTyXmxYx+KXHFCKM6sK4Jq97vNklWIOwGx07OcAv7mLbq1Ig9aKJhnG9AUO5X+jHZU+lLoKkCf28L8kNQh/190qODTOxiyM6vJWlUIt+vYS25kmmqj1SB7tCVCk7/7qviq/UapVjkA86mTUztp58u7qSTtp7I9OJhql97hQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3jxNhQd; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3jxNhQd"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4561b43de62so28505e9.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 15:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753483150; x=1754087950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iv5k4xFCPNa2vVbv5IcTsLR5XM99RD3akb1r63WqZv8=;
        b=V3jxNhQdhhwF6n1cQebzDVA2g7KPTLjSl6AcXasO7anDdOoTBAuYjzapx/576ZKqMB
         cj9l+24Yn3WYO4rLQOKirA+ecgFrPwl6FhXhw/ozK0x7mHonm0Ev/XArYNDf9JK35g6u
         KAhdF0GT02YYnpuAk09HWsCfiUmVda4p2uu5w6u1y3b6X0FPr1jvd3bWyc5pqdExF5DT
         QRc9LoVernobbkkgqIHnB+M5Um3lvTUG0h6ZAq8v/ZEa8Iff86al8BQud4V3EmnBqldT
         MA6qDzE6rh+yu0+WQfH7faDzVk1KQyeAnEywlZNuq830jW5pHDSZibwUtEdatz8o2Z9w
         jHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753483150; x=1754087950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iv5k4xFCPNa2vVbv5IcTsLR5XM99RD3akb1r63WqZv8=;
        b=eKcI8xGX5HT3G4jrztR38P9J/2ebErQh9xYtzrUOTG30OIqRnbfSe4ajH2YzCRfk5I
         dX4WaJJVZlJc54Nm807KBrclf/iZt0R0vpOpe6qrT7qicziLZN623Vs7/UPu/lItky9U
         v+RPJINT4bBYF8dI0J0HwT93Tq+WkwReh8/4RKmsFf8cHItFF91YzApvXQK79iivicUV
         21FLTmuqDt6YjWUMV021NeVtcKNSwYuob0KD8A/RdCou4m9v6I8/D7jIr0Pe7Z58bQds
         S1GfZPv/pr9HSvnVeREISTdCnjjxc2IiU2eV5Qy+WODeFtWO3umg88Z3N85OMwOkc6cI
         X/GA==
X-Gm-Message-State: AOJu0YzZKq2mx+JPVLJ5vwRSjuxG4kRE2NQoUPiU5vwxMYkCHH7XQYnl
	nMwu1tf52niqqFBz0WTZ1O51mGneV7YB2IwFQkizHgtKlYm8X3WkP5T5Uy3xb1U7ZvB/ubDAClF
	A85a+DfEpZKYwGLWUSsS2oGM9nfoOUWvzM5kBN/LS
X-Gm-Gg: ASbGnct2ftmp66M+V5T4WmyDGy4Rdv+UQL/MrDMLpFGFPTABBHX/0It6PJQrLY6Yzhr
	EpgOjCrbPR7CuMh4rlw1Tv/dOnELp0DCoad90i5d8oaej28FDWoDVeve/u7HK+L/1ZO6IJPgQgG
	d5ksyD9sVoVNLf4L/Idpc0bnAzjhk/U5uMAnsjH0s3trlsIp2uFjfyqtXX+ek3V8CzoU6GYXrAH
	9114zCccMthBijfPiDTogfxxYrTj5s1X5CVP5XqopUUNt5ElWCFPBepwZY=
X-Google-Smtp-Source: AGHT+IFMklkHFcOXioyAx2d0bqd4nB4JNFNX2aKfodywqbYpQlwqoLGHp/pEpvS+ZJk2Fn4BDruQbU0An+mgiPGHPA0=
X-Received: by 2002:a05:600c:820b:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-4587c9912dcmr147085e9.3.1753483149860; Fri, 25 Jul 2025
 15:39:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
In-Reply-To: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 25 Jul 2025 15:38:58 -0700
X-Gm-Features: Ac12FXwS4Wnk13CURRl5JaHGtZNdLdb3q8MbCL8zJr-EvUjIvukDMA9G0Jg_u2g
Message-ID: <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com>
Subject: Re: [Bug Report] external_aborts failure related to efa1368ba9f4
 ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 7:00=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> Hi Oliver,
>
> I was doing some SEA injection dev work and found
> tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
> head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
> branch 'kvm-arm64/config-masks' into kvmarm/next"):
>
> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> Random seed: 0x6b8b4567
> test_mmio_abort <=3D fail
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
>   pid=3D25675 tid=3D25675 errno=3D4 - Interrupted system call
>   (stack trace empty)
>   0x0 !=3D 0x21ed20 (regs->pc !=3D expected_abort_pc)
> vobeb33:/export/hda3/tmp/yjq#
> vobeb33:/export/hda3/tmp/yjq#
> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> Random seed: 0x6b8b4567
> test_mmio_nisv       <=3D pass
> test_mmio_nisv_abort <=3Dfail
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
>   pid=3D26153 tid=3D26153 errno=3D4 - Interrupted system call
>   (stack trace empty)
>   0x0 !=3D 0x21eb18 (regs->pc !=3D expected_abort_pc)
>
> It looks like the PC in the guest register is lost / polluted. I only
> tested test_mmio_abort (fail), test_mmio_nisv (pass), and
> test_mmio_nisv_abort (fail), but from reading the code of
> test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
> probably due to some bug in the code kvm injects SEA into guest.
>
> If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
> exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
> tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
> yet figured out the bug tho. Want to report since you are the author
> maybe you can (or already) spot something.

Friendly ping ;)

>
> Thanks,
>
> Jiaqi
