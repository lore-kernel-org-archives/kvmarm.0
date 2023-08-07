Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C33411C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:30 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942667393so60087577b3.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425349; x=1692030149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ATBSjF6qBqdfdnd8w2mF20Dlf6Vur3R3tLd+6Z/cyMs=;
        b=i1eNS32wMwVyxs4WKb9JGC7F2FXkcX+IHurd54K2c03M6iCgApXHP/+RKzyS+vv9kJ
         KOn62RNuqlSIEMtJcGRrj97bkcJdDhxmkiTBjmvykmIEfhfS2APKbtyCwxuYaemi8/+r
         REjk8j/3KhEZALMyBaCBZWMV6Z17y2flSpLpiZM/IRcLJ6EtpxURNEyJUs1YxOnkPUD4
         jLoMqWjnSwLseg5pRypEjfwZmRVeN1FEDMu3FOUKren26JqSnQ6KrrvNoXjjNx7dgRH+
         eOBmxABe/GWihxsBandBo6jAJ5IxtTXfA1qiWdaSY9e/f/6rrdGQtxWPx3M3e0Gt+2Zy
         K6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425349; x=1692030149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ATBSjF6qBqdfdnd8w2mF20Dlf6Vur3R3tLd+6Z/cyMs=;
        b=AHczMzt460ci2x2cqeLG0gRAcrX+alaEZA046vBLkzsVW9llntVF1KIAvPRuOJFzMT
         86t5Z8V/Nudsj1CwNtI0xA+v21EZoJVX/bdJYicKs438KRIHX6WWi2iCMBEcpf+V1S9B
         aoEuOqEk8St12gsFh1g5Ww9BH4h2Tmas/aQpZ63vgmTAhDIZenQWMrNTpuUWRVoSeFxo
         SMQHnuKA9LopZh6lJ4NEl9J7qX1YL2GAxPnqgWQCe8WxbB+yTYf7b1BYXA/sS4ZvRWly
         WTl8HSSNv33kHMnmmZyp6TUlq9kbUsZ0TBJ2VCyYZT4obhxZVYhueSyWpUHZQRNUZbO0
         Cy3g==
X-Gm-Message-State: AOJu0YyLs4qGVReWewLFqwHIpj4/28scfO4GqJSlAuiyX7K+zWs9Rgzv
	6VIqSEyjmtILwKce2KZSYUeS2LCdk5Xvlp7Peg==
X-Google-Smtp-Source: AGHT+IHshu44rw+o8SIUK+hYUQLk5w4Kgcs1lJhicK+bcq3hGbMtuNeTuBpA8+ho5ibjdKGHRmegILAIqvRMvxhB1w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:23d6:0:b0:d4c:f456:d54f with SMTP
 id j205-20020a2523d6000000b00d4cf456d54fmr32913ybj.8.1691425349461; Mon, 07
 Aug 2023 09:22:29 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:06 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-9-jingzhangos@google.com>
Subject: [PATCH v8 08/11] KVM: arm64: Refactor helper Macros for idreg desc
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add some helpers to ease the declaration for idreg desc.
These Macros will be heavily used for future commits enabling writable
for idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 79 ++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 392613bec560..85b5312bdee6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1844,27 +1844,37 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * from userspace.
  */
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
+#define ID_DESC(name, _set_user, _visibility, _reset, mask) {	\
+	SYS_DESC(SYS_##name),					\
+	.access	= access_id_reg,				\
+	.get_user = get_id_reg,					\
+	.set_user = _set_user,					\
+	.visibility = _visibility,				\
+	.reset = _reset,					\
+	.val = mask,						\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
-}
+#define _ID_SANITISED(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, id_visibility, _reset, 0)
+#define ID_SANITISED(name) \
+	_ID_SANITISED(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+#define _ID_SANITISED_W(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, id_visibility, _reset, GENMASK(63, 0))
+#define ID_SANITISED_W(name) \
+	_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define _AA32_ID_SANITISED(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, 0)
+#define AA32_ID_SANITISED(name) \
+	_AA32_ID_SANITISED(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+#define _AA32_ID_SANITISED_W(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, GENMASK(63, 0))
+#define AA32_ID_SANITISED_W(name) \
+	_AA32_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg)
 
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
@@ -1886,15 +1896,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * For now, these are exposed just like unallocated ID regs: they appear
  * RAZ for the guest.
  */
-#define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = raz_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
-}
+#define ID_HIDDEN(name) \
+	ID_DESC(name, set_id_reg, raz_visibility, kvm_read_sanitised_id_reg, 0)
 
 static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -2001,13 +2004,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility,
-	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_AA32_ID_SANITISED_W(ID_DFR0_EL1, set_id_dfr0_el1, read_sanitised_id_dfr0_el1),
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2036,12 +2033,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
-	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_ID_SANITISED_W(ID_AA64PFR0_EL1, set_id_reg, read_sanitised_id_aa64pfr0_el1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -2051,12 +2043,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_aa64dfr0_el1,
-	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_ID_SANITISED_W(ID_AA64DFR0_EL1, set_id_aa64dfr0_el1, read_sanitised_id_aa64dfr0_el1),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.585.gd2178a4bd4-goog

