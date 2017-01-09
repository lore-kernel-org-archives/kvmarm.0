From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 20/55] KVM: arm64: Forward CPACR_EL1 traps to the guest
 hypervisor
Date: Mon,  9 Jan 2017 01:24:16 -0500
Message-ID: <1483943091-1364-21-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5355B40539
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ymg-K-5lOfjQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:18 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABA7B40296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:17 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWYN017300
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:59 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 522D38F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:59 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 3964980
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:59 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PxMI004922
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:59 -0500
Received: by mail-qk0-f197.google.com with SMTP id c69so110041673qkg.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:59 -0800 (PST)
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

Forward CPACR_EL1 traps to the guest hypervisor if it has configured the
virtual CPTR_EL2 to do so.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 321ecbc..e66f40d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -951,6 +951,11 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
+	/* Forward this trap to the guest hypervisor if it expects */
+	if (!vcpu_mode_el2(vcpu) &&
+	    (vcpu_el2_reg(vcpu, CPTR_EL2) & CPTR_EL2_TCPAC))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
 	return true;
 }
-- 
1.9.1
