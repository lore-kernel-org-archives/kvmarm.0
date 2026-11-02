Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624538;
	b=T5pel1lozonAklakLbu1vM9hQhEA2xsckpSH2OOzfEtFoKcn96f7nhS09bkJv8DwmIkO
	 la7M3osM5DyGprwKh3PB/Terj8YVOYAhbuFeyie3EUnTF/2axsfqZFauetUJ+jpjE7Nx3
	 8swXbeEHVwjGPgflKC0CBpzGx673MgXakZ+FtRDE/ii5fqt86crPF+yxlFHW/kLeF0o63
	 9yNuJUKWyo46MQVl705jZp7Y8/MNh9l7Ec07L9IapkBoqW1LEN+QtGFFl+jBGqX++hcQN
	 +tEcA6fvuk8UHikGwUvnNk0qbD+Hk16jLrgYYEpoA54WZuSMRb+bsk9p7OPtJi6aXsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624538;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PssXTR1GZrsqtEK7C6unt3X/SPdoffa44UYfSuTum6E=;
	b=OsaaxBtM2HHLFKT90SPfqJ529hii7cmkYnSpaRGC0Jd8z7qK9lhLkJ30wJVGxd8qgtQb
	 3evEdkwA9fcZ14iILYjiCFC4F8HnqrP674p3+PEhFlh7q1Src/Km4DCI0ofn24pRksW1b
	 MgtQY31iERFUE/0Z7aRc+Lg+zNCT3uxH/Xmh+tnWHK6zydiHNBU/KlDuLxNFx/CuTmKjr
	 FceVZcHEW2rAI5M/yS99DS26V/TxfXBjGNyLiEMCwN3oXrRoKQLnirN511Jjh3R8+RPmJ
	 Z9VXjD9QBDWivpke8s59nWtv4id7p6/WSNoIU5jEfTZ6rfE8kls8uFxAwd6/IP9mY/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ne4BD8ie;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6160A2634
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0E6160A2634
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ne4BD8ie
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=j0NbCmVOZODkpnuzQJFxfbpF22caqI/A/jhViukqerg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624536; v=1; x=1794229336;
 b=Ne4BD8ie3mE+FZrfkCwyjBcjpNh9UP5ivJUHzaUHK6Yr70YGp10wVDtGvBLhDvz+riJP8EDf
 1NUulauuJ9507e9uVKM6FEnU+yyQyXsUwqrtSFRRbtTDq2/1d/Hodj+dOGaG/Jgu2G2LYFXSkoK
 UGG7w4DiVIlw4dqBYtOVlqc4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 62b76b9dce29e721;
	Mon, 02 Nov 2026 13:02:14 +0000
X-Mizu-Trace-ID: 62b76b9dce29e721
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/13] KVM: arm64: Share the ITS command field accessors with the hypervisor
Date: Mon,  2 Nov 2026 13:01:26 +0000
Message-ID: <20261102130133.3684226-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
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

The vgic's ITS emulation reads command fields with its_cmd_mask_field()
and the its_cmd_get_*() accessors. struct its_cmd_block, the block they
decode, is private to the ITS driver, and a later patch has the
protected KVM hypervisor parse the host's commands too.

Move the command block and the accessors to arm-gic-v3.h, which already
holds the GITS_CMD_* encodings, so there is one copy of each. Only KVM
reads commands, but the accessors decode the block the driver writes, so
they sit with it rather than in a KVM header.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 15 ---------------
 drivers/irqchip/irq-gic-v3-its.c   | 10 ----------
 include/linux/irqchip/arm-gic-v3.h | 22 ++++++++++++++++++++++
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7e9b265b1f521..78e480d112025 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -802,21 +802,6 @@ static bool vgic_its_map_lpi(struct kvm *kvm, struct its_ite *ite,
 	return false;
 }
 
-static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
-{
-	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
-}
-
-#define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
-#define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
-#define its_cmd_get_size(cmd)		(its_cmd_mask_field(cmd, 1,  0,  5) + 1)
-#define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
-#define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
-#define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
-#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 44) << 8)
-#define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
-#define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
-
 /*
  * The DISCARD command frees an Interrupt Translation Table Entry (ITTE).
  * Must be called with the its_lock mutex held.
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index f06da58cccf3d..3e27c7d58e024 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -528,16 +528,6 @@ struct its_cmd_desc {
 	};
 };
 
-/*
- * The ITS command block, which is what the ITS actually parses.
- */
-struct its_cmd_block {
-	union {
-		u64	raw_cmd[4];
-		__le64	raw_cmd_le[4];
-	};
-};
-
 #define ITS_CMD_QUEUE_SZ		SZ_64K
 #define ITS_CMD_QUEUE_NR_ENTRIES	(ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ea5fd2374ebe0..e0bec40adf2b7 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -657,6 +657,28 @@ static inline bool gic_enable_sre(void)
 	return !!(val & ICC_SRE_EL1_SRE);
 }
 
+struct its_cmd_block {
+	union {
+		u64	raw_cmd[4];
+		__le64	raw_cmd_le[4];
+	};
+};
+
+static inline u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
+{
+	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
+}
+
+#define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
+#define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
+#define its_cmd_get_size(cmd)		(its_cmd_mask_field(cmd, 1,  0,  5) + 1)
+#define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
+#define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
+#define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
+#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 44) << 8)
+#define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
+#define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
+
 #endif
 
 #endif
-- 
2.47.3

