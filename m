Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69211298989
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817635; cv=none; b=t9dfZR2jrq1gJtGN/kVizzOZl3sCOHLOTXbg+n8al+6Jp4lgaZHOKhdFDEE7cGu95ALNjCfmSIRBtRsTDM21e+tCD0tP15YQyBpRK/yGv3+x3ny1d87GWrm+SwdGZ6HrmWwo6Y3MDALf0w4fiwi7UECfFzYn/xRDzkGtGLT80rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817635; c=relaxed/simple;
	bh=fdpTasDFylH0aih/WYUrRlBApDM32hVkvXUFxrZnj7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NWJs59+HXUPBeI/z+WSHfVFHYBz3BXv6PNx07Aap92D973ocNMXkQLKYv0Xn8KBIXkXOilZFEHOP6Db+nlx8MowFUBox2rv/u8AevHpFVvyVk2z6M+dFAtlEySzIXLY8AdNb1lk2SHixMCvVkhjprqoAggLmjBeHqAsT4vVG3uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S3Nk07ta; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S3Nk07ta"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31332dc2b59so5851961a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817634; x=1754422434; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7kW936wFYM0Ary5B3+n4kBp/4+0suFDEkHTdVVXpkj4=;
        b=S3Nk07ta7E1Ut6IKZv4KUIjFSJ5f8FWL5V0UybjThr29aou1qHN3kgB3UjhsZ7kQrv
         f0lOlPPOJYJc1N2lylcOKahdfLiVCIS7HAHGuTB2CwqD1UDyGcOiyJTT2OBz2+XlFXQi
         pxMwjrSr2zu5RXQ32xNgpR/oXLDLUYN9/J/Ch5cG/mPM+LBef+FyBe0suQV8PubNh4uZ
         CvaoEIICFQ12MBExV1fHrQW7kBgrKIcKnwixKl6lJJ/XOQouQjMsVH9A3Qev3sixPIq2
         /uX+QbeAN3Gm9gzPE2dqNxyOO7kQUgj4rw00hzQD/Jfnfwlh0t9jPJug0tyxcYWtJGFG
         opSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817634; x=1754422434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kW936wFYM0Ary5B3+n4kBp/4+0suFDEkHTdVVXpkj4=;
        b=lKGMuWHcpfhxErZQcNZmyI/m2M00hlLZabDOR46X/yx1/mc9tnd+BLnxFY4pDnHd0R
         Iava9CLVqdbNpTF5kJmFq2XX6BKbcZssHBgiOpBY8mNbSx7fFiI6iXCF3GKq2bM5hthD
         co723/fUwQdj+3w1BTVhLhwfBqmUOg0VuRca0H2hcBnQTIyB4WhjmVlp19eOJG8cKRC1
         QPXgZga95ohlosGM+4KFjTwPddzKdtzzKGgQsqz6LbBgKX+dxWgwzbWqgiOnTJ/B75O5
         J0v6UQM4RS04RaAOo4ODvO53K3gkXaJyKVunigxICapIGVt38ev9UTfp/qTMSdXbNlOO
         hUeg==
X-Forwarded-Encrypted: i=1; AJvYcCX1vzFIVx0cZzUbRn9dqEKfYeUZ7vb8INBes/RT54kOkiEmYXxvZa+2elVudcnoG4HQMY1XSQ0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/E9gWT0rlxPCtnlupCAx+KaMfElTU7Iqm9X4zdOFrnS0hqT6M
	NouTX8O3OcB3nEJiLD+Mck04p08DIUeuLmDubuIrm39xtpzMoFDQ8x7aDp8ioCafPEXlhcJ21Zb
	gJm7iLA==
X-Google-Smtp-Source: AGHT+IELFOFWc8vYkYZRQRf3VfKYyLdceEz1T/Y/HkOfoDthT5RfeT3LHFZMzx5elvj9USSUE7rYmRIpqRk=
X-Received: from pjsc3.prod.google.com ([2002:a17:90a:bf03:b0:31f:a0:fad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2684:b0:313:20d2:c99b
 with SMTP id 98e67ed59e1d1-31f5dd9de5emr917579a91.9.1753817633690; Tue, 29
 Jul 2025 12:33:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:39 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Use for-loop to handle all successful SEV migrations
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Use the main for-loop in the "SEV migrate from" testcase to handle all
successful migrations, as there is nothing inherently unique about the
original source VM beyond it needing to be created as an SEV VM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/sev_migrate_tests.c     | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 0580bee5888e..b501c916edf5 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -14,7 +14,7 @@
 #include "kselftest.h"
 
 #define NR_MIGRATE_TEST_VCPUS 4
-#define NR_MIGRATE_TEST_VMS 3
+#define NR_MIGRATE_TEST_VMS 4
 #define NR_LOCK_TESTING_THREADS 3
 #define NR_LOCK_TESTING_ITERATIONS 10000
 
@@ -72,26 +72,23 @@ static void sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 
 static void test_sev_migrate_from(bool es)
 {
-	struct kvm_vm *src_vm;
-	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
-	int i, ret;
+	struct kvm_vm *vms[NR_MIGRATE_TEST_VMS];
+	int i;
 
-	src_vm = sev_vm_create(es);
-	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		dst_vms[i] = aux_vm_create(true);
-
-	/* Initial migration from the src to the first dst. */
-	sev_migrate_from(dst_vms[0], src_vm);
-
-	for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
-		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);
+	vms[0] = sev_vm_create(es);
+	for (i = 1; i < NR_MIGRATE_TEST_VMS; ++i)
+		vms[i] = aux_vm_create(true);
 
-	/* Migrate the guest back to the original VM. */
-	sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
+	/*
+	 * Migrate in N times, in a chain from the initial SEV VM to each "aux"
+	 * VM, and finally back to the original SEV VM.  KVM disallows KVM_RUN
+	 * on the source after migration, but all other ioctls should succeed.
+	 */
+	for (i = 0; i < NR_MIGRATE_TEST_VMS; i++)
+		sev_migrate_from(vms[(i + 1) % NR_MIGRATE_TEST_VMS], vms[i]);
 
-	kvm_vm_free(src_vm);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		kvm_vm_free(dst_vms[i]);
+		kvm_vm_free(vms[i]);
 }
 
 struct locking_thread_input {
-- 
2.50.1.552.g942d659e1b-goog

