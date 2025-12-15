Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC53313525
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792619; cv=none; b=LuB59729y9B5JVAzxNj9OKHSPQF1hNo1S4hqhRkqamd4Tw/jM9wI0NjjJadstvsEy/mp8ooKEFDOQbBVAd94jLL6PhuUH3e824EmVh0gp2HglsN0wGtgVrv3zUzv1hLr3hbE6PsDH08zDEqbsnvRJG1vlldhQRlSatNma6WTn6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792619; c=relaxed/simple;
	bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFVWvGugPcr7YGL1GXGufYDCXSB7aYevKhrqK1apoJnlcTKvqIgndeOYbpz6DINUvxVMa/MGwi1ZB+azj4ii6LGqBcfzpBCqi+yJYmOyg9d9XMgGYFXR0h69SCCzyYfGBlfXFWv+yvPpwNkvPkQaZtNsB9Dk5xTPJ0sHCsOSYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=erMjdeBb; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="erMjdeBb"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6432842cafdso2930743d50.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 01:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765792617; x=1766397417; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
        b=erMjdeBbzzSMw+3rjEDQ5sWd15npukQACPcpHN0pWlIZ9rbxfXKVaUTMMeAICiZl1H
         2BRUiyZvvkXoiEdkVRrOSH5A6DRWmlUGWoxViD2bMOYP0MbvDrYPmmAxRB4OrKX9Xegn
         PZ3P3GAlDivL2DcxJ8mimgT5n4AfwobuPRTpk3Wb3SYbau6ED9nSj6GZ8J7VHdlznjLz
         XDN5oQjlYYJaAEfS+Kcnqj2LYnRX7HJVMju41NoFQcsV9x96vLZowjKwkYpeTozf7T7V
         o8gxg8+mdY0t8jGlw77Qz1CCPu394GxjtMt0X7SEPcDMMo2Fp6FhQPz5e7oSrCHXFx/X
         iI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765792617; x=1766397417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
        b=D0GKdu5wJ9KlTvzkf4vs6ddKe9ZqzoL6RsqmSMxIyChFcDPk5svkEzlw7597AmUU7H
         1TRyFLecdrVqSIExgf/8bl3jV1Xg1mcXivz50fmlZadMXWqsfCp+jzZF6LerC/slVOYG
         n6BQfSLOk5aIWLfMDZLuJ4wwuAEvy8DwrE64eoCe/NxrCARj17H4y733KxkxxJMkJkgI
         g9T2mPpxptIjsqsd7NzwtEBDeOaSeAKrEw7N9w1/ajnYrJo4nqZyrTdmBf8rkiwspbtf
         UGr/wzYadhZ7acW5Eu3khhE+4ijsMidg6XDpo1jSGWyE8n53LXM7eXKlrS5fb5GOMMFQ
         d9xg==
X-Forwarded-Encrypted: i=1; AJvYcCXX3Uw9yBsvm1hRn6Ex6NC4Ck4sip+GX6NQ+9d9/ftMS3TTUU8DfcqDosm0X2hLp8dSPwZEtOk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaDs768QHmCJOQtf7Y3r2azUmpnsXTTEqpX1LbQUJix16ASrZc
	suGReMJgfN6ag6ZUvtjOGtMzyz4TZA/yeGKp9f/lVZHdpHGgUhzuh8sdGOvvPgWb44UmyNNJ1g3
	l4q6wV4cMiSh/GXpVIUTuVKS1PBbiQyaS833F6V145Q==
X-Gm-Gg: AY/fxX75+k5kuTV1JIvCTLRp+DD4uhQLMgy6aver2ahMmaeW/uqu7Cp0hlQXVsYk2rS
	B8VLmx4jD3zmZ5IAThTQna+aR9tp2XD5Hr4L66ZAS+fFdukuR/1vA+6oO85qAzNRpOboHhVYDw5
	PziqTWZBcZol3vWdfa6sdoYMFa9kbKKRDgFUvWiosTt9x16i8Pd8vdoEWoz6cabXzxzgSkuVP7x
	vMWXF2ARvxS0OKOoFioxu32Ygv0mF3wMck6JBrB8c2uf8lI412dtttmofaviELfi47q12fZ
X-Google-Smtp-Source: AGHT+IGvRV+k5PpJ3mHqjVXWNH0ySYLSRmzIZa/3PhuG05Fhie+VpbBy/JBhrcR8TEOdgUG1Nhjy1u+B7Rb0r7A0s3U=
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id
 956f58d0204a3-64555661ec4mr9123217d50.72.1765792616925; Mon, 15 Dec 2025
 01:56:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251212152215.675767-1-sascha.bischoff@arm.com> <20251212152215.675767-32-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-32-sascha.bischoff@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 15 Dec 2025 09:56:45 +0000
X-Gm-Features: AQt7F2oZumKMouo4dd8tGmO8LzSkjWfV4-sM3jXbB_jFEwXZwbdvqQR53He-UZg
Message-ID: <CAFEAcA-fgWOUu7yWfGNGyy0BwTPxH1ht+E5SQ4tjJf3U=w7e6w@mail.gmail.com>
Subject: Re: [PATCH 31/32] Documentation: KVM: Introduce documentation for VGICv5
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Dec 2025 at 15:24, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> Now that it is possible to create a VGICv5 device, provide initial
> documentation for it. At this stage, there is little to document.

Is userspace access to read/write the GICv5 register state also
in the "will be added a in future patchseries" category ?

thanks
-- PMM
