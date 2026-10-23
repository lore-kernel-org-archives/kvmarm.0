Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792759066;
	b=YzPcs9hA7IOleGoRgF0k2WYfx/mgxrs+UkjTuBqAuO8ahZNoPH6MnEHLBPn2XKC8eFrV
	 NBb3qa3s0yXa6putBYJnUtPeW68q/TsyMhdlxvQAe1WB4GH593VrLHkVDrIGBGSFeTS5A
	 UjDOIIyHGEOKjDJsDkPrOdVDqp7DFgw3f/59XzLi8wLPszfLF22eWFGO39rBOzo2e6HCu
	 qDaZtYNuUbxx6xnjahdeRqQy0af8xRhD1vNfOXKSq1nUsJwPB2IW7zrmDK0c4E7ztiPP3
	 +oaazKFJCuQyyG/CuBMV6zGQLo+qoEWYns9TXT9ODgE46QAH8XTdN1wMvV5vb6q46ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=SUkoX/3bwjFpT0dyc8UcMdZ4lcBpeSlTtzlkyvLE7Jo=;
	b=W5ZdZkWC0O0gUSRynEd3Y2ED/AvzfpjmqhEK7GjUvpUbq1+siLaD4lp3680LS7/bLtIp
	 JyFmrydcSKcwpvODfdxxmaf5UMhD6daNTdStMxpDsu8ZGawdmvViKiv/X32YqTonYYVx9
	 xZYXmVvtYw0hnMbJdFa71L5m0A+luWj5VENkW8QuLc9QGG7iqO3hYvV3jJbJrGdYquEcN
	 nfyCyRCiY4W12tH0//q1RAvYeQt5S1CyJV3Q6ftzy+5oqAwW0AeXlxPudx6iJeUDoye7s
	 Wil7g8q2+Wjo3lQyRJtCTiP9ZLWii9YKEJRk+TuiJ+HBWyASvgdtOqRsprBXappRV9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=UdpCV5Nw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55A1606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 12:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D55A1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=UdpCV5Nw
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b09e07e149so7518147b3.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 05:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792759065; cv=none;
        d=google.com; s=arc-20260327;
        b=bsrtsSokqac0/EknjmWbFZ+IWLAS8MpJ2cMlAe56PdV650V9nHuBjVYgKLigAOwN89
         PvS+bpD8XxGkh8o4w85WsWWzDjAnKHARmtaCHqHKefPqPmgPIAc5Y3HFJB5cEIlibCLM
         6A71mk4D39CuIE+/yQuR2sJPWX/JmSe5m+14ixODf/BjRlxytl71kWeqmQqgTDMVcbwt
         hY1Nuq2Va8blxHqcaWNrtfVdO1RDvqHPc4auYLls0DMND0/00NvntCHEzp1gYWma9WKZ
         VUsW8OY/CeU+54xkS3VaFW/MQUlQmSTP/M/VQgr7TO3X0TeN/dJc5vZ7xLuxllLq5yFp
         9CkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SUkoX/3bwjFpT0dyc8UcMdZ4lcBpeSlTtzlkyvLE7Jo=;
        fh=6Xyjg6xSWLSps4LsfIP9DNrqwqBvw5iw+KW+vfBhALM=;
        b=AQ47gp5DhwjMYLhaw6akOt8oKAu0j8Y+TSx//tNQfRL/70XwGtUe8iItrbgExSzOwT
         LoUajRA23aiy1vRgr1YqRarTH9BEA6rFpRL22d2C0KBd0HkYmRQyvsFA0kvOd3Syagc/
         OK/VSx4wZYgDjJG2J3Q9tueNpc4jgtS4lZbQVmTjGPUUIQMjwFO+2aeBqV9o51onaWV3
         lwxhDIwfQoSvRQhbgvHlFKB/v2+mEYNfqGFmlSrsuZd8LAA3sn6v81EWRlR0uccXyGx9
         JA/OwZl+9UBpECrjVXppCTmef9uoaO8iQ96xRN9WPhyUGiGpyLWMsp4wdc19UOdB1CGx
         jZiw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792759065; x=1793363865; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SUkoX/3bwjFpT0dyc8UcMdZ4lcBpeSlTtzlkyvLE7Jo=;
        b=UdpCV5Nw7KaIlCuloAFJLGQxlhA4stw57V0NBAMkgH+w1NCrj5SygmTDRxvAK/dSwo
         Pk+kBuxAf1+JxCy2aCr+UtbYN0qDePJhLxIwBmM9kN/878A98ERvOdF6zEbT6ctnK0ak
         0kKSP/e8E6OEcjIEmnlyoLx6A0eYsMgSzb3wW3JhxKSLpAZq6txgQ0l/QDyk4uqejpzW
         j9lqYSKrksU6+mMmN47DsVYDLHkB6+Xagd/36OTDM585N7OAccjaSfcKPZA1st1B8gPg
         9xIFX4SqdyYW4wSyaDPZ0DTKFpx28Ho+7z+Wnp+PJ0Vyd+4obCvZHkoVd5skhCJNjSyW
         KsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792759065; x=1793363865;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SUkoX/3bwjFpT0dyc8UcMdZ4lcBpeSlTtzlkyvLE7Jo=;
        b=iPMgOEpkXVrUcOSUk1IG+JdG4MxPOWmMZMEvXLWWgC7s6ODsYGW7C7k0vwVcdXYsov
         yIK4649HSIRLVcp+Bgjfd6FVCwqhxBGtcsbF87+GBPGCxE4p6mexfQQTXnbjx4cxJyqW
         dhiSVo9bVEH3+EZxEc7pq5xVX6/5LTukY2jhdezj6/XZkeCU67LisSXBj4Du50tbQ1E9
         p+VIq60JXc+6KUmLqih5QHu0FY6afSd+JEby2wlWNZeEoBbJk3IR7jh/S8TJZg7/UQRU
         VAZ/qxbcdp9UMAPZf272ad2WX3Art79YFVpOpo0xh3+xItQ+YNhNSkuB+vBH9CfVSHE8
         Qf/w==
