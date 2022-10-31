Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CD67E
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667176695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=erX4o23Z0ei2lYxmuM+Ux8z75OGb9vWYbfZmMdyVy88=;
	b=WXFmUyQc2nEO0X9iXBUjfIRBtHb59U3Mf8XMqqqH7v16CJGSY0vukpAzKL9vFAAFFOOMIh
	WKfIHpI5+aonFBg0LwM1BiuDAgcFosZlsOgpEOGjaYhFeZGd0IlJ49p4zw9uHrFHF5DJl4
	o273s6ggfawq0tLqPEnyx33wojxr0kw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-uwN95PzoORCvPyi7wBrbgA-1; Sun, 30 Oct 2022 20:38:11 -0400
X-MC-Unique: uwN95PzoORCvPyi7wBrbgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD08E811E67;
	Mon, 31 Oct 2022 00:38:10 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAF3140C6F9F;
	Mon, 31 Oct 2022 00:38:03 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu,
	andrew.jones@linux.dev,
	ajones@ventanamicro.com,
	maz@kernel.org,
	bgardon@google.com,
	catalin.marinas@arm.com,
	dmatlack@google.com,
	will@kernel.org,
	pbonzini@redhat.com,
	peterx@redhat.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	james.morse@arm.com,
	shuah@kernel.org,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v7 2/9] KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Date: Mon, 31 Oct 2022 08:36:14 +0800
Message-ID: <20221031003621.164306-3-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Message-ID: <20221031003614.EYO-5-GlXfG1AhO1ss_q67QY5mwfd5C-FNQjBtN8oME@z>

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
index 53a36f38d15e..04290eda0852 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -65,6 +65,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
+int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
 
-- 
2.23.0

