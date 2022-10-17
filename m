Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD7346BC
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 19:58:47 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id q3-20020a17090a304300b0020aede449d6so5870894pjl.4
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 12:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
        b=fgWWpUPTATZoObqhmudipHE1rbimOoJyI+54OfwH0kvktKoHrRezhrx8scWRrlgMw3
         R9fqTrITvnJxkHRGObhA9IygDkwfDAkNo5fZW58sIZ9j7CkQCf7yKBSSBOzOlygv3cEX
         WqQqU2nOcWbJnZnUqakS42G8OGsJ1yEQ3sl4cEpytYa+dH63gdc08lDiNWKEEtToWTiG
         gDkhd6zCSHx2QEbNkAAlw0pSB+KQ1K/BnEIypAUi+drLyyjBB/UqJI/pjgYlNGleGayr
         wVamIBpZzR1ep0WZE7pYHhZXtx9d0noSwsAqFq0yLs1MOARtOloT/o7sqRgUK+vYl5sr
         ot7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
        b=IaCjoYK2mfna+V9Xg/Fb8+7p0AEcyw9Oy4jvYl2FcdysifNUc5rpdRO65C6v6k7ohH
         wYe121pxJbBLe8RR/sVGY/zSHY96c8D2JlF2C3neaS6gVYxmYjkVIGWceRseXmfwBHMy
         9KogzPtuom+7uSI04+TvwzgYxJdPXFL2p56U2DTMIsyEfwbWIGXDn8hGzIUe61d09ILk
         6vIzzid9ZBm1LyJtgostBRCeqaydCuaO0f1jv7h1xV9p1lH5daKMkhA4KeGnP1SKkSB4
         q7jCb2DZj9WFWqNrmb2BFWDH8QR+gHldJmVvWCEAZtBQVbSF9S5hdv9Q0xqWuezyw0I7
         ZMJg==
X-Gm-Message-State: ACrzQf3x4qqtynjeU1KEjEerLWQNDJZzHxLU6Y37SUjV+Ck5CW6f9WHR
	RCGarIm/7kKrioJz1CBq1K8pdon8Yz5UTg==
X-Google-Smtp-Source: AMsMyM4H8tFUm5rFlQxBAMa9WbaF7a7ibX/iAyJ0SH1yF0izF7uxbK7MzSL5/AADU6b1oJGCrLQySyhxETmSLA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e52:0:b0:438:ebec:363e with SMTP id
 18-20020a630e52000000b00438ebec363emr12257328pgo.437.1666036727104; Mon, 17
 Oct 2022 12:58:47 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:26 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-7-ricarkol@google.com>
Subject: [PATCH v10 06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221017195826.MhW4hCNHrL1RyOE1LvfgFhg-trv8kxzMQ2J8XG6_Ip8@z>

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
2.38.0.413.g74048e4d9e-goog

