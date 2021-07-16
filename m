Return-Path: <SRS0=U254=MI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F769C636CD
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B679E61400
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B679E61400
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 698BC4B0CE;
	Fri, 16 Jul 2021 17:26:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gB3waz1V4aEG; Fri, 16 Jul 2021 17:26:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4544B0DB;
	Fri, 16 Jul 2021 17:26:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23204B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwvUyPXeCFoQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jul 2021 17:26:46 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85A924B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:46 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 o8-20020a92c6880000b0290214927ba4d8so1516154ilg.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
 b=B2erstsZ0I91t+mYldLmOLLel1G+aM6Ian9jvA3PqMUvLVVS+sQUUBXObAUf6cMj5+
 PRMGoz5VZCDt8kHkNkVJuACsxAUpJ08ID+Sk/jPDFJvNbbyh9ZXsC8GPQ85zmO2zvEWd
 fU3zD+0XbCXLKnIOik79V0+V3Sibe5nUe9kklumGK3Ngd+YNOK61XTYd53uVBqIBAURa
 zaoxgG4aKHqy87gunI/Sgx6CxgSIGDchWCp1LBYSvGuokfm1Iyy9TPr6UBaqHSewUQiZ
 6/Ojo/16j508dxgP7Ifs1hftC31nyoETYOTqWT9VRSc1pw4lXQZ35nt04bnpGOkN4517
 VYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
 b=g88Owt/BrOWcLrptgqeBiYGSJsjC3SklfhdfK1dQrR6hPavTRZ1CLiVL2ai9ys33+6
 TQLwW/U1vuRPH8lpVVEm9JKSj52AWDwB+4/k8TWUalyl+8x8hb/+7vy+CgC7MWATEaN0
 RyrUk7aCXhvU+7hpEkDeMjUNxqrn1Gmv5pMvFHbArlANeZmyyGBq07rtXTLy3lQ5i49N
 uVY2mjnSq9j3V5hBpBPcFnhmKAHvREXNGxOuttKHseVXRJ24mQ/+0UX0snNbt+ZeK2rh
 L6g+nMjMMocKFsQ9wcQeqHraA5rDaHZZ77I/XEWkQiiTQxCfJssI6UZV6gclp9V2aVU9
 XSIg==
X-Gm-Message-State: AOAM533EgLW8uiMvyC6OZPmBXYGuWbWGDO1LYyhTLGVLZjA6YdkUZXPj
 tz2mgVirIpRfIB5A2dSakuaa9s2F44I=
X-Google-Smtp-Source: ABdhPJzuRsqE96CDh/UoCvZS6h5E8FyCdDD/dtyia+XfzDZwxA6F3DGOMJ9OV+ka/8G2p263HmaPR1hXhIk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:24ce:: with SMTP id
 y14mr10410273jat.82.1626470805952; Fri, 16 Jul 2021 14:26:45 -0700 (PDT)
Date: Fri, 16 Jul 2021 21:26:23 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-7-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 06/12] selftests: KVM: Add helpers for vCPU device
 attributes
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

vCPU file descriptors are abstracted away from test code in KVM
selftests, meaning that tests cannot directly access a vCPU's device
attributes. Add helpers that tests can use to get at vCPU device
attributes.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8ac5d52e17b..1b3ef5757819 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -240,6 +240,15 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		      void *val, bool write);
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr);
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr);
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val, bool write);
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr, void *val, bool write);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..b595e7dc3fc5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2040,6 +2040,44 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 	return ret;
 }
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_check_attr(vcpu->fd, group, attr);
+}
+
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+				 uint64_t attr)
+{
+	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			     uint64_t attr, void *val, bool write)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_access(vcpu->fd, group, attr, val, write);
+}
+
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			    uint64_t attr, void *val, bool write)
+{
+	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
+
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
 /*
  * VM Dump
  *
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
