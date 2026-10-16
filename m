Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD72A44236A;
	Fri, 16 Oct 2026 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161881; cv=none; b=MMZHKCMc2qCzz3DJ4Xeg0Xr6GJ73+X0y7xDxMpz+/PyRmuo76csFNXfmuTDf7+l4+lJpqRXSheA+jf/ovyZWG1gZfm2asIxOMj/wnI17uQfJkqwXsnPMmV9i2vvHhRE4XNisF0AD9FcP4B8SSYu7B72tm6tXYYSbLcb2pC+1T3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161881; c=relaxed/simple;
	bh=j0xW1ECQl1jI0BL+wij76Qj8jsOKsICj1DWAClibVrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tl6DhmqgNigX/U5eFB0BcvipT9e8Uj82K+BsU8LwdG6iQalUDNBxaN1aWfUUxKUd4HomXGJnfgxDbLY7B6J+iFFKf782K3e/IyLIjNK0XRAph4pH+zAFdgym/9xlVkor4X2+yYJ7KCu3+PYxK1p/Cc0DumOLZsQRCVTp9FQ4AGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwr/nzag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwr/nzag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652B01F000C4;
	Fri, 16 Oct 2026 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792161880;
	bh=j0xW1ECQl1jI0BL+wij76Qj8jsOKsICj1DWAClibVrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bwr/nzaglzAmR+wBeAZmq2eOT7MEcrWX2lvXEGeDyhE51bVxI3SgaShKfUBiYf95g
	 PmPSn2XhibSE4eN8cv06IVMobz4lNmloGh/vbUBPQPMRA+LsYlBo0nz0c8vJpFUK3C
	 slQkDPLs6z92+ufgm/Fa8TFMhnbV0q/2Z/dJ3rGmonEBvA+JaJN11IxFe7clZgUeDJ
	 miRiBu7BSUf9kZeip6s4AfA6WfKCbpjIzAdzbyD93F2r8xbjiTsSds49Lsg9YIgyxO
	 f38Mt2XTtZuhAtxAIKtCr2LRW0txknrlpTenmZXyjebLSbgcK/6JId8DQ/Ooshdf9D
	 JLjwJt40G4clA==
Date: Fri, 16 Oct 2026 15:44:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [RFC PATCH v7 11/28] KVM: arm64: Add a new VCPU device control
 group for SPE
Message-ID: <atI1NfqxWsPOhvBX@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-12-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-12-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:06PM +0100, Alexandru Elisei wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> Add a new VCPU device control group to control various aspects of KVM's SPE
> emulation. Functionality will be added in later patches.

Again fairly thin commit message, be useful to provide more details.

I'd also explicitly say you're adding stubs and the foundations for this but the
actual implementation isn't in place yet.

>
> [ Alexandru E: Major rework ]

Generally [] stuff is for small fixups done to a patch, so a major rework isn't
really suited to this form.

The done thing for this kind of thing I think is something like:

Co-developed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Note that you require Sudeep's explicit permission to do this though! :)

>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Overall this looks obviously correct (TM), so with the commit message +
authorship stuff addressed:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo
