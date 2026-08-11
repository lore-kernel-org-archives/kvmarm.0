Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD8443AA9
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 12:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786450662; cv=pass; b=oTezh1RfpX2HmO1xd3HB8g/A9Me38BC0BVQwbs66Ilrlnk76sKnCOfegoO4d+Ch3of15tYu6Y1mQtV5fq4iTym0pIjaQtkF6kplcFX4dQOr8nUuhFCP+8+DsS//p5RpiKLuGjIxcGqJOBUdKV6rb95/ks9pFKrclouxCZ6uxANg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786450662; c=relaxed/simple;
	bh=aQxnaVgFyk/TYxcPsgQAcOYDWwxVTsIZQNXoC1wDgK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nwQhzPgPRddd9zpj6J+GdINI3nWZ5FnMNKxF9uaHZGIxod022XkfLyh+nXLYaqQXronxZC8eVM/4MbookAxe8IYKBBkVDnwSuM29oq/4DYZGD6tBD1g6DjO/oZqpySTttsiyRNcbJoOh1wGUHuhEDTUPDuFrserng2LPpRdHwoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tIExOq1t; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tIExOq1t"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69fec8b4638so11481a12.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 05:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786450659; cv=none;
        d=google.com; s=arc-20260327;
        b=rokKoUWhSw83zPSqWkmlWn+IOYhjhAmG6QDYGkYsPXQS7+KsJfkjwvIpVxj1FbjxiB
         7Qadwodr2PUHIOMxeb/xhF3B8TYZkQNiLvasCZL/wXcf5TB3Pm25IJ93cXDASGEdRXPQ
         8fOajpCj6DFgfeVi+CSL2u3+Vo73C0gLx7XDXDRcsVuCtDgt3c1DY2wNOnb91xzNU5Pb
         nUAs4+30oP+y2xP0D3+m5x4lpDSdLR+wYFl8p5rTMvbw4NbMrmju9noXqu2BOE5WYv5U
         bYorGyvvoJKwsE/LLgNPUyfjZo+IwdaIQXmExpUn0m5hTjEmGF9pTI50ZOPejJjdkndv
         njmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+g0yyxU25w21pcLuXRAHww3PrvUBtCpd+aa0SHubV3M=;
        fh=3i6Lp6aAtdIWk5bn8VpHUckueNakMlGxIe0xPq7L4mk=;
        b=ayvYt09BXeRd4ltIlyTa/rHBCTtaSAsFvhTPK/h69oGiO95pNF60xpZFbA21Lh9oKy
         6J1HDeiVGKaE+5DGiphig6VRYYrb9Bd7NQdw2NbUJXssgLySDvGuDRXkIGqfbj7cFC4b
         V441gXJY6UF2HoLI0bBJiR6cvxRLwBLwDhfvyD80oScTCvxacfFsy4659UBJjUTwgDLX
         XYyYT+Xg3v5Wz45P6flejT2d1oUqhI2scf9iXQy9jOQuo09ZGpoR28noX6wsoL/2euOB
         w5JaaYiFfbO7UexUg8VFjTdM9FMDkiOf+kRhCjpyz7pMHKtWFoLNhuhyQqofuSzX6rJL
         4xxg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786450659; x=1787055459; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+g0yyxU25w21pcLuXRAHww3PrvUBtCpd+aa0SHubV3M=;
        b=tIExOq1txBsmUk/c75ilZMISKfKEc3IUbg/Yz6ti+gQYZiaD+HFWAXt0yODkRehBxe
         Q5dh9rMr5FlqCHZ5TunwDuQBLAkLzuwwmk0XZs7p4bssuvSqZ2WdTugi+5yRcCNweVCy
         YA04FWGbO5q+7sAAmXRQtjA1sfGP/v+1d+5VK/E6vqji1NsL34CAA/rsXe3aym2hlVjE
         Dj2aDTDgdUDn7C9rfu2qD6CSXDE3dc4Z4pIv+aFGCVFWrx+zAPlvStQdDcxIks3pxlZh
         ShwnpqIZ6RMRxmrhHFT9WubYtZ1fU/vmC3olas8jR8C9pM8FJ4OIjKvyRuHw/5ZNRfDb
         0GEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786450659; x=1787055459;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+g0yyxU25w21pcLuXRAHww3PrvUBtCpd+aa0SHubV3M=;
        b=EXa0OUyRCUEt/x1s0oD27DdXfVxZXGdeY3Re0+7wn45BI1EuWNQzz0Kq4B9xlVWZNn
         wEOJWg1fohIA2aiouSVXb6AeMINrbtZ8zuZfFWedd6UVxclb+u4X3iZj8XZYMQ1w/fS2
         +pLpOb7W2QiQci1mImOcfdUAIRn/XBZjyveYl4z0T8+F6ID8klRMDXbl13O6s/SM10eJ
         vIUJcdtck09BTlw08ZdP0r0daCe76Y0ob0Gm48uydlbUUXnq0Ms76DbvU+iV2Y2FUffO
         fAoNzo6pnsmN833ACFyras00WXpgS9/WBf9lkAQcUKhngQZ1c4pXyO3t8Mz2o58pYACo
         Sogw==
