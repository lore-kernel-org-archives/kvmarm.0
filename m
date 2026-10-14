Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D88566C6B
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999265; cv=none; b=n4dVz/9dVBiFwIgkzRgNp1N7rRvdhmZK71xzglPlK2Jhe6cMNxUiw9ieKqDHy9/8RxmaBWFEkBKgbGIb8Ldf8t1VUwtxtDGWrLYcjjAXOUNd8n0GFB/oWBt2GQtsHwiYzAK5N2yDmi0FQ52XwJRXaMgn2/d345DJqVrus255mNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999265; c=relaxed/simple;
	bh=DIazYOznxkvMQfk8MPg8hYekx/1bKJszrWi9fi0un7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxR7BxWCqoKJvdwFmJfrJp7TvCegtx3y+0hnBI+UN9vzoCvl4/tij9vTSiS388YNT1k1V7f/TvXhqlQWXnweHW0RoQOtO52pUMu2G9t2MuLcv5wjDUZhLieL9cgL4oID+6FFg8ZpYusvAOsQacifrm/Pv/TX57OB3vdxsOOGsiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CcC6aZc+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CcC6aZc+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE5F914BF;
	Wed, 14 Oct 2026 10:34:16 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D85993F7B4;
	Wed, 14 Oct 2026 10:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791999260; bh=DIazYOznxkvMQfk8MPg8hYekx/1bKJszrWi9fi0un7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcC6aZc+pLZLMc8Y2jvkWWDjqs+zPuhkdYidj89BVesRheQhseYiYw9GUHke29Y1u
	 2pk8EArvyX4RFNe5wFv6QVk2DpA/T0wdwCdQ2nrpjE5wxm0V9V0a6H6txpUJqgG09p
	 OM/DW9lIYgAkS/9gnGs2FWxvbFxD0Wnv9GV2rzi0=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] arm64: sysreg: Bring field definitions in line with the spec
Date: Wed, 14 Oct 2026 18:34:13 +0100
Message-ID: <179199925311.3163994.15808107527690275071.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013130247.4135515-1-fuad.tabba@linux.dev>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 14:02:43 +0100, Fuad Tabba wrote:
> Fixes to definitions in the sysreg file that don't match the current
> spec: three wrong enum values, two misspelt field names, and fields the
> architecture has dropped, including leftovers from FEAT_TME. The last
> patch also removes the BRBE driver's check on two more such
> fields (BRBINFx_EL1.T and LASTFAILED), the only functional change in
> the series.
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[1/4] arm64: sysreg: Fix three incorrect enum values
      https://git.kernel.org/arm64/c/af0010f29610
[2/4] arm64: sysreg: Fix the names of two misspelt fields
      https://git.kernel.org/arm64/c/5fee8b920a06
[3/4] arm64: sysreg: Mark fields the architecture dropped as RES0
      https://git.kernel.org/arm64/c/cbaca3920f64
[4/4] perf: arm_brbe: Remove the check for TME transaction states
      https://git.kernel.org/arm64/c/4a90fba44e3b
