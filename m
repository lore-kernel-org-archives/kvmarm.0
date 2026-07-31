Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89647D928;
	Fri, 31 Jul 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523915; cv=none; b=Et6Zcve9w3wUdIXDK4XB0JYrCVvBf7axOQc1JZIQ9c1VAJNW9P/35IIxrr7WUk2m+AyZLhR8MbK6/Jzi5btxWFAMOgJAwvJ5Vxdra10TL6yc+0G8RmZhbW3phFVzpcQP6IOOjmEiSrKrKOI6/gEwHJhsg2lxcTSx5N3VZTayByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523915; c=relaxed/simple;
	bh=/2BVvedOYirkQpwHKj8Fr23O1/l8jlOEKrfiUXhyeH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/Xl7q2xIyq0McS7DnkzUq8w4QO6ijfJfBggGm9kDfI9V/9m8NqwCsV94xMsjrIWkHqEUaRxj3HHBjODkPcJLG0L4av9ghgjpaTe2sa99LnKa7Ym4Ow3EBPjw7GiF29jv/9keQPc3qnyB30gyNK45PFGs17JbkgLLqNXRkzsKuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJj01EbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJj01EbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23631F01559;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523914;
	bh=F8FDpk1RyFSrE4ou3yw+A67uFkSWkxtrMp6e/F5xT4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJj01EbGFKTqUwPQ+Q0KdEEsRAtJB6e3nBC9ngUkBNPybNJc1xsbt+DKUdTphwbNe
	 TSd8T0ObgQXx3EBlBJqifrBtkIS5tuQ/auBFHCmiiaFxrt26wM6qymtRJSfc3I/qD1
	 S927M6JYTJJuCnVKdEsOdzI4TDeuW1qlyiv3m9umGHmg8JFuEJ/SETjGVtHSSo8kol
	 0oob9LyrcQV7noSvOtB3cIQ3SLDnPKolAnhcZDtW2Bez2KDTdIT6H0iFCqrmzySiFd
	 Tn8zNq5VPxA7GlXx0L4zeIsAzt1CbnwKk3Cv/6zTIKhEnV723x72b5yv5E6kG2TAi1
	 QE6M8iO6ZuXQg==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v7 0/8] KVM: arm64: pKVM vCPU state management at EL2
Date: Fri, 31 Jul 2026 11:51:47 -0700
Message-ID: <178552142335.30097.18179093757678605679.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729131823.2021516-1-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 29 Jul 2026 14:18:15 +0100, Fuad Tabba wrote:
> Changes since v6 [1]:
>   - Rebased onto v7.2-rc5.
>   - Expanded the comment and commit message in patch 8 explaining why PC
>     and PSTATE are copied back on every exit. No functional change.
>   - Collected Steffen's Reviewed-by on patch 3 (thanks!).
> 
> Building on Will's pKVM infrastructure series [2], this series reworks
> how pKVM moves vCPU state between the host and EL2, and stops copying a
> non-protected guest's state on every world switch.
> 
> [...]

Applied to next, thanks!

[1/8] KVM: arm64: Extract MPIDR computation into a shared header
      https://git.kernel.org/kvmarm/kvmarm/c/c0646b964733
[2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
      https://git.kernel.org/kvmarm/kvmarm/c/f88099ad9fc2
[3/8] KVM: arm64: Factor out reusable vCPU reset helpers
      https://git.kernel.org/kvmarm/kvmarm/c/29b2e2ab7fa7
[4/8] KVM: arm64: Move PSCI helper functions to a shared header
      https://git.kernel.org/kvmarm/kvmarm/c/86db2bd7f5f0
[5/8] KVM: arm64: Add host and hypervisor vCPU lookup primitives
      https://git.kernel.org/kvmarm/kvmarm/c/e9f88aa0b16c
[6/8] KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch
      https://git.kernel.org/kvmarm/kvmarm/c/79c3122a1e14
[7/8] KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
      https://git.kernel.org/kvmarm/kvmarm/c/42fe26543e66
[8/8] KVM: arm64: Implement lazy vCPU state sync for non-protected guests
      https://git.kernel.org/kvmarm/kvmarm/c/734dc8c01c83

--
Best,
Oliver
