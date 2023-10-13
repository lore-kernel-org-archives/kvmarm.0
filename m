Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59E0613A
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCDlKR0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C22C433C8;
	Fri, 13 Oct 2023 09:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697189402;
	bh=f7do+dpudNZPy0yWryXE+ho+/1AmjqbHW/++9cnKmVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCDlKR0u2gWn+VGKL+Xw0nM+aPj09j749/NPPfpzHYQkmACi93tfi4+bChNwRg7sv
	 Am+NE49hZdohDMRnY9SX0uO/c05BUTQEXBZ/4tytq8+9fOY9pkinQ3j8KPdynNMaWB
	 y08VdhetBOBFoqZNET2jqfRuMNFFF/x5igTsHwhiNWfQI/OnOtDjV0j0E9lnQUv42m
	 g/r3iv9TPRZXpEvwyXUyRkcpgJr02Lp/0+NIITcUM8CczLjY32ES19KwIFqvyiF92Y
	 JAq8/qmrNHtzrSWEGu++z0JwaJhiL2Ntp9rhD3u2y5HKd4DBihztObUADnTGilPl7X
	 7J8MpnZb+38LA==
Date: Fri, 13 Oct 2023 10:29:55 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>, ankita@nvidia.com,
	maz@kernel.org, oliver.upton@linux.dev, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231013092954.GB13524@willie-the-truck>
References: <ZQIFfqgR5zcidRR3@nvidia.com>
 <ZRKW6uDR/+eXYMzl@lpieralisi>
 <ZRLiDf204zCpO6Mv@arm.com>
 <ZR6IZwcFNw55asW0@lpieralisi>
 <20231012123541.GB11824@willie-the-truck>
 <ZSf6Ue09IO6QMBs1@arm.com>
 <20231012144807.GA12374@willie-the-truck>
 <20231012154439.GM3952@nvidia.com>
 <20231012163931.GA12592@willie-the-truck>
 <20231012183624.GN3952@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012183624.GN3952@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Oct 12, 2023 at 03:36:24PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 12, 2023 at 05:39:31PM +0100, Will Deacon wrote:
> 
> > All I'm asking for is justification as to why Normal-NC is the right
> > memory type rather than any other normal memory type. If it's not possible
> > to explain that architecturally, then I'm not sure this change belongs in
> > architecture code.
> 
> Well, I think Catalin summarized it nicely, I second his ask at the end:
> 
> We are basically at your scenario below - can you justify why
> DEVICE_GRE is correct today, architecturally? We could not. Earlier
> someone said uncontained failure prevention, but a deep dive on that
> found it is not so.

This logic can be used to justify the use of any other memory type. I'm
asking specifically why Normal-NC is correct.

> > Ultimately, we need to be able to maintain this stuff, so we can't just
> > blindly implement changes based on a combination of off-list discussions
> > and individual product needs. For example, if somebody else rocks up
> > tomorrow and asks for this to be Normal-writethrough, what grounds do
> > we have to say no if we've taken this change already?
> 
> Hmm. Something got lost here.

Well, I didn't assume FWB since these patches change the behaviour
regardless...

> This patch is talking about the S2 MemAttr[3:0]. There are only 4
> relevant values (when FEAT_S2FWB) (see D5.5.5 in ARM DDI 0487F.c)
> 
>  0b001 - Today: force VM to be Device nGnRE
> 
>  0b101 - Proposed: prevent the VM from selecting cachable, allow it to
>          choose Device-* or NormalNC
> 
>  0b110 - Force write back. Would totally break MMIO, ruled out
> 
>  0b111 - Allow the VM to select anything, including cachable.
>          This is nice, but summarizing Catalin's remarks:
>            a) The kernel can't do cache maintenance (defeats FWB)
>            b) Catalin's concerns about MTE and Atomics triggering
> 	      uncontained failures
>            c) It is unclear about uncontained failures for cachable
>               in general
> 
> So the only argument is 001 v 110 v 111

Ok, so I can see why you end up with Normal-NC on a system that implements
FWB. Systems without FWB have other options, but you can reasonably argue
that having consistent behaviour between the two configurations is
desirable. Please can you add that to the commit message?

I still don't understand how to reclaim an MMIO region that the guest has
mapped Normal-NC (see the thread with Catalin).

Will
