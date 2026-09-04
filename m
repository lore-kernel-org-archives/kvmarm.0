Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B44A0F18;
	Fri,  4 Sep 2026 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529295; cv=none; b=dNGPM/HU3Ey2L0apjgp903cv4q93C1ly6aZfEeR2tdvXut1vZvkN/Ub8WCNASY9vhWnnVH+hqTWatH3GD4hBxo+cWVDIv0ag+cg3U0Fc/Fz/pT+50pwOo7gO4czDGeLyKN30PTPo2MtOyDwOmz9v4i0cIrNWfy0+HkGRzSA7fto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529295; c=relaxed/simple;
	bh=7r32Tg/qIG8pEx8swBsgybRMGFF8HRBL62rfwK0Z7wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lvub9GIxnvBLSTLPGEoZpUAaz1ZyBFrdym+rbEZMuzsQnD8lI7Z3DM64H9CFtwgzMbXnL2D+VoG1s+NjgmjNfWwr4dfM6Wl56mK21Vh8NVcjc0b/r5hpommKqHkHKWn5iUZIAssTsmXMmszPKlV5xAs2ISl8Ut1uFg6vpgQYQR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ko25YKjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ko25YKjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CFC1F00AC4;
	Fri,  4 Sep 2026 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788529294;
	bh=C9H82NLQBdMpqPgxDAoF5zCET/a423kRXf21LCJulRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ko25YKjlQVWRGSmrZmVyXO3hq/59IgraPpdP2jNoHi5AsmfPHPRExitu14lEH3Chp
	 2QhblnqmgnKtkIJbK/fUtxLZSvHu2nC9OP4md1em96SHt4bKUIAuaHl8jG1btxJanR
	 9t6zGWmmnK2YM5+dFziQQ0LK+gCSN3yauhDzGKwYONvMYhtm/YJ+hhlHX9m+dJpxEd
	 IuYmYJ8TAHi07ipx8abm5f/XPztbpmp9yuTkYla8X4Sdq2yiVuNYxyMDK1PEeMEQPt
	 rqHdVbDa1Hl1r+x/0mNHtNv4AUhtloOnsU75YFcWNr9fyyrVU/9OigeAWE8nv8aY22
	 NvLEpiwkGGmGA==
Date: Fri, 4 Sep 2026 14:41:28 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <aprKiP2YlBuBwDU8@willie-the-truck>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck>
 <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
 <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>

On Fri, Sep 04, 2026 at 01:20:44PM +0100, Fuad Tabba wrote:
> On Fri, 4 Sept 2026 at 12:48, Mark Brown <broonie@kernel.org> wrote:
> >
> > On Fri, Sep 04, 2026 at 12:29:23PM +0100, Will Deacon wrote:
> > > On Fri, Sep 04, 2026 at 11:33:24AM +0100, Mark Brown wrote:
> >
> > > > What about pKVM, my understanding was that that is very much an ongoing
> > > > concern and uses the nVHE hypervisor?  My expectation was that this
> > > > would only ever get used in hVHE configurations when people enable pKVM
> > > > on modern hardware, actual nVHE mode was mostly just carried along with
> > > > that.
> >
> > > pKVM uses hVHE wherever it can nowadays, so I'm fine with only supporting
> > > S1PIE on hVHE and VHE configurations if that's easier to maintain. We
> > > just need to make sure that the failure mode for nVHE results in the
> > > feature being gracefully disabled, rather than e.g. crashing or quietly
> > > doing the wrong thing.
> >
> > I figure that if we're supporting hVHE it will end up less complicated
> > to also enable nVHE, it reduces the potential for having bad or missing
> > fallback paths for features downstream of S1POE.  It's not like it's a
> > huge extra bit of code and it seems likely to save hassle down the line.
> 
> For pKVM there's no fallback path to get wrong: any CPU with S1PIE has
> VHE, so pKVM runs hVHE on it, and a CPU without VHE has no S1PIE to
> disable. I couldn't construct the protected nVHE plus S1PIE case under
> QEMU at all.

I can't remember the exact incantation, but there's definitely a way to
force pKVM + nVHE on VHE-capable hardware on the cmdline. So we should
just make sure that doesn't go horribly wrong!

Will
