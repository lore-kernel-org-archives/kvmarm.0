Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712151917F1
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753114553; cv=none; b=vBhh8OLXZHZRlSjVK6SLBVh9jvjcezYAWOgOU7VN0pvdlD6pHdx6VllRtyZlcczx4pzsKtlAecwgxSy59QBQT5XdbtExkzUXmefizY4xET2bdHGooVJKQbP7HWxlkc6JciNieoWG7/xkIJaUuG/w1QZlFTT/NH9LHBR5Agyi9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753114553; c=relaxed/simple;
	bh=96HexAJ8pgw5xnYaIoy2RO1Cl3uPEp0grH7rEZj9CjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvYvLzZYkd482cCF44uvQH0OHrxYpP+9DFylR6McF8xcF1ucOSuOpgjNFVIynqI6PsZw7ZXTDdD0cm/uN62mwIYl8DwoFsfbNVF0IYfHRIzmZXPcgPgWWtw5EdwObAKycY29GEiW62qGiW8P9XgMWhJc846B3xhDTk2jL3HMMWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFB2D153B;
	Mon, 21 Jul 2025 09:15:45 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 351323F66E;
	Mon, 21 Jul 2025 09:15:49 -0700 (PDT)
Date: Mon, 21 Jul 2025 17:15:46 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: mark.rutland@arm.com, lpieralisi@kernel.org, arnd@arndb.de,
	wei.liu@kernel.org, romank@linux.microsoft.com,
	mhklinux@outlook.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, maz@kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, oliver.upton@linux.dev,
	kvmarm@lists.linux.dev, roypat@amazon.com,
	Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH] arm64: kvm, smccc: Fix vendor uuid
Message-ID: <20250721-proficient-carrot-cockatoo-393ae1@sudeepholla>
References: <20250721130558.50823-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721130558.50823-1-jackabt.amazon@gmail.com>

(I can't see this original patch in my mailbox, got only Marc's response)

On Mon, Jul 21, 2025 at 02:05:58PM +0100, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> Commit 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for
> getting hypervisor UUID") replaced the explicit register constants
> with the UUID_INIT macro. However, there is an endian issue, meaning
> the UUID generated and used in the handshake didn't match UUID prior to
> the commit.
> 
> The change in UUID causes the SMCCC vendor handshake to fail with older
> guest kernels, meaning devices such as PTP were not available in the
> guest.
> 
> This patch updates the parameters to the macro to generate a UUID which
> matches the previous value, and re-establish backwards compatibility
> with older guest kernels.
> 

Nice catch. This is result of classic confusion with UUID and GUID especially
coming from Microsoft who tend to use GUID more.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

This also makes me wonder if the initialisation in arch/arm64/hyperv/mshyperv.c
is also wrong or may be that's correct only MS guys can confirm as I couldn't
find the UUID string for that.

-- 
Regards,
Sudeep
