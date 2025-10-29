Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21582320A0F;
	Wed, 29 Oct 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762889; cv=none; b=YMOjBFvmrEfR3X0D79+UHlWfJaIBa9Sq8B4/gZVim4vNV4ezdxTE/X/iVw1um8NX6eO8/8bjSW1VDrRyhyfBKm+Ljm9+qCGEtQ/ufMqb8Qu+82lres26qqXpj3e1wNlgVoSsEQU6FYWkE1dixsOECAdLbiDsfGdOGkZ7MdggNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762889; c=relaxed/simple;
	bh=ZeT7Owxzy+wHd5v/L+u3VJAUyhrgBzMBG6B/UwT0TKg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YG56cCZKnPgyLFyz9zhh2jcPgQ9XmLNtVsQWDzKg5J3c+J7oiPCc8oKEzJJEeRKZEvDSNTIo7jDs7XEFTcDF3v8KCZAMF2/cwasRPp8tcV9XVwQvY25k4FqVIFZF9qcQhBMqC1pGRTGwcFOJiCNYFf0sYLg4yHe3X5wMcYhGHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zGNlhVLI; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zGNlhVLI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rPA5zYsG/tWVAFiEKuWztdoSVMBIPULj9uPWMdi3d2E=;
	b=zGNlhVLIf/x8aC6ttfUj5NAB+UYv4xQo1T71neC0+wg1M8fTzTFLyRKQCeG7pPD1YE7Umbwte
	f3Ey0RZiAh4RjFzNftjLoWX7HYoNKVcplGStCS9VHGywzzeMWvWkh4upvZ25lp7HkwN0G97sCst
	l3iWC+Hl5KeRHiPlcfQ7Kqo=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cxbWG5FCpz1P7HW;
	Thu, 30 Oct 2025 02:34:34 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cxbVL4CqzzHnGdq;
	Wed, 29 Oct 2025 18:33:46 +0000 (UTC)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 95B22140276;
	Thu, 30 Oct 2025 02:34:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Oct
 2025 18:34:38 +0000
Date: Wed, 29 Oct 2025 18:34:37 +0000
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
Subject: Re: [PATCH RESEND v2 07/12] coco: host: arm64: Add helper to stop
 and tear down an RMM pdev
Message-ID: <20251029183437.0000661f@huawei.com>
In-Reply-To: <20251027095602.1154418-8-aneesh.kumar@kernel.org>
References: <20251027095602.1154418-1-aneesh.kumar@kernel.org>
	<20251027095602.1154418-8-aneesh.kumar@kernel.org>
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
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 27 Oct 2025 15:25:57 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

Repeat the main bit of the title here.

> - describe the RMI_PDEV_STOP/RMI_PDEV_DESTROY SMC IDs and provide
>   wrappers in rmi_cmds.h
> - implement pdev_stop_and_destroy() so the host driver stops the pdev,
>   waits for it to reach RMI_PDEV_STOPPED, destroys it, frees auxiliary
>   granules, and drops the delegated page
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


