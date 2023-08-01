Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34C64DC97
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:28 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c6dd0e46a52so5991215276.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903227; x=1691508027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCRHZVqddoTSJorH44HmZhNcqs8I6hBKdRtCxXPKdcc=;
        b=xUk8/PBRR9uYT5FnKEA4Cve1KEBIbakV95yHK6lLIe0Jd2hkciskQ+1vWIYAFyfZsZ
         SCkb2hADUdQOJtA//rrCMnQqJxn7PZYTyBKgjUvlcLWBDivD0rNSjH0Fm+S/uMyIEuFs
         VzbTvhXsMlyB9/+mbWNZqt/86Gv1Xe0g33EdLC7mJnLLcnPFZy2nXLx+saOoj4JLpNhp
         AMystXt2IFjzAh++Dg3UFla/zhMzyRxWd4Wa7p/+SCvTajnY3eXp8FLVkLfDFKQftdIM
         g4DDq5Zt3PVmyqublIcK+lJiF1+3ve287QP9AsxsxDSKfxLiQ3KOQdv+rISsCFsQKj12
         OBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903227; x=1691508027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCRHZVqddoTSJorH44HmZhNcqs8I6hBKdRtCxXPKdcc=;
        b=T1K0n8oNkUT0z+/zbUqmV3yFolwPPugusIeapoQmR8HHJfTqcageEqvWUPv9G7zo7C
         ZnUfErRcPs2FQAFJDsL7wjRkKuB4vIrYUDCAQGPa2JZARbd9XQYabH3z4yhv/8lx2Ib0
         vWwg0XWXN8EqPAFwnA1TTiEQKSvvH6PAyyg56yUJiUrnaepinksWXTgCW6UKilRwYjks
         3wcLD2zGcw9VekleqN1atGMhhlQffKM5/9ayht1PsASpM2vle414hjaR4+U2O6v/5tWq
         YwK21sA4enTW6u4mzh/dkHDs4IJoPgPdJ2cxqRzUkXBiXz0jG4qumant51WorhiILZj6
         9UnQ==
X-Gm-Message-State: ABy/qLavgN5j5B/cCk5Lf9AUptfVivSSysYNRl+gNy9iytG+61D4u8a7
	Ta1abJVz0wwLm+N/lwDYyKmYVOUcJB66JrsZzA==
X-Google-Smtp-Source: APBJJlEnpgyitr9PUTByZOiYn2bZXCXM8oRbrFOt19UqT5CZCMNf1UqGqdwhB7FXBYLGi3iq9DArG2kfHOXto4DNyA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:ab86:0:b0:d0d:a7bc:4040 with SMTP
 id v6-20020a25ab86000000b00d0da7bc4040mr92863ybi.0.1690903227620; Tue, 01 Aug
 2023 08:20:27 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:20:04 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-9-jingzhangos@google.com>
Subject: [PATCH v7 08/10] KVM: arm64: Refactor helper Macros for idreg desc
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
index 0a406058abb9..9ca23cfec9e5 100644
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

