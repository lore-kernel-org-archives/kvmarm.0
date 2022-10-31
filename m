Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8DCC38A02
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 00:38:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A854BACB;
	Sun, 30 Oct 2022 20:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YUkqxI9P75HY; Sun, 30 Oct 2022 20:38:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787214BACD;
	Sun, 30 Oct 2022 20:38:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92C144BAC5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Oct 2022 20:38:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLShsbDcdD3G for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Oct 2022 20:38:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80A7E4BAAB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Oct 2022 20:38:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667176703;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BHVR2QQLq5gmxvnkMA+rSKhZlYFOe38pzpUbmKo/1hk=;
 b=RmG/lg/y/gzT02wQG+UJTtRbhluXyFw7HeI+JEH59u22Oxkd6mjLGykpkPmRdEPou37fpe
 TcM+n3esXAO7guVp250ZGXhf47LQQCSWAIImZBVSgSfQxwzTYFzJp2y0owZKtuOVFvKkLy
 zOOZXfxw1ns6OQwKJCP82C+tJoxYesI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-CqV6AEGKPfitiYbjqa1SUw-1; Sun, 30 Oct 2022 20:38:18 -0400
X-MC-Unique: CqV6AEGKPfitiYbjqa1SUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09FAA3C0F7E6;
 Mon, 31 Oct 2022 00:38:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A87E40C6F9F;
 Mon, 31 Oct 2022 00:38:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING,
 RING_ACQ_REL} prior to enabling them
Date: Mon, 31 Oct 2022 08:36:15 +0800
Message-Id: <20221031003621.164306-4-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

There are two capabilities related to ring-based dirty page tracking:
KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL. Both are
supported by x86. However, arm64 supports KVM_CAP_DIRTY_LOG_RING_ACQ_REL
only when the feature is supported on arm64. The userspace doesn't have
to enable the advertised capability, meaning KVM_CAP_DIRTY_LOG_RING can
be enabled on arm64 by userspace and it's wrong.

Fix it by double checking if the capability has been advertised prior to
enabling it. It's rejected to enable the capability if it hasn't been
advertised.

Fixes: 17601bfed909 ("KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option")
Reported-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 30ff73931e1c..91cf51a25394 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4584,6 +4584,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
 	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
+		if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap))
+			return -EINVAL;
+
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
