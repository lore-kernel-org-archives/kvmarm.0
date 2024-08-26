Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA8612DD90;
	Mon, 26 Aug 2024 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666446; cv=none; b=qNkuaMX1aLuCtNJrQ36kpnX7cIouRy++gst9MWpJym86uyzaOIaG6rKU/svtL1Mh7i576LH6YzXtmmnSbO/6NN5CCv3zT9K3++ZkzXkos9kim5FasNrkw/Ri+JccVPXEVDtcLQGRDCGYX0oIh6MSL1H7tRlJxT3RerSGLcJQcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666446; c=relaxed/simple;
	bh=S/E1TA3kX03JbzeVmejApAtME6MDHbXvPr9ScrspqDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emXKdj1wZkm+Snrlqny/X01p5UzF3f8WtgkX9GVIRGBK+5NfwQ8ciw+MIGOgLLkw+M6gxycpB7cNWlg8EM9Ub/fZrg0k9+BncwUiEaq2PcbErF2UNjOY2zq6Q2JnbxCIGo9HqBfqNSUqHFYfx0xkvgqgVmECBJjJ12tCIP6zekw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3663FC51403;
	Mon, 26 Aug 2024 10:00:42 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:00:50 +0300
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 01/19] arm64: mm: Add top-level dispatcher for
 internal mem_encrypt API
Message-ID: <ZsxSUnl4qRhwOKD-@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-2-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-2-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:06PM +0100, Steven Price wrote:
> From: Will Deacon <will@kernel.org>
> 
> Implementing the internal mem_encrypt API for arm64 depends entirely on
> the Confidential Computing environment in which the kernel is running.
> 
> Introduce a simple dispatcher so that backend hooks can be registered
> depending upon the environment in which the kernel finds itself.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
