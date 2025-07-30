Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28234298CC5;
	Wed, 30 Jul 2025 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884850; cv=none; b=eEoveVj5CDVT3/xMUPegLtwXy9Zmy6lnvW7dDjG9l9/09QhjD5JxMad8TVPT9pcF0o/AQ/OZTEh1buYIc7EpVeiKLxKJ6KJYKfFlvdVJCyzwl0yNUVaQ0DJ4/7fK10+fHkXE0XCe2FSdsjaoNiXwVn2vf0WZXXJKzvxvwU7trYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884850; c=relaxed/simple;
	bh=OC2hkwkmQt+BEIG7nddMlw/yxb8yvDrBW/4fqMhEF+Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHFZApUG3/6zjyRY/CuIx3QDj/ZVUR6+/Q7Px7oEA1aHtD0B97lIl23nC3Ze1rJv/fAiQ3sreZazI7XiW+MHrDbH4xuSmWItUUDlKEyApI2NjEa6PK3S0cUuA/k06LQLpBGilS+HT9I79EBRWS7YmchrsylbsNTbHcuz9oOH5A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zj4CHx74; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zj4CHx74"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3/g83TqD8GB6t3kK/eejQZgZ15j6ZVUNu4RBa9h8Mog=;
	b=zj4CHx74nz6HvZWV/BwdpVOWJXryTVOZaGNY+ENV3ZyDS8OgjZmYE+6NATH4UVWX0dChit03l
	P/FNgiNrfkqBinmqX1eR2GvhJyAtsSet9LFeaou4fFbLqvjKj+PuJQlDLRypRQR8TzK/r2vNfp7
	jwEnXUv7iWaf7PRPakXUzYc=
Received: from frasgout.his.huawei.com (unknown [172.18.146.36])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4bsZ0r5CCBz1vp3V;
	Wed, 30 Jul 2025 22:12:28 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bsZ0P0Btbz6L4yk;
	Wed, 30 Jul 2025 22:12:05 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E4B271401DC;
	Wed, 30 Jul 2025 22:14:00 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Jul
 2025 16:13:59 +0200
Date: Wed, 30 Jul 2025 15:13:58 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
CC: <linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <aik@amd.com>,
	<lukas@wunner.de>, Samuel Ortiz <sameo@rivosinc.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Suzuki K
 Poulose" <Suzuki.Poulose@arm.com>, Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 21/38] coco: host: arm64: Add support for virtual
 device communication
Message-ID: <20250730151358.00003f84@huawei.com>
In-Reply-To: <20250728135216.48084-22-aneesh.kumar@kernel.org>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
	<20250728135216.48084-22-aneesh.kumar@kernel.org>
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
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 28 Jul 2025 19:21:58 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> Add support for vdev_communicate with RMM.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

One minor comment.

> diff --git a/drivers/virt/coco/arm-cca-host/rmm-da.c b/drivers/virt/coco/arm-cca-host/rmm-da.c
> index 41314db1d568..8635f361bbe8 100644
> --- a/drivers/virt/coco/arm-cca-host/rmm-da.c
> +++ b/drivers/virt/coco/arm-cca-host/rmm-da.c
> @@ -207,8 +207,14 @@ static int __do_dev_communicate(int type, struct pci_tsm *tsm)

Can type parameter be an enum so we can see all cases are covered?

>  	if (type == PDEV_COMMUNICATE)
>  		ret = rmi_pdev_communicate(virt_to_phys(dsc_pf0->rmm_pdev),
>  					   virt_to_phys(comm_data->io_params));
> -	else
> -		ret = RMI_ERROR_INPUT;
> +	else {
> +		struct cca_host_tdi *host_tdi = container_of(tsm->tdi, struct cca_host_tdi, tdi);
> +
> +		ret = rmi_vdev_communicate(virt_to_phys(dsc_pf0->rmm_pdev),
> +					   virt_to_phys(host_tdi->rmm_vdev),
> +					   virt_to_phys(comm_data->io_params));
> +	}

