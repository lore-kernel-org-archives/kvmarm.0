Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608686;
	b=BKBjqIWitTtSdbbEh0ryooT+GufBg2eOMpRRx/LQmjKj9PDHEt46cCukTYqkLTyd0gJ+
	 oCn+jO5SxFw62IiAYM3r+imwA4E+NnTaXUzw1v/J6xzuhtOy/YD53U89UsLk74F8zifHn
	 kfjP/vHRPIorBrPS58LevUa00vqlj7zf5Nz7D2zDQQG91rOstyx7KvlJ74Jv39bR/rH/t
	 LQG4zi3I1Kwl0NIJvcV0Ey4lR7HISgBqi9pbaKko1FHmq1G8Ft+rgAKVmV4KOpkiDnsDJ
	 rTKjIS9q5Io0M9I+xQeryjB4neyy8rIKig/sl48CiQu5/oaluY9uwdgEtAFfvgPioNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608686;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8d0vDitzezDWa7J6bkNN1sM4Lg1Dh0lgOVgctT1VpEs=;
	b=s/H2/ausQecLfz1dKSsGrFxBbltyTaa40V8OnlBrol1ZvSXq0S6jfj4xF4b6FKkNoqDa
	 Of2QgI+BVNKWQ1AQ4HmZ412hR08fokUkFgAVII5jlV5fn+7bb7wiNGL9Z8Kh8lp88DzG7
	 m5mxCSIAYqITpQsqB0QzLBFpj3MvIGAG7deCAGOmDlWgkZ0JcCsJn2JlBE9PcEVyfWe3E
	 +up/xjunX8elf3d0ZH9BFcKWgchAh1Z6ETm3QAVK8V1pzkI3wGejRvgB7knUsTz3adIHo
	 PWSk0X6LTzqHXrBTqb/gtKIVcDo9LTZyXQ8PXNcIMqRqWtCzKIN1JrglRXAGgxL/7yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J3d67s7D;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA9606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 08:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AAA9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J3d67s7D
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb1199bfd8so663634a12.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 00:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793608686; x=1794213486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8d0vDitzezDWa7J6bkNN1sM4Lg1Dh0lgOVgctT1VpEs=;
        b=J3d67s7DNbFR+tWWfdI+VcV0MeOPtK+ppyhwflvXXsZ7AxWM2vOXnAojhio5IU7DNJ
         ZkWEB63d3tsK1sv1gXqSKweCfW4uzaMSxwAGx9eXnzjXzBlxPODQ0JLZHwvm3ueWDtFz
         YToedbnPMXY7uuxkYVc3wggcJnwM1qXw0vY6kIFuvaI+BXcVjiBRXzltetpx19+KWZZP
         Ck8GxWj46L9ysDn1PtkfV+7iL6ZtkXITezwZXneOVpMTy6j84e/a9UuAeM5EIqQpX9uY
         qDWjWivBnbr91m/A4loAZvVxZkSSOe39aSCCrgqDXLHR834PNc6KwhewXOhA1icLqXWq
         pXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793608686; x=1794213486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8d0vDitzezDWa7J6bkNN1sM4Lg1Dh0lgOVgctT1VpEs=;
        b=1T0NPXjm6FwdVG/t4/SN4M44uY4GBqbzcRTg4jWVC3L7KETZiFDdvCGEWrhDnxglIV
         O71LTKLS4lrUv80LTrfiPU1aP52wPvnqFcDNQWKBrmJVIhT8+qIPwuZxCrYQ8SqQ1S1a
         pze+dShJ8QKdhGu1YR/fqoCLWoMZR/XWP9PbKV+UY+dcujwBRVpiqgzw9O7kHbrTFiYJ
         Q3k9pxTfhr7gNGLtF5vaJ0nNEnOurUNg/Xz/YHXJWPKs/VVilAL0bGD4ty6/05JNFgJk
         rxMKGFUoQTK7GZ1U8zDTg35uu1lMINmpeip1/wIKzx5xh6BA9Kyoj0+M/zFUD55MOayO
         5Mtg==
