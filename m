Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F75514D290
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654978; cv=none; b=lqizzKNv4b9Q9CjaKYD1w2wxVSLLaRDm6/3M9Db5OEIdcFeBM4S0Q0D3jxCOedz7eYErkFzVi4ZMd/FcvUXI3ZBBxlR0ntrs7763t9MV3o0+pz4A9n/mgf6UlN3coyZtbz+I2HQezMz0+4jgTGU2ghRB7K9qP62tTH3zg6p9EW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654978; c=relaxed/simple;
	bh=eBdL3QVT/FXe2eEdF9QRtRlL8ltbcelrbHtqXfp5W3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lWeYJ91Vr9CIy/7e4xqGlo82NYrz/tJYRYC7bvCVVQFn/wQtv0qot3XAD2MUcWO8isaDYnlJb68U1u+lrh/e/itFt5b5HgsKTz/w1+wEOUWFcKXcg/T/+Ji34nmN2V2KE23Sx4UTNZ7b5oEM8excyzS/hlI/y9q3xnVMgkGvSK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1WsSuuCQ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1WsSuuCQ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03c68c7163so521219276.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654975; x=1721259775; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=23lW1dYHwRXqrRIzh0tt4ShqtRWFD2EoChbCYcPjw+M=;
        b=1WsSuuCQUPEL+44Ja3UjxzsOSa3ncgFlSsEKS3z5GS7IRMNF+x2i42xS9aSkK/I7Ct
         CiBswLHuEoPnhxSqjpGusNnTtbWjLT1oLtqoZMwduIcnNvN/5piSmRBCkn7SKPEygwot
         XbxG78EZPBfCtnfY4nPji88Kk1LOWKtT/7o3BKmaD6B/b/0TJM01hWzkrALN8DFzQNK8
         TVG/KV+gP4J+hC2tufpspwAZlYxzoGhRS0WWJX0R7gAVf/Y4uZW2j8FUu+DW2G2abTJq
         nm/ya2xAXjBFCaAPhDzql4hy4clLc5eddrdDkQd2Yj56tq0J9cDw8pb6095WZiBsAp/f
         Z9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654975; x=1721259775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23lW1dYHwRXqrRIzh0tt4ShqtRWFD2EoChbCYcPjw+M=;
        b=ZJ2DLqpfxtSKa6JWT00lQ5/S+UfnuNbQnPcu/YOqlUSoU6rZhhSPvTsZTJV8gnjkeL
         smhjogtZXYcs+rn9EDal8Zq5IXc8RRZC/y0SFDcrhh1qbCDOVKxKCe8HI2daBBP7R1GC
         mUQkfsjrbb8h8y5VCi3e+BMQPnDCDwxF054YOtu7uAwfnOriPWKNjCSR1bWecfJtWPAn
         1lkb4VZpmlz0jAjky2UgpQaU8fXbPr+ynd1lgTYSbdHhlaHizyj5clTDQPGw83j/h0J4
         iPEw6N3lQfeR/EaZU7SCkS7UU6gHOrnF4dw8dN6PHsb5kkjXjTG7pFmE4+LnEUPtI5jz
         Sm4A==
X-Forwarded-Encrypted: i=1; AJvYcCVPG/VGKkN8BQxf3y3k8fbfIZwRDuUs6lOs6hUGrsngfEfwg39h4JUelKZbsB6mAkTse9AaBqQMdadvNQtqpd3Cj4Lf8Z/3
X-Gm-Message-State: AOJu0YyfFYYGjD86vPHOOrpvCLZS0YaISH2OqyoRLFIrsU6K0hKhQMDT
	7zmrSRz/1sTiKdDp5JNNWt87AJRQJ/mA0pZXPHdbifPFujVmeqelSnKGfxRLRo3npc0NXmZ9S/n
	UHDSVZt2L+GlRJfLNDw==
X-Google-Smtp-Source: AGHT+IH2x5mDHjhnJd4Mu/PM7RGmCTtDANjq+WihoofI52RvaYh1X5nH2Cnmm44GTYY+PggisrUn2Jo0WRfC2acE
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1ac1:b0:e03:62dc:63de with
 SMTP id 3f1490d57ef6-e041b0593efmr582356276.6.1720654974739; Wed, 10 Jul 2024
 16:42:54 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:21 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-18-jthoughton@google.com>
Subject: [RFC PATCH 17/18] KVM: selftests: Add KVM Userfault mode to demand_paging_test
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The KVM Userfault mode checks that we are able to resolve KVM Userfaults
and the vCPUs will continue to make progress. It initially sets all of
guest memory as KVM_MEMORY_ATTRIBUTE_USERFAULT, then, as the test runs,
clears the attribute from pages as they are faulted on.

This test does not currently check for asynchronous page faults.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 46 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680..8654b58091b2 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -28,6 +28,13 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static size_t demand_paging_size;
 static char *guest_data_prototype;
+bool userfault_enabled = false;
+
+static void resolve_kvm_userfault(u64 gpa, u64 size)
+{
+	/* Toggle KVM_MEMORY_ATTRIBUTE_USERFAULT off */
+	vm_set_memory_attributes(memstress_args.vm, gpa, size, 0);
+}
 
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
@@ -41,8 +48,22 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	/* Let the guest access its memory */
+restart:
 	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+	if (ret < 0 && errno == EFAULT && userfault_enabled) {
+		/* Check for userfault. */
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+			    "Got invalid exit reason: %llx", run->exit_reason);
+		TEST_ASSERT(run->memory_fault.flags ==
+			    KVM_MEMORY_EXIT_FLAG_USERFAULT,
+			    "Got invalid memory fault exit: %llx",
+			    run->memory_fault.flags);
+		resolve_kvm_userfault(run->memory_fault.gpa,
+				      run->memory_fault.size);
+		goto restart;
+	} else
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+
 	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
 		TEST_ASSERT(false,
 			    "Invalid guest sync status: exit_reason=%s",
@@ -136,6 +157,7 @@ struct test_params {
 	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
+	bool kvm_userfault;
 };
 
 static void prefault_mem(void *alias, uint64_t len)
@@ -206,6 +228,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
+	if (p->kvm_userfault) {
+		TEST_REQUIRE(kvm_has_cap(KVM_CAP_USERFAULT));
+		vm_enable_cap(vm, KVM_CAP_USERFAULT, KVM_USERFAULT_ENABLE);
+		TEST_REQUIRE(kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) &
+			     KVM_MEMORY_ATTRIBUTE_USERFAULT);
+		vm_set_memory_attributes(vm, memstress_args.gpa,
+					 memstress_args.size,
+					 KVM_MEMORY_ATTRIBUTE_USERFAULT);
+		userfault_enabled = true;
+	}
+
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -232,6 +265,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Overall demand paging rate:\t%f pgs/sec\n",
 		vcpu_paging_rate * nr_vcpus);
 
+	if (p->kvm_userfault) {
+		vm_enable_cap(vm, KVM_CAP_USERFAULT, KVM_USERFAULT_DISABLE);
+		userfault_enabled = false;
+	}
+
 	memstress_destroy_vm(vm);
 
 	free(guest_data_prototype);
@@ -263,6 +301,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -k: Use KVM Userfault\n");
 	puts("");
 	exit(0);
 }
@@ -281,7 +320,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:c:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ahokm:u:d:b:s:v:c:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -324,6 +363,9 @@ int main(int argc, char *argv[])
 				    "Invalid number of readers per uffd %d: must be >=1",
 				    p.readers_per_uffd);
 			break;
+		case 'k':
+			p.kvm_userfault = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
-- 
2.45.2.993.g49e7a77208-goog

