Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A274388847
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769688955; cv=none; b=UjfxJ2bm/rhPK6780nnQffMzbeB4+nvpDfua4CJWm+vVQoCEKvt7cRhHJNRnM4lTO/kerS8BT15zw+YNC+uUUmyhAqpBX3I7IFPTqP89hURVg42fJWx6jRwuPwefEvKQwA7RYiiI23RzL59fIhn7aDaqoCN9PngxwY63P5A3x0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769688955; c=relaxed/simple;
	bh=0IK+DRm/Yda57JCyxXKFwl4KjzuOyT1Kblfcrg+u0bU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvqOno5uYwOs3vneq7yWLfChNrIeR/2JYa0SVpDRhOBVPHEVrm3PmZqHwhHv3qmjAkVcJ/dtw3yfBe0YY8a5JAeaBCSi7krPIw6kq4DIF3qCxB9gpH4Wqs60GFZKcrYXeirX6hkIM/G9eP4IRrAdESSTul2dZPROGYkP44f/LsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=prWDpijG; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="prWDpijG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OznORozYizQxwH0YPp/AAs48x/3QH3/xBBmeqZor+bQ=;
	b=prWDpijG40MZmkg1lzmAGJw6xmt4IAKoEXYw3AUU90gjbb0oBm/bMqiWzRbjhgrO13AxqgaKN
	gal8bbTwofUWrwhXvRnZJ0Eh7S4I+oWj6h7757vNn+INwVKhBzTMVX0EqJNiGFFenjRxjbGw0+N
	d8fUrJVvIH2H/VC5BQ0ym0o=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f1yhm551Qz1P7P4;
	Thu, 29 Jan 2026 20:13:12 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f1ykf1dmTzHnGjf;
	Thu, 29 Jan 2026 20:14:50 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id AA4B940569;
	Thu, 29 Jan 2026 20:15:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 29 Jan
 2026 12:15:35 +0000
Date: Thu, 29 Jan 2026 12:15:34 +0000
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
Subject: Re: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Message-ID: <20260129121534.00001133@huawei.com>
In-Reply-To: <20260128175919.3828384-11-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	<20260128175919.3828384-11-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Wed, 28 Jan 2026 18:01:54 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> As part of booting the system and initialising KVM, create and
> populate a mask of the implemented PPIs. This mask allows future PPI
> operations (such as save/restore or state, or syncing back into the
> shadow state) to only consider PPIs that are actually implemented on
> the host.
> 
> The set of implemented virtual PPIs matches the set of implemented
> physical PPIs for a GICv5 host. Therefore, this mask represents all
> PPIs that could ever by used by a GICv5-based guest on a specific
> host.
> 
> Only architected PPIs are currently supported in KVM with
> GICv5. Moreover, as KVM only supports a subset of all possible PPIS
> (Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
> present. The timers are always assumed to be present; if we have KVM
> we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
> have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
> always assumed to be present.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
