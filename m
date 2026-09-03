Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2894AE139;
	Thu,  3 Sep 2026 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443983; cv=none; b=ROjvLf6fp4eMYUA0GrTc7jeUNVomEKnTv0AAuvt7FhhoYo6t9QmHXIZCvOl/EDew4NjjmOu5wSsvfZ6Eq4RjxslOuTrOKMiUWuI96bUyb3dXTP80JhwCQtGo29tL2mmtkaRM3au3sZF624U2P87JaLzWh0HasYR6a6oy1Z6b8Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443983; c=relaxed/simple;
	bh=RzLnX5tAhAwLZuTbkxAbt+T3B6GjhLewgBFcmYwg4tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/ODCK9Q1AtPPeeuw1xjGcLtCUgWmMkhujclv2htC+Zx1L3ExiAVNlDhvbJabr9j/DqaWJOMaJOS6zZiYJ9E88K4cT7oRaRxW2/26LC/GPZa4lHXqH/QG+I+wgfXrkj/Dsr3vSrzGpZn5srWiBlt0Od81drfsyiKS9Wc4CEmDk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzrLb7FO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzrLb7FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE5F1F00A3E;
	Thu,  3 Sep 2026 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443966;
	bh=Z9R75c4B3rs0HbxR41cROos6qACJLvEn0XkD6Iroq3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzrLb7FOXo7LE9TEMuSOSpVB1Bk0Syd308DdfBN+D+WxXqIBZmlJZA+P+JT97RuGk
	 NGli60ocgfW0acoqKWsxvuZf6MaWVynSQS8Xqf69N29HQPF7yOhC2+XBkBTstMZucL
	 htMuf7dTWabNK+9vb9Bz6ZebYnWRBIqESwPYy1wcYQnhnGSHpCzEg+rsBHHHEZTf0G
	 tWNZdvZ+tldcU5SnCCjxWE8gdt/Jw9Xk5sdzDBtsoooyZd00tnotF3CyhJWHtbTDD/
	 UNprbj82ekQUWATlwBIDphH+jcANINIDP+a7v17tsziAPh1BRp1PmAAp+vB8Ty99E1
	 lr7TobbkZhifA==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] arm64: Don't read GMID_EL1 when MTE is disabled
Date: Thu,  3 Sep 2026 14:59:15 +0100
Message-ID: <178844061613.4163758.10275612375567336111.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827185937.1369099-1-fuad.tabba@linux.dev>
References: <20260827185937.1369099-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 27 Aug 2026 19:59:37 +0100, Fuad Tabba wrote:
> __cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
> ID_AA64PFR1_EL1, so it reads the register even when the kernel has
> disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets HCR_EL2.TID5
> in that case, and pKVM injects an UNDEF the host cannot handle:
> 
>   Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
>   pc : __cpuinfo_store_cpu+0xf4/0x264
>   Kernel panic - not syncing: Attempted to kill the idle task!
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Don't read GMID_EL1 when MTE is disabled
      https://git.kernel.org/arm64/c/5445d6419962

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
