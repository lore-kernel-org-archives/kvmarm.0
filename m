Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24314C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:49:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C24D04B9C2;
	Wed,  2 Nov 2022 12:49:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bDkg56DDiy5R; Wed,  2 Nov 2022 12:49:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BA44B9B9;
	Wed,  2 Nov 2022 12:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B904B93C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IaZAfh53ICbo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:14:23 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC95B4B95A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:22 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id o4so25285509wrq.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+NFek8SyKiRWYHjHtbk8OGDRsRGEQRPyliekwb3dBs0=;
 b=zIsbXVctd4Gs9c7zONlY6rBBf/u6dRKfDfpOTlkuiEJUgjUQsLTcUBjmRcFVgUNhED
 kLVrbBPVPhQqG1rWStlgoZ3P1N8r0vgZEOlA0utl508kEa8Jyu7Ipo6udgGqaIvoefN2
 XOX9/d/ZPUnrkJsHVr5uWb+hdlJQKY/d4h04avN6Tnovxs6hveRIGNYCUrG7nom6ggIN
 B5DEWY3YjASVmfcbF0HOzeminCPZDlOuH4hAne+oyAHV+tSThVa2Pd6MBD0JbLouHCAV
 FCMDfOpikrGP5maiE1Rp2VibFVwLUMVTOdSazEzjMLT/8CLKwtd2Ju1lMTe/DKUzkZIn
 zY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=+NFek8SyKiRWYHjHtbk8OGDRsRGEQRPyliekwb3dBs0=;
 b=DBLY/FVPuwSXJwN5u2hEft+CuYFq9xbIgeHp9kLwqF68JC/IQZdufHuToh0Tq/ufql
 a91+EYoAknTx5xg5pBB8Igp2t0BVv2asQlUyk78G9WlMemN/ShfTWLcAF4bMqJyzOyiX
 R1jmnKm6K/8oWE8EXTH3vdouXdOtCGNN34CZDJymNAlIbF53sxD29DqIhEG3AM0XKIu7
 9Da0vzXym4oYOjEDS9w3QYVSlvicGMnBONiG25y1f8GjBCn1x26TVxxsIfoyp0u9yOYy
 dDHaWMtYMvGMP63LeWVlwfRnjI4mWNDQUTHI6sEZ1RKq0shA/SybRvpIXKo1Du0BAd6l
 +AWw==
X-Gm-Message-State: ACrzQf0g4X+Arf4KCMWTVmPqg4mRpPvsV/Y1W0ZrZsgVI1TDSR4MEq6I
 ZMKwhakvRNkNuKCDCbE2vIsgyjgYRnK+Yj2U
X-Google-Smtp-Source: AMsMyM51Qs+O1i/M47G0qYh912V6X3Y+YiiLnHgO12+XmQMuhVZp55+mkvcjl/4bj2IYOqmiXVBi8A==
X-Received: by 2002:a05:6000:1a46:b0:236:9cb4:f2a7 with SMTP id
 t6-20020a0560001a4600b002369cb4f2a7mr15637873wry.141.1667405661935; 
 Wed, 02 Nov 2022 09:14:21 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
 by smtp.gmail.com with ESMTPSA id
 m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:14:21 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Subject: [RFC 4/6] KVM: arm64: Provide VCPU attributes for PV lock
Date: Wed,  2 Nov 2022 16:13:38 +0000
Message-Id: <20221102161340.2982090-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102161340.2982090-1-usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 02 Nov 2022 12:49:29 -0400
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

Allow user space to inform the KVM host where in the physical memory
map the paravirtualized lock structures should be located.

User space can set an attribute on the VCPU providing the IPA base
address of the PV lock structure for that VCPU. This must be
repeated for every VCPU in the VM.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 ++++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/guest.c            |  9 +++++
 arch/arm64/kvm/pvlock.c           | 57 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 77 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 18303b30b7e9..86aeca8a4393 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -829,6 +829,13 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
 extern unsigned int kvm_arm_vmid_bits;
 int kvm_arm_vmid_alloc_init(void);
 void kvm_arm_vmid_alloc_free(void);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index bd05ece5c590..71010bacaaab 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -412,6 +412,8 @@ enum {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_PVLOCK_CTRL	3
+#define   KVM_ARM_VCPU_PVLOCK_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2ff13a3f8479..7e765e3256ef 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -959,6 +959,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -982,6 +985,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1005,6 +1011,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/arch/arm64/kvm/pvlock.c b/arch/arm64/kvm/pvlock.c
index 3eb35ab31481..b08a287a4811 100644
--- a/arch/arm64/kvm/pvlock.c
+++ b/arch/arm64/kvm/pvlock.c
@@ -41,3 +41,60 @@ void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
 	kvm_put_guest(kvm, base + offset, cpu_to_le64(preempted));
 	srcu_read_unlock(&kvm->srcu, idx);
 }
+
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	u64 ipa;
+	int ret = 0;
+	int idx;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	if (get_user(ipa, user))
+		return -EFAULT;
+	if (!IS_ALIGNED(ipa, 64))
+		return -EINVAL;
+	if (vcpu->arch.pv.base != GPA_INVALID)
+		return -EEXIST;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.pv.base = ipa;
+
+	return ret;
+}
+
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	ipa = vcpu->arch.pv.base;
+
+	if (put_user(ipa, user))
+		return -EFAULT;
+	return 0;
+}
+
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PVLOCK_IPA:
+		return 0;
+	}
+	return -ENXIO;
+}
\ No newline at end of file
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..1fe3cce5c84a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1429,6 +1429,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_ARM_PV_LOCK,
+#define KVM_DEV_TYPE_ARM_PV_LOCK	KVM_DEV_TYPE_ARM_PV_LOCK
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
