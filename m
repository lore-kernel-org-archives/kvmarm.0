Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EE143A80A
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 10:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123448; cv=none; b=IxyoQhYnVuCxZe3l6mzp7uE/R+GWFOtk9BqSNRd/pMB9dLOpmCVRvO6W7F/RYvtLuM5WFGwwRk7iP2MNGM0xYN50lPK4fdT3SE1fu+g2f8gPL4zKQNcCpztqNMs9ZFdUZLyyGxmB/Mz8RlApT3tBa5gST9cCM3f1m+cWAYTW3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123448; c=relaxed/simple;
	bh=dt7W7qoqMvN/pTVmBCQfsmPq57WbDOVswaYdZJuMgEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrPh946d1NRAbp9MFGnIIu8BGPauoIuppNIpxtvLNiQ4S0Q1jV9nMWLrwRdpL5knGbxNWrCh0wAr1/JkwvZmnh3yquru6I2vb2BpV2cSz/X+hNt6CJfJWjH5mjfHNB40VEOCg1srLT9RwLhAIjC5SyldTjsDNyqsgxf3ytJJv5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RIlB4Thb; arc=none smtp.client-ip=91.218.175.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RIlB4Thb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dt7W7qoqMvN/pTVmBCQfsmPq57WbDOVswaYdZJuMgEM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789123443; v=1; x=1789728243;
 b=RIlB4Thb+YX3VsjQtfMsck+mm6Zfh8XjD4cM/nm1sF2+PWpmsnCl3367U7Bakd1bEv4JqMLM
 bHeQrRaChRPYpcztYoXikR5v5zOd/p7G6JrJTdFf/MHiaWOZvGVMAKJPyoJL/+H8p4zjEN9mZ4C
 1/lZ89IUVWT2n2pgNQOTCixs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 494dd1acdacd3ce5;
	Fri, 11 Sep 2026 10:44:03 +0000
X-Mizu-Trace-ID: 494dd1acdacd3ce5
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so3696e87.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 03:43:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwsMW8QFuYcGMv/SZLYjfu5Fr8TXmDOcZ6fwfXpeMOAboekIqFAnhUW1IdIkBtct030UxT8lh4=@lists.linux.dev
X-Gm-Message-State: AFuF++lMzTkQw6i3gCEbNtNZR1UaJlLYdrd6YhQV/cKyAaclhUsHjXUv
	nFFq2/2rBZ8I1KzEa01bKWBwDoXJvZlbwaah/+hqC2qeR/0amzla3L4ZFNZFEEXYBQrST+XsDGC
	+gHQrBDztI6XaCTHqUPofeoM7rLeKq90E/64sxE6k
X-Received: by 2002:a05:6512:6204:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b8a05364c4mr124575e87.0.1789123438690; Fri, 11 Sep 2026
 03:43:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908145651.2828597-1-fuad.tabba@linux.dev> <86se3h748o.wl-maz@kernel.org>
In-Reply-To: <86se3h748o.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 11 Sep 2026 11:43:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzos572k==mryykXi98Z_Ok_WKy=1nyv_P=+TmQSbOzdA@mail.gmail.com>
X-Gm-Features: AcwNN1VahT4s9utKWdo2oybbVii_jsZIqb7Y0hgJ-TEx-cPBPTlX6iufnxeQGOQ
Message-ID: <CA+EHjTzos572k==mryykXi98Z_Ok_WKy=1nyv_P=+TmQSbOzdA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Xi Ruoyao <xry111@xry111.site>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Gavin Shan <gshan@redhat.com>, Yuan Yao <yaoyuan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Sept 2026 at 12:08, Marc Zyngier <maz@kernel.org> wrote:
...
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -873,6 +873,11 @@ static __always_inline bool system_supports_mpam_hcr(void)
> >       return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
> >  }
> >
> > +static __always_inline bool system_supports_mpam_sysregs(void)
> > +{
> > +     return alternative_has_cap_unlikely(ARM64_MPAM_SYSREGS);
> > +}
> > +
>
> What is the rationale for choosing alternative_has_cap_unlikely()
> instead of cpus_have_final_cap(), which is more wildly used?

Not a good one to be honest, and it's gone in V3.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
