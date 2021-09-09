Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD3BC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4058A61181
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4058A61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E730D4B159;
	Wed,  8 Sep 2021 21:39:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xjx0ALl55iAB; Wed,  8 Sep 2021 21:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A7A4A5A0;
	Wed,  8 Sep 2021 21:38:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A977E4B15D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JxV5jgci1pk3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:57 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57BC24B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:56 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b9-20020a5b07890000b0290558245b7eabso401107ybq.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QFzaphrb6MUUmunc6a6PS61JVYVIo4B9xEZOBe9g7Fo=;
 b=OLiKiebf2TxifAFIXy3Xc+KcOCQ/0AGYdrE4MhqknFVHdroim3LDpPE5sbASnxry8W
 ghCwia/tmngpglMpIPxqFiP/MURbu6c5Zh04SGNyNjrRUwXb8msisPMuTnnvPkAmp8ld
 XaU8Y/HKaoWMRtpKDZ1RIjIx0Zfa9OZP+kfhw7YYEn6EkSg84iz0n3ox9rYxOhGMoyAc
 PJynGxE7Gh2YmOv8iN2CyaJMw760I7ez+eq7P7opjhhuBEdHdiYjYKq2/nzYHc6u2Opa
 7I4bUJNYcVxZpfxT158n0bnulcLHoTMeunqeYJ0nIT69aIpW+yLjqlg29DzurHUuGODU
 nq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QFzaphrb6MUUmunc6a6PS61JVYVIo4B9xEZOBe9g7Fo=;
 b=kVMOUjqZzALQYvDOMcouw4hrngDxlg35Qtfc+UZFirJbTAWwi+TjwmQqb8sXswAKQo
 V75DJwKYXEbRJXiFoVOUcacDWd/5YsDrI8fiDDspdNeqAKf/KeuNlihCyvzSguAu7g1I
 TMpBS3atp0qzLI6soSPzoU90ohzo2ToaSlViG4FI6n3T/0wsK09AnH5wcxjiYWk7ZJiB
 uev112ge0aNo/K53/6cjJx7r0tuKNTetT9wJiYQWpk6/mgCDhr+XBODkhriXlsdy2xGX
 /dMBqi55/eOE1i9X1Mm5WCLWzDUKxhPA+DKB4B8TuXC0z2ZgP5Kt+PLes/iR5yW2Z2an
 plUw==
X-Gm-Message-State: AOAM533YnlQmPBoxhPRogFnmx4fBHc0XDlHbAPPvAVgpcvZwZ0FKhmid
 5MV1N+jt6suw9EgY/E3/GY5B5HoyzkaY
X-Google-Smtp-Source: ABdhPJyIJlWSvy9ha4r+TmbXK5U100h0ul3t0NMi635x/oKJd6ScJd3FEJZ8ks+Ji3XU4v7IezN+undvXWOe
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:802:: with SMTP id
 2mr528307ybi.61.1631151535888; 
 Wed, 08 Sep 2021 18:38:55 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:13 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-14-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 13/18] KVM: selftests: Add support to get the VM's mode
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

The host utility functions (in upcoming patches) may
want to know the mode of the VM. Hence, create
vm_get_mode() to return the same.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d5d0ca919928..9842bf5e2c2e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,5 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_nr_vcpus(struct kvm_vm *vm);
+enum vm_guest_mode vm_get_mode(struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1b5349b5132f..ad73ca921e2e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2350,3 +2350,8 @@ int vm_get_nr_vcpus(struct kvm_vm *vm)
 {
 	return vm->nr_vcpus;
 }
+
+enum vm_guest_mode vm_get_mode(struct kvm_vm *vm)
+{
+	return vm->mode;
+}
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
