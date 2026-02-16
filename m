Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161F276050
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 11:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771239668; cv=pass; b=Lz8GiVPAFx0qbV78ABKrBOZFxzdfdS6WPu8SH80cdT8d/rW4Ylh79RWliDnSmcvw0E7hXPbVIFdBI6+N+oNzIuAq+fCbEOEkyIR1Rdgtb26Q4VvJdROdQgtAhBAPXcf3M3qrV4flTIwb4ZfXI5nqHuTUDhXPnVZuEMNN6qbByPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771239668; c=relaxed/simple;
	bh=jo24C4u2uAH7Ef+Q7XrQqIIp9bhYKhWRqVkS3RBEzlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nfbqt+57pQrEb+7cbMKiteWCxq3NDPZPsacmh108qiVR6p0+gj/xondScqiC059Sxcf7ltuHYMa4JMAXBBpYQNiIMbBmKnwI8beC3QOM9i5N/PbdpLY0HwxkTPQJpni5TQ0YM+xhrYDcJY57CEY1vSqu0y6qwQRFNaA2wW+78SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NguM4l/6; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NguM4l/6"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a355aedfso709061cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 03:01:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771239665; cv=none;
        d=google.com; s=arc-20240605;
        b=cBGDymzAi8b/gT90Dw+CjiE1KvJwWl1qzzm821RBIrbXLKgHwF1K016UltcpnvgkVy
         8nneYWByXmkr98cwzfAbVM7EHwS7oKcOzbXnCuF4xPiKNRGUijkL8cLaXKtU0Pmuumvi
         EnVYwTbfkni/t5OKorl9j2aoUY8B5LczTKunLrP9aspBXAQJDK58SJ/uclboljQYyqJx
         S4dW8lNy/eWG3mbfInmZEsvs2mUrz6l9EDVbkodqbR5E2k0oQpYVX0ZnHKIDdprttPlF
         NyXbrdtpFjfqBT+UCzZNJFvMlxNF7xf74Dah685GF427DnpE4cQ9+Kdi3nCjWHNaS8D/
         Pm4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=j6N2P1woktSvq/O/OPh9bNbC2hnbgvc/YM2AU2z6w8E=;
        fh=EBcsio/tplilN4Ft4tCpz3aUaY2z9aH1gBmcf5hBhfM=;
        b=ivQ+ccDIuMhUdMd6TMm9+9odkOqX8nAcDOWJ3r+sX4ja44SFKNNpaq+n5m8o61n1sE
         ClqHDCXvKfV5YTwNy2w6y00b+9Smvaq1tf9IVtuA8tqDsWdURdJqkDo6fDlQQ4x1P5jF
         IOjiAHrlUgPV7+aG9kqGHQ/qrpk5Vr7T7VdVBdHw3HHI6pSulEoCuNBovLcu6/ySzzn2
         rT9F7XnFlhkM7BhZ6+miBgHdn2NfKbiSXC9qXWdSZ9uFLZEiPgX7gqf5TTY1ulZzzCCL
         skE7y8F/d4WZ7pTw9/o/mdFODrc5lUzyk4bjXbXEPYVLUHQFPLAwzv6sm7Vzp2ZjfGdF
         QVNg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771239665; x=1771844465; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j6N2P1woktSvq/O/OPh9bNbC2hnbgvc/YM2AU2z6w8E=;
        b=NguM4l/6hksvQCRg19pekkJ2056nKtVYJsdouGskq6cIqvgeMXdJI3Fy5fkN3WdqqA
         5qt7vuXVPT7fZAEO4TrEtRxp1JhXbugxqtrJO8V90M7S0FeS0vuH3/lpkbd+IebFksc4
         JOXzH/wVzF3n5rWvgfz5J8MNZvajFB5JoFvAzIKZxkc3TTt3byBF+6YcyaGXKqUIbFAl
         f2jVa9XpUqG9UAo/wOApECen5k5BRGC4iB6XKtKyvadvPRpQuE8ReDkKO2wtPaQbteqe
         C+INfyuMHc8Pd7SLVevoD25IXyH/KhdcYrUBc65XucdvaY9BcghJyVji9pCqHp6OtJRE
         2sog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771239665; x=1771844465;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6N2P1woktSvq/O/OPh9bNbC2hnbgvc/YM2AU2z6w8E=;
        b=ksG/urbaEr6FpNHyj5Pre58Me1D59i8E9TGgx8y5294LV11kNcPrmDNIjo2MTy7cet
         hfdfmZ+Yan8/mA6ESIYcIcWqk89RIvYcLdkdAGZN327rTJGXut5ITvW5LGASWIHPrEwq
         u2ebJhLNJcrHIA5OnuRZqkbjBs6/1nf09TreF88tFT/yB63//UJc34J7IfvZHdvEUuoG
         zh57dEX/HzaVw1o8i7rvw9WrhboTycOGcZ/Ahoij3Dm/BbgGIpXFNHMo1OcVRevhuDIb
         6uiIvQf/gtVdwCU6i0gowJdB1+CpJhx8zZsKQ18/u4zH3fHeJlOkCQR0f8S6tTGjmAgs
         DGSA==
