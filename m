Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8884A7B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:53 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id f17-20020a056602089100b0072d326fe58cso3230330ioz.10
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuXcpW5hhZycWwjy1Q114Q+HT3FS23f7QbM5HtQY0Fg=;
        b=feKShA/7o9prxIHFhpNnY77ILQUPvgtpZXRk79I3iz0pxZR4XUQSXtxjBLVH+THqDa
         vcSpwZXazMbkumYlUMJRFzZWGBKqZxy7sElr6nYZ7v3kuQZaK1Z1KxDj01LfMeyT7mH3
         6w5A5L2SljnoZgGQsrKJrYCohxcM9xKdu/qZvXTVBpE+tK6GENFkgHYRaOgTsMix1n7e
         uJzgmgooIUCuCP9t9WrcP10nQ2l9L6DGY3FMMbeO+6zNOmAis/kijSg7NFTZvj06P9+8
         3BYpx3rzb2M0cUf0XIK3hGqrmehOJ8k5To3ZsQgGGxqTYW0tVAT0h8grc9edvmNMe+Yw
         uq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuXcpW5hhZycWwjy1Q114Q+HT3FS23f7QbM5HtQY0Fg=;
        b=HMN66emGmo1VNllbMv342UzkkIaZmbsGd3ps8v0pHSbwk4sTVacAp9v7yi6jurDQ/M
         n5GklHPLVIfS9bsQDyOte40wVLadWtSDtF82TWay7h5eEEhK87Di+25ysK0Ze7eFJ6oA
         hJo+wP6K626w/4YIDFKgXbd6Vk8ssM1YkQv+DJS19k4TfVh2m1FJG02f5MzXH2HmZDFi
         dKoFgbjOHXRBLLkBPlGkTR5fy6BM/ibehk25dVQVbs5hptg+WHfxxzGCmBbrBuXT3xjn
         vBuDoqviCnWKkbjKCJSdi5LgA656Ca5BxdxuT+GpBDSDIOmAG3O1gq4vtgd3T9CYGQvv
         LsrQ==
X-Gm-Message-State: AO0yUKVTeSAkaEW9VKhS4LkrIse1eIh7K77+LHO7othc3ejiNAa6fLar
	7xAa3pjlSXDregpMNB9squ372c4XtmnI
X-Google-Smtp-Source: AK7set9A/bA5zzEfudk7dWL6RltnEMvURxG1hIJY97EY9SyVcwzO2bKsvygC60t64GkBOI+dM2FgiOiM83Q+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:398e:b0:704:dad2:863d with SMTP
 id bw14-20020a056602398e00b00704dad2863dmr3973430iob.60.1675704232681; Mon,
 06 Feb 2023 09:23:52 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:38 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-6-rananta@google.com>
Subject: [PATCH v2 5/7] KVM: arm64: Flush only the memslot after write-protect
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

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 409cb187f4911..3e33af0daf1d3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -981,7 +981,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.39.1.519.gcb327c4b5f-goog

