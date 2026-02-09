Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688B328B61
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676869; cv=none; b=mGqjExULn/ZPaf1X4fQ9bMUfCttqMH5XtTgMXJLMZLLyQPeEL4/LRrWhPILrdbZM/i4M2AaDCbvaRDv0sdQrf+xswRM/7tc2HfyoSegVm/B1w1t/LYBWq0lnS0PUoLGJlJFn6zWu57OAQ9iQZ9ocavuijMLV6/JYnyU0ArRbDoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676869; c=relaxed/simple;
	bh=SHVJoQZ+YflPOx5JrxGn/C/DEC5GjFnR/d7ZsgewPiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XDnDbQCXKO4Z1j1VUkiyK0imW8rfk30hDLEDOsFxRtR6XH3YnaquBi7C7/qHxWXi1SSy0ytc2Q/MI088lBZryz2s0/fJ/GZJ0VjmNECdjCeNCI7q5xWhQAj0OOHvSl8EKNxBTdTa/GQT+r4A+vK7Gn3GJ2nc+0DozOXWxnXLp68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tGQ/b48a; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tGQ/b48a"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-66308f16e13so9035386eaf.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676865; x=1771281665; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/TKm1gU8lTLqEcn/8yRmMV0Zp5pYjSJjWs0bsDB+GUI=;
        b=tGQ/b48apYVHlSlfvPqJ8evEfU5CfUdDbIUNmCWtZOAa4ZgS+lQHMqol6t5M4e7a2U
         85WZ0FKVvVj2zzzRsXx+zca1r3jOPwTwtN7zEg+iinKT/ZA22ooAbzw/s/lgWA0KG62b
         NczyIeGG1WAklCl+vFa1DvPwSPG74m//wpdHv6FUP1BWtLl6covJmQ+EhtA+Z+uwDHJo
         C/T24cSEdv8CCPFWsyEDXBuLncY58N5H3YrErnOfMEb9Y2CISRe3MWhhKL8MvE+ntnkG
         l/HKOV6btyHD/TfRLVuD0kPK7XuuBeDkBk0X/G7/dv60jj3cpYCBcixKZQug7dSHQUr/
         B4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676865; x=1771281665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TKm1gU8lTLqEcn/8yRmMV0Zp5pYjSJjWs0bsDB+GUI=;
        b=PptO31XkI51lybN+zBEbvZ/LBTqu/ydgtY9riab438g7E+Jo0105+PqUOoEygjg2cg
         5jHdsgBloFHStmlbO7HghulrNcFpgW23tSR6tSz5nkBrf3YTnUBz6/UIQ8HYyEtZ/mdc
         HbMfj18BS9ZwzaFvyuLy3AR3XMbUV8NKFnQyvhxJ9ROvy9Hru13l6M51bcA7meyeAq9J
         9qoTLKnogDYdot2fhRU8ZX8d7a6lfV0He7aVEC/dSTpFTItXJM5JKk8LCocbf8jMcnWg
         v3I1nTmQaUkzrA7sBAFQMUk8YN/jVtmfJViL86k3HY4XzZ+B0wEcF0U7rel4x2pgv4MZ
         8isg==
X-Forwarded-Encrypted: i=1; AJvYcCXmwtz8AfkSJlDkm/gcbLGOTjchS7FZiHd8WPwgwCFLTqloVvXiTV8WJl/fnOwX0GqE1OnFJ1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTaPJvo0mCHQpzK26Gc7dNSuVFV36jKAwcFTzjmmzKOxmiO7a6
	DhIDojUAtriGOgwhrKXGVil9WAXyafadIvpZr59jPYe0Sy58hLPX4iCUS5XcHOIPge5Oz2U0jBn
	21vOlPCAoOe/tZkq333X9saOi7g==
X-Received: from jaox17.prod.google.com ([2002:a05:6638:111:b0:5ca:fdfb:2007])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:f015:b0:663:610:cb67 with SMTP id 006d021491bc7-66d0a477b40mr5663839eaf.28.1770676865086;
 Mon, 09 Feb 2026 14:41:05 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:14 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-20-coltonlewis@google.com>
Subject: [PATCH v6 19/19] KVM: arm64: selftests: Relax testing for exceptions
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
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
2.53.0.rc2.204.g2597b5adb4-goog

