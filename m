Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D53B30E84D
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944392; cv=none; b=qC98wiThifr28Q5MMdN1GV0G4iKpoN994Tgq/wNxESTXoqbUK/pSNJC56zeO1mpl5Q/hc89+8WfagAMKoOhBbWw9/JXlrzo0LUdPWGcAjNML4DK4lRRulnIXjwYrQJfWDqjpPohG1iNSDdvwrwT7JBmI2mUmUuMuhdW5qnUz/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944392; c=relaxed/simple;
	bh=VPHE8yc9++1Vdm0H0mvGHvExX7WWaEVR/unz16UcOc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV0uxs1c+Anb1w1Bc26eYBq7o8G3LLvoFQpyPL8RiUDjyzH8ktBpMRGmEjfD0uexkG4b/eJgE3//GcNvNdyb3lFrLIXRJNZKfmdBx4231uD2xXL6qrPfGi9vWDTSqg6GrzbD3UsMsl52hA/R5iXvTo374CBnKBol/T9Iiv6/Ns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Lpz/ebQf; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Lpz/ebQf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779944390; x=1811480390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VPHE8yc9++1Vdm0H0mvGHvExX7WWaEVR/unz16UcOc4=;
  b=Lpz/ebQfXObIO422FyNAlwtz837jhUyu2lZAR88xpQ1ulS9dF0B+uZcR
   dE52xxsPV02pGNScfeYilEgTdIvUWSsbPckMQRT6j6CpKVA6GpB48MoVM
   n468QUCuURxV5Nkmr+D1cM0PlUoa9oLyoDEdJoDCo9dqzaD4VQCLZVyrH
   maPFYlynsjaDw01eNwtHeP7qMNU258i+Z59LgFCGNufI1uVnjlMh2HJIJ
   67bxamTpHwFMhVxz/whyesocMAfHSkG1JtIVRy1Kj5307l0u6IMRh1I3T
   x93EtJPR2wFgXi7OyvElPG7VafGETj9C5q4wf+uYIKzE5C+taBUXqu2al
   Q==;
X-CSE-ConnectionGUID: 5eZ1dNGvSuOOkTpR0gxkJg==
X-CSE-MsgGUID: E2uW4Z9KQDC3FBBkUF+2+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="229488619"
X-IronPort-AV: E=Sophos;i="6.24,172,1774278000"; 
   d="scan'208";a="229488619"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:59:43 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 72F3E1002812
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 04:59:43 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 276C286082D
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 04:59:43 +0000 (UTC)
Received: from sm-arm-grace07.ssoft.mng.com (unknown [10.124.178.20])
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTP id 9EBC7101E475;
	Thu, 28 May 2026 04:59:37 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: weilin.chang@arm.com
Cc: catalin.marinas@arm.com,
	itaru.kitayama@fujitsu.com,
	joey.gouly@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH] KVM: selftest: arm64: Run shadow_stage2 varying guest modes
Date: Thu, 28 May 2026 13:59:30 +0900
Message-ID: <20260528045930.450339-1-itaru.kitayama@fujitsu.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516183003.799058-6-weilin.chang@arm.com>
References: <20260516183003.799058-6-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor main() to use for_each_guest_mode() helper to create
a single VCPU VM with a guest mode ID.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
---
 tools/testing/selftests/kvm/arm64/shadow_stage2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/shadow_stage2.c b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
index 5bce55abdea7..05acca22eafe 100644
--- a/tools/testing/selftests/kvm/arm64/shadow_stage2.c
+++ b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
@@ -105,7 +105,7 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-int main(void)
+int run_test(enum vm_guest_mode mode, void *unused)
 {
 	struct kvm_vcpu_init init;
 	struct kvm_vcpu *vcpu;
@@ -114,7 +114,8 @@ int main(void)
 	gpa_t gpa;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
-	vm = vm_create(1);
+	vm = __vm_create(VM_SHAPE(mode), 1, 0);
+
 
 	kvm_get_default_vcpu_target(vm, &init);
 	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
@@ -163,3 +164,7 @@ int main(void)
 	kvm_vm_free(vm);
 	return 0;
 }
+
+int main(void) {
+	for_each_guest_mode(run_test, NULL);
+}
-- 
2.43.0

