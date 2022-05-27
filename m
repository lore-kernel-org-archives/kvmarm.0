Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C64C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:05:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F29D49F1D;
	Fri, 27 May 2022 04:05:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kPeqmR-cS6uS; Fri, 27 May 2022 04:05:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E0524B26D;
	Fri, 27 May 2022 04:05:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 146C549F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5p0EgctIMtls for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4D1B410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638733;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=n/sMtf3ycYV6mAOWnm/6XSJenHeTbOjDcLvp1nt3Cvw=;
 b=ci97Z5sooPg0qfBPoh2IJ52VToTbE8vqK4h+eoKmHOtrJxVGTeVZTGi72iXGgKurbneq8y
 L95nAMsPOH3xTqvQSY1tQ+qO/6CT10QU+X52nZ8udVwKFx4hhx9RMQce2bTYO+3dc9+/ws
 1Weo8HcxU9IbMHXCGsUBq9YNg9rqapY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-LBUecK2GMdK7gJWsKVcz4A-1; Fri, 27 May 2022 04:05:30 -0400
X-MC-Unique: LBUecK2GMdK7gJWsKVcz4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBC71C161AE;
 Fri, 27 May 2022 08:05:29 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1D972026D64;
 Fri, 27 May 2022 08:05:19 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 13/22] KVM: arm64: Support EVENT_{COMPLETE,
 COMPLETE_AND_RESUME} hypercall
Date: Fri, 27 May 2022 16:02:44 +0800
Message-Id: <20220527080253.1562538-14-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

This supports EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall. The
execution resumes from previously interrupted context when
EVENT_COMPLETE hypercall is received.

However, the execution resumes from the specified address when
EVENT_COMPLETE_AND_RESUME is received. In this case, context
switches like below.

  * x0 to x17 are restored from the interrupted context.

  * SPSR_EL1 is set to PSTATE of the interrupted context.

  * ELR_EL1 is set to PC of the interrupted context.

  * PSTATE has nRW cleared, but D/A/I/F set.

  * PC is set to the resume address, specified in the first argument
    of EVENT_COMPLETE_AND_RESUME hypercall.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 36a72c1750fc..0bea1b2f9452 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -85,6 +85,54 @@ static unsigned long event_context(struct kvm_vcpu *vcpu)
 	return ctxt->regs[param_id];
 }
 
+static void event_complete(struct kvm_vcpu *vcpu, bool resume)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event_context *ctxt = &vsdei->ctxt;
+	unsigned long pstate, resume_addr = smccc_get_arg(vcpu, 1);
+	unsigned int num, i;
+
+	num = find_next_bit(&vsdei->running, KVM_NR_SDEI_EVENTS, 0);
+	if (num >= KVM_NR_SDEI_EVENTS)
+		return;
+
+	/* Restore registers: x0 -> x17 */
+	for (i = 0; i < ARRAY_SIZE(ctxt->regs); i++)
+		vcpu_set_reg(vcpu, i, ctxt->regs[i]);
+
+	/*
+	 * The registers are modified accordingly if the execution resumes
+	 * from the specified address.
+	 *
+	 * SPSR_EL1: PSTATE of the interrupted context
+	 * ELR_EL1:  PC of the interrupted context
+	 * PSTATE:   cleared nRW bit, but D/A/I/F bits are set
+	 * PC:       the resume address
+	 */
+	if (resume) {
+		if (has_vhe()) {
+			write_sysreg_el1(ctxt->pstate, SYS_SPSR);
+			write_sysreg_s(ctxt->pc, SYS_ELR_EL12);
+		} else {
+			__vcpu_sys_reg(vcpu, SPSR_EL1) = ctxt->pstate;
+			__vcpu_sys_reg(vcpu, ELR_EL1) = ctxt->pc;
+		}
+
+		pstate = ctxt->pstate;
+		pstate &= ~(PSR_MODE32_BIT | PSR_MODE_MASK);
+		pstate |= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT |
+			   PSR_F_BIT | PSR_MODE_EL1h);
+		*vcpu_cpsr(vcpu) = pstate;
+		*vcpu_pc(vcpu) = resume_addr;
+	} else {
+		*vcpu_cpsr(vcpu) = ctxt->pstate;
+		*vcpu_pc(vcpu) = ctxt->pc;
+	}
+
+	/* Update event state */
+	clear_bit(num, &vsdei->running);
+}
+
 static unsigned long event_unregister(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -234,6 +282,12 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
 		ret = event_context(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
+		event_complete(vcpu, false);
+		break;
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
+		event_complete(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
 		ret = event_unregister(vcpu);
 		break;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
