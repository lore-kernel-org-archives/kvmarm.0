Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3DB20E718;
	Thu, 20 Feb 2025 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740069780; cv=none; b=Q9NJl1GEgNXWslGKf33Ra8Dt9ZnAXTnPl5lALCtQ3vf41jMMzg58GxnRI3KxGLT3v6EvYQHPi36oUd9HUFPy46TMeuMoSCB0DsEVwHqanqpPBNY4XuT1qbOCHsJOBvuRO3hebDmR2d5FwpC6uMjHTE0DtZNbTbzamENxxLbcDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740069780; c=relaxed/simple;
	bh=xoszGfeQD/BBXn5mUBjcDckmqNtdwyHV3ywQG9RpC8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gT4FdY0K+xH7nV80Kj4x6CE9UbRdnqp3d/5clEzmv+Q2hk5Jirgn9pj2gs/gkXDcnpRVWBbrtpqRCntIuVKpNAmewxGG6u9xC1EqX26SrakvUf+KEzFUKQr/jTjrwKxfb7s187cHGI0vZQzsSp8lKuRmvOeOLzqQkSomE/jZSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFqokkF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFqokkF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443F9C4CEDD;
	Thu, 20 Feb 2025 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740069780;
	bh=xoszGfeQD/BBXn5mUBjcDckmqNtdwyHV3ywQG9RpC8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFqokkF1Ym6xjnfDhFQGElT6/OqTuN9JEVX0mK99Qi6oW6ce6P/zB0HKyl4IQ0na+
	 u2OvSoh62Eda1t814xKVwn6whhphf+Ok8UfCULF+v+dg22RWAdaxWgo0XwNS4mFC4t
	 /386pdCHPlw9MhvRTbnSzfGdcZ8hh0ZeGlVAQ7Iaq13SaPWO0yu+6BeA+CGItmm9Xp
	 VGzZ2U3/C/BpVWBVdPlYy49U91rBJUh6SGqT3CoLKbwWmQbwrfBcPoJBJY5JYYPRSQ
	 ie6wRwGHsRWad9ILB57KbQywwysZoZKRfB2ogNpaWJbzjaq7PdpRpWrYvsNcH9EdI/
	 3xOucnOZL5OzA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl9da-006Hgd-Ao;
	Thu, 20 Feb 2025 16:42:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	stable@vger.kernel.org,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
Date: Thu, 20 Feb 2025 16:42:54 +0000
Message-Id: <174006975563.555960.15085833159215599018.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219220737.130842-1-oliver.upton@linux.dev>
References: <20250219220737.130842-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, stable@vger.kernel.org, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 19 Feb 2025 14:07:37 -0800, Oliver Upton wrote:
> Vladimir reports that a race condition to attach a VMID to a stage-2 MMU
> sometimes results in a vCPU entering the guest with a VMID of 0:
> 
> | CPU1                                            |   CPU2
> |                                                 |
> |                                                 | kvm_arch_vcpu_ioctl_run
> |                                                 |   vcpu_load             <= load VTTBR_EL2
> |                                                 |                            kvm_vmid->id = 0
> |                                                 |
> | kvm_arch_vcpu_ioctl_run                         |
> |   vcpu_load             <= load VTTBR_EL2       |
> |                            with kvm_vmid->id = 0|
> |   kvm_arm_vmid_update   <= allocates fresh      |
> |                            kvm_vmid->id and     |
> |                            reload VTTBR_EL2     |
> |                                                 |
> |                                                 |   kvm_arm_vmid_update <= observes that kvm_vmid->id
> |                                                 |                          already allocated,
> |                                                 |                          skips reload VTTBR_EL2
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
      commit: fa808ed4e199ed17d878eb75b110bda30dd52434

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


