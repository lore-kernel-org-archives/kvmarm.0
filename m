Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C58244684
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776994065; cv=pass; b=W35v4O90lcT0Hkvjvay0AXx70ASpXaMoOrMvIlfqmxSERPsUw7tWb21TrpEWkn6qzVWQSFoJeFF/13j+9lwL+vX7sdwXlLlWuKPwdjP979tP1DIRJNIqD1BgRxvHNG0KWLWLUnPHytioNrFpGwqBAc0CBfXNRYrXcW0VaG68bEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776994065; c=relaxed/simple;
	bh=omKa/2WdgusmHEfGk+KJhSzPUsH5UhfYeEoCCOvHE4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VV8cCTTFc9/qyjv5FzSq/sWKuXqpht3V2FIbJ2vcpgTMbm15r7ta4XN5SlyI8NzdXHxFNwUTWGpZqtJAAPLn/AKgxI031FAx0+SdHl5FcHzKlzc4CRqKdIKX76HDwEoev6g7MXZgvAWBbLVX/LP9BLuYeY9LVVmTiBc/Vi/wqZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=e9DxCmrB; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="e9DxCmrB"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-671ae79e617so9423608a12.3
        for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 18:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776994062; cv=none;
        d=google.com; s=arc-20240605;
        b=ceXd2OH1KjkETjWZfgZVuvxE3frAvXRagpPHdz6iFzwj0qrbjYYd6gKOLZ0Bu74OeY
         8zx97c+TTkFSbXBk8qkMoZs7zwe8Y4ViZedfaO/BkyrgoxhH6XiDMeF64TwcXWo3/avi
         uBJSB3WbpY/0Wl29riYclD4jG5OejTR5VHE/giajNsvVLcVWX4MEZHaOSnxmkdftYQNa
         BY2g7PckHQgPV+QLvGVqBgEW24j8UMKZWO7cdlFsHlVP5TTmHEp+L5vgVRDKtX71fFOJ
         sMd0p0bLdn4OuMneX7U70o3i3ceJ9c0/d9L4/llvqSooflvxOqIcLoJKlhi/JNHcwsHa
         PrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RYR42p7JO/QHsKTGPNBeEQu2D0vGgM3DHEt/tjHMAQQ=;
        fh=E1m5tXLHqNYAzgvxA5HE8cpR7DwRgnvAWE5wS0yeIrg=;
        b=EUSUC78saAOfB3Bk/i1YZD0JUdZfY34d/hora+WdhQaCLiVmpqA0GMeMNb4HtXSdVP
         64WB5iUwFL1npJeNvolAxecanloY4EbWIqPAxHp1TKtUkUIASAdh1wvuZhOBpY5u/siH
         IbIfYJGP1K+LD9MfO3nQvtPwj2CLEPLBILrup2ekgsj9FVaXHI0mQaVRUsKPLMBwH3f5
         Cvic8Y+bA1V+q6WgdmLriJFeFyXHia0HTfzd1gDANJ7bHT/qCsMrcdcDCihGkgH/qwbP
         rLwrsky+WDomFbXwN5yoFwxfgnpN3AaCnUCqZ+yYDqR3CVjfagLDQA8txpg0fC/UBVui
         PB0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1776994062; x=1777598862; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYR42p7JO/QHsKTGPNBeEQu2D0vGgM3DHEt/tjHMAQQ=;
        b=e9DxCmrBBGP1zZGcr2q0nyYdDtErZy1kw+lZZl3DvVz9QX4CQJhpL03B8y361obcxy
         pMhGHDyyFK3FgRitOvssrMWjAItbfyVfdUp8OkhDvJdUqHttYiQgDYaKUSSLp5yoj2C3
         oLARd7M31R0e4e3J2j1APe9114p4RnxfJXwIHzmJdeL3BN2zVZgOsI6lYIqHPHKKcDfb
         4chY7q3zWxSsYyxBzl3pScGpGDP/6U3602B/HsPUA3CiYsUL2uEibN4ZYkA/9xIRgW4t
         0ZhuhS6n2T2v8oV2RrvLNki/t0QfMI3GYUHObr4RZSmFLebd1AfhI/ouX1ReOCuXOkfB
         XN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776994062; x=1777598862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RYR42p7JO/QHsKTGPNBeEQu2D0vGgM3DHEt/tjHMAQQ=;
        b=bB8bVq6rtZBR5iBRaArQnf2hW2aL/4FE6oDp9ltOEWt0xKeIi4HFxxtHA9l5bT4gtF
         zdyp8L3mtcPCVw+OCKOhw8SVD8fhZScksg9ovxCcYPf/z9A4aAto+jVjTniLy0J4UTO7
         PABxfxGPKlTJX7V4YjYV86JqXjIwzqg9afjZ/eMiku2CbWnSjfrJ8chniigb9DzMMryD
         Sa3LCBkKNhsGhpFvQks15KawDvlv/300uneE/K6NW3xNS5JTk18g8oFM+cHXdUBqb6g3
         aRMkLFdVsnqVJHuV4mHAM+8yoTMo1Ymc/1MDNlvY5vayBFiLXhnaV3rnBvidsuxlWL13
         T4GQ==
