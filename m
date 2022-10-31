Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580237E
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 00:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667176704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHVR2QQLq5gmxvnkMA+rSKhZlYFOe38pzpUbmKo/1hk=;
	b=VE6MiRM/yWyh62dTeM495sD4MEx7lNICK8veM0fV+gWDyLCF43YyiGeoAdnzyEozOq3ABa
	hgrZl/irAOtJkGVPjc90ppvVAAV4kDWICminMabpnkTq3rOFqA1CUMpKAP1xaq0vwut/LZ
	GjdEgmrCzlkbGJflMhJydU0LvVPHrfM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-CqV6AEGKPfitiYbjqa1SUw-1; Sun, 30 Oct 2022 20:38:18 -0400
X-MC-Unique: CqV6AEGKPfitiYbjqa1SUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09FAA3C0F7E6;
	Mon, 31 Oct 2022 00:38:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A87E40C6F9F;
	Mon, 31 Oct 2022 00:38:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu,
	andrew.jones@linux.dev,
	ajones@ventanamicro.com,
	maz@kernel.org,
	bgardon@google.com,
	catalin.marinas@arm.com,
	dmatlack@google.com,
	will@kernel.org,
	pbonzini@redhat.com,
	peterx@redhat.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	james.morse@arm.com,
	shuah@kernel.org,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them
Date: Mon, 31 Oct 2022 08:36:15 +0800
Message-ID: <20221031003621.164306-4-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Message-ID: <20221031003615.oW2HtUqdBDuAH4GLh6xSjTttZ2S_ACawBTLRGVZGt74@z>

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

