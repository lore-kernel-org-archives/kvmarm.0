Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998133C2D;
	Mon, 16 Feb 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771265073; cv=none; b=JWaC8/dAPQVmqOk4dNM9j/xYou5CtEbgdzTpvaBO55ue4whZFydBw1MMFZxcWh7b5vFga8BOBvAN1P/7E57xa8nb3PxjHs7+3ZWvvUhk8e6HA9PoeV3L63FTmx9z4EsrlXG2EbgUJfP3Kk4DIpwtPJTwgp5unjyThSL5NGxbrXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771265073; c=relaxed/simple;
	bh=6kGOM1T4poFGaUAsNvDOGjnG5cLnitKexAm58d+t1Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0JH4F+gBo66a5hXxXkHhIfBXNot3CnX+ZrbsREQ+oNQN+4WTtRJQZlEVWj6gwCUmAKcpkCcA3S98rZDP0Ajqi+RRPM3Tb66v4y0fciKVy1y9on4kGcuinRAS6VO0HScwHQ/1wT8IpQjosT8i4903ToMRCA1AqFIoUzqUMPh3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FDEC116C6;
	Mon, 16 Feb 2026 18:04:29 +0000 (UTC)
Date: Mon, 16 Feb 2026 18:04:27 +0000
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
Subject: Re: [PATCH v12 6/7] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aZNbXlvCHxDmsmOA@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-7-yeoreum.yun@arm.com>
 <aYtgmZZhAKAvtfaK@arm.com>
 <aYtoOktjE18YNtB+@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtoOktjE18YNtB+@e129823.arm.com>

On Tue, Feb 10, 2026 at 05:17:46PM +0000, Yeoreum Yun wrote:
> > On Wed, Jan 21, 2026 at 07:06:21PM +0000, Yeoreum Yun wrote:
> > > +
> > > +	if (futex_on_lo) {
> > > +		oval64.lo_futex.val = oldval;
> > > +		ret = get_user(oval64.lo_futex.other, uaddr + 1);
> > > +	} else {
> > > +		oval64.hi_futex.val = oldval;
> > > +		ret = get_user(oval64.hi_futex.other, uaddr - 1);
> > > +	}
> >
> > and here use
> >
> > 	get_user(oval64.raw, uaddr64);
> > 	futex[futex_pos] = oldval;
> 
> But there is another feedback about this
> (though I did first similarly with your suggestion -- use oval64.raw):
>   https://lore.kernel.org/all/aXDZGhFQDvoSwdc_@willie-the-truck/

Do you mean the 64-bit read? You can do a 32-bit uaccess, something
like:

	int other_pos = futex_pos ^ 1;
	get_user(futex[other_pos], (u32 __user *)uaddr64 + other_pos);

-- 
Catalin
