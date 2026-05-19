Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6B644D6A1;
	Tue, 19 May 2026 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183969; cv=none; b=tgaaDGwCin7sWAGS2W+RF50CuBRQLoBTSLd5mVO1zQGvWxNmSXxfGCFP1vqebnDjfFQU/kWq7RIozxeWM15hjogBhc6rdegjUKoUmEeRSwrAV/E1F/5f8GOun9LZCzZzZVKGp6ShHwWEADOxFbisL7COT2DtgMexzRQYqe0mZuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183969; c=relaxed/simple;
	bh=1q56YkIpKB4JqZI01BH4FGFKZ+NyxhaqIasZhEiOaEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7uDVXNFdb+Cc3sgTrl9Hup3DxQVLIVWzpsJWOF5ewab8HDCF015yBXFO/Dv5BVt4YmTLN1FPijfi9af0UkM6WRQjWuW1Fd63+TIex8A9yhXkXcDkRDPp1/WtSayPp5pZF1DJAACYXjuXRUNkZd1s+CEV3nPE0CzPKdwrjZpFtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+k1LzZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+k1LzZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5585C2BCB3;
	Tue, 19 May 2026 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779183968;
	bh=1q56YkIpKB4JqZI01BH4FGFKZ+NyxhaqIasZhEiOaEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i+k1LzZVosvKUbvNbN5b7ee5QQzUzDzCg7R0bOFvcIBc9zv8fxG1IKt8wpE3vxcK7
	 0Svy7Bv0lPxEA8cGkTJvQPRQX7RHXpAd97lsRPuUc6JCAKiapNDITY1TloGy+RyO8N
	 0fqGHQG9m00DmltF7HavJO7VF5V7knoRs2fXXvGR2vv3Fp7wiSm/2VGQavt95f++Ja
	 VM0ySeFlulqA0TqL18E2k6uQ1IFtr52gBJbxxzYTuc8w6aDxYHL2RLz4w7xsnRTH/s
	 GtE5V8nYWAApzu3U+W2jfOB98Dbn2lxziJKb1HkgsKedebfpcoVlDKuCXLmm2gQnll
	 ofmfQgOwiNHMQ==
Date: Tue, 19 May 2026 10:46:02 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 00/14] coco/TSM: Host-side Arm CCA IDE setup via
 connect/disconnect callbacks
Message-ID: <agwxWlORbd5F9N4N@willie-the-truck>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
 <agsNO9cc7H-b0H8L@willie-the-truck>
 <afca6cdd-f9e3-4b5f-9f70-940c8dbb7a80@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afca6cdd-f9e3-4b5f-9f70-940c8dbb7a80@arm.com>

On Tue, May 19, 2026 at 09:24:07AM +0100, Suzuki K Poulose wrote:
> On 18/05/2026 13:59, Will Deacon wrote:
> > On Mon, Apr 27, 2026 at 12:21:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > >   arch/arm64/include/asm/rmi_cmds.h         |  85 +++
> > >   arch/arm64/include/asm/rmi_smc.h          | 168 +++++
> > 
> > Curious, but why does this stuff have to live in the arch code? Wouldn't
> > it be better off somewhere like drivers/firmware/ or
> > include/linux/arm-rmi.h?
> 
> Good point. RMI interface is only available for arm64 (not in Arm32). That
> said, it is indeed a firmware ! ;-) interface. The APIs are closely
> integrated with the KVM Realm management. If the general consensus is
> to move them under drivers/firmware (like PSCI), we could take that
> approach.

I'd certainly prefer that as it means it's co-located with other firmware
interface code and also means that the arch maintainers don't need to
worry about changes to driver code :p

Will
