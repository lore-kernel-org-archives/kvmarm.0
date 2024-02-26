Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6A312880A
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957182; cv=none; b=AAQy98i7mjF7uMIjFVO2Ej/1LuMXkt0V9J8WRFETJgvDszH6qoPvktKX3mGYET1Frbw7xO0+FWjaOILmbEwj+npiyjCX7Y/7VNWemKBNTMw4uxox7c++4niqfIAh84OwY7lmjGT8M7Lwt78VQkIT+Nq4sISp0xAeg1UQIF67eIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957182; c=relaxed/simple;
	bh=gai/GiGBgYJiOyrG+mmY/1tUlW1NPiRKQw3ns5tMD68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2hJwMwr2vZX+08+dLvM4wJ0bZYN5ynFEKybK33BZGY5J1XQA78GkzZXhIk5J+hk+WuyOOZ7dWLxX1mL+0/zj6IjECQ2kugYKed1LTFKt2pnT1eVG4QKt5H9/uAk4SWMU0nsUORL2+wrRCvgVfIIccMCW2J/H7T1fFiQZ8tjWxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TcaotAr/; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TcaotAr/"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40fb3b5893eso24416035e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 06:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708957179; x=1709561979; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gai/GiGBgYJiOyrG+mmY/1tUlW1NPiRKQw3ns5tMD68=;
        b=TcaotAr/CUo2P4Qo+SUUX0dZkNBRSADGpQuMiuE7YwQMDwJ7sIaOwM1vHfoIBaiJzz
         fVyHqvXgETlXrtyXIWxjU3MdeOqGsA4tV6/kpOeYHKlNVIfiHi+NSH8dDD07pgCMagkS
         clBexnygNtKdeJJ7u6LsVAerksOzwF4YsOb/NmxLWx4mO5uheg3H9XGN/+Rj/DEr8/dW
         fGLTyYu4QvWcVZ4BKqP4mZ5TTy4CW7WGITJKzSIXa00fuVBTYxvduUsPsxJIco/gsqs0
         MtLmP/4+1Y+dY24KPhhJ0lhurMWL1vbLV+dTOFA+fgNJyTMYbAOB2VgMaUoo9ApFCrIE
         XXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708957179; x=1709561979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gai/GiGBgYJiOyrG+mmY/1tUlW1NPiRKQw3ns5tMD68=;
        b=W0bQe7LduZfdhePUf2K9sqUeRD0y/YhL5DnsVFT0N9c/cSbT5tsJudsmawQQ9kLqcq
         DSU6Yo1cQGIKbAX8OnY6RdfyD8PvVdBIzyOfh7vT80x/mZrq7EGBTxG2knI4jvUwHiUI
         hkN8b6cGUYBcomlceji1tkTluAcMU+2TdQ9cfu5E7ww8+9enRLTdjfgla3Aww0QxTuTK
         BkkpSlnqZ/zaGOBZok1hJOTiDQUYBb0DxMFpt1Fy952LyoaMxLLYVFARBxWTKJ90qGbw
         40efLtLUvkSXug/uzWRUaU5yCZo8IGYTVlyCAn5+skK7HDHASm5jqwce52WelEifzdlI
         bEuA==
X-Forwarded-Encrypted: i=1; AJvYcCX++I/6v+lFnovUs8UYMmCr2hNI0BIY7usG2iztGTpNa5z9E+tSk7F4A43qcNH4tTx92d9PQtR07NorrIAg2JkxknVPn+9F
X-Gm-Message-State: AOJu0Yxk2lsnbpM6KXuYSrkvbfPGwDRxAXAsjBgUkoGG5kZR2hxZB6zi
	hh9An7OVYWS41r74uVzXzJcpRrZbZ9CgL3V3GOWMXDNxsfLY7D/utgDlKfgY9/4=
X-Google-Smtp-Source: AGHT+IEdNCnX1nw1wKmlDkmdLNh/bZj2Ejkr26vzdxCwCUpJHwjjuA0WQ0F8/258UyR0vtTBUJErAA==
X-Received: by 2002:a05:600c:524e:b0:412:a16d:fedc with SMTP id fc14-20020a05600c524e00b00412a16dfedcmr3592533wmb.7.1708957179481;
        Mon, 26 Feb 2024 06:19:39 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id y16-20020a05600c365000b0041296bac040sm10861565wmq.26.2024.02.26.06.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 06:19:39 -0800 (PST)
Date: Mon, 26 Feb 2024 14:19:16 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 30/45] iommu/arm-smmu-v3: Move queue and table
 allocation to arm-smmu-v3-common.c
Message-ID: <20240226141916.GE1579460@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-31-jean-philippe@linaro.org>
 <Zc9PHXEn3IKFlzXZ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc9PHXEn3IKFlzXZ@google.com>

On Fri, Feb 16, 2024 at 12:03:41PM +0000, Mostafa Saleh wrote:
> > +int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid);
> I see this is not used by the KVM driver, so it is not needed in the
> common file?

Indeed, looks like I've already removed this at some point

Thanks,
Jean
