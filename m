Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622009;
	b=sPLX2++ZGA+tFmRGUE+B6NmAZ19rs1Vk0XvBzbx0MIPCAWEd1o6etloriqeXzbcCgrM7
	 MZSXXFBui2kSxB9Oa5V/MCq5w2Hyy1SrugAIoCbX+IK8jrR0vjm0uD8Cp9wxvrh65Tslq
	 jQaR4u62tGJLC80eGGZclN0zAoq356QbKrAlY2JtDYZWDDzNyTxuymFGcRnLXhly32nZo
	 FLtJKuy/ijgtDUvvq5aajxgYM9PArpWQM+Eo07uZiJ5uGJAt7ZjXJT3MpOAqwdryBDXyA
	 h3pdt8OnEGqH2YoufxuGgR34x5AFOo54ZYy45zE8CY5ioTJPhRAWh9OZFgZ7ERBFz+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622009;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=604SFvy4+RgSkLOg62spOBToZb/ngKE9hV/JFGFCqjU=;
	b=rL1sTXO60urE8bAo1iWYJVSOlcSgP0wSH05Hgv+r7JiRpi9VWh6tZgcU0kv7ftAnJVa+
	 FjCxqRWrVENXvALAAfht2q6I8qmX1+NHnXmOyUkGiFAdsmeZe+QwgWP5vlUXG34SSuAnb
	 CT3lmJ01Zs3LiTyoi3fN6olyhhOyiLRwqFrRkKxqCQJAHmeqsQvpsL3S5hJKZ5FUlejfN
	 MBJV3ykMQzs5BTAidgJpwab2xEgoe9ro9Hv7MLqMpxg/VX/ENYjqcn/ol5m6985hSP0E+
	 hAiTrWeuTxQSm+GyDN6/tFYaop9uzy+4CzxEihfN9AL2KppzB4cw7oKRRtY/3dhKv3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P76Ka9q9;
	arc=none smtp.remote-ip=91.218.175.151
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740AC606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740AC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P76Ka9q9
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zzi6AwEaVyS7KWiqQ9UFdMnPQT3SvBIYY8OV76VYzEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795622006; v=1; x=1796226806;
 b=P76Ka9q9Za9H2JAcmRnchjSA4jZRvLCVI99HHsdnGQzO0t3M98CtmLKX7PbLeBBGu343o0Ga
 gnBXCeQTgvABTME7BDlN1lbJ15lMzrN1X368askaSdgh703hWPPw+4JOi5KdehQ5PGnwDOte/qk
 7RwUIdwZmj701IkFOATZ1/5A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 95dab79fab09b337;
	Wed, 25 Nov 2026 15:53:26 +0000
X-Mizu-Trace-ID: 95dab79fab09b337
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so29461e87.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 07:53:26 -0800 (PST)
X-Gm-Message-State: APuU4Z/9MMybpRjFwZ2PNjIblZ1Z9Q1pHV2EkFYMvQQk8RPBOltN8oLA
	sJKAAvKurvXSz7n94+avJ4LILERCZ+eXrfKdjQ0jcA8raietZqBGyCJppqNorBruMFPknFhsrT3
	YE3928+YlU0fWBdyC31DH9H3vK+aJppM8wjtvCuJf
X-Received: by 2002:a05:6512:2249:b0:5c1:ac5e:ee43 with SMTP id
 2adb3069b0e04-5c212394558mr542334e87.3.1795622005333; Wed, 25 Nov 2026
 07:53:25 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261125153911.106793-1-fuad.tabba@linux.dev> <20261125153911.106793-3-fuad.tabba@linux.dev>
 <sashiko-outbox-233677@kernel.org>
In-Reply-To: <sashiko-outbox-233677@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 25 Nov 2026 15:52:49 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxB4VBRFrwS5LVo2TrmwxLG8=Oyf9JTBWeCaXDfp7X_NA@mail.gmail.com>
X-Gm-Features: Aa3M54p_f3WBy9239pNU7mXjKEDGd8rPn5mPXG1-qpZx9rKsY0g4RHXqEgP4sNA
Message-ID: <CA+EHjTxB4VBRFrwS5LVo2TrmwxLG8=Oyf9JTBWeCaXDfp7X_NA@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] KVM: arm64: Don't advertise the host's MTE_frac
 to protected VMs
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Nov 2026 at 15:49, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] KVM: arm64: missing Fixes trailer for commit 3d7ff00700d1
[...]
> [Severity: Low]
> Should this include a Fixes tag for the commit that added the MTE_frac
> entry to pvmid_aa64pfr1[]?
>
>   Fixes: 3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features for protected VMs")

No. A protected VM doesn't have MTE, so the field isn't read, and the
wrong value doesn't cause a failure. The commit that added the entry
is in the commit message.

/fuad
