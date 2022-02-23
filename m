Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DD3C43217
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2E94C2F8;
	Tue, 22 Feb 2022 23:19:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xV4FEPf0PZKe; Tue, 22 Feb 2022 23:19:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D764C3F5;
	Tue, 22 Feb 2022 23:19:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 056034C3DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xE5EThf0WXqQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:22 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D31B4C369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:22 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 r16-20020a92ac10000000b002c1ec9fa8edso7301771ilh.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FNS4PyjEGxuJSaCVEOu72QQrSSYAZtKW2QUnGIVfau0=;
 b=e49Ue+JZMKJTF4FKVvs05LKdC7XnGotaG6I7g92j1SjIIS1FDLH1cN/N1EgS1P5ER+
 gah/IkXs0/E7eMhyaJG1u5bystIS2zgyEXKjvahD5csHmw6iNiaPVCNsuCKAujpio2x4
 x5h2Y66ca5V8RAvVKUdeUFdil43Yb/urcWb4FnhtRnCXPgeJLE2YgySa6eQJxpuDJeub
 LVjCsoTUqgB8NNAVskSi+oM+Jb0ENgqa5jZI21tOSFGXaYCGAhkduH5IHnjn+25Jhx+1
 zK5j2ka7vSR2+bvhw5Z9Ql0PqR2fqoidoh4i9qnIHMVtxgpRkiuQ5XWuf3uMkjt8aeqD
 XYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FNS4PyjEGxuJSaCVEOu72QQrSSYAZtKW2QUnGIVfau0=;
 b=7USzap9EuFqsdzogRBiexf6IqCynOziG9aGoNdf80nZ1GvxluiO4dWxXdYBeYAMP7C
 inNspWPT7y/+1NMqXmvVeFeceoznxbAN+smnszgIwt67l+XUAxHaTRZCP51jo+AUAlGm
 tm4R4nSfwNJEeQ1VdvfP0SIaDyntAQXDkKfTviEUMJZrEcv387T/ZQkGUOWXtI5GgVgZ
 uDZs7jFGBOCRJ9fEGQT6K2idBxZeh5l1zormtVxoct5yIsgA+NFK5S5nPN9/f4TYoPZ+
 nWWt3C9t4mX/p1U6VJS+/3rOtmJsptzrd6+sca3nXQQCIAWaeIXCAY9s0MfO9alamfG2
 FX7Q==
X-Gm-Message-State: AOAM530xb6BHbZTq2q0D7mr8tB5gY9pcUpSFMzbiTdEW41H7oNeiTdFe
 CbPcXnkjJcvXj5oQKD9UvKZRSsuzHNWDaSXK0TJ6NzZjGuWQt79mDgAu2EB1xbhFcOopmIwPgqf
 MlkDC5mjSUhrBiivHEjYa7qG5N1a3lN8fs55MmA8m78oxjZFBvLjjN4w47+1Nxp6zCXy9sQ==
X-Google-Smtp-Source: ABdhPJzk4sIaIqCtMwTE2XY7UxiYHAN+OIvodZsnh0NYxLMGJieovAoGPOgba0C6vnJ4V/BJcawGQCT4v2w=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:26d3:b0:63d:aa17:8742
 with SMTP id
 g19-20020a05660226d300b0063daa178742mr21631674ioo.198.1645589961514; Tue, 22
 Feb 2022 20:19:21 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:34 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-10-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 09/19] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
software to request that a system be placed in the deepest possible
low-power state. Effectively, software can use this to suspend itself to
RAM. Note that the semantics of this PSCI call are very similar to
CPU_SUSPEND, which is already implemented in KVM.

Implement the SYSTEM_SUSPEND in KVM. Similar to CPU_SUSPEND, the
low-power state is implemented as a guest WFI. Synchronously reset the
calling CPU before entering the WFI, such that the vCPU may immediately
resume execution when a wakeup event is recognized.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c  | 51 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c |  3 ++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 77a00913cdfd..41adaaf2234a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,6 +208,50 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
 }
 
+static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_reset_state reset_state;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu *tmp;
+	bool denied = false;
+	unsigned long i;
+
+	reset_state.pc = smccc_get_arg1(vcpu);
+	if (!kvm_ipa_valid(kvm, reset_state.pc)) {
+		smccc_set_retval(vcpu, PSCI_RET_INVALID_ADDRESS, 0, 0, 0);
+		return 1;
+	}
+
+	reset_state.r0 = smccc_get_arg2(vcpu);
+	reset_state.be = kvm_vcpu_is_be(vcpu);
+	reset_state.reset = true;
+
+	/*
+	 * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
+	 * calling vCPU) be in an OFF state, as determined by the
+	 * implementation.
+	 *
+	 * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
+	 */
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, tmp, kvm) {
+		if (tmp != vcpu && !kvm_arm_vcpu_powered_off(tmp)) {
+			denied = true;
+			break;
+		}
+	}
+	mutex_unlock(&kvm->lock);
+
+	if (denied) {
+		smccc_set_retval(vcpu, PSCI_RET_DENIED, 0, 0, 0);
+		return 1;
+	}
+
+	__kvm_reset_vcpu(vcpu, &reset_state);
+	kvm_vcpu_wfi(vcpu);
+	return 1;
+}
+
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -343,6 +387,8 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
 		case PSCI_1_0_FN_PSCI_FEATURES:
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
@@ -352,6 +398,11 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 			break;
 		}
 		break;
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		return kvm_psci_system_suspend(vcpu);
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f879a8f6a99c..006e7a75ceba 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -215,7 +215,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  *
  * Note: This function can be called from two paths:
  *  - The KVM_ARM_VCPU_INIT ioctl
- *  - handling a request issued by another VCPU in the PSCI handling code
+ *  - handling a request issued by possibly another VCPU in the PSCI handling
+ *    code
  *
  * In the first case, the VCPU will not be loaded, and in the second case the
  * VCPU will be loaded.  Because this function operates purely on the
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
