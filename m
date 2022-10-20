Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E361323BF
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 07:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666249988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqVmt5YoyTpdybpQLaBWLMwp2J8t1L+xxmd4ToLLOLQ=;
	b=HyKLaFrdXr3H+/TkquwbOwYj1uAaM9GramQzThszfewTNZ/jIqYWncX9tdicuAXoSOJWPI
	STQfkWILKlKw82hW7G4fKhHa/a3e6eCdmqhYgf7fdrHcrNyX7OW+sOeTMwkeqbhow7M6+T
	gUMOGy+byuBnebTfLxWZTx9JvBH9La0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-gKNIcA3RMcqrmkokm2R28A-1; Thu, 20 Oct 2022 03:13:01 -0400
X-MC-Unique: gKNIcA3RMcqrmkokm2R28A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C39AB86F123;
	Thu, 20 Oct 2022 07:13:00 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7057E40C6EC2;
	Thu, 20 Oct 2022 07:12:55 +0000 (UTC)
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
Subject: [PATCH v3 3/6] KVM: selftests: memslot_perf_test: Probe memory slots for once
Date: Thu, 20 Oct 2022 15:12:06 +0800
Message-ID: <20221020071209.559062-4-gshan@redhat.com>
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
Message-ID: <20221020071206.Y3iXya2_xKiWPQ8NNTBwoi3QZ0mToM2E4jYODTKQwZw@z>

prepare_vm() is called in every iteration and run. The allowed memory
slots (KVM_CAP_NR_MEMSLOTS) are probed for multiple times. It's not
free and unnecessary.

Move the probing logic for the allowed memory slots to parse_args()
for once, which is upper layer of prepare_vm().

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 32 +++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index dcb492b3f27b..f0ea3f75b6e1 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -245,27 +245,17 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		       void *guest_code, uint64_t mempages,
 		       struct timespec *slot_runtime)
 {
-	uint32_t max_mem_slots;
 	uint64_t rempages;
 	uint64_t guest_addr;
 	uint32_t slot;
 	struct timespec tstart;
 	struct sync_area *sync;
 
-	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
-	TEST_ASSERT(max_mem_slots > 1,
-		    "KVM_CAP_NR_MEMSLOTS should be greater than 1");
-	TEST_ASSERT(nslots > 1 || nslots == -1,
-		    "Slot count cap should be greater than 1");
-	if (nslots != -1)
-		max_mem_slots = min(max_mem_slots, (uint32_t)nslots);
-	pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
-
 	TEST_ASSERT(mempages > 1,
 		    "Can't test without any memory");
 
 	data->npages = mempages;
-	data->nslots = max_mem_slots - 1;
+	data->nslots = nslots;
 	data->pages_per_slot = mempages / data->nslots;
 	if (!data->pages_per_slot) {
 		*maxslots = mempages + 1;
@@ -869,6 +859,7 @@ static void help(char *name, struct test_args *targs)
 static bool parse_args(int argc, char *argv[],
 		       struct test_args *targs)
 {
+	uint32_t max_mem_slots;
 	int opt;
 
 	while ((opt = getopt(argc, argv, "hvds:f:e:l:r:")) != -1) {
@@ -885,8 +876,8 @@ static bool parse_args(int argc, char *argv[],
 			break;
 		case 's':
 			targs->nslots = atoi(optarg);
-			if (targs->nslots <= 0 && targs->nslots != -1) {
-				pr_info("Slot count cap has to be positive or -1 for no cap\n");
+			if (targs->nslots <= 1 && targs->nslots != -1) {
+				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
 				return false;
 			}
 			break;
@@ -932,6 +923,21 @@ static bool parse_args(int argc, char *argv[],
 		return false;
 	}
 
+	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
+	if (max_mem_slots <= 1) {
+		pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
+		return false;
+	}
+
+	/* Memory slot 0 is reserved */
+	if (targs->nslots == -1)
+		targs->nslots = max_mem_slots - 1;
+	else
+		targs->nslots = min_t(int, targs->nslots, max_mem_slots) - 1;
+
+	pr_info_v("Allowed Number of memory slots: %"PRIu32"\n",
+		  targs->nslots + 1);
+
 	return true;
 }
 
-- 
2.23.0

