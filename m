From: linucherian@gmail.com
Subject: [PATCH V3 1/4] KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
Date: Tue,  7 Mar 2017 11:22:41 +0530
Message-ID: <1488865964-17346-2-git-send-email-linucherian@gmail.com>
References: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74BBC40C28
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:52:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1X4LT-GaPlt6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 00:52:07 -0500 (EST)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
 [209.85.192.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ECFF40A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:52:07 -0500 (EST)
Received: by mail-pf0-f194.google.com with SMTP id o126so5816026pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 21:53:28 -0800 (PST)
In-Reply-To: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: Linu Cherian <linu.cherian@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
---
 Documentation/virtual/kvm/api.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 03145b7..7b82f1c 100644
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
1.9.1
