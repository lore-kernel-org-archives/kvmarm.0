Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C160B23BF
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 07:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666249974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vvc9nSeTOx+R9O1KRdNsOErR2cLTeHQp0FKXCgftjxs=;
	b=W/N1PruCa0l23M0hoMWAZPPIhmrAWapCdW7lg1pekvAkiqTVjAm9sCJdzcsqfAOBLZyNsi
	esci7g/D8dNJljihaGYoRCGHtjkvTaeykKnfmJEsyKNJp7PuMHb46O8DWOOcScolE4robM
	oLUxHaqJ85nAeSQtkTfT5a9RQIw7PE0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-nI8UtPRCNiuaY4FWD93Yig-1; Thu, 20 Oct 2022 03:12:49 -0400
X-MC-Unique: nI8UtPRCNiuaY4FWD93Yig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51B56101A528;
	Thu, 20 Oct 2022 07:12:49 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 574EA40C6EC2;
	Thu, 20 Oct 2022 07:12:44 +0000 (UTC)
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
Subject: [PATCH v3 1/6] KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
Date: Thu, 20 Oct 2022 15:12:04 +0800
Message-ID: <20221020071209.559062-2-gshan@redhat.com>
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
Message-ID: <20221020071204.o_0Hl5jNjBvsN-5A9oTrRndX9sGdPF21uqxcskmpNAg@z>

In prepare_vm(), 'data->nslots' is assigned with 'max_mem_slots - 1'
at the beginning, meaning they are interchangeable.

Use 'data->nslots' isntead of 'max_mem_slots - 1'. With this, it
becomes easier to move the logic of probing number of slots into
upper layer in subsequent patches.

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..231cc8449c2e 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -280,14 +280,14 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
-		max_mem_slots - 1, data->pages_per_slot, rempages);
+		data->nslots, data->pages_per_slot, rempages);
 
 	clock_gettime(CLOCK_MONOTONIC, &tstart);
-	for (slot = 1, guest_addr = MEM_GPA; slot < max_mem_slots; slot++) {
+	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
 		uint64_t npages;
 
 		npages = data->pages_per_slot;
-		if (slot == max_mem_slots - 1)
+		if (slot == data->nslots)
 			npages += rempages;
 
 		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
@@ -297,12 +297,12 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
-	for (slot = 0, guest_addr = MEM_GPA; slot < max_mem_slots - 1; slot++) {
+	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
 		uint64_t npages;
 		uint64_t gpa;
 
 		npages = data->pages_per_slot;
-		if (slot == max_mem_slots - 2)
+		if (slot == data->nslots - 1)
 			npages += rempages;
 
 		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
-- 
2.23.0

