Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FAFC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 14:03:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60B7E60EFE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 14:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60B7E60EFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59E34B28B;
	Mon, 18 Oct 2021 10:03:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ex8UQOgfKoeZ; Mon, 18 Oct 2021 10:03:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8DB4B277;
	Mon, 18 Oct 2021 10:03:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 984424B277
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 10:03:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIlQhcj18VKP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 10:03:09 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 656A64B25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 10:03:09 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id
 n7-20020a05600c4f8700b00323023159e1so1661426wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ilVE4xJNEWJqyraR6L3VDA//LfSc9977wvuETuVPB8A=;
 b=iJIXL5k7UKvSaiTpCZ/NRbW8UXBAsbUL5bOR63EhPqb2ttLq0MzQ+FfWR28Ughkcbs
 7oxUvk5dyNKyRQ9FcyE+4POjljVn8AUTg0UxQ/joj1V2cjBe6Mb/J+3yp9DUeTOChEzF
 hCbP6MccBTheeW2X1EAx4b6raO1wC/cuiHTbGljgxKMNmXFiLAeD0yLXrzZ+XBD5/Ssz
 9Dg0rxygs5gZ7Hr/mxbdvF1cw40+Mdx6SSDe5DsAEeUGW+2gJ0hE6ZWPxLFMwf/XaGZJ
 6dX+v1hEfS5yqCz0z84JwbkyGe05YN4VVNU5P88OPbnwPQx308pK5syC8OBhnhe9bTQy
 o9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ilVE4xJNEWJqyraR6L3VDA//LfSc9977wvuETuVPB8A=;
 b=5wlh2DGOW15gG20KlpnLUr8/AstonAZHZ4waXM277ks5ULNGYdLJvg0B/1abmoGjQQ
 3ukoW6zc/8AJmZL7Tm7oZ1ufO4D5K4htdoUBL6B01iSp4HWwEJeU7/gtVfAghRn7c0xl
 2+FjFeCy1fFTW8GMacOr+QF09xXi22shmbg7eg8ngvF1H2Cmi97eO0OzVkGQmC0qJ6ZX
 jfLJnQ+CGH+huwwCUC5ddR8j0EjjNJkuJ55c8MpQvb0lTN3FDpi86tB8ibaE7KyVEB8L
 TsFjoy20NUVO2ns8k2Gp5x1jN/xZ88MHkOFsbJ8HiTs0EoIasQ4d1NdGHyu/LYMHgfbp
 9jOg==
X-Gm-Message-State: AOAM5329tr3KmUvTDyl+oY8RFbUnqyOBcKQg1Ad1E0vR6P2PuppH+LFu
 2Sif+CawRild4/AIFX2STHMFjw==
X-Google-Smtp-Source: ABdhPJxJWiLYpJjB5ZQ0+cjl9xUBd/Al0nfVV9kESWuAisjQ7GXwYpBkwbby+DsCbh6H7gcw1jJXcg==
X-Received: by 2002:a05:600c:1c1b:: with SMTP id
 j27mr29455483wms.1.1634565788135; 
 Mon, 18 Oct 2021 07:03:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ba81:6f1b:ab2e:f120])
 by smtp.gmail.com with ESMTPSA id n9sm3982324wmq.6.2021.10.18.07.03.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Oct 2021 07:03:07 -0700 (PDT)
Date: Mon, 18 Oct 2021 15:03:05 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 16/16] KVM: arm64: pkvm: Unshare guest structs during
 teardown
Message-ID: <YW1+mQ6Bn2HXwl34@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-17-qperret@google.com>
 <87h7dhupfa.wl-maz@kernel.org> <YW1NLb9Pn9NyEYZF@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YW1NLb9Pn9NyEYZF@google.com>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Monday 18 Oct 2021 at 11:32:13 (+0100), Quentin Perret wrote:
> Another option is to take a refcount on 'current' from
> kvm_arch_vcpu_run_map_fp() before sharing thread-specific structs with
> the hyp and release the refcount of the previous task after unsharing.
> But that means we'll have to also drop the refcount when the vcpu
> gets destroyed, as well as explicitly unshare at that point. Shouldn't
> be too bad I think. Thoughts?

Something like the below seems to work OK on my setup, including
SIGKILL'ing the guest and such. How much do you hate it?

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..50598d704c71 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -322,6 +322,7 @@ struct kvm_vcpu_arch {
 
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
+	struct task_struct *parent_task;
 
 	struct {
 		/* {Break,watch}point registers */
@@ -738,6 +739,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
+void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2fe1128d9f3d..27afeebbe1cb 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -15,6 +15,22 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
+void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
+{
+	struct task_struct *p = vcpu->arch.parent_task;
+	struct user_fpsimd_state *fpsimd;
+	struct thread_info *ti;
+
+	if (!static_branch_likely(&kvm_protected_mode_initialized) || !p)
+		return;
+
+	ti = &p->thread_info;
+	kvm_unshare_hyp(ti, ti + 1);
+	fpsimd = &p->thread.uw.fpsimd_state;
+	kvm_unshare_hyp(fpsimd, fpsimd + 1);
+	put_task_struct(p);
+}
+
 /*
  * Called on entry to KVM_RUN unless this vcpu previously ran at least
  * once and the most recent prior KVM_RUN for this vcpu was called from
@@ -31,6 +47,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
+	kvm_vcpu_unshare_task_fp(vcpu);
+
 	/*
 	 * Make sure the host task thread flags and fpsimd state are
 	 * visible to hyp:
@@ -45,6 +63,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
+
+	/*
+	 * We need to keep current's task_struct pinned until its data has been
+	 * unshared with the hypervisor to make sure it is not re-used by the
+	 * kernel and donated to someone else while already shared -- see
+	 * kvm_vcpu_unshare_task_fp() for the matching put_task_struct().
+	 */
+	if (static_branch_likely(&kvm_protected_mode_initialized)) {
+		get_task_struct(current);
+		vcpu->arch.parent_task = current;
+	}
 error:
 	return ret;
 }
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..c2a2cd7d5748 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -141,7 +141,13 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->arch.sve_state);
+	void *sve_state = vcpu->arch.sve_state;
+
+	kvm_vcpu_unshare_task_fp(vcpu);
+	kvm_unshare_hyp(vcpu, vcpu + 1);
+	if (sve_state && vcpu->arch.has_run_once)
+		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+	kfree(sve_state);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
