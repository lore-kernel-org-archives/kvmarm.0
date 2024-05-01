Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99751031
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573770; cv=none; b=Oy3v1zAn/SdoKZsYmhEbbzC8VhlYoi4TFvnLH21y1vyvQu3Un/9GSgDHDNMLD4ZJYszxVDtZEgS4vMW2JKOatI1KHJRspBVPeC026IylZB+V9couBWi9gH6+jChov7CDxBmpcLkZB2dfc1QmCRvS+RXBudvM/rXeotSr917Xi2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573770; c=relaxed/simple;
	bh=fkk8MFKS3Pc1HJRJ/0KUrFBJ8mTlv5jTOMxB3Ep5dgE=;
	h=From:To:Cc:Subject:MIME-Version:Content-Disposition:Content-Type:
	 Message-Id:Date; b=dfjgYTB8OJrsUqxxabkrqkLfCcwNf1toy97uIeyRUJvrcSLlNgZEqR8EusAbEmtkNc/CTfCYvy9YacdJ1PXvp6h4nx4j3HtG2ztkNUcxIA09pTKq0LA5SiqE8hLUQ0kbwYqD2mbY/GPXUAZ2tbNfPk+3QMigl92l9qg6eERx4jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=jxtjXiI2; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="jxtjXiI2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=flHhJZtmUWrbgiq2IRb/yn3nOSgZGp8qfx6LBezbmgo=; b=jxtjXiI2xKKvuMZ1Ck4uTcR7RZ
	8Vo41x5yX6zqYsHr9liqQ5rik9zXhpZ0XxmhlgYEEi/W6T166IBPud+XYiO5FjXrCUpbRW03dnRpd
	jvquieJpwMMyhdoKxssD54fJDCkj+0qjtiiDYIim0ZsqM/QzCu/bE4Qq1b1Hh38oMQXzEQr+Ei3Bw
	Bblkn+PnbZpZoGG/xveFDHbqUFf8LbKKtE5xdx0I3rWet2PVzt+SO1nMb4foVap/8Y9Ojhe7lx0+h
	wY+oiUx++yLS8HodS0zSVfDpg6eXFzCNDzg0msVQlMT154r+pNi1kOnHpBDB38UDe+6RIi6E61EqQ
	OyIIt8cw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43310 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1s2AxD-0006HJ-1P;
	Wed, 01 May 2024 15:29:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1s2AxF-00AWLv-03; Wed, 01 May 2024 15:29:05 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] KVM: arm64: remove duplicated AA64MMFR1_EL1 XNX
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1s2AxF-00AWLv-03@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 01 May 2024 15:29:05 +0100

Commit d5a32b60dc18 ("KVM: arm64: Allow userspace to change
ID_AA64MMFR{0-2}_EL1") made certain fields in these registers writable,
but in doing so, ID_AA64MMFR1_EL1_XNX was listed twice. Remove the
duplication.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3aa2cedb283a..0cc289b17665 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2338,7 +2338,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR0_EL1_TGRAN16_2)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
 					ID_AA64MMFR1_EL1_HCX |
-					ID_AA64MMFR1_EL1_XNX |
 					ID_AA64MMFR1_EL1_TWED |
 					ID_AA64MMFR1_EL1_XNX |
 					ID_AA64MMFR1_EL1_VH |
-- 
2.30.2

