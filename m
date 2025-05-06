Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0D15C158
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567056; cv=none; b=dis/ycIM+HxMLgCryWreCOSd85PEcF9LhDFeHcwaxBzVDZMokuf1VfDPfXvlCY0/HnzcHdWVRFOwMpmUEaj1DHn4i1KssuLnO8UVkoImFS9CO6Ex7C+umbRTcHIlMNjz76gli5yI2mXpeQqxG7oeXl8XZNLkHpPCnILcGrvpO1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567056; c=relaxed/simple;
	bh=LF4XyTkcgWoicn7uCeNsDcChHQo5BLnimhFxKCYZDII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YE6c4IJYEZ/pTYfJmtlFTFj0Cc+GIOEWrB9ENStHbVANy5skPnj3uV5BIGEnCAu60q3mSDSGsUJ8Rqg8V59AT79aJ3bMWUkUC5l7GXsOs81OfuP1vl9BIp2qaRWdKHVVYMLE65Cp3d+lIUi03oW53JxX2XLXiPBSOla9CAwTukM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNluEQFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNluEQFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC15C4CEF2
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 21:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567055;
	bh=LF4XyTkcgWoicn7uCeNsDcChHQo5BLnimhFxKCYZDII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fNluEQFkkeCwvPrfzIVWjNz/fxO7XClp4/+43s1LbqX5aWnCweVwRbbM2lIYlPpCz
	 pE4shwMICs31y+e3dEBL0qFiTMcHcQa6DaDtdijSyzGWXbbjB0hMmZioDeseLr5LdV
	 Bqm8W7lsCe7nxWxPzYGpJS2OEXeEOpbTANCxdQrXEirS3KWCwLf6Sh79/T5nqBXM+D
	 A38Hy9YlwRtnXh9GEgv+xaYXKVMviIpE+Tr/vWwHMxGfW3rwbvDmRokxWBFQRkA1OV
	 PY8L5UOfl7dsosAq05DeIbgW+tayqRx9TUDyQcdHmAp1X11LklEHfM946KdUBE/zBm
	 8dwZM/sqTM0KQ==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e5e63162a0so9420900a12.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 14:30:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVFQ97JisHvcXqnEhx2mcboQDNI65ed4euFn32ZUz7OF1lSc7oTm/uDUYhWBEHOEX8cnT4k6YY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRX2L0PT7U1g5xfB9/Zvvid/vEhMYNTi16NiXMVC0QbAkLd6ER
	PAJhegIgIkyRcg6nOjSpq78FILhT3WtNq/9JV7P02mYOLioqVCoU9hQKE7qzltWpOevgoxVIafQ
	AKmjuL9PP/ZsS/Ou96tpcVP7Mfg==
X-Google-Smtp-Source: AGHT+IEnd5G8SKlNRW5w4iFO/mLcDtaGwA9ndk5+resb4iEheEVI1rHK1zs74rWur7nF5rXXl5sEz573M/0kmSBOH+I=
X-Received: by 2002:a05:6402:1941:b0:5fb:9f73:d0e3 with SMTP id
 4fb4d7f45d1cf-5fbe9e29f20mr703063a12.18.1746567054358; Tue, 06 May 2025
 14:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org> <20250506154702.00002b57@huawei.com>
In-Reply-To: <20250506154702.00002b57@huawei.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 6 May 2025 16:30:43 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL2ZeNhpm3E=xVEtdiwGXV7Ni4YpdYn7thvbgt7Gn-QUA@mail.gmail.com>
X-Gm-Features: ATxdqUHdtGklHSUrSP-OlxuranOH14q1bQqj56TmZsXDcW7Zo0EE4YurWkIdGsA
Message-ID: <CAL_JsqL2ZeNhpm3E=xVEtdiwGXV7Ni4YpdYn7thvbgt7Gn-QUA@mail.gmail.com>
Subject: Re: [PATCH v21 0/4] arm64/perf: Enable branch stack sampling
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 9:47=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 07 Apr 2025 12:41:29 -0500
> "Rob Herring (Arm)" <robh@kernel.org> wrote:
>
> > This series enables perf branch stack sampling support on arm64 via a
> > v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> > on BRBE can be found in the Arm ARM[1] chapter D18.
> >
> > I've picked up this series from Anshuman. v19 and v20 versions have bee=
n
> > reworked quite a bit by Mark and myself. The bulk of those changes are
> > in patch 4.
> >
> > A git branch is here[2].
> >
> > [1] https://developer.arm.com/documentation/ddi0487/latest/
> > [2] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/br=
be-v21
>
> Hi Rob,
>
> Expecting any changes on this?  Anything specific we can do to help then =
shout.

I hope not. Still waiting on Mark R's review though... I'm sure there
will be something and since perf drivers seemingly only get reviewed
once a cycle, I guess it will be another cycle... Sigh.

Rob
