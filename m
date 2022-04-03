Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7BBC433EF
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:40:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C423B49ED7;
	Sun,  3 Apr 2022 11:40:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GWlkPBvzLcvu; Sun,  3 Apr 2022 11:40:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABECC4B19F;
	Sun,  3 Apr 2022 11:40:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 514F14B1BA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9YCZ3J1ZP0Ty for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74F1F49EC5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000410;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=N2/VYgb8BwuXP4gy6xwNWoMfI+WOYmTAaqXhSYXVe7M=;
 b=QG4LiCB8VTu4ZpiVW6+rgzAEV2Y0jpAq9bt/dorxIYLg/DlgnK40aIDIp+c7Kbee3Vvrct
 xwbcVdlNjEy4bO5NA+KhwdCceYV7mzWjn5VJLblTnabKk5TTmcVTBUu3KUZOdHXMQR0wZT
 mq5/OS4U3rV2XmZHnjGUuO5DlbWmHjk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-KrJb2otjMy6i2P7h8Ij8lw-1; Sun, 03 Apr 2022 11:40:07 -0400
X-MC-Unique: KrJb2otjMy6i2P7h8Ij8lw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 891473C02B6F;
 Sun,  3 Apr 2022 15:40:06 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BB6C403172;
 Sun,  3 Apr 2022 15:40:00 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 05/18] KVM: arm64: Support SDEI_EVENT_{ENABLE, DISABLE}
Date: Sun,  3 Apr 2022 23:38:58 +0800
Message-Id: <20220403153911.12332-6-gshan@redhat.com>
In-Reply-To: <20220403153911.12332-1-gshan@redhat.com>
References: <20220403153911.12332-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

This supports SDEI_EVENT_{ENABLE, DISABLE} hypercall. After the
event is registered, it won't be raised and delivered to guest
until it's enabled. On other hand, the event won't be delivered
to guest if it's disabled.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 89c1b231cb60..941263578b30 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -101,6 +101,45 @@ static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_enable(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *event;
+	unsigned long num = smccc_get_arg(vcpu, 1);
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (!kvm_sdei_is_supported(num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the event exists */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Check the event state */
+	if (!kvm_sdei_is_registered(event) ||
+	    kvm_sdei_is_unregister_pending(event)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	if (enable)
+		kvm_sdei_set_enabled(event);
+	else
+		kvm_sdei_clear_enabled(event);
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -125,6 +164,12 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
 		ret = hypercall_register(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
+		ret = hypercall_enable(vcpu, true);
+		break;
+	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
+		ret = hypercall_enable(vcpu, false);
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