X-Forwarded-Encrypted: i=1; AKwUvBzSt1pAy9T/9/9+VfDiK/WpIkZFCf97PG1KBaNpPtKSe4wy701kC7mcIYrkc59DOndhOCFMq4U=@lists.linux.dev
X-Gm-Message-State: APuU4Z8qZvbHZeCS7aWBpy/Ts/eLtHBKYujt+fUdWuWHs8JqylVFEPAO
	+C37UlZHu4wnf+A6vTkUBMkGjDnSfOuS2vY9qQGfe+xFNumW8XMflXIS
X-Gm-Gg: AYBFou3I/x0wzoe4rqU20PJOq20mNxs8ScptSprM4KjxnOlyCZig7JPC10nKr2KRIOK
	qH6FWUEJ9QwFA7NC8nPSvnE6zsDDvSsL65EhZfmpLhsCT2CrwrE4Ck9HL+4mBlXNe/NLiXSu5zv
	M+N2QAs7OZqQRFw0s4LmVemxitMwRZXAhyEpt/2XM0rMp0RsXIS7Sjl+4JHlxoSOQMEPlDWYYbN
	49tEdl780DNtdIarX0Uv7dKXOl2j3QhM8z8fmLXvY8cNfGnsDenfAmGdf+V7254XPZkiFSOB/TR
	k1W/kT02D4HuaGAGeqy0LuUEO8E038rNuVzIHOxDhRNHmGxF0NP3fQMUmFrsw31f3A/g/3KFzLv
	dN6T0tFM+1h28+QJWw5qhjHN6dYkdJ5HaanNpBRJ7/kl1CKMcDFLr/qehIONdmGIxkO11subCqJ
	J7ehGdYAO/iLf/Wj/gHQCo24YhkFQeBCXcNp/V+bPSbm+GuRZmxUL9OTRjqr4HtPy3ZlSaWpPEB
	IWHYnsZZR4AmuKPgy8DEDPFQODk5oRcc6n+tptXiut9c/ijPbiaCQmQ+1jFiZ8hLR+5fzbamymI
	My3uvGmdCeqwXj1tZFM3hIybLhseuy5HYcDluFL/cpjSCT1VprBuafB66C8ndMtfGbF0jAGILMJ
	lrzQKTgANeYaq7vNjzWdPAIDqlln93bqddgtR8Sd1wmB+AT/ZFVpIKNs5Td2RVapbUXyNISKZgc
	CwzVAczOaOWuCKBA==
X-Received: by 2002:a17:90b:5648:b0:3ad:93b4:718f with SMTP id 98e67ed59e1d1-3ae89879b52mr8145082a91.65.1793608685557;
        Mon, 02 Nov 2026 00:38:05 -0800 (PST)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae85f3e087sm7861463a91.1.2026.11.02.00.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:38:05 -0800 (PST)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org
Subject: Re: [PATCH v2] Documentation/process: Add a maintainer entry profile for KVM/arm64
Date: Mon,  2 Nov 2026 16:37:59 +0800
Message-ID: <20261102083759.1561867-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <6urqt376s23fcyr5pchfrrowvjoo6acg5xt4ujkft7gww6sagj@jxz5rqihtkja>
References: <20261030083351.3040604-1-matthias.goergens@gmail.com> <6urqt376s23fcyr5pchfrrowvjoo6acg5xt4ujkft7gww6sagj@jxz5rqihtkja>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 31 Oct 2026 21:03:17 +0000, Wei-Lin Chang wrote:
>> +Minor problems are often fixed up by the maintainers when applying; if they
>> +say "no need to resend", don't.
>
> The second half of this is a little silly :P
> What about just:
>
> Minor problems are often fixed up by the maintainers when applying; ask
> if you are unsure whether to resend.

Agreed, that reads better.  I'll use your wording in v3.

Thanks,
Matthias
