Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B996C48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B6E5611AE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B6E5611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3772C49E5F;
	Wed,  9 Jun 2021 06:21:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EpHGtCe2NDL4; Wed,  9 Jun 2021 06:21:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E9F4A173;
	Wed,  9 Jun 2021 06:21:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A4140291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9KyfY18Jv-dS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:47:58 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AC254057F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:47:58 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 c11-20020a928e0b0000b02901e829148382so9418234ild.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4A17gJzJ1kAenjV8HCdX+pKLR+NA8dR0yX/rB5Wyus4=;
 b=sZ03P3gmdWaLshxczUdD9Od3bFJUln8rI4ImTn8BDyJzHtddp3THf5COkhfLMdj55E
 n9sjgUCKQgP4l6XRXdCHfCyOxu9hvHY16sqhT5/R6MnHcwV+HuxNq1NlyJj3uadUFc4n
 H7r4IxlGZHiAuvHOQ1gg1tFGgdhyKWQakRbEG+U2ckcGSCRIM5nYO7UbFtMxfpZwvKAE
 +fjddPP9+5BdMz7lTndnpx7znrI/Msz/7n33UV3eAkPwFaiEb5kqY7CxJfGm7Mkw6Xqm
 aKbHQ34Eby8DGH6OlizugwpfJIrMiZjv4GfocR3ndPv29968ap/g4kMYOR2TTuB1RcY2
 SR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4A17gJzJ1kAenjV8HCdX+pKLR+NA8dR0yX/rB5Wyus4=;
 b=Wtas7vzZICPwdcdRGyQDvd3We3YtwUc0vcJK5jvyZKNkWRaxGYxM1Nc6523srnmF10
 5Zbt4ksuTwUptkZYPcEWmf8OqvFtCsPuacSqqSJW+aBiFMzhShr8ccjT7Q+MTeCHpO+4
 zLs0p3rZsWTGMldtS+2sNKLVbOatfxV/A6+BhhGX308+GWrXPHgxxudUCs3xxELBIKd1
 wEgVKBVWbmQugatKD54j6dxFFG62EPbSZ94elNLLlGITjno9vbxF7Zm6nXMUbeP/gfy5
 Ke1pEBBgXE4sx45sD9r5FxfIQP+SgJLWqO07nM5uNEUqlXKmGcZRiWEYJiRQQv1K4XzW
 XnEQ==
X-Gm-Message-State: AOAM530zSqeXbTFag6Dlz0dKKb30KgOXWt03oN7fWRwqDDOvToI4/FMt
 ZBW3Q/h5gEGSpP1Eq4hoHKcEmfQi29w=
X-Google-Smtp-Source: ABdhPJxnS6SA33thGYVUqbqETQx/fbnXtTuCiMbrOX/ip3kv7XfbzDxbKzCuHLNRXwCPmcgEWAfR4WhvG1c=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:9842:: with SMTP id
 p2mr20519082ios.132.1623188877580; 
 Tue, 08 Jun 2021 14:47:57 -0700 (PDT)
Date: Tue,  8 Jun 2021 21:47:33 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-2-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 01/10] KVM: Introduce KVM_{GET,
 SET}_SYSTEM_COUNTER_STATE ioctls
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 09 Jun 2021 06:21:47 -0400
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

Correctly migrating a guest's view of the system counter is challenging.
To date, KVM has utilized value-based interfaces (e.g. guest value for
IA32_TSC msr on x86, CNTVCT_EL0 on arm64) for migrating guest counter
state. Restoring counters by value is problematic, especially for
operators who intend to have the guest's counters account for elapsed
time during live migration. Reason being, the guest counters _still_
increment even after calculating an appropriate value to restore a
guest's counter on the target machine.

Furthermore, maintaining the phase relationship between vCPU counters is
impossible with a value-based approach. The only hope for maintaining
the phase relationship of counters is to restore them by offset.

Introduce a new pair of vcpu ioctls, KVM_GET_SYSTEM_COUNTER_STATE and
KVM_SET_SYSTEM_COUNTER_STATE, that aim to do just that. Each
implementing architecture will define its own counter state structure,
allowing for flexibility with ISAs that may have multiple counters
(like arm64).

Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/uapi/linux/kvm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..562650c14e39 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_SYSTEM_COUNTER_STATE 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1645,6 +1646,10 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
 
+/* Available with KVM_CAP_SYSTEM_COUNTER_STATE */
+#define KVM_GET_SYSTEM_COUNTER_STATE	_IOWR(KVMIO, 0xcc, struct kvm_system_counter_state)
+#define KVM_SET_SYSTEM_COUNTER_STATE	_IOW(KVMIO, 0xcd, struct kvm_system_counter_state)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
