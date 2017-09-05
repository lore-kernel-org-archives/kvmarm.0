From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 3/8] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Tue,  5 Sep 2017 16:52:02 +0200
Message-ID: <20170905145207.18447-4-cdall@linaro.org>
References: <20170905145207.18447-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F40EA49C3A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 10:50:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YtRDYF1D3rx9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Sep 2017 10:49:56 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F5B049C2D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 10:49:56 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id i145so20452211wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Sep 2017 07:52:20 -0700 (PDT)
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <Suzuki.Poulose@arm.com>

The mmu_notifier_release() callback of KVM triggers cleaning up
the stage2 page table on kvm-arm. However there could be other
notifier callbacks in parallel with the mmu_notifier_release(),
which could cause the call backs ending up in an empty stage2
page table. Make sure we check it for all the notifier callbacks.

Cc: stable@vger.kernel.org
Fixes: commit 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
Reported-by: Alex Graf <agraf@suse.de>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0e1fc75..2ea21da 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1718,12 +1718,16 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
+	if (!kvm->arch.pgd)
+		return 0;
 	trace_kvm_age_hva(start, end);
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
+	if (!kvm->arch.pgd)
+		return 0;
 	trace_kvm_test_age_hva(hva);
 	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
 }
-- 
2.9.0
