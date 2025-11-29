Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947079CF;
	Sat, 29 Nov 2025 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764427531; cv=none; b=s1FOGtw+xScTVEr/og7ILf656Mb3uUJAFVQGTja9jmFzctgI8RJYB3yVijNNiBy+2touxV0JAozsR+82QpPdyZk/X1hotXvinfZ0iJqwWMPSfJV6NDGuaev20YX0hLycuz8t+i62SZKFB3wppDw5Hlpwn89rVz+KYTRFto2TFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764427531; c=relaxed/simple;
	bh=J8YgpBDKoIkE30i8e29RJl8Adbc8Y+aT9MBBTzbD6IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvwfFncFd6Eep3GUnNLXOa8+CxB+6HUTU2LBdAYZCtejR57AzW2yUx5o8zmMn5lq2MPNv7Rt3TDoZU4peeazD7znyKsv//C1tdaSsXuLLt1RQyp0c8HSdJmzMpOxk1uMhMW8A4klPUDLxTEWDuOhbVA/40JjpHN24SpTA5ugyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5yIymrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5yIymrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C086C113D0;
	Sat, 29 Nov 2025 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764427530;
	bh=J8YgpBDKoIkE30i8e29RJl8Adbc8Y+aT9MBBTzbD6IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5yIymrvlmrVZV10Kyo9oayMygRW0E5mnnRK13jq4+/1dlZaKWyhRghI6fcQF1AUh
	 gIg70MuCIQXTFu48m61Iu4UQzzuklOVsdvjttpsHFr5h9+zACeGEKgr8EE3u35qsuV
	 RwGhNeRVYqxXaXfZQJKelZyG4atkiLifG4OJToXb9dxMfux6OQPeuSnfK6hErz3LDx
	 xF2eDDrL/oycQAR0Mpiu3IF9S8kQOAnjRUiyWi23d0Lgbhd8ifRMy9syzqEjtNqWv0
	 ccDx0jUjvgjVGAR9B5+0bs5yBxVqyU+yOkIMujGSYIsdx6UseN7OHZCZjXrcTzDT5L
	 aE8NNQfziCHng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vPMCW-00000009HnQ-26an;
	Sat, 29 Nov 2025 14:45:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 1/4] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
Date: Sat, 29 Nov 2025 14:45:22 +0000
Message-ID: <20251129144525.2609207-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251129144525.2609207-1-maz@kernel.org>
References: <20251129144525.2609207-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 are currently represented as unordered
enumerations. However, the architecture treats them as Unsigned,
as hinted to by the MRS data:

(FEAT_S2TGran4K <=> (((UInt(ID_AA64MMFR0_EL1.TGran4_2) == 0) &&
		       FEAT_TGran4K) ||
		     (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 2))))

and similar descriptions exist for 16 and 64k.

This is also confirmed by D24.1.3.3 ("Alternative ID scheme used for
ID_AA64MMFR0_EL1 stage 2 granule sizes") in the L.b revision of
the ARM ARM.

Turn these fields into UnsignedEnum so that we can use the above
description more or less literally.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bba..9d388f87d9a13 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2098,18 +2098,18 @@ UnsignedEnum	47:44	EXS
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Enum	43:40	TGRAN4_2
+UnsignedEnum	43:40	TGRAN4_2
 	0b0000	TGRAN4
 	0b0001	NI
 	0b0010	IMP
 	0b0011	52_BIT
 EndEnum
-Enum	39:36	TGRAN64_2
+UnsignedEnum	39:36	TGRAN64_2
 	0b0000	TGRAN64
 	0b0001	NI
 	0b0010	IMP
 EndEnum
-Enum	35:32	TGRAN16_2
+UnsignedEnum	35:32	TGRAN16_2
 	0b0000	TGRAN16
 	0b0001	NI
 	0b0010	IMP
-- 
2.47.3

