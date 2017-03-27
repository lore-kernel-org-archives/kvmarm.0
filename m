From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 16/22] KVM: expose next_segment()
Date: Mon, 27 Mar 2017 11:31:06 +0200
Message-ID: <1490607072-21610-17-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF35940A86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KbIN8tMyYogu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:30:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2A1740A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:45 -0400 (EDT)
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Expose next_segment() as we would like to reuse this routine in
ARM vgic-its code.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/linux/kvm_host.h | 8 ++++++++
 virt/kvm/kvm_main.c      | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c14ad9..b4b5d82 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -92,6 +92,14 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 	return pfn == KVM_PFN_NOSLOT;
 }
 
+static inline int next_segment(unsigned long len, int offset)
+{
+	if (len > PAGE_SIZE - offset)
+		return PAGE_SIZE - offset;
+	else
+		return len;
+}
+
 /*
  * architectures with KVM_HVA_ERR_BAD other than PAGE_OFFSET (e.g. s390)
  * provide own defines and kvm_is_error_hva
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a17d787..b825e86 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1738,14 +1738,6 @@ void kvm_get_pfn(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_get_pfn);
 
-static int next_segment(unsigned long len, int offset)
-{
-	if (len > PAGE_SIZE - offset)
-		return PAGE_SIZE - offset;
-	else
-		return len;
-}
-
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
-- 
2.5.5
