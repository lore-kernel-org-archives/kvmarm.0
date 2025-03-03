Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2221B9F4
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741020275; cv=none; b=sqVzxUk2pZ4uYAjnt9tOUz7iJTbz4oaOtsIj3iLQeUzIqucQcBSx5Ezmdicfu+ECQfoDppSEUWLjOP0ICB6CFrXga03HKL4q007Rx9eIpmau+7n3/0/EcfNTBgzoifNuXYd/ys9MwWXOSn9uPhFqViqNrgVfitu+epU51URVNe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741020275; c=relaxed/simple;
	bh=xihpcD+p6hJonkzJT3Ob5VMeFACGeyJ+HMFQWEbE3co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Svg/FGpHBDNF87xqFprlozNJvRo0r64jDHHMg1U9AK+QaNuT/tasbFxduBnN8mo5rj/lynYAwL7zM2njQElP8jvsuVNtxynUkEiSIDg0AyE8R+9evar0TQimwZtsp/I1agy/lbOQPPT44cleHkXgVrONF87xUqP5qDK0C9rbKpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqGlCvl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqGlCvl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF6DC4CEEC
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741020274;
	bh=xihpcD+p6hJonkzJT3Ob5VMeFACGeyJ+HMFQWEbE3co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LqGlCvl9p9p8PhByHtBGN13f43XGlifacot+vZvS3pHIT046+NGn6uP4qMc5VhxYW
	 FdDLx312La6TUDQogZoHr1zYrG9yeg8bbI4jBo0EJIO/zjFHmEMFshF4XCdbaW89QU
	 hBfhXKkuQ1OpoUWXsrNeZ55/WyijVzOT1lvWDzybN7DJIkAf+DvQbmVHhYLcWNNhOr
	 YA2q3BrMSYKWqZJM7P0pBaeYRLw5fKUOS3ZjKrZQHc6zOkuYEIIQogk2OetMH0RVDZ
	 dIdvy2Xazn2X2YddXWXl9rWCACiHN5fTIzHWQj0qcVCZbuqDhns7jUjmWwkkJd99yq
	 XrB7Qn1ZwDTvg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abf615d5f31so341212466b.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 08:44:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVreflnuP024d7Db/PjTPsm5/D1BGQ7lgaHEmkKsy4abAkBerhbEZDs7CIjpieLLtIFuseUVTE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze2Qpg8UTZuz+OadsO90k2oYby/ADRxyQ/krJvf5VS6xzg76EE
	fHNXRR7hf3I2Mtro71qQV+wC39M7cBqssErmuJkdsE9eQe45D0zoS7cnC82odjUc2g4jlbRA+sP
	UDxEEUoY1Qzwy7YjBDbfzRh5Hrw==
X-Google-Smtp-Source: AGHT+IFs3AxR8k5eF3cLqq0Jy6YcBJKsznbiFF0lDq6kRV8nU05db493Qg3NVLNrVPLfT0m9I9tnp+vPUCeMeelwMrk=
X-Received: by 2002:a17:907:da5:b0:abf:7a26:c46a with SMTP id
 a640c23a62f3a-abf7a26c5d8mr394234266b.50.1741020272581; Mon, 03 Mar 2025
 08:44:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org> <174080569248.3208873.17639032755999041028.b4-ty@kernel.org>
In-Reply-To: <174080569248.3208873.17639032755999041028.b4-ty@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Mon, 3 Mar 2025 10:44:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLijFG1PFkqKk7hXzC=aj70OLQsXwC280QsCO=PnCVZYg@mail.gmail.com>
X-Gm-Features: AQ5f1JqS2WChjdYpf1hur2V7GzhdVdMY_80V1LgU_ZsJaDcMPJ5xdVGvREIXSNM
Message-ID: <CAL_JsqLijFG1PFkqKk7hXzC=aj70OLQsXwC280QsCO=PnCVZYg@mail.gmail.com>
Subject: Re: [PATCH v20 00/11] arm64/perf: Enable branch stack sampling
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>, kernel-team@android.com, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 1, 2025 at 1:05=E2=80=AFAM Will Deacon <will@kernel.org> wrote:
>
> On Tue, 18 Feb 2025 14:39:55 -0600, Rob Herring (Arm) wrote:
> > This series enables perf branch stack sampling support on arm64 via a
> > v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> > on BRBE can be found in the Arm ARM[1] chapter D18.
> >
> > I've picked up this series from Anshuman. v19 and v20 versions have bee=
n
> > reworked quite a bit by Mark and myself. The bulk of those changes are
> > in patch 11.
> >
> > [...]
>
> Applied cleanups to will (for-next/perf), thanks!
>
> [01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling c=
ounters
>         https://git.kernel.org/will/c/04bd15c4cbc3
> [02/11] perf: arm_pmu: Don't disable counter in armpmu_add()
>         https://git.kernel.org/will/c/dcca27bc1ecc
> [03/11] perf: arm_pmuv3: Don't disable counter in armv8pmu_enable_event()
>         https://git.kernel.org/will/c/4b0567ad0be5
> [04/11] perf: arm_v7_pmu: Drop obvious comments for enabling/disabling co=
unters and interrupts
>         https://git.kernel.org/will/c/7a5387748215
> [05/11] perf: arm_v7_pmu: Don't disable counter in (armv7|krait_|scorpion=
_)pmu_enable_event()
>         https://git.kernel.org/will/c/7bf1001e0d91
> [06/11] perf: apple_m1: Don't disable counter in m1_pmu_enable_event()
>         https://git.kernel.org/will/c/c2e793da59fc
> [07/11] perf: arm_pmu: Move PMUv3-specific data
>         https://git.kernel.org/will/c/dc4d58a752ea

I don't know if you looked at the thread on patch 11 and said "long
discussion, I'll assume a new version is coming. Next!" because that's
what I would do. In this case though, there's not any changes.

Rob
