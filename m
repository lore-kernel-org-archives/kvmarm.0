Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016080;
	b=MGjFoGCAE1RFwmXvBi8A7jhbM+SasmnV2r+Wm/5ADx6bpVb5K/cTEHY6osPYW0b2ECON
	 M1ZPgT8FnRAS1MBL1W1NbvYqWKFBYn6pT6SnwQqyImxJ8v12W5ysUGoQQiCILODzvviuo
	 QaNGeGc8LQU/q1SipUjK8jH4QLsH2PPRnebx+lkn8RlyQFmuPEANklKjKX9BRlQTqUPsL
	 2eCm2rqxstuo0pbLNA6Uzt9TPTIOz+UBG3p9vdqZ6WXDvLhQICGPNs2WYnGthWOiURn+E
	 hEG1T34OGOCZmG4eV8GgXkHoHfT8ZT574k0zWABjhBrpsg+ny7VPk532lYbBQ+ubY1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016080;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=dpLOTP82eRJvi4Uq9n3UH445ps38/OhN0J6cr44J4xk=;
	b=WaSWTzNW1rEv9griFzKGo9A+KWqvINgy4XMwwt42qJgPbhIjEVcXhkQWRgREMBwTG94m
	 XatsJ9yJXdF5HC1LfRLQkX8SKMoXHpNi+qcHx+c8meyBkhWRmYtcV8oetmhftF/KDHtu6
	 Bw30apufw1OKo+NbA3GB3lQvCd6M7tJGBbtAMl2SXqZXfQtE4pz9Fb5kim1WlnMP4G/Ez
	 VKubmV8Y3RxzN00HyW/AeKMcSs/2LbdnAnE+jUgB7Tu8qtP6cUv1AMG6O4wta7uvDy1cr
	 70VWvEqbfbF0ZLlvWEaTgn9CwRsdO03/Kvtz+/jhlznNTEFqd/c9eh5HJ/Miq4ehc0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VigbS57Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A113660A2611
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VigbS57Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855C01F031E2;
	Mon, 26 Oct 2026 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016080;
	bh=dpLOTP82eRJvi4Uq9n3UH445ps38/OhN0J6cr44J4xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VigbS57Y2M4p7kdTrkQ5zk+RxRQbAKeILy0kPiq9BCs7kYiZuPU2R7XNOYt/bGmuH
	 iRbMcRAPs7Of86JVjOJbufl10kk8EFsqjUmpf3gzi1T/2IjUMq9m0viEGOV4lLBtIZ
	 rM5jrp9dSvSUXb/TXc95RJ4xHyasbgKECyMEFjyeV0dScTh/B6IAkjDSAiMcc8pcod
	 KoXfMZaHUnt4cpdCNAna9zyl6IzGtIGTNTNx+XMy7o9O2Vs7mWv+4A+MAl7D57kxfl
	 Zwl/FlvEAi3+HyZuLcrzvU2dD91K6TqntoKb7l9OwUdIbcjekKUqgxvJtuSPCydvsU
	 CNgKHKoyVCwnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJOA-00000007Fr6-2moL;
	Mon, 26 Oct 2026 12:01:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v1] KVM: arm64: Move pkvm_selftests() after all CPUs have initialized EL2
Date: Mon, 26 Oct 2026 12:01:09 +0000
Message-ID: <179301587192.2527370.2928933252575532589.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019094258.1582756-1-vdonnefort@google.com>
References: <20261019094258.1582756-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 19 Oct 2026 10:42:58 +0100, Vincent Donnefort wrote:
> init_subsystems() installs the hyp vector on all CPUs. By running
> pkvm_selftests() in init_hyp_mode(), there's a risk for a migration to a
> CPU where the hyp stub is still in place which would fail to run one of
> the HVCs necessary for the selftest.
> 
> While init_subsystems() is the earliest we can call pkvm_selftests(),
> move it to finalize_pkvm() to avoid having to export the selftest
> function out of pkvm.c.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Move pkvm_selftests() after all CPUs have initialized EL2
      commit: 0fa4e506a054702d03d46aac9272a37f820fc2e5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


