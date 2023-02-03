Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF071C29
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675417384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/sw5RAfO/TETjhBCbaE2sbk1k6OIXCummMa6Dx6bagw=;
	b=GvtN69vZ+QvHXgrEPf8EholySnUP1QjjoxNSxFTnhzro/TBpDa2NCgsX7bIo3OXJ1x6sMt
	pKkiT/4T33a5XCKfK+rhILrNQ3cfIfMmcpg5ytGYMLwpwHM51w19oEs5W5YkQ9264swdLP
	i8JSVfgqW3RTeRf3EBWLQJwVSU/vTqs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-0lzC7SKGN0GZYvjAe5j_5Q-1; Fri, 03 Feb 2023 04:42:59 -0500
X-MC-Unique: 0lzC7SKGN0GZYvjAe5j_5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99CE71C05B0C;
	Fri,  3 Feb 2023 09:42:58 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.204])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0461740ED76D;
	Fri,  3 Feb 2023 09:42:55 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 6/7] KVM: arm64: Change return type of kvm_vm_ioctl_mte_copy_tags() to "int"
Date: Fri,  3 Feb 2023 10:42:29 +0100
Message-Id: <20230203094230.266952-7-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-1-thuth@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

This function only returns normal integer values, so there is
no need to declare its return value as "long".

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/guest.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..b1a16343767f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -963,8 +963,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
-long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
-				struct kvm_arm_copy_mte_tags *copy_tags);
+int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
+			       struct kvm_arm_copy_mte_tags *copy_tags);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index cf4c495a4321..80e530549c34 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1013,8 +1013,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
-				struct kvm_arm_copy_mte_tags *copy_tags)
+int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
+			       struct kvm_arm_copy_mte_tags *copy_tags)
 {
 	gpa_t guest_ipa = copy_tags->guest_ipa;
 	size_t length = copy_tags->length;
-- 
2.31.1

