Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD015D1
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 02:24:41 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso4548272pgc.14
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 18:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOc6nDFQxL2+zMzMHVOY/zZ9XFhHWFGOwpzRU/kQJv4=;
        b=giKA0LkehwnFAaJcxWDPj+9uugfdIq16i6d89COL3MpQpBHSdMfJ9ai8B/GNsiicdz
         waa3+dABc6GxX+rusfAc1gaP6XzkrpGIi00AjbdmFPqbki6H8jAXkPw3Jcf3jXZDXMiS
         qXNXBTPXkAvi97AZ1KuPRVCL5sk0w6opxw+DjBNx4zzc7ViUoMSNOXeh/5SOPDnai0WO
         KqdaQ+T//2ENiD+cHLk4zBDULpMfmWA22SSrDHCxgNnwPLWwTZJhVi+F3glO7pYLwsXi
         +5Lfdc7QG74jkXTkewy+fEtoBS3X18mhc5J2koQaC1bzpfRVu7rcApDO/2qlJHDGX9Jv
         5hBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOc6nDFQxL2+zMzMHVOY/zZ9XFhHWFGOwpzRU/kQJv4=;
        b=6Ph82VX5ig8AQfTlTcJ9zMxf0GdU62neTqu+JQe0A5rE/R30sy196jEYawnh3XORUp
         DwNZTs0cjBgb+rrSXOX7npddvOokbrCOJivG3Gtu4txF5GrPGXrGAUPKMD3XAAx1Y1wA
         qGlGeHyolEdFBb2IfTTfknGFLbmcA9Kz7TwZZxtW91AvOW/rBgNlZu+ADsX0GosHEiSK
         l4ZPsevvcK5mdfzJ07xHxszFOmXER9453Z8yijWbm91mgcC2t/t55Ol7ZpcHpb6NEHmt
         KHq63RxKLXUlQtSaUbx9ht41qKw+MurnFxO2yV32y6MNL3bwIZsJHHpeLgdS9YRtmTLi
         0tJA==
X-Gm-Message-State: AFqh2koO6tuJV4ag8tycSAF4KTPJrdm3ui0mjqOToqc39OhSTZ+g61to
	Uuh63q/Z+3CLJIMX9fq3D++tC6MVzCYpRQ==
X-Google-Smtp-Source: AMrXdXtiP2AjlooOdh29gOi1ydGUgioJWHVFIDJdUdJK5lpaF4pioCqj/pDWU2ysBBrHgveL1sZl9eOQXlw7Bg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e046:0:b0:477:a381:84d with SMTP id
 n6-20020a63e046000000b00477a381084dmr4374577pgj.207.1673317481175; Mon, 09
 Jan 2023 18:24:41 -0800 (PST)
Date: Tue, 10 Jan 2023 02:24:31 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-4-ricarkol@google.com>
Subject: [PATCH 3/4] KVM: selftests: aarch64: Fix check of dirty log PT write
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

The dirty log checks are mistakenly testing the first page in the page
table (PT) memory region instead of the page holding the test data page
PTE.  This wasn't an issue before commit "KVM: arm64: Fix handling of S1PTW
S2 fault on RO memslots" as all PT pages (including the first page) were
treated as writes.

Fix the page_fault_test dirty logging tests by checking for the right page:
the one for the PTE of the data test page.

Fixes: a4edf25b3e25 ("KVM: selftests: aarch64: Add dirty logging tests into page_fault_test")
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 1a3bb2bd8657..2e2178a7d0d8 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -470,9 +470,12 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	struct userspace_mem_region *data_region, *pt_region;
 	bool continue_test = true;
+	uint64_t pte_gpa, pte_pg;
 
 	data_region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	pt_region = vm_get_mem_region(vm, MEM_REGION_PT);
+	pte_gpa = addr_hva2gpa(vm, virt_get_pte_hva(vm, TEST_GVA));
+	pte_pg = (pte_gpa - pt_region->region.guest_phys_addr) / getpagesize();
 
 	if (cmd == CMD_SKIP_TEST)
 		continue_test = false;
@@ -485,13 +488,13 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
 			    "Missing write in dirty log");
 	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Missing s1ptw write in dirty log");
 	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
 		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
 			    "Unexpected write in dirty log");
 	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Unexpected s1ptw write in dirty log");
 
 	return continue_test;
-- 
2.39.0.314.g84b9a713c41-goog

