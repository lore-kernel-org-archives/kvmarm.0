Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B5E42A9F
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728380483; cv=none; b=lyiJF2kuO4d5VVOE5+v/baGkjZNBLDwTvE3djOJuputeTKZYR0c/SZA8hSM+dCAcDlo32nDx0nJ+cuHuZaSUfxA/0NNTHJTrTp1VRxDyrC8CzQwb2PHABAcAuaoRCMuOJpA/xyReXFSum+L/2WBn8b1CjaHOx5aZJr5L7beqdlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728380483; c=relaxed/simple;
	bh=dKazElgAhucRn3LjYg9PXDGARuM4GnbpP3wOWcgiY7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYArmXwVw62vVHJTZVM/eQ6yCJBITeeDN+/wU2EaQIHkSR64ji867hlcUyiRPp/RvRRlh8sgNb8R6VTTqLLEs9V3wdYqrzbAZQNTpPuit6hhPpxVHhtTR9iu6i1hID4HlV/HpCjP+buWLOBcr1msDi+quX4a6FP8fIcHU1MrlRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nno7K/Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nno7K/Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0771C4CEC7;
	Tue,  8 Oct 2024 09:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728380483;
	bh=dKazElgAhucRn3LjYg9PXDGARuM4GnbpP3wOWcgiY7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nno7K/ZpiJcRr0iZNQUfo9XLEV8UsYrZyisJXAVGupLOiCIhpbT59geHpQSs4cG5b
	 mD9SiyOwi84ShLMpHeXUPMSCF3LCmsxMkpYPAqLWwyNUS3NYsHAqCvqGbIkQBcVWbg
	 X6+PstCzzCP5FOtECzeKo3ST+Vdaln6nKzUjS8tlIfeMrK7IeUnfUXZjZ7lW0J40Vd
	 tbdXrBIbQZGwoLiFSs1QjEJMTi8dCPqMf16DsP36SNFzM9Dsrkh+16g8jX2bW35vG/
	 08+S7v6SihnXZpd7zyqbYxntSttBsL4MjGHv3eUtIr7vqd1rrcq7sOWlaRsTO3qeBw
	 WzReTLw4VOWFQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sy6iW-001J7O-PH;
	Tue, 08 Oct 2024 10:41:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: nv: Fixes for stage-2 MMU recycling
Date: Tue,  8 Oct 2024 10:41:18 +0100
Message-Id: <172838046106.2971841.480215279304860931.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241007233028.2236133-1-oliver.upton@linux.dev>
References: <20241007233028.2236133-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 07 Oct 2024 23:30:24 +0000, Oliver Upton wrote:
> v2 -> v3:
>   - Avoid 4 byte hole in struct kvm_s2_mmu (Marc)
>   - Clarifying comments (Marc, Sean)
> 
> [*]: https://lore.kernel.org/kvmarm/20241007164256.1795250-1-oliver.upton@linux.dev/
> 
> Oliver Upton (4):
>   KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
>   KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
>   KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
>   KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
      commit: 6ded46b5a4fd7fc9c6104b770627043aaf996abf
[2/4] KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
      commit: 3c164eb9464d39ba339c1487dcac0dc9508e03f0
[3/4] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
      commit: c268f204f7c5784e84583c1c44d427bac09f517a
[4/4] KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule
      commit: 79cc6cdb932a5cf1a1ee05f6de12a7d102818d21

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


