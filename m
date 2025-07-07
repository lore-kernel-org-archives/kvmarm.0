Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333FEEDE
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751901053; cv=none; b=ZN047/bDq4wcDRBhWVxc3VKz+Y/D4Vvzel314+e185sDaKwkJbgvgw/kbC0ucCMiw+OJFwiGUREavCy5moBO5M1ybsNiDYvuEWO80XeonQ5Jo6Peu7MY7XQPHzhhK6LU6hvFp1Tp6wV3fdSGRBE52vRWU4+8jSkbSwX2Jk5B7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751901053; c=relaxed/simple;
	bh=NzO+0IozOEcDQn3l700QnEk39i5XxNG9MwjqeGJpu78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mjjXADRl1RXkyzDbkG6OfEECOfPY/Yqfk/wVroUtikIYb08bmmjOScCEDcSNnxYC+4ar1QqJnnWdrJ911tNSKJdwKRKQVEJZ08B2WYnlEvRijhsTeAwuwh12XZoEXVbxKKddPsD0A5FOiGp8WFcfFAf+AonMTjm+Bsbp22GCVjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=erm8+P3T; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="erm8+P3T"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4079f80ff0fso3051731b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Jul 2025 08:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751901050; x=1752505850; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnKl3T+2/Gli3SYuDP6kSnPnrKRp+JeV5lf6ObCVcU4=;
        b=erm8+P3TwqFn2tfGnXyOtCA116pkL6TNrfnbIk1/i1EAZpC01LLYoNFlN+SXbYOFqj
         hVLW2EH+4QAeQWPcrET0r4dBiO3YDcwiQ989ZI08ru7Fp3DN8FvVzaZmP2EilV1Ri3wP
         ZKIXuE3NsMlvDlEMzu4++SWotdwLwppvpNBdR6N89XIZXpb5QqHQ0DnklmPsN/Vsw3OA
         EgoxMtNlEWmtaMkZosyFdb+fFdKigDOAhk1MyLAt0eKDNNxyv0JRa5I99+KD1WVbfC/k
         A/QjyHQs0lcYhJFzd8ryV4Jv3BEMPgcehE4riT6eCLlbRMEjvTPRW6fc7JmDZ9HKL+qS
         DoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751901050; x=1752505850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnKl3T+2/Gli3SYuDP6kSnPnrKRp+JeV5lf6ObCVcU4=;
        b=uRbCNlxI1ph60ENYBwTzUQaNpmRE4wpt1p5Pe70arc5wTW6cxdlXqZCTJ1RoySTA8m
         PKuYrbZRAMk/ZTwiAJeUk89tfFoLWHdnLulP/IiCebarwy7AvK+DvK/jX6AUmLx5utRz
         9xU/XcYL8r9GjPybmPiHRg7D3O82VHOMynWZUngi99+RXfi4EM/rMF5Aa1eldd9jvvkv
         PYshI09VCaZFgqu2V12Rg0zj69Anc2UWb/S89CvARhXr4w0pqEVENddviywTI5oN1s9E
         yvIh/CrMTuhVMSakPM4p92S4zjCOpPt7U7vEhvmKQoXhDGz4GZV+mjfCebTq4QaBKQ0P
         8euw==
X-Forwarded-Encrypted: i=1; AJvYcCWYk/VyK5O360hEbj4IJfco/UbvXquLBvdRgFOHxmCudqc5hQ+4ih6k3eCOnifk+UCw5VMvyLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHtjaR73icpLD2iP/0dVmPRJiUq+JK8EPzi74MuOJwUTNAZ3c5
	aHoYI2lZiPruJEsUSg6vjIHhR4dhRXXazvSGqxraClqpFBAO6yQTUhbyLc/YLVjE2JMbLUmiXKc
	SWWNOzfWxapuDvY7EFk8JOllHKfjpX8sQ8baG+4JQ6w==
X-Gm-Gg: ASbGnctb9PY6nVtAt3FHoQTZB3rHK/7xFgGgRpRUtEVEcDPPpflFIm6oG9BpAdyQ8MV
	HV2c94buaohHBdEZzK6OnXH+6QrrtgbvZkE9lt1+MkMknOuCTfOKfQTQm9bPYThiy1No/LNb4HS
	/kl7lP3u+pcWVMLhffmyzB4BPAfid51f2eomuIQqEgu8T0
X-Google-Smtp-Source: AGHT+IG+z1QRmX52XgvUvuibShCH4JxPGne+61lfX2+6MXnE61ffxBITvW1KTHFtHy3R5JyQX8kD9a85pxlYxun9pQI=
X-Received: by 2002:a05:6808:4fc7:b0:407:9a0a:3f54 with SMTP id
 5614622812f47-40d02a5655cmr8571934b6e.14.1751901049892; Mon, 07 Jul 2025
 08:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-5-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-5-andrew.jones@linux.dev>
From: Jesse Taube <jesse@rivosinc.com>
Date: Mon, 7 Jul 2025 08:10:39 -0700
X-Gm-Features: Ac12FXxjT-qZ8EUAqkDvvy6G3RYe4XxmKy5JhKeSLnukbAx50LvwhUxZI1axAGE
Message-ID: <CALSpo=ZU9Eb0E0cq1Um1t3bmbAt05K0q6e_PLpWAn0Oibd6hLQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch
 with kvmtool
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	alexandru.elisei@arm.com, cleger@rivosinc.com, jamestiotio@gmail.com, 
	Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 8:13=E2=80=AFAM Andrew Jones <andrew.jones@linux.dev=
> wrote:
>
> When running on non-arm (e.g. an x86 machine) if the framework is
> configured to use kvmtool then, unlike with QEMU, it can't work.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Jesse Taube <jesse@rivosinc.com>

> ---
>  arm/run | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 9ee795ae424c..858333fce465 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -97,6 +97,11 @@ function arch_run_kvmtool()
>  {
>         local command
>
> +       if [ "$HOST" !=3D "arm" ] && [ "$HOST" !=3D "aarch64" ]; then
> +               echo "kvmtool requires KVM but the host ('$HOST') is not =
arm" >&2
> +               exit 2
> +       fi
> +
>         kvmtool=3D$(search_kvmtool_binary) ||
>                 exit $?
>
> --
> 2.49.0
>
