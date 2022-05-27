Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4D1C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:05:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917E549F3D;
	Fri, 27 May 2022 04:05:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0MwKbEU1nSPE; Fri, 27 May 2022 04:05:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63CD84B186;
	Fri, 27 May 2022 04:05:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD2649F01
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lxbe47rkadki for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55915410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638747;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9CfhejkXuPa7WByuloODhCqAxTblZ1S6BbTJI/JlxSk=;
 b=NXXXkEnmDNt+o+/qYXZdeDhHn/Aq5wmDBHV24g+NBD1Xn0TBEfL6PfjHQw1qcxPAshsdgB
 D/gFmUeY9oafaYRceXqU8m28sYincCm2qJcsShf17kiBoJbLg16G7W81pcTt8KgsSygSyg
 7bVvzYeUq9lD08C7zzOzLRHadmbRm4I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-9XtA_8I5PWyJEkWbwAHphQ-1; Fri, 27 May 2022 04:05:41 -0400
X-MC-Unique: 9XtA_8I5PWyJEkWbwAHphQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B34B1C161B3;
 Fri, 27 May 2022 08:05:41 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7D442026D64;
 Fri, 27 May 2022 08:05:30 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 14/22] KVM: arm64: Support EVENT_SIGNAL hypercall
Date: Fri, 27 May 2022 16:02:45 +0800
Message-Id: <20220527080253.1562538-15-gshan@redhat.com>
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

This supports EVENT_SIGNAL hypercall. It's used to inject the
software signaled event, whose number is zero. The KVM_REQ_SDEI
request is raised if the PE is unmasked and the event has been
enabled.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c         | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/arm_sdei.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 0bea1b2f9452..a55797fce06a 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -232,6 +232,31 @@ static unsigned long pe_mask(struct kvm_vcpu *vcpu, bool mask)
 	return SDEI_SUCCESS;
 }
 
+static unsigned long event_signal(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+
+	if (num >= KVM_NR_SDEI_EVENTS)
+		return SDEI_INVALID_PARAMETERS;
+
+	/*
+	 * The event must be software signaled event, whose
+	 * number is zero.
+	 */
+	if (num != SDEI_SW_SIGNALED_EVENT ||
+	    !test_bit(num, &vsdei->registered))
+		return SDEI_INVALID_PARAMETERS;
+
+	if (!test_and_set_bit(num, &vsdei->pending)) {
+		if (!(vcpu->arch.flags & KVM_ARM64_SDEI_MASKED) &&
+		    test_bit(num, &vsdei->enabled))
+			kvm_make_request(KVM_REQ_SDEI, vcpu);
+	}
+
+	return SDEI_SUCCESS;
+}
+
 static unsigned long event_reset(struct kvm_vcpu *vcpu, bool private)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -303,6 +328,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
 		ret = pe_mask(vcpu, false);
 		break;
+	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
+		ret = event_signal(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
 		ret = event_reset(vcpu, true);
 		break;
diff --git a/include/uapi/linux/arm_sdei.h b/include/uapi/linux/arm_sdei.h
index af0630ba5437..72b07114bbfa 100644
--- a/include/uapi/linux/arm_sdei.h
+++ b/include/uapi/linux/arm_sdei.h
@@ -22,9 +22,12 @@
 #define SDEI_1_0_FN_SDEI_PE_UNMASK			SDEI_1_0_FN(0x0C)
 #define SDEI_1_0_FN_SDEI_INTERRUPT_BIND			SDEI_1_0_FN(0x0D)
 #define SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE		SDEI_1_0_FN(0x0E)
+#define SDEI_1_1_FN_SDEI_EVENT_SIGNAL			SDEI_1_0_FN(0x0F)
 #define SDEI_1_0_FN_SDEI_PRIVATE_RESET			SDEI_1_0_FN(0x11)
 #define SDEI_1_0_FN_SDEI_SHARED_RESET			SDEI_1_0_FN(0x12)
 
+#define SDEI_SW_SIGNALED_EVENT		0
+
 #define SDEI_VERSION_MAJOR_SHIFT			48
 #define SDEI_VERSION_MAJOR_MASK				0x7fff
 #define SDEI_VERSION_MINOR_SHIFT			32
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
