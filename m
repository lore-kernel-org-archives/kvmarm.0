From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/58] KVM: arm/arm64: use vcpu requests for power_off
Date: Fri, 30 Jun 2017 09:44:28 +0100
Message-ID: <20170630084514.6779-13-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01CE740EEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIU-JC26IgJF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B547040E37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:04 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrew Jones <drjones@redhat.com>

System shutdown is currently using request-less VCPU kicks. This
leaves open a tiny race window, as it doesn't ensure the state
change to power_off is seen by a VCPU just about to enter guest
mode. VCPU requests, OTOH, are guaranteed to be seen (see "Ensuring
Requests Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst)
This patch applies the EXIT request used by pause to power_off,
fixing the race.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/psci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index f68be2cc6256..f189d0ad30d5 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -179,10 +179,9 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
 		tmp->arch.power_off = true;
-		kvm_vcpu_kick(tmp);
-	}
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_VCPU_EXIT);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
-- 
2.11.0
