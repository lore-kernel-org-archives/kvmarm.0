Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A1FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:08:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1DF40CDE;
	Tue, 22 Mar 2022 04:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DxJ4hQH9+FNk; Tue, 22 Mar 2022 04:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85A3D41049;
	Tue, 22 Mar 2022 04:08:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69EBD40FAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UwvxRPtAE-wN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:07:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF9340CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:07:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936476;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=N9c9KYfInlm3WESUry5oYf1sTxA1uf+ImXpH7d2FaLk=;
 b=LlS40oTbSSla2J6g3LoKxw2SpRgoiJy6hPu57YBCU0JA6MnWsDHnSUoOiNwEBcfWm0G207
 WorIiflAzxbvYsZQZw9NbncmSPHZLbv1aJdfr6isCaEBsmhLNhuzzqiPlNZiQWyg7qw+PI
 dNibwVzVbNWhu7WPm2eYwAPqVMlY8YU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-o8EAzm0_PpO9EZ1_Y38Gag-1; Tue, 22 Mar 2022 04:07:53 -0400
X-MC-Unique: o8EAzm0_PpO9EZ1_Y38Gag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4061E1C04B66;
 Tue, 22 Mar 2022 08:07:53 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6FC61121324;
 Tue, 22 Mar 2022 08:07:41 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 01/22] KVM: arm64: Introduce template for inline functions
Date: Tue, 22 Mar 2022 16:06:49 +0800
Message-Id: <20220322080710.51727-2-gshan@redhat.com>
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

The inline functions used to get the SMCCC parameters have same
layout. It means these functions can be presented by an unified
template, to make the code simplified. Besides, this adds more
similar inline functions like smccc_get_arg{4,5,6,7,8}() to get
more SMCCC arguments, which are needed by SDEI virtualization
support.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/kvm/arm_hypercalls.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 0e2509d27910..d5144c852fe4 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -13,20 +13,20 @@ static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
 	return vcpu_get_reg(vcpu, 0);
 }
 
-static inline unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 1);
-}
-
-static inline unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 2);
+#define SMCCC_DECLARE_GET_ARG(reg)					\
+static inline unsigned long smccc_get_arg##reg(struct kvm_vcpu *vcpu)	\
+{									\
+	return vcpu_get_reg(vcpu, reg);					\
 }
 
-static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 3);
-}
+SMCCC_DECLARE_GET_ARG(1)
+SMCCC_DECLARE_GET_ARG(2)
+SMCCC_DECLARE_GET_ARG(3)
+SMCCC_DECLARE_GET_ARG(4)
+SMCCC_DECLARE_GET_ARG(5)
+SMCCC_DECLARE_GET_ARG(6)
+SMCCC_DECLARE_GET_ARG(7)
+SMCCC_DECLARE_GET_ARG(8)
 
 static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 				    unsigned long a0,
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
