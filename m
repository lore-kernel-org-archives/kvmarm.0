From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 06/11] KVM: arm/arm64: use vcpu requests for power_off
Date: Sun,  4 Jun 2017 14:43:56 +0200
Message-ID: <20170604124401.24902-7-drjones@redhat.com>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD3D40D08
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CkaEPBOAiyxb for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jun 2017 08:40:14 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11F4540D71
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:14 -0400 (EDT)
In-Reply-To: <20170604124401.24902-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

System shutdown is currently using request-less VCPU kicks. This
leaves open a tiny race window, as it doesn't ensure the state
change to power_off is seen by a VCPU just about to enter guest
mode. VCPU requests, OTOH, are guaranteed to be seen (see "Ensuring
Requests Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst)
This patch applies the EXIT request used by pause to power_off,
fixing the race.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
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
2.9.4
