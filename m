Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F2C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D57486117A
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D57486117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 833014B14C;
	Wed,  3 Nov 2021 02:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t6z6TubdhPMT; Wed,  3 Nov 2021 02:28:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E5B4B195;
	Wed,  3 Nov 2021 02:28:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8DA4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ob3NBGfpUkQn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:25 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54C014B091
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:25 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 k9-20020a170902c40900b001421e921ccaso159481plk.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LPEo6E0odusyrNggBByLPHmUhPl/zAKGlEQeNEdskuA=;
 b=bUNM+pxcYjjNldjizqCPZrdfmrJ570sn9wZ2+V56DnjdvPvtesjhdX/PSW+VQDoFfO
 4yc25e1h0xFAlZIhbOGpVQZrhoK267T/BxRH6QH3HLqV/1XTLHt0bmLoDFG2mBLwR2n5
 4qjERrwJ999xwEgl++TYoXgA9t9wDvO8RsuGQMJaJ5XEvCaVXN3vs4Fn3idvHHMy8lzJ
 eIuynnNTqqXtqERgV/dwYp/hbLg3cZOLT2Hz/eodY1pJ69D1yTMVzvEJPhuK+3Cgtg/n
 7U3CmnMjBBgBG4VlAeldkwlh/C5NaaZXwcCDPKbztqhLXOUTFjDOyPzZXSoH329hztzx
 1ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LPEo6E0odusyrNggBByLPHmUhPl/zAKGlEQeNEdskuA=;
 b=5UeLpyIHyUy4l8HTJvOWFufFKNnsWu3zGyhU1Lt7U5rh1nAZxtaBZkXFW1EWKK9k+M
 OvsuHl0CgrIQaoQzAoaWFLkqPBYC3nZdGlQQAw5LICeL0hSA1OUIelTynqNk0MxWxN5p
 khFPSZ2CoEaKrEgVS5TgSUqhZZKrebIRnK8mr147I+jxwHclxvg00iC5XskPNzcp8piS
 Fp3LND94WTqpIahwzhPVmxNw9zDEJmhI5M+UIa/pAQkKXCrVvrNVHx9ZNiORZLJm35+2
 rj8mcLz8TEA1mHmRJYumtFM+qWiEv0kCgJjX3AigvPIdVyeD3Jz8a1AbH1wf0Hvy8BLN
 9u6g==
X-Gm-Message-State: AOAM5331heq2yzzUJjNqvQUJL/hVINfiPk2LgTnsxUsUte23NH41joUS
 aR0IFLpTzCq6Rt/uAVohIa8YSdVX2tw=
X-Google-Smtp-Source: ABdhPJxPQlTZgemwz/ej9COOHQof1/L/+yDn2lMn62bmlzOf2+lYhTzbKkH4dxYFVrp4EA9bFyTluvTF1D0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:1904:0:b0:480:816c:1d3e with SMTP id
 4-20020a621904000000b00480816c1d3emr27606490pfz.83.1635920904536; Tue, 02 Nov
 2021 23:28:24 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:10 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-19-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 18/28] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE
 capability
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
that ID registers are writable by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..f7dfb5127310 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_ID_REG_WRITABLE
+--------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 528058920b64..87b8432f5719 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -197,6 +197,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_WRITABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..3345a57f05a6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_ARM_ID_REG_WRITABLE 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
