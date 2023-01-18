Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B87B
	for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 09:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674033729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRpao2U67NwWvD0GEz79kUj8iQxU/5jsj0HVM0mbPII=;
	b=h3qr3HCI5BZ6Qqv6fG3BkLhf8rhHPEBSb7GlZaiuiPyIgL/9TkJvTYXWh59inefYvjW115
	BN+33hZO5BVT6/WDuSmd3PIuN0S3J1pZoDJFekVNC/xMeMk1aXULOISw7KCQYsRXFMcXkV
	hlMu6+zQ08UW/sJ9QmjG49d38a+xdUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-UZO_jiJfP6S4dV4N2e0F1g-1; Wed, 18 Jan 2023 04:22:02 -0500
X-MC-Unique: UZO_jiJfP6S4dV4N2e0F1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3C3858F0E;
	Wed, 18 Jan 2023 09:22:02 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8327B40C2064;
	Wed, 18 Jan 2023 09:21:58 +0000 (UTC)
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
Subject: [PATCH 1/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
Date: Wed, 18 Jan 2023 17:21:32 +0800
Message-Id: <20230118092133.320003-2-gshan@redhat.com>
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

There are two VMs created in prepare_vm(), which isn't necessary.
To remove the second created and unnecessary VM.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e6587e193490..adbbcca3e354 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -308,8 +308,6 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		data->nslots, data->pages_per_slot, rempages);
 
-- 
2.23.0

