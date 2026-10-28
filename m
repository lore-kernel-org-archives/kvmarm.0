Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194116;
	b=kgOIz8qMpF09BxVzNJm0cBeWm2QkkhxADbioVKhsPo5f3uKVuRjskPiut/H5hUqaANwY
	 Ad0HGOT1PDc83Z7GOTzUMsUU7uc1Df/7iJIVrkEZL0gHU0bmBmGn8RKvHoUl8PxNCAKq/
	 pAQs1VqUYW4nOd5dOouIv6qOpKr8gvLcQlOvLZ6ojxqv4U5uWpAQ6lhpPzBtUYcdIFuSw
	 mdt6wk8tFCTmdbifR/J9Bg61ZWfBTYdS+Us05/T1GPpYTdT7p3d3gWTuKdL0Dd74vqbIf
	 M1YPB6Hc96wUyaKNcXszOjqnlK7+FJW2nMc1CROCfoqArQYUsbcdB6twJVvaadrfvqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194116;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=W1HmmaCLaDmxQDxSww48MVKAfAl+hw686KsydqXGP8E=;
	b=DDVgbqmgQC+3Ct+AzHF9/u7csNCEWAK7pHSAnc+WgUSlTJ9IdyJnTq7u+jStFjuzXift
	 sqiDK/Q6bMd6sTXDvSiQHciELUpVymbwmaA2LDL+THs2BmvqQmjsbHLdoPhOW+qtUBUaR
	 YCQ5OMltBFv6OlYAWvEwOf8FlnCWTA/pcSNdKl+YT2OzWv2K2DBPi0Tkx2sUM8djmGQ9u
	 sQCfGPcdZpOmds37JJAtThe8/X0Kt246Qw+uIl13c7A3m7DhJLpIEKDHvZLXMUTFgLX3T
	 3uM8SkpgibKftLb3r7ATNrA2VV9UW/aHHiPsY3vfp7cK0P18cMZ2RF96dWPvvSIjYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="R7x/orGj";
	arc=none smtp.remote-ip=95.215.58.21
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F42606A31C
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 13:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2F42606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R7x/orGj
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9P2Z/y6NjVdpld2CTv7DpvYDbQvScjoFFhdxAr3DRcA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793194107; v=1; x=1793798907;
 b=R7x/orGjIYhBNm/AtnArv8Lt/Q9xSyb9WMTrLac4iI+EwwBrwfzNFUs9ud5+YVl1+Aqsy4YS
 H3NGB8L3qQZ+5d07xV2WnvLm3LcOtWeMZpIeZDu2qogXqubbC9ZH3+x37LV8QYL0OAkqrRW3Dr7
 3XaS4sX5AhiSyNl1FlzLvPyY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0ae42f46bda83b11;
	Wed, 28 Oct 2026 13:28:27 +0000
X-Mizu-Trace-ID: 0ae42f46bda83b11
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be58ad9600so8334e87.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 06:28:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlS1FWCV3oxWLlA13rdGskiSeChU/uYVcK4Jg6bjKBUpmsfA8KJfUYQ7A0wF1t6v/fOpXsedg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJioUV+SetYGZOa6HUp7mj5SbrFJOjhd9ejAEXvoT36WDIqnrps
	6qP6BHIqF3DoQ8F3WYYVfwxXvAXJ+kCu5aUdysVyiFJaSLJYpIx0MTqTGB42t1nolSUeq40j8D1
	cOhEOl4BLgHKRuRl6O1dq2xEtoyoCtVm7x2dhiUPQ
X-Received: by 2002:a05:6512:3191:b0:5bf:a191:c132 with SMTP id
 2adb3069b0e04-5bfcadddf9cmr156064e87.2.1793194106543; Wed, 28 Oct 2026
 06:28:26 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261028110739.2366566-1-fuad.tabba@linux.dev>
 <20261028110739.2366566-4-fuad.tabba@linux.dev> <86mrryxa0b.wl-maz@kernel.org>
In-Reply-To: <86mrryxa0b.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 28 Oct 2026 13:27:50 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzNWj06JAJsJJgojC1j+TuZbfQbyB-5s+h=9DbOtYU1BQ@mail.gmail.com>
X-Gm-Features: AclHuK-dO70Ki_OMkN_Ee00KAstB-ItAriaRWTmXYHNfORmvfHh-SoeIMyJdhEA
Message-ID: <CA+EHjTzNWj06JAJsJJgojC1j+TuZbfQbyB-5s+h=9DbOtYU1BQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Disable host PMU counters for
 protected guests
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Oculytic <oculytic@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Oct 2026 at 12:52, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 28 Oct 2026 11:07:39 +0000,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
[...]
> > +static u64 __pmu_stop_host_counters(struct kvm_vcpu *vcpu)
> > +{
> > +     u64 pmcnten;
> > +
> > +     if (!vcpu_is_protected(vcpu) || !system_supports_pmuv3())
> > +             return 0;
> > +
> > +     pmcnten = read_sysreg(pmcntenset_el0);
> > +     if (pmcnten)
> > +             write_sysreg(pmcnten, pmcntenclr_el0);
>
> It feels a bit odd to change the individual counter enables, rather
> than just use PMCR_EL0.E, which is designed for this purpose.
>
> It probably doesn't change much, but it'd certainly make the intent a
> bit more obvious. Or am I missing something?

Nope, my miss. I'll move to PMCR_EL0.E in v3.

Thanks,
/fuad
