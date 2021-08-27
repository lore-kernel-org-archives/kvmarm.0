Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87033C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 21:58:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E57960FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 21:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1E57960FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B37D24B153;
	Fri, 27 Aug 2021 17:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I9qVY08Dvd2h; Fri, 27 Aug 2021 17:58:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 128694B151;
	Fri, 27 Aug 2021 17:58:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A317B4B13A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 17:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B6sPp+J2vSqi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 17:58:35 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A12C94B10B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 17:58:35 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 h7-20020a37b707000000b003fa4d25d9d0so414911qkf.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cnx8MV/iIdfnNKhivOjhJ2a0G3hLtk8JhdyLdiJTHU4=;
 b=LtCeEPuf1s00VFa7aOcMIfwN9jnd75qkZ9gzNqNQcwWEniYjs/3D83bO9UERdXmvO5
 oKO4gs34e+D0zEuC72QhnZ20J7YtfCJqOFD8TNukOsGZV3UDmxFtnw4ezBuz88Z9iSGx
 J44TeYACFHGC7svMAzgfZf4iXmRaJJr9ITLzBgtCKxN1i35WammzXpmheHhpsMCypyUB
 3t05X8MQx/o65j+lj6xtcFotBr8utSSOjLvAQGjMfGvGdSaeV3tw6xAh4LlZzayASEMf
 vPMlSXiIYMBgIZE7L0RqsKIN51viU0dZkXU6c92hws6Uk/kfRLXh2AKkeAqZ77olLufS
 wMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cnx8MV/iIdfnNKhivOjhJ2a0G3hLtk8JhdyLdiJTHU4=;
 b=aD1uznv8VxL12R06Q94642YP4ZKObZ1FhyMlHVNJKQX58cnEMR1CfVf3ojtkonP8zO
 Z/dQI8seDtkEkPbVUVnvpYQaKHm6bxMMmKH2bErFyYCaDp5YXbIDXNiaBJRCK0bUzAFk
 iyX3Tg1h5YxxXyNyWzfgytKnqrld2045+uKg46PfXwWkR/VPvrX03ANGOjXV0KM1ZDcf
 mTDLNsU3K5duLKnqw2RQ68npL9Vz0csUVuJqRse12uPL4uz3CpQVECSK9l0KCguY4NDz
 y7/ajEWQa0R7xN2Aw3g0qbGhBZYZS3+WKTajy8p68GIw5aqAhuzpWhXtBcbpWKJZNFe+
 u1xQ==
X-Gm-Message-State: AOAM533rRd2J+kqRtVeApLwRIleYCcP7t1SmibbRBSpolpijNOAgDMVn
 KTOc3mkQIwmhMcZMV/ihJpqYYEKMKLU=
X-Google-Smtp-Source: ABdhPJxlN8oeb0z4aA4E8CXHbvnDa6MT2IGvjTVLccWcC0CvIbwsk0TsHuuWIaBNDYgrU4hQng0Vn3csM6U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1843:: with SMTP id
 d3mr12228530qvy.10.1630101515145; Fri, 27 Aug 2021 14:58:35 -0700 (PDT)
Date: Fri, 27 Aug 2021 21:58:27 +0000
In-Reply-To: <20210827215827.3774670-1-oupton@google.com>
Message-Id: <20210827215827.3774670-3-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
 <20210827215827.3774670-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [RFC kvmtool PATCH 2/2] arm64: Add support for
 KVM_CAP_ARM_SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

KVM now allows a guest to issue the SYSTEM_SUSPEND PSCI call with buy-in
from the VMM. Opt in to the new capability and handle the
KVM_SYSTEM_EVENT_SUSPEND exit subtype by ignoring the guest request and
entering KVM again. Since KVM has already configured the guest to
resume, this will result in the guest immediately coming out of reset.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/kvm.c         | 12 ++++++++++++
 include/kvm/kvm.h |  1 +
 kvm-cpu.c         |  5 +++++
 kvm.c             |  7 +++++++
 4 files changed, 25 insertions(+)

diff --git a/arm/kvm.c b/arm/kvm.c
index 5aea18f..0a53c46 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -59,6 +59,18 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		struct kvm_enable_cap cap = {
+			.cap = KVM_CAP_ARM_SYSTEM_SUSPEND
+		};
+		int err;
+
+		err = kvm__enable_vm_extension(kvm, &cap);
+		if (err)
+			die("Failed to enable KVM_CAP_ARM_SYSTEM_SUSPEND "
+			    "[err %d]", err);
+	}
+
 	/*
 	 * Allocate guest memory. We must align our buffer to 64K to
 	 * correlate with the maximum guest page size for virtio-mmio.
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 56e9c8e..c797516 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -236,6 +236,7 @@ static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
 
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension);
 bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension);
+int kvm__enable_vm_extension(struct kvm *kvm, struct kvm_enable_cap *cap);
 
 static inline void kvm__set_thread_name(const char *name)
 {
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..1fedacf 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -236,6 +236,11 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 				 */
 				kvm__reboot(cpu->kvm);
 				goto exit_kvm;
+			case KVM_SYSTEM_EVENT_SUSPEND:
+				/*
+				 * Ignore the guest; kvm will resume it normally
+				 */
+				break;
 			};
 			break;
 		default: {
diff --git a/kvm.c b/kvm.c
index e327541..66815b4 100644
--- a/kvm.c
+++ b/kvm.c
@@ -123,6 +123,13 @@ bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension)
 	return ret;
 }
 
+int kvm__enable_vm_extension(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int ret = ioctl(kvm->vm_fd, KVM_ENABLE_CAP, cap);
+
+	return ret ? errno : 0;
+}
+
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension)
 {
 	int ret;
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