X-Forwarded-Encrypted: i=1; AKwUvBxYV2upBzo+z04923hsuLvlSy1K1QKO95rXLWst2utPR9BpsyBNd3z0IovrRrNliKJI0J4WkwY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLNg+G/9KvO7Q+AMLLNuQXSIXnv7kKbRwneD09/C48m33LNNkcL
	liHlkoccJyuAWbv3YM0OnS3JOfVsn0paKzSWNImuefiS6mgSuNxk7AjiXMBIP1EuCZgcKyAmhV2
	MGWgPQ9rxLreThqSeyUYgPQYYOAAtjMXYBflcrGu7TA==
X-Gm-Gg: AYBFou2ZWo5rpLBA1ozuRTxpEe2G/fwtRL0wIGp7m33RcOxSOdTMEBISv88DcQMG9nq
	Aniu15x7ZB3WaZQppKLeRUVXbfXdbKSqO/GQ24zODt0rINI8quwF5C/ts/7ZWuwUKU8cveQVxj6
	+/CGUKlWPLqnE5bKtzUXJfpIUFgfXsWegnsht2hZXO750vWrBGn6d9Jc5MzOSYhAKw5IDTqLYaW
	PEGnWSF6lPukvKc6zuCmfaNvk67zEv5HkwN+qP9dIqVOmHEjWtvONWmJk53clA77lEeGv/0RL0F
	nxUp+JBosbLE1H23lCV4nd9QpVOuJ8zfyw+krOdSblvyMi9PbbQw8YKScM9YJwWKqrNVOQbB0SN
	FZyug90GT/VTTDylUBBnUpnH1GBk59keXC/65GhL0DTzyBLdxqGHCK2DzKzNF6Wh6KvXISaHoad
	GZ/Rvb1Rqqh2TJdQN/cXeuXg==
X-Received: by 2002:a05:690c:550c:10b0:8b1:3606:65f6 with SMTP id
 00721157ae682-8b157d96b4cmr11350167b3.64.1792759064577; Fri, 23 Oct 2026
 05:37:44 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <cover.1792728982.git.deepagupta@nvidia.com> <529fc7538b61d0d2ea9a984087ff1d616dd65624.1792728982.git.deepagupta@nvidia.com>
In-Reply-To: <529fc7538b61d0d2ea9a984087ff1d616dd65624.1792728982.git.deepagupta@nvidia.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 23 Oct 2026 13:37:32 +0100
X-Gm-Features: AclHuK9ojQv69OAZTrmG7kBHeUcigZauSSNPGVhBPnbTfN_tKVHRQ_dcXo19pmw
Message-ID: <CAFEAcA8tV-Qc_GHxyCwaU-c0h5n5hcTCU07k0bvGiT8ePFu4FA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] target/arm/kvm: handle KVM_EXIT_ARM_SEA and report BUS_MCEERR_AO
To: Deepak Gupta <deepagupta@nvidia.com>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, mchehab+huawei@kernel.org, 
	jiaqiyan@google.com, oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Oct 2026 at 06:22, Deepak Gupta <deepagupta@nvidia.com> wrote:
>
> Linux 6.19 added KVM_CAP_ARM_SEA_TO_USER: a guest synchronous external
> abort (SEA) that the host cannot attribute to a firmware-first (APEI)
> error record is returned to userspace as KVM_EXIT_ARM_SEA instead of
> being injected as a virtual SError. Linux guests treat that SError as
> fatal, so on a host whose HEST has no SEA-notified GHES source every
> guest-consumed memory error currently panics the guest.

So we already have a mechanism for the kernel to tell us about
memory errors -- the BUS_MCEERR_AR SIGBUS code path. Why do
we need to have a second mechanism that needs more code in QEMU
to wire up to have the same effect? Can't the kernel tell us
about memory errors in just one way?

-- PMM
