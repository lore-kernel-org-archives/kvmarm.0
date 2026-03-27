Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDCD29ACDB
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639323; cv=none; b=a869eqtFiu6Y+H6cmYC34q9fHpIDlY9RVUzHGu+iT9o3vxw09iMhgXNaTSPN1sUpsQ2kEoygVBsmFBHRSG6oCi4HjDH6E8jTa575QTyzUfdAweMR0ojbOCycdgY93JYbbYww57AZu0P1Ci+Zxp0tZRbRlEXq0zIfYOxpFF2YH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639323; c=relaxed/simple;
	bh=UhHIiHkeoVIvecNWT/vmtedUFGAdoBTec9LU2lfLxcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmKSz74IkS4TQ1Rw3i2EeKMPsQZcVHOSh1uWouhcUlTyIRH3zENO5diiWFabGGi4p8fjnjmV5Mn64eHBr9/voty51MUPLVh5mKeLmsEejw+LaGsPTvTuIuOrc0LSsxAnfWlbO6WaxWdAlkjdLQ1hn9N5rxeUgK0Yq0S8fktzV+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BSnlTV+l; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BSnlTV+l"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAE993D4F;
	Fri, 27 Mar 2026 12:21:55 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D66C3F99C;
	Fri, 27 Mar 2026 12:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774639321; bh=UhHIiHkeoVIvecNWT/vmtedUFGAdoBTec9LU2lfLxcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSnlTV+l02riQc7GahKRFF6tlfxPO76vNWLQM5w0qs4fOIS5u/POTMvyOicvUCtAv
	 BsMYPzLyvqdvr/x1+k5mEgBeWGSRhXkTGVYrNiqdnKEduj3IEHxgd8wyu7vq3eIfFy
	 8d6o4fkYI0owsku7gDbLq00HCbhkFksw2Dnx73BM=
Date: Fri, 27 Mar 2026 19:21:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, maz@kernel.org, oupton@kernel.org,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, broonie@kernel.org,
	ardb@kernel.org, suzuki.poulose@arm.com, lpieralisi@kernel.org,
	joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v17 0/8] support FEAT_LSUI
Message-ID: <177463928205.2670874.13517032507439052873.b4-ty@arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314175133.1084528-1-yeoreum.yun@arm.com>

On Sat, 14 Mar 2026 17:51:25 +0000, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
> 
> This patchset support FEAT_LSUI and applies it mainly in
> futex atomic operation and others.
> 
> [...]

Applied to arm64 (for-next/feat_lsui), thanks!

[6/8] arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
      (commit e223258ed8a6)

-- 
Catalin
