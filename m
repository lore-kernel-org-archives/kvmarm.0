From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/10] KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
Date: Thu,  9 Mar 2017 09:55:36 +0000
Message-ID: <20170309095539.14512-8-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4B640625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GkTz8r+2zGDN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:55:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B042D40992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:11 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Add documentation for KVM_CAP_NR_MEMSLOTS capability.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 069450938b79..3c248f772ae6 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -951,6 +951,10 @@ This ioctl allows the user to create or modify a guest physical memory
 slot.  When changing an existing slot, it may be moved in the guest
 physical memory space, or its flags may be modified.  It may not be
 resized.  Slots may not overlap in guest physical address space.
+Bits 0-15 of "slot" specifies the slot id and this value should be
+less than the maximum number of user memory slots supported per VM.
+The maximum allowed slots can be queried using KVM_CAP_NR_MEMSLOTS,
+if this capability is supported by the architecture.
 
 If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 of "slot"
 specifies the address space which is being modified.  They must be
-- 
2.11.0
