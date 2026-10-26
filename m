Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002991;
	b=uqrVPenwxZU9loNXnyXCG6WEW1HYLpQ7pDKuTwNsVmT3xz5aWy1J7Rho5bcoTkIpJRBL
	 naDC/FiDD7ezhevxi2i0oq7ZCJW1QICzkukiGZBih7MC9TZp01Ir9vMUMqii6A5ZEMKf3
	 I4y8injz6UdKU0zsSelilN1w9fYfPZ2j54h51oGXIqJJK8C/C2vpB/jWmn/dZMM1lJKzc
	 hecGKXA4rECnhcWlnUhqc531hQgbhqlzUB/38Zik52FIN4OiYlzP28r2etAGYDBn2GwB/
	 +aNJQdWrExHiI+mjKnm60om4oiu/bz9f7WD77W/FhCxGJEYH4lfnyYdh/RHXZpfDFlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002991;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-SA-Exim-Connect-IP:
	 X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=J6rJ9m2a/zNKwWgYWDs9/d7TuGE7M+e5cj3hCcIOpvE=;
	b=DPU1sPBnUCJVpoDZWZ5r651pnPh02g2fZRC52yM7B0rIH7zgk8X+I7mmNqxqYKXQzdA4
	 BaokA3R8SYMcZHkvEuFF2eewh7DUf9eckIGpvDcca64T8ilPuwOWvcMnKe+XirzX+Oa/F
	 nKcfTqpWJ/iE8vodnr/tJJ+lHsdNAkB4uTJI/tInYnm3lw+MWkb1VMZVYyDt/7Ltanoy8
	 W8noMGX1a2GWVeynGwys0LzJ8YbHzPsa4TSD66FpeUkJfU2N/5f7mhLKNxNZOxvgKEqzJ
	 r7Fd+6B0/+MNMvOhYo1o8KfjORB8zPPRqETiVwcgjMt+OrCGvGWh3Xzm12kezIC1cCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcfYS43j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1447606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcfYS43j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C704C1F01825;
	Mon, 26 Oct 2026 08:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002990;
	bh=J6rJ9m2a/zNKwWgYWDs9/d7TuGE7M+e5cj3hCcIOpvE=;
	h=From:To:Cc:Subject:Date;
	b=kcfYS43jjCMlyXtqJTBicbh2hGtl+bZ9Ap2lxjk/tep9teZZSud0xSHpsY6BBiHfs
	 36BHwMnLYXpUMcgXiPBWVLNXy2HJU3cmUkWm/rPuj2sNGCZT8bj59YYQceR22Mq6dG
	 IuUqb0d6hMdQSFEvfiZcuLt/hfQpaDd6xdnpz22XoxVXLkiouf1qvmJXbR3vHQs6p+
	 f6V+pudR15EOn+2eM9lu40n/B09u6v4O/WoCQ6/64Gs4a1YztmlrlTZXfIkRlZY6fB
	 MdRE3Mg7x1rffHwUVkzdxDKUjSzponDs8BeGBJi3t5FNq6Mp7ifmHL5uzd9D4zkAk/
	 GeKEE6CY9K3bA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLFz2-00000007A40-3Z6o;
	Mon, 26 Oct 2026 08:23:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Reenable MTE on VHE guest exit
Date: Mon, 26 Oct 2026 08:23:03 +0000
Message-ID: <20261026082305.2515705-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Upton taking an exception, the CPU sets PSTATE.TCO to ensure that no
tag fault can be taken while handling the exception. It is SW's job to
eventually clear it when it is safe to do so.

It appears that when MTE is enabled and that the kernel is running
VHE, nothing eventually clears TCO when we come back from the guest,
so things such as KASAN_HW_TAGS will not work until the next exit to
userspace.

This series aims at fixing this. This is not a stable candidate, as
KASAN is only a debug option.

Marc Zyngier (2):
  arm64: Add return value to mte_disable_tco_entry()
  KVM: arm64: Reenable MTE tag checking on exit from guest when running
    VHE

 arch/arm64/include/asm/mte.h    | 10 +++++++---
 arch/arm64/kvm/hyp/vhe/switch.c |  7 +++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.47.3

