Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C975221
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 21:44:01 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id g138-20020a25db90000000b0080c27bde887so2926291ybf.18
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 13:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow7bHQQrk81H5p7MdEvUeMOlztu0LrzFJM8nKhppa2g=;
        b=iwERg0mlUIwCHJ34JdGmjSttyNSInsW2zsHwXq8EvlPTsyVQI8RzkremFBPOeIhfn9
         nlfQyfw5lJVMrTnx7M3vkW+yFQbA27E4KFRyD1aVDAsgK2qIb4w+UmF3SW0JeTw0uWaf
         toGYrTsfRQfxzlMVuCig9WgAJPIES5EvZCoZmNhnDv8VQRIyMNacDOwfntHKbZ4EmDP6
         misRjySTqXKgYwSqwGdUBElISIjBpUaw+vKPRHZ381WD9yUDaAkfJ8Ck6TYAj/fi7oBe
         M5Q+tnrEoM2hFdJUr9s1DvLbco67J0VSMhMy2HpzCgT/xnqP/t4Ovp5WXeoJzvFO49k6
         fdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow7bHQQrk81H5p7MdEvUeMOlztu0LrzFJM8nKhppa2g=;
        b=Qevrg8oooz7YBmin7Nf0pvG2Fwz8ZoFhYsqqevNwdCvV6v3fg0+dAsBbHJB0u7gSz3
         dnD0EhEAAB2xY4kRWOtdfU/UFnWusUXIroPgVJ88FKeN6MAhnzsn58M/6vvMdFUNSrCQ
         d8x5hnabtoAd9rCCLuxStzOH8oL7yOCFlwA4ssjESjIbtQpeuECzVuAkAzhKFhw0Q3Rw
         EKVhZo/YannjniSwRlFuFJIbEzYaIY914tjQWxClHobOMiWfAuAYR30bWffTyaOtG5qm
         9zX+UbXNxugj2R9gb4Uo0pqUOHcwPo0zZLuIaVWn8trKdq0Qv+VqafiDqAYFMBx6fHgg
         CqFw==
X-Gm-Message-State: AFqh2kopURB0L6qKkCSx2IZb5Olb2CK3CTeEuiSI+CIgfhgzYJI9Tlfk
	znlFQYZnAbDoJZy0go9vz1qgi6ldCJ/bZg==
X-Google-Smtp-Source: AMrXdXvLxD9R2nwpuG/CYmx8tWVUDrbel8HTvFJ26X3Vr6vnt6OGPtFVeAvBzAo5+GrsgKzkMmMMltXrI4hh3w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6607:0:b0:501:539e:8b5e with SMTP id
 a7-20020a816607000000b00501539e8b5emr3435776ywc.112.1674855840276; Fri, 27
 Jan 2023 13:44:00 -0800 (PST)
Date: Fri, 27 Jan 2023 21:43:52 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-4-ricarkol@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: aarch64: Fix check of dirty log PT write
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

The dirty log checks are mistakenly testing the first page in the page
table (PT) memory region instead of the page holding the test data
page PTE.  This wasn't an issue before commit 406504c7b040 ("KVM:
arm64: Fix S1PTW handling on RO memslots") as all PT pages (including
the first page) were treated as writes.

Fix the page_fault_test dirty logging tests by checking for the right
page: the one for the PTE of the data test page.

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
2.39.1.456.gfc5497dd1b-goog

