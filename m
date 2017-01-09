From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 48/55] KVM: arm64: Emulate TLBI instruction
Date: Mon,  9 Jan 2017 01:24:44 -0500
Message-ID: <1483943091-1364-49-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6C8404E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ud79PkO49LQM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:54 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC222407F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:51 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXor005357
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:33 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 14E8081
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:33 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id E57FF84
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:32 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QWnG057893
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:32 -0500
Received: by mail-qk0-f198.google.com with SMTP id c69so110047618qkg.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:32 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Currently, we flush ALL shadow stage-2 page tables on the tlbi
instruction execution. We may be able to do this more efficiently by
considering the vttbr_el2 value of the guest hypervisor, but leave it
for now.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ddb641c..b0a057d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2013,8 +2013,14 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 static int emulate_tlbi(struct kvm_vcpu *vcpu,
 			     struct sys_reg_params *params)
 {
-	/* TODO: support tlbi instruction emulation*/
-	kvm_inject_undefined(vcpu);
+	/*
+	 * We unmap ALL stage-2 page tables on tlbi instruction.
+	 * We may make it more efficient by looking at the exact tlbi
+	 * instruction.
+	 */
+	stage2_unmap_vm(vcpu->kvm);
+	kvm_nested_s2_unmap(vcpu);
+
 	return 1;
 }
 
-- 
1.9.1
