Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793086692;
	b=DIxUUvZcDxL0nOdAII48pEZ7EHbZV8J4XKnBmcV/pGw4/550ve3SRICyzPVw2wfWciMu
	 QTaxoFbI6x4vPK7wb3S0ErK86HVHMpRcTVjs8jUhs4qqFl39bn/7CFz+sNQozlLdcFEvm
	 ggqxJHKy7/KtYoe9VsZ51rbZrN+cwJKB+ieOmRXTAvMa33wtbEeTOo2UM6nJzlRNx7BQw
	 oYAdRbR5b0WJ5Rj9lw2TjxKhhnBlpg1XbZY5WkowtBeSyAze2TY8wY8uXpCg8cWDeWsfu
	 gEwBm87xZ2Hn/fr+uUTO3edL4cGvDQ0RlXJYnrSxNoDS6jSaXgcXJp81znF2r2ymVCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793086692;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=DUdFRfw52ywOMQpo+REv/lQY3o2e9igJbUGF/Xyek/s=;
	b=jsgAvOpAaBHgOJJ71Tw1jydlnABDG50+M4M9UfFC+mFcHsaR3oHFeTxIj3pWXRJVqCtt
	 67Nl2tjKiJQ10agKJza/NDh08zZ4mzoAK8zZyUV+SwEs8lxs2U+LQbV8QBLLAP5HpcWDR
	 /YHhFOLfDkwlm7qLQUctez9PImt4CuChL3R/PthpdEYXHlJYzVv3f6AChxnrlZHL6hf+4
	 lLJMFuyHjF3N1hblZbStXmirao6mTfJWlNakMDwRshl9AyP4m7t4OZ29hVMbJg05tgA5U
	 F/XjrLCylSHZ1qwcP2HPvh0divtgLewa1no3CdH+fG/Ziu3mbTd7lmPXcAby82PjRYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kqiFB6aB;
	arc=none smtp.remote-ip=95.215.58.150
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81628606A31A
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 07:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81628606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kqiFB6aB
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DUdFRfw52ywOMQpo+REv/lQY3o2e9igJbUGF/Xyek/s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793086689; v=1; x=1793691489;
 b=kqiFB6aBfUeCYCRL1yc2U0GOv1kqzHiVWQtng2SxggOdN6T94tg2YzDCljcSFg7sfqa/lfx0
 bNrEPFOFjHwLICW00K4yTraPvBNIp7kqcx1MlMSU8kOuhFyeMkwEJEeMw0RWUkvwBkFRgdS/FyI
 R/I3h5ivA2mC+VX3o1zGpKaY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1da2b82c294444fc;
	Tue, 27 Oct 2026 07:38:09 +0000
X-Mizu-Trace-ID: 1da2b82c294444fc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso4032e87.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 00:38:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw05Dosu9EBPwm3G07aHCj9mgA8tbN60rr2ODfrjM8DWymZPcOijb78kH/nvn9aRDbdG4SwWLA=@lists.linux.dev
X-Gm-Message-State: AFq9FYLiM5UKVTbb+lWxuDqVapNJKO94Qwzb7R5iX7J8ekZyRX48UsNj
	7US7FIwOg73u8L+WLXTfZqkPve31dquTDIYaL62+YiwOCTaYZd+hEG1CXBdJVUmlTna2GWA6vUg
	4Vh+LpA/hhbvF9+wzKht1Qvt/nvT099pyPCw9yOLm
X-Received: by 2002:a05:6512:31ce:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5bfc64ebb06mr117765e87.6.1793086687794; Tue, 27 Oct 2026
 00:38:07 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026152639.3926498-1-fuad.tabba@linux.dev>
 <20261026152639.3926498-2-fuad.tabba@linux.dev> <at-mF3Qvq67Nh_v5@kernel.org>
 <87qzhc8ce6.wl-maz@kernel.org> <at_GYZQr1RIUi2Tf@kernel.org>
In-Reply-To: <at_GYZQr1RIUi2Tf@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 27 Oct 2026 07:37:31 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwnGzQ3ycmk+jL+Z8LKSZCBP9fy-CFvFWb18C6xb_xU1g@mail.gmail.com>
X-Gm-Features: AclHuK8QU5R1ACHMlkVCCkXbAIJslyt5dlAA4mZb-HbR610UB57AMm525lP1-_8
Message-ID: <CA+EHjTwnGzQ3ycmk+jL+Z8LKSZCBP9fy-CFvFWb18C6xb_xU1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Oct 2026 at 21:30, Oliver Upton <oupton@kernel.org> wrote:
>
> On Mon, Oct 26, 2026 at 07:55:45PM +0000, Marc Zyngier wrote:
> > On Mon, 26 Oct 2026 19:12:23 +0000,
> > Oliver Upton <oupton@kernel.org> wrote:
> > >
> > > On Mon, Oct 26, 2026 at 03:26:38PM +0000, Fuad Tabba wrote:
> > > > KVM can run a GICv2 VM on a GICv4.0 host whose CPU interface supports
> > > > legacy operation.
> > >
> > > I'm pretty sure there's no IP out there that has GICv4.0 and legacy
> > > mode...
> >
> > My favourite space heater, HiSi D05, says otherwise: 64 A72,
> > GICv4.0. Remember that it is the *CPU* that provides compat mode, and
> > not the GIC.
>
> Well I forgot that one got glued together. Good thing you're on the hook
> for fixes this round then ;)

Can I at least get one of those space heaters for my effort? It's that
time of year after all... :)

/fuad
