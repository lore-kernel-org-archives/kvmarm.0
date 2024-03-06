Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299A3A262
	for <kvmarm@lists.linux.dev>; Wed,  6 Mar 2024 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709714393; cv=none; b=Iod7bgsgS4NmpD4bUT667CuUPlx3Nq4ffEoBcE0byGZ+nm1o0ghTCgFskcK9M4F+m/Q5TDitNGVnkw+pZQ1N6XgmvIiLIAy5zeXNuzEkwdgG0eeHRCQZCmxI54nsAZDjiM2D4bHNapNiLvM6sXwBCHBVgMVxURbt2BHD6o2fcus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709714393; c=relaxed/simple;
	bh=kSiViu/PNwEQ6CeKZ88X2MM/44fvA8higRaew3HJTkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEuZxCjW92dplfap9dlpw7+1fWAbfFXJ9cE94xqolmq4JyIVJqtsdZ33W1FJZy9QGWnNzKKDmysUcm8jXeSty12bPqQy2ijXWwnqHj2S96Nb8xpTZcQhn9HX1Qo1DBEoz7/14rAAqMtuImMsKShgtbz2Ca0p3QOSrMey53nrW+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kM2SK1RR; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kM2SK1RR"
Date: Wed, 6 Mar 2024 00:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709714389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=esGonkOHKLwe5cJdl4RDMJ39QA6gaSTz6ugwpE4PceU=;
	b=kM2SK1RRAqE3BIYVmPqKxyr/Bn9blz228x8OZ9r6uiZH5LkalR/HNKJHi4g+M4GDYHgzAo
	QrKK+ALWY8fD3ewEfvRA1dFK1BcxQ6LdPRohhEqKlttCqHKRligQYvnDZqU9lfW8K8r7Rg
	PeWBU01QQwG5u8nxftuXEc6DG5qkrp0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Message-ID: <ZegrzpC-GODaO1yB@linux.dev>
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <Zebb9CyihqC4JqnK@linux.dev>
 <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 11:01:09AM +0530, Ganapatrao Kulkarni wrote:
> Of course I know this script -:)
> I didn't cc since I felt to avoid unnecessary overloading someone's inbox.

People signed up as reviewers for a subsystem know what they've gotten
themselves into... or at least realize it after the fact with the pile
of patches in their inbox.

> I don't think anyone(even ARM) is interested in this feature other than Marc
> and me/Ampere.

... and based on this _presumption_ it's OK to leave folks in the dark?

> Otherwise this would have merged upstream by now.

Stuff lands upstream when it is ready, no sooner.

-- 
Thanks,
Oliver
