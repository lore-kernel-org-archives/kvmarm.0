Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F96C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9140C6139F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9140C6139F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303204B101;
	Sun, 15 Aug 2021 20:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b4wMpCk-S+It; Sun, 15 Aug 2021 20:11:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C82A4B0FA;
	Sun, 15 Aug 2021 20:11:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0167D4B0D8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XA4NtGc1SJob for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:11:36 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D30954B0CD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:36 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 i15-20020a92540f0000b0290222feb23cf5so8766845ilb.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JjAheCeU8OLcl85r3fMj4Tdvexc0vXT5B0Nj3krTsUc=;
 b=d6cpi6xW3Siu7V3Ocspqj9m35qtPwhy9VjX9IpuhYvzlBO9bm8dw1P5J7VBwrG/v2d
 Fupr4JhmaYS9+w6umx9EqHBP3LfnMtK1Kr/jxVbEcNDyy8oQGQ3no2t92dY3FKEEIXEa
 CfCckQags7sN+kVlG5Hdj57ck9GltxZaJKxUBfcwB427IahQVbWxenKXA58a5qIeC3DG
 8MrhNb0gHlaZT3vFri2g7jpaq5huj5XKJlGzrhzAtTdOSINjh7hF5DnQT/nJ3MjbGZNe
 c04JMAGppd3t5hTbFCi+s+kwGbL+qIHiUT7IsFop3H7TGFWcKRZxC8p8YgqscoZog1mz
 mhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JjAheCeU8OLcl85r3fMj4Tdvexc0vXT5B0Nj3krTsUc=;
 b=VSF9GVgBKyxMWSZnT1dql2xK/N/TR8E7s65uvA8H/IzZaT1zIPjVwHEMi9xl5hqEM4
 G/PTDUBzfYRY92oz6UAvcsmH8nPf0BsEG3ANru2SRsX/kL53PswHk7ykVa/xOgUW5/tn
 Sk2QFJ271+aRC7Vcq2qX/eQsb1snoHkTlA4gL7AcBxWKGKd8h6n2CH19XE1TjPhN8LCt
 CRc26cq7NAVnXErjfMqIYnjBRYjlm8Rq60f9TNCxc0fAzyjjKs2RVrEvs8wQrrkDFGRf
 ewGswIZK0vcp5zGn4JrVDx6EbQ84i1UI/g141tfeA0JKzCmYGl2SMZSAvvz5trizYrXf
 Nwtg==
X-Gm-Message-State: AOAM530x46k8nWSQjvOrrBLtGA7wrLoUfEOOYY3FQKMoKhlet3pX8Ex0
 CSSi/gMKOYwCOYaMXCub9oz0y4CgHHY=
X-Google-Smtp-Source: ABdhPJzql/ws9nv1W9hhmm8kA+C+wyM8/Yyi52JOtJkxfAmPdz1NtGSbK43RlGb0QaSB6Cb2d7x8Jf49cT8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cca8:: with SMTP id
 t8mr13047843jap.51.1629072696400; 
 Sun, 15 Aug 2021 17:11:36 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:11:26 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-3-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 2/6] KVM: x86: Create helper methods for
 KVM_{GET,SET}_CLOCK ioctls
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Wrap the existing implementation of the KVM_{GET,SET}_CLOCK ioctls in
helper methods.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 107 ++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f3929bd5f58..39eaa2fb2001 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5833,12 +5833,65 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_clock_data data;
+
+	/*
+	 * Zero flags as it is accessed RMW, leave everything else
+	 * uninitialized as clock is always written and no other fields
+	 * are consumed.
+	 */
+	data.flags = 0;
+	get_kvmclock(kvm, &data);
+	memset(&data.pad, 0, sizeof(data.pad));
+
+	if (copy_to_user(argp, &data, sizeof(data)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_clock_data data;
+	u64 now_ns;
+
+	if (copy_from_user(&data, argp, sizeof(data)))
+		return -EFAULT;
+
+	if (data.flags)
+		return -EINVAL;
+
+	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+
+	/*
+	 * This pairs with kvm_guest_time_update(): when masterclock is
+	 * in use, we use master_kernel_ns + kvmclock_offset to set
+	 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
+	 * is slightly ahead) here we risk going negative on unsigned
+	 * 'system_time' when 'data.clock' is very small.
+	 */
+	if (kvm->arch.use_master_clock)
+		now_ns = ka->master_kernel_ns;
+	else
+		now_ns = get_kvmclock_base_ns();
+	ka->kvmclock_offset = data.clock - now_ns;
+	kvm_end_pvclock_update(kvm);
+
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -ENOTTY;
+
 	/*
 	 * This union makes it completely explicit to gcc-3.x
 	 * that these two variables' stack usage should be
@@ -6076,58 +6129,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
-	case KVM_SET_CLOCK: {
-		struct kvm_arch *ka = &kvm->arch;
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		r = -EFAULT;
-		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
-			goto out;
-
-		r = -EINVAL;
-		if (user_ns.flags)
-			goto out;
-
-		r = 0;
-
-		kvm_hv_invalidate_tsc_page(kvm);
-		kvm_start_pvclock_update(kvm);
-		pvclock_update_vm_gtod_copy(kvm);
-
-		/*
-		 * This pairs with kvm_guest_time_update(): when masterclock is
-		 * in use, we use master_kernel_ns + kvmclock_offset to set
-		 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
-		 * is slightly ahead) here we risk going negative on unsigned
-		 * 'system_time' when 'user_ns.clock' is very small.
-		 */
-		if (kvm->arch.use_master_clock)
-			now_ns = ka->master_kernel_ns;
-		else
-			now_ns = get_kvmclock_base_ns();
-		ka->kvmclock_offset = user_ns.clock - now_ns;
-		kvm_end_pvclock_update(kvm);
+	case KVM_SET_CLOCK:
+		r = kvm_vm_ioctl_set_clock(kvm, argp);
 		break;
-	}
-	case KVM_GET_CLOCK: {
-		struct kvm_clock_data user_ns;
-
-		/*
-		 * Zero flags as it is accessed RMW, leave everything else
-		 * uninitialized as clock is always written and no other fields
-		 * are consumed.
-		 */
-		user_ns.flags = 0;
-		get_kvmclock(kvm, &user_ns);
-		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
-
-		r = -EFAULT;
-		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-			goto out;
-		r = 0;
+	case KVM_GET_CLOCK:
+		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
-	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
