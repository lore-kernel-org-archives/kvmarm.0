Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724930;
	b=ox5xoHDUaklsoJ9Hii8xto02ljje40s+snxGXtf3WnxBDndZvlAoC/tU4qD7DwXmgjgT
	 BFOXIuL3mRGy9W0FbzOmRZn1RbPqDzrxZHmTgvlYJUTYq58oM35w/C17kq1JdshnIT5pI
	 FrnP+nTvc7J+Guw7N/eEd03EZMOc2gnJdf9pzTCb8LT5yvMP8VfqszXY0agX49YWLygsh
	 /4TkIlsHJV7SFWqRpL0yb1LCzf7O1jhQEJdR4+A752DAFYZby0RDFAbRTXcOI33UW+7SO
	 /oCSn1pRCrMXyDz6q1cEzRq2OjaJyYUzWM2honPEvlWTBdPJ040yg+5mW/sZ1sgO8YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724930;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Uy62sZIrZ53EycNsa0F+QfAVrofv8khe85aXX4gapkQ=;
	b=5T/mH6paOrxXAB0utKOSzUGxPGQkCd0pK1MlDkF03wtPRiJa7Hdpsf+AV4RJe5pLkFsa
	 nrSWhCW264f/5b6C1J7uc+I2xpgyPa7Tn7qgcUzNk5vaDS3NKM2urxLqn1swFFFHh7efz
	 49hZ9bdPyLJ1FxLGwPIh0o7J7+VQegH35eEC/iSnA9Tuw5bk2eQlNoIAPLFyo3j0kkAEG
	 PMrig3FUF3gLEEflAcxuSCTdUSQJ9gUf9PZa4eP2W0/9GyMWqIk8WkcipApkpdlbxQ6+r
	 6N4hW1nilKb9K8vzElJMwCHoo9SkgiGWDAJrr75wHUv8kvFPwZchr8yc7/DiZFDJt6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SM9garVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9673606A324;
	Tue,  3 Nov 2026 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SM9garVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A09A1F000C1;
	Tue,  3 Nov 2026 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724929;
	bh=Uy62sZIrZ53EycNsa0F+QfAVrofv8khe85aXX4gapkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SM9garVI8Du06Zk5PGVus1j5YVh2s2lwl1obZ9eq1O+qxLFFBxvPUJLfTVauKfTU1
	 Ny2uh64m1SVz5j5rudVJfoL9oD8ZZoE1GlSX9+s0NFuPm5mEzNQgn83hcR2IPRvz+h
	 sXpQ6LuRfkuxBJRkcbksscajhHaoE3TwwX62zBJkoAIicoXwLUGBH95pp7hyYDaIa+
	 tjpJYoLtaMV1DUZ6BmsJrIVIG0M5b0V/A31CWm1eI6UmF+nkckH8tnGVJ7CLIkjs64
	 sdqnYEsPzigid3i/OCibJSW7+WGHgtntzLWlEll9d6SmJN71Fb54k3VpWqiyqEnhUg
	 O8CAbTv+8YKNw==
Date: Tue, 3 Nov 2026 08:55:28 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Skip empty IPA ranges when destroying
 stage-2 page-tables
Message-ID: <auoSAH996QxqrqI1@kernel.org>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-3-fuad.tabba@linux.dev>
 <9841ba98-7f07-4d5d-8397-a07e22ba7f51@arm.com>
 <CA+EHjTxWA2o7RkZw_17QMfYjXYN2dW-X6Rmj95YN1iYBvBzrCg@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxWA2o7RkZw_17QMfYjXYN2dW-X6Rmj95YN1iYBvBzrCg@mail.gmail.com>

On Tue, Nov 03, 2026 at 04:19:38PM +0000, Fuad Tabba wrote:
> > > @@ -1010,9 +1010,20 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
> [...]
> > >                   next = stage2_range_addr_end(addr, end);
> > > -                KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
> > > -                                                             next - addr);
> > > +                kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
> >
> > minor nit: Given the kvm_pgtable_stage2_destroy_range() is the only
> > called from here, and this caller would benefit from the walk
> > information, would it make sense to return a hint back ? Not sure how
> > much of that is possible. We do this in the RMM, always return a hint
> > of the next possible address. Of course this is not that expensive
> > as the CCA case and could be dealt in a separate series.
> 
> kvm_pgtable_stage2_destroy_range() is also called by
> kvm_pgtable_stage2_destroy(), which EL2 uses to free a pKVM guest's
> stage-2, so I'd rather not change it in a fix.

This one is still an optimization, not a fix. The re-walk after destroy
is a bit fiddly, especially when the inner walk knows exactly what IPA
it stopped at.

Thanks,
Oliver
