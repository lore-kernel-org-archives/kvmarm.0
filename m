Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F76C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E24CE49F0B;
	Fri, 11 Mar 2022 12:57:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SQ-5NAJgrW87; Fri, 11 Mar 2022 12:57:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3EB149EEE;
	Fri, 11 Mar 2022 12:57:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D61849ECF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68E5MYIpP1Fu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:40 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12E2649EBD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:40 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 z10-20020a056602080a00b00645b9fdc630so6785335iow.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BGsr6pN9enYniNk4zGr+nWX2xORuU1JL7wS+cLweFVM=;
 b=G8cB3TIlGOvwQlgqnb6Mv3A6ZDlk82Jx93jjWrLxun3vDuSleV+2ZENfuUS1eSZq+K
 IgQ+GM9Xo82V8Mun7Lw//GhahVM4rZ371b9ilQF12s4J9ZiMeW81c7rONn3ZnADLdkRR
 u2WDOuwVoayXZQ+3DSiHPrNnfLhLIsa/IdvllbJZZ7pvFOzW7aSZNQ8W7lifUWwLCuf2
 DzxMLwqWeIeg6ntp2KnMOFHYpbHF7VkUH7zkgVfTqKkbCvbnG93z8jQ35Nzt65Ow3VLB
 yQHFcdwj2Grigd5frLaWlCQhcWFuBSzZAr/5LUkcx2FguOxyMPYLNFA5zfXBNAuS2oIg
 Zn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BGsr6pN9enYniNk4zGr+nWX2xORuU1JL7wS+cLweFVM=;
 b=Uyi92HGHsoizmdLOX0kE61/dMGbeMXThnC7fYW3nvTphreYYTK0Ho0xBvGl1DZDwjl
 /4PU3Ne/oBqugysBHFV3Dv0N2+eEmkG3nYZEcaG3nTdeF6eSf1W7xtWVJn79XARNJoHl
 asMqptMay+UwFtyDATWOruB3x/4k+a0558bkTMOYX3VmSBYwtzLzxGgL/hC7wA+rjwC6
 ij+REmqM4nUmVomQVTyqHfrZSPZAeYoKwwarDcrMDUHPGePw1+Jr5thH/Vew1Sn6Wbov
 7CUGdn0U2ki15/gJfOdWx1/f8i95dh6+/qbfjHkfjhtbnifIihbqeNL+jrMv9jLcxOIw
 RSdg==
X-Gm-Message-State: AOAM53005DW8H12vLOtlB0vyLnXuILpp/4hjPS36hP559x5ZjPcMBfok
 VuC0g5ve3pAvvIfQa+lBMQunrQZym+4bjpBkwzS0SaYelvjY2vONEq8TGB130F8gGWob1nGsFyt
 VYV5l4uol5xg5/uXATJhdnu792bmsYXv3Rj8nZ0hNW/8dbFGJkhfF9km0kYoxFCXjIirt5A==
X-Google-Smtp-Source: ABdhPJzy7TljJ49dSoKSsh7qQwadwo8KUyffYqNTXf0RMjBpnuNAtwt/ATgmZWQS3claaoNqk/pp2mmirz8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:15c5:b0:646:4d0f:7728
 with SMTP id
 f5-20020a05660215c500b006464d0f7728mr8810250iow.63.1647021458831; Fri, 11 Mar
 2022 09:57:38 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:13 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-2-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 1/5] TESTONLY: Sync KVM headers with pending
 changes
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-arm-kernel@lists.infradead.org
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

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/kvm.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1daa452..e5bb5f1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -444,6 +444,8 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -634,6 +636,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -1131,6 +1134,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_VM_GPA_BITS 207
+#define KVM_CAP_XSAVE2 208
+#define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1162,11 +1169,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
 
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1178,6 +1194,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
@@ -1208,6 +1225,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -2031,4 +2049,7 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 #endif /* __LINUX_KVM_H */
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
