Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE01B2EF2
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639538; cv=none; b=WmaATx4lBu5RRQa3/Hu7IUfAuMIikWXBtYUtuA/1g8AINukIFl0iHS4ZWNfo8RxCagmdCRPC6oY8PVikO5bfAkdcobc3zx2eJRZTEDjqNZUE/nW7XF7ZsVUPvmFNRU9bmsWxLu+JRtm3qGWaKn+wkRZSCpP/QPxLEhK3s1IOXQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639538; c=relaxed/simple;
	bh=oeORjM3Pzd/sNdj+0S3vYehHPusgILuypBkl7ZL/HFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Yvzdqw/M7c8PVqpLFEWGbadrGT3LZOjTR2OfIT3F2RzRko2QFXXb67k1jbsD/4/SvzZWh5bYncNeuEDFoBbK7zpBpPtKS3Otqm8Fv7QBi+pP/IRTdafbFYwN+KPmZ97k2yf3X/eZYM1SuAd4+fUJBwjUenUItOfPSG1+NFBLWS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ayVTewtU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayVTewtU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJJ9866SG6H+ss4j/yi5NJRaRLchsKWeX66gkZZoSAY=;
	b=ayVTewtUdfYSwlpf3UYwwZDPtxm5UfjSY9xE9BFB4DZmArI9VpzYcrvZURjEnYS1CzAamI
	fdm3PkEF6XV6UwdrnxDyhcb7Q2sxjBv3/QEDW9m0qaxcbLXyTYw3Y4x+2mEZU7OKTKDR30
	QrNsR8+2JJ4Bzl04slgA2iaYTKM2nfo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-IlDwscnDO6S4RsQQdcxOeA-1; Sat,
 10 Oct 2026 13:38:52 +0000
X-MC-Unique: IlDwscnDO6S4RsQQdcxOeA-1
X-Mimecast-MFC-AGG-ID: IlDwscnDO6S4RsQQdcxOeA_1791639530
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA44A1809C9F;
	Sat, 10 Oct 2026 13:38:50 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00FCD30000E5;
	Sat, 10 Oct 2026 13:38:45 +0000 (UTC)
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
Subject: [PATCH v10 15/26] target/arm/kvm: Let kvm_arm_init_cpreg_list propagate an error handle
Date: Sat, 10 Oct 2026 15:36:19 +0200
Message-ID: <20261010133725.642498-16-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: iRALXew__YIscH6cUqvJ9GXChWagkQNaTgDS1GYAWBg_1791639530
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Subsequent patch will add an error handle to kvm_arch_init_vcpu(). So all
errors must come with an error handle.

kvm_arm_init_cpreg_list does not propogate any, add this capability.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ac4f307276..f2b79c0a34 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -962,6 +962,7 @@ static bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx)
 /**
  * kvm_arm_init_cpreg_list:
  * @cpu: ARMCPU
+ * @errp: pointer to Error* for error reporting
  *
  * Initialize the ARMCPU cpreg list according to the kernel's
  * definition of what CPU registers it knows about (and throw away
@@ -969,22 +970,27 @@ static bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx)
  *
  * Returns: 0 if success, else < 0 error code
  */
-static int kvm_arm_init_cpreg_list(ARMCPU *cpu)
+static int kvm_arm_init_cpreg_list(ARMCPU *cpu, Error **errp)
 {
     struct kvm_reg_list rl;
-    struct kvm_reg_list *rlp;
+    struct kvm_reg_list *rlp = NULL;
     int i, ret, arraylen;
     CPUState *cs = CPU(cpu);
 
     rl.n = 0;
     ret = kvm_vcpu_ioctl(cs, KVM_GET_REG_LIST, &rl);
     if (ret != -E2BIG) {
+        if (ret < 0) {
+            error_setg_errno(errp, -ret,
+                             "failed to get KVM register list size");
+        }
         return ret;
     }
     rlp = g_malloc(sizeof(struct kvm_reg_list) + rl.n * sizeof(uint64_t));
     rlp->n = rl.n;
     ret = kvm_vcpu_ioctl(cs, KVM_GET_REG_LIST, rlp);
     if (ret) {
+        error_setg_errno(errp, -ret, "failed to get KVM register list");
         goto out;
     }
     /* Sort the list we get back from the kernel, since cpreg_tuples
@@ -1001,7 +1007,7 @@ static int kvm_arm_init_cpreg_list(ARMCPU *cpu)
         case KVM_REG_SIZE_U64:
             break;
         default:
-            fprintf(stderr, "Can't handle size of register in kernel list\n");
+            error_setg(errp, "Can't handle size of register in kernel list");
             ret = -EINVAL;
             goto out;
         }
@@ -1027,7 +1033,7 @@ static int kvm_arm_init_cpreg_list(ARMCPU *cpu)
         /* Shouldn't happen unless kernel is inconsistent about
          * what registers exist.
          */
-        fprintf(stderr, "Initial read of kernel register state failed\n");
+        error_setg(errp, "Initial read of kernel register state failed");
         ret = -EINVAL;
         goto out;
     }
@@ -2196,7 +2202,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     SET_IDREG(&cpu->isar, MPIDR, mpidr);
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    return kvm_arm_init_cpreg_list(cpu, errp);
 }
 
 int kvm_arch_destroy_vcpu(CPUState *cs)
-- 
2.53.0

