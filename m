Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DB1C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C89B8619A6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C89B8619A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739264B20E;
	Mon,  8 Nov 2021 21:39:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ulHd1YFfaYdz; Mon,  8 Nov 2021 21:39:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D334B209;
	Mon,  8 Nov 2021 21:39:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1AB64B1C5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kLNJ-wH98Vlx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:33 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBCEE4B1D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:32 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 k9-20020a170902c40900b001421e921ccaso7186196plk.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iSH/9G2uxswFP6gkGEcQmnNa2z9g8VsdxM33bZx7bv0=;
 b=FNjNDlAP3hOxMC/RXn9EWgjxrA+hIShK3UY3VETSZOuZMJeHfitIHtJQZxvYQV+f4U
 Iq/swVyJQEUWRDtuU2WQYypz+xyoRoUfhUzx1kek+cHBteUTCGFdth6d4o6Jm9n+oucZ
 IgoKaTYNOIpCsOLYhKXDyHd84maT9VxoAsHSFqznaArbX9+6iESd9y9zxcDsBrepK7d0
 GFpAwakViIFKPT+Pu2ZrImzM9CtXEOk0XhW/XpnbXOWGZpw3X5sIb0Ftm0Cql2xNDzRI
 dpBpmZhwA0kp9e3zf1oxR/1e2V8fI5wk2Bi+0FNAuf5rWpVta3Oin7i4/v8Ruiz/8oJV
 OV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iSH/9G2uxswFP6gkGEcQmnNa2z9g8VsdxM33bZx7bv0=;
 b=Jt4Sw6Pi1PtqIio0DWh3eVRnKHzpuGilxGYwkCLHbMpfPJ8mJfrD9XT41N7BY++nUy
 hLl9S/jYWJ6oHDdnUEpM3x72OWnLJXZ9Z9EQUzdaeqwGKXPsex3mUA6O/somqZ/H7ax/
 Mb+sjr89/8raxYuYcLAZW8JcfG6nCrznThIA870qDqouSnW2xiM8t88tTqzBEeA8ZxBn
 f5OP364MjnF65tl2uoBLfROXHuA/75JGy9hrZq/OXBlIeftKu1Eh3/8NyL9sonXg6Kk3
 2U1aalp/pBvwVKbbHa/H0Nnvqex89Fd7so0KLnzOKCrVFmdcKHYm9MuuMw3fJNpEdPTo
 irOA==
X-Gm-Message-State: AOAM532XUClXy1m/chM8Kfk16LI3SKoKt+M52V+/cm6e9s0/tx53ehra
 xsnRNetYtkYZvNf/R0IfKgp59vDycAT4KA==
X-Google-Smtp-Source: ABdhPJxTt4UcxOyc1/klJdlWYcGN66uMv0GTJlbqC3+LaRYmHWJSHpNI1PabOWRufiE9dGE3qCyvSL9pxALf0w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:1b2e:: with SMTP id
 q43mr3347483pjq.56.1636425572028; Mon, 08 Nov 2021 18:39:32 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:01 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-13-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 12/17] KVM: selftests: aarch64: add tests for LEVEL_INFO in
 vgic_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add injection tests for the LEVEL_INFO ioctl (level-sensitive specific)
into vgic_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index a20d225367a1..bc1b6fd684fc 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -60,6 +60,7 @@ typedef enum {
 	KVM_INJECT_EDGE_IRQ_LINE = 1,
 	KVM_SET_IRQ_LINE,
 	KVM_SET_IRQ_LINE_HIGH,
+	KVM_SET_LEVEL_INFO_HIGH,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -98,6 +99,7 @@ static struct kvm_inject_desc inject_edge_fns[] = {
 static struct kvm_inject_desc inject_level_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
+	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
 	{ 0, },
 };
 
@@ -406,6 +408,10 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		for (i = intid; i < intid + num; i++)
 			kvm_arm_irq_line(vm, i, 1);
 		break;
+	case KVM_SET_LEVEL_INFO_HIGH:
+		for (i = intid; i < intid + num; i++)
+			kvm_irq_set_level_info(gic_fd, i, 1);
+		break;
 	default:
 		break;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
