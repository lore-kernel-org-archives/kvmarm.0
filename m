Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961690;
	b=p68s4a7n7gp9hHvXUywCYa67kGKjCm1LTyJMuOHNsNeZOjCrixk0chAOB8BsNIbl9WAC
	 anOOlPZFZ6nSAqtZWH+9K7gkC4P3emYjdMnhHiZlwcqNteyRjYaa5pR4KI76VpnOs8rqE
	 Q5/xhpr0SJtbCCGi4Rg/a+KV1Aja1htnq2kCIjx8m/Reqd7x2C2AnaKoYDog9FLaNigdg
	 E+sgyoqTKpmv9BwyBCwpaOwtIsBj4fMDasnmksAt0ZuGveRBIAHZHzKMPEyu8zFtu4uN/
	 6mhkGj8m1E7Wq4yJ8zXeUr1dN2T4dy4RYCzXjNtuYZn7QX5RruTnX/7ChEXT2SgXlJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961690;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zvrOcLQ/9j6k4VzNeeZ4ubTA6xIn7QoQ0vI4b1H2fsY=;
	b=Me1j3OzS9QK3w5/1xQR1wXKiUGDBxxDp3DK8OkNy+dnpyEKON1SXuZ6JnX8N1xGYtOZj
	 NFgbvOF0yf2FSKFtObImX8wtRZ7SAM8tYeyVF425W9Uty0Rx13+PY8bI5xyoxFMJ+udi3
	 sDyAf+Jxabdto/Cv+rfqN6RckJWwiRAv/JxmDhRMCnpwt64NneFhpycsoYu9qvW/PQefT
	 c01Jxr47SsGKHo7TJyZyvLzPkoxI/GWqvM8kCPSXkLOXHjT9jvJazHri9Yq5bR3UiOFzI
	 Z9/sijynZZjO9tqe8KGT+UPIPxddFqisOi/g4I05uyTgbgiVBQfWrkYtixssirCUbvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CyWRZB+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31AE606A338;
	Wed, 18 Nov 2026 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CyWRZB+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485621F000C5;
	Wed, 18 Nov 2026 00:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961690;
	bh=zvrOcLQ/9j6k4VzNeeZ4ubTA6xIn7QoQ0vI4b1H2fsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CyWRZB+OjB6pp3PhlLCT/Z72vh+NaEvArJZGW2I2DVcYct7OiNcGxFxreT5ip9DnG
	 ym13lqgDUy5shrdUtyD8G13JURZUb3jn/x0sRQxO2ZwvslSaUeqhwdU0H38K+66Or2
	 RzSY20nyImy2ADM0IxfJGup9GdFjFk4+Vc5Lkie+pj/Y6TH8OeBJpQSYXkFyYAIjrI
	 1L8odKslmyHqrfbGbzo6rRl94avCRuX4lM51PN6IX2CLqFSBm6Cjr5N7pLqchSb+x7
	 MRyaYHceKVbRpNtf28lhhHabS0eaBMWscNZRV/ZvxCpEjpHLHFgyJMbcT8CP4MfP7g
	 nWYJP0Vrpd8SA==
Date: Tue, 17 Nov 2026 16:28:09 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Michael Reeves <michael.reeves077@gmail.com>
Cc: Myria Sarvay <myrialsarvay@gmail.com>,
	Yureka Lilian <yureka@cyberchaos.dev>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] arm64: Add KVM support for newer Apple Silicon
 CPUs
Message-ID: <avzxGUgKHnSEnstK@kernel.org>
References: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
 <179495264127.1456871.1866504028661732526.b4-ty@kernel.org>
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
In-Reply-To: <179495264127.1456871.1866504028661732526.b4-ty@kernel.org>

On Tue, Nov 17, 2026 at 01:57:24PM -0800, Oliver Upton wrote:
> On Wed, 21 Oct 2026 10:53:19 +1100, Michael Reeves wrote:
> > This series enables KVM support on Apple Silicon M3 (base, Pro and Max),
> > base M4, A18 Pro and M5 Pro CPUs.
> > 
> > The first patch adds the CPU part numbers and MIDR definitions.
> > 
> > The second patch adds these CPUs to the existing Apple Silicon PMU and
> > broken SEIS workarounds. It also enables TDIR detection so KVM can trap
> > guest DIR accesses without trapping all common registers.
> > 
> > [...]
> 
> Applied to next, thanks!
> 
> [1/2] arm64: Add CPU part numbers for newer Apple Silicon CPUs
>       https://git.kernel.org/kvmarm/kvmarm/c/61615311ce39
> [2/2] arm64: Apply existing Apple Silicon CPU workarounds to newer CPUs
>       https://git.kernel.org/kvmarm/kvmarm/c/3a7b70524c54

Whoops, this was accidental since I had your changes applied locally for
testing on an M4.

Marc's next fixes pull for 7.4 will be the canonical patches.

Thanks,
Oliver