X-Forwarded-Encrypted: i=1; AFNElJ+k/LsjlsMq0whO9wgYe6KxJm1x9ByonMfoLYkrgbY8/AztN1psQvjLUmmW0VLhbXtYGa74gKE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFLYEGKieD9NzpCeVuRvAy1w/HeuP6BTEFsUM4JcQMt1Xnk976
	BiSOxEsGlUojGgX9jFc8lRyi0bTYWWrqpwscbx8qU/YQn+cZM+OumM4n8K8P8b313d6hdNaYrkT
	EQhCtkpp3GztHnbaVrspVECHyQjiTO1GcCRMed5mh
X-Gm-Gg: AeBDieuVl0tSIppI1hNFxd1BBmjOBZv67/CVOvzj4KyqGY+E2hTw9GbCzq2ktanYtzP
	y3QhFAuIr+yntxkR74qo7fFQZIlz4NztmZmfT6JRdMAepdddCLVVd+seh2zJ6hiXxj9WVYgG/7v
	rnRmvt4Y0ZYNWp5QTVHrnJbMO7L77+Hsq3TbfeCzY1pVsB6+y5H+mjWTcsR5LkQ4IjnyADEc7AH
	0r52xWYYedHmUv70zs/OPl8Af1dCSOr3rLPjk/6BHQygQzcIvPXi4j4dBbuLq34sirqMAy8EQUk
	ynD6l/rft/mLqWY/lv/d2eZ9lLY4
X-Received: by 2002:a05:6402:28c5:b0:678:7da5:2346 with SMTP id
 4fb4d7f45d1cf-6787da52508mr2108038a12.25.1776994062317; Thu, 23 Apr 2026
 18:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aem0SSQuE1e3pGOS@e129823.arm.com> <56a8aab50a3b5ce0a345fc2079fb2abc7d0f1b23.camel@linux.ibm.com>
 <aeoAlVEwzRUPrlVe@e129823.arm.com> <aeoRxWPyOHGJd+Jh@e129823.arm.com>
 <aeoWO2Cwo04YYu2l@earth.li> <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com>
In-Reply-To: <aephL3MzYoqFGaT5@e129823.arm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 23 Apr 2026 21:27:27 -0400
X-Gm-Features: AQROBzCKchqlqq4fwimM8FvKvU-_em0HAaY4O5iQxKuvqQBuL1WqJdLvyk10CT8
Message-ID: <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Mimi Zohar <zohar@linux.ibm.com>, roberto.sassu@huawei.com
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell <noodles@earth.li>, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, jmorris@namei.org, serge@hallyn.com, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, jarkko@kernel.org, 
	jgg@ziepe.ca, sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 2:13=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Sounds good. Once the patch is posted, I=E2=80=99ll review it as well.
> Sorry again for the noise, and thanks for your patience ;)

My apologies for not getting a chance to look at this patchset sooner.

This seems like an obvious, perhaps even stupid, question, but I have
to ask: if IMA can be properly initialized via late_initcall_sync(),
why not simply do the initialization in late_initcall_sync() and drop
the late_initcall() initialization?

Does any IMA functionality suffer if initialization waits until
late_initcall_sync()?  If so, it seems non-critical if waiting until
_sync() is acceptable, as it appears in these patches/comments.

--
paul-moore.com
