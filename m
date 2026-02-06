Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9271335F8D9
	for <kvmarm@lists.linux.dev>; Fri,  6 Feb 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402961; cv=none; b=JG43jDTIJ9P5+u79UNkmqrEjVxzskbekWJv1yncyuV+3s0KXWx2FKL1UDX6GQrdCdClsnNVKpLSz5o2v7iXRNwddSf3LMM3A7u/TTintmp7foxUUbMQMJpxiwtBfeC2hteUzdx0s0PtxpqzzF8fQi085XAUlBYnSAlPdtkM0ETQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402961; c=relaxed/simple;
	bh=fAOnpi1k96zhhNFrBl7HalgkZEIqUwurYuGb5lXndXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAkFGPC3DS7x6nr53JXjrbhz0QJWZmOcf+2z1biOZA2nK5uJ7dlqyTZkf8egUquq0H2RyzT7pIemG9kjbRVBDyHJOMj2apcyKdAW0mFF71Qv8M6mLKkS6gRSKAUGgDVcR0OAhBpZbs/gtP8tfNAI2n6FoxVrS/X1lsipRUDm9Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA525339;
	Fri,  6 Feb 2026 10:35:54 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E124E3F632;
	Fri,  6 Feb 2026 10:35:57 -0800 (PST)
Date: Fri, 6 Feb 2026 18:35:51 +0000
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
Subject: Re: [PATCH v12 0/7] support FEAT_LSUI
Message-ID: <aYY0h1DtvDpEyekd@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <aYWuqTqM5MvudI5V@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYWuqTqM5MvudI5V@e129823.arm.com>

On Fri, Feb 06, 2026 at 09:04:41AM +0000, Yeoreum Yun wrote:
> Gentle ping in case of forgotten.

Not forgotten but lower priority given that the merging window is about
to open this Sunday. The LSUI series is now aimed at the next cycle.

-- 
Catalin
