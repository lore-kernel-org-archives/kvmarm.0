Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DE840BE5
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954738; cv=none; b=c60sbSxZdrr64PwX3Gra4Yc7y6NFVaixSIJ61WkSmltxmcgCWYg3noYKE4dlJ+AGNcrMogoco/QhTbuiCQ7dHVA9xp5tZqAzJvK+qzOX25pwd+nQwSI5W+zis2KrGg6anhyfzQ/HejX7zvOxXQfQJXeIHtd4dhYz5DhtngL8RhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954738; c=relaxed/simple;
	bh=D8XAWTe4sEY9QGE49AHls5BaX4fye0job2m9Dj0QDSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kjHLAS8j6u1Kz+WAdYng/xQKi/fCk+hC685meG6oN3c9OYoNnD2hQb924ssQhPXdXLMgDgQ92z/tvEd7Dl/ZCJMZwLY1AaYfzop17A8cP5N8pqgj2GxhlrcHVa2cK0Fk8PASZ40hYvvn/nyWWrBBPoDQr6dLaTpDRtvOQ8Ut/Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPaB3uux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPaB3uux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAE2C43399;
	Mon, 22 Jan 2024 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954737;
	bh=D8XAWTe4sEY9QGE49AHls5BaX4fye0job2m9Dj0QDSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPaB3uuxJWmRAsz0u6hyiLQtT/C2HocfO5x5Uk01DwJYya4xX7bbvzmxR/isSqh0R
	 SllJtgmwMYLjB6x3T6ulc2a7S8woG3g2H1gCxCZXpmRTXb74skyrFpdrSQKYuUVote
	 1V1Qb1WJqbMTteYY7gm6UXapXSm01ajAwmQ4/P/bJlewn9NpOUz6uaCDku0Sw1xVQb
	 vA9NfD5ly1pnU5poKk3/LHeTWBkzoidzAboHMVbcc1OY6CaK0uxGo9tAEGQHp2QcoO
	 M7u4hi4ir5Hy+fpaGaQ1wb8rItXuxk8tJiIejQN4VwjScal8Sq8B3fzMXTYzVB8ZqX
	 0LhzoAKPe+cCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kx-00DjkQ-VA;
	Mon, 22 Jan 2024 20:18:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 02/25] KVM: arm64: Add feature checking helpers
Date: Mon, 22 Jan 2024 20:18:29 +0000
Message-Id: <20240122201852.262057-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to make it easier to check whether a particular feature
is exposed to a guest, add a new set of helpers, with kvm_has_feat()
being the most useful.

Follow-up work will make heavy use of these.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 53 +++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..c0cf9c5f5e8d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1233,4 +1233,57 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+#define __expand_field_sign_unsigned(id, fld, val)			\
+	((u64)(id##_##fld##_##val))
+
+#define __expand_field_sign_signed(id, fld, val)			\
+	({								\
+		s64 __val = id##_##fld##_##val;				\
+		__val <<= 64 - id##_##fld##_WIDTH;			\
+		__val >>= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
+									\
+		__val;							\
+	})
+
+#define expand_field_sign(id, fld, val)					\
+	(id##_##fld##_SIGNED ?						\
+	 __expand_field_sign_signed(id, fld, val) :			\
+	 __expand_field_sign_unsigned(id, fld, val))
+
+#define get_idreg_field_unsigned(kvm, id, fld)				\
+	({								\
+		u64 __val = IDREG(kvm, SYS_##id);			\
+		__val &= id##_##fld##_MASK;				\
+		__val >>= id##_##fld##_SHIFT;				\
+									\
+		__val;							\
+	})
+
+#define get_idreg_field_signed(kvm, id, fld)				\
+	({								\
+		s64 __val = IDREG(kvm, SYS_##id);			\
+		__val <<= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
+		__val >>= id##_##fld##_SHIFT;				\
+									\
+		__val;							\
+	})
+
+#define get_idreg_field_enum(kvm, id, fld)				\
+	get_idreg_field_unsigned(kvm, id, fld)
+
+#define get_idreg_field(kvm, id, fld)					\
+	(id##_##fld##_SIGNED ?						\
+	 get_idreg_field_signed(kvm, id, fld) :				\
+	 get_idreg_field_unsigned(kvm, id, fld))
+
+#define kvm_has_feat(kvm, id, fld, limit)				\
+	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, limit))
+
+#define kvm_has_feat_enum(kvm, id, fld, limit)				\
+	(get_idreg_field_unsigned((kvm), id, fld) == id##_##fld##_##limit)
+
+#define kvm_has_feat_range(kvm, id, fld, min, max)			\
+	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
+	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.39.2

