Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F0EC55199
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 09:39:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90A63206B6
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 09:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90A63206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9BEF4B146;
	Mon, 27 Apr 2020 05:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RXCSye2b0jC6; Mon, 27 Apr 2020 05:39:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4144C4B1A6;
	Mon, 27 Apr 2020 05:39:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7CC04B14E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 08:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v43XE10AN3rr for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Apr 2020 08:39:13 -0400 (EDT)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 462FB4B14A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 08:39:13 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01f04427;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0Twh0apz_1587904748; 
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0Twh0apz_1587904748) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 26 Apr 2020 20:39:08 +0800
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To: pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
 mpe@ellerman.id.au, benh@kernel.crashing.org, borntraeger@de.ibm.com,
 frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
 heiko.carstens@de.ibm.com, gor@linux.ibm.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Subject: [PATCH v3 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
Date: Sun, 26 Apr 2020 20:39:01 +0800
Message-Id: <20200426123905.8336-4-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426123905.8336-1-tianjia.zhang@linux.alibaba.com>
References: <20200426123905.8336-1-tianjia.zhang@linux.alibaba.com>
X-Mailman-Approved-At: Mon, 27 Apr 2020 05:39:54 -0400
Cc: linux-s390@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
 kvm@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The 'kvm_run' field already exists in the 'vcpu' structure, which
is the same structure as the 'kvm_run' in the 'vcpu_arch' and
should be deleted.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/powerpc/kvm/book3s_hv.c        | 6 ++----
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1dc63101ffe1..2745ff8faa01 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -795,7 +795,6 @@ struct kvm_vcpu_arch {
 	struct mmio_hpte_cache_entry *pgfault_cache;
 
 	struct task_struct *run_task;
-	struct kvm_run *kvm_run;
 
 	spinlock_t vpa_update_lock;
 	struct kvmppc_vpa vpa;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..413ea2dcb10c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2934,7 +2934,7 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 
 		ret = RESUME_GUEST;
 		if (vcpu->arch.trap)
-			ret = kvmppc_handle_exit_hv(vcpu->arch.kvm_run, vcpu,
+			ret = kvmppc_handle_exit_hv(vcpu->run, vcpu,
 						    vcpu->arch.run_task);
 
 		vcpu->arch.ret = ret;
@@ -3920,7 +3920,6 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	spin_lock(&vc->lock);
 	vcpu->arch.ceded = 0;
 	vcpu->arch.run_task = current;
-	vcpu->arch.kvm_run = kvm_run;
 	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
 	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
 	vcpu->arch.busy_preempt = TB_NIL;
@@ -3973,7 +3972,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			if (signal_pending(v->arch.run_task)) {
 				kvmppc_remove_runnable(vc, v);
 				v->stat.signal_exits++;
-				v->arch.kvm_run->exit_reason = KVM_EXIT_INTR;
+				v->run->exit_reason = KVM_EXIT_INTR;
 				v->arch.ret = -EINTR;
 				wake_up(&v->arch.cpu_run);
 			}
@@ -4049,7 +4048,6 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 	vc = vcpu->arch.vcore;
 	vcpu->arch.ceded = 0;
 	vcpu->arch.run_task = current;
-	vcpu->arch.kvm_run = kvm_run;
 	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
 	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
 	vcpu->arch.busy_preempt = TB_NIL;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index dc97e5be76f6..5a3987f3ebf3 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -290,8 +290,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu, hdec_exp,
-					  lpcr);
+		r = kvmhv_run_single_vcpu(vcpu->run, vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
