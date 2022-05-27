Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E4EC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:05:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19BE849F0F;
	Fri, 27 May 2022 04:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u8g2tr50B6ZP; Fri, 27 May 2022 04:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E64E54B186;
	Fri, 27 May 2022 04:05:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1D14B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+iQemfDDcCy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07EA749F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638717;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=990zi+sfu+1KWMZVgqplhrYTyhVc+VOJOjIr/irisRU=;
 b=Aw8dVSdDPsq+BYv3v+JLfphKJcrk2iWNYZ2bzH414DpumC83llbUyX48C+HyszNhwjbo/c
 MSJpvCBvrUyY2NjC03/4Cll+AL3zm3RHzEgafnarX3fDhQZNB9MKiLKs1I1LdTvjP1W7lH
 ujHE4uAUQ0laM4KPI0WeGpWy1ZBJGIg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-TbYShRdBOM6hGLgfZR7QJg-1; Fri, 27 May 2022 04:05:12 -0400
X-MC-Unique: TbYShRdBOM6hGLgfZR7QJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C116B1C161AE;
 Fri, 27 May 2022 08:05:11 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4D2A2026D64;
 Fri, 27 May 2022 08:05:04 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 11/22] KVM: arm64: Support {PRIVATE, SHARED}_RESET hypercall
Date: Fri, 27 May 2022 16:02:42 +0800
Message-Id: <20220527080253.1562538-12-gshan@redhat.com>
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

This supports {PRIVATE, SHARED}_RESET hypercall. There is nothing
to do if we're going to reset the shared events, which are not
supported. For the private events, their registered and enabled
state are cleared.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 6afa49b4f3c7..42ba6f97b168 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -184,6 +184,26 @@ static unsigned long pe_mask(struct kvm_vcpu *vcpu, bool mask)
 	return SDEI_SUCCESS;
 }
 
+static unsigned long event_reset(struct kvm_vcpu *vcpu, bool private)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	unsigned int num;
+
+	/*
+	 * Nothing to do if we're going to reset the shared events,
+	 * which are unsupported.
+	 */
+	if (!private)
+		return SDEI_SUCCESS;
+
+	for (num = 0; num < KVM_NR_SDEI_EVENTS; num++) {
+		clear_bit(num, &vsdei->registered);
+		clear_bit(num, &vsdei->enabled);
+	}
+
+	return SDEI_SUCCESS;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -229,6 +249,12 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
 		ret = pe_mask(vcpu, false);
 		break;
+	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+		ret = event_reset(vcpu, true);
+		break;
+	case SDEI_1_0_FN_SDEI_SHARED_RESET:
+		ret = event_reset(vcpu, false);
+		break;
 	default:
 		ret = SDEI_NOT_SUPPORTED;
 	}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
