Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2341E04B8
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108795; cv=none; b=uCpbu5Aq07tuGIv3L9q3jUqyY6IWCoIpP8MEY2rCSoIPQ0wR+sdaN6xgXfvHBPkid2U79jRYfvaMvC6wKcOB8aslJm64e1xZl/HO25ctbIN5tUyItB/TWPiriwdaMIx2zMIIu2HJ/1C3MoJEPZRbRA6DDUAogahxgEHEZjZWg+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108795; c=relaxed/simple;
	bh=UQ22N92gmLmVhXAkSD1nDpGj1/ul42ROwEtRuKncu6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBzF8FUvoEJ3QYz2oE7/+H58NWldLgLE1qjxRAcG7fqxMp600O+LPwIzVWjk1y64rKLSFdA63baMhAeuzqs72M/zBwDwPhkRQMvblkwu7CO1YV4j/klQYefMmwfecaDorOHx32Y0+L/TgkiJMQk2mHXttP81o5OO0eR9jrN+ve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9E841480;
	Fri, 13 Dec 2024 08:53:41 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.1.196.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C20F33F5A1;
	Fri, 13 Dec 2024 08:53:11 -0800 (PST)
Date: Fri, 13 Dec 2024 16:53:09 +0000
From: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, catalin.marinas@arm.com,
	will@kernel.org, corbet@lwn.net, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Message-ID: <20241213165309.GE30314@mazurka.cambridge.arm.com>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-3-miko.lenczewski@arm.com>
 <87cyhxs3xq.wl-maz@kernel.org>
 <084c5ada-51af-4c1a-b50a-4401e62ddbd6@arm.com>
 <86ikrprn7w.wl-maz@kernel.org>
 <2b1cc228-a8d5-4383-ab25-abbbcccd2e2c@arm.com>
 <86h678sy00.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86h678sy00.wl-maz@kernel.org>

> > 
> > From the ARM:
> > """
> > RFCPSG: If level 1 or level 2 is supported and the Contiguous bit in a set of
> > Block descriptors or Page descriptors is changed, then a TLB conflict abort can
> > be generated because multiple translation table entries might exist within a TLB
> > that translates the same IA.
> > """
> > 
> > Although I guess it's not totally explicit, I've interpretted that as saying
> > that conflicting TLB entries can only arise for the IA range for which the
> > contiguous bits have been modified in the translation tables.
> 
> Right, that's reassuring, thanks for digging that one.
> 

Thanks Ryan, will improve the comment and commit messages to make this
clearer and to include references to this information.

> > > If anything, this should absolutely check for FAR_EL1 and assert that
> > > this is indeed caused by such change.
> > 
> > I'm not really sure how we would check this reliably? Without patch 5, the
> > problem is somewhat constrained; we could have as many changes in flight as
> > there are CPUs so we could keep a list of all the {mm_struct, VA-range} that are
> > being modified. But if patch 5 is confirmed to be architecturally sound, then
> > there is no "terminating tlbi" so there is no bound on the set of {mm_struct,
> > VA-range}'s that could legitimately cause a conflict abort.
> 
> I didn't mean to imply that we should identify the exact cause of the
> abort. I was hoping to simply check that FAR_EL1 reports a userspace
> VA. Why wouldn't that work?
> 

Will do so.

Kind regards,
Mikołaj
