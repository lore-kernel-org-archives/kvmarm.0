Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.238
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793185323;
	b=4ush4I9GHIY50XKVbFrC7lJy6hq9YHUK/qOrzWuIgf26QSNVBSYFaX0iCGiHjyS4/e3E
	 aPnLm3MRoUbZKk7s0df0sqoCN7DyVsZrcaFuHooOMlEWzZu5c29kZwBxj2Na9FOYLNXUE
	 g/I57MMSgr6ml2EwUvuHNW94RWFyS2BWDHEI/OMdAfGa7ZFnfRHLdxLUd5iYXlYqRw4Oh
	 /Ii3xpJ5yEElBE/9J0918j9c8Pvj1IHvT+CtrRabxPRTC8qpsrPo3fi2pipi24Hf77hM5
	 JZV19dUnTAyexuFw+psG2PNoz+F8RM+QdjZfaXgKbJnMeBfyGKjluHIhSw3J7d40PkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793185323;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=qcokdDgL4mvoHte5dbQtGJJPejEfezJaBPHvPpNg2A8=;
	b=3bJBm0Nm2K4zyHByNUMpwjZIPKxc0keRvOamflMcxh3dkoyrt0S5t06dsWN8VfcHdtMJ
	 LXJrEROrrai8ygMYNYsZl+OyctMQKIa90bFSyZ3lvWDFKl7T0Q+3jS0n2obRnzk0NsC3o
	 szi7eMc46LfuS4UHnWVswsoj1hlQowhxdX4m2IzA+Tp/0FR23CW8/eawRFO3ItswgizDT
	 wMokAbwSO2kzYmwlJJhlKnxvQJaCjTL9fAAZXWRGZbxiFY8lWoLCAIL3CQJ/cHS/WLrpC
	 JfbvqMW3G2Vk9SboBuToKFPmRq4CV3UmMEyCn+Xa8JIvPPdf8atwwjZKbtt/9NVSVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hn6DOZ3Z;
	arc=none smtp.remote-ip=95.215.58.238
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67F7606A31A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 11:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C67F7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hn6DOZ3Z
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rh4zM0t9OB8EXFXZvzLi8a+hQvyHbDJz8WyuNEI5q98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793185319; v=1; x=1793790119;
 b=Hn6DOZ3ZMJ5PHyEyna4gwB3HF1mQcJrMU2moiZRpqMDIUOjTxpO/Fy//TkdFqzFutynHbarb
 yv2ptQQcUNDCxDLsC0SeSdGVao0zPYLQPWd1MbNqLd++xy8aFToGdBcEykM6ubUXgRmiOkBTElp
 w7wrfr+yNn6uAeXXo9wCrzck=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fa6f22072bc32f31;
	Wed, 28 Oct 2026 11:01:59 +0000
X-Mizu-Trace-ID: fa6f22072bc32f31
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so5863e87.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 04:01:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx0ybAC1lMoLYyJInT18kN0/BWmYLLOWx+XYOInHW6/LIsTte/vrMcv6Ihn2u/Ms7t484yNZOg=@lists.linux.dev
X-Gm-Message-State: AFq9FYKxWPaOAQQ/FrKoWkkHHcBRrJfeaHLcUydxrrXh/FLaBAKJY39p
	XrFtgLSdXWSTbEXfl3P5lQGXc4CVav+Q58ky70ZVrazHMTsfw7z9WmnMexud7HdTbWRxmQ+lggY
	wZXxGyVT/5R0msKb0Q9XSmjeRE7kmcdjD0pkdsO/S
X-Received: by 2002:a05:6512:3a86:b0:5bb:27df:415f with SMTP id
 2adb3069b0e04-5bfcd0262a4mr142862e87.15.1793185311685; Wed, 28 Oct 2026
 04:01:51 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261027081147.498183-1-fuad.tabba@linux.dev> <20261027081147.498183-3-fuad.tabba@linux.dev>
 <auCFa2VPEmxx2ZcC@google.com>
In-Reply-To: <auCFa2VPEmxx2ZcC@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 28 Oct 2026 11:01:15 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzS_rqHYR+bxvMkJt6KAagrDE9VJecAaS4qimqTQa3LjQ@mail.gmail.com>
X-Gm-Features: AclHuK-N-iC_NAvcm9TdrzyXjqM3xFcWr7x8zL-7NgW85hvGrrNZ88luGxX9CiU
Message-ID: <CA+EHjTzS_rqHYR+bxvMkJt6KAagrDE9VJecAaS4qimqTQa3LjQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Pass the PMU events to the hyp vCPU of
 non-protected guests
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Oculytic <oculytic@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 11:05, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> > +#ifdef CONFIG_HW_PERF_EVENTS
> > +static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             hyp_vcpu->vcpu.arch.pmu.events = hyp_vcpu->host_vcpu->arch.pmu.events;
> > +}
> > +#else
> > +static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu) {}
> > +#endif
>
> nit: Could save a couple of lines by just doing?

The coding style says to "Prefer to compile out entire functions,
rather than portions of functions", as do similar functions here.

[...]
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> Tested-by: Vincent Donnefort <vdonnefort@google.com>

Thanks!
/fuad
