Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3E5459AD0
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789115171; cv=none; b=Hyo1Z2to1bTOzklzmhpwYYsnDIQMcIYvmzSDSmh+dS465429+zF0/7YWFe92jvCyuZBe1fvtpWztXvkmseX/T0ZyqFBX5DZXAGWtAU4qb4yS+/xGcJEImLbFpHxZC2sIac9ZyV85oPMSm6SfWCNA5TAM+4zufRoCqAw66nShfLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789115171; c=relaxed/simple;
	bh=2kvGXRAqVZDcJZKczMh3qqj+fDfIG86LBpesa05gpG0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID; b=mHO5cdrt2ynt1ALNon5w3faMLGvo+gV2Az1GMVn/zLYl1bv8O/tQbdHxr3UXIHrFkFD438KBAG8nK3uPHPkc2zf3P8M2SEe48rYxLf/2nly6914uz6XzvsPATA4yhKb1FxCbxJsVE2s8dVghVTQKb9n7NyZpnQfBet9SS4fbbOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XjvOHAen; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XjvOHAen"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca7c1176317so649922a12.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 01:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789115166; x=1789719966; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bjhH5Fnhw/BjVRr46A9maSwy2qrf+Pc0uw9RKK3CLk0=;
        b=XjvOHAenUP4w9z1vF/SQCq12t8tmR2wo6bIBpo9rVQuak3UApg9CzM4qYggiwZmQuS
         D+SEnkFjTZJvw84aOIQT31vG+YIFVXZT3uVThYp9UO83mvN170wVks/qzT/hw+tZPEHm
         Ow1FDBWKSQn2i3nrCGEnNwF4IOtRB+3+PHrcgxzBKG2UN4SMmxqCZZPoE1SKolb7foCD
         gufs9wg9874N2KKZhiHKj3b5WZKuk8BO5P8rQl/h2X2fBnwnTjTm4RiFNJ1KVcn9BNpE
         QfBmTmdShr5HAtcPOA5hwea8zMj1gOfukJPLf72543euqVS+sSd0fs/b+cSHg216R83J
         ktrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789115166; x=1789719966;
        h=message-id:date:references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjhH5Fnhw/BjVRr46A9maSwy2qrf+Pc0uw9RKK3CLk0=;
        b=OsnS7m8/3enoQ4mqIHhmZCWZMnIYWd48vqZjGUwf1k4PAa+oNl8s4QQNOZTq1h9Zya
         SXCm4Z/Jt6PngUUMtW1HQAmPIQzr3Th7POofQHEtWAoA7Br8g3S1DvTRDXywt4pApqtU
         vKzcHhMvqgQEO30krs1y/Gfgfy28LK7sAE7bJiJoJ6UMq2cszYzONigy+1X8R9Y9sxZ4
         Ix/sX3B66J/IblNMuUvZnL7wGLRAarAifVSis6w+5QRCeoq1GBn95KxGfa2CxwdU3/XK
         /IrxbtxF0yrY1510SIFKLvtSFGOEVMNYogFd1q5+fXgVilVMCFzJQlYqJvxpuj35ZC8e
         d2QQ==
X-Forwarded-Encrypted: i=1; AKwUvBzyXOgFtwjLfJe54XvBbui8F1yuy+Obl2eRzhWqymL7pjdP23ZmDC5L5Ghqf6lfK62IpKNaWWw=@lists.linux.dev
X-Gm-Message-State: AFuF++nZDf86D/meNc77lVPF2H8pVR+DjuGjKl3tU3ceiXiURQVY5jbO
	UkvYVJ736SLSh7e2Rodu2NwgQxFbTJ2S+mjDWmSovChzuDAYXcL+r+0N
X-Gm-Gg: AYBFou2p0jth6mv0K68ESF52+TwCr3nwd9mPeYANT8ubqgZaUuvQ8Sc4emoM2FKRyQX
	mB/BJ4lRtAntCoqSm5oIwtk5IFB4Co+7ghwZKeRbD5s+zfJSqVVxeBU3y5uJ0JqcJctmBwbGLeB
	7omMQ5Rfwpg7iWMtjAhBp2Uaz6igdSY4Z3DfiZxPakSAm1o2cOBhpLdM5swjQpsRcrhkMK+hdNo
	WAw/XKtYtr3nPRdziLfzicu/ecsiq2FoXBHs2myULHDTz/YxlaJxsRUUWPU9cmzbEsOPM0Si5dA
	LfO6kjDy/0kOEoaUjYQCzl0+3CM5/WGFOaCFDJXpUKn+z+lGOERp5I0XueBBq9pJy1+B/eRaxv2
	GZgn6BxFB5udpqiOaGJ9MN+LKddTdepY1AKXKhGjkHTuJlwmIrfUHVlCho0iXOVDlw3Di1vqQD1
	e9i5nMtPGiIZfmMcY+T2AGUJ7Lqvn1vyvUAEf3D9hikkb9LH11UjpyxkIHsse5uVQVFJiuNdjD/
	SI1Oe0hiMJCIrVKZoRfDBWbXg==
X-Received: by 2002:a17:90b:1648:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-39d9bec50b9mr4918364a91.10.1789115166444;
        Fri, 11 Sep 2026 01:26:06 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33baf0ea9a1sm1308649eec.8.2026.09.11.01.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 01:26:05 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] arm64: kvm: fix repeated word 'is' in comment
In-Reply-To:
 <CA+EHjTwW64qwPPAY7GpGWnW7kTHgK+NOycPD+ztZLu8MxhKEgg@mail.gmail.com>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
 <20260904122445.31163-4-hemanth.selam@gmail.com>
 <CA+EHjTwW64qwPPAY7GpGWnW7kTHgK+NOycPD+ztZLu8MxhKEgg@mail.gmail.com>
Date: Fri, 11 Sep 2026 13:55:59 +0530
Message-ID: <178911515996.474202.18153234548688379981@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

On Fri, 4 Sept 2026 at 13:46, Fuad Tabba wrote:
> The typo here is that the first "is" should have been an "it", rather
> than being a duplicate.

You are right, and the patch as I sent it makes the sentence worse
rather than better.  Please drop 3/3; it should not be applied.

I should have read the sentence instead of the checkpatch warning, and
Andrew made the same point in this thread.  I have stopped treating that
warning as a list of things to fix.

The comment still reads "assumes that is is run from EL2".  If you would
like the correction, the line should be:

   * This code assumes that it is run from EL2, and that it is part of

and I will send it as a single patch, or leave it for whoever next
touches the file, whichever you prefer.

Thanks for catching it,
Hemanth

