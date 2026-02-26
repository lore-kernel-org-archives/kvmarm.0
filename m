Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41885A932;
	Thu, 26 Feb 2026 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772105912; cv=none; b=NTrWw7essieeowzLJ32h4bdW5driVu4AMIMZL1mPyYlDVkihPndNEYLXrSCUXXEXyK29piX9MeNjE4YWsaLokgTreRp4x0mxtDKwvzHcpjfpQ6aVqfBC6VSOYTphHNpAuBN19c8oEEQ5Jw65mbBA7Ls2pNVtIUged8ZcDN9URfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772105912; c=relaxed/simple;
	bh=h0LXqcIKOrvxUgaaQZFhxxdHYHkQ0+ABx+hsGmP7jz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0CutH5i5XhAm2WJh8mDOIaJB5tyG+hMoANDYFfWOIUFmI6IiKZKgB6qx5NcXoMAoUM/cMqjlJxFr8fdlKTnueWQBPnMkbRxuVC9z8n+3/r8yHTAVvt44xYBAdqTexvoghWSRWvmPJqUo9iHVhRZX34cqkCDFFftAQW59pDQNDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBnlrRXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBnlrRXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7972BC116C6;
	Thu, 26 Feb 2026 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772105911;
	bh=h0LXqcIKOrvxUgaaQZFhxxdHYHkQ0+ABx+hsGmP7jz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WBnlrRXsE6ZbQPudY3I0xHS7hZGfQ4B0Ogf5rz6MH/MzklysmhGRoocHOedAKhRSw
	 Zb9o0R1J4owSQcmJPaAoUxoPXPrJ9L51DXP2Ki820buN+4xv/he7cSfs0Loegg0lWG
	 k5HUmYffeRYsyfoOcKyrEhPtHYQjAI+3Pz4iWJ++CGqjOVzTpwDPB3sJVzyzo0q8QF
	 D+lYVWYxk6L1tAfK0zIyHoYOf1uSnEPlo3BUmV3IPkVOxVmWvxrQYmG0m10yztN8el
	 XdUAtCTmMoAW/8jMWLDx6DOFOdGgbRqD5IQpON49sXYnQF3p0xZkGn5qeIilqrZHpw
	 s/ByNyn5Zycpg==
Date: Thu, 26 Feb 2026 03:38:30 -0800
From: Oliver Upton <oupton@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaAwtrrJ-qFrqktX@kernel.org>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225182708.3225211-8-yeoreum.yun@arm.com>

On Wed, Feb 25, 2026 at 06:27:07PM +0000, Yeoreum Yun wrote:
> +	asm volatile(__LSUI_PREAMBLE
> +		     "1: caslt	%[old], %[new], %[addr]\n"

The other two flavors of this use relaxed ordering, why can't we do the
same with LSUI?

Thanks,
Oliver
