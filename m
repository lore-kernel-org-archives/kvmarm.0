Return-Path: <SRS0=uoKB=PI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B608C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C82FA6135E
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C82FA6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 692194B104;
	Wed, 20 Oct 2021 10:27:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uR7uz-69o62Q; Wed, 20 Oct 2021 10:27:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 621844B159;
	Wed, 20 Oct 2021 10:27:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F3174B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i7+LZB5OZUHE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Oct 2021 08:05:13 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E8A64B099
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:05:13 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id kk10so2350125pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 05:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=7bzPbU2Xaa8fmzxUh6rCSbTEYDD93djqUZnD3TW+SAs=;
 b=UX+uqnX27wkcUQgZ7Np/jTXc2gdVOauvft2bDy1JTzrj3fz3ZiNp7p/BLL6K/zXTIw
 R4Q5EID0HPrqtxjWoUKWlr3IayZYodQ+mwfmBI1Ehvyhu5BtHD03bI1iChvsTHq8wxSq
 PhMLe2jeLzD9QSxuYYTqv4dIPnC124TCI+wow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=7bzPbU2Xaa8fmzxUh6rCSbTEYDD93djqUZnD3TW+SAs=;
 b=jhDjopZ7puv9g+78uGD/08kjak5cESoa9Zy0eTviGCYVkSZMRPz7VLutckdOvv8AF9
 tc2ux49ek+RnGCiVXu5mu2jQkuLxY0AlYsgFlXrXkr0s/BgtcfhF/p9AaeJFvf6yk5pL
 CvDB3AOtH9QoREGiLzK/mXLviCn/er34B0Ljhka/vdDOrzw4QzzCbxZ0nU7Ykc15k5UI
 WPIMt6CLEOKvsVz6Ff7+SV4sTwUUeLXq2muetSqpRP7E2bYnSvRskPiF8RqYGm1zKJkp
 RWg+RR/IAwua8yTCe3APSjuLajcHr/uUV3hpaf+TCFA9fI0b93M79cBVB32XQYwHE4Cl
 crwQ==
X-Gm-Message-State: AOAM533lviPoWFhXZWaTfUPjbsnacvY5xVZXX5wGRVYuaajvm2u7Ov9Y
 wFDtDpNKLM+bQcAA0eccRFzQPg==
X-Google-Smtp-Source: ABdhPJw1+iL+I6HcYGcYZD7jYmOIU3e4eK8PQhco2KBIwknjmRZyUPYqWMY+ib0NNjlPhxwohXSeBQ==
X-Received: by 2002:a17:902:8682:b0:13f:8e12:c977 with SMTP id
 g2-20020a170902868200b0013f8e12c977mr32473932plo.62.1634731512056; 
 Wed, 20 Oct 2021 05:05:12 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
 by smtp.gmail.com with UTF8SMTPSA id n14sm2115748pgd.68.2021.10.20.05.05.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 20 Oct 2021 05:05:11 -0700 (PDT)
From: Hikaru Nishida <hikalium@chromium.org>
To: linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
 mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
 vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Subject: [RFC PATCH v3 3/5] kvm/x86: virtual suspend time injection: Add
 common definitions
Date: Wed, 20 Oct 2021 21:04:28 +0900
Message-Id: <20211020210348.RFC.v3.3.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 20 Oct 2021 10:27:47 -0400
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>,
 linux-doc@vger.kernel.org, Hikaru Nishida <hikalium@chromium.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, suleiman@google.com, senozhatsky@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Add definitions of MSR, KVM_FEATURE bit and a structure called
kvm_suspend_time that are used by later patches to support the
virtual suspend time injection mechanism.

Also add documentations for them.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Moved the definition of struct kvm_suspend_time into this patch.

 Documentation/virt/kvm/cpuid.rst     |  3 +++
 Documentation/virt/kvm/msr.rst       | 30 ++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  6 ++++++
 3 files changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index bda3e3e737d7..f17b95b0d943 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -103,6 +103,9 @@ KVM_FEATURE_HC_MAP_GPA_RANGE       16          guest checks this feature bit bef
 KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit before
                                                using MSR_KVM_MIGRATION_CONTROL
 
+KVM_FEATURE_HOST_SUSPEND_TIME      18          host suspend time information
+                                               is available at msr 0x4b564d09.
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 9315fc385fb0..40ec0fd263ac 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -389,3 +389,33 @@ data:
         guest is communicating page encryption status to the host using the
         ``KVM_HC_MAP_GPA_RANGE`` hypercall, it can set bit 0 in this MSR to
         allow live migration of the guest.
+
+MSR_KVM_HOST_SUSPEND_TIME:
+	0x4b564d09
+
+data:
+	8-byte alignment physical address of a memory area which must be
+	in guest RAM, plus an enable bit in bit 0. This memory is expected to
+	hold a copy of the following structure::
+
+	 struct kvm_suspend_time {
+		__u64   suspend_time_ns;
+	 };
+
+	whose data will be filled in by the hypervisor.
+	If the guest register this structure through the MSR write, the host
+	will stop all the clocks visible to the guest (including TSCs) during
+	the host's suspension and report the duration of suspend through this
+	structure. The update will be notified through
+	HYPERVISOR_CALLBACK_VECTOR IRQ. Fields have the following meanings:
+
+	suspend_time_ns:
+		Total number of nanoseconds passed during the host's suspend
+		while the VM is running. This value will be increasing
+		monotonically and cumulative.
+
+	Note that although MSRs are per-CPU entities, the effect of this
+	particular MSR is global.
+
+	Availability of this MSR must be checked via bit 18 in 0x4000001 cpuid
+	leaf prior to usage.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 5146bbab84d4..ccea4e344f46 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -35,6 +35,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_HOST_SUSPEND_TIME	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -57,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_HOST_SUSPEND_TIME      0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -79,6 +81,10 @@ struct kvm_clock_pairing {
 	__u32 pad[9];
 };
 
+struct kvm_suspend_time {
+	__u64   suspend_time_ns;
+};
+
 #define KVM_STEAL_ALIGNMENT_BITS 5
 #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
 #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
