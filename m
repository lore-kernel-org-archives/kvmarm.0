Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C236BCC2
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802933; cv=none; b=fa63aETosnIg79frFHF4JFI5xJTHHT+/p1IQdckKgVl9fjXnduUZ1tT5bfmvWLsdAKUezQAMQB3R9ZLv/K9JbpxWcsTNZBvU4ymnZg7Hn3e6nqiyJjrjyUh48fu53G2T97GubjhYK4+7kpAr8lnojh7lc9op06rJWV5rYa/ANnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802933; c=relaxed/simple;
	bh=tLxl9sIb3ZFFyAMkX2pgiVXJWCk+uwqY54exwbJe1NU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diytBjXrLQnuDkE+FGIBlm8pktH9cLj9b2KOiRrG++C2+CGrVdh0ZJo93r1YEGDf+EvvXDXUpc7zggouT9TFVgjCxj3jOsrmBEJS4xP9akOR4IQ5HHSQcNKOGp3bXOxdlWzQVYZ7DOgOngOFUMZ1ptY/2N1fSFw+4bt4+38wSPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=uSP1mgVR; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="uSP1mgVR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xadTztksFTVn2im+cWJVadEdaf24OWXXzLmCMbGLiYQ=;
	b=uSP1mgVRHj/kzZz0H4vCQq9XlMlnL+FmkErAnpAs/AI5ghQbDYpaKf3JSj0yYG+yrbQzNAmwW
	0QzGK2CW5s07CmWq8VhqZ5VN+qoWoPS2JRBD4iOh0zSOtXD2OZkj3d/n5NPeu5Vgza0G1hnibJY
	45d7Syw8q/i2CekMc8KCU+M=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmYBx6y0rz1P7Kb;
	Thu,  8 Jan 2026 00:19:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYFZ4vwszHnGfP;
	Thu,  8 Jan 2026 00:21:38 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 222D440086;
	Thu,  8 Jan 2026 00:21:45 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:21:44 +0000
Date: Wed, 7 Jan 2026 16:21:42 +0000
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
Subject: Re: [PATCH v2 32/36] irqchip/gic-v5: Check if impl is virt capable
Message-ID: <20260107162142.00007e3f@huawei.com>
In-Reply-To: <20251219155222.1383109-33-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-33-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:47 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Now that there is support for creating a GICv5-based guest with KVM,
> check that the hardware itself supports virtualisation, skipping the
> setting of struct gic_kvm_info if not.
> 
> Note: If native GICv5 virt is not supported, then nor is
> FEAT_GCIE_LEGACY, so we are able to skip altogether.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
