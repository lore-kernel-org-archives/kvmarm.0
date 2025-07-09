Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E820B2E5B26
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752075193; cv=none; b=HU1a+sRyAZg2c5nw8PVbU5bSPHdBAlg/jWAdnnRF9SiT8XQEJnMBwdIyaGNHgnJrAkSy9wvnLEaZbkNX9xz/6aop7s9BXKgoTG2M7jT1Nq/BVlQTXw0GO8Za5WeAYFSgRDw9lhY8M8P3ilDw1RGA0mCckmDSP4PJ4HXMEbo3kQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752075193; c=relaxed/simple;
	bh=zHPVg3osmCYyAy75qyrzcAxb6ctP4hFf1ZVxGGaCGUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBE4Hru0IuCXImFkLeDN1ZRCTCJNaxkEeeKjC/9fMg4bNY20NAtiK4VAj9vM4l23rw5j6eRfH5ZUoA7SWhAVfH9aMZZBl3N6rXhlRj8dWqFOIEDubu7CT9+T6GH8vWL3CsYuqG4oi1nPkZq78p0fWlla9s9m/VHXw7SKjNPqwbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DubfM9jm; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DubfM9jm"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74b27c1481bso3531743b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 08:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752075191; x=1752679991; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5h0vY+8yWR6d53ywzrllmdRVHS+9LkknzDUPnvu0s3A=;
        b=DubfM9jmXCNQnpXwiLL7ZNYHB3ikQMKOedoHZSN0QXeP37vzwTzmX2rhlmKXgLoClV
         Q0s6+o9Q4l08FxXvjUKGUf8KOBA5oLpoewFzW96cl6DOtMpf4AfztSH6JKKTLAGfywNA
         4t+Nm4AY1eTMvtSM5KoT5/1JmxfQf/bD6TsjYJn8OP29oz26h8SIZTSFlXnPZvcx7rbv
         eEhMCuL38xIA8YtfBHp95gW2DqQI2uw/SidoTQN2EQ0un40RpJR3U26THJLLtCR4Z3xz
         9bkenQca525BH85PuaPc2FeExP6Cx/OiV1kltTyhkEilRBTQT8EdpUw/UDF1mKtjc8og
         HdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752075191; x=1752679991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5h0vY+8yWR6d53ywzrllmdRVHS+9LkknzDUPnvu0s3A=;
        b=L2MkT4RSeh7hCUFdiECuXgs5sKv3TEKHwM/HpMqHMifmiEeb+LFdZCZjDXrq/16Jqw
         2p3SE9/YCAGLU4s12Hx8E81owCyY55tatvML5ojdw0IaXAXx8tF/qJ7Z3myrgGehbQx5
         WFJVOQz9HWng1DWfJlr/kSXn3tMTJ2uYg19SZFp4186aokJf5woI/pLyN0XffveJVJeR
         D15wYY4xcNfjbzA7C4b7hdVZbugqiGxSE9CCfWHv3k45jbIPbiZK/wYW9+YXNFNCH380
         WueYtRHb31VnmEbvkzXYL4e79nALcYqpNOjBBN1cK1oXV8rkmjZUmRSgDi/wv4f+vWWL
         vNEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGCDceCVyVXEPh6uUyTBHGp/QmbtP4AG0PBo5pxfWSPioJhgrRnHRWhlHxaHlPB8m4spttkkw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBCy+yUFSh+eIqSDI18SXS+IxH1JKF4hri0g0FaWjdEvt2FaNI
	0j1s9yA+oLpQFm7AkBM8a8rU4ZWL0fPo7d5MruYMMVYmvqEM7MuBUiS+
X-Gm-Gg: ASbGncthxIhJZ0hVxMUqccN2jA8rkhTXVmOfeV7W9qziw8nFARE9Xl8jc7AcL41WZbm
	pXnEubH61R/nmfz8FnRtm+MjVIDBnhgJW6twPRBQgtPCTBlFkC3DImhl4QMCbx/fvV06qB/WXNO
	tFEKFi7bk7gUY7kPZlSVU15ozrBvamrN/qmq6uE+dY0DAmLVLH2yxIf7CBvxxz+BcwgCO8hbyna
	s8BWGVvLdoJirfDNBJVmGKZJwhZdlcIprRI/JgeNKcuvJIiDkg8sp4O+ziByfysHSWpxORU0knf
	DDUS/kZ8Of2REIVmCylgO2GbAc/Tpj1MR81LL/IRIvIJr7rwB5plB0AeXdQq1g==
X-Google-Smtp-Source: AGHT+IHZtURowHsYjnMJ5BnwtddfQEn1Fb18GjbXaV0krfOX1jJD/FS2hhGkqD/zQ8JNrPNyVELOKg==
X-Received: by 2002:a05:6a00:ccc:b0:74d:247f:faf1 with SMTP id d2e1a72fcca58-74ea645f1b0mr4005899b3a.6.1752075190794;
        Wed, 09 Jul 2025 08:33:10 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee62bc54sm14821781a12.59.2025.07.09.08.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 08:33:10 -0700 (PDT)
Date: Wed, 9 Jul 2025 11:33:08 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org, james.morse@arm.com
Subject: Re: [PATCH v2 2/2] bitfield: Ensure the return values of helper
 functions are checked
Message-ID: <aG6LtJ2N1smBKHh1@yury>
References: <20250709093808.920284-1-ben.horgan@arm.com>
 <20250709093808.920284-3-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709093808.920284-3-ben.horgan@arm.com>

On Wed, Jul 09, 2025 at 10:38:08AM +0100, Ben Horgan wrote:
> As type##_replace_bits() has no side effects it is only useful if its
> return value is checked. Add __must_check to enforce this usage. To have
> the bits replaced in-place typep##_replace_bits() can be used instead.
> 
> Although, type_##_get_bits() and type_##_encode_bits() are harder to misuse
> they are still only useful if the return value is checked. For
> consistency, also add __must_check to these.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Applied.

Thanks,
Yury
