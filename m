Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6ECD3B38AF
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569671; cv=none; b=toUdxG5DqqCR+4PahOP+2P4Q2m4HuXNTig+VdIdwYxGXCn/5foSbdJ0Xv3eDgHFTuAYRa2a1xqTP0a5eiYUS5eWouvjKgqXY4x6CRNEO3btSnUwHKLXaiGA3EHnyCtMU7I2tN8o3R7GBcQlQgqCrRwXk3irzQUDM8eEeDGmPfBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569671; c=relaxed/simple;
	bh=YCxm5IsUZWkOVmsnnCElZfL8KDjU6K9uk5Pr3gZX1nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIjvkhKUe7XCEE0Z+5Nkp2lDvl68USy1XSyLI3Tl2wuWb0P8EjuKZT5Mk+BaxTwOigsS+LRdWLHEQeHFxuimp+t31nVBhWt9Toobicot7Qxz51kQr2I9MfxxOkUlzJ6udIj3tR+UNWAJMlUfS/XeSALNQEGZ4socHfYVxeCQgmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VVPYMBNy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VVPYMBNy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44D8A16F2;
	Tue,  7 Apr 2026 06:47:43 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEB003F7D8;
	Tue,  7 Apr 2026 06:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775569669; bh=YCxm5IsUZWkOVmsnnCElZfL8KDjU6K9uk5Pr3gZX1nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVPYMBNyFaH6onWlNAwGCgXqVZGQkTcoMTSFGWNL93JMN3nv3BLkZePnFnacj6De6
	 jCgyNxQVNTeX+ACgzoSM21XwGim9Q6AvQrjUQfyJ5TKZm5oaT1z/rI/wZROF8uDTZy
	 NzlrzHYBnkils0WuAfTTUSw1Dh9VbZRQ9Ut2ROTM=
Date: Tue, 7 Apr 2026 14:47:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: clear_page[s] using memset
Message-ID: <adULAT2xus5z3HdQ@arm.com>
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
 <ac7YJPo4Np2zxxEp@arm.com>
 <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>

On Tue, Apr 07, 2026 at 11:25:55AM +0200, Linus Walleij wrote:
> Quoting my own commit message hehe:
> 
> > No performance regressions can be seen, the fastpath
> > benchmarks differences are in the noise.
> 
> This was tested on hardware with Ryan Robert's fastpath tool.

BTW, have you tried the perf bench mmap test again with the new
clear_page? Both with single page and multiple pages scenarios. And
ideally on more than one platform.

Will pointed out (in a private chat) that current clear_page() uses
non-temporal stores while memset() doesn't. It may not make any
difference in practice but it would be good to have some numbers.

-- 
Catalin
