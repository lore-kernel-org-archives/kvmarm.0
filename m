Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C5453BD
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:52 +0000 (UTC)
Received: by mail-ot1-f73.google.com with SMTP id w9-20020a9d5a89000000b0068bc6c8621eso6367393oth.9
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/WQ4tanGHLD0a6b2FjQ+bGKlMDGPgiC81Lwl9+tXSgw=;
        b=HlgZK7drAF1NkubuaYDgOFLWzGKsIDZuhRNRe/ggGLvHzyeMYq0ufuk/xC6nCR4GiB
         tKo0COOrCG5vOobMn8v1RmXXnAquTm82KSrqpuApRFowqKsxJY2sz8w92mzEpzZzndi4
         VnHxdsSemETwYgEEzspJDMOQ1zmfKc+noNBCE6o5ezFaVtwASt64WNKj7ZLY7LI0DVnS
         2LShvJ1A7kZo2YlD9IKgLs6SxJRdD9l4V1x0oA+YM1Qu+bERGrjFAW7OJ4j7RIbZZOfO
         yxVOazXmx9ju+W3AKI2Tkb6yABPPk2cA8DLoquRA7XhVUbQHU1z7f9s/iBzkTLRZ65Vq
         4G/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/WQ4tanGHLD0a6b2FjQ+bGKlMDGPgiC81Lwl9+tXSgw=;
        b=vbdMSRSE1LsgmyVo9PGkM4Zzg1ZCOXBNlqATGVs4eINHRMj/6usaislri4NXhXqmdn
         djKDYziX8YonoarxPs40MteOLSLGTUpkKzteziI6x6RUbewucXnWPIsUqGWzOGj5D6IU
         WdcXnvufMjNUVhiiCWhptpQwQrHmLyh07Yv+1j8ani0wiGF7doDgWGnwiTwbF0lHDnKZ
         hAl8DXf3LWUgKKgsix6TidZ8b7vXch3ewt5TmjbFHeqimk9Sb3ZLt00Jiq2vlchXRS2x
         z6LGaRqfmurRSvDT/vyYg1WTW+FjRoFZrv64+ak01cAYKneukhQLR61Hd4YbMhm75idV
         sz2Q==
X-Gm-Message-State: AO0yUKUWSfdR3tClMMtgBC45lAV4vVAGuAWuR9bpUCA7Ug1FlT9FAgi5
	ynXi5ryulOIS3b5FIddk1XHxXlN/vKSV
X-Google-Smtp-Source: AK7set8ffZWDVhuBcprr2QYwvUU/KBzrwfS8aKnRkn+PHHlIMUjSCY4ut4uQ2GZlkBZjiAH8CTJ0rI5PuQsJ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6870:a90f:b0:163:d167:809d with SMTP
 id eq15-20020a056870a90f00b00163d167809dmr1742923oab.8.1675704231413; Mon, 06
 Feb 2023 09:23:51 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:37 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-5-rananta@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_flush_remote_tlbs_range() for arm64,
such that it can utilize the TLBI range based instructions
if supported.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dee530d75b957..211fab0c1de74 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e98910a8d0af6..409cb187f4911 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	phys_addr_t start, end;
+
+	if (!system_supports_tlb_range())
+		return -EOPNOTSUPP;
+
+	start = start_gfn << PAGE_SHIFT;
+	end = (start_gfn + pages) << PAGE_SHIFT;
+
+	kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, &kvm->arch.mmu,
+			start, end, KVM_PGTABLE_MAX_LEVELS - 1, 0);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.39.1.519.gcb327c4b5f-goog

