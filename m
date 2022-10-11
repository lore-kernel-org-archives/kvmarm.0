Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157F15B7
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 01:06:46 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso12213249ybq.21
        for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
        b=UkcJ/bp46qwS500IUMujefCobrQShOfuHj8ioURU3a0xRbWbiAY1dJoK1tX+sNtP7T
         CxqJV0TdJjgLOcXmL2VYIE88pJHrCcVSAno3rTBfypXy9epKFlZfxIB6U3TkUx+Ct/6/
         Lb348Bq/LWI2EvD9u2tDQF93FpdduOF1jjL+wMv5+jU2mIXLqg0PjXfVJdA5r0nI2gCR
         MpVB7KFa0SrftyMS7OlytdguZ8mjXhb8fCxo5BAIiDEWdHcJ820STx57+6hU5d3myWRp
         uWQinnUUJs4HUVh/fvW/4AjczmuWdPPkEHt6MxzKBMGeYirap0BsWWRr+qPTe+/tkdOM
         c3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
        b=29DnYAbCs5OtLIVkYRhlE6KbLSJQTAZl+sYFA7DW9d8FvOcBUC7oRHys16uiuLDQ+k
         fkL7q8R4inmSwDK3JUvjjweOuDqUCpiVkLznV60nBYUExVKmMPFng+ShtTRApsWrRZ//
         AkRgv2JtsFjc/CL0luaJOi701X1FvOnST8P7z7mKxWY5mTMqUtks3dMORR8XMdkZmyBB
         HLAfGwmFNmuOXJLKkd5oy039bCOHStW131w9nkQAnTTgJ6989uMiRGyv1XCswJNMktgA
         4OBg+1c7B/EHhEAAsx44GjEqvEwQxO3/Ahp11JG+u6ENt72vUhz7AXYAKXlxWNwp1FHi
         R31w==
X-Gm-Message-State: ACrzQf02QKY/1STaTXMrRh3soCjpeKQIWR7+YgKD+7chW5xgnRl9F7hx
	vDPCBewibvPOP5XpmriQl4u/C9soY8r9Lg==
X-Google-Smtp-Source: AMsMyM6DvDW7RQp/vT3H4oz3eGzG6d941XFf+LY4Plq3XF9A4zKfPJxqaSk6SkRxtj0iUkgns4BqjOw8cl41tA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d7c3:0:b0:6be:28a9:b8ec with SMTP id
 o186-20020a25d7c3000000b006be28a9b8ecmr20504274ybg.443.1665450406087; Mon, 10
 Oct 2022 18:06:46 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:20 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-7-ricarkol@google.com>
Subject: [PATCH v9 06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221011010620.mQpVFpw3NYE4VdxoG9Pu-JJGuHIHq5-9cJ7ZIKNntnE@z>

Add the backing_src_type into struct userspace_mem_region. This struct
already stores a lot of info about memory regions, except the backing
source type.  This info will be used by a future commit in order to
determine the method for punching a hole.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..a9264ed22cca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 19e37fb7de7c..6affce47e899 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -929,6 +929,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

