Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACA29BDAC
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938403; cv=none; b=gGzhX0fWtO7y7YkjH1eitHQmLE9bEI9TmcKT1Shw7B0gIZlwtl4GdIpGhDxsaRQqg2v6eM7vG7N5Y3lEQa6DHmhXHrt7wm7Q7BUSnYL2NTIM71KmNgqAZ8EOJ7dYI9KILmSl+19gY4aKTjTrHacKzqOBWWIXqVqWgs/2yF2VzpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938403; c=relaxed/simple;
	bh=3wecD8tDbMduXMg+9TJnfvZ/c3CKE6Q3RD2TETZcXlE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Nns3HPD7qKAmypDMNMc2dUGCKtYpDX+8XKA0fn6+XDcwHJVUZX1HsEz9OzIJ2QPPx2fm+tjC0pnwsp7WDOyHwjrd2u6r4UjvWFqZtSqBP3EnaSbt9GKHkxBBi1Ca+Rn9n85st0CleQjuYYGcPYTBix4MI1UFryk7J2Vvv3LoD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rcezhYdo; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rcezhYdo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759938398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d/u4jReseop0/bCsd+wYtyXTYZOtdfFVumMqa5wsKfA=;
	b=rcezhYdoDGbo67O7mVxNiF7OAuu7Nr92tcfx/Beh0AJb5OvqT3NVpzQHtTaJa812Vsxe//
	iXJD/VxrdptNvozqNBMxTEvuw7seNY6W4OXD0/hcgA0ee6uFOJxCJ3b2vOOAz0qF5rwOM+
	1FyyfI2En61qXOJzc+HmFWrkVGleibQ=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Allocate vcpus with correct size
Date: Wed,  8 Oct 2025 23:45:20 +0800
Message-Id: <20251008154520.54801-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vcpus array contains pointers to struct kvm_vcpu {}. It is way overkill
to allocate the array with (nr_cpus * sizeof(struct kvm_vcpu)). Fix the
allocation by using the correct size.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 87922a89b134..b134a304f0a6 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -331,7 +331,7 @@ static void setup_vm(void)
 {
 	int i;
 
-	vcpus = malloc(test_data.nr_cpus * sizeof(struct kvm_vcpu));
+	vcpus = malloc(test_data.nr_cpus * sizeof(struct kvm_vcpu *));
 	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
 
 	vm = vm_create_with_vcpus(test_data.nr_cpus, guest_code, vcpus);
-- 
2.34.1

