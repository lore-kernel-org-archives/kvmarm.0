Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF4CC43461
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 14:08:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D39A361286
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 14:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39A361286
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739C04B6A4;
	Thu,  1 Apr 2021 10:08:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D8xZg24kmx12; Thu,  1 Apr 2021 10:08:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9774B6C3;
	Thu,  1 Apr 2021 10:08:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6B44B5E3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:55:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1maHS4b7CMAv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 09:55:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D1BA4B604
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:55:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617285351;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Beke6p3SuuLc9PEBd5EVBwfI5FcHk7u5ME5KWl6tIhg=;
 b=ddgGlG5WXKWE7cVfbO212WD6HRDPX4PmTVBF6NUxBG6D2cLANpOcTQX1j9gHhXsEPOxt4G
 J78VLe4ly//U5Cgz3uJX46cTL1f4Io5gnASe71RQhAZ4+nkC+zDOO7NB4WxeIYdl5n3ajA
 T4trUbt8fwcG3ixVV2ho7Ye6tymYp5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-_HcijJiUNj-mXO3Df2jx2A-1; Thu, 01 Apr 2021 09:55:49 -0400
X-MC-Unique: _HcijJiUNj-mXO3Df2jx2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C75BD107BEF6;
 Thu,  1 Apr 2021 13:55:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 32E505D6B1;
 Thu,  1 Apr 2021 13:55:32 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH v2 4/9] KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
Date: Thu,  1 Apr 2021 16:54:46 +0300
Message-Id: <20210401135451.1004564-5-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mailman-Approved-At: Thu, 01 Apr 2021 10:08:09 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
 <kvmarm@lists.cs.columbia.edu>, "open list:S390" <linux-s390@vger.kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Kieran Bingham <kbingham@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
 <linux-arm-kernel@lists.infradead.org>, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Move KVM_GUESTDBG_VALID_MASK to kvm_host.h
and use it to return the value of this capability.
Compile tested only.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/guest.c            | 5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..613421454ab6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -401,6 +401,10 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
 
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
+				 KVM_GUESTDBG_USE_SW_BP | \
+				 KVM_GUESTDBG_USE_HW | \
+				 KVM_GUESTDBG_SINGLESTEP)
 /*
  * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
  * take the following values:
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..e575eff76e97 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -208,6 +208,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
+	case KVM_CAP_SET_GUEST_DEBUG2:
+		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
 		r = 1;
 		break;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9bbd30e62799..6cb39ee74acd 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -888,11 +888,6 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
-			    KVM_GUESTDBG_USE_SW_BP | \
-			    KVM_GUESTDBG_USE_HW | \
-			    KVM_GUESTDBG_SINGLESTEP)
-
 /**
  * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
  * @kvm:	pointer to the KVM struct
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
