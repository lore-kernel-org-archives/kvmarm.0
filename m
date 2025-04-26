Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9D24C07F;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670533; cv=none; b=GWZlfsmWFRp+otYS+dHRBqXJkxDASQfFMAQWCzyXTyy227aOe8aKscXrybf79i53RufZVgOvYNK7+ivCDtF4qrxLo0qINjOEiLuSSmI0l6V7aKj159CkpcKvyQns/BXtMy30GLyr+z/9qcVOQZRGD/05ba+870GNQHuf4h1rjF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670533; c=relaxed/simple;
	bh=9pgxiWCL9Lomr3yxaonxBwT8LnBlQFBPORiK3/1n6t8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vE2/fh51QG7FMrRJKUpBQaA/qhXq8tWUR7bC/xWgIEHTW4sBLvfNUw50WyQ+NABVl2r3ie2IJt1NunwgmFqhtZz64MJEj4DuWIcS6T1jsF2zvCnQ3gK9ryakamYnOV5QUrKJUNh5QD9kFshC7KL/Cp6R0jHjyPd1HzyYyHgEhN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAnRQXjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAnRQXjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C061C4CEEB;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670533;
	bh=9pgxiWCL9Lomr3yxaonxBwT8LnBlQFBPORiK3/1n6t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAnRQXjS6kf99FFOouDPsD0Yjqc64sVm83Fpuxdsl1kucZwDObM3gi8ZRlG9NJ74p
	 iCni4VXgsow+DrINrvVEpITtr56RKH2GYgzc6vAwLWMY6rWPIzVEgv7YRx684VyOK3
	 mjic6d0MFJaEXzNOiQMKWo3hRmJEu2n9AjflhY/px7shlRBP8scDpybu0IyTW82ucg
	 rXkJQMgH0GBsDrExGHItYboHc3oLmpV7yogQ/PwUZigTldvq6kCvnyd2ZeuIgt/gNv
	 BqcC/NKIu85p1nc/KrNqRjxnDc5oFKV/SHKuPf2G5aANTZWo0D+ceirO8kuiqJrMsh
	 x7EjY/MPborsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeJ-0092VH-1n;
	Sat, 26 Apr 2025 13:28:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 10/42] arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
Date: Sat, 26 Apr 2025 13:28:04 +0100
Message-Id: <20250426122836.3341523-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the new CMOs trapped by HFGITR2_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a943eac446938..8908eec48f313 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -117,6 +117,7 @@
 
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
+/* Data cache zero operations */
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
 #define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
 #define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
@@ -153,11 +154,13 @@
 #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
 #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
 
-/* Data cache zero operations */
 #define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
 #define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
 #define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
 
+#define SYS_DC_CIVAPS			sys_insn(1, 0, 7, 15, 1)
+#define SYS_DC_CIGDVAPS			sys_insn(1, 0, 7, 15, 5)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
-- 
2.39.2

