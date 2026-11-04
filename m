Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809789;
	b=i2Z3MPMZDxezf5G1WBc9Dn99FkW0rL/KWK/6TflnyEk2E2zHqiok0X4GMEhhCem5Zoph
	 IX2aaJM9jq8vehDYG7hy8ei+OIH0tWfc/5WTVKyxV76iFDcWHJRBtMpHTFz8WDncZALUr
	 RWW2IQS/0wnQpn2nvdDNkjKOPOyDhln75R3oNckih21y7rtQoFy/EuIVotCUMKlEiVNYp
	 fEKMDkMC1sf4BBQ18wfBo01jFb1FZfDbBujmqb53KkJgaaQwlFf8g4PwIELMH/FCLCiMx
	 5l01/7agc/QvzUS3Qg0lNe5KJ8fMjxpqVOw6whiwoIZ1Y6s+fy4Mmic5rzVptaBVOKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809789;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=A+c88oY+OM1KTWwYSavDme1bSrIZkOp07+hlEpWVcCw=;
	b=hWL5xwJmuyQXKEuaidLznGKbO00FNQx/Chs+gYi8F3nAE/uPyqCxt01c2Ycb/+nnYbZe
	 OWLM7F+Wf4lP05IzRvLUCLdM93q47Y6QtvN66FnP86BeZ9DTiRnXd2DU4oXorzMiwakXg
	 yRXSx2zACOsgGq5J7Ivxwdidb5qsdF+6BllcAx5o2aD3P20Y64SmHMRr6WYP1Dbi7BGYD
	 W11d9dfkSTjexOd/3DgDmjjCmNmcJ4uw6NAGZK3wDllYhtON/in6eOP0GtrP9PhSQLtVT
	 bv3h5xF0HN+TwfcVRaDZoKcCVV+2/YsbSqSzsZ5f/u0v+d+ZEUBWf2Yrv7XiJiIxobg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="qmN/XCMN";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743A1606A326;
	Wed,  4 Nov 2026 16:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 743A1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qmN/XCMN
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA628169C;
	Wed,  4 Nov 2026 08:29:44 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 378FE3F632;
	Wed,  4 Nov 2026 08:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793809787; bh=yfV7Pr/7oJjyugoqKWkyvS9QCQp5fdkcK+WpMwo/qac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qmN/XCMN+bMq7vL3IroW/zO5c9utj8tVY7h4PeGCnZGzZx6QJb+MVfxfmxpGIFkWs
	 MPGF/7odw2F/vJpAguk557fWflsz7TXTzAaTdWmwif+k4Ga1M/3BXeRPSyJhdDYVVy
	 1rCDBkJOH7eR30KB5XIpAumuo7e8R8w3RhGUWzuw=
Date: Wed, 4 Nov 2026 16:29:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: michael.reeves077@gmail.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Myria Sarvay <myrialsarvay@gmail.com>,
	Yureka Lilian <yureka@cyberchaos.dev>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: Apply existing Apple Silicon CPU
 workarounds to newer CPUs
Message-ID: <autddoQr_lqAS3v-@arm.com>
References: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
 <20261021-apple-m3-m4-kvm-v2-2-04905152cc2a@gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-apple-m3-m4-kvm-v2-2-04905152cc2a@gmail.com>

On Wed, Oct 21, 2026 at 10:53:21AM +1100, Michael Reeves via B4 Relay wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
> 
> Add M3, M3 Pro, M3 Max, base M4, A18 Pro and M5 Pro to apple_cpus
> so they receive the existing PMU trap and broken SEIS workarounds.
> 
> Add these CPUs to has_vgic_v3 so KVM detects TDIR support and can
> trap guest DIR accesses without trapping all common registers.
> 
> Co-developed-by: Yureka Lilian <yureka@cyberchaos.dev>
> Signed-off-by: Yureka Lilian <yureka@cyberchaos.dev>
> Tested-by: Yureka Lilian <yureka@cyberchaos.dev>
> Tested-by: Myria Sarvay <myrialsarvay@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