X-Forwarded-Encrypted: i=1; AHgh+RpaF8DCyFR+hbyu5r74IIlPNZKwnhQ0uaNfSNQVp/7SgpFVM7MuCQs2NNMzqz3m9VG0CKLvmMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwLNXMJh7043G++lAer+icNvm5Knk9bKgM6lLp0r9xeqhHtsPt
	bWaSXwaywE3f/AozuYdb93Jw3AS1T16ocHau9RmN9sgBhAGAWoYMN2zosJeWjEhnEJEAfeti6Ka
	csjsyAQCUIVTdhH4Tmr6UlhOka90mNOKPkY/GaF07
X-Gm-Gg: AR+sD12MM/HFtGDvXmluo1B+saFeHTfLNxPggyV2XlQ8+LOzjap7O4MH0DOEtxXMxwO
	MxGqnQM9R80glnYcBghZyCCz3u6AO4JNN5AjnB6L2beix7KMnBsSj2MjuQayvLyKNRMdY9mh7S4
	uEvXYnfKufqjnHd6jh7cHraUvZaXQ7To3kCkRjBgWKDtoVKZkZvfXuw0728pIqtNaIo5j3NsX61
	0qcByUpDZanFTNTn7/NeMDXylPprSdfV29L+/MovU5ETCUC9tQZAHpXdbT16jD1oNYHknNt+8Fh
	h3QlwzMjh74yBjzWXfGshTAhyTqMIqIpTbqC4QjOpRVufg6UpnpYU1zaQnBz/vJJqRtgJqaczgI
	=
X-Received: by 2002:a05:6402:1843:b0:67b:7d05:60b8 with SMTP id
 4fb4d7f45d1cf-6a3697f7d29mr8059a12.10.1786450658392; Tue, 11 Aug 2026
 05:17:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com> <178621460524.381735.15023846552532101058.b4-ty@kernel.org>
In-Reply-To: <178621460524.381735.15023846552532101058.b4-ty@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 11 Aug 2026 13:17:25 +0100
X-Gm-Features: AUfX_mylL7mka5X7s4oaoqXqkvT0gVqweb7ayJRqhutnUStI5GPh-r5yrwruQqA
Message-ID: <CAFgf54qY8c9wO_RHQZpVSKUCTOgr+WWKCxetjb6BGf-G=5OTSA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for timers and pKVM
To: Oliver Upton <oupton@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 7:44=E2=80=AFPM Oliver Upton <oupton@kernel.org> wro=
te:
>
> On Sat, 08 Aug 2026 08:58:21 +0000, Mostafa Saleh wrote:
> > What started as a  small patch ended up as a 3 patch series thanks
> > to Sashiko.
> >
> > First patch from Marc to consolidate the offset calculation,
> > follow up patches fix issues with non-protected VM and timer
> > offset and protected VM running with broken CNTVOFF_EL2.
> >
> > [...]
>
> Dropped the unintended SOB in patch 3 you mentioned.
>
> Applied to next, thanks!
>
> [1/3] KVM: arm64: Make timer_get_offset() work in all contexts
>       https://git.kernel.org/kvmarm/kvmarm/c/2858600ecd01
> [2/3] KVM: arm64: Fix timer offsets for non-protected VMs
>       https://git.kernel.org/kvmarm/kvmarm/c/47d3eef780e3
> [3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
>       https://git.kernel.org/kvmarm/kvmarm/c/2e813a6e8ebe
>

Thanks Oliver! I believe there is one more bug. I'm not sure where the
bug is or if it relates to the broken timers.
Before those patches I could not boot a protected VM because of the
panic, now after booting protected VMs, I sometimes get a system
reset.
I confirmed that cntvoff_el2 does not get written to non-zero, I also
removed the sysreg write completely (rely on xzr value at init) so my
guess is that the HW might be allergic to more than just non-zero
values in cntvoff_el2.
I do not have issues with non-protected VMs anymore.

Thanks,
Mostafa




> --
> Best,
> Oliver
