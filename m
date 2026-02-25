Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC529393DCD
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018684; cv=none; b=jl7vXzzurRHcz4EnREHud8XOvbos8UBUm2XNcGq94vyATfNhLq5WAntOIWPY2V7a+x43EzdD4tQqZR9TngcQl6NuqM1tXfaGQezFLz2NJ4cq9mXjP7Cr/x6P6lbfpn8ZVUfcnOx6PcoBQ2ALxZSwj61yR2QRCtfu0SXU01vgkU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018684; c=relaxed/simple;
	bh=QlV+xcyrwuc1TQlXS0E7xPVfI8CVsv33YrGFcdeR10U=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gysh6Ct2wPJT7xh0Hrxj0BDMGxn34frbIl4QWzy2nrmOMfbAmYoRdNlC403T47T4bwcx3YIkmoazmQRa9BIJPxzOeTyN1lOswALZavNvDxbFG2dlXig8xM5p5GaWjeMYuGzMtuJSwEwO8ShZtcQY3f7uvqJ3JoW21cTvGPjAplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fLXKN0gPSzHnGkN;
	Wed, 25 Feb 2026 19:23:52 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id DE33140086;
	Wed, 25 Feb 2026 19:24:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Feb
 2026 11:24:33 +0000
Date: Wed, 25 Feb 2026 11:24:31 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	"Oliver Upton" <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Deduplicate ASID retrieval code
Message-ID: <20260225112431.000051f1@huawei.com>
In-Reply-To: <20260225104718.14209-1-maz@kernel.org>
References: <20260225104718.14209-1-maz@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Wed, 25 Feb 2026 10:47:18 +0000
Marc Zyngier <maz@kernel.org> wrote:

> We currently have three versions of the ASID retrieval code, one
> in the S1 walker, and two in the VNCR handling (although the last
> two are limited to the EL2&0 transltion regime).
> 
> Make this code common, and take this opportunity to also simplify
> the code a bit while switching over to the TTBRx_EL1_ASID macro.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Does what it says on the tin.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
