Received: from mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2703A8736
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278930; cv=none; b=StMqVo6U78xqylSSRrpMfcPuvTm8ZbyZx34n1G/k47UACxtkE5NIH94TGUyVyR7eQOkLuMpfmG9XtuWmsAi/OqRzrXpM5KlYi23US+DgdowlFqRPK96r42YUyNFn+pSTRSOXI7kvKecOKkedIp344Mpz7IotJh5ekxF6WqEu1wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278930; c=relaxed/simple;
	bh=I68XOz2+dlHst72wv+RGCM6KpZ5GGkDGvyZu0sm4Syw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HJ6uN6/6tRfJxJf2mfIMYYKOhnN7ONYqLhUEmhPap49Ugp8vm8KROhwUdWBI5km3onudgivKJ6x4O7P1wpcFs+FktjnhuRTYs4I2uf84kChZGiUSxS3JiL/xXzERAib1Wuo8KaxS5nzyv9dBJWF6dnT9eBBEj6vUh1s6tdmRbnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MEkA6Q8q; arc=none smtp.client-ip=95.215.58.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MEkA6Q8q"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=I68XOz2+dlHst72wv+RGCM6KpZ5GGkDGvyZu0sm4Syw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791278926; v=1; x=1791883726;
 b=MEkA6Q8qN0UqhysbHM0zMcwF6xt4Y2Tyq6RrdzLp/N9665hbEBYSrm4vkkQvZUt9NsbD2OWJ
 D+VDYoqYlZMuH8r+uIwKZpP0NmRu6zR1nvBNrIDwHuIY998qpIzH1bHEmxgPDO5NOTc91j8yJLR
 dY8bOTmn3TTkJsUaD23oCZB8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d166d98b4bdd94e5;
	Tue, 06 Oct 2026 09:28:46 +0000
X-Mizu-Trace-ID: d166d98b4bdd94e5
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
Subject: [PATCH v4] KVM: arm64: selftests: Check the pending SError state in external_aborts
Date: Tue,  6 Oct 2026 10:28:41 +0100
Message-Id: <20261006092841.2202109-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None of the external abort tests look at the vCPU events once the guest
is done, so an SError left pending after the guest took it, or dropped
while the guest had it masked, goes unnoticed.

Read the vCPU events back at the end of every test that runs the guest.
The SError must still be pending in the masked case, with the injected
ESR when the vCPU has RAS, and no SError, injected or spurious, may be
pending in any of the others.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
The check that no SError is left pending after the guest took it is
what fails without commit 3708f6342f01 ("KVM: arm64: Sync HCR_EL2.VSE
back to the host vCPU under pKVM"), in kvmarm/next.

Changes since v3 [1]:
- Check the SError pending state at the end of every test that runs the
  guest, and assert it is still pending, with the injected ESR, in the
  masked case (Oliver [2]).

[1] https://lore.kernel.org/all/20261005050349.836795-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/asNdAXGkxagm88Su@kernel.org/

 .../selftests/kvm/arm64/external_aborts.c     | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 7836756a38a6c..1a858d0d82968 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -75,6 +75,17 @@ static void vcpu_inject_serror(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
+static void vcpu_assert_serror_pending(struct kvm_vcpu *vcpu, bool pending)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vcpu, &events);
+	TEST_ASSERT_EQ(events.exception.serror_pending, pending);
+
+	if (pending && vcpu_has_ras(vcpu))
+		TEST_ASSERT_EQ(events.exception.serror_esr, EXPECTED_SERROR_ISS);
+}
+
 static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
 {
 	struct ucall uc;
@@ -134,6 +145,7 @@ static void test_mmio_abort(void)
 
 	vcpu_inject_sea(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 
@@ -162,6 +174,7 @@ static void test_mmio_nisv(void)
 
 	TEST_ASSERT(_vcpu_run(vcpu), "Expected nonzero return code from KVM_RUN");
 	TEST_ASSERT_EQ(errno, ENOSYS);
+	vcpu_assert_serror_pending(vcpu, false);
 
 	kvm_vm_free(vm);
 }
@@ -185,6 +198,7 @@ static void test_mmio_nisv_abort(void)
 
 	vcpu_inject_sea(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 
@@ -212,6 +226,7 @@ static void test_serror_masked(void)
 
 	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, true);
 	kvm_vm_free(vm);
 }
 
@@ -247,6 +262,7 @@ static void test_serror(void)
 
 	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 
@@ -288,6 +304,7 @@ static void test_s1ptw_abort(void)
 	*ptep |= bad_pa;
 
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 
@@ -313,6 +330,7 @@ static void test_serror_emulated(void)
 	vcpu_run_expect_sync(vcpu);
 	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 
@@ -356,6 +374,7 @@ static void test_mmio_ease(void)
 
 	vcpu_inject_sea(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 done:
 	kvm_vm_free(vm);
 }
@@ -395,6 +414,7 @@ static void test_serror_amo(void)
 	vcpu_run_expect_sync(vcpu);
 	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
+	vcpu_assert_serror_pending(vcpu, false);
 	kvm_vm_free(vm);
 }
 

base-commit: fa22cd9947fc245d71bc40482f7f78eb0d5a4af0
-- 
2.39.5

