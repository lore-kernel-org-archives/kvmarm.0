Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7229A23C38C;
	Thu,  7 Aug 2025 07:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754551299; cv=none; b=iRHVY9AEaM54Uxm0NIzCp2rn9d1XQKSS3v0Dsu4g7uwWe3c8tTIuT6LSyVTp4ptWAG012eHF9Idonbtvzffiu3T9VNHnTJ1o1SFUwvRmf16k3Si/e5mk5UwHgvQpkxwe7qjcnlghakdasAJI/r46EEUIjUA1vY+FpkwBVRZzsrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754551299; c=relaxed/simple;
	bh=l67ps6XMJsj22L/0eqwK6V7mVq3B1+8/YAu/wUCLpl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B9o7ze/w0ZUmogKm5p6nh6TEglfifpfnucYOoHkrUj6dtURi55vFEsM2LsgXdMWuOOgV1YGKJB4umiWoO2B2mcmMosyeap/g2zTAaKJ1ITt40aS2AJuYdHLrKx0x9sTPbQSaJzhCCXbEKgYkPocfVWeXS5g9K6aEXJVSVxXZ5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyopB+dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyopB+dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D83C4CEEB;
	Thu,  7 Aug 2025 07:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754551299;
	bh=l67ps6XMJsj22L/0eqwK6V7mVq3B1+8/YAu/wUCLpl8=;
	h=From:To:Cc:Subject:Date:From;
	b=XyopB+dEl+ZVYHiIdZKgbDzNPDA3ozqq6SkvPzFse7qJJIPKPKUzrzXkMMJlH9TxI
	 ZbBsdW7Yseu6vrN7K4xh+fj1ixWfbRqwsqtXB1luq9TZbkA+i2KhhLpLEPAjfICb4p
	 o08jNdQbo3FHPHTdPHHYw7wtwiW12pEepdEJXCTGgwrZuQdBzbtJgl2711aMe7LRT8
	 4UfzTBSEwvEmZ11AQ/ZSQrqft2xR0Mc2uZiRMebWtCpy/GWMfcPcmCQ5uVVrgH527U
	 chlAcQqbBEaZAzpUOOJ68Gb2+lcYMEyX2iwAT4ihfSsaxYGjwUDNeruzWK7K4xezjo
	 kAl/pUy6krLSw==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] kvm: arm64: use BUG() instead of BUG_ON(1)
Date: Thu,  7 Aug 2025 09:21:28 +0200
Message-Id: <20250807072132.4170088-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The BUG_ON() macro adds a little bit of complexity over BUG(), and in
some cases this ends up confusing the compiler's control flow analysis
in a way that results in a warning. This one now shows up with clang-21:

arch/arm64/kvm/vgic/vgic-mmio.c:1094:3: error: variable 'len' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
 1094 |                 BUG_ON(1);

Change both instances of BUG_ON(1) to a plain BUG() in the arm64 kvm
code, to avoid the false-positive warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/hyp/nvhe/list_debug.c | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/list_debug.c b/arch/arm64/kvm/hyp/nvhe/list_debug.c
index 46a2d4f2b3c6..baa6260f88dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/list_debug.c
+++ b/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -17,7 +17,7 @@ static inline __must_check bool nvhe_check_data_corruption(bool v)
 		bool corruption = unlikely(condition);			 \
 		if (corruption) {					 \
 			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
-				BUG_ON(1);				 \
+				BUG();				 	 \
 			} else						 \
 				WARN_ON(1);				 \
 		}							 \
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index e416e433baff..a573b1f0c6cb 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1091,7 +1091,7 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 		len = vgic_v3_init_dist_iodev(io_device);
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 	}
 
 	io_device->base_addr = dist_base_address;
-- 
2.39.5

