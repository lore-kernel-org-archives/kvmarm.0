Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D5733C536
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570153; cv=none; b=h643mWSJKXfJX/GlxYIMXzlTB/m/gojeB5mPLm3qY3GzS3v9c/UPfD9WtdaRTiHI33l+KUEx3hzmSHmQ0TzZ1t9JX6leJPdt7BnOXp9IjxeQt7o2GYj1qeP7AtowvvdNOLnPDZ9ZwLkAKPtQ4wGzY1JzQv08Axfl50XOqrnhGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570153; c=relaxed/simple;
	bh=kqlGnjMK8ddnKZwZTia8DFvAmlvBYAMUhgHhKwJmjWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eq7Z12qmZTYw0u/JmpV6nZHOLllqGNwr10E9oRpyUXHe5JpJjOyVf8/Ugd6cuvmCGGpYAuYX45jM+kr4CVQ4qzBF7kfR1vlr+HJKiouAohDeHgD4/MNtiyYht6KxJMqa+yBlpRpluqfEvgupi68/tyB47D/DqBNGFsQ3YCOAKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSJn9Kmv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSJn9Kmv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gBiQ/WZ8FDSS7QTiXrmQ5xLbPQJvAU6T5QyffYoE+7o=;
	b=CSJn9KmvILllacS6dGwAMrBqP8PJDh/mL057ZgS0EGV8ibWN+RzHj4/eIhdY21rz7hkZO+
	QVOVHgpQTQu0PzsjYb3PvMU+jIvOmQeDdNfAhFkLy+kfY/c6XPG8QOMuF6NAQo+k+FAFAk
	/F3OdFXJ5/8wT5sc3xsU3DhgYaRvf8s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-03htv0vrMP6M-Xey91I9eQ-1; Wed,
 16 Sep 2026 10:49:07 -0400
X-MC-Unique: 03htv0vrMP6M-Xey91I9eQ-1
X-Mimecast-MFC-AGG-ID: 03htv0vrMP6M-Xey91I9eQ_1789570146
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F95E1800DB5;
	Wed, 16 Sep 2026 14:49:06 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4EC36195604D;
	Wed, 16 Sep 2026 14:49:01 +0000 (UTC)
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
Subject: [PATCH v9 18/26] target/arm/cpu: Expose writable ID reg field properties on the kvm host vcpu model
Date: Wed, 16 Sep 2026 16:45:41 +0200
Message-ID: <20260916144721.751810-19-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: IIjdHLQj2rkQB_Wl6SkmGlwmV9ejful5ZRqCrifVXCQ_1789570146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
of writable fields for all ID regs, expose uint64 SYSREG properties
for all the writable ID reg fields exposed by the host kernel which
can be matched in target/arm/cpu-idregs.h.inc.

Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
being those used ARCHMRS Registers.json.

When such properties are set, they override the default field value
retrieved from the host and reinjected into KVM. Then the actual value
being applied at KVM depends on the register, ie. it can be sanitized.
In case the field value is rejected by KVM, the vpcu init fails.

Anyway there is a first attempt to write back this value into KVM.

Then legacy CPU options (virtualization, secure, ...) can still
override the previous value. So low level IDREG field properties
apply before the legacy ones.

An example of invocation is:
-cpu host,SYSREG_ID_AA64MMFR0_EL1_ECV=0x0
which sets ECV field of ID_AA64MMFR0_EL1 to 0 (enhanced counter
virtualization).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Sebastian Ott <sebott@redhat.com>

---
v5 -> v6:
- do not check writable_map anymore

v4 -> v5:
- get rid of ret local variable, dynamically allocate and free writable_map
  here
---
 target/arm/cpu64.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 4e8c472530..e04062e848 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -37,6 +37,7 @@
 #include "hw/core/qdev-properties.h"
 #include "internals.h"
 #include "cpu-features.h"
+#include "cpu-idregs.h"
 
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
@@ -807,6 +808,10 @@ void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
+
+    /* generate SYSREG properties according to writable masks */
+    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
+
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
-- 
2.53.0

