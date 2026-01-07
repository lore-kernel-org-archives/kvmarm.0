Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19F533A701
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802401; cv=none; b=En/UlfLCAKAYDtN5AyxHD4tV2+Wf2Qk2be2Kqa2E5yJhyfCeGPvYicHYwxXfxQVmJSipa+4ObhB+vk+Ca/5BTFhGvAgNt/Ew9dOj2eQ99Z6Pw6MQlWzZGnVkqPuLWESULpSVyC24nz1s1zW88+JZkW7JxKP6LouQNZ9XVuuhnJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802401; c=relaxed/simple;
	bh=NkzegpdHfjoedUnY83okiK/zwnS60pk4peMXfbe4QUo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tNwVV2oGn4HF7g4m82GCbrAsj1uxIlnUb99Llx5iweDRO2nsAtzE0oI5Q8t0isetKYViEct4cRl5jHv31vGzVFwQypnWs4Wq0NE0GMKWZMERZ/vb7HBQbUm0J70hwsjY9h0FY9yRnSRO+lCf7lYgPdhiNshT73P1Opv5+7TgI2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=RTq+K4Uq; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="RTq+K4Uq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wmClf/DpRm1O0q3u5kTCy3g7sCT/97ATQsJnWVzDbpU=;
	b=RTq+K4UquUAb3nrBVWcz3v69WzNI6BJ3UPJfIlYaXFbArRrdNh7aZ5MC0ZnRfkcnZ8FSAq79i
	4pD/+gjFoDxlb3dLCn6C5tOcjw0qk4k1atljLT8WLioUvKXKxcJZim56RcbZQi5EZmfHbB2izm8
	XUpSs1iw6jA9pOS8C/bme+U=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmY0t6Pp3z1P6jW;
	Thu,  8 Jan 2026 00:10:38 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmY3Z4Pv4zJ4673;
	Thu,  8 Jan 2026 00:12:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1047A4056A;
	Thu,  8 Jan 2026 00:13:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:13:01 +0000
Date: Wed, 7 Jan 2026 16:13:00 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Message-ID: <20260107161300.00003470@huawei.com>
In-Reply-To: <20251219155222.1383109-30-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-30-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:46 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Currently, NV guests are not supported with GICv5. Therefore, make
> sure that FEAT_GCIE is always hidden from such guests.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
