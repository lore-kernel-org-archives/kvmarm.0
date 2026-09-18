Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD663CC33C;
	Fri, 18 Sep 2026 06:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789711651; cv=none; b=YzU+h3yStjZcHjKp+jrgdWNtfuGVpJERxof0n2PUaOqcZ5HwiuY2Zd0r+tcicxesNmyDV8p48WfE9fcWfhxffBKrnHYQLwi2h/kqaUufrEEkrsMESegLdyys2+9qTNdYqYP/RgEFA+JR2xWGQjNAigZnxeccAtbXiKh6lfwNpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789711651; c=relaxed/simple;
	bh=Fn6rADDGdB42fgFMk2BH+v/fIX9Rf7QfewJfhr7z/C8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ntHY0+ky0rvn3fg4YMFF9/taXuJxgtH3hdMtsnb8acFoiMRl5nvmY79ey1mkensxPa7XqNfNGn1ov0XIWREzyL1vhGtwTcfBd7OVckISM7FjprA05B0n/l33Va+hmJNWjybsCLVDCxzMldvv9L9r0Sq4NdbwMZhFX2KI0OLkiM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4WFQ/8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4WFQ/8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26481F00893;
	Fri, 18 Sep 2026 06:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789711648;
	bh=rwSgmxUrtbpCmxPEYK9er5gynnTViPyV6I3RqSz3ERI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h4WFQ/8Wc/jggR8sKMBzi2Zlht6du789DaDJ0xTGa3JZxxXMy3ltKR660bjxlErF1
	 FT3+cxLFUPnHHaKuFhc++j4Z8W+41fqBWqnj+1PY3zM/0Oh13Q+kd44C9AHaB9B7Js
	 COpd1XPqwmy3nelnzVqVVOVLWvRdF6WcrA/ZQHy4UdIUXA/7QZLnFcKZPzAVTgqYLy
	 UEvNgLl/qu6IGBTHfLvqNRg7x1W8+0ImKiTUDfRJsRQe6fR2Uc8kv7O9tytP0pQRTu
	 3BrOT1anVyp1KVv1s4Gam0IwYcCAh2bwKD5Xyr3XUGsM73cIzWpMqH+zhQ4F78TITo
	 CTSF7QWrP/pgQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ankit Agrawal <ankita@nvidia.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH v5 11/15] coco: host: arm64: Connect RMM pdev streams
 for IDE devices
In-Reply-To: <SAWPR12MB9992670293875EF547CA440A18B0872@SAWPR12MB999267.namprd12.prod.outlook.com>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
 <20260910140509.868402-12-aneesh.kumar@kernel.org>
 <SAWPR12MB9992670293875EF547CA440A18B0872@SAWPR12MB999267.namprd12.prod.outlook.com>
Date: Fri, 18 Sep 2026 11:37:20 +0530
Message-ID: <yq5aa4pf149z.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Ankit Agrawal <ankita@nvidia.com> writes:

> Hi Aneesh
>
> As I read it, the address ranges handed to RMM in this patch are captured
> once and at the point cca_tsm_connect() runs. That becomes the address
> range RMM has on record for the pdev/stream going forward.
>
> So a couple of questions on that..
> 1.  Is connect -> {driver probe / vfio-pci bind } the intended
>      sequence or is that ordering left entirely to userspace/VMM policy?
>

We can tsm connect the device even while its driver is bound.

> 2. Are the resources/BARs captured at connect time assumed to be
>     fixed for the lifetime of the PDEV? If a PCI rescan (or resource
>     reassignment such as pci=realloc, a hotplug re-enumeration
>     happens after connect, is that expected to be rejected/blocked?


IIUC, a normal rescan neither rereads nor relocates an already known and
assigned BAR? To discover an externally changed BAR, the device would
normally need to be removed before rescanning. Device removal reaches
pci_destroy_dev(), which calls pci_tsm_destroy() -> pci_tsm_disconnect()


-aneesh
