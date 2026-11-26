Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713300;
	b=UyXO8SZOocBOGBa+aYAwRPrDmyJw8JF6md1qY1xTKBIZ73StpTTVhFehI4D7PWEQ1dmr
	 ue3rs/CQX5eNW0m8jUveN361qDVi1TJXajO5O/Mdf9PzBM+/I/WwdyEjS/TuPhKlT2zRN
	 10pRnC3iYftXCof+aztR/I6+MjwayV9FC7okC/c0TdLDpBc+a2G9JfklhnC2O9gngzKxm
	 cKPRdnsdtB8m7AJ5O+hCpefmJorOtP3YL/KYSFIqoAmEHSZd7W7epifiIseeBClqvV/hx
	 AaZImvLS5Lyw69IrFEWur5ck7Gd5gMKkoPeMBIXFUb7ItbPKt5yaNBBDw6dsxzhVLfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/V0rZuxbPpqV90335mZqBu8TYpDdCcCDOR66aUIa36E=;
	b=aNfRq/wSpUQHHir7fJZFSOkC1bWQNk1Prz35bhcqD3abFVQgmfOqZ7zMJPjH9kj3hqbh
	 yO5maLmlVRXdxPJZu2awcp1PcWzWWy/n0oA4taUqG77pPcgXVT08wNU0UaiODxjKVE3Y+
	 k/9ZQ5nLIAJhOFh3cgE04cwmi86g/Dq0DSWu/Kts7hj1er6jOowf0D5SkrS0RAnBhA49W
	 26w2Wu/oxiMCbKQRCKbXUlTWfA1oktCrC3OS97r6GWpw9Mmxzgkx1hO5qrfahg9vzU3te
	 OBWybzXfVbzAsL8DGr6uLPntp99omalJR1YiNKinz0WJCTwji0j2vVFIOfGbR+5FuDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dow3ELZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890A0606A31E;
	Thu, 26 Nov 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dow3ELZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F8C1F000CA;
	Thu, 26 Nov 2026 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713300;
	bh=/V0rZuxbPpqV90335mZqBu8TYpDdCcCDOR66aUIa36E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dow3ELZ0D2CeJBkNAyQMzjzO977vKeb/E+uOTGAOEUJc9G4gjajUP6/sD03f6Aa39
	 SlEgX4IBb7QROZxhe7HNTyuGnpQ5bmOEdQN+E3jB64psaoCYsRVAmE3rQuIzCNoeD2
	 zR0SB5/05xyrVdS16WbnL/6dvKixOmLt+xuiEIc1s6B+dUcwtOSJkful3HhMV9eCQp
	 fPCb/u1xaZjd93D6EGCsJyY+vqlH8dRw4gygjwdWTH2Od0gr2k54NALeiwZZZ2z4a0
	 NZXuvrY7rGSFQ2mFlvVmHOn6M0zJ39N74UIK7cU1XJ6bJfAYeS46/e3zAEsvZ2xrPW
	 DDGMtBjI1Tf5w==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool 1/2] net: dhcp: Fix parsing of resolv.conf
Date: Thu, 26 Nov 2026 17:14:33 +0000
Message-ID: <179571118646.2964088.15371184378928458278.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117161019.142337-1-kajetan.puchalski@arm.com>
References: <20261117161019.142337-1-kajetan.puchalski@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 17 Nov 2026 16:10:18 +0000, Kajetan Puchalski wrote:
> Parsing logic for /etc/resolv.conf currently does not take into account
> line breaks and can erroneously interpret e.g. comments in the file as
> valid nameservers. Fix the parser to scan line by line and explicitly
> expect a bounded key-val pair to resolve the issue.
> 
> 

Applied to kvmtool (master), thanks!

[1/2] net: dhcp: Fix parsing of resolv.conf
      https://git.kernel.org/will/kvmtool/c/3185095e8afb
[2/2] net: Use the host as a DNS proxy on loopback DNS
      https://git.kernel.org/will/kvmtool/c/f97e6d645b79

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
