Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CD1C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 13 May 2022 09:26:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5313E49F18;
	Fri, 13 May 2022 05:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jPk2Elw7bDGb; Fri, 13 May 2022 05:26:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16CFF49F28;
	Fri, 13 May 2022 05:26:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86F2C49F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 05:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M72RNzp94o8M for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 05:26:13 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 441F349E42
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 05:26:13 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id
 ox8-20020a170907100800b006f9dc6e4a22so3875068ejb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 02:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9O8T4d24GJyDP8cnDNbV2+/gozd6tLFGA4/uUL04NR0=;
 b=iaKsTEqI7n6J/fP4v02bJyqUWoPtt5dhrjPs4ksBSNCBKOaXfDWwhOHzfJYQmcM+0l
 Osrd15SpJ/MUZVIrB2FnK9UyK05ZdH+RsxYG+9/juYL0xN4508oz+GpVT+6S4G95JeVn
 lzoKLMokWswGEorBviYK4hjGCsSNM4m8xdzn9TFgjxi2VEnFDGeyRURQzqIbIU6QbqJo
 scrHRXgr3/gzL/+DzERkF9yhkcv8Kd+tWMyBpmqr45Eg/xE0MvCzOrJP1R4LehaAbjl8
 Fq88TC29HBPTuxne5MzNIwAiVYuBgTZ8tWZXEKUE9VWNMUXuAoNg/SJwwN2JllFqQuKH
 0LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9O8T4d24GJyDP8cnDNbV2+/gozd6tLFGA4/uUL04NR0=;
 b=cQwWByiV8PPk0DgNPHhib7xl+G83APD8bq3z8ljCYoHLut2dTDHIC9I1P80LNEP7l2
 THWM3r8854dASYD4qE/iqL4+IE7uNUJXciD3X2wsyEKXFHYiAxt65iJgjIBfn3ysvVmv
 Yfg+OuolsoO1ENR7y+ztgX3iJ+sUiHMkItboTq66VP+ocE9Fc6E5HSJj/EMd1UX8kGlj
 KLjDjkn3X3pwHTY9PVhsMY1FGfpezFbgg+0kvrVn30Ro+1CglO0DqohFanZxv7IXUX68
 NMJLNU43zseJzrHuBLJpEDqIrw8GSTJaASo5epfcQ0W4hD8uTHbTzxA08PCXxE2FVdY8
 7TGQ==
X-Gm-Message-State: AOAM531I2nBebFzzKSrTYNsJZEiwZeqDabpkfaZSii+Ws6npB97nVpAH
 tRX9jBNENLqgFffLOmaUgpiS6dzq2iRT
X-Google-Smtp-Source: ABdhPJzEbS2hvb75/jq83OEwqeWgJNKE9I/lr4SjkTANlLOQGKApCVrv++PbFYZ8MimaO9CjAM0i3IiAohaE
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:aa7:c656:0:b0:428:3280:a432 with SMTP id
 z22-20020aa7c656000000b004283280a432mr39932843edr.396.1652433971840; Fri, 13
 May 2022 02:26:11 -0700 (PDT)
Date: Fri, 13 May 2022 09:26:07 +0000
Message-Id: <20220513092607.35233-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH] KVM: arm64: Don't hypercall before EL2 init
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
 linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

Will reported the following splat when running with Protected KVM
enabled:

[    2.427181] ------------[ cut here ]------------
[    2.427668] WARNING: CPU: 3 PID: 1 at arch/arm64/kvm/mmu.c:489 __create_hyp_private_mapping+0x118/0x1ac
[    2.428424] Modules linked in:
[    2.429040] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.18.0-rc2-00084-g8635adc4efc7 #1
[    2.429589] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[    2.430286] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.430734] pc : __create_hyp_private_mapping+0x118/0x1ac
[    2.431091] lr : create_hyp_exec_mappings+0x40/0x80
[    2.431377] sp : ffff80000803baf0
[    2.431597] x29: ffff80000803bb00 x28: 0000000000000000 x27: 0000000000000000
[    2.432156] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[    2.432561] x23: ffffcd96c343b000 x22: 0000000000000000 x21: ffff80000803bb40
[    2.433004] x20: 0000000000000004 x19: 0000000000001800 x18: 0000000000000000
[    2.433343] x17: 0003e68cf7efdd70 x16: 0000000000000004 x15: fffffc81f602a2c8
[    2.434053] x14: ffffdf8380000000 x13: ffffcd9573200000 x12: ffffcd96c343b000
[    2.434401] x11: 0000000000000004 x10: ffffcd96c1738000 x9 : 0000000000000004
[    2.434812] x8 : ffff80000803bb40 x7 : 7f7f7f7f7f7f7f7f x6 : 544f422effff306b
[    2.435136] x5 : 000000008020001e x4 : ffff207d80a88c00 x3 : 0000000000000005
[    2.435480] x2 : 0000000000001800 x1 : 000000014f4ab800 x0 : 000000000badca11
[    2.436149] Call trace:
[    2.436600]  __create_hyp_private_mapping+0x118/0x1ac
[    2.437576]  create_hyp_exec_mappings+0x40/0x80
[    2.438180]  kvm_init_vector_slots+0x180/0x194
[    2.458941]  kvm_arch_init+0x80/0x274
[    2.459220]  kvm_init+0x48/0x354
[    2.459416]  arm_init+0x20/0x2c
[    2.459601]  do_one_initcall+0xbc/0x238
[    2.459809]  do_initcall_level+0x94/0xb4
[    2.460043]  do_initcalls+0x54/0x94
[    2.460228]  do_basic_setup+0x1c/0x28
[    2.460407]  kernel_init_freeable+0x110/0x178
[    2.460610]  kernel_init+0x20/0x1a0
[    2.460817]  ret_from_fork+0x10/0x20
[    2.461274] ---[ end trace 0000000000000000 ]---

Indeed, the Protected KVM mode promotes __create_hyp_private_mapping()
to a hypercall as EL1 no longer has access to the hypervisor's stage-1
page-table. However, the call from kvm_init_vector_slots() happens after
pKVM has been initialized on the primary CPU, but before it has been
initialized on secondaries. As such, if the KVM initcall procedure is
migrated from one CPU to another in this window, the hypercall may end up
running on a CPU for which EL2 has not been initialized.

Fortunately, the pKVM hypervisor doesn't rely on the host to re-map the
vectors in the private range, so the hypercall in question is in fact
superfluous. Skip it when pKVM is enabled.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..7347c133efc4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1436,7 +1436,7 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() && !has_vhe() && !is_protected_kvm_enabled()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
