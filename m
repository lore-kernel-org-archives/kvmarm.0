Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEA47B
	for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 09:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674033731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E+4oHLzjlzllV+wiLqTCwa1ZJlnN7IOeLnn4TzkPJNA=;
	b=W3TX/vHHpZgYkQ5U+s5l1PXAtfPwUjGKYAWGxijwsw3/8ITj8GTRiqLcu1lGX1Ex6xhbFS
	PE5CYvbO9t1FOHW3tN2xIfZ7RV+YXr2zddOfhwvvgEHVR955vX9hdtsf7H7oBgGccks+X1
	mPkuqDEGbl3yUJ8h/gZ2oEEl+hozckc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-glE88ABxOcmNNnMev1Qwyw-1; Wed, 18 Jan 2023 04:22:07 -0500
X-MC-Unique: glE88ABxOcmNNnMev1Qwyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0943802B86;
	Wed, 18 Jan 2023 09:22:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C331940C2004;
	Wed, 18 Jan 2023 09:22:02 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	maciej.szmigiero@oracle.com,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH 2/2] KVM: selftests: Assign guest page size in sync area early in memslot_perf_test
Date: Wed, 18 Jan 2023 17:21:33 +0800
Message-Id: <20230118092133.320003-3-gshan@redhat.com>
In-Reply-To: <20230118092133.320003-1-gshan@redhat.com>
References: <20230118092133.320003-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

The guest page size in the synchronization area is needed by all test
cases. So it's reasonable to set it in the unified preparation function
(prepare_vm()).

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index adbbcca3e354..4210cd21d159 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -347,6 +347,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	virt_map(data->vm, MEM_GPA, MEM_GPA, data->npages);
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
+	sync->guest_page_size = data->vm->page_size;
 	atomic_init(&sync->start_flag, false);
 	atomic_init(&sync->exit_flag, false);
 	atomic_init(&sync->sync_flag, false);
@@ -808,8 +809,6 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 	}
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
-
-	sync->guest_page_size = data->vm->page_size;
 	if (tdata->prepare &&
 	    !tdata->prepare(data, sync, maxslots)) {
 		ret = false;
-- 
2.23.0

