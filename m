Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4073B322E
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 04:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667880753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HmEjMGKRiSLAThTLqtDmoaFom/cHpQ3vOA926P7l/34=;
	b=Q6BEzYtpigWGOTnukH9HTsqxW7CEjhL9iqA+rEFtckYUhihBqxPQA2Ae/Gis2J4qmuBFej
	QD/aITBKWrItF2f4QLQ4R6ZIm/+yRUu9tXqdgUnONw4r3C/ysYTEqBRqge7N4cCe25PEv5
	wzpI6ggritqDv1jf0eua9kXb6ePp9/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-9L2SkMYkN6GXuR7UDn8spw-1; Mon, 07 Nov 2022 23:12:30 -0500
X-MC-Unique: 9L2SkMYkN6GXuR7UDn8spw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 864C529AA3BA;
	Tue,  8 Nov 2022 04:12:29 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20E1435429;
	Tue,  8 Nov 2022 04:12:22 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	andrew.jones@linux.dev,
	ajones@ventanamicro.com,
	bgardon@google.com,
	dmatlack@google.com,
	will@kernel.org,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	peterx@redhat.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v9 2/7] KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Date: Tue,  8 Nov 2022 12:10:34 +0800
Message-ID: <20221108041039.111145-3-gshan@redhat.com>
In-Reply-To: <20221108041039.111145-1-gshan@redhat.com>
References: <20221108041039.111145-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Message-ID: <20221108041034.oHFda9pCjSJe2O7m6NrVtGkTxANG9rh1RDjh1BgxrZI@z>

Not all architectures like ARM64 need to override the function. Move
its declaration to kvm_dirty_ring.h to avoid the following compiling
warning on ARM64 when the feature is enabled.

  arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12:        \
  warning: no previous prototype for 'kvm_cpu_dirty_log_size' \
  [-Wmissing-prototypes]                                      \
  int __weak kvm_cpu_dirty_log_size(void)

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 include/linux/kvm_dirty_ring.h  | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..b4dbde7d9eb1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2090,8 +2090,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
-int kvm_cpu_dirty_log_size(void);
-
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 9c13c4c3d30c..199ead37b104 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -66,6 +66,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
+int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
 
-- 
2.23.0

