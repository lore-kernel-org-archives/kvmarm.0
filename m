Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007145;
	b=jVxoYYipDKJCEK3PAbJ6t3xIKIqWRnREFmhAXplPj+ExUElDPl67XwggUD7Gcxm89Bo+
	 CGiY/G9ihMK7hiP42UfYIGngIQZaG4nSY0r4jKYmOvHriNSIPgdMcO1qOZfNALQC1JofY
	 k579iYA6hLdDwC+pY4v2DhWWits1/Fs4xHBr8AcVUX26n4n1gx3Lqu0Q51/6/1aEEgA88
	 +cAu3s6sVFa3sPHPYMWxQtA/zNa+gdWEd9gHzrp+Vi8V/6tL7lLmnb0oqzKgckCa1O0gJ
	 cRSKwJNZxtRp24O3FLdhHA++A3mEwjxpdL7PjLXUYiFVtz1oMYoTUnNzhA6xPmDmgCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition;
	bh=tpQ8VO3UkpPGl2BMdFGh9UILzHHG8WU7QyZ3fXKetUA=;
	b=rVZou9lopURgPemsq4wCWY1LMkcxGtRF4Lh9bFm4xuxO9+MvBUo0HGLKogZLOLCR851p
	 fy4xzQ465gsSGV32HYiHj1bjCfparjKny7ajA8aT/xS6XKFAIMNEz1iWWu0fFhOzg9LdN
	 IkHRSPlByQI6p18ClBY4X5nRPjmfU8JB/EJ7EjAHED3ykF6Eh4IyPyvT45++NekuVY7ou
	 Bn43b+2BuLIJ7B37UY5+KAMHjzoKExAFsCGLXXZ79z3/aT8UX8JFiJE51+PQTZPk7kjl5
	 WfAF4FZD5MIW9L+E+bfXgZdoXwaD0MVlwAnc2BgecBNkRqs61oLkLAwUGTlR4EAsGIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=RdkifHWL;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7833606A32C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 13:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7833606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=RdkifHWL
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so6710365e9.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 05:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795007143; x=1795611943; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tpQ8VO3UkpPGl2BMdFGh9UILzHHG8WU7QyZ3fXKetUA=;
        b=RdkifHWL8RAouQTmoO04VAz5MGZdISSQi3HnM02BxN/wz6c9kH1B8jRsc+DbguGbCN
         ykBshsNAG6EiVwQ0r2qyZAeJZlZMGKQsZtJ+mom08aBvslOgAhktk7HLnKvNoJhmOqRR
         zEoo6v8zAex9kQzeTQOIsw3tPxN5PXgTIt0jk/rHN3u7vXxm436MmhXKKUrRMM4Cz4TQ
         nP2IZ97TrKPTJYU96pRQCvIuiG1bGUo96wfUJ99vuoLMXBS7AL4Z1zUXqOzgyozMcP57
         UryOameuK1Imj0p7YpNMx7mHSb3wwPyeVbuU7k1UT1EVEIhfty2n8Y8Efpp9fH1G1DSq
         xM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007143; x=1795611943;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tpQ8VO3UkpPGl2BMdFGh9UILzHHG8WU7QyZ3fXKetUA=;
        b=kVEelcPxsuuAf5THntJr88Uk2Kp0Xf03sslpuv6Di1yutATUYRE4SBd4UEa5FGaaxm
         VN0+k98SPmkoDuqPhPCgjqu+rFrDAwC8b5JRXUweGYYcLuZEfZg4gm0HYJbvotdC7JTQ
         SrzaLP1/7LRoF7tQYf3vOOn5FbcEuB63Y7uu7CheaMPKtlnfMsn/dnq+Mkmjz9W5BNTl
         1R+Y2ozEUwHywPhLTqs6P33oWl3ybzfHJXGHpyrNwYGzeQsBdgzU8/632mk3OyMXTckz
         52nxRSlk30E0vqE1WVOpnskK1AG/pPk4IW7zIYaVA1XML3SgE4h2uISvWRIjg/cBYNNm
         qVrQ==
X-Forwarded-Encrypted: i=1; AL+hErG4XOrlpDM2b8I2xp/8kENuGKFvaS/Mo6Evvkbdz+gbmCL6RMOiabJ4TibsfawqsjPsxW7IACo=@lists.linux.dev
X-Gm-Message-State: APuU4Z9kBZpNQtKVk7+CQv4JI3xgQs7zpX69JenhOX7YnXmOd3jtgQBv
	Tt6a7iOgrmVCaC/u14Ngz9rEioqW2pnnZGmlhMlUxOCy/KxYHnTpmm/c6QQ1Vs3vssk=
X-Gm-Gg: AYBFou1Zolse9ieve1Cdvy+PDlBxzGsnV0wieRB5XR28BUPLMTeFtilW/1I0w9hYT2r
	sEil/yQT2Kin3JwQgDMVv4r5UnXZD+H4+J4yvKOrm2MG6IW34jMjb8AuFH6LB8bQj3aGki5ajLM
	Qu3r5Rp4+wP8zFPFzootzjlrU/PA5ZSaKEaR4at6c3J8KTwaCe3EkGmLISZB32yQKv8U43CrByD
	1m90q6P81snWMEJOfoMHvkSIPYaDYBxwMGwrDVm/LPo/D2PMo/3feT3VBtTyuXYRiUHXfLCgtau
	Nv3/6TKQk8bokUARVDMLFa5YMUVc/nRS/22j0BLkABekoRxAk/OWosaXrRe6opp1Ts+pbUXH85S
	OJugCBXXdqOBTKNAfoyrANqS5iOR9H/3hYTEA3C2itsFx96S0obJ7o6RWnvcDuwXZ372md76HOV
	WDpPg+0aYOOCsBnHmDdeODztPURf3LpOQse3IxCLzlT7thpCS7eXJYZs6Kod6oG8Buhi0m3MKmK
	aPXgNJYpjzWBd9u2vKh7UYDMujSoE/MfdXPxEZ20W1CL9e11qcWve4fd+rP8JNo5cKtP9BMt4vK
	BFc6WGQJ+HhTRurXSFQ=
X-Received: by 2002:a05:600c:c16d:b0:4a1:d459:db4b with SMTP id 5b1f17b1804b1-4bb7da3aee1mr46453045e9.24.1795007142605;
        Wed, 18 Nov 2026 05:05:42 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7e57664esm27848905e9.1.2026.11.18.05.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:05:42 -0800 (PST)
Date: Wed, 18 Nov 2026 16:05:38 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Congkai Tan <congkai@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Haris Okanovic <harisokn@amazon.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Stanislav Spassov <stanspas@amazon.de>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH v2 0/2] KVM: arm64: nv: Fix a couple NULL dereferences in
 kvm_inject_nested()
Message-ID: <cover.1795006659.git.dan@pereq.eu>
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

This is part of our formal verification work at Pereq.  It's a couple
of NULL dereference bugs that affect nested virt.

The first version added checks for if the vcpu was loaded but the
new version loads it unconditionally instead.  Also add a fix for
the related bug that Sashiko found.

Dan Carpenter (2):
  KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
  KVM: arm64: nv: Fix NULL dereference in kvm_pmu_nested_transition()

 arch/arm64/kvm/arm.c      | 8 ++++++--
 arch/arm64/kvm/pmu-emul.c | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.53.0

