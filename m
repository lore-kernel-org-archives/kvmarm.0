Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC626307AEB;
	Wed,  2 Jul 2025 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467317; cv=none; b=DOXka250Ire3qgLF1Rip2EXlj0zFFXo/s5Xpjv8uNGDVqFJ6xLfKYtJ5dKawH6Q6+WikMjcd7Bp8fuoGqwX6dZL4WP8NNNnHLtVoqbqyVVsRbv5CNGjdIe1aX9KAZ9bt3y90cVAMsa8d4uo175uPo9RQdJI8iDPe/A4Rfa+ROwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467317; c=relaxed/simple;
	bh=gXFjrnyK53XnEFprtSbQ/Yh/7HpkHVyLvcYoo2oSfh4=;
	h=From:To:Cc:Subject:Date:Message-Id; b=UhaQD0cXERsCilm5Zkb/78TTu5tjISpLQCdUXOsKEswWj/U4TuyO1Hm+3CAUPIuz8DG4EL5BU4KpUEKWqRtraQN2m6YpuEBq253n3G39Vv/JkuM3HavFQz2XEnyH8uH5Vs+lo9ztGeTc8gI/eoNkd/bT7Oc9Sgqk2NVwaoHxvBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LQUrCmxJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LQUrCmxJ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 562Bj2IF016944;
	Wed, 2 Jul 2025 14:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:date:from:message-id:subject:to; s=corp-2025-04-25; bh=YCKnp3Or
	O5Wmgx35HPKkfCaxbUBnGDjKLz7CyQmLiKk=; b=LQUrCmxJNw0nNG79310xtT1Q
	LBpkAV2ndtFEYutWKox/qH5IwOt1cybS1IAMr+NJJrlxTRxyd3w4PO2gKbTyFsMu
	BcB+KrhCPdwcIV32COtPY/HTFHm841u0YdccbHa+IDGXqQ2eEDAmm4vwc6meJD1S
	tFZCiFY0QUaubCRl48WVtres8SxqTMJhUO2/r18PUqj0uouQGwGjnsP+7WKL2Cn6
	aEaTjjpCzIYhZw4Z2GjejQ97PZbybNDyzB8vmkPLLbl0YCquDgHGQaMMB9K0F5/j
	YBUqiMjuomqxeFvFJG1gk1AVP2M/aeT2OniUgydfivKobk7zqpHYI/XWj37Wbg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8xx72jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 14:41:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 562ETKxs027426;
	Wed, 2 Jul 2025 14:41:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ub9veg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 14:41:39 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 562Efceh028848;
	Wed, 2 Jul 2025 14:41:38 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47j6ub9vds-1;
	Wed, 02 Jul 2025 14:41:38 +0000
From: Steve Sistare <steven.sistare@oracle.com>
To: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH] KVM: arm64: preserve pending during kvm_irqfd_deassign
Date: Wed,  2 Jul 2025 07:41:37 -0700
Message-Id: <1751467297-201441-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_02,2025-07-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507020120
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDEyMCBTYWx0ZWRfX3W1ipIPc+NLJ zfPOTz7A+j5BQorlfRvwOuEs9Ze8RtcHKpiRpMoNa/GQJ5zbI2CXHqUqxT1VzHSHPEncmkA2Kpt XRvJF1IHuMfdpKQI1TZGGyG3C5y8tNUzYAnxOde7SEoMmpX4dLgBvISakuChEd/KIalZ69BE/MA
 TKSxX8fs2qbvwVj3vnMqlcqbjlX798wOvloToX1csWpF6DNuD92QtZyaJ39Pt4EFPnzf5kYXA8K 2DCGRJl0h7ED6Mi30LOx7abNB4Xsg0tHh5x3d07LlzekX7DfY8st8k8FtUife7kU9G0p37Z8AxV BWApqVnacQUVXWYljzoe6rwbKf7rlD+oREzBVy/pZ3Bg2z3k/IgxbKfJowJtpb8Tvdae4cF0+61
 gKKzYEL+LSw6GQaxkQTEP6JromOs7WgZXhc/2LRIwo98Z5yYIOFB4XdyDtfNUfQsn/uocjGn
X-Proofpoint-ORIG-GUID: FlDV_UeUeg8y_lv3GJEyNXJIWJeV-Rka
X-Proofpoint-GUID: FlDV_UeUeg8y_lv3GJEyNXJIWJeV-Rka
X-Authority-Analysis: v=2.4 cv=QfRmvtbv c=1 sm=1 tr=0 ts=68654523 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=Wb1JkmetP80A:10 a=yPCof4ZbAAAA:8 a=slvqiuA5ilpdaXBxI5kA:9
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

When kvm_irqfd_deassign ... -> kvm_vgic_v4_unset_forwarding is called,
if an interrupt is pending in irq->pending_latch, then transfer it to
the producer's eventfd.  This way, if the KVM instance is subsequently
destroyed, the interrupt is preserved in producer state.  If the irqfd
is re-created in a new KVM instance, kvm_irqfd_assign finds the producer,
polls the eventfd, finds the interrupt, and injects it into KVM.

QEMU live update does that: it passes the VFIO device descriptors to the
new process, but destroys and recreates the KVM instance, without
quiescing VFIO interrupts.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 arch/arm64/kvm/arm.c          |  8 ++++++--
 arch/arm64/kvm/vgic/vgic-v4.c | 13 ++++++++++---
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38a91bb5d4c7..315f4829875b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2751,6 +2751,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
+	bool pending = false;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 	struct kvm_kernel_irq_routing_entry *irq_entry = &irqfd->irq_entry;
@@ -2758,7 +2759,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return;
 
-	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
+	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq, &pending);
+
+	if (pending)
+		eventfd_signal((struct eventfd_ctx *)prod->token);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
@@ -2781,7 +2785,7 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 	 *
 	 * Unmap the vLPI and fall back to software LPI injection.
 	 */
-	return kvm_vgic_v4_unset_forwarding(kvm, host_irq);
+	return kvm_vgic_v4_unset_forwarding(kvm, host_irq, NULL);
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..b4cc576f9b51 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -527,13 +527,14 @@ static struct vgic_irq *__vgic_host_irq_get_vlpi(struct kvm *kvm, int host_irq)
 	return NULL;
 }
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq, bool *pending)
 {
 	struct vgic_irq *irq;
 	unsigned long flags;
 	int ret = 0;
+	bool direct_msi = vgic_supports_direct_msis(kvm);
 
-	if (!vgic_supports_direct_msis(kvm))
+	if (!pending && !direct_msi)
 		return 0;
 
 	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
@@ -542,7 +543,13 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	WARN_ON(irq->hw && irq->host_irq != host_irq);
-	if (irq->hw) {
+
+	if (pending) {
+		*pending = irq->pending_latch;
+		irq->pending_latch = false;
+	}
+
+	if (direct_msi && irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
 		ret = its_unmap_vlpi(host_irq);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..249b39e8da02 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -434,7 +434,7 @@ struct kvm_kernel_irq_routing_entry;
 int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 			       struct kvm_kernel_irq_routing_entry *irq_entry);
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq);
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq, bool *pending);
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
-- 
2.39.3

