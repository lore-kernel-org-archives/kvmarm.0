From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] arm64: KVM: clean up a condition
Date: Thu, 14 Jul 2016 13:19:34 +0300
Message-ID: <20160714101934.GD18175@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

My static checker complains that this condition looks like it should be
== instead of =.  This isn't a fast path, so we don't need to be fancy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a57d650..b0b225c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1546,7 +1546,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 				struct sys_reg_params *params)
 {
 	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
-	int cp;
+	int cp = -1;
 
 	switch(hsr_ec) {
 	case ESR_ELx_EC_CP15_32:
@@ -1558,7 +1558,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 		cp = 14;
 		break;
 	default:
-		WARN_ON((cp = -1));
+		WARN_ON(1);
 	}
 
 	kvm_err("Unsupported guest CP%d access at: %08lx\n",
