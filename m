Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303C1238C07;
	Mon,  4 Aug 2025 22:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754346405; cv=none; b=vDTKqmlF+eeU8TyNA23im91wTH0Zny6ZdwTiPgbA331ByH8SDfV0ZIU8FJDoufG6IMOFJQRgqYBUd077AI5dpGaYQY3dzkOmxtmO0/a54HIEfrNaY7QwrbH5DyBejxdEPSNKckxMPu921Myl6yOo9M+QMYOOWl7A5eNXyz/YN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754346405; c=relaxed/simple;
	bh=L87N0DhYbV5dpDzEH5tG4mPUL3OpG5ieHRRfrAjELw4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ggOvXacl4RUv5t/fCImncScz3pb67asN+JiA9XNtwjT/6XlayfYFsSoJS6GhHeXSAtxW1qST2OhAFmTOeClF7J0m7zRul3JfGrq+FqN5VKaKP4/qghBSRvFLo9ZiEiYxrAXxCm0OaVYaz3tNDEUuncZBNMvdXsJQeYktpkhSn+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGdvan4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGdvan4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF87C4CEE7;
	Mon,  4 Aug 2025 22:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754346404;
	bh=L87N0DhYbV5dpDzEH5tG4mPUL3OpG5ieHRRfrAjELw4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=bGdvan4Ae0B+GP9jbLjjI280GZIkWK/2N/poET1Lo0jNYaoq2RZahEQIt/LUonvFT
	 Yb//4LXKHw5DUlyFmJgglJw9j8wGWPD9ZVTNROhha6gqLXMw1fgOyo7/8RKRY56EEC
	 njpXhaB+v4KMCyIeIgH2bgayPElYyCIunVxkNhf0qV9iaCdAbmdz3awMKp+Gs+BpCU
	 FQMLIhg4/bitJ8gef2JOmsHn8hCS3+7ED6SqK5JJIQ9mHUcijFNGrhKBK1S4abxeAn
	 u52x7tpHzHsdRdRa44yMEMxChp9lGwECPb/mlFwKg4jh9v8DRmVe5UHs5uQn0UUQDP
	 Ap70vthSluyvg==
Date: Mon, 4 Aug 2025 17:26:43 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 19/38] coco: host: arm64: set_pubkey support
Message-ID: <20250804222643.GA3645706@bhelgaas>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-20-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:56PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Add changes to share the device's public key with the RMM.

> +++ b/drivers/virt/coco/arm-cca-host/rmm-da.c

> +static int pdev_set_public_key(struct pci_tsm *tsm)
> +{
> ...

> +		/*
> +		 * exponent is usally 65537 (size = 24bits) but in rare cases
> +		 * it size can be as large as the modulus

s/it size/size/ or s/it size/its size/ ?
s/usally/usually/
