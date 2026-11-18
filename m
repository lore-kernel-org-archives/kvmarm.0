Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015182;
	b=ePxQAaTXUwiyOE8a+zAOz/r7yXyPTsDl0fTZhxGIhrw0LIvQ/PyKaw7Hv7ALnxsTHHxE
	 Bn4xfDWXNGUug0kwDyTYB0EzBXF7FTRROX43O/uobDZ+ZWU3Woda7D1YH5ETT0x43I1CC
	 j7h71viHafpDmM8OSB9LzQy+JxesovCSIPDGGiIxdGOTCOa73XSiqlVeY5qC4qodIX7WV
	 zRFYawJVy1/ME7t5jmO918oEiRRZEP/JgV6iECItjHe2mIPA4hppgPFtmCk4TbIYjCqeC
	 yYkH+4gR1PAdXjXgeJBK79lkmt5crhMNYMBOFUo9dV/Ep8Zgafr3tjkzKb72Uasz6Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015182;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ih7PJseCTUo9992Qi/riC8TJ+5UyoXMZp5GLXDRFGsg=;
	b=hMZowgG8J8aEJDRMWAI057lgwnm8mpSWFt4Qi/5Q5iMY0B508998J7j4eVPC90vkU34U
	 CpWexDRAB5vKBf2QVcqmR+U9KzCBiNlkJlQcOlENQbOgQTvDs28Rkc/5X/8Fps9ZmwEvk
	 HXMqLlckqjOZtJdgZwgMlZdxhiO7c3v07ocwARhE3dcI4GbX3CJtbDF6gi39+nY1ad7ib
	 tJAUqTGjBimL0BSfJHe8LTO/QkIbgTcT5foRcZyCtdsHZrVepS7iyXjIEC9Gq+3BOsvT6
	 t1PhLR5ItPoeTB4UFDQ0HA7aJnyNGVXjhEP2WSvzO5df+qGqJTU+YSlDw+BWBxXHnuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="vA/uNhz8";
	arc=none smtp.remote-ip=95.215.58.239
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60297606A32C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60297606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vA/uNhz8
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=g087P9+edDWSWSxVVt+5nxjxLatHb08fe1Dv5ib5o6Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015179; v=1; x=1795619979;
 b=vA/uNhz8F2uBN8nnSsSN1c42pP/m3YPB3Rr+gI36JK7b/6mu30O8joF+JANxagXYpYNmlqt1
 CtSfXCafKBFyNgqmb/5jIqbw0GfwM76hSkQ7ZOBfwa0iYxtO1ekGtd3rzWWog2oOc1gYtp/JyA/
 SDtNgdzB7/F7YcDlKTGS8jHo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 76ddee6606c60c99;
	Wed, 18 Nov 2026 15:19:39 +0000
X-Mizu-Trace-ID: 76ddee6606c60c99
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
Subject: [PATCH v4 06/13] KVM: arm64: Share the ITS command field accessors with the hypervisor
Date: Wed, 18 Nov 2026 15:18:57 +0000
Message-ID: <20261118151904.4099560-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
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
decode, is private to the ITS driver, but in a subsequent patch the
hypervisor parses the host's commands too.

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
index 734fe4fb52bd6..df6d7b2fc8611 100644
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

