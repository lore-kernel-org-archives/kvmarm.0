Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040B6C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A147F61279
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A147F61279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D214B16F;
	Fri,  5 Nov 2021 15:21:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wVhoF9aPfWzw; Fri,  5 Nov 2021 15:21:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4123E4B1B0;
	Fri,  5 Nov 2021 15:21:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0068A4B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D2GVkcXeKkvh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 15:21:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 619774B0C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:31 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 70C516125F;
 Fri,  5 Nov 2021 19:21:30 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mj4mG-003ig2-Jz; Fri, 05 Nov 2021 19:21:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/5] KVM: mips: Use kvm_get_vcpu() instead of open-coded access
Date: Fri,  5 Nov 2021 19:20:58 +0000
Message-Id: <20211105192101.3862492-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com,
 atish.patra@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com, jgross@suse.com,
 npiggin@gmail.com, seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Anup Patel <anup.patel@wdc.com>, David Hildenbrand <david@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, kernel-team@android.com,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
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

As we are about to change the way vcpus are allocated, mandate
the use of kvm_get_vcpu() instead of open-coding the access.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/mips/kvm/loongson_ipi.c | 4 ++--
 arch/mips/kvm/mips.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/loongson_ipi.c b/arch/mips/kvm/loongson_ipi.c
index 3681fc8fba38..5d53f32d837c 100644
--- a/arch/mips/kvm/loongson_ipi.c
+++ b/arch/mips/kvm/loongson_ipi.c
@@ -120,7 +120,7 @@ static int loongson_vipi_write(struct loongson_kvm_ipi *ipi,
 		s->status |= data;
 		irq.cpu = id;
 		irq.irq = 6;
-		kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
+		kvm_vcpu_ioctl_interrupt(kvm_get_vcpu(kvm, id), &irq);
 		break;
 
 	case CORE0_CLEAR_OFF:
@@ -128,7 +128,7 @@ static int loongson_vipi_write(struct loongson_kvm_ipi *ipi,
 		if (!s->status) {
 			irq.cpu = id;
 			irq.irq = -6;
-			kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
+			kvm_vcpu_ioctl_interrupt(kvm_get_vcpu(kvm, id), &irq);
 		}
 		break;
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index ceacca74f808..6228bf396d63 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -479,7 +479,7 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	if (irq->cpu == -1)
 		dvcpu = vcpu;
 	else
-		dvcpu = vcpu->kvm->vcpus[irq->cpu];
+		dvcpu = kvm_get_vcpu(vcpu->kvm, irq->cpu);
 
 	if (intr == 2 || intr == 3 || intr == 4 || intr == 6) {
 		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
