Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1531423BF
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 07:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666249977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FjkKJ4RB0wBhJUFjtqAZ3VQdnrJF4akYRPmacZ3lG8=;
	b=SM/XXcUIskh44ZsTh4iWHGvDjoFQFdtYiviXsTu3dY5qCblhmNEEFRvggsTHCX34KWWzza
	hLWdsLWtf/fudKfpDcmkVPqQz8BN3vhz0HJbdVtKm1z3bcgRDUGcY6R8sy/cEIMySp94nu
	8ipZpFsyTGie5OUGSdZKSQc16IkOe+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-n3h-O6ciMHaqmna_rDKDRg-1; Thu, 20 Oct 2022 03:12:55 -0400
X-MC-Unique: n3h-O6ciMHaqmna_rDKDRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E665E800186;
	Thu, 20 Oct 2022 07:12:54 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D17E540C6EC2;
	Thu, 20 Oct 2022 07:12:49 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mail@maciej.szmigiero.name,
	maz@kernel.org,
	pbonzini@redhat.com,
	ajones@ventanamicro.com,
	shuah@kernel.org,
	peterx@redhat.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	ricarkol@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v3 2/6] KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
Date: Thu, 20 Oct 2022 15:12:05 +0800
Message-ID: <20221020071209.559062-3-gshan@redhat.com>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Message-ID: <20221020071205.h_fj9VFTdSh6S21yYhdTuWorHeeNWD_Sh1V7A0dPNEg@z>

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

