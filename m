Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32263CCFB8
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 19:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785180489; cv=none; b=VtzyojErAK9Y5Y3QOt+QYtz9/d/jyjn+yuZ44AYEmGTTy797kkWML/BH2ugY6oWU+yRffvo3ZH2SRnmP72wNEAs2F5IELxsd3O+8eP+rtnpKXaOwmORubdj0ds7EGLS11eur//8MVeX+wBLblleBJsfKF8otdxRnAYS1oxUbGRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785180489; c=relaxed/simple;
	bh=QCrE+iGXfZD6zD5R9MwWECEg7w8b/yqHCg7oz9hQ674=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/3cFcvDmm/JhcOpxUBL4Dgp17a+okoXUhgJFEq1nLsee4NEwioYwzxdKfDL5zTL7rsAQ8Z3ibIJSlXWCHgCVVssBg4MPU1nJGl8fGzPh2nfrxLHTsy3v/EFAclAHXrzIV5D5qJVt4xSe/AOQGCNx4IKSYmmW2/WYWdUm1O2oZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J0hWATlj; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J0hWATlj"
X-Forwarded-Encrypted: i=1; AHgh+Rou498mQEdYODvbWAYUG5UVlI7S2l/aQsjqU1vuhcCBk/LcZdTTB2J7uasTzTdKNqH2/jnASjc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785180484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzFyIvdETtvcgqgQWIorf4OEXGTCx8wQba8CPFyKDaM=;
	b=J0hWATljJvl/zCKgAhm6GUsLm05srRPJmWGcuPspCnf6T/HGaW46ccOtX+eVeH6A0kc9FR
	FcHQ6vOyzX2YtDoSJqcuUJJIkZYY9LtW848FfY0osHMwzGtS9uG9l/yxbRh+TmEYug260q
	dC/sbD6V2WDfU9UJnbiOnFWI76L5tLY=
X-Gm-Message-State: AOJu0Yyh2oH1rzslNddtOxFHDkwRwNk5vzQXf5qHG1mbgGh1xSqa/Vxz
	2QvO5Q8oiuCd/aEl29a6MR5qWoJv5rTbQWTBWFuHORo3wMI2TlyjHE9r2qp/Wdvc48hTsyodrYj
	JMv/MiIilI4zBLsdM4bRZb31LpfVAcosnq5Fxbs1n
X-Received: by 2002:a05:622a:901c:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-529a76e10b3mr37835361cf.11.1785180477336; Mon, 27 Jul 2026
 12:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260724104819.1296803-1-sascha.bischoff@arm.com> <20260724104819.1296803-39-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-39-sascha.bischoff@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 27 Jul 2026 20:26:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxk_OnWEd_2w-w=Ub3ANXdHhqx_ai52cjy0vMo5bGOnfQ@mail.gmail.com>
X-Gm-Features: AUfX_myJCmLEFpem2D6VmQMOVasWlfXcuLnqXXpU_yqxlWvcIJNtla0GtSeFpRo
Message-ID: <CA+EHjTxk_OnWEd_2w-w=Ub3ANXdHhqx_ai52cjy0vMo5bGOnfQ@mail.gmail.com>
Subject: Re: [PATCH v4 38/48] Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sascha,

On Fri, 24 Jul 2026 at 11:59, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
...
> +      -ENOENT      A userspace SPI IST buffer was supplied, but there is no SPI
> +                   IST to serialise/unserialise

I do not think -ENOENT can be returned. The branch producing it in
`vgic_v5_get_spi_ist_desc()` needs `!ist->base && userspace_buf`, but
`vgic_v5_validate_ist_attr()` runs first at both call sites and
rejects a zero `spi_ist_addr`, and a VGICv5 VM always has an SPI IST
by the time this attribute is reachable. That leaves the
`userspace_buf` argument without an effect either, so this may be a
code fix rather than a documentation one.

Cheers,
/fuad
