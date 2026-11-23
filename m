Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461924;
	b=CPn0luUmGPwHjEQAm8NLlihEAoDwONMdaC96dxEEtKbU2o/T5I+3y66bztZOMjzYpT6J
	 JKRwD9oytKHdGpAo0vxPFfD4QxOvJA5Oh8M8oVx1NvAx8G49jvvdlJdLg5lVbiNVTlpcd
	 Unl23O11666oyrmia48SuDWQ2+1C0oplhNGuHBMlFKxF9O8qbG309bkjSnY4cGBMd5u4E
	 it1FrUYl8A2aeKoXE4l84nCaGGQQ04hPufouwWKnYK5zejODq4lvCvweP+NYe8MvO04wR
	 ljDyjCsEqJaVlq3PpB32qUfmHmbqE60359jnRYYbqoIZi+LuyFRAAW/XdD41GcvbG+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461924;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-SA-Exim-Connect-IP:
	 X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=6Or7n0jizxWVJyA7jIKPA2rACgq3R3VfoNnp+Kk7c7w=;
	b=tXcLekJkMfzZrtiFeCrE0oJ2gIWPdpkH+Hvat9/e5NYzmiOJ2E+ecymTF/HxnavKvf2F
	 WlCBAc8zJYSBeIScKY5fCxE+ISDMhtLONmwoPy9IZ47iVK6w9VjSab00slvFJUoODQhG9
	 Z3+R57pDNe5mWXZQwDqR4pMa4cPtt3YYbpxK9Wr9IffmyVhB9dUwavoiDd5YpOZYs/6W9
	 jfO80y1zuZWOpCVZJWzYiCG+PDkVHlZxtCol2fd1ivfMVd2ERM3G3fNNopoGa5AsNDp1n
	 NZbazmmzohqGhN8awJWa0SplZLLrpF+ElhOpnXcKv1dwj0ctUimFc7JOcDyD3plF+cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvWV0NJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A0606A32E;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvWV0NJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323CD1F000CF;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461923;
	bh=6Or7n0jizxWVJyA7jIKPA2rACgq3R3VfoNnp+Kk7c7w=;
	h=From:To:Cc:Subject:Date;
	b=VvWV0NJdtqB/ylBE4iXOw7thFxymk5LTD6vQhJaVPgpc35eVUZn3El30g7HAhnKCV
	 8ErSNcY+02tLGFuMkq3mi2im9gXWo4LhUSdrMkzpkSyvSTzeIDetbb7GJxcbkHygs8
	 BlPYZoBX4lI7olq8TxLoi94Z1Kf4BFyqkJn1WRItvDYupl80mXFz9WxmpO3S+W80sL
	 HHPJCDvrXoJpK+M5uhaGR1aGAFlBiJ8Qp1HGv8cMZYevwIfGse8cfp5wnWhCKK/WVa
	 QGTiKhU9u9PLqB/Jt5Ir0zXIwv41AfAx8A2i90Z4ObCd1Wk0te9kZVwVxBptz2Hq8N
	 sOML+uHsNOo3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xVZfF-00000002A6V-06IM;
	Mon, 23 Nov 2026 19:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Convert GIC idreg sanitisation to the confic framework
Date: Mon, 23 Nov 2026 19:24:54 +0000
Message-ID: <20261123192457.8700-1-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having started adding some sanitisation code in the idreg department
with ID_AA64MMFR3_EL1.S1P[IO]E, I'm back with some more and trying to
wrestle the GIC into submission...

These patches add zero functionality, but aim at setting the basis of
a much larger sanitisation goal, where all idregs are checked for
consistency and the resulting constraints used to enforce the other
sysregs' behaviour.

Patches on top of kvmarm-fixes-7.4-1 (the only one that is currently
in Linus' tree...).

Marc Zyngier (3):
  KVM: arm64: Add enum support to idreg sanitisation
  KVM: arm64: Add GIC idregs sanitisation to common framework
  KVM: arm64: Drop open-coded GIC idreg sanitisation

 arch/arm64/kvm/config.c         | 100 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c       |  45 --------------
 arch/arm64/kvm/vgic/vgic-init.c |  31 +---------
 include/kvm/arm_vgic.h          |   1 -
 4 files changed, 100 insertions(+), 77 deletions(-)

-- 
2.47.3

