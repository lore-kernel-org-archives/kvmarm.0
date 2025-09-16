Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5EE188734;
	Tue, 16 Sep 2025 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758027208; cv=none; b=iz62DrN/hScUG5IFIN5z+SyIp0RLRcWIm+a+HmtQArvqi7Yv3CrNi/+YFMeBUoGSGqqtJjFsneyfZErVJXHdD6/G7wQtFSI2AIDCtTFhE+CNHr2VO6K6GsTvPde7KpDfGmG2mdy/Z4LF/a3I8SOtXzcWveg+b7JmEaQIbJ1bedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758027208; c=relaxed/simple;
	bh=iPNDmcVXL8IyJ05UuMGvvqQIJxC1D4p+fdlLgyb/Le4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHB/Lmu/+tQzWn7nviVEiZ1WrC42tK/yYf2cDcUkzm+L9x6dSOydag1LQOkh0pBZOznbjSan2sJj3Q1JsHlpiacx1znkAvv/GTni+2sHyGMte1McxaBnh0Qr8emp49HqqEeEl3yGMhIGbX/3wjDGCuOv12bYL7+qycxz9jXfhZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF14C4CEEB;
	Tue, 16 Sep 2025 12:53:25 +0000 (UTC)
Date: Tue, 16 Sep 2025 13:53:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMldwgxOh3VjuSLC@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMiUX0O3MpdRyb3f@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMiUX0O3MpdRyb3f@e129823.arm.com>

On Mon, Sep 15, 2025 at 11:34:07PM +0100, Yeoreum Yun wrote:
> with selftest's futex testcase, I've tested.
> But Since there is no test for each operation even in LTP,
> I tested it with additional test from me.

As a separate series, you may improve the futex kselftest to cover all
the cases.

-- 
Catalin
