Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF0B678
	for <kvmarm@lists.linux.dev>; Sat, 30 Sep 2023 18:27:19 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696098435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHjWeUwUzHpdUMgKgpnqE1STeGfAbmIbXCpljrvsbfc=;
	b=xjnxJTmvhvgoi9ivxjvefbvnNTCPI5BKQkMFepeY32S9maH6zpDsqYlJwR9oTZ81sq4Bf7
	PzANH8q4fl9+cVaW6tkaCDUSfZYPHk1/AoWdp8jTSuaUR9+TxXqM3qCZp8FO8GGSadORtx
	j6Z5dJmuc+L2GyBGUKLbVGYKbKYMVAc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/11] KVM: arm64: Accelerate lookup of vcpus by MPIDR values (and other fixes)
Date: Sat, 30 Sep 2023 18:27:03 +0000
Message-ID: <169609840956.1767077.12635408767994539864.b4-ty@linux.dev>
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 27 Sep 2023 10:09:00 +0100, Marc Zyngier wrote:
> This is a follow-up on [2], which addresses both the O(n) SGI injection
> issue, and cleans up a number of embarassing bugs steaming form the
> vcpuid/vcpu_idx confusion.
> 
> See the changelog below for details.
> 
> Oliver, assuming that you haven't changed your mind and that
> nobody shouts, feel free to queue this in -next.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/11] KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
        https://git.kernel.org/kvmarm/kvmarm/c/9a0a75d3ccee
[02/11] KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
        https://git.kernel.org/kvmarm/kvmarm/c/d455d366c451
[03/11] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
        https://git.kernel.org/kvmarm/kvmarm/c/f3f60a565391
[04/11] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
        https://git.kernel.org/kvmarm/kvmarm/c/4e7728c81a54
[05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
        https://git.kernel.org/kvmarm/kvmarm/c/ac0fe56d46c0
[06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
        https://git.kernel.org/kvmarm/kvmarm/c/5f4bd815ec71
[07/11] KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
        https://git.kernel.org/kvmarm/kvmarm/c/0a2acd38d23b
[08/11] KVM: arm64: Build MPIDR to vcpu index cache at runtime
        https://git.kernel.org/kvmarm/kvmarm/c/5544750efd51
[09/11] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
        https://git.kernel.org/kvmarm/kvmarm/c/54a8006d0b49
[10/11] KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
        https://git.kernel.org/kvmarm/kvmarm/c/b5daffb120bb
[11/11] KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
        https://git.kernel.org/kvmarm/kvmarm/c/f9940416f193

--
Best,
Oliver
