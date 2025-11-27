Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F92E9729
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 10:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764237894; cv=none; b=erOTqdvzK5mzhgheg+sscjNHI80pHjoTcST34byHx6DxSmLdTLRzvr7yvFvhGJp1GtCKUHIIW6gCwxVBWgfkC3naBUHxnQSLpqoU7sJqSG66FndSHR6zncmah/h+HgFMwQxp+JPS/m2IOopQ0BgXBxR5W2OdwjUIBoVLYdNz7nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764237894; c=relaxed/simple;
	bh=W7PJmEg+ySd6bSUClx93pUrJNIPJakZuzB+lUeIQ6+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PL3nKlWqFWXqktAaB+OtTcBexC7DOTBMnH/2Z8ofnX0Ga55jbIMYrL8ngLhlnTvB5uTHnp8CF49AiK7ko120lFCV/feHYS2/ql2jhYZtWQgJBYbsZrvDlqD7A0LIlV17yCGGOoILqBCvixjwbGPvzmusYjqMPPB3W0pait9Y+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9yAPMkC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9yAPMkC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764237891;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QHU1dfEDnDJW+SngUG/WWslLp6yHfhX1XyYXZAm53gw=;
	b=G9yAPMkCqZkGtiOUFvmphn6UZWuDidVxB0pk7FhFkgT8fICSOEmSa0zo0CaB00Cwe8AucJ
	ON64mbC20FCfPPLWi5TYqSBKd+dL/z5vTZl/YnWMM+v7zL2sqRDKAYsAq6XHHEKbtQ/LZf
	EVMicTIPwVopWQ+WTmV6LCEMV9lsR/g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-fhjbfSnrPT6s6UYqy6QEkw-1; Thu, 27 Nov 2025 05:04:47 -0500
X-MC-Unique: fhjbfSnrPT6s6UYqy6QEkw-1
X-Mimecast-MFC-AGG-ID: fhjbfSnrPT6s6UYqy6QEkw_1764237886
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88236bcdfc4so14296886d6.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 02:04:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764237886; x=1764842686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHU1dfEDnDJW+SngUG/WWslLp6yHfhX1XyYXZAm53gw=;
        b=rj2481LBjWX1pRpztvshFwk0uLEFz6+5QUl6lYkNsPD5h8VDuJvAULkppUi+N2hg/2
         gYmFHSLA9den5jTEmPGGN4K2lOk+yZ66inyVDa46KJeoI1RPNdsN/aqOTYTuJ7MRjtJn
         UuILNSqrCt7UZnYPqrrXzDE/nHWGfNEEcEmDNAHVrPKT3gYTSy2+a0/Z9RKmAh8DXtky
         L378ipaQmkdunSyDG87ZBBQDUVey/CHrhfU+gk6zw/x7baGDtUuuTImqW/34QtKO1vJn
         X5TC40SYQdptmM7OBeKF2SR8dF5pWkES/5/1C84Yf1baklLQnQRk+loxnmplLVcPInOK
         zCCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNZDZZIN6G9duEQMAZlKJkWe/DapvdTbFdjeDPhu3xBWrvyXEjDchFvfCx3bicapHQXT0f2AQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwflFuLw73ai51DwHihfQj/oZP5BSvv72++hIw68LaQCffTjF3E
	5fFwEblKK5xoeTXQV+fuXjCHbtl1R5WmSmsz5lFzvwB7StT29305H/k/uy66WaYc73vtuVe1N6j
	EU7ne/Pszlx8fmMjMjH1yemSYdbqPg7q2/+TCEZK6OfAyZbzajzahEtWceA==
