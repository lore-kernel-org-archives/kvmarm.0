Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4430C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58DD16137D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58DD16137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D3BD4B108;
	Sun, 15 Aug 2021 20:13:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xSsfiQhmMGy3; Sun, 15 Aug 2021 20:13:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9E64B13E;
	Sun, 15 Aug 2021 20:13:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9EC4A193
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zB8Kqsq-CAr8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:56 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AAE34B10C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:56 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 y10-20020a5e870a0000b029058d2e067004so8299389ioj.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qqp/SiKQXNqb52XXOCheL4cR6htl4LO0kcJJeErQ0KM=;
 b=nV85gIhy5Mdy9FrQ4UM0C4NrSPFVkV71ujHfJ8rK8gp3QoY27qqM575XGRKe+58Vo2
 kcDC+dHLR7nkG5AVQdTUDca2fvIU1oUAbfEzIp0AAlP+WEGTD+pPoEyg9LJuklv9maAW
 RjsAIwwWh1y4qKsik7fUndJerBUoqxZc/d6HCtUjoCOSsDEub+WSTdzzLCAgK6LgfChf
 Dbbbam0nAMIpFzZjagiCPdWQjKm1rOUo5cUqL3Dy5eqUOxCMjo7f2AyBl+LaI+wAdni1
 lCyPnsv3btnqTsR4tpajBW19R23leqbTIGNT28fgUD2ryFhkLY8d51B6tbYnNYadBzSm
 s07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qqp/SiKQXNqb52XXOCheL4cR6htl4LO0kcJJeErQ0KM=;
 b=BmRmiaOOH0GOt4YgxR2zo2GMQzsWFZLYLAsfSAl8ipK81/omAD/fVgSH//ZPtfC4ss
 GWSRcmnao+M8K0X0lE7GBbrDRq/QESlABc8B1KCReZBG3pdGydgh4QZUojojcGD+l0sO
 FyjxmGWAFg9Lxc4xfHdh/yIMI3FbrM72/Mpxy6xgMMsRzcImwv58WWXZlh6VoRLoJlrk
 cAxiTBZxV9Zlee9JZhMbZrcAqyuJA74kK9yV0lDaov1wRpQ+HOx1SMwrhWYmOjqimpU2
 ER+OIYlOF+wqaCj926zaWVYROudTOWPEZoMtMmYAE4YanrYSBYm56wyWAPkvhsfcuxGh
 QZ4A==
X-Gm-Message-State: AOAM533hJ28Hol50O0d0Z3yWf8Rr40uh556IOqd8+azsE41/348rHP7D
 vGnpl7aDYL3OVgCuEZfMky4oRXwcSeU=
X-Google-Smtp-Source: ABdhPJyPI7VnyfiX7cslqPDObv36x6Z1p0K9s6gygAZTtPKm2R0kUptF5KEoa2qPPVC4Q7CE4xo3WGA2Xus=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cd89:: with SMTP id
 l9mr11939190jap.29.1629072776109; 
 Sun, 15 Aug 2021 17:12:56 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:41 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-5-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 4/9] selftests: KVM: Add helpers for vCPU device attributes
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
index 0ffc2d39c80d..0fe66ca6139a 100644
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
