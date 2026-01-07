Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634053A5249
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803236; cv=none; b=YqmtSBxH2MHnSNxhiAj+QvUPrWS5elHOPlk41fxIQWI6EZA3WvOj4UY+pKUfGrRa0Dc3faEbX85pplPKeO9mWcg7ek0sNGN3y6tTkA9ydntVS9bfQDO6CPoehT2wPrG2Lhw+Ii8PRsxyI9j4yej8sr2Fx67GxzMfRS88saYiw6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803236; c=relaxed/simple;
	bh=6dJ1XlgVebg+PgDGiZqigrAKHQFbRQJmbQhxzIeIL+I=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KC2nUT7bChoUeXj7nskE3eJaNTJrC6NaveTC0Xr1cb5jdmCBAejtwGUZixJtYZLLkCNognTnl/1+TZCbQohnvSYwO1JGo2pcRQdW7ay4MbnEFVg7iMZsCUk4rJ7aivti9Ri1HJyKEXwIQftL6ZD468SOqC4wKCwgRwGz+oH1Qlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=c4SVkfPh; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="c4SVkfPh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GVIF9KkKAs454Pa94kXvNM5oHQzz5+f7BpY059S8z5c=;
	b=c4SVkfPhvMHNd3Z74MTkXrPGsipJ+svqFYYwJ1hUc4S9+K9mb5LiGZk9B+gWdOHmNJzyoXl0j
	ysPXa+dEKSkl7xNmYD0WhWHegf8Vk+p7LxnOpU40XEMVrixEKEnnzkXCS/K0M81w5bSgdhW3v4N
	3kGZEmxaNoKCCFN5enoJjHg=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmYK372J2z1P7L1;
	Thu,  8 Jan 2026 00:24:39 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYMh52FGzHnGgg;
	Thu,  8 Jan 2026 00:26:56 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2993440565;
	Thu,  8 Jan 2026 00:27:03 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:27:02 +0000
Date: Wed, 7 Jan 2026 16:27:00 +0000
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
Subject: Re: [PATCH v2 34/36] Documentation: KVM: Introduce documentation
 for VGICv5
Message-ID: <20260107162700.00006411@huawei.com>
In-Reply-To: <20251219155222.1383109-35-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-35-sascha.bischoff@arm.com>
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

> Now that it is possible to create a VGICv5 device, provide initial
> documentation for it. At this stage, there is little to document.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Seems fine to me
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
