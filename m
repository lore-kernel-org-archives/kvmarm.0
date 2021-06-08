Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4DEC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2095361181
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2095361181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C071449F83;
	Wed,  9 Jun 2021 06:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cXdXJF0gzIA9; Wed,  9 Jun 2021 06:21:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80BC0407F1;
	Wed,  9 Jun 2021 06:21:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8476A405A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id usfWNrcpFf-0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:48:46 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 144D540291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:46 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 a15-20020a927f0f0000b02901ac2bdd733dso16297847ild.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZMiQ0RX43+2xU8fhkPaV9SCdEkQtx107I/DVKk+Rtz0=;
 b=vojVCLN1HHEauEqNOm/PIY0zLcZtycXgG4Yq1qZkQn1i6fCilmFgAbGo7EwMIWp9xD
 uouwKiRPFHRRJoGtI1aiOdDm+b3jc3qG8B2qFpcPFjcuk29VM4ivu3QJMGHK1t5qbJkv
 JGwhnLezKG9L2wbLcVZbk2Dd3Uk8maRdkYMoYOhO6oUClxho6+yxHwdxNkR6zvXzPQB/
 A4RD377h8wBYdTz/O9LeZhod9DfUUZrQ3kKjgHRzSqbcXZEp0H7vIkysawdBHb476m8V
 FILJ9G4mdM8C5+WVDoNhmN8vBGw/vMCx32d3LKmJkv10sQWDTM7ieN3DlfgKKdyxFO4s
 df5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZMiQ0RX43+2xU8fhkPaV9SCdEkQtx107I/DVKk+Rtz0=;
 b=e0WmDucDdq91U2zeKV/KyZyl7liZG9+cV2nUk//NTN5/zvz0EtCzci5F/DZ4m4NEYR
 jiTztM3vYM+obfRCMPD1e5yda4dj/ZybNbhEE68JwgIH00BJvgFhIhT03q5rsVvYR9+v
 6gvgHPBhyzy8qxrHq8/uNCVr80sEEIGvVwjYFaQGzPaeIg0fRXJ1KVRYOkiBAG5Zi9zi
 U/qg1LqU3pw4iz/9cWL0tgW5re+DmKPA17kgwqofEH/8kTrxNX1qsUBs1ec7CH52YXGf
 7mjF7ciM2FWekIZsdvrtETuXlikb8PT6KI2/2l+l5urIvqdrphuZ5LX5xBF3EiLAj/fy
 sZhw==
X-Gm-Message-State: AOAM531jvEoyRq8DXv52KyVPDb3hP31X5eFOyv0+kadYbgBFsiE+FyGR
 hw5gkYRYfmn0QKK3PLHPgWaH2kaKgus=
X-Google-Smtp-Source: ABdhPJyR8V1HzhwDWkDHKme3jZntuYhIwMcdFAlEYI5sseau6in9wS93gGWc94zbz+SRkO7moO/Rzr28Otw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b82:: with SMTP id
 h2mr20761162ili.7.1623188925465; Tue, 08 Jun 2021 14:48:45 -0700 (PDT)
Date: Tue,  8 Jun 2021 21:47:42 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-11-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 10/10] Documentation: KVM: Document KVM_{GET,
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst | 98 ++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..85654748156a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5034,6 +5034,104 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
+4.130 KVM_GET_SYSTEM_COUNTER_STATE
+---------------------------
+
+:Capability: KVM_CAP_SYSTEM_COUNTER_STATE
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_system_counter_state
+:Returns: 0 on success, < 0 on error
+
+Allows the vCPU counter state to be read. Each architecture defines
+its own kvm_system_counter_state structure depending on the backing hardware
+controls used for the guest's counter.
+
+ARM64
+
+::
+
+  struct kvm_system_counter_state {
+	/* indicates what fields are valid in the structure */
+	__u32 flags;
+
+Enumerates what fields are valid in the kvm_system_counter_state structure.
+Userspace should set this field to indicate what fields it wants the kernel
+to populate.
+
+::
+
+	__u32 pad;
+	/*
+	 * Guest physical counter-timer offset, relative to host cntpct_el0.
+	 * Valid when KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET is set.
+	 */
+	__u64 cntvoff;
+
+Offset for the guest virtual counter-timer, as it relates to the host's
+physical counter-timer (CNTPCT_EL0). This field is populated when the
+KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET bit is set in the flags field.
+
+::
+
+	/* guest physical counter-timer offset, relative to host cntpct_el0 */
+	__u64 cntpoff;
+
+Offset for the guest physical counter-timer, as it relates to the host's
+physical counter-timer (CNTPCT_EL0).
+
+::
+
+	__u64 rsvd[5];
+  };
+
+x86
+
+::
+
+  struct kvm_system_counter_state {
+	__u32 flags;
+
+Enumerates what fields are valid in the kvm_system_counter_state structure.
+Currently, the structure has not been extended, so there are no valid flag
+bits. This field should then be set to zero.
+
+::
+
+	__u32 pad;
+	__u64 tsc_offset;
+
+Offset for the guest TSC, as it relates to the host's TSC.
+
+::
+
+	__u64 rsvd[6];
+  };
+
+4.131 KVM_SET_SYSTEM_COUNTER_STATE
+---------------------------
+
+:Capability: KVM_CAP_SYSTEM_COUNTER_STATE
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_system_counter_state
+:Returns: 0 on success, < 0 on error.
+
+Allows the vCPU counter state to be written. For more details on the
+structure, see KVM_GET_SYSTEM_COUNTER_STATE above.
+
+ARM64
+
+VMMs should either use this ioctl *OR* directly write to the vCPU's
+CNTVCT_EL0 register. Mixing both methods of restoring counter state
+can cause drift between virtual CPUs.
+
+x86
+
+VMMs should either use this ioctl *OR* directly write to the vCPU's
+IA32_TSC register. Mixing both methods of restoring TSC state can
+cause drift between virtual CPUs.
+
 5. The kvm_run structure
 ========================
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
