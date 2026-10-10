Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8EC376475
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639559; cv=none; b=gTpdakiOLYbBknxnEqr/AMyGh7iMHrY0L0muHw59HsWGXw8yWdJy3/t/4dvcTnYFdBX9gEP8yTvtTHAekpybH6icHMuB7ki8omfmP4pcSzY24RPHEcla92LRAmOHdXLGXzvOuDUXWzxDJKpHxZT8VD/3YWu5eehXN2a53p0clB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639559; c=relaxed/simple;
	bh=KJowRmWQGUPSvp5cG7cuWxzEHn+Pmzlr8acM+UQMNcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=imu70bdRArQq0+4ri1x86S57iK42C2SvsjTSgzr2E5gjV+RcxfktVdVAGktlCiIlKxEBJ4lZTb+ui9d2UEjP5C1lSHTCNYU3vT1dNJOPHNN7RkdxEneLG4MEXdbzbIY20XUeOW08HjbQYXWVV0Wpluz4IoNCEdobSKyXCnNxoUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ncmsl5ko; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ncmsl5ko"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2e+3CcNTBkD4MMGpHP73g186a5p7lV5juXn4lBjmR0Q=;
	b=Ncmsl5kon2hTpCJn4KYtHCog131km8gttGBav5pZtAdi1Z0dTiMBEDcxoxeMOJBbyg244N
	dLfTgv7hvPxGXrmMhmXlqicVk8ceeWa8U9ionTMN7Ra7XL2mR0+QwyL+oA1Xj6MNpHajvz
	Um0lbzIV3izEsoRNVfPcbW/EBshvqiw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-HXkgVivpOn-D1dziElzKEQ-1; Sat,
 10 Oct 2026 13:39:12 +0000
X-MC-Unique: HXkgVivpOn-D1dziElzKEQ-1
X-Mimecast-MFC-AGG-ID: HXkgVivpOn-D1dziElzKEQ_1791639550
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88E081944DF3;
	Sat, 10 Oct 2026 13:39:10 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C48330000E5;
	Sat, 10 Oct 2026 13:39:05 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 19/26] target/arm/kvm: Apply SYSREG props
Date: Sat, 10 Oct 2026 15:36:23 +0200
Message-ID: <20261010133725.642498-20-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: NAcvJUgU0xo8_wqLZaenfUpueG6owVpppymfQNSdzIk_1791639550
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Now the infrastructure is in place let's trigger the
SYSREG prop update in the KVM code. This is done in both
kvm_arch_init_vcpu() and kvm_arm_reset_vcpu() after the final
vcpu has been initialized with the proper kvm init settings and
before kvmstate is synced back to the cpreg list.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v9 -> v10
- use ValueRange
---
 target/arm/cpu64.c |  9 +++++----
 target/arm/kvm.c   | 20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 26baee102c..ff178bcaf5 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -883,10 +883,11 @@ static void set_sysreg_prop(Object *obj, Visitor *v,
         return;
     }
 
-    if (field->arch_vals) {
-        /* this field has some enum values */
-        for (int i = 0; i < field->arch_vals_count; i++) {
-            if (value == field->arch_vals[i]) {
+    if (field->arch_value_ranges) {
+        for (uint32_t i = 0; i < field->arch_value_ranges_count; i++) {
+            const ARM64SysRegArchValueRange *r = &field->arch_value_ranges[i];
+
+            if (value >= r->lo && value <= r->hi) {
                 goto valid;
             }
         }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c6c9ea03a5..0c7e80aea8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1247,7 +1247,7 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
-static int G_GNUC_UNUSED
+static int
 kvm_arm_override_idreg_field(int fd, ARM64SysRegField *field,
                              uint64_t newfv, Error **errp)
 {
@@ -1291,6 +1291,17 @@ kvm_arm_override_idreg_field(int fd, ARM64SysRegField *field,
     return 0;
 }
 
+static int kvm_arm_apply_one_sysreg_prop(ARMCPU *cpu, ARM64SysRegField *field,
+                                         uint64_t newfv, Error **errp)
+{
+    return kvm_arm_override_idreg_field(CPU(cpu)->kvm_fd, field, newfv, errp);
+}
+
+static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
+{
+    return arm_cpu_apply_sysreg_props(cpu, kvm_arm_apply_one_sysreg_prop, errp);
+}
+
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     int ret;
@@ -1304,6 +1315,8 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
         abort();
     }
 
+    kvm_arm_apply_sysreg_props(cpu, &error_abort);
+
     if (!write_kvmstate_to_list(cpu)) {
         fprintf(stderr, "write_kvmstate_to_list failed\n");
         abort();
@@ -2250,6 +2263,11 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
     }
     SET_IDREG(&cpu->isar, MPIDR, mpidr);
 
+    ret = kvm_arm_apply_sysreg_props(cpu, errp);
+    if (ret) {
+        return ret;
+    }
+
     cpu->mp_affinity = GET_IDREG(&cpu->isar, MPIDR) & ARM64_AFFINITY_MASK;
 
     return kvm_arm_init_cpreg_list(cpu, errp);
-- 
2.53.0

