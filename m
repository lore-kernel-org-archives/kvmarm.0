Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4212022D5
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 00:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731372753; cv=none; b=uMQLUHvncF5x1ZABpsDNwYS+0Y1FgTUjrstiZ2ML2B/cdRKqyGHNZc0Sjw04fpaeAgbUbPJMxyNKf4bDoBqpfdRjI6DixhWG9g80TVjhfxK3vuG2x9h0wpVaa1VRJOZJmD/kOK4/6UcGMhRGdKSi3kdNozL1L34+WKO22GIzt50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731372753; c=relaxed/simple;
	bh=Wph0OYiV3ntON+fu+PtnMe16jvUo7k3ccZUDgNqiupQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zsb3OU/3hA3ZE4NxicxNcBWbz+dczEgEL1nkeY/008sSmyiJBMJfB87V4UVYRzJFIZni72ThYgT/OyUGdZExmm5wS+RvUxSrbZ1cUrqy/Q+92De2vrnaUNQ2l2bAOBP/e7VXPI1KeSfmlqe6pWgx/z/yPU0tAxTLUBQaz5syV24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oeM20//c; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oeM20//c"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539e19d8c41so7772e87.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 16:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731372749; x=1731977549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/3C5QTs7l3Bpik5RV8yY+zOUnmIc6f4W9i+LJl1HIQ=;
        b=oeM20//cyLpwOZr9cWJyCTiCLmqxAgD9tx37qtZyQqQCmsTumj0PRE5XgLNkXTap8D
         MKmpWWqnxUjqYZHJpAp0E3BI+maJCe1qc3uinPxw41FS9ikbYoPeDiDpieJ6+5SYbFOy
         cS2pAGZIxVEOeDFKSSZgX6YfSAJvxTpMispeNB6/ph8aDXwvIASPHG3XEYFe4URbM702
         BIxK5ZPmDN+jEeAXZoYmM8fGLQ87xRKvZ1bFNZgg2Haul99+MP32wzZSBlCoIQcfPT3W
         8FafmxYm2jdUmO4IYrg22sluuSOJgQFJjpnM6R4nWWD98ZbcgMatzba9oQ8ngmMqKu1Q
         +4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731372749; x=1731977549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/3C5QTs7l3Bpik5RV8yY+zOUnmIc6f4W9i+LJl1HIQ=;
        b=KeuA6NAXY4Jp9rQHgvSdFGwsqrn9zB00BnE53+y8G12lxJDhjKyF/Io1zg3bitHkqU
         0JDI4/moXZs3rNvz45JL2ksP5tvUOJMzYhxIWdTfnIJ85W3tDXkOoliC17LOdcHdic8M
         a7T3bC4vbuxf6IY7ZS3AEpOvHIf2TwjnWGJpyLGIaIApEvgNGRFm/f1Gc3Q0Fs0s6LWl
         ILbO17SXqrKjr4sg5jCm8Z4V5rU5zMP5fx9tlDDNWSN7P39MYqs1Jqq0SqdOg716+lfL
         ZXxtBpZWeth2qBbToN3Pu/lAHC5OHCy1FID2LwszzcXHrAz7n/JCve5vKkdqx47b28ss
         RFbw==
X-Forwarded-Encrypted: i=1; AJvYcCXbnmGF2QwmOfWIpIL8ti2wagl0BSgst24qDJrdnuPvoGwXMtuW8ZOD9mXynpg1xiZ1B+bOngw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHo7Rpuf12GZokYkOrlmUp29brRv3nMLFJ+wsizh43tZQgAaS1
	rbKY4pA8MywL6hDl4QhbWMALv7UC8QoYv0fc2O+DrnKkjkGIp7UlxK2gJdQ85rOfw1Jnkvvf6MN
	kNx5XSrJJ3v/Jdlh7iUgHxY/QN2V7DI5oKQC7
X-Gm-Gg: ASbGnct01KlB3xAgYHCrNqBsKE9cVMH24fsfZJ8MMOXKCtLZnJQkjLt3JT4VXs9IPm6
	mo95/yZPFxZjnCJW2e/NqrUXn+yfQMwPk9Ei3tkiukqzBKeD/LBNgvUPa2Fwq/g==
X-Google-Smtp-Source: AGHT+IHYsqCCOn+C3yPmQ8eRLf6BbWJJRJBSA1CffumGjbn9E9PJBhWGGAwk02oUVBhtLbBpMWoEoOGe5NySvm1wHcw=
X-Received: by 2002:ac2:4c08:0:b0:52e:8a42:f152 with SMTP id
 2adb3069b0e04-53d9b8d6dedmr23863e87.5.1731372749138; Mon, 11 Nov 2024
 16:52:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241108211446.3304809-1-kaleshsingh@google.com>
 <86r07jz6uh.wl-maz@kernel.org> <CAC_TJvd=fNRx2VOcEEgjdkY53MwpR0Xa4dX1KTy=nNew7dg9Mw@mail.gmail.com>
 <86o72lzmi6.wl-maz@kernel.org>
In-Reply-To: <86o72lzmi6.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 11 Nov 2024 16:52:17 -0800
Message-ID: <CAC_TJve8tuBpoeTjwg5=PKFhFaD=M5nwxeJsHeYP1ZezMd_Wug@mail.gmail.com>
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

On Mon, Nov 11, 2024 at 9:52=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hi Kalesh,
>
> On Mon, 11 Nov 2024 17:10:18 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > I tried to be conservative with the configuration only allowing only
> > up to 2 pages. Your points are fair concerns, I can see how this still
> > may not be ideal for upstream. However, I think introducing
> > NVHE_STACK_SIZE as a refactor still has value, similar to how
> > OVERFLOW_STACK_SIZE is handled. If there are no objections, I=E2=80=99l=
l
> > resend a v2 of the patch, dropping the configuration parts and
> > focusing on the refactor to introduce NVHE_STACK_SIZE.
>
> I'd be OK with the refactoring on its own, which is a nice enough
> cleanup.

Posted v2 at: https://lore.kernel.org/r/20241112003336.1375584-1-kaleshsing=
h@google.com/

Thanks,
Kalesh

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
