Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EF4E80BD
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609167; cv=none; b=SEtr+PJCoY604FDP1bWrDGN8VS8aVjvaeqVKmPzpaf9fUYWdBWXecDotwmzgl7XylOswzi8AQBRtPh+0dMDGwElPWSW7Uz612obG3xF4oR3FcDrh257rgvC4Fyn7rz8llYs67YNVJyk8HYMlr2Ep40z8/ZYsqQ8QAeHESKOhjMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609167; c=relaxed/simple;
	bh=3L7Qz5BjFOrFp7kkec0T9qY4CbqaUJC/XAFU7nYMJMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DRMjePzkd7GCKsfdzufcUrQxlpZ24DuxEEUKJc8zVfvSXCuNiLzmxcN7Q20lg2JPDKdpqX2sR+5BoyFws7R3vHFXRUsMLZgdzATwlunNT/cy684xtvipVjuyI+tzA/4LdriiPfvWbL183pigNxl9ddICjhTi+QyUrd6UZ1UFL0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qtBAy+Oj; arc=none smtp.client-ip=91.218.175.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qtBAy+Oj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3L7Qz5BjFOrFp7kkec0T9qY4CbqaUJC/XAFU7nYMJMk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609159; v=1; x=1791213959;
 b=qtBAy+Ojw7c1rhMS8J5aJeZyofhUkhCaCj5FbV1G1CnKCArO4V7nXoZ0h9W6PPtBF4Aa/nf7
 X8zEh0MWAHMkRw9xPxeXc5meDi66VIumgVyIGKtRPQYB3MMcHAzsNhy4XbzztxMnH+ZBAETzG7x
 Wh+BQ0Ih6lZf4z4VhaaEgflM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 18ace68e8bd67107;
	Mon, 28 Sep 2026 15:25:59 +0000
X-Mizu-Trace-ID: 18ace68e8bd67107
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 09/10] KVM: arm64: selftests: Free the VMs in smccc_filter and psci_test
Date: Mon, 28 Sep 2026 16:25:06 +0100
Message-Id: <20260928152507.2116110-10-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928152507.2116110-1-fuad.tabba@linux.dev>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_pad_must_be_zero() and host_test_system_off2() create a VM and
never free it, unlike every other test in their files. Free them.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/arm64/psci_test.c    | 5 ++++-
 tools/testing/selftests/kvm/arm64/smccc_filter.c | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index e775faf208680..7feb7394fe110 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -239,9 +239,10 @@ static void host_test_system_off2(void)
 	u64 psci_version = 0;
 	int nr_shutdowns = 0;
 	struct kvm_run *run;
+	struct kvm_vm *vm;
 	struct ucall uc;
 
-	setup_vm(guest_test_system_off2, &source, &target);
+	vm = setup_vm(guest_test_system_off2, &source, &target);
 
 	psci_version = vcpu_get_reg(target, KVM_REG_ARM_PSCI_VERSION);
 
@@ -276,6 +277,8 @@ static void host_test_system_off2(void)
 
 	TEST_ASSERT(get_ucall(source, &uc) == UCALL_DONE, "Guest did not exit cleanly");
 	TEST_ASSERT(nr_shutdowns == 2, "Two shutdown events were expected, but saw %d", nr_shutdowns);
+
+	kvm_vm_free(vm);
 }
 
 int main(void)
diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index 21e41880261b4..d5e4ba074a5c6 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -105,6 +105,8 @@ static void test_pad_must_be_zero(void)
 				  KVM_ARM_VM_SMCCC_FILTER, &filter);
 	TEST_ASSERT(r < 0 && errno == EINVAL,
 		    "Setting filter with nonzero padding should return EINVAL");
+
+	kvm_vm_free(vm);
 }
 
 /* Ensure that userspace cannot filter the Arm Architecture SMCCC range */
-- 
2.39.5

