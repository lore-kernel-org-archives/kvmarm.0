Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C3134BA5B;
	Mon, 12 Oct 2026 16:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823866; cv=none; b=ByhWT+5IJ4hU5OnixIPQOEgaZ/cWz1rS/Xxa55LHcDioQa2nw/b1kepk5k6d6GZyvdbBPiqTMtq9ER70/Vp8XqrIoQXrTJNWdv4K87nvGaTDi/iQL2zbhU3md0gAjX20kXBgleJoYWnc4jvOdEVUTu48hZAArEr6Tz1nl7/9YMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823866; c=relaxed/simple;
	bh=D+EWCyvU5lM3bpyjoskEyi+nYvM+Cu4MsxC5akYkFug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BxzeJUiJJ6QZe6T3VC9Tf0ncOayKWhmGgmOdma3/bQ1UVWKesMdK3uMC/JK79GplwAHkvATos3EsEaqZR+D9XU5Z06CYcHpln4GPljQh87QVCSA2XywHQQWMFJQ3Lhevye2/JkAVMczC8h5D+S2iHCY4prJKYumer9FX4lfrBhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hgH3yg7k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hgH3yg7k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EECF91650;
	Mon, 12 Oct 2026 09:50:59 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 758203F673;
	Mon, 12 Oct 2026 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791823863; bh=D+EWCyvU5lM3bpyjoskEyi+nYvM+Cu4MsxC5akYkFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgH3yg7k5nLsFckquZBVNyD/rrEj0Hp+/Lx9q7hs9XYsZlYeJZph/6QmyB1y9DUgk
	 72m0STX7+R2vcFbip7Iuqc/2XkF61poZN+1EUcU4IJtKmsuFftBBNDE9WXqQ6IxMvR
	 9fXgR2Hf7X5oBYYY4A/U9XhZmRYRPoHg9Ocqe2uc=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: "Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Frank Li <frank.li@nxp.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v5 0/2] arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency issue
Date: Mon, 12 Oct 2026 17:50:53 +0100
Message-ID: <179182359007.897996.12846127704007429935.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261010-imx8qm-cache-coherency-v5-v5-0-c9d6cd60c0c2@nxp.com>
References: <20261010-imx8qm-cache-coherency-v5-v5-0-c9d6cd60c0c2@nxp.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 10 Oct 2026 01:19:44 +0800, Peng Fan (OSS) wrote:
> This picks up the work originally done by Ivan T. Ivanov in 2023 [1],
> reworked to address review feedback from Will Deacon and Mark Rutland,
> and rebased onto linux-next (next-20261008).
> 
> According to NXP errata document IMX8_1N94W [2], the i.MX8QuadMax and
> i.MX8QuadPlus SoCs suffer from a cache coherency issue (ERR050104).
> The upper bits, above bit 35, of the ARADDR and ACADDR buses within
> the Arm A53 subsystem have been incorrectly connected, corrupting some
> TLBI and IC maintenance operations exchanged between the A53 and A72
> core clusters.
> 
> [...]

Applied to arm64 (for-next/cpu-errata), thanks!

I tweaked a few bits in here: commit, Kconfig and errata description
texts, some code comments.

[1/2] arm64: cpufeature: add ARM64_CPUCAP_SOC_ERRATUM for SoC-level errata
      https://git.kernel.org/arm64/c/cea68e7489a0
[2/2] arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency issue
      https://git.kernel.org/arm64/c/d44e08dab27d
