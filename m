Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A219A32AAA8;
	Sat, 19 Sep 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789841478; cv=none; b=V84xrSXj/7qEFPXxbPi4zKGSl4pZ1SekjbzBKsfT38u0Y6fC60FcOrWCRjDe/78qvPzZ4vcb6kPTtmGiBOOtAKMAv5hgF+Eva6LS74SZgMJjqjoG8mWtUZsupZvDIcarQRWXriddVQ+ELx0BHXatjMiUB//FaXEIwnyBKZrlpYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789841478; c=relaxed/simple;
	bh=OzsqDzyleP0kWw9mJn/AoFDmTbY/lwfcYFUdNZ8b3vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dD/o9KNPyNQkyQGdRcKnqDqURR2GnLFJBW7FRkm7GhQV7nRAYLiy9X+QcYJNFJSCoT1KsezxbAL9Snb+/7VEzyKpo5dptMNRdwcEEDTSUghrWeA6ZksjVtVw7SsNlvQznZgz4Tbz7VzCRwjWn63TlWaeTbInEZ+a7mynBaK3VK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQq4YRL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQq4YRL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C7C1F000FF;
	Sat, 19 Sep 2026 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789841477;
	bh=i9vVM2tMTDcLQ7MTmdYRaKZNtkheWY0pH5YNF/l7tWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQq4YRL8vpyzhOa3jR+GwyVRYi9UjMAhG3+Ueip91Q+T0OctKW9a/9ofnXFXcR35Z
	 MwaUC1lnh9dIsnkhN6CUgiOaZn8U4zB5v/aq2/jF8JsvCj4cSWGQBoZCsi3c6fgtfl
	 pbWRHt9/4D66jh0HjRdxo2Q7isbXsNlFPJ3WERYPBAtDyItbnoBoRphq9wXpi6U1vQ
	 qrV9rQJW5JoMaq/UMooOQtToSQOlj/ng8xe1tvdS/kLPq4ZtwVmxSwTm0ikdzLHYpY
	 /fynCZoYyZTtlr3vzfsXV+YLCeN1xVOMNncmXhGkq7Cj0TwuWjuuyM+TmJbKfmXuXA
	 kkMVwbnhVf7wA==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
Date: Sat, 19 Sep 2026 11:11:14 -0700
Message-ID: <178984145401.38162.12449211285441501967.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810005616.13227-1-kmehltretter@gmail.com>
References: <20260810005616.13227-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 10 Aug 2026 02:56:16 +0200, Karl Mehltretter wrote:
> The consolidation of the breakpoint and watchpoint register accessors
> switched DBGBXVR<n> from trap_bvr() to trap_dbg_wb_reg(). The latter
> selects backing storage with demux_wb_reg(), which only handles Op2 values
> 4 through 7. Since DBGBXVR<n> uses Op2 1, an AArch32 guest access hits
> KVM_BUG_ON() and marks the VM dead.
> 
> DBGBXVR<n> aliases DBGBVR<n>_EL1[63:32], and its AA32(HI) descriptor
> already selects the upper half. Map Op2 1 to dbg_bvr[] alongside Op2 4,
> restoring the pre-regression behavior.
> 
> [...]

Thanks for pinging, this slipped between the cracks.

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
      https://git.kernel.org/kvmarm/kvmarm/c/239763bda716

--
Best,
Oliver
