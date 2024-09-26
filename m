Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A421A4F2B
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727340964; cv=none; b=TbXk8Jiqv4soDoKqLQJpOyNu77ZSEPHePWUw2kTLvhqbq/c72xIniXM1aEEB6g7G6bQkjFq3tyHzjlYsE3KggAYW7qrsHZpqu4CsCBMkZTp0KEVtyAipFZ8ncHr9X/kt1k7CihZftvPWSidp/0/rfFn35PULCPUdgbHmvBCJxwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727340964; c=relaxed/simple;
	bh=N/MdxSZRRgXw6t3FZKYPDKlvTtCCPAM4Bq/l5Av5B0Q=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rhARt5rlgEHV4lxetSwilqT2FLsW/pl/4zxiAUm4pXdRQWaL+4eORgujYwZyuTLBA/o6ejD9bf69B0WOUIXcC722If8MFFtQAbBxewrzTaM8OZsCYby9d5Npa9isiwGzz/fV10zF4M8RZ3E2NCEfQLsCW4IKT8ooTpCVHb0Ch4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZX7QwgrQ; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZX7QwgrQ"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53653682246so943975e87.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 01:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727340960; x=1727945760; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/MdxSZRRgXw6t3FZKYPDKlvTtCCPAM4Bq/l5Av5B0Q=;
        b=ZX7QwgrQAHo4qkaq5HDIwcZXdmLAMVIIfo1ONfjIma9+tyECe6oJy+sEbdxC7mPW5y
         7nLn3ksFjqFygY7n85wI/OnFVDRuyypWK6fLmaFEmHMMM/cQVU7W18RhVSdKno1++e7K
         DUWoyN95Qdi9iMoP97mMvk9/4T6/xgrYxdx5p8bw6O7G4Ugo5s6WFcubDudnRsZZd0Cu
         IcFFlOLNhg1ttrKFiv9i59mnv+pCh+XnYx/vrHSJiKOVVsSrDnPAs/AaE/AjsNHE/Bq4
         0w6E8+tJDgcpRUijcE5A+j0yWtzC0/lplO1jDMbPZ2zF2sBbOSGTAMzWrBxGLZCQrXZC
         Bk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727340960; x=1727945760;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N/MdxSZRRgXw6t3FZKYPDKlvTtCCPAM4Bq/l5Av5B0Q=;
        b=AbGElTxRmp9AiIiyEfZFDOrylxodDMk5WFW1xypPtrwfQi89mtGpB7qD/FGaYQtBjM
         8sAvUOkzWsubCzAjPPuzZs1Fj7W3Ap6qAPbU95xVZoE7/icQHR09XnFhvAucaEqveS9T
         +rN/q90MOYSJ7fP4SeJBuRdsCYbV7IoS7qziln3jJYXeYJRyYrLklUUBgqhDhfqvzchy
         A8zqyfGKH1zC6etHFrQI48QykLMGhLMaoSZNHWzPDpkGRI1D56helmDk/t+uEtthnPnd
         7++IpLnxowmxwkkIeXuMVb/ovHVYkDwFVWqGQBU84ez976yKkLAuSgzO+96cU5Ar7yY1
         UVRA==
X-Forwarded-Encrypted: i=1; AJvYcCXL0p4yZXegIE+LKZHqKLzh4Y9wPvaZS2ChHAP8/2Z6+o+JHp8KfKHUAn8nkPOy6khLDzVGrJU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzonFFBiwSgH6yVj2rYfGUqLomP9mNFaee3q+NvuO5vmIzpp71g
	96ic5PAkgBEnijdX8QYvRuOWnX7ybbVIxNS6u49wRRg7rR/nGQJb
X-Google-Smtp-Source: AGHT+IHhrS4QXSILHTgsdhqbb5hO7tNCXVRYEYz1SUiLl+OS5YyvI4GPgvxdfXnxwqpZqVHN5fGjFQ==
X-Received: by 2002:a05:6512:33cc:b0:536:55cc:9641 with SMTP id 2adb3069b0e04-53877538012mr3938709e87.16.1727340959984;
        Thu, 26 Sep 2024 01:55:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf? ([2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c5cf4c52aesm2878777a12.59.2024.09.26.01.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 01:55:59 -0700 (PDT)
Message-ID: <15f38d57ca10606e444ca422f802e0961908f02f.camel@gmail.com>
Subject: Re: [PATCH v4 1/6] firmware/psci: Add definitions for PSCI v1.3
 specification
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Shuah Khan
 <shuah@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>,
 kvm@vger.kernel.org,  linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev,  linux-pm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Date: Thu, 26 Sep 2024 10:55:57 +0200
In-Reply-To: <20240924160512.4138879-1-dwmw2@infradead.org>
References: <20240924160512.4138879-1-dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-09-24 at 17:05 +0100, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> The v1.3 PSCI spec (https://developer.arm.com/documentation/den0022)
> adds
> SYSTEM_OFF2, CLEAN_INV_MEMREGION and CLEAN_INV_MEMREGION_ATTRIBUTES
> functions. Add definitions for them and their parameters, along with
> the
> new TIMEOUT, RATE_LIMITED and BUSY error values.

The CLEAN_INV_MEMREGION and CLEAN_INV_MEMREGION_ATTRIBUTES
functions were added in the alpha release of the spec but have been
dropped in the beta release, and are not included in the final spec. So
IMO the uapi header file should not contain these definitions.
The same goes for the TIMEOUT, RATE_LIMITED and BUSY error values.
