Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80120F090
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174885; cv=none; b=BN3XH63SrcxD4HMl3RfkqSED2sDWBGjbDuU0EzcAJLY8SmfWxQP4mv4uK+7+GVA9euSeH3ILqL10QKaLqBZ5wAq8DnLcvexDS2qKuau6O73VBKpm2QeVaf9tqv68n5apDduyPWn66rpxiwwAulDYnJ9OoPL2assAqn+HG9WWwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174885; c=relaxed/simple;
	bh=Qpf0p8SygINmjtF0svQLvTYA/WdrZh7FV0DwoMqOT+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=goZWYc0xRzs+66FkIVj3wY2y3oUdtaJVFqXsfPcbBi8vsohcjWbPtj9RQuvrV8qTKPPk6Ed+1MqFl7Or+kF+8TDz482l9KlfMdgHlqoH8Nx7ffGJfnoN0PLzi/kOHbvSee6s09V3Qo6c0bMoc7nQa3prRRuw48/PFA3KJFY41K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BB6uHH5x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BB6uHH5x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aSFgDrP9kHSG5CJCRypPsuwvrYcuRcBe7vg+Zrvp1qY=;
	b=BB6uHH5xGQtI1XL63lHYSzRbZfTSwKEha5899JGGIyXCYRZ9VmzRgVes71nHyEQparE8UI
	Sb+Y/uqu8JxdM+NbA8sWyvSfZc7mJGVm46qKuhAnxeJpZ27SE8JdjtfsLjJ6LvYyNeUfd7
	+298UQAAjcjugzm0LInfSDEqe/ebuLY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-140-4FPw8sDeNuyYaJs4eO6ETg-1; Tue,
 17 Jun 2025 11:41:16 -0400
X-MC-Unique: 4FPw8sDeNuyYaJs4eO6ETg-1
X-Mimecast-MFC-AGG-ID: 4FPw8sDeNuyYaJs4eO6ETg_1750174872
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0873B18001D6;
	Tue, 17 Jun 2025 15:41:12 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72300180035C;
	Tue, 17 Jun 2025 15:41:06 +0000 (UTC)
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
Subject: [PATCH v8 14/14] arm/kvm: use fd instead of fdarray[2]
Date: Tue, 17 Jun 2025 17:39:31 +0200
Message-ID: <20250617153931.1330449-15-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
References: <20250617153931.1330449-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

We have fd, so might as well neaten things up.

Suggested-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3df046b2b911..70919aedd0a4 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -348,11 +348,11 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
@@ -390,7 +390,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 
         if (pmu_supported) {
             /* PMCR_EL0 is only accessible if the vCPU has feature PMU_V3 */
-            err |= read_sys_reg64(fdarray[2], &ahcf->isar.reset_pmcr_el0,
+            err |= read_sys_reg64(fd, &ahcf->isar.reset_pmcr_el0,
                                   ARM64_SYS_REG(3, 3, 9, 12, 0));
         }
 
-- 
2.49.0

