Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE8CC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 10:12:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA8E41019;
	Thu, 17 Feb 2022 05:12:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IuajAUozKv6Y; Thu, 17 Feb 2022 05:12:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A12D49B26;
	Thu, 17 Feb 2022 05:12:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49C6541019
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 05:12:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ms8Ld4w8S+f6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 05:12:48 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFA1F41014
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 05:12:48 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 g16-20020a05660203d000b005f7b3b0642eso1748408iov.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 02:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=5T4ROjtiSYSmILGtelNbeXe0t7OVZ2zJkKj18jqpZkM=;
 b=lUzq+PCpYalHly9R3Q1U06bzq2o75xRuFbqYlkDMnnn5KOiSDkcPRkLnJpxR5Y8s6B
 9tmLnKvXcEOsWLwD/z+2dF9XLULMO0qynB+qbLVFy26bDbAUp0tP0SzxNUTphTAMM+Sx
 0GMYh6axYOoWjIqXTFUhW1VVWvlzFSQ9o4jfRjm9ckT8YcZxiclp3BVxF201cY1Zrvhc
 6/2A6C99zU5v+t3j9xPzLnTUPRsc1NO6sjAYA+ULe5x8D3BdddGJ+Aa8Wtago4gpPimI
 /tAFA1zexbYa1S0w3fX2xlxIKnGK8w01qy0lx0n4/6DuJa2N4ru7jTu16TfwzuDrSQWh
 cWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=5T4ROjtiSYSmILGtelNbeXe0t7OVZ2zJkKj18jqpZkM=;
 b=FJ2ntWZXpKxJjdsUVX4P8O2pBbOreu2HBrvwdJ/CFX6usvdMHvi5xDUQYeylhPxE4k
 Ety8V1xHizenMRqMBrWdvTCNpH2AcgKtqxlXHe0LABMmfwnvwEeKojwwgz4w6Fwia8gj
 l3Cc1m7ioVUu34baW3YOGKokmi1PbH56T1CsdsuTiSe3YHAPiwdes2gSRpjNshPpwmDv
 IQ0Giu3LPUGJniJ6mYqjucynD4TR5bsZFKGXrqMQ4bhlrqq2d8EkLJBxLxHParrIdzJX
 3MSCWsNX74Hzi5K0OXY0KsAlDZTQbGiNj7AHyK266bhkBw/oxD49EBGvEPR92bgVzD6y
 WNaA==
X-Gm-Message-State: AOAM533km9TzM8ZC7IuBxosO/a14Ih7gN+AuNDEXh/P/JF4ibulqhZye
 21NFU6oXn0eJyrCbSQ08n6PczPAS/ixElxwk9nbOTOJRlL3SrFI6jT5qZbywF7RZpn3oW7UPe0E
 gYWxyjIiFPoZOehebOCOswsA1T1ec7ZBLcTx/omA5c0L2TbwnSSSBYmgks/vj6F3HBJInbA==
X-Google-Smtp-Source: ABdhPJyOEPz9mt5BJMOOnZ7Z5Hae+tzeYPXrDeNDmxnly8CXUchWb06soiTAXuk5BdL+NZ9baVeN5BMO0QM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2f01:b0:5ec:f99a:93a1
 with SMTP id
 q1-20020a0566022f0100b005ecf99a93a1mr1452284iow.109.1645092767893; Thu, 17
 Feb 2022 02:12:47 -0800 (PST)
Date: Thu, 17 Feb 2022 10:12:42 +0000
Message-Id: <20220217101242.3013716-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended vCPU
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In order to properly emulate the WFI instruction, KVM reads back
ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
necessary in order to recognize pending interrupts in
kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
callback hook"), these callbacks were gutted and superseded by
kvm_vcpu_wfi().

It is important to note that KVM implements PSCI CPU_SUSPEND calls as
a WFI within the guest. However, the implementation calls directly into
kvm_vcpu_halt(), which skips the needed work done in kvm_vcpu_wfi()
to detect pending interrupts. Fix the issue by calling the WFI helper.

Fixes: 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3eae32876897..2ce60fecd861 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -46,8 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * specification (ARM DEN 0022A). This means all suspend states
 	 * for KVM will preserve the register state.
 	 */
-	kvm_vcpu_halt(vcpu);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+	kvm_vcpu_wfi(vcpu);
 
 	return PSCI_RET_SUCCESS;
 }
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
