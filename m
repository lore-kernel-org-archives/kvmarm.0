Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA23517DB
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 06:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665469043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9ZS0D2+thpmOhdj1R2mZDkXLTceBJH5yl2mi+5Q4vM=;
	b=Y9a16nevKOcyh1JHxjCmFJIMPFFPKuWrNnZQ13IWMXHSlZeYE29djWQMw5uQ0sffh14khr
	nW0dY1z/gfkiC1DpoiAFpOVdz5adxakpdV2FEx2SRd2WBo8lNhqNKi7Ym5I0Z9g69BCRtq
	E8DmrioclbSZi5CnJL8lvzuMSmP0GA0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-DYMqC3IgNl-DL0I3mP_hYA-1; Tue, 11 Oct 2022 02:17:19 -0400
X-MC-Unique: DYMqC3IgNl-DL0I3mP_hYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3016185A792;
	Tue, 11 Oct 2022 06:17:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20105112D402;
	Tue, 11 Oct 2022 06:17:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	peterx@redhat.com,
	maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	bgardon@google.com,
	shuah@kernel.org,
	andrew.jones@linux.dev,
	dmatlack@google.com,
	pbonzini@redhat.com,
	zhenyzha@redhat.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v6 5/8] KVM: selftests: Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP if possible
Date: Tue, 11 Oct 2022 14:14:44 +0800
Message-ID: <20221011061447.131531-6-gshan@redhat.com>
In-Reply-To: <20221011061447.131531-1-gshan@redhat.com>
References: <20221011061447.131531-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Message-ID: <20221011061444.PpaOCFxG5YBowQvs1GNdhmPXaqw169bdwZkvXIAMN_w@z>

Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP if it's supported. Otherwise,
we will fail to enable KVM_CAP_DIRTY_LOG_RING_ACQ_REL on aarch64.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 411a4c0bc81c..54740caea155 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,6 +82,9 @@ unsigned int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
+	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP))
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP, 0);
+
 	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
 		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL, ring_size);
 	else
-- 
2.23.0

