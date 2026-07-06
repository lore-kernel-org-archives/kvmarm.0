Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5122E975E;
	Mon,  6 Jul 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783357476; cv=none; b=VWj4IBXUHrPgWPbXCCF7A+Q4qrbEa8hkA9Y9KBb7tn7LxB3reMH0EeXuxugRptPgNDIzGMOPOhw3pYwEQktxHRFSbZjj5stihoD5w+pgG9t8c7V9YJdwmVXRRjuk/riO2FKLLYVSyxTMgkAN+y3CR5rgZcaXvvXE+SOKoBBqPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783357476; c=relaxed/simple;
	bh=q2bf0hck/kteT/8BiENk5zi92hNnZDmATG4EbRm5dQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNG6Wlnl/KXobjTggWRV5JUz3YGbP2nulao76WITmzSY3BJWSXxd9UJYonTEQfwuPS2YGN/GMjnIt+oWzED2Gq4316OckfLNjzsB8hvA/b9vYiVHpXcy7wiaC10OU4901D70RSRJ2TCabvcYjx3E4cqNGs4TZ3WoDsiwRZFgRV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyaaNu0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyaaNu0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FE31F000E9;
	Mon,  6 Jul 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783357475;
	bh=REmuzwIaNWYa8LGBVvGUzNpeujzoKq+eMU1Gq13kbjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gyaaNu0DZ3lY+wpZZZxQ/iX7UMQqh0yyWYHoi78HU774kBB/02mxwoerTE+/DOWYp
	 ftBdYzRQvBWyb/29euRzLW3wmTKXWID7tadSd+Nb97HQ7Lw24Q07dQc6tis00rC92/
	 8xZPYUxbdNceoDK6j/iBacm63/gI7YctudjwjYi4ceHK5RpWkagVWH7umCwngTYW8+
	 jtsPBAUVsgiN2pTUkDm/0+7BMFzZCznXpYKvpmV6GwD+WlIHud9o4aaWD5Cu3YNgOe
	 hDWiQNhcSgbvwgEyZXnd/V4YDoYbh9ZojTux/OFUUB/09bWTQe07B9eRAbrcWc2BXO
	 kT/8DfH8xtg5w==
Date: Mon, 6 Jul 2026 10:04:33 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 1/7] KVM: arm64: Disallow vPMU when pPMUs do not cover
 all CPUs
Message-ID: <akvgIWqBjAp_VA_A@kernel.org>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>

Hi,

On Mon, Jul 06, 2026 at 07:03:24PM +0900, Akihiko Odaki wrote:
> Commit ec3eb9ed6081 ("KVM: arm64: PMU: Disallow vPMU on non-uniform
> PMUVer") made KVM reject vPMU unless the system-wide PMUVer is usable.
> That covers systems where PMUv3 is absent or non-uniform, as well as
> systems where IMPDEF PMUv3 sysreg traps are unavailable.
> 
> However, KVM can still accept vPMU when all CPUs uniformly trap PMUv3
> sysregs, but the pPMUs registered with KVM only cover a subset of
> possible CPUs.
> 
> Reject vPMU unless the registered pPMUs cover every possible CPU.
> This avoids carrying support for partial pPMU coverage into the
> fixed-counters-only UAPI introduced later in the series.

Doesn't CPU hotplug screw this up? I could online a CPU that doesn't
have a PMU after creating the VM.

I'd rather just change ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS to become a
system feature. That way any CPU which breaks the system-wide assumption
cannot be onlined.

Thanks,
Oliver
