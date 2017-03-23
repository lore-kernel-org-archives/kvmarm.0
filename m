From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] arm/arm64: KVM: send SIGBUS error to qemu
Date: Thu, 23 Mar 2017 21:01:01 +0800
Message-ID: <1490274061-487-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A906740C25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 08:43:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w4VNysdjtp1h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Mar 2017 08:43:58 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (unknown [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20F4C408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 08:43:54 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com
Cc: wuquanming@huawei.com, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

when the pfn is KVM_PFN_ERR_HWPOISON, it indicates to send
SIGBUS signal from KVM's fault-handling code to qemu, qemu
can handle this signal according to the fault address.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm/kvm/mmu.c       | 20 ++++++++++++++++++++
 include/linux/kvm_host.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 962616fd4ddd..1307ec400de3 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1237,6 +1237,20 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
 	__coherent_cache_guest_page(vcpu, pfn, size);
 }
 
+static void kvm_send_hwpoison_signal(unsigned long address,
+					struct task_struct *tsk)
+{
+	siginfo_t info;
+
+	info.si_signo	= SIGBUS;
+	info.si_errno	= 0;
+	info.si_code	= BUS_MCEERR_AR;
+	info.si_addr	= (void __user *)address;
+	info.si_addr_lsb = PAGE_SHIFT;
+
+	send_sig_info(SIGBUS, &info, tsk);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1309,6 +1323,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
+	if (is_error_hwpoison_pfn(pfn)) {
+		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn),
+								current);
+		return -EFAULT;
+	}
+
 	if (kvm_is_device_pfn(pfn)) {
 		mem_type = PAGE_S2_DEVICE;
 		flags |= KVM_S2PTE_FLAG_IS_IOMAP;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c14ad9809da..610ded9ebe9b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -91,6 +91,11 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 {
 	return pfn == KVM_PFN_NOSLOT;
 }
+/* hwpoison pfn indicates that it needs to send SIGBUS */
+static inline bool is_error_hwpoison_pfn(kvm_pfn_t pfn)
+{
+	return pfn == KVM_PFN_ERR_HWPOISON;
+}
 
 /*
  * architectures with KVM_HVA_ERR_BAD other than PAGE_OFFSET (e.g. s390)
-- 
2.11.0
