Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696C01C830D;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695232; cv=none; b=dhp3yAQ8DIQKDcteGbuaaocE7NPThKsDrQ+C0rEKqaW3LvmKAp9tZaGon22LjI3VAxeNxHLaCPeIMgS0kJHpcV4FUhMs707nBH45u20CE7YN51T193I719iJ1/jLcTLaZTqg9hfvmJmIPNIxZ9O1ygYM9JtRB2W2Il9GoPyfWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695232; c=relaxed/simple;
	bh=2p8gtbngTQycKdtoWZv63noAS1lUhgvWdrHkUVI0VQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jP5EUdYmDVbRtIeYJCeg/so1n8Sbe9mQBboQtKOKLKaR8gMTZcOvr+AnfSpBgQ4m7psTkkSHpKs7AmglaaS8ycbbpZmPNAwQNxrEaeyIk3/DvhryNRMCnYjGnCDc8PmsZ1P74VCV+S2ZW1hNmYGro6Rb8W3XyP21TsxiqpP9qVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epIvBurr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epIvBurr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16BBC4CEE9;
	Wed, 23 Oct 2024 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695232;
	bh=2p8gtbngTQycKdtoWZv63noAS1lUhgvWdrHkUVI0VQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epIvBurrAvY5MNIx7KS+hXHCQnGCXnVbmE5HDQtC8CRMJnH09GHk26KC+9e3YrJYg
	 6taX7/eiaU4SFIDBGbwsei3ET/uPNw0VaH+8j9u9WW3urWwHyQE2q0rbMH8ys/6ACC
	 rYbZ4bQEF5tMGFWEPPgoKRifn7xFT3oIOHidzWS4cUXCWeyQ60RLabJ4rxDX9JGIw0
	 U3BdS47cHkkaPxaFb9VrrQ0wDS9VttQYu9OkoDK+nWuCl0wptqY55Kfg1QeBMdOcyX
	 JrWFTYl9+C3j0i5t8ETo+RtS7oREj7heJrvlzCtsMdwdpazHvFO55k7jh/4bNV4sXa
	 Sv97Sy8nHlXjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckA-0068vz-3b;
	Wed, 23 Oct 2024 15:53:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 03/37] arm64: Add encoding for PIRE0_EL2
Date: Wed, 23 Oct 2024 15:53:11 +0100
Message-Id: <20241023145345.1613824-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ee3adec6a7c82..3c812fd28eca2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2882,6 +2882,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	PIRE0_EL2	3	4	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	PIR_EL1		3	0	10	2	3
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2

