Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.95
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696843;
	b=pHtQ/a/ljqHIQqKtrgPqEw4SwNIoXIQ0VlnGJiugxxUy355+sBnc2RkFK30uCWdXo8xK
	 XEan9Dz8iVa5N+kLPIP+MklBipOqiw4OwwVKjNe8baeNi6yX/O2a9xgUMbNKpWc4Z4RIu
	 LY8RjgkCu4clM+A5hvCpqSIrBkE70W/I9oFAmHKV+9dnkcEoOIiQ+tkrDWY1qDo4ZOsYo
	 IjdeV+PLsPXLeNYUNmPdKQM7l/aruItLUrTVRnClV/ysa0qJsQNAqajr2wZ56NIg0PLWo
	 GvVg/o30uWD7JJXuRARQtbSSrFzzuxehcfYPmOxlhYCQi4XpGEcaDiAoFO48PywKqMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696843;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=nftPNhHACaAjmrWyLnFiFxg6dPd//Ubc6ntdo0W25Vs=;
	b=f+YRKhyZ/hB24bb793dtnOOjcllQLCpYckKcY+ECuOwK/ITpLxg0Isw3v/qE5m/2l7S4
	 gZnvKsKkTAzDGMjVWV15WT6LcfX8ijslB0mYclkHvbEQ7ZmVTuEu0GuFn7Pr6bDyK7HoG
	 EkUIb1A7XjXcLoXVNNn3fXodpm2E1liS3oHnoeAyxrfpRbV8/mAa/QskOG5PGQbBocen/
	 jp6Bkd3lLy0CZKp0pdwdnUBene1CW3oBH09Ip74av9ybG3tRqW2OYxOToLbQtx/VmIXkH
	 K6tt9Sb3RSjISaNFnEwZRVvx43bunwJnfxflfQQydUfn4vRdw7E7u9zTJQkRSnkrqnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y+8M3B18;
	arc=none smtp.remote-ip=91.218.175.95
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48697606A327
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 12:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48697606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y+8M3B18
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3S+tkRDlt8mmbrhI28toVD30bvDmGMUv8PKIjZ3+uC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795696840; v=1; x=1796301640;
 b=Y+8M3B18sEpQeNwvwEy/giJTALEFan5kKjpIE0qnHdr/I8Pj7a3z/WSGcMRJn3FCHYrsPm0S
 M5U/wJwJVEkWyV6gQCVIUksmncFeLgYzM1xGr4vRcH0nKJqiUrnkF5BdVSBBwnWkmdNvlc6JAoH
 h3kckpQldx0XXji8iu1tKo/k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bcab7ac0159c6a26;
	Thu, 26 Nov 2026 12:40:39 +0000
X-Mizu-Trace-ID: bcab7ac0159c6a26
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so36945e87.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 04:40:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHgonF4kEY5odMgjhovxUMDcjk6U6N72c9YmmJjMXaUUgrHAsAEzPk5vsHBXJNYU2QkpXPzPfY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/9V+XSJsjp6scN/k3VSUzXgTIG9Rwyv2/KlOypiRPGVrK1mAIJ
	nLAmlWhBYMdl+pnKzobg+koN1qvleXPQRpDRn8e9EyOdudAILjSEp72dklcmpNpO2/3rNmii50q
	vcpZqMihefXoYBov3e+8jfGveLm3fTVyYdHcWIqD7
X-Received: by 2002:a05:6512:3983:b0:5c1:ac33:5a4a with SMTP id
 2adb3069b0e04-5c21a27a14emr850306e87.14.1795696834316; Thu, 26 Nov 2026
 04:40:34 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261126100023.1286902-1-fuad.tabba@linux.dev> <06effdad-0a76-4d73-9542-cb628a40d887@arm.com>
In-Reply-To: <06effdad-0a76-4d73-9542-cb628a40d887@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 26 Nov 2026 12:39:58 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwVzRPi-cxH4jbvpm2P5x9B2kvBUeuWyX__i9nHZpPmew@mail.gmail.com>
X-Gm-Features: Aa3M54rSvorHaYPxJpGhhECQu83ycbJnsMQoQINlgHkxCOdeEgWdWCtjoCL7aJ8
Message-ID: <CA+EHjTwVzRPi-cxH4jbvpm2P5x9B2kvBUeuWyX__i9nHZpPmew@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: gic-v5: Reject an ID_BITS too large for a
 linear IST
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Sascha,

On Thu, 26 Nov 2026 at 12:28, Sascha Bischoff <sascha.bischoff@arm.com> wrote:
[...]
> > Reject an ID_BITS for which a linear IST would be larger than
> > KMALLOC_MAX_SIZE. This applies even for a Linux guest, which
> > configures a much smaller IST. Userspace writes to IRS_IDR2 are new
> > in this cycle, so no release has them.
>
> Thanks for catching and fixing this issue. I agree that we shouldn't
> allow this to happen, and what you have here is a defensive check.
> However, I was surprised that this was reachable in the first place, and
> now see the mistake I'd made.
>
> In general, we limit GICv5-based VMs to 16-bits of ID space in both the
> CPUIF (see vgic_v5_reset()) and in the emulated IRS (see
> kvm_vgic_v5_irs_init()). The userspace write path fails to enforce that
> limit, however, and only checks the hardware capabilities. I see no
> reason to allow a vIRS that supports more ID bits than the CPUIF.
>
> Maybe something along the lines of the following in
> vgic_v5_mmio_uaccess_write_irs()?
>
> /* We limit the CPU interface to 16 ID bits, so match that here. */
> if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) > 16)
>          return -EINVAL;
>
> Are you happy to add this (or similar) to your patch, or would you
> prefer me to fix that up separately?

I think that this is the better fix. I'll respin with that.

Thanks!
/fuad
