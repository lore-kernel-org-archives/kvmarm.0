Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A9B1DE4FB;
	Tue, 23 Jun 2026 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782174013; cv=none; b=reHFrT9QRoLjgAW13BKTXxg7JFaY2sGzurJo4U0l/0ExAzB7dbAMnCEwn4CWu3sWDsQCOuA3upELlahescFAhUoQGL+GRTCiXgsiaUgdFE1ewMmbL09/WrFdkE6+7qwmwXoPacYXXKyXD0Db1QTg+0QBgKCvRtkeMDi1AKJ7lLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782174013; c=relaxed/simple;
	bh=dYMrvQ7QWulmrVl1eu6L5LscUtsG+z/1nPqrW9/6UcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLis737AQxTBQ02tOQwTpi+5oRhYRBRgbAHM4mAblbOgQk1W7OOgdtYmvV7RmxQtW5MFV7NhNhskcG62Xi4KdtQNI6l6r024rTLBg11nws6bnDIFUntTWpWFXSKy9CUo59Xo68ovDmHCr8sZvG7b8dqqz1JGis/gOFZulvBOi4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ei9u1Gkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ei9u1Gkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B54E1F000E9;
	Tue, 23 Jun 2026 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782174012;
	bh=BDKUVID7qw6T4mp18P6/ELgU0/lKW+UBMNBhyLpyrEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ei9u1GkzJ84WMGMXM2wTDi3t2Wr8NPXEkmG+WJhM2LwZSiZesTnOlQUBNSvABzMOt
	 PL1bFvxpcEDkHqf7c9Yvv4jxf62tQshvmaB1xz42UA/TLGivZU5BvZmtR+gsdWjjUI
	 LzwQNlqkw89gXB5SBaSD8fJk40FmW5Mn53HH8CmDTLzRwdmo4l/NN8+1ZEbTW1VXRI
	 EEYfYTTZ2MNDzBLorlsfbXg+Q6P2wxwMUFbjXB5QWFGAnWhwigy5VmIArvdYu/J0dn
	 yETSrn9w9g1aM2SA3rJus8yjDi9TGGwBYBtVe7TxgiYeO3FWfLOjKsLGjqQkzseMqA
	 Ry/RSuqWXcOwA==
Date: Mon, 22 Jun 2026 17:20:11 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Fix and test MMIO sign-extending loads
Message-ID: <ajnRO9oMrVCXQT9t@kernel.org>
References: <20260622190701.2039766-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622190701.2039766-1-fuad.tabba@linux.dev>

On Mon, Jun 22, 2026 at 08:06:59PM +0100, Fuad Tabba wrote:
> Hi folks,
> 
> A sign-extending load (LDRSB/LDRSH/LDRSW) from emulated MMIO returns a
> zero-extended value rather than the sign-extended one the architecture
> requires; vcpu_data_host_to_guest() strips the sign bits when it masks
> the data to the access width.
> 
> If my git archeology is right, the masking dates to 2014 (b30070862edbd,
> big-endian support) and has been wrong ever since, but sign-extending
> loads from device memory are rare enough that nobody hit it. Patch 1
> fixes it; patch 2 adds a selftest so it doesn't regress.
> 
> Cheers,
> /fuad
> 
> Fuad Tabba (2):
>   KVM: arm64: Fix sign-extension of MMIO loads
>   KVM: arm64: selftests: Add MMIO sign-extending load test

For the oddball guest :)

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
