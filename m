Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB873CF218
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 08:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238642; cv=none; b=EVUKCfJCO5mO9Wl6pmSbQmBaduwd4EEmeFP3gyks48fJtOikFzQCd10/Hk+f++6nm++CxJr7khVwFdsWu6IWLkPAE5biopbRSQuYiwyPWOkzvyxhGh+CIjUFQCiR5CIgc1jNsbRj0qAfwAzuJzp3XLsrSvHNE9VaoPaydJGSK3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238642; c=relaxed/simple;
	bh=9RMsph7JBgcHHs2Fj2MNROhNeWIW9zNd/evI9et1It8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOd1WsGKo5ny5AEBg9lPRAeaZHeZRKdTsZmACVu3OXq5YtY9QnKJ/zvKlSde0o1ISLei7iYMKQsXagHt08PdbN1AeifoZlZ9qqN57unSyp+ie0dTQC7ETogdxNVhdoHe0dSyWBFt6Qw1d7d0fnOXW9BacmCquh1Wm2O8PrACRGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtEr9HUJ; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtEr9HUJ"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-86e6d007703so947749b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 01:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790238640; x=1790843440; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YkwdcL9EoHavUX5QcWK4vzTTBKgWFQ8kJmmNwelVh0A=;
        b=VtEr9HUJE7HK2Ue8meJbjsxPbqIZXzLtvXQ9DpowBxFGYTzAH/tobBlpIHDBeRdiZp
         KBg2kGbP5ciHRyHu2xRpisrVr+Zmef9tBLM1rpNj4PWSh8jV7TrO2phdDd2GBZKT9dyc
         CaEdaeL2DvOr5ezQDsqP4UgT5RDUrd5t6tpDEOoLcPfEvY4T6u3Icaae1dH10P8duF3o
         C1q3TG+18zty4JjpUQcwpxE2DcmM56qeQpUX1hgjGzk20MC8pRi4NSgqJLcJq8oGT0sa
         1IvKY83kkY1NDgMivu+PriMEfp0pJsRXL4r3/M2UmDQIsRU6F2waWKiJW3Ni5SH0v9tz
         fQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790238640; x=1790843440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YkwdcL9EoHavUX5QcWK4vzTTBKgWFQ8kJmmNwelVh0A=;
        b=TSqi6qLSZ8itFQMXRo+O252UcCWxhHK828glktGiq5aVH6btbvDfCrXHoLqJd4piE8
         +rPJXVzpxYcqm+vtWkrVYgYQtMIttKH4GewJ6jGVNSOQGErZ5FXqPHLz+jtldzzGwqUx
         MpkgR6df23t41qUpZtxhuREMwT8tulDbToFFnXSFXnzIf8i4SSo3iaAEiaM2xCIo4xW5
         jVDFYS7wdMi4DNqTIO0tsi7ItayWrYmxKFxOXdulYUkAEl5rat1wE+fX6Lzwz8bJcUlq
         OeZjgRaQpM06gbly0nbOTQ2ZkvDoh6AU792yVXAvP6D3xxJty8OSSUaR2Ml+KyiiYfG7
         pldw==
X-Forwarded-Encrypted: i=1; AKwUvBxFO8iGei41FNrQDT01dxS149gYYe9u0YwrepXMBz5+v/VpSUWWPkWiNnQp66Ecsvtxfk6X2ow=@lists.linux.dev
X-Gm-Message-State: AFuF++mlnhNDLIv0jty5AKwctsaLgSeTfFTDN9WI0cyUcMZDMRuOZ5t9
	n9QIa0i8eOeQKV5kuDNAvWwvZzgL/6nC81BDcLS6i3VkHYzkGJ99d4cf
X-Gm-Gg: AYBFou1I3NI0HbeUogS8YhiP8ilHXkLPvtKTUSSbUo+oIh9YpSEiLOx20lhaChySpWd
	5di9Jig2WvZpNsx4cS/3Vxsu67JOuSrANKpD3DwyGHhP2dAevLVWCx23XYqhi7k62iYRnwOB8/w
	7pcHedB63F6Ld/89xZTe50PKgHZMagGrg7BouqartL/L314dZRBdOqznSwlETMEM4xaXMy9sLfU
	EEuKB9kUJIK4SM+2/93dCaw47iw5cJI6SW0LxpB+2lL7wwylAwHpqeKHnOT0hNEo8rUC5f89HJp
	CFcWdXd26JNbpb9m3HOFbN5tTsj6HqB1oWOAaUhu715wjYsrTLhcvSJtUQ1hmQ/NXJ856P/b2xu
	aUi1kEZ9OibS2zfN0ly0Xzb1lK0L3gDOIaxRj6/3KB5xJsIn3ugHCAioj5eUIa80BSkxdZigZMl
	MDbc9Z67jlloUyvKbiL7a6KaUbK52DAT+vyJKuP8jx8Nyq9RuUBbdnFNy0dw+HFvghGtsoeKeRp
	SmGv8M9N4/4SDZpkgkqWJ7tXI6mZLgq7F2rumLjX7Iw2Gnbw3n1yJ9WpFk7Z2xix6sFcZF5eeV0
	L/Ao+/o3/BB8/qZU5FErrN2fyyYOmQGsAiysXn9zqNm8ogC7IWoIqU7rlMU=
X-Received: by 2002:a05:6a21:3408:b0:3dd:7a92:77ab with SMTP id adf61e73a8af0-3de0e6f1097mr1787107637.12.1790238640149;
        Thu, 24 Sep 2026 01:30:40 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc75f40839csm2232878a12.30.2026.09.24.01.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 01:30:39 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: name the kvmarm/kvmarm next branch
Date: Thu, 24 Sep 2026 16:30:36 +0800
Message-ID: <20260924083036.1744194-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <877bkb3zjq.wl-maz@kernel.org>
References: <20260924033536.3624334-1-matthias.goergens@gmail.com> <877bkb3zjq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 24 Sep 2026 07:59:21 +0100, Marc Zyngier wrote:
> But that's not reflecting the way we deal with this tree. No actual
> development happens on that branch, as it is solely for integration.
> [...]
> Again, this is not how we work. We explicitly discourage patches
> against -next. The only sane reference to base kvmarm patches on is a
> published upstream tag from Linus' tree.

Thanks for taking the time to explain; I'll drop this one and try to
leave out other integration-only trees.  The rest will say only which
branch linux-next merges, not that patches should be based on it.

It does leave a question I'd like your view on.  submitting-patches.rst
tells contributors to find the tree to base their work on through the
T: entry, and for KVM/arm64 that leads to a HEAD from 2020, while the
rule you describe isn't written down anywhere MAINTAINERS points to
(the entry has no P: profile).  Would it help if the MAINTAINERS header
said that T: names where a subsystem's tree lives, and that the base
for patches can differ and belongs in the P: profile?  I'm preparing
patches documenting T: anyway, so I could fold that in.

Thanks,
Matthias
