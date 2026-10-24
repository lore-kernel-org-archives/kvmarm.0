Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792824959;
	b=KQINTwUrWUEsHtvuHI/SM+hdZhjtt++r9xAevtSi+D8H6kiiO0vfryzyAgx4/bK8bLNK
	 FUtMLiPJGImpRKuCQUIjHeYCSum9GEBE3VtQI0RLy8X+rtLGwdDjoQja1eKtpbFjE2jYi
	 OH74jF9NCJ+IMybJ6zbTveWYniORezAcFsLzGC6zztU5KZA2wyMIceJulZ/vmUX5VuTY5
	 E5qOrwQSYCJDK0k3xC5MNk5VQfDul2EK22FRxfdCET6iWjki0DOTQQeZeg6uvMi2SG4uv
	 XDv8V7qyJvSi8Av4eu6rhci/MoyBfZpMUo9P0e5d7XzV9fisoYyPr80TGT9Ld+blP0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792824959;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6+VMZP4/imQFRcxhHNIAtyuoExenFQEkCplGv1ihNMc=;
	b=g2I51h2OvyNACFk4P3bgBBg7kpH4NxyYn5nQFii/MVo3Gvx56EOX58oAkEU95Sp32URB
	 RqoG0DfIMnZG55phe+8AKJogybZw8cY136oo3BHOzd+4RBgvDK7NDORisKFTjbwzJSfhO
	 H8aDobGNoRcunKYPn6zorIPGialZWeeHxbHqQim6IMKTnTKJdxGtYYJ/yV80LckD5OhOe
	 9rAjeLWI1M/U11NN+4vI21f00jpvg4a9NnRy4KZGmiyNLbFUIvyVC3zkAEkY0gePJ5PTA
	 FdGRjnWeIsi8UOAMlVaRAMST1fcOjNEZ60dVntXysV6cwJE4zBO0UMBprGyVwYiHUsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWG1PEKB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9A606A31B;
	Sat, 24 Oct 2026 06:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWG1PEKB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849EF1F01825;
	Sat, 24 Oct 2026 06:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792824958;
	bh=6+VMZP4/imQFRcxhHNIAtyuoExenFQEkCplGv1ihNMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cWG1PEKBSyP/Azxo7QWRPw7O0At9SIcnBK3p6Ebqohr42LjPoUDMYXSIkuSkIiMrh
	 feqUkXJNYkHqoQYkAtRJBSZK6VKS0PSRet/LOOM65IynGSY2Z7egGmaT3d7mB8KxpF
	 6FioWI4KokejBGS/RMK7Hm3nSgyL48YI2q9dG5xPqln+rkVk6HM0ow5cBn85lDmOHa
	 U0s98dmuTcGS4Hm7uSpFG9lSzOCoV5Ke46g466114qOX32mAwnpGwhAzCbYMqpaJUX
	 esiVY6142btfJ+pdnDPBUd27FzKqA/jhKEU3OuRNsp8zEvF5r95JYT6V4GTPum4udX
	 TEADT+I1GCSDw==
Date: Fri, 23 Oct 2026 23:55:57 -0700
From: Oliver Upton <oupton@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] KVM: arm64: Preserve level IRQ re-pending
Message-ID: <atxWfRsNNK8vdeSr@kernel.org>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
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
In-Reply-To: <20261022064628.4206-1-kmehltretter@gmail.com>

On Thu, Oct 22, 2026 at 08:46:25AM +0200, Karl Mehltretter wrote:
> A guest can set a level interrupt pending again while handling it. The
> GIC records Active and Pending and delivers the interrupt after
> deactivation. KVM instead drops the second pending state for both the
> GICv2 and GICv3 backends.
> 
> The VGIC keeps software pending state outside the LR because commit
> 67b5b673ad4d stopped placing Pending and Active together for level
> interrupts. When the LR is folded, KVM cannot distinguish the pending
> state used to populate the LR from a later ISPENDR write. This series
> records the later write and preserves it across deactivation. The last
> patch adds a two-vCPU GICv3 selftest.
> 
> The awkward case, and the reason for the RFC, is a write from another
> vCPU while the interrupt remains in an LR. KVM cannot know whether the
> write preceded or followed the guest ack. This series preserves the
> write. A pre-ack write can therefore cause one extra delivery, while a
> post-ack write is no longer lost.
> 
> The exact alternative is to stop and synchronize the target vCPU
> before applying such a write, as the active-state accessors do. Is the
> conservative replay acceptable here, or should ISPENDR pay that
> synchronization cost?

Yes, just kick the target vCPU out and sync the LRs back into the VGIC
state. That's consistent with the approach we're taking everywhere else
where this sort of issue arises.

If we're lucky the vCPU is just poking at its own redistributor and the
synchronization is free.

> The issue was reproduced with Zephyr, NuttX and RT-Thread guests. On a
> Raspberry Pi 400 host with a GIC-400, each GICv2 guest handled the SPI
> once before the fix and twice afterwards.

Have you configured these guests in such a way to reproduce the issue?
What exactly are they doing that is susceptible to this issue?

Thanks,
Oliver
