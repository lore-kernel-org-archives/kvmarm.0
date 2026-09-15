Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E647DFA8;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511148; cv=none; b=V1XmaiTIU4nhS+oIX8cv+BS1vFNi7KxADb86DVxKvMvLErXYzKDtyr12pjoUObak3Q9lBCSxbCsmkbk/VwTk2EPB7m4TDc9JeNZ67LJfi+uvMf866QE/ml1bFBMQflMXYYMxMI9KcuqGm66d8+ybCM3EcoMICWBR640i5noXORk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511148; c=relaxed/simple;
	bh=iJgOGq5O1LChlKo5rLejXCUQUZgg0Dmy6tnWiP48pxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPpoJT3+nWzRsw2qU6ln3LehU5MZBcPAhgGtpXILDU3ujtsGY1o1g2Cn8ZRyq5i3GpARF7OmSDhxCHh8g0osRg54zRALuiWQ1VSIBMewfe1oAhUAv+OL5uh3IP5Qn/CWQHub66MP53YYue18dlThBDJt+6ELEvjEAGJq6gMFxTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DftyfJ36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DftyfJ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F621F0089E;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511146;
	bh=2XNrRt3K/e2GN4rK6G5yz+bVayP/H1MToKI/zMgC5rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DftyfJ36qL02JUOy+8wuqysxT1e9/AP0552ZtGpwRIpOR6WpMwHzcA6ui2ExrjajS
	 P3AbRebswUS++Q5A0hfjZ9mYPNE0vv+y3eg6HJQNIKZTL9cIWQnmM3TR2A9guKEQXG
	 OMZSMenlgeu//48gCujufkwkUMD+ODHKeeRl2Hy+JS4oSsuMZyFGfr8bX3SjWnallO
	 tMzyAZVJnLtfAJlnbwMDkPTZhEyaqQP2HiWIke7aXl6mW6VULXU0myuUriDgyOwr4Y
	 JOCH3tN+DaPIZynJ2hwpsJZ1PpYlc6AnZHVN3oE0msG8ToEC1cLg9IDU8CbQ6QXuea
	 i93ZcH2Jy/Efw==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: vgic-its: Make the ITS table save reliable
Date: Tue, 15 Sep 2026 15:25:36 -0700
Message-ID: <178951103704.10790.6467022902884466773.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821064445.615838-1-fuad.tabba@linux.dev>
References: <20260821064445.615838-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 21 Aug 2026 07:44:41 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Free the LPI translation cache in vgic_mmio_write_its_baser() too,
>     inside the its_lock section. (Eric)
>   - Reworded patch 1 to name the register the write is to. (Eric)
>   - Rebased onto kvmarm/next.
> 
> Marc pointed out on the v2 ITS series [2] that patch 3 fixed the wrong
> end of the problem: KVM should drop the collections when the guest
> changes the table that described them, rather than validating them at
> save time. He also called that patch's -EINVAL a mistake, since it
> aborts a save userspace has to be able to issue. This series does both,
> following his answers [3] to the two open questions: purge the whole
> list, and skip the offending device rather than fail.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
      https://git.kernel.org/kvmarm/kvmarm/c/8cd92f77ae4f
[2/4] Revert "KVM: arm64: vgic-its: Don't save collections the table cannot hold"
      https://git.kernel.org/kvmarm/kvmarm/c/30908e727247
[3/4] KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save
      https://git.kernel.org/kvmarm/kvmarm/c/cc5d96036e01
[4/4] KVM: arm64: selftests: Add ITS table save tests
      https://git.kernel.org/kvmarm/kvmarm/c/6f182db39fb0

--
Best,
Oliver
