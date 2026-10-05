Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E857B1E2834
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791176636; cv=none; b=IOQKshPtdWHQNcxdjdF2FpGT2NsQ22bqDqgbVYAXM+RaBJ6K6KR9ok1oBpaKIRrjpF0rHP76yLrQLZnJcWxmozJdLmtJAoSn5PHl0Dcoi62/bzvp504fXQUbaEZ8i/aaqjOB6fxSzkQiq69+JRo1T5tVad7LhMUg5fMYxGwDjhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791176636; c=relaxed/simple;
	bh=1rAAjG7z10ioumPSrvqWzbDK82NOUf1K670uFQMRS8o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lh5mNR4DkaoDYMD+n7/2WSRizxrflVZJsY3QeI+3AeGhfb4ikKWJQyLzGFkxgrA9L77gb7hACY2DpYrnuPiJH2vYzudmsnAR+3cTXyXtJ+cSfSjZwiUmc8441zg2aycQIpYbRgGu8vtjEHpoEB1T/6ZP2/mK1Z2HV4Fxm1FFhSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oDMhlVj9; arc=none smtp.client-ip=95.215.58.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oDMhlVj9"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1rAAjG7z10ioumPSrvqWzbDK82NOUf1K670uFQMRS8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791176631; v=1; x=1791781431;
 b=oDMhlVj9/nI1UZ/sFwlnmgPqdqbnBPoYi3iurNSUjbU4rIQS0n/T78TbtBGGI3/ht/Gwel5i
 1iZpxicyUc0ukcYzN6kqumBkthyxRM+sEBD9P8z0Bzc2Hcur/WJiNK1+nTHEBlZfkhXBh2xLvm2
 tt9u/Xzev2SonrF/sX/c0W6M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 80948e4cdbc2f4cc;
	Mon, 05 Oct 2026 05:03:51 +0000
X-Mizu-Trace-ID: 80948e4cdbc2f4cc
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v3] KVM: arm64: selftests: Check SError is not pending after delivery
Date: Mon,  5 Oct 2026 06:03:49 +0100
Message-Id: <20261005050349.836795-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_serror() never looks at the vCPU after the SError is delivered, so
a stale pending SError goes unnoticed. Read the vCPU events back and
check the SError is no longer pending.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
The fix from v2 was applied [1], but not this test.

Changes since v2 [2]:
- Dropped the fix, now in kvmarm/next.
- Rebased on kvmarm/next.

[1] https://lore.kernel.org/all/20261001135711.1640520-2-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260921101030.1231605-1-fuad.tabba@linux.dev/

 tools/testing/selftests/kvm/arm64/external_aborts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 7836756a38a6c..c35b0c87250a1 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -239,6 +239,7 @@ static void test_serror_guest(void)
 
 static void test_serror(void)
 {
+	struct kvm_vcpu_events events;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_guest,
 							unexpected_dabt_handler);
@@ -247,6 +248,11 @@ static void test_serror(void)
 
 	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
+
+	vcpu_events_get(vcpu, &events);
+	TEST_ASSERT(!events.exception.serror_pending,
+		    "SError still pending after the guest took it");
+
 	kvm_vm_free(vm);
 }
 

base-commit: fa22cd9947fc245d71bc40482f7f78eb0d5a4af0
-- 
2.39.5

