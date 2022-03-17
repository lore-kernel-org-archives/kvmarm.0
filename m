Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BC4C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 00:56:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE6649E08;
	Wed, 16 Mar 2022 20:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yr3jZxyq8gTu; Wed, 16 Mar 2022 20:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41C1049F0F;
	Wed, 16 Mar 2022 20:56:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1EE49F0F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FpYDb9l+d5-v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 20:56:43 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB22B49F1C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:42 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 n17-20020a170902f61100b001538c882549so1938349plg.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 17:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Jg9GQhk+MrZN5dXhW+X4cf0jKpd+avRpNX7anKj5Jrc=;
 b=m89l2hQAmUEdjNqV8OSCTfysZ/zOOwEFynaTXmVlR6Yzoo1Tx/dZoxyW6lOexx8+fq
 QUzXN6cI+cdNXN/EtWPD+f16r6B89XHPNUsNz4fxE70ESglpMWEl6bUWyJCBhYEsbYQb
 zxe9PXL1GLkt1QJJ4VG3Ie8JbNi3IGFnlkc9yRNI//242WCP8SA6wjBDbrK8gWrpduTZ
 OgvfmcZOxe567V08fuXZiraQk4SlFSiORjD6r1LqMp6mzhggpxoeD7hT2Yyyvo9M0k6l
 sMc8dnS9btYLpIWRh7ECmbtm7cyooPtA7nCYio+MoLGW2LDuWd26q4maprX8HLyqA1fe
 Ne/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Jg9GQhk+MrZN5dXhW+X4cf0jKpd+avRpNX7anKj5Jrc=;
 b=oDC+NLGQ8B6oAxL9kQfHc1JLIHofWcxoT8mmaZ9A9IJR0FcQjWgdsXIWETgOvTFIdJ
 MP9wFP49dvcPb0/oMUVnYXugfp2XohOccZLeyYDaOyB6z8bB7TcgwZe/RpDGSIjFF+Vv
 U/JAC6SAMHPw6m5vgN7ru06dtP8v2xXWTUQc6cv3pj8CDsyqAHIyvf/WSdtHuabu6IDL
 NFZI9AIV0OhUz6WPC8rBawt76EArJB5Bp3+s/eQwSBuPSNQRYwPySa+II6m/ezEU7gWe
 52DmN1WEe39d1n5LuZWYQ6dzvntl9wLtdMUEXBQqVtp+MFh4jZL68eaB15ho25ny6SJK
 P8Ug==
X-Gm-Message-State: AOAM532VU49/A6TajX/k1XG4yugvCZokbYeImsytu9Z/1OD/18BcagJF
 u5VL50pQzvO5Oh+CfG1v5aojfRGDhp+LABrePQ==
X-Google-Smtp-Source: ABdhPJwHRN519VOfnvRnJr+eDRdY4WPxlBAdx8ibhHEmrVvzFG7w2BsmEup87mQKjxpdevwHPl3T4yZQyEjnfWSjTw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:903:124a:b0:153:47d7:de49 with
 SMTP id u10-20020a170903124a00b0015347d7de49mr2556590plh.81.1647478602084;
 Wed, 16 Mar 2022 17:56:42 -0700 (PDT)
Date: Thu, 17 Mar 2022 00:56:30 +0000
In-Reply-To: <20220317005630.3666572-1-jingzhangos@google.com>
Message-Id: <20220317005630.3666572-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Sean Christopherson <seanjc@google.com>, 
 Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, 
 Ricardo Koller <ricarkol@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
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

This tracepoint only provides a hook for poking vcpu exits information,
not exported to tracefs.
A timestamp is added for the last vcpu exit, which would be useful for
analysis for vcpu exits.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/trace_arm.h        | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index daa68b053bdc..576f2c18d008 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
 
 	/* Arch specific exit reason */
 	enum arm_exit_reason exit_reason;
+
+	/* Timestamp for the last vcpu exit */
+	u64 last_exit_time;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f49ebdd9c990..98631f79c182 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		trace_kvm_vcpu_exits(vcpu);
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		local_irq_enable();
 
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..3e7dfd640e23 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
 		  __entry->timer_idx, __entry->should_fire)
 );
 
+/*
+ * Following tracepoints are not exported in tracefs and provide hooking
+ * mechanisms only for testing and debugging purposes.
+ */
+DECLARE_TRACE(kvm_vcpu_exits,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu));
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
