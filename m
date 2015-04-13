From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 13/16] kvm: introduce kvm_arch_halt_guest and
 kvm_arch_resume_guest
Date: Mon, 13 Apr 2015 14:29:28 +0200
Message-ID: <1428928171-18884-14-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA634C467
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VWpuTUFSE5fN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:25:09 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78D134C42A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:09 -0400 (EDT)
Received: by wiun10 with SMTP id n10so64600458wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:56 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This API allows to
- exit the guest and avoid re-entering it
- resume the guest execution

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae9c720..f4e1829 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1053,6 +1053,18 @@ extern struct kvm_device_ops kvm_xics_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
 
+#ifdef __KVM_HAVE_ARCH_HALT_GUEST
+
+void kvm_arch_halt_guest(struct kvm *kvm);
+void kvm_arch_resume_guest(struct kvm *kvm);
+
+#else
+
+inline void kvm_arch_halt_guest(struct kvm *kvm) {}
+inline void kvm_arch_resume_guest(struct kvm *kvm) {}
+
+#endif
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
 static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
-- 
1.9.1
