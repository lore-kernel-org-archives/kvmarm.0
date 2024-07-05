Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BEA16EC09
	for <kvmarm@lists.linux.dev>; Fri,  5 Jul 2024 17:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199123; cv=none; b=OsZWkSYgBjX1fBpT4+1MtvJ4tqbkcxtj1K/U/v0XY65EJItp/9P31/ni2kq0g0Kf8E83/N8K+6cEk9qRy54Q65JXSEvlKWhMa2LAJj0tbc4cd42gYeHpTcBwyJzlOeJewZMyVkpq65zTFmJ9tK+nJ7oDVjjgqS79HfkPRZ/dV8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199123; c=relaxed/simple;
	bh=MKtRMGM/j8nO4KxYLuFEIS5UAUmF3DwCDOQWoeGvid0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2GoChZw7oeJkVdJkeBRsPULL4UyWpIOraL+oLwZXoh6ykv5o1O0TEpWDQ4ZGBfpqZ7HLD7aEFED/ai1mVaZL+0FjqSxhBZQhb66xNt63Z8tuREwtKuFt/wHeDym9OB2nOBqgrxX4rUQyivoXbqM6I6ekkMPdCkt+8jsme2vfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D6061477;
	Fri,  5 Jul 2024 10:05:46 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4654E3F762;
	Fri,  5 Jul 2024 10:05:18 -0700 (PDT)
Date: Fri, 5 Jul 2024 18:05:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, szabolcs.nagy@arm.com,
	tglx@linutronix.de, will@kernel.org, x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 22/29] arm64: add Permission Overlay Extension Kconfig
Message-ID: <ZognzFiCD4lSSEyO@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-23-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503130147.1154804-23-joey.gouly@arm.com>

On Fri, May 03, 2024 at 02:01:40PM +0100, Joey Gouly wrote:
> Now that support for POE and Protection Keys has been implemented, add a
> config to allow users to actually enable it.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
