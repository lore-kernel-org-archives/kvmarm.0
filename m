Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792607915;
	b=NZe3h21E0/JIS6JdL9WAMvXQ09itdOp3s4BBih1fAiySJf8ZCDdxJaWxQ7ITqkju1oIH
	 8f6CWaX0PIp4R96SI8K+tQNcofJ0zyGGDLGQpUlNtiLpZHdOBLTAJw/IW3H0YcXIzHtqW
	 1Wh3DRT212R46LbxmRaIYKx64qmZ+Kxq0BZ+Az1MTx86kKO9IFn2rAMssYQa4FlROxR7p
	 Ys89VXxrWboPLg6+h2Cw8etT59N0NK/YURME//WYnxpKOkzuPdnvIJpqKW+wnEXk0WDuu
	 o5ELDmt58Awt57v9zs/ZGZIzZ5gTcdzLCdA+fwtrNntzWYMwQ3lbKO5qIDwCR7MgDiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792607915;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=K5lls2oC5CObBW2Bul7MC957A+BWsqy4OwbmQJto8Ic=;
	b=4A2YN6nuPZtvhSX1tTWprsRXQQTP3BOK4fkX86BvWxzupwdhWiiJZz8HYkSDP0cbih04
	 wd9MF2rXZA2F+tm+lRRgPLGaiTTQsppIF8Y3gsdkWW8E0wbi+IzsFd+rZ7m+eD4AOzy8/
	 +t6svkPx9VI0t9lQY959FUT6Ga8uuvS8VxYQ16dOLQdRshpWNF+vH+27QO+lVcP4g9F8e
	 JpyIt0bgTomhNeCHobiQV7sc+Mm/6ansJ1HAiwMgwn5QP4Z+Omt9YvQ3HK3k94yguVQx5
	 2ALrZj2aYI2g3mBHaK8sEMu8VPqgGwizuuByHsmKJosJmwHj+GiQ7L83wULbTCCTdyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XKYIgXR7;
	arc=none smtp.remote-ip=95.215.58.128
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2588E606A322
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:38:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2588E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XKYIgXR7
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K5lls2oC5CObBW2Bul7MC957A+BWsqy4OwbmQJto8Ic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792607911; v=1; x=1793212711;
 b=XKYIgXR7nPo5vlaRLNXgpB4Ydzc7kQzmVVAMY9cvnkPVT3eqd+hMV3C5XY7o0sovngkGOyIF
 6bBSI0J+0U43AXwvE7w0N2+Xhry3512vXzqbAcov/C10fy7VBt4YvQXaZ+SRhx49kcGfZ2m6ARE
 vHpAUj3nQZfwVT5jncwECRJ8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dbbd4ac5f89a2cd5;
	Wed, 21 Oct 2026 18:38:31 +0000
X-Mizu-Trace-ID: dbbd4ac5f89a2cd5
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so1474e87.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:38:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxu3dMCm6X6aGLYr5DxKosItZNY11t2iZkclO3iCtFiXllpGMizAANtlBk53ZAnaGrdEUQ8PLM=@lists.linux.dev
X-Gm-Message-State: AFq9FYL1gIHddBNGyC5WChnRXMfmkLFwgeuXkVs2w10agKc4MnTRMcMO
	XY4E9RoeuBKh+4UBs5lfJKHIPasqH5hhYEGuuOFsnCWmzWVR3CVJvZSHx51YUau76UkVrgmWzkO
	okmFudMUdmMHjrMMageFdp8+p6huBIBrW2uwb4Grq
X-Received: by 2002:a05:6512:12c9:b0:5bc:ed54:d5b1 with SMTP id
 2adb3069b0e04-5be66f68de8mr421311e87.14.1792607906645; Wed, 21 Oct 2026
 11:38:26 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
 <atc2Y4gHwtGlffns@gremlin> <CA+EHjTxMGFuZHPp8ULkpUiGhXos8f1B8kZ1FDigFE7afR=X6AQ@mail.gmail.com>
 <86o6cnywvb.wl-maz@kernel.org> <atjSmLQbm7-_oRPv@gremlin>
In-Reply-To: <atjSmLQbm7-_oRPv@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 21 Oct 2026 19:37:50 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyCLkHwU3NU_s9zeAknG0nU-C9yeB_8VzGgaZvka3vyvA@mail.gmail.com>
X-Gm-Features: AclHuK9BI7fqOPfsqs2U3z4LJDf8paxZf7HpBnvRQgffL6hBNeQHYJuBSCqAjb0
Message-ID: <CA+EHjTyCLkHwU3NU_s9zeAknG0nU-C9yeB_8VzGgaZvka3vyvA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 21 Oct 2026 15:03:04 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> I don't care about the name, but I don't want the rest of the proposed
> changes.

Let's leave the rest as it is. For the name, would you rename it when
applying, or would you rather I respin?

Thanks,
/fuad
