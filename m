Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C7446AA6C
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 10:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985445; cv=none; b=PH0q4hBCCGyn4+STPBwUjgF2/Da7twahPIbV8ikRt2aQSpqg9kZUfVA00KPHgVVhuDuLJBLmH7973cSKchbnlvzzglyonprF+7SG+cV58kW8ikhrt5wPnb689buzKVUvZj5CS23d4hBKWP7xjSaNujCWTda2vzpSvqHlXoQc3Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985445; c=relaxed/simple;
	bh=0WEUwWA13h6lSIRRHugW7N81xLfWs7SnLHtINewqeBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mp9cNkPI6NhQtp6osUZ1KxCu0p5zIFoW8X96IjNqO29bfUJOOI6IutAC9qPIe75Bp3pymSBAXpXaWCmDzTqsBKiCpt6JD0HdRAnN6y1uo3y5bGpeVIkTTIGwhC7t6M9/IhjQsirZeNrWB5MviunNBNBqu6gk2A19ecZwV+q7Mwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hdhewLO8; arc=none smtp.client-ip=95.215.58.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hdhewLO8"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0WEUwWA13h6lSIRRHugW7N81xLfWs7SnLHtINewqeBo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789985441; v=1; x=1790590241;
 b=hdhewLO8IRIHObIEz8+0C9kBmser7+1cdmUfPOwOB3HAz7dt73431HNwews1PbNLVfusSj/B
 xJIlGH5fuZFXHpzzpNlAoBNQkkJL8cHKbcHXy0rZlTvnOn4f9tQAu1ILq5UAwn6aCb01ipY+GRW
 Ip5FJF01O2pwmFCFQmnhNlhc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cf336d2bb085442c;
	Mon, 21 Sep 2026 10:10:41 +0000
X-Mizu-Trace-ID: cf336d2bb085442c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: selftests: Check SError is not pending after delivery
Date: Mon, 21 Sep 2026 11:10:30 +0100
Message-Id: <20260921101030.1231605-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921101030.1231605-1-fuad.tabba@linux.dev>
References: <20260921101030.1231605-1-fuad.tabba@linux.dev>
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
 tools/testing/selftests/kvm/arm64/external_aborts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index d8fe17a6cc592..b276a4998a92c 100644
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
 
-- 
2.39.5

