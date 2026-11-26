Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713303;
	b=hVEWlPq8LuMvcgi5Q5RYbW35yBDHZSZlSycHMMu71kHr7Cc/W4IJMIHXoLZAkbVwT52/
	 XaEbVbV4tCIZCxMXfimnhuEMNa4IDtnD3MBSSYdDsMGw5SROn/3GUNRfqH6XUr5htS9t4
	 f8h1s/MEtpI5TYGETgJ9ofGspOcsekNAbasulQkw1AnRtyOM7DpdXt76hiIpdpLMxOoyb
	 i4RH/5YRCfc63GmYB+wfRnWN0bHOoDOXTmwu2yiipEbOKp5FIgMfMT2fb8eHTpsgpQaND
	 sclibeDMWt5hMiVwFFbehQDqoHyuA59kC+UnyvvY83Pbf6IzockeQ2CGAFjeJhLEIWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=q0B2zDEgWbij3ExR5m6tj05ZE8Loybx2WzGdd3/XLjI=;
	b=le6iBaOVseDJwUV0R8uitImKB4Ze9wysgN3Tuwo21pXsIeKFKeMwk3dir8FTOF8BgPuF
	 bdieWCfon07kNDRR3Jgmgb1K6AbvDARxP5A3Sv9neEja91MT4u9Xyu3AP/umHpzE2IzcZ
	 W8yFv6CW7e5TbVPo6px9Xt4Xh+gvfz1BWVS17EwSGicbmd6bmrjwylj5r/RSGIFR4ftjE
	 dGYRz8d8daQU1NuA82LmHd/BhI7HfeLThGSSBwgmBB/XThNKzl6wDZHIj6gu16LhBZDb0
	 ZZp6WsmN1qu65XcQigS5urI+gkgi2v9DMGfmriPqEnxGMbodYLaLsW27z+ReM1NPwYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LXAHTVYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9AD606A326;
	Thu, 26 Nov 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LXAHTVYl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3F01F000C4;
	Thu, 26 Nov 2026 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713302;
	bh=q0B2zDEgWbij3ExR5m6tj05ZE8Loybx2WzGdd3/XLjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXAHTVYleZCk77A0KBVbrzVRYYEk8g7LGNr8lllNPuL9sKP+j2DfhkzBJ1S2wZL1Z
	 A5AXutDExSkrph5niuRZo7dEbRYuYTYTha/KAKQ9tkBtJODdwiFaP/HtB+if2l7/Dc
	 O4Ex0tPnSNLLmmKC0sb0BI9/Zh/Ma8YPG59thZGmDLRUAyxINmsKqnnyHuc0VCUugY
	 Emp+dcJSpeZBoD9WSpFaVD1uzqHOLlM5VlejVVjMSAOE9lRBAeHhHwNyI81aJPP7In
	 16eUs95PIwZ2ghew/15VY98zDvVgKzmZuCfgBiOvaYq6EWeDLnKJVxHgsV8Xz72mvo
	 3F66kqPafhguA==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool] include: linux/types.h: Add 128-bit integer types
Date: Thu, 26 Nov 2026 17:14:34 +0000
Message-ID: <179571110464.2963221.18320321266334097396.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113153847.60183-1-kajetan.puchalski@arm.com>
References: <20261113153847.60183-1-kajetan.puchalski@arm.com>
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

On Fri, 13 Nov 2026 15:38:47 +0000, Kajetan Puchalski wrote:
> The tree no longer builds on new systems (e.g. latest Fedora images)
> because the included types.h is missing 128-bit integer types.
> 
> Add typedefs analogous to Linux commit 10a47fb67340bca274276faf855d7 to
> fix the build failures.
> 
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] include: linux/types.h: Add 128-bit integer types
      https://git.kernel.org/will/kvmtool/c/6aeffc7ad7ad

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
