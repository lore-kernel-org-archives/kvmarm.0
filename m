Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56493815D7;
	Thu, 12 Mar 2026 22:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773353315; cv=none; b=gsiLVsjZiSirS6NOeevxkGSHw5GvKi98qrVJsOnMjIldXroVkcWyIoQ7oZG3eY9ObbUNxj3FYlrWVyI5npZA3G2seN5gKC8tURVt7WoCdyviygaGtTly7vPAYffvkjAd+I6T5WGeyNBltwMkaBbir/R79ZxGimjyOuNXIQ9eldE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773353315; c=relaxed/simple;
	bh=TVqWbgjpZje8r40f9joOR90Fu8pz5GOFfapDTXbFcCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FoyxWBUKOgoC7DrBojw9HWRK/ze7BjiLavTr5yBiMkCmwkezdO+bxT27KHjQMucDENhubUTJDI45aZKh3FfmZDwdj8fASVNaCEeegeQJ11TFKsIyDQHtD+NKdTecua4+6x0XDGPx7km68yeFKacpRIX5mQDAYES3FMX0vCrJ38Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lv9mXKlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lv9mXKlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE226C4CEF7;
	Thu, 12 Mar 2026 22:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773353314;
	bh=TVqWbgjpZje8r40f9joOR90Fu8pz5GOFfapDTXbFcCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lv9mXKlOHaf5VcCuSm6v7BkVfbltIzxhOFx1iohg0A2COIrjXOE4y9NZdGKj9D8Fg
	 /yoxraizcGTVG6KmlpmcDFtaRjnP0dAAEve+f9CNOSgliMTdE2Fh8m+34/4hhLv44v
	 qAFG6CtglTDgGZGOOjCHcNRfQ4EhPSyoZtZfzeF0+X74pCD5T5G+I4/BublthsCMOc
	 I3EUhhPd/t6l6y11STfSJK0UTfKs9s4ZvZ3U8lwUqYXoA6giD0wR+dvglT+EvCCFKz
	 xUK3OHUh9YAs7xeqEM0HL20p0dbolcfWiSwT8DAf/QjVPkcLdgEptn31/K2ObFxqDY
	 0oTbp4ddHnqbg==
Date: Thu, 12 Mar 2026 15:08:29 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 1/3] KVM: arm64: fix include path for ring
 buffer implementation
Message-ID: <20260312220829.GA1068615@ax162>
References: <20260312123601.625063-1-arnd@kernel.org>
 <177333027972.824271.5682048908167993643.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177333027972.824271.5682048908167993643.b4-ty@kernel.org>

On Thu, Mar 12, 2026 at 03:45:26PM +0000, Marc Zyngier wrote:
> Applied to next, thanks!
> 
> [2/3] tracing: add more symbols to whitelist
>       commit: 7e4b6c94300e355a72670c5b896ccc26ac312c63

This dropped the SPDX indentifier line in kernel/trace/Makefile.

Cheers,
Nathan
