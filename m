Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792587030;
	b=vDrgO5R/lq87MPCX7nS/VoTex0Aj52OIFxVqdMkHFIqMYlz4wTdJSiWl6tuyGjcp7ns/
	 YZAC5AIPYjiqOfXcUzpDgswe4Bc2YKpth+qcO1qp9UAk6yQda7KND6sCM4z+C6FYEXYgs
	 xqbRjsVgXnWXbYIi5oOucx1A0RoQj4/qFfvdZlP6IIhWHQfxdAsyMSh/tUSPQTwSbvkuR
	 Vx37va/thVdbnJbBHYfu+KYFKISNQL1X3qcuJTXRI2FGC3Zsu6GrlBzwSXoI3v7VmDKkp
	 LB1BK7pUq2sLkTZBnTVRo+OO+O8OrcqlYV96oq8eFD+i+RlIplkyZCByRETrf65CkGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792587030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Sh9adS1hWGFrVRHbKh++Je7qyXxMfA8cN2D8AczDFWM=;
	b=seKgBp7I8iso8laRgLa76mb+P7DrMzcXZVFnZqcUYxvgRVtSoBYDsA/v8URFEBF/1G1Y
	 GnTVwi4CI2JprvajApl/4VPdRlzxBjc/8na8+y/cYww+RXuH5qwkHcVDo1K6bOi8dV5JX
	 +B3CRVfTqedTPkQZ5xgTWRgXSGrHWrr/ZDsdKcnNeUERIbVCPYiTPSBhYNRw5f1odjLqh
	 WrfatfKZV47wxjHJ974Vw2i/nGjBLm235Wj6bqxmR6sd7EbHDA7Rh2Pzwkre9PbPFqh+4
	 7c+N1mTDc8La4u+ZRL73maDSADCBoAKYLbuqi03KT+4fclwVJi/eAhTIwtTKl4qzKKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=q0ybyEol;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552BF606A31E
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 12:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 552BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=q0ybyEol
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso2756666a12.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 05:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792587029; x=1793191829; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sh9adS1hWGFrVRHbKh++Je7qyXxMfA8cN2D8AczDFWM=;
        b=q0ybyEolXqbuN10nSE5blDS1+sAk/SpkgqqvyyMk730iAGhSVXbQGh5RkNsidKzO9e
         xGEwtq34LEnSE/xfqikVXXbbZPtMbr6TCGPWgqB7lrUWiNcY2ifQQ4PjHDU1IKXYpJ0i
         2IJoAnmuHS2j5o/tLtCn2bSuBiEapO5K00zzXqubPUQQa62PDXAerExV1UvKi5qL2kWD
         AZnnHC4cUWbsVLtAmHNj6MGkbEzTfFQro8cZmZB3vOFhaazlqo0sj1gZUKnj+CmtCVLp
         0HrmxwYiSmfNqVf/l6bOOiD3JJLhVfm9Mn0tlF7Z6w2cvuYBrTHB7HSDmkUPSEYJLTcf
         Pbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587029; x=1793191829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sh9adS1hWGFrVRHbKh++Je7qyXxMfA8cN2D8AczDFWM=;
        b=QnkE3gFrbSmK9T+KvJttvLP7JRu5mtgx4Rcsp8hP209U8HV82+eToJ5GZiy960m7WQ
         cgTHKcz/EdXOmVvoxFtZddP2JuxtWo1bSWOohqv+GLH7jsIXC0oISdpEaF51Cyr2AASU
         g/bgDFmZ8szfdQMdL3DJeAu+AkYrKY4lNjbO6pFF1NhLSt41+GOqO/uPFvUYHTWl5suo
         veSThJ6NgknUyD0YhzTMp5zsJg7RSMRtnmGG6C6j4efg4vy1Lj4FGIAzjJTMqxxWnLsJ
         4X/wjx3lRIrw4L8WJmlFMdcekq2Vjl3B26hBKVsscqKUBXZVEaYJAKhebgg6VmrJjX/E
         gHBQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1iyVy0m7eW+CWz9CIqIx+l0p2ciUSnweIavWxvHvBQBCTi22My4oeVgDK1rezgJQC1pDRXO0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKsrE39IAj5gyfcgkdzfj9yLIEMi5R7RGXGo+H+AfS2WMXCv5Bj
	uTgAretnHvwZU0BI49wHBEcTPsxIbYicl2Xa+6qabixfJPyxSQKUZCa+NzvDRpuEtw==
X-Gm-Gg: AYBFou0SC1Ol5mRXctdJlefFrnssXNYh3ZrDVet5o9cVq+CG8tGh3M0Mwz8ye4gBg9y
	RcX1iovKM7VeqseqmOt+xLmNP9DLOGC9OAA3Ltb/2D46XVXCKwZD032MyCkNsXbUEsJQ03RK6hZ
	J60zoLpUvT/ovCGj4ZfqwRNG56kpnk9HUaxu6H41yBPOTALofE+c8X4Jr71y1aulMNcRgtmKVbi
	Lwqa4dQGxcDr7p6az7YS2I5kjtxAmjtC0RpICtaasSlX9JMNkZjlTPd63S7yjiDlxLfctGhi2eP
	MG+3F5qIvC96s/Sg3/22wPVWN8re2Bf/nJfUQz1W0IbNpesrp/m8hOx3nEUpDBq1n4yrbs9f+S6
	XkjU4U5sJs60yWbZ2WITWQPcnIBYHpx217H920qRyowIaNEdBvSCXoig9gb1E+Hp1U4tDOt3JlU
	QWPX0YKiZon9+3ZvEIxUUntJYcsQ8hGVHoVTx2R4d5DXLO4xfNPOfZ8OaTFZ/QhUYOJ+AePGxKc
	EOjsd3paaF57EEmhTnXhD6XlQSlDxD/49SjSNq+a0kq8y3eUprNhFAl7ZzqMLSUHMk3GNGPE597
	ULkUA9MBMg8f4UIccV9YWMI5
X-Received: by 2002:a17:906:c114:b0:c2e:22f7:59c5 with SMTP id a640c23a62f3a-c460370aeafmr447928866b.7.1792587027947;
        Wed, 21 Oct 2026 05:50:27 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4678e5acc9sm74841366b.9.2026.10.21.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:50:27 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:50:22 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v1] KVM: arm64: pkvm: Clear GICv3 LRs in the hypervisor
Message-ID: <ati1DrtmMd-63bIN@google.com>
References: <20261021110000.508827-1-vdonnefort@google.com>
 <86qzhjz1iz.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qzhjz1iz.wl-maz@kernel.org>

On Wed, Oct 21, 2026 at 01:22:28PM +0100, Marc Zyngier wrote:
> On Wed, 21 Oct 2026 12:00:00 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > The LR registers are architecturally UNKNOWN when the CPU boots or
> > resumes. However, in protected mode, only the used ones are reset.
> > During boot the HVC __vgic_v3_init_lrs() is never called because
> > vgic_present is only set in init_subsystems(), after cpu_hyp_init() was
> > called.
> 
> Why don't you fix this rather than making the init even more
> different?

Ack, I'll make a patch to fix that first.

> 
> > Also, the PM notifier isn't registered for pKVM and the HVC
> > becomes unavailable after the host is deprivileged.
> 
> Sanitising the LRs on PSCI_ON is probably the right thing to do, but I
> don't understand why resetting the LRs is out of reach from the host,
> given that the host is fully in charge of the interrupt injection, and
> therefore controls the LRs.

I suppose I could reinstantiate the pm callbacks for pkvm to at least reset the
LRs?

-- 
Vincent

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
