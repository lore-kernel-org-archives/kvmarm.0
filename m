Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A332815D1
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 02:24:43 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id d10-20020a631d4a000000b00491da16dc44so4526842pgm.16
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 18:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb/UL9N+TdW3lyMm25d4vAkbjgvwAOnK9Fl+rduzRIA=;
        b=rEqCGz6t8QyQlPEI0NMPzk1i6EQpUrqa6XyEDrHbO0wHyeOeEfrPcIfaXWhoIk77s+
         UJd9yLZ6nX5O36ou5ENtRg9HtJXknlVeiIy+PS0zgiJiZGktSr6V9oILhwEYoP/Rzv/9
         rF1qj27evW3vgFYHed2IJLijv0bCseAxNKZq4DGaJRc/huiFJjonxXEIaFpoFPQGlYaE
         206m63B4RZrIiKDikwfEW5iyncqvQUyQxqNe2td0EivnsXeT8nQkZsqYNgUBcInnikzD
         BY+oKQJy7tU376nIBOiivhwFpd0AB+RuDVOYNx1jICIJU/s3lQB36RVg3j22zWX2b1GG
         je8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb/UL9N+TdW3lyMm25d4vAkbjgvwAOnK9Fl+rduzRIA=;
        b=AIyxP9v18tA1HcyNTvumGYoGmZb25zpk+X7hs1H4HfVBd87wmtxW8fqvGJ+bOz1Iv6
         nirl7sLgeEmxXQXnn0ItN2y1T55xLHt0rEKOsLr179qf0kYvtFzKCod0MW0TX21UzNOg
         lhIFrgUa4ib+DappUTY6NsXx3fjHkAZKw2cJ3xraUwIt/4NhWSuiYYsxxmF3uKCqGL3x
         G24204ICOZKTYpZSiz/GHdh1s1bYLHVoCZCaD9NhKZmvNxEKKSccF2kwYxSOgrBU3Bty
         RnNYfMaZ1qmeRXS+t4hGoxEZ2yuNV1Q6dU/dtRO0P7r7wx6OnCW/R1hnhXbBfSwSeeIp
         sjtQ==
X-Gm-Message-State: AFqh2kptt4JM1RF6/gfkab/kOBiQwV1kwFpNLp8gw1Vgs5rU5Ca+GKqg
	UI2FlGNzzM8JXXdHWDyS+MrGGKES5KUGlQ==
X-Google-Smtp-Source: AMrXdXvlWGEjWfWcZbHDWIm9NmwSybJsE2rgL2m0oZSh7/z6aEYi0sv6dlvDGgg3uUUT97CYCNP50UyE+Oc6NA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:a0f:b0:581:366c:64ff with SMTP
 id p15-20020a056a000a0f00b00581366c64ffmr3772266pfh.85.1673317483224; Mon, 09
 Jan 2023 18:24:43 -0800 (PST)
Date: Tue, 10 Jan 2023 02:24:32 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-5-ricarkol@google.com>
Subject: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the read-only memslot tests in page_fault_test to test read-only PT
(Page table) memslots. Note that this was not allowed before commit "KVM:
arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
were treated as writes which resulted in an (unrecoverable) exception
inside the guest.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c        | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 2e2178a7d0d8..2f81d68e876c 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -831,6 +831,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.mmio_handler		= _mmio_handler,				\
@@ -841,6 +842,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_test		= _access,					\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
@@ -851,7 +853,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
@@ -863,7 +865,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
@@ -875,6 +877,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_uffd, _access),		\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
@@ -890,6 +893,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
@@ -1024,7 +1028,7 @@ static struct test_desc tests[] = {
 				guest_check_write_in_dirty_log,
 				guest_check_s1ptw_wr_in_dirty_log),
 	/*
-	 * Try accesses when the data memory region is marked read-only
+	 * Access when both the PT and data regions are marked read-only
 	 * (with KVM_MEM_READONLY). Writes with a syndrome result in an
 	 * MMIO exit, writes with no syndrome (e.g., CAS) result in a
 	 * failed vcpu run, and reads/execs with and without syndroms do
@@ -1040,7 +1044,7 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
 	/*
-	 * Access when both the data region is both read-only and marked
+	 * The PT and data regions are both read-only and marked
 	 * for dirty logging at the same time. The expected result is that
 	 * for writes there should be no write in the dirty log. The
 	 * readonly handling is the same as if the memslot was not marked
@@ -1065,7 +1069,7 @@ static struct test_desc tests[] = {
 						  guest_check_no_write_in_dirty_log),
 
 	/*
-	 * Access when the data region is both read-only and punched with
+	 * The PT and data regions are both read-only and punched with
 	 * holes tracked with userfaultfd.  The expected result is the
 	 * union of both userfaultfd and read-only behaviors. For example,
 	 * write accesses result in a userfaultfd write fault and an MMIO
-- 
2.39.0.314.g84b9a713c41-goog

