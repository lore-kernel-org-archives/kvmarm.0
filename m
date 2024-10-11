Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A01D21859A;
	Fri, 11 Oct 2024 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652827; cv=none; b=HP+0o4yRvlNHY4h+agWJ+TPvPKzzwd146FoAmgaMVJeR01tvSTp/CfsAjAPp5ZAmC3FbFh8TvAUCcJI2mzluuD4F3iy+8vj6MjZ0XDukyVMruy/sn7zkXxVHiikEPRLQXbpxQYdlNAcdAM63XbhF8+U5v4TltnOLh0AIHF+7RxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652827; c=relaxed/simple;
	bh=2jxyRGQEUaM24Td33Kfu4OO2Gf1opNBGn5+F1Nrr1DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcMJV58VxHJt1SzbtMgha62xEX/7TIWB3LOFC3uGr5A9HPBNsAJNirQ/LfSzUO7RhMd3Us34d8HNow/a3CX++tcL3cONcPpte+8TycUmSIO7Wd/X7hPTStKmm2/UXdd+29cKckxFmdwOezfbaBL7LLhvWWeSc0X7PGr/s4wetwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1B1C4CEC3;
	Fri, 11 Oct 2024 13:20:23 +0000 (UTC)
Date: Fri, 11 Oct 2024 14:20:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
Message-ID: <ZwkmFWiSeULx_xgn@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-6-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004144307.66199-6-steven.price@arm.com>

On Fri, Oct 04, 2024 at 03:43:00PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Instead of marking every MMIO as shared, check if the given region is
> "Protected" and apply the permissions accordingly.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