X-Gm-Gg: ASbGncuSSazNNg+FegMQWwL2xHbCpYl4pIwBY1PLR23MfiFZV0Mm4jQCOTQloD/qrlH
	BD6AJdAtaNfnZ7V1SbExdmBT67BnWfmVXYWyLGdnUQoR7tAoYjOuPD8Y8CSro/YFneDVZAXw+yV
	BoTNRIkEXhoFomICr7Mt6rjQw/YoAa8myM0iphYuZ+SC4vaTjqRjV6945KzwaCZet7ANiCYGyo1
	I0kvExH+/EymUnaCSVZzkHV5W9gKRJuIHs2tiwf14BOEvPElhJCnGfaclVS5LhwRq4M6+tN1a+p
	AQUZzgbAAEzW1g2TZ6hD7NvySbvFgL5K2x5ZuDqrx4U6JHasXYBFo6wW3WUQQzfxTMNrZuMl/P5
	C1FkfOMprZXC/h5zerZaFJbPgR72njSAMQv88cYVU/egTzWjFt/Xb3G3kJQ==
X-Received: by 2002:a05:622a:64d:b0:4ee:1f5b:73c3 with SMTP id d75a77b69052e-4efbdafae82mr136566691cf.60.1764237886576;
        Thu, 27 Nov 2025 02:04:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMNAI9vR0jwzy4e6ezn9h7hQWLE/WyRaFVqDnCXyvdwThkgiaIPE3CdjzdXtnP1MyZ3AN9LQ==
X-Received: by 2002:a05:622a:64d:b0:4ee:1f5b:73c3 with SMTP id d75a77b69052e-4efbdafae82mr136566411cf.60.1764237886178;
        Thu, 27 Nov 2025 02:04:46 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd34224bdsm6316801cf.19.2025.11.27.02.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 02:04:45 -0800 (PST)
Message-ID: <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
Date: Thu, 27 Nov 2025 11:04:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r2cHyp9Y1NRHey9Q-OHB0QlFJslz23cjgU9cfqUYBqk_1764237886
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> Hi all,
>
> This series is for adding support to running the kvm-unit-tests at EL2. These
> have been tested with Linux 6.17-rc6 KVM nested virt.
>
> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> running at EL2.
>
> The goal is to later extend and add new tests for Nested Virtualisation,
> however they should also work with bare metal as well.
>
> Changes since v2[1]:
> 	- Move the sctlr setup in EFI to a function.
> 	- Decided to not re-use el2_setup.h from Linux, looked more
> 	  complicated to use than needed for KUT.
> 	- Add EL2 env variable for testing, open to feedback for that.
> 	  This was untested with kvmtool as my testing setup only has
> 	  busybox ash currently, and the run_tests.sh script needs bash.
>
> Issues (that I think are fine to investigate/fix later):
> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.

Have you noticed any failure with migration tests. On my end, as soon as
I set EL2=1 migration tests do fail.

Eric
>
> Thanks,
> Joey
>
> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
>
> Alexandru Elisei (2):
>   arm64: micro-bench: use smc when at EL2
>   arm64: selftest: update test for running at EL2
>
> Joey Gouly (8):
>   arm64: drop to EL1 if booted at EL2
>   arm64: efi: initialise SCTLR_ELx fully
>   arm64: efi: initialise the EL
>   arm64: timer: use hypervisor timers when at EL2
>   arm64: micro-bench: fix timer IRQ
>   arm64: pmu: count EL2 cycles
>   arm64: run at EL2 if supported
>   arm64: add EL2 environment variable
>
>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>  arm/micro-bench.c          | 26 ++++++++++++++++--
>  arm/pmu.c                  | 13 ++++++---
>  arm/run                    |  7 +++++
>  arm/selftest.c             | 18 ++++++++----
>  arm/timer.c                | 10 +++++--
>  lib/acpi.h                 |  2 ++
>  lib/arm/asm/setup.h        |  8 ++++++
>  lib/arm/asm/timer.h        | 11 ++++++++
>  lib/arm/setup.c            |  4 +++
>  lib/arm/timer.c            | 19 +++++++++++--
>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>  lib/arm64/processor.c      | 12 ++++++++
>  14 files changed, 191 insertions(+), 19 deletions(-)
>

