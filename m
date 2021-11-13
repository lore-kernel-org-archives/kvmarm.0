Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5629BC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECA376108B
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ECA376108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2DB4B30A;
	Fri, 12 Nov 2021 20:22:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7fw4VnK04B13; Fri, 12 Nov 2021 20:22:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F5544B304;
	Fri, 12 Nov 2021 20:22:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ACBD4B29A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ELQ4olgUCm63 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:22:53 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFC1B4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:52 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 70-20020a630149000000b002da385ceffaso5632249pgb.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ba+wxobSaiFgmTcgNPo/VsfplrPQ2ANaflUkZ8U4a0Y=;
 b=B2RXTSE+PsDQxq7oyt7onb151ClNd8WGtfxbuo8u0TZgh9aOnDTWAnvdB/5/Dy0rzQ
 W0SVhNnv9T96lHG4/HucXMgaCt2V6L/wjk9GMjXIyF1SLKA3QiUJ1+NyrPEjPNeQCF8L
 L7kGJS/2VpOghFFwbmHpzBKTMy1rH586KW5wzi0d6hgzl5ZT2hHP62qfgOs/PBN1QLR3
 I283eK87ObcpukWe/Tw04Po+bpk1cxT80eJ/Vb3iF3jFtt6VLa1UmfuvwFNryAuWFGf+
 NbsBedNB+i2THjX+c+6HFo+oIyw/Fidj1xiS3ksdMJJhZhV4oinNo3UnIYCJtHJGTh+W
 j+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ba+wxobSaiFgmTcgNPo/VsfplrPQ2ANaflUkZ8U4a0Y=;
 b=a3GQg+4gQvk4DRJl9/EUxEVV9TH4Hj3h3egdECmcI6F6TpzGFRsXT7uoVY7iicuOV4
 u/YopK3ap3GltRj3/C6K3A3mapvLjnXFkvOnHggW2+FuNGstO/6vDtD3TJDepKjEMnbn
 F9Natd3VfAV5AB33tCveTGRfKRIcMkfaAlDyY/n+ViRivF1Bw2NAm543OU5SiNbSdcEY
 +b4rjd3qaWA/4tNr/NBpS7FEgWVd0gPaZ8QvRQTe5OqRatJJvGUIh4ht3H3LcweJZumt
 r4zWRe9VTdrtisR+ZeSrgC0xBWAPcjXBxjvUeEXD60MivZdR67i1/lSp/ej91iCmDmxn
 ncGg==
X-Gm-Message-State: AOAM533hGc01UeXcunGIxwHN8Pts6CRG0KBa+ToRADUSdYl1Z4bLAdR3
 FbvG6Zm69D/vdUKxx8VqhjWPJ7ykZ+S6
X-Google-Smtp-Source: ABdhPJxd9EBwwuIBPspUU4u87Oi0TkCWLlVKjb1nJ8VxwRhr5W5IAS2T2mLzZod60TuVuSRdfolwZ6rvNCJY
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:3905:: with SMTP id
 y5mr141689pjb.0.1636766571415; Fri, 12 Nov 2021 17:22:51 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:26 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-4-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 03/11] KVM: Introduce kvm_vm_has_run_once
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The upcoming patches need a way to detect if the VM, as
a whole, has started. Hence, unionize kvm_vcpu_has_run_once()
of all the vcpus of the VM and build kvm_vm_has_run_once()
to achieve the functionality.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b373929c71eb..102e00c0e21c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1854,4 +1854,6 @@ static inline bool kvm_vcpu_has_run_once(struct kvm_vcpu *vcpu)
 	return vcpu->has_run_once;
 }
 
+bool kvm_vm_has_run_once(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ec8a8e959b2..3d8d96e8f61d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4339,6 +4339,23 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 	return fd;
 }
 
+bool kvm_vm_has_run_once(struct kvm *kvm)
+{
+	int i, ret = false;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm->lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = kvm_vcpu_has_run_once(vcpu);
+		if (ret)
+			break;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
