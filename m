From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 02/16] brlock: Always pass argument to
 br_read_lock/unlock
Date: Thu,  7 Mar 2019 08:36:03 +0000
Message-ID: <1551947777-13044-3-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D72514A4C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BIc5iQ-fxQI5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D67684A455
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:27 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The kvm argument is not passed to br_read_lock/unlock, this works for
the barrier implementation because the argument is not used. This ever
breaks if another lock implementation is used.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 ioport.c | 4 ++--
 mmio.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ioport.c b/ioport.c
index 505e822..a6dc65e 100644
--- a/ioport.c
+++ b/ioport.c
@@ -184,7 +184,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 	void *ptr = data;
 	struct kvm *kvm = vcpu->kvm;
 
-	br_read_lock();
+	br_read_lock(kvm);
 	entry = ioport_search(&ioport_tree, port);
 	if (!entry)
 		goto out;
@@ -201,7 +201,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 	}
 
 out:
-	br_read_unlock();
+	br_read_unlock(kvm);
 
 	if (ret)
 		return true;
diff --git a/mmio.c b/mmio.c
index c648bec..61e1d47 100644
--- a/mmio.c
+++ b/mmio.c
@@ -124,7 +124,7 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 {
 	struct mmio_mapping *mmio;
 
-	br_read_lock();
+	br_read_lock(vcpu->kvm);
 	mmio = mmio_search(&mmio_tree, phys_addr, len);
 
 	if (mmio)
@@ -135,7 +135,7 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
 	}
-	br_read_unlock();
+	br_read_unlock(vcpu->kvm);
 
 	return true;
 }
-- 
1.9.1
