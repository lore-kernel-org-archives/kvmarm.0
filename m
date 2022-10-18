Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EC41857
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666065946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/RCLmwcdRRHc5iUwT+6ibxZ6InHRbOkdgeEhTg+vaBw=;
	b=APHHVZ4yJk1zqsgx8iVh6G5dAcLXNJ9P26fqcpI2jPcPgsYUYaiDUh4BPYVkwlmol7RgcE
	G44v5Ig4pG7b6+XyyBciSXXgDH+llbcef1x9cHrSQ1iQZ+yXUb7NpbSbTx7BeLD1ei8akH
	hCAAHfnw/l8U6D+O6+ge1mGQAkqkJ4E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-2lhYu8McORSGNCmBrHRyQw-1; Tue, 18 Oct 2022 00:05:42 -0400
X-MC-Unique: 2lhYu8McORSGNCmBrHRyQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36C663C3C968;
	Tue, 18 Oct 2022 04:05:42 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BF7C2166B41;
	Tue, 18 Oct 2022 04:05:36 +0000 (UTC)
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
	mail@maciej.szmigiero.name,
	maciej.szmigiero@oracle.com,
	seanjc@google.com,
	peterx@redhat.com,
	ricarkol@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v2 6/6] KVM: selftests: memslot_perf_test: Report optimal memory slots
Date: Tue, 18 Oct 2022 12:04:54 +0800
Message-ID: <20221018040454.405719-7-gshan@redhat.com>
In-Reply-To: <20221018040454.405719-1-gshan@redhat.com>
References: <20221018040454.405719-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Message-ID: <20221018040454.S1QW-H3PkTP_WfsOMFbdAOLg4f0dx03-y-SEqRvY2vw@z>

The memory area in each slot should be aligned to host page size.
Otherwise, the test will fail. For example, the following command
fails with the following messages with 64KB-page-size-host and
4KB-pae-size-guest. It's not user friendly to abort the test.
Lets do something to report the optimal memory slots, instead of
failing the test.

  # ./memslot_perf_test -v -s 1000
  Number of memory slots: 999
  Testing map performance with 1 runs, 5 seconds each
  Adding slots 1..999, each slot with 8 pages + 216 extra pages last
  ==== Test Assertion Failure ====
    lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
    pid=19872 tid=19872 errno=0 - Success
       1  0x00000000004065b3: vm_userspace_mem_region_add at kvm_util.c:822
       2  0x0000000000401d6b: prepare_vm at memslot_perf_test.c:273
       3  (inlined by) test_execute at memslot_perf_test.c:756
       4  (inlined by) test_loop at memslot_perf_test.c:994
       5  (inlined by) main at memslot_perf_test.c:1073
       6  0x0000ffff7ebb4383: ?? ??:0
       7  0x00000000004021ff: _start at :?
    Number of guest pages is not compatible with the host. Try npages=16

Report the optimal memory slots instead of failing the test when
the memory area in each slot isn't aligned to host page size. With
this applied, the optimal memory slots is reported.

  # ./memslot_perf_test -v -s 1000
  Number of memory slots: 999
  Testing map performance with 1 runs, 5 seconds each
  Memslot count too high for this test, decrease the cap (max is 514)

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 45 +++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 3ab385e40bc0..e0f3d9bd5297 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -229,16 +229,52 @@ static struct vm_data *alloc_vm(void)
 	return data;
 }
 
+static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
+			     uint64_t pages_per_slot, uint64_t rempages)
+{
+	if (!pages_per_slot)
+		return false;
+
+	if ((pages_per_slot * guest_page_size) % host_page_size)
+		return false;
+
+	if ((rempages * guest_page_size) % host_page_size)
+		return false;
+
+	return true;
+}
+
+
+static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
+{
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t mempages, pages_per_slot, rempages;
+	uint64_t slots;
+
+	mempages = data->npages;
+	slots = data->nslots;
+	while (--slots > 1) {
+		pages_per_slot = mempages / slots;
+		rempages = mempages % pages_per_slot;
+		if (check_slot_pages(host_page_size, guest_page_size,
+				     pages_per_slot, rempages))
+			return slots + 1;	/* slot 0 is reserved */
+	}
+
+	return 0;
+}
+
 static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		       void *guest_code, uint64_t mem_size,
 		       struct timespec *slot_runtime)
 {
 	uint64_t mempages, rempages;
 	uint64_t guest_addr;
-	uint32_t slot, guest_page_size;
+	uint32_t slot, host_page_size, guest_page_size;
 	struct timespec tstart;
 	struct sync_area *sync;
 
+	host_page_size = getpagesize();
 	guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 	mempages = mem_size / guest_page_size;
 
@@ -250,12 +286,13 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->npages > 1, "Can't test without any memory");
 	data->nslots = nslots;
 	data->pages_per_slot = data->npages / data->nslots;
-	if (!data->pages_per_slot) {
-		*maxslots = data->npages + 1;
+	rempages = data->npages % data->nslots;
+	if (!check_slot_pages(host_page_size, guest_page_size,
+			      data->pages_per_slot, rempages)) {
+		*maxslots = get_max_slots(data, host_page_size);
 		return false;
 	}
 
-	rempages = data->npages % data->nslots;
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-- 
2.23.0

