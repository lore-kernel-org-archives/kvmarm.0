Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0993E41C31A
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929542; cv=none; b=tfeb0Apeh+7k9c1tddkTRJ79ZRLt28B7aCUPIufZGq3wS4NPAuOFcwtCZ49gfFXbHzkCdE94fIluxhDPWZ/wjELBJ+LT0DJjvGlkby9lUHMuLk12M2B+8yRU8OK3h6RXXtwuHshLUz0ZbJ58QoMf/2rALbMt1wBn6HIyJpN95LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929542; c=relaxed/simple;
	bh=z22FJ/RoHsM+jeuWzpMU9byGN80HsM7C3iFbEeU0P2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tzD9ITpLeIu0yU0ldLX2CpykxFvp4N8GzLFup65FmxBIy7O3KSYJyRW5u7OCXXHV66lhD3J9M5YeuQrjwBIoHMoNlFVWHcgD8d2rZEYTGJyFxCEvgK1hRxIIYEpuu2kVIxIirCYeGmR4K/aliftJoxwU1XUg6vYmPxahAwXDSzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+6MxMc2; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+6MxMc2"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7dcdcacd141so6965246a34.2
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929535; x=1778534335; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BjlPgXNwXeFHjDTHfAecQAjmNwOoUuZdzNZWTJemW0E=;
        b=P+6MxMc2za3wt9Lpa/2/nyvVHyxAQAmI29ew2MbSc1zS8G+X9ATukw3FIIBfxG9mnX
         KE2/xhvJmhxzHO+IgKOhZvgkhpZnUBEYJ399jpORU6HadeSAeH2EL4sROABN1UFbpHDr
         YLmnLdZ1Mfe/kVouIZ9Mx8XybZN+xx6cYWIE6XnENpzo1ZKIXsqGNDxZnf+iBcVr6xqz
         3IFH+eZuIqzWJ0+H7yNdk6nkjA+a/PaJQgNtNsiBr1zciB8wHxB9TK4oAyHVCtlJHb1U
         USGVh23F8Hh6N9CLQXwjEXpnePmrqP6Ocfjhw59AvXXV7qbdPxiDa3q9bmjLhgO4m0k2
         H+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929535; x=1778534335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BjlPgXNwXeFHjDTHfAecQAjmNwOoUuZdzNZWTJemW0E=;
        b=CM81kPaVMlyITyM0hLzTXcRt4MTs0D2VdW3h4n/wQ1ryC/wrOCPdl4fzpO9CEvw7sv
         WgsFVpSKTiYI13mZHJzdbhmH/ddxzZZmlwlVlu2hl/DFaMC5IZ0FK0Wk0fhSJTTcsnD9
         EzHAxFxe0rjuUu7Xbz/a/IKyNCODIxw5o0G3bcziNyCUyK9Aku3rgpV2C+1wb6TQpGdi
         dpYta5FVDxnU7Wjoh/yw/bjeHrZUab59pC/08i+gtaQxqI+j2Q5CrFouXR+xoa/PoK9s
         e0NoaWgYa3zNNMcCttcZmEocm9xYG8pWKbsGXyUWZbphGkOb2AwaVkFSLJoob6YiALCL
         VSPg==
X-Forwarded-Encrypted: i=1; AFNElJ/9E5ECAyyA3SPClWKr7AfNpjTVmGiBF4GDbRrzYaI2OSRiJ9VZTzrROiCiKmB0ZpKCsHfgE1s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvhQymB0Lgjsa2IoUnOEl2+tCaSuHx6fha6jujEOO0juzBXB7t
	CN0g9bHr8hCNDqp8bE2Ir2anKFar4SBDiabidomhbJN/KQt3dJSFJ+ku45HaqVEqoc1Drucaiuc
	rvrKMI54xPavSM+2lfqBd9bO0Nw==
X-Received: from ilqt1.prod.google.com ([2002:a92:cc41:0:b0:4fd:69a2:6072])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:81c6:b0:694:8fb2:2c35 with SMTP id 006d021491bc7-6998a59a043mr161048eaf.2.1777929534601;
 Mon, 04 May 2026 14:18:54 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:13 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-21-coltonlewis@google.com>
Subject: [PATCH v7 20/20] KVM: arm64: selftests: Relax testing for exceptions
 when partitioned
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because the Partitioned PMU must lean heavily on underlying hardware
support, it can't guarantee an exception occurs when accessing an
invalid pmc index.

The ARM manual specifies that accessing PMEVCNTR<n>_EL0 where n is
greater than the number of counters on the system is constrained
unpredictable when FEAT_FGT is not implemented, and it is desired the
Partitioned PMU still work without FEAT_FGT.

Though KVM could enforce exceptions here since all PMU accesses
without FEAT_FGT are trapped, that creates further difficulties. For
one example, the manual also says that after writing a value to
PMSELR_EL0 greater than the number of counters on a system, direct
reads will return an unknown value, meaning KVM could not rely on the
hardware register to hold the correct value.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 9702f1d43b832..27b7d7b2a059a 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -38,10 +38,14 @@ const char *pmu_impl_str[] = {
 struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
+};
+
+struct guest_context {
 	bool pmu_partitioned;
 };
 
 static struct vpmu_vm vpmu_vm;
+static struct guest_context guest_context;
 
 struct pmreg_sets {
 	uint64_t set_reg_id;
@@ -342,11 +346,16 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 	/*
 	 * Reading/writing the event count/type registers should cause
 	 * an UNDEFINED exception.
+	 *
+	 * If the pmu is partitioned, we can't guarantee it because
+	 * hardware doesn't.
 	 */
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	if (!guest_context.pmu_partitioned) {
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	}
 	/*
 	 * The bit corresponding to the (unimplemented) counter in
 	 * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers should be RAZ.
@@ -459,7 +468,7 @@ static void create_vpmu_vm(void *guest_code, enum pmu_impl impl)
 		vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION);
 	if (!ret) {
 		vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &part_attr);
-		vpmu_vm.pmu_partitioned = partition;
+		guest_context.pmu_partitioned = partition;
 		pr_debug("Set PMU partitioning: %d\n", partition);
 	}
 
@@ -511,6 +520,7 @@ static void test_create_vpmu_vm_with_nr_counters(
 		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
 
 	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+	sync_global_to_guest(vpmu_vm.vm, guest_context);
 }
 
 /*
-- 
2.54.0.545.g6539524ca2-goog

