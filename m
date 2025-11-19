Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8D3A79AF;
	Wed, 19 Nov 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567449; cv=none; b=BVBk2lPPYtORW00d9c4fG+4l+ckL8Fhu3b+uxmEet4iA5peoq7QCJGz+6BESJURDq7k4dQ1mLy8MV/SE79+Lz6HVJXSr+D/8uKejfSW9bY6tEdv8ui3h34V6uCxKdKm8Yt5t0Pz3l6ZiQuUg5aRMSsI5HSHrIdbY79790FpBodA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567449; c=relaxed/simple;
	bh=OnWo3e2LVYw1bwnRO0bBgJtQMSDrVhFI5AR6yUV7dZA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUKsLC2EitbfWR7kEfx00NREKx6No8SqGlEJte7omD9g/x1x9wOjhjn+4s1Q2z26u/lTDWAn8C47IlPO/RjJ2DhbK1J1anc9NHr3xYySkF3aOKF17YdGwQUQ0U1Sm94x4mk/bqFKxjqnLaLlfOgZ67EQfKgHmEnVC2owKoT5p4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=wJbIiP6M; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="wJbIiP6M"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3cdySq4RWh2IajHIx8YtiSWymoIFSnIHWX/ALQ3zVFw=;
	b=wJbIiP6Mbx9aIBgM2TlPX2OG0o0XyoHgJqRFizACZkTEgnRMLdcOxKO07PEhdgwzL3aySX9qf
	N0W799g86FQRQEWHGKsdgrT1TC5ZoVmfHvsTwOYdulIvTJ0E+KtgqkBlQRz3goiMaABYQS5q05F
	FLiXhTS5rWORcRXO76RusQg=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dBQs566Chz1vnN7;
	Wed, 19 Nov 2025 23:49:29 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dBQsn6vrqzHnGdq;
	Wed, 19 Nov 2025 23:50:05 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 047E114033F;
	Wed, 19 Nov 2025 23:50:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 19 Nov
 2025 15:50:38 +0000
Date: Wed, 19 Nov 2025 15:50:36 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
CC: <linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <aik@amd.com>, <lukas@wunner.de>, Samuel Ortiz
	<sameo@rivosinc.com>, Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Steven Price
	<steven.price@arm.com>, Bjorn Helgaas <helgaas@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 03/11] coco: guest: arm64: Add support for guest
 initiated TDI bind/unbind
Message-ID: <20251119155036.000026ca@huawei.com>
In-Reply-To: <20251117140007.122062-4-aneesh.kumar@kernel.org>
References: <20251117140007.122062-1-aneesh.kumar@kernel.org>
	<20251117140007.122062-4-aneesh.kumar@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 19:29:59 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> Add RHI for VDEV_SET_TDI_STATE
> 
> Note: This is not part of RHI spec. This is a POC implementation
> and will be later converted to correct interface defined by RHI.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> new file mode 100644
> index 000000000000..6770861629f2
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 ARM Ltd.
> + */
> +
> +#include <linux/pci.h>
> +#include <asm/rsi_cmds.h>
> +
> +#include "rsi-da.h"
> +#include "rhi-da.h"
> +
> +#define PCI_TDISP_MESSAGE_VERSION_10	0x10

Not sure why this define is here.  It sounds generic
and looks ot be the TDISPVersion field content for first
byte of a TDISP message.  If so should be in a PCI header
not here.

> +
> +int cca_device_lock(struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_LOCKED);
> +	if (ret) {
> +		pci_err(pdev, "failed to lock the device (%u)\n", ret);
> +		return -EIO;
Why eat ret?  It might have a useful error value to the caller.
If there is a reason -EIO is special then add a comment here to explain
that.
> +	}
> +	return 0;
> +}
> +
> +int cca_device_unlock(struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_UNLOCKED);
> +	if (ret) {
> +		pci_err(pdev, "failed to unlock the device (%u)\n", ret);
> +		return -EIO;
Same as above.
> +	}
> +	return 0;
> +}

