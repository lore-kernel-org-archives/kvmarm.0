Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D3E5222
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 21:44:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4cddba76f55so69145057b3.23
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 13:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxl12ovx7VRU+WHFkX8OH/d12QRd76yC440A+zPHtE=;
        b=gMp4A6O6/1b4rlE7oumSCdXh/cftkGSCBQDtrZZLgJJbNnN5ktVKxgYwy14+GTVYhL
         19CRJB7jQag9sLKRMgdiLPErYNYcDO+hI/1rxGUgJSn/BtPFZIu3hM+FEjvjoBj72W0g
         2fdzi87UIWXrHC9ZirA+iJk32u+Ns8cF5sUZej8ZXSMTdCgB7T7N14lDnk6jrDVExsHu
         9j2eZFAeijK9gVqP9LChqBtLBngE5MB1oadQgqm21QW5q1Ilrb8KTKtJ9A6ceu5seJx9
         0QYaGqvRh2pvudNwpYy/ERKoc3wVabf+Ij3/Ll0uSoWnch3jQB8Z3oiUo55PuobPfFf4
         vNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxl12ovx7VRU+WHFkX8OH/d12QRd76yC440A+zPHtE=;
        b=HThagY6rZz0PtDUZ00m+ShYrPKvC4wTzWmdIHubbDEXA2XE5UmzyNhBOTytg6y1atl
         beRFEQLZ8BioFi9GUUlAabr1ImX0B6ln3G283QZ9jMFqOaO9FGhEZrcnAYzrVoloU3Wp
         xmYoZjTYieYGIEDJ1v8wg3oXrmBsDRl6IksBcQY9GNkr7QHuFAIQv1W8xv+pzmh0Z9KC
         agBeWvk1jkv5oISPARFiqDSFMBwOVp45yOvVlrk68piCKf8TNKERkvK/U5mZBIxxmREq
         Gh0jQrjh6Qr2b4sVnZjflJiV/5Cycj3EFe1WkE6glpi4f9xEri2uqqY7TzmbUPBr8NnK
         7Y/w==
X-Gm-Message-State: AO0yUKWVieUKoBqJB++LR+LwR7Wn00c9LFAD55XwcDc0vlDunrYHdjzP
	/3BcWb0CoF69h6Sauu0JWlmEi6xcqtbssQ==
X-Google-Smtp-Source: AK7set9rGLaAY6JNAkStpkpA30vS3fvFUTMvtgFrmN3hnUo+1nFQnv0AQ1lED/vU32yoKHevFZLJuTyRYzOq/Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6d89:0:b0:506:6313:9436 with SMTP id
 i131-20020a816d89000000b0050663139436mr1588894ywc.137.1674855842075; Fri, 27
 Jan 2023 13:44:02 -0800 (PST)
Date: Fri, 27 Jan 2023 21:43:53 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-5-ricarkol@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the read-only memslot tests in page_fault_test to test
read-only PT (Page table) memslots. Note that this was not allowed
before commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
memslots") as all S1PTW faults were treated as writes which resulted
in an (unrecoverable) exception inside the guest.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c    | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 2e2178a7d0d8..54680dc5887f 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -829,8 +829,9 @@ static void help(char *name)
 
 #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
 {										\
-	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.name			= SCAT2(ro_memslot, _access),			\
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
@@ -849,9 +851,9 @@ static void help(char *name)
 #define TEST_RO_MEMSLOT_AND_DIRTY_LOG(_access, _mmio_handler, _mmio_exits,	\
 				      _test_check)				\
 {										\
-	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.name			= SCAT2(ro_memslot, _access),			\
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
2.39.1.456.gfc5497dd1b-goog

