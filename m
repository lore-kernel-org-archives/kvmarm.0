Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E58A125C0
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:23:02 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c647150c254so7464895276.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652982; x=1693257782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZNW6XiNIf4mfjw9nbhS/bawdb727WcU0dp8aEgn/JY=;
        b=mfZ8T+vJQqkinKwOsLzTgieqjlDTtmMJPhiIg1UCejUhjc9rHbi12nHrBX1P8R+La1
         On1VG+8ZZPt9lU0WEOUK6Hhqm7oUHN3uX9k7gKeoKcYZqRQarrkaKugZ+N3u0zR1NqeF
         qKUJdOWiOl7c1ntFEpmGr0DZ4k3fUFFTwFJ7AwFIjMbyNNsPqdCcMezkrnEzRErgVfwk
         vrAeVlG3W9apImp2c4JOGe0cjEog9XiPDnb0fCQ5GiDtCb4wob39UHoE7iFPG+Vo19sS
         ULFHcNVrjQgS3eIQQq+qWnfIuvrkUaYPkW+Y5RPIC0SbNZHS8AWRIqwMP7EgiznJNWSd
         mqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652982; x=1693257782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZNW6XiNIf4mfjw9nbhS/bawdb727WcU0dp8aEgn/JY=;
        b=IKhuB1IaaHfV3PRA9R3efoDsYd++eldw5FoGSnBlBG/lfxxhsB+I8DtPV8Wuo8RJsf
         PgRVYxYWa9+4M6NAmIeypa3KcSghZ+PgY6Y0QlTdxBr0uOZ4yvvZhTdh6EtdogbPnmxN
         TkSrhBwZkbsNLzMVBU0FD3z/vN8ixolCqsV24Ck6UU/iwMPnRyXYimKJ9rJ2zhCkUGEo
         u7o7/bf1XHl22Vjso5wPLUpWCXtxsne7jj1/EajHFNjrY/N2nud6fJH2kQ7AIyinEH2o
         8+znEOq8xuNCKhO8GPSsQX1FvplL7nGAfT60+q+qWk01t8qnWKJbHf2tScRMRNrdq1y3
         SmHw==
X-Gm-Message-State: AOJu0Yx+S+1rf7Kbfq3MDRsaxNMoT4lHjzceVJEDspZuWVEhw3CYvnoE
	Dz+NNq5/G6mpU5xOh0CmmnLkXKDXCLzlga9EvA==
X-Google-Smtp-Source: AGHT+IFcZHBQjtL3hf7b721U36jM/7oR8Bwys7GsW5mF8z+GNPV4bnU+CLhfQcjsqC+23yxApD2ljTpBXI1NF/Etiw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d3cd:0:b0:d64:9e2c:5c0d with SMTP
 id e196-20020a25d3cd000000b00d649e2c5c0dmr98945ybf.5.1692652981963; Mon, 21
 Aug 2023 14:23:01 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:40 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-9-jingzhangos@google.com>
Subject: [PATCH v9 08/11] KVM: arm64: Refactor helper Macros for idreg desc
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add some helpers to ease the declaration for idreg desc.
These Macros will be heavily used for future commits enabling writable
for idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 82 +++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bf716f646872..44d164d47756 100644
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
+#define _ID_SANITISED_W(name, _set_user, _reset, mask) \
+	ID_DESC(name, _set_user, id_visibility, _reset, mask)
+#define ID_SANITISED_W(name, mask) \
+	_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg, mask)
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define _AA32_ID_SANITISED(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, 0)
+#define AA32_ID_SANITISED(name) \
+	_AA32_ID_SANITISED(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+#define _AA32_ID_SANITISED_W(name, _set_user, _reset, mask) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, mask)
+#define AA32_ID_SANITISED_W(name, mask) \
+	_AA32_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg, mask)
 
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
@@ -2003,13 +2006,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility,
-	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = GENMASK(31, 0), },
+	_AA32_ID_SANITISED_W(ID_DFR0_EL1, set_id_dfr0_el1,
+			     read_sanitised_id_dfr0_el1, GENMASK(31, 0)),
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2038,12 +2036,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
-	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ~ID_AA64PFR0_EL1_AMU_MASK, },
+	_ID_SANITISED_W(ID_AA64PFR0_EL1, set_id_reg,
+			read_sanitised_id_aa64pfr0_el1, ~ID_AA64PFR0_EL1_AMU_MASK),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -2053,12 +2047,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_aa64dfr0_el1,
-	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_MASK), },
+	_ID_SANITISED_W(ID_AA64DFR0_EL1, set_id_aa64dfr0_el1, read_sanitised_id_aa64dfr0_el1,
+			~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_MASK)),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.42.0.rc1.204.g551eb34607-goog

