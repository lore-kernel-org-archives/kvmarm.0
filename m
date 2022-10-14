Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549EBC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 07:20:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7AE4B293;
	Fri, 14 Oct 2022 03:20:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TagofDMl9k18; Fri, 14 Oct 2022 03:20:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B07164B2AE;
	Fri, 14 Oct 2022 03:20:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 259E24B278
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 03:19:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ksoiceKFanO3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 03:19:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1868349F51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 03:19:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665731997;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9FjkKJ4RB0wBhJUFjtqAZ3VQdnrJF4akYRPmacZ3lG8=;
 b=P1XPkpzlb1v28g7EfnK041ADQwt3UVlUPA+4JgImZKYdy6eLyS/3L8tvB5fFOGD+V6bO5N
 ZdgPTCn+xVXAkCijlhaC2PLVzBPPDVSpWof1M3OKDl1Qkjovgix2cAyelyvh5KKEfuGAe0
 lFOQuI1N+zTD4vLj0BhcTESWrJ2uNHk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-p7IZhB-gOPeyF-R__aZl2Q-1; Fri, 14 Oct 2022 03:19:54 -0400
X-MC-Unique: p7IZhB-gOPeyF-R__aZl2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA6A1185A7A9;
 Fri, 14 Oct 2022 07:19:53 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 183ACC06224;
 Fri, 14 Oct 2022 07:19:48 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH 2/6] KVM: selftests: memslot_perf_test: Consolidate loop
 conditions in prepare_vm()
Date: Fri, 14 Oct 2022 15:19:10 +0800
Message-Id: <20221014071914.227134-3-gshan@redhat.com>
In-Reply-To: <20221014071914.227134-1-gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, pbonzini@redhat.com,
 maciej.szmigiero@oracle.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