X-Forwarded-Encrypted: i=1; AJvYcCVyKJJfiVc/aEbpYzfZPlgIdNidN1q9fZpB4AeKxyymUF8EuCIh82Trp/8etgelm6lXI0cN284=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDxBd1VpeNRpSTXkEoTsLrlXS9NlaxuuCUCihT7HCXEx1x6Ppl
	XQPS4P/+Jr7NCC0Hlkn1qvfqwpagockkJPeuMHUuhWsB6KZzVArQMKRCma3t2xQarXZfr2HaTsO
	9leEFnfROHvWRHPHRlSReMQxsnC0IBngkotk7beu0
X-Gm-Gg: AZuq6aJyolqB+fNIRu7qXYxegrpNp8baaIt3tUHwxqshbhPrH0cuXkC4b7+xOY/l76h
	OmOAJj+2QRLKv/Gbm38i4EWRQ9qExsqGXNMmZJ8Ew0tsO4+73fu+uPp8bBBDy5Hdd+ly7tiPKzh
	lYrXnwyaYti35KYp9nsYem12ej8pcKPhuRXBM+Srtot/vi+VElqA04GgA+hkZc2bdcUcuKY9l5O
	JLesvCBaCm8z/udEypS9jahjbB66sNCcWoZc4oy2QtX0RCFhnbZs6XiZkn9AYgX4rWYU8kKTgfN
	pdxVviBV
X-Received: by 2002:ac8:5985:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-506cdab08e4mr6258721cf.7.1771239664283; Mon, 16 Feb 2026
 03:01:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119124629.2563-1-will@kernel.org> <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
 <d2303150-5692-479e-9a56-11a52ba58c2b@oss.qualcomm.com>
In-Reply-To: <d2303150-5692-479e-9a56-11a52ba58c2b@oss.qualcomm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Feb 2026 11:00:27 +0000
X-Gm-Features: AaiRm52UGHbce0UNCUNYSqfkL14zPT3LmCyCoSrVykbFhQDeWXdeg2c2n9iGses
Message-ID: <CA+EHjTycHq7WkOfD7d+1-9A7HOAkGzBTmEm-6DB8Y0TNq-Aftg@mail.gmail.com>
Subject: Re: [PATCH v2 00/35] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>
Cc: Trilok Soni <trilokkumar.soni@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Venkata,

On Mon, 16 Feb 2026 at 10:58, Venkata Rao Kakani
<venkata.kakani@oss.qualcomm.com> wrote:
>
> HI Faud/will,
>
> Can you please share tip of your commits to apply the patch series cleanly?
>
> I could not apply on tip of master branch.

The link Will provided in the cover letter above didn't work for you?

>As before, patches are based on v6.19-rc4 and are also available at:

>  https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory

I just tested it, and it seems to be fine, based on Linux 6.19-rc4.

Cheers,
/fuad

> Thanks - Venkat
>
>
>
> On 2/11/2026 12:28 AM, Trilok Soni wrote:
> > On 1/19/2026 4:45 AM, Will Deacon wrote:
> >> Hi folks,
> >>
> >> It's back and it's even bigger than before!
> >>
> >> Although the first patch has been picked up as a fix (thanks, Oliver),
> >> review feedback has resulted in some additional patches being included
> >> in the series. If you'd like to see the first version, it's available
> >> here:
> >
> > Is it possible to test this patch series w/ the QEMU or it will require
> > real SOC platform?
> >
> > ---Trilok Soni
> >
>
