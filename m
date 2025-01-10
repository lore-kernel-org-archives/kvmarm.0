Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6741B4248;
	Fri, 10 Jan 2025 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736514716; cv=none; b=EW+CWo9ih/mtoe3upJwNRZHFLQLXt/WgrF4BeWSOCNDcU6cGpDO4YzbJCTBEZtfiok++1yzsy5w1xwBgr4Cx7aR+v2YSsrUWspXRzCzwAzP5YB3T+0ztE8xwvgGJticliFpEaQAKPPUJPBqJC/2i9xZhqeeTitpBhIAJJ4Ao6OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736514716; c=relaxed/simple;
	bh=6EBV6hp9Rcik5m73fjwAMERnfGjE8Ksw4cnz7lzBk4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVlHn2CIVqnrBIzR7uCT6Etuf9iXJrrI+emQc7xVzTIc19bj5vr9T70Tdfoj5OC7VfocoDrqUFyJ6i4K9JJ/YRRZgYlQSNpANTdmh4ButP4s6KRsf2nvhNllQ+QHuZXLEjIEgLQZMgG1/TYa5IRekiGlR5PKjX7IjMzU08uqpzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C32C4CED6;
	Fri, 10 Jan 2025 13:11:53 +0000 (UTC)
Date: Fri, 10 Jan 2025 13:11:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/7] arm64: Update the values to binary from hex
Message-ID: <Z4Ecl83NmnBS39ly@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110110023.2963795-2-aneesh.kumar@kernel.org>

On Fri, Jan 10, 2025 at 04:30:17PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This matches the ARM ARM representation. No functional change in this
> patch.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Fine by me if it's easier to compare with the Arm ARM.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
