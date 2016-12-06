From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH 1/2] arm64: KVM: vgic-v3: Add the missing resetting LRs at
 boot time
Date: Tue, 6 Dec 2016 14:41:43 +0800
Message-ID: <1481006504-25460-2-git-send-email-zhaoshenglong@huawei.com>
References: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112F9402A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 01:43:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvNXHUxd3FWB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 01:43:26 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D68640223
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 01:43:25 -0500 (EST)
In-Reply-To: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This is the corresponding part of commit 0d98d00(arm64: KVM:
vgic-v3: Reset LRs at boot time) which is missed for new-vgic.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 5c9f974..7262f3b 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -307,6 +307,11 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	return ret;
 }
 
+static void vgic_cpu_init_lrs(void *params)
+{
+	kvm_call_hyp(__vgic_v3_init_lrs);
+}
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -361,5 +366,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.type = VGIC_V3;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
 
+	on_each_cpu(vgic_cpu_init_lrs, NULL, 1);
+
 	return 0;
 }
-- 
2.0.4
