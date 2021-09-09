Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A674C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC09961176
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CC09961176
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F28E4B0E6;
	Wed,  8 Sep 2021 21:38:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wp3nDgzZ9icb; Wed,  8 Sep 2021 21:38:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08E04B129;
	Wed,  8 Sep 2021 21:38:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F1E4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1jcaNd2BkmGu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:54 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 098314B115
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:54 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 a10-20020ad45c4a000000b0037774ba4e8bso2031129qva.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZaJi8CrqCPyJ9SPVj5/tYaTEiQv3pZu/dBaNxFMezdY=;
 b=PpNPK3uv3KYTEq4zFRqcV0VpV1U/YFs1TworIZSltJ6BzjGT+CFyrsaUQ81pFogUpL
 pbP/AhfGKn8nVNt0WTzGj6Z0pBSDe5pb8JxKb4lU3xhg4/hh859JoG10iSFxaDX/Ty8y
 ed8kkUkiiYlectcv79/1l4B0ScLwUy5TYyCI8eSdU1OIyOw3AlwBzYxwPV213RHZn+tL
 c92kEM3PpqswL8bzE3Rt3tU2Gb5AaGu+c6TGX+YETcwN19ItCASnme49ODyP5pAtuM20
 5p6KnSq3BtkfvaGY7VjbVR/49ilbif92hnkWMBdj7yBJen8/3hFDiBNs3pao0KsWwySB
 MLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZaJi8CrqCPyJ9SPVj5/tYaTEiQv3pZu/dBaNxFMezdY=;
 b=y0l1NnNWqaZLoqs6VI7ps9fuIQnkfng4KdOgOpuMKA/Lt0u/0ZzQ/njuKM6Z3u/Z/V
 tptzExisz7i7zmzoxDHTXaVuh+qfc+xRus/2uvtlUc9X8lhLQkrW+8ShHTy28DRQmh8J
 g3Y8iKk0K+fMvBWvfLohsBPZ7vA9OpqimxgK2bJQaiEpKLmv7RhL2yDTaeE5H7z98I5z
 vYHFF5foIvbqDSc0XgQ1wZtZuU2o7qgJxJ1053ZbwKCcb8tHXv3Ilci4jNEKRmlNE78G
 4m9KAgzvvMzNv8DoX+Dn0bD3dTiAkCqAXm7B0FlYrkiaVY7N1oozYStJuy/4YK8db8TQ
 3CiA==
X-Gm-Message-State: AOAM530o9Jj+gySxd8NPVzNGIcUbo9IYMvo48A5KM4bdC831CqTV7VV3
 5iODt/ljQrG02qTKwgJ3cNijMw1F+7Wy
X-Google-Smtp-Source: ABdhPJy8pEbKtkdH/W5PM7WuN1paWanl2LDh5YKLnSr+Z8j+HMVfew5uBZscRMSLZ2k43Mgwzdxpo2kAQeIp
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:104d:: with SMTP id
 l13mr485175qvr.13.1631151533677; Wed, 08 Sep 2021 18:38:53 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:12 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-13-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 12/18] KVM: selftests: Keep track of the number of vCPUs
 for a VM
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

The host may want to know the number of vCPUs that were
created for a particular VM (used in upcoming patches).
Hence, include nr_vcpus as a part of 'struct kvm_vm' to
keep track of vCPUs as and when they are added or
deleted, and return to the caller via vm_get_nr_vcpus().

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h      | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++++++
 tools/testing/selftests/kvm/lib/kvm_util_internal.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..d5d0ca919928 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -399,5 +399,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
+int vm_get_nr_vcpus(struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..1b5349b5132f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -594,6 +594,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 
 	list_del(&vcpu->list);
 	free(vcpu);
+	vm->nr_vcpus--;
 }
 
 void kvm_vm_release(struct kvm_vm *vmp)
@@ -1143,6 +1144,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
+	vm->nr_vcpus++;
 }
 
 /*
@@ -2343,3 +2345,8 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+int vm_get_nr_vcpus(struct kvm_vm *vm)
+{
+	return vm->nr_vcpus;
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index a03febc24ba6..be4d852d2f3b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -56,6 +56,7 @@ struct kvm_vm {
 	unsigned int va_bits;
 	uint64_t max_gfn;
 	struct list_head vcpus;
+	int nr_vcpus;
 	struct userspace_mem_regions regions;
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
