From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 29/37] KVM: Add kvm_vcpu_get_idx to get vcpu index in kvm->vcpus
Date: Tue,  9 May 2017 12:44:58 +0200
Message-ID: <20170509104506.30929-30-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B0E40C5A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fk24LjL-mRla for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:31 -0400 (EDT)
Received: from mail-qk0-f174.google.com (mail-qk0-f174.google.com
 [209.85.220.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 525CC40C74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:25 -0400 (EDT)
Received: by mail-qk0-f174.google.com with SMTP id k74so75285563qke.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:40 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

There are occasional needs to use the index of vcpu in the kvm->vcpus
array to map something related to a VCPU.  For example, unlike the
vcpu->vcpu_id, the vcpu index is guaranteed to not be sparse across all
vcpus which is useful when allocating a memory area for each vcpu.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c14ad9..12eb26d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -490,6 +490,17 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 	return NULL;
 }
 
+static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *tmp;
+	int idx;
+
+	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
+		if (tmp == vcpu)
+			return idx;
+	BUG();
+}
+
 #define kvm_for_each_memslot(memslot, slots)	\
 	for (memslot = &slots->memslots[0];	\
 	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
-- 
2.9.0
