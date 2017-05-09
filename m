From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 03/11] KVM: Add kvm_vcpu_get_idx to get vcpu index in
 kvm->vcpus
Date: Tue,  9 May 2017 10:56:10 +0200
Message-ID: <20170509085618.28311-4-cdall@linaro.org>
References: <20170509085618.28311-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3922040C32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 04:53:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9qbjt9JR+b0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 04:53:13 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66B0540BC5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 04:53:13 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id u65so3302662wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 01:56:28 -0700 (PDT)
In-Reply-To: <20170509085618.28311-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There are occasional needs to use the index of vcpu in the kvm->vcpus
array to map something related to a VCPU.  For example, unlike the
vcpu->vcpu_id, the vcpu index is guaranteed to not be sparse across all
vcpus which is useful when allocating a memory area for each vcpu.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
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
