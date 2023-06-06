Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD56E125CC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 19:29:07 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bacfa4eefcbso13892141276.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 12:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686079746; x=1688671746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WYVW7sMItJ+/qNz0zQExZlTscw6/G0/crBTyowFvIE=;
        b=5IlabwCGrIyj/AGVDbv02tLgdBhugCUdfaXNCXYMSgWmeO4GWMwq9kUV8ZLcrznmtJ
         9w/fRVw2Q8vQO+X8PD0RiK+E4de/ZlpNpjX//3+ZJ/z1bgt4IWCS+WCqcmPYchdYMhu7
         6ZyTyuOgCdCzQ6Qd9R9LhK4vGuuDSFhKZxBgCoDZYz1ivx6gHwTZc2aV0zJ34iKVwEts
         b+wR3veNb0Evao1qV8B/2Wkryz4orAqDviNP7ie3it9vbdqD20hDgy70q8P3ZsyWQY24
         V90tcmm1HDL61ztZ1eduvI73n/LrSx8omh8WnuH0h1b7VOBl7pbLKx3+xvncMPyB0MAp
         TYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686079746; x=1688671746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3WYVW7sMItJ+/qNz0zQExZlTscw6/G0/crBTyowFvIE=;
        b=NC0fKU7UOffVROZ31QDkDc8cGdp1B8MNA98sQnjhgqGV5i8qfqqX6CgU+SbgAmqfmX
         ZmVmtVC8+JtE4VSMahxtXypW8wPLudbeYZ4BUiyKCXMh9galdopToJRpOjug041wB8hi
         XMQ05iM/VEKVVXIlJV1JVXbzG/xcUPChzZUE1Y6YDpCUZPjNmne3mPQrJSNFy4M4nRQ/
         KN+18T3Egl2vd7o/DQYcmmVFmBUmSg5mn9No2HQ2V4MuwI4+7qwbN7ReKMsj173uZq75
         QE9zjrLG59f5eXY04RO9g5ACbdVP4h1rydnDwB3KYv8qube9nmf2cVozWvRbuaPZ+nrB
         DA6Q==
X-Gm-Message-State: AC+VfDzHqEl1ZzyifUN6F6EusTnMP4+Sw1PFhDA3vmX6VrQspEYri3mp
	yz7mlJv7mmHCqBsivt0yjhw1sh67g7/1
X-Google-Smtp-Source: ACHHUZ6EqwKWg0miPDGHXqsiKtPZWCKDCcQHa7RLTfS8/ASb2ZH4UEIkh0Qo1ATHiY2DnDeSbDhiY4EFJcXm
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:aac6:0:b0:b9e:7fbc:15e1 with SMTP id
 t64-20020a25aac6000000b00b9e7fbc15e1mr8330733ybi.0.1686079746618; Tue, 06 Jun
 2023 12:29:06 -0700 (PDT)
Date: Tue,  6 Jun 2023 19:28:55 +0000
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606192858.3600174-5-rananta@google.com>
Subject: [PATCH v5 4/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 81ab41b84f436..343fb530eea9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d0a0d3dca9316..c3ec2141c3284 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,6 +92,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.rc0.172.g3f132b7071-goog

