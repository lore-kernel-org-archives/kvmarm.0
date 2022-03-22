Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CDAC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:09:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C5349F09;
	Tue, 22 Mar 2022 04:09:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jk15f2G-19JT; Tue, 22 Mar 2022 04:09:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D14411C7;
	Tue, 22 Mar 2022 04:09:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48B2C40431
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 57DaKeU1HnnI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:09:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4F340BE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936587;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KDBG9hheIqOVlljCf2sb5fT6Csq9yFBt9fZvXIcLh5A=;
 b=LFYC2VGEFThpNRS6KuFWp2LDatyHp/mIWZdo9tv+ZBCIaAqheRwi7v+gkAdolWYmSq0Lly
 5y+dpDLjUtBUZQn8qqAFZ3Ox5HfFxrjFClexzngv0g4fB77Zd+m+zh6tEqjKcBqfV0kUjr
 t9zGP2gwQhGsrsMfURr3cvbiGSzBdi8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-fw8RiBStPEioOqaJUno_BA-1; Tue, 22 Mar 2022 04:09:43 -0400
X-MC-Unique: fw8RiBStPEioOqaJUno_BA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B6FB85A5BC;
 Tue, 22 Mar 2022 08:09:43 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D33F1121324;
 Tue, 22 Mar 2022 08:09:33 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 12/22] KVM: arm64: Support SDEI_{PRIVATE, SHARED}_RESET
Date: Tue, 22 Mar 2022 16:07:00 +0800
Message-Id: <20220322080710.51727-13-gshan@redhat.com>
In-Reply-To: <20220322080710.51727-1-gshan@redhat.com>
References: <20220322080710.51727-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

This supports SDEI_{PRIVATE, SHARED}_RESET. They are used by the
guest to reset the private events on the calling vCPU or the
shared events on all vCPUs.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index b2a916724cfa..0dec35a0eed1 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -637,6 +637,31 @@ static unsigned long hypercall_mask(struct kvm_vcpu *vcpu, bool mask)
 	return ret;
 }
 
+static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_registered_event *registered_event, *tmp;
+	unsigned long r, ret = SDEI_SUCCESS;
+
+	spin_lock(&ksdei->lock);
+
+	list_for_each_entry_safe(registered_event, tmp,
+				 &ksdei->registered_events, link) {
+		exposed_event = registered_event->exposed_event;
+		if (private ^ kvm_sdei_is_shared(exposed_event->state.type))
+			continue;
+
+		r = unregister_one_event(kvm, NULL, registered_event);
+		ret = (r == SDEI_SUCCESS) ? ret : r;
+	}
+
+	spin_unlock(&ksdei->lock);
+
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -700,8 +725,14 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
 	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
 	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
+		ret = SDEI_NOT_SUPPORTED;
+		break;
 	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+		ret = hypercall_reset(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_SHARED_RESET:
+		ret = hypercall_reset(vcpu, false);
+		break;
 	case SDEI_1_1_FN_SDEI_FEATURES:
 	default:
 		ret = SDEI_NOT_SUPPORTED;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
