Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89AB264A7C
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 08:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746521669; cv=none; b=VUwI6XQZ0JnlYpgQxN2gOB3Z5SRuUBWW1TbQxoQ/P3Ok4+zr4xQ0s38tm2ajJQXItceUaTQleyqSC7vlyOtx7gK6ZHQVmdBKlLBnsfv896HpDO5uxyEE+MG9z6i+UO9JnCVFLchZ7iq2/GzXD269cmDU/5s02UshAO6YK2IImM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746521669; c=relaxed/simple;
	bh=Lz7f2gi4p96ogN8uVtxlTCefumad2fCjmh2l7hBuBQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Xgfk+ltpIUtgKgtKOPwIimliVGp5gfk4gjKPAGQYGhXyfTmJgHnuyUJ1ZaEwlnTwbAk3Wj3Mt6HkxCp5xXl/yWfBo6Uj7EIv3QFTjIxHP/k2nW1rpyHToGGoav177BZ/FYI2qeopN4dl3LE8k85Ip0xw8DMTxXuVNE4CukgoECc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjd3UJEX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjd3UJEX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746521666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wPvglNEukGQhD+Y5wPUIpn0NUeRZN0KH5RrHoWHnaGE=;
	b=hjd3UJEXcdA29lZlmoX54uHgetdXPwpmDeD22pKNANcNkdJEIn2O6gNxMRWCQyyQihxjHn
	0C/Ihoqo2xm0MEE+ztJyUzod19K15jB5WdYQxnqM2ZtwY+ViBHE5z2B29gp2eF70jIPPD2
	yxR6EZXTuoSaiMiszlu2jnspyn0DNb0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-0afWw-StMpm-_caYvSph6w-1; Tue,
 06 May 2025 04:54:23 -0400
X-MC-Unique: 0afWw-StMpm-_caYvSph6w-1
X-Mimecast-MFC-AGG-ID: 0afWw-StMpm-_caYvSph6w_1746521661
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B20F51955DC7;
	Tue,  6 May 2025 08:54:21 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 30E631956094;
	Tue,  6 May 2025 08:54:14 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v6 14/14] arm/kvm: use fd instead of fdarray[2]
Date: Tue,  6 May 2025 10:52:34 +0200
Message-ID: <20250506085234.855779-15-cohuck@redhat.com>
In-Reply-To: <20250506085234.855779-1-cohuck@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

We have fd, so might as well neaten things up.

Suggested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index abb63b7f617f..1ffd67a39056 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -387,11 +387,11 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR6_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_MMFR4_EL1_IDX);
 
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr0,
+        err |= read_sys_reg32(fd, &ahcf->isar.mvfr0,
                               ARM64_SYS_REG(3, 0, 0, 3, 0));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr1,
+        err |= read_sys_reg32(fd, &ahcf->isar.mvfr1,
                               ARM64_SYS_REG(3, 0, 0, 3, 1));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr2,
+        err |= read_sys_reg32(fd, &ahcf->isar.mvfr2,
                               ARM64_SYS_REG(3, 0, 0, 3, 2));
         err |= get_host_cpu_reg(fd, ahcf, ID_PFR2_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
@@ -429,7 +429,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 
         if (pmu_supported) {
             /* PMCR_EL0 is only accessible if the vCPU has feature PMU_V3 */
-            err |= read_sys_reg64(fdarray[2], &ahcf->isar.reset_pmcr_el0,
+            err |= read_sys_reg64(fd, &ahcf->isar.reset_pmcr_el0,
                                   ARM64_SYS_REG(3, 3, 9, 12, 0));
         }
 
-- 
2.49.0

