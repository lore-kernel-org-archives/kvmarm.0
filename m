Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C967E7B
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 07:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665731998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FjkKJ4RB0wBhJUFjtqAZ3VQdnrJF4akYRPmacZ3lG8=;
	b=Gf4fLd15dM6J1L2/WpdroYqeSJMTOdMDR3iiu4CjQVf2JKxu97oEMHxYUNwCyNw92OcyHj
	5tG/BCwP5lrZzBsWhDguxVeNgWX1w2QhhgCrEtc8hZ0xc6xG/O6fXlncMRwRFu2c6ZUhVv
	9/opf+pojVBj4HViN9mBrByXNYSwws4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-p7IZhB-gOPeyF-R__aZl2Q-1; Fri, 14 Oct 2022 03:19:54 -0400
X-MC-Unique: p7IZhB-gOPeyF-R__aZl2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA6A1185A7A9;
	Fri, 14 Oct 2022 07:19:53 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 183ACC06224;
	Fri, 14 Oct 2022 07:19:48 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajones@ventanamicro.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	shuah@kernel.org,
	oliver.upton@linux.dev,
	seanjc@google.com,
	peterx@redhat.com,
	maciej.szmigiero@oracle.com,
	ricarkol@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH 2/6] KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
Date: Fri, 14 Oct 2022 15:19:10 +0800
Message-ID: <20221014071914.227134-3-gshan@redhat.com>
In-Reply-To: <20221014071914.227134-1-gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Message-ID: <20221014071910.yWzPQ7B-RzUftOIe5RUYTUBFL4zMuU4P7Ct5ll1yp8U@z>

There are two loops in prepare_vm(), which have different conditions.
'slot' is treated as meory slot index in the first loop, but index of
the host virtual address array in the second loop. It makes it a bit
hard to understand the code.

Change the usage of 'slot' in the second loop, to treat it as the
memory slot index either.

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 231cc8449c2e..dcb492b3f27b 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -297,21 +297,20 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
-	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
+	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
 		uint64_t npages;
 		uint64_t gpa;
 
 		npages = data->pages_per_slot;
-		if (slot == data->nslots - 1)
+		if (slot == data->nslots)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
-					 slot + 1);
+		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed\n");
 
-		data->hva_slots[slot] = addr_gpa2hva(data->vm, guest_addr);
-		memset(data->hva_slots[slot], 0, npages * 4096);
+		data->hva_slots[slot - 1] = addr_gpa2hva(data->vm, guest_addr);
+		memset(data->hva_slots[slot - 1], 0, npages * 4096);
 
 		guest_addr += npages * 4096;
 	}
-- 
2.23.0

