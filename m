Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10AD42315D
	for <kvmarm@lists.linux.dev>; Fri,  6 Feb 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770403022; cv=none; b=lbaw9RfPIOSrEJ7wxTE8CmJ3uqWlGMG4TEaFCnCA0hD7QF7qhgKm+lWws57m9XbtXgVh56uvu8qox+nN2X5aI0dftPv81xciQV4iwfUX190NuT5xzmNjH0W5UuckguAEFdeJ3QqI2sI9hGFUT0B5cebVbWb8k7i1EjgjZ61+3DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770403022; c=relaxed/simple;
	bh=CehQn6ShgSVIZOBhGRqrC5UlJXuOMh3G+/j9hX2CJWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3JD5l30A8un2Nafj/Ym3um8A5ljHStj1PI0hHnCnmwNizgfXMiywcbmuWtcI0g+BzwpxJ7Tm0fxmqTmh22oMM/M1TSkdC+1R/wzsRqDaXTgFzVgH3A6q2ngIjBgDHZFwCnstSf7V6qlX+rqY0Wx1ukCf4dP+EgCygyIEpXvlV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B738E339;
	Fri,  6 Feb 2026 10:36:54 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 763D53F632;
	Fri,  6 Feb 2026 10:36:58 -0800 (PST)
Date: Fri, 6 Feb 2026 18:36:52 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 1/7] arm64: Kconfig: add support for LSUI
Message-ID: <aYY0xOdUxn39ZPZh@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-2-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121190622.2218669-2-yeoreum.yun@arm.com>

On Wed, Jan 21, 2026 at 07:06:16PM +0000, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
> 
> Add Kconfig option entry for FEAT_LSUI.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

In general we should move the Kconfig addition last for bisectability,
unless all the other patches introduced are ok on their own.

-- 
Catalin
