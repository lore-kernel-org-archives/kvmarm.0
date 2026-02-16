Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B92BE031
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771261817; cv=none; b=Sy3U8RDGv7Cn8JaMJRFCoLqY5i0rO/wUPqWtHDSvHw4lJNLccB3/uv8FXRZOaze+aEHsYNRHe8mB/tztitcc0/6H2fkCeBcVf/hvH0bqPYpEIqqES1nytd6sQ7Am4BpK29yB4Nhfdct02Hpb2Vbna7/IZsJpyRhIOSe4IiR4pU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771261817; c=relaxed/simple;
	bh=MPgw0ZJGnZdRd0+uN9tm9xrc36h2WXvcvot70CXaz2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdkwYxcof6kpWmZDbqwcmre3Z7Xmq32Y5C7/Xri+YSbAvv3g5sNMZrLZ4bqZXPR0Hr1XrdrXfonIMaGSjymiO2bHGCa4/lEsRN5m+8G4yGq5LaDen+bp/TAW3SPIFXWXy87yRfFPpCIvzJ/uCgxmXsTJ/O/r+WwdgE6yz9cwkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxATw1uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxATw1uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350ABC19424;
	Mon, 16 Feb 2026 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771261817;
	bh=MPgw0ZJGnZdRd0+uN9tm9xrc36h2WXvcvot70CXaz2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZxATw1ujX7s5XkBVGQDu6naptjeLtuISp7QsMMQdTwCSxe0n4LuMxX6kTykniM0NN
	 XPXu1Is3WK24bS6lJJ/HnnEVOtSgwk8YsfOyWApZEOGReXra2514Uoi4PQJ9VK3foe
	 PQegwoZfEueyX+LrS24cayflZEfBA+Gyyz35luPbnoilNY1weV2cGWsyxTBtH8XwN3
	 r1TnxXewX8akun81SMd3iCDleaipUptT+P09kmlGp30qNBo+u7kszrMc38CacISZNV
	 5UHC0kiSEJK1G7cXNXbaJEjzVVmKiXvK8DTul+eQ2lKpZlg8W4kJUu0MkDz2WZYPBs
	 YfpmbtGEptmZw==
Date: Mon, 16 Feb 2026 17:10:12 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZNPdDAHiLpTvGnS@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <aZM9kv9X5KjeM94j@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZM9kv9X5KjeM94j@raptor>

On Mon, Feb 16, 2026 at 03:53:54PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
> > On Mon, 16 Feb 2026 13:09:59 +0000,
> > Will Deacon <will@kernel.org> wrote:
> > > 
> > > The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> > > generation in guest context when self-hosted TRBE is in use by the host.
> > > 
> > > Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> > > TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> > > per R_YCHKJ the Trace Buffer Unit will still be enabled if
> > > TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> > > Trace Buffer Unit can perform address translation for the "owning
> > > exception level" even when it is out of context.
> > 
> > Great. So TRBE violates all the principles that we hold true in the
> > architecture. Does SPE suffer from the same level of brokenness?
> 
> I think not currently - I_JZRDG from DDI0487M.a.a says that after a PSB + DSB
> 'no new memory accesses using the lower Exception level translation table
> entries occur'.
> 
> But looks like the behaviour will be changed so that it will be similar to TRBE,
> according to the Arm known issues document [1], added in D23136:
> 
> 'When the Proﬁling Buﬀer is enabled, proﬁling is not stopped, and Discard mode
> is not enabled, the Statistical Proﬁling Unit might cause speculative
> translations for the owning translation regime, including when the owning
> translation regime is out-of-context'.

I think SPE is ok, as __debug_save_spe() clears PMSCR_EL1 and (unlike
TRBE) PMSCR_EL1.ExSPE _are_ factored into whether or not profiling is
"enabled".

So there's a funny asymmetry between SPE and TRBE, which I assume is due
to the coresight much associated with the latter.

Will
