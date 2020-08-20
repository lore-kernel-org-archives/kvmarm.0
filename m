Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D13AC433E4
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B42AB20639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dnVyOT5y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B42AB20639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67AFE4B86C;
	Thu, 20 Aug 2020 06:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GQ4ad6-em-6y; Thu, 20 Aug 2020 06:35:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4390B4B88F;
	Thu, 20 Aug 2020 06:35:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D9A4B83E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lAx12jj1zDnd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:38 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 272D44B888
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:38 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id d9so1012572qvl.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=BmbAKV/m7ypqUR0lW+5iQoAhiw2axY9TAu1aTPaDE28=;
 b=dnVyOT5yZ/CbAgWsodXttzOq3jwrI+1rpZm8LfTGlXqGQU4VYJ6C6Lch+WjQBjhAFq
 h6t5WD0QDGyWnVLu5vdxGS4swfEgpusX+On71Wl6l549i6kT0Iu+KmrvVElWM3oc2OqJ
 KN5ccer+ntMN27vddRgGpBXwUZwMy7UeVoFBf+cVCreb74ZoHl9WURk6wL88rQsH1pc9
 dAvU2biHq6iGz0dtUYi9PDZQbSH61EWkGqQJFyiXQE53fxeNStNor7kcQ6J499KitvmB
 A5nD9CcemrqUscqv/cFq35t7/TtgOmLwlYkqfJZ7ztEQg6McPMJ8IEmu8TpTlDv2r/FO
 hexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BmbAKV/m7ypqUR0lW+5iQoAhiw2axY9TAu1aTPaDE28=;
 b=DSmb9l5zT+zaHieBALpJi/qCWbA6D5dx07ubQVIlSYAodWz69v9tVLAhndYi7EKjy4
 +PKqSFm4/GVUsmYjC6FlXp4yL/XKhPlEyFsU9Ra5LJCrzq9oXvQURqc2xQbCVpeIDxzv
 EPdRqaLp3cPA8F0eEj1gGUVjIKCyvrQxDTyhw0+XeJf1J6K/NtBNYgpLV1toe+HG9wOp
 Wtl07Er21y70+rYviZv4o2t+rJpCUT/DmXSs6YHIhWewnGrgoehBKksaxfTTFORMmnRO
 64tK+8DsE0jFcLbj2tlPi2ZgToi3lg/pt2OPXdJlHRcsIhdi2Llcog7yh1SM35tXS//K
 VGJg==
X-Gm-Message-State: AOAM533rxezuqObqgrmDZTWbTQsxeVKIImIewvO3IFiWptZCgFysgSlg
 T8q3vKGD7dGlmd8jl3ymsdDaGfE8st/WBzgvRy2uewj32+ejFoYiFZq8hGHsD5u+h8vGaV6r85X
 6eN2sSC7cQBvUI+HPsee64umZWP6L8j6tu+ShoOwTzX+vVkuoPbJ+dkAL7scvtEm3qe7PCA==
X-Google-Smtp-Source: ABdhPJxS8aMsiew65YygRuhFkrEdWeDneRoOb3pQVcpupjRzP3AM3yLOnGQyhHExIhvvZqrepsO7702zqfM=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:8d4a:: with SMTP id
 s10mr2337167qvb.34.1597919737610; 
 Thu, 20 Aug 2020 03:35:37 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:34 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-9-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 08/20] KVM: arm64: Preserve host DISR_EL1
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

With the RAS extension available, guest exits can overwrite DISR_EL1
after checking for any guest SErrors. If the host was using DISR_EL1 to
track a deferred SError, it would be lost so save and restore DISR_EL1
for the host.

Cc: James Morse <james.morse@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>

---
This may not be necessary if it is a safe assumption that the host
doesn't mind that DISR_EL1 is clobbered across the kvm_vcpu_run call.
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7a986030145f..a549f8698bd4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -56,8 +56,12 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
 	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		if (ctxt->__hyp_running_vcpu)
+			ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_DISR_EL1);
+		else
+			ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
+	}
 }
 
 static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -152,8 +156,12 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		if (ctxt->__hyp_running_vcpu)
+			write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_DISR_EL1);
+		else
+			write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
+	}
 }
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
