Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D422E44
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 19:29:08 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-76998d984b0so553812339f.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686079747; x=1688671747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmdPfikIRRvnyRjXE+lL2qXckkyOSYAQTpf3USgKEV0=;
        b=NHF1fXOFFod7VAbBEt8UCeYZ0LWUlIN+Z6b57RJ3dYkbyPMi44oby9chiAOpKFs6un
         rhxs+wXMHvdYt4NYsIrtkVl2YKSo3zk8tNR2TwujCnBckhIbpVAaktlHB3QijHKNfJUe
         hkb8y/6aZZhYsF9WaKPqZYo3xyz17qUNtYekIJTDlgCURWGI245/YxQk2wkmQm7hJ4hL
         xayxtGHFCypiY81y05iqASARTfMp4rlZxyu38FOX8d7dloa7uO6fa0YCW5u90zQup9cK
         dJkRfasVP0S5ITGJLJepNh3XaHWNfVUfe+xqGnGRaOc8k4fa1vead1/j2XUFEnm8uJDb
         bDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686079747; x=1688671747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmdPfikIRRvnyRjXE+lL2qXckkyOSYAQTpf3USgKEV0=;
        b=GM+ydOH3iZotok19KppprF4Ik1yhalxgKcUe0SnUsXpTe82CYcV6ROGaIQd/IANCC1
         jd7+fJJCmPzwQdqkMc7wAmY9Xugi8jqxfYusPsOrPX4DOAcN4jMhQl3jGlLSYO+bczer
         VTWgj6jbRW+1KtCdSSJt42443O/1P7gDx0p2WEofZw3tuUV/cGKZqQptIH0Mz2s8v2W2
         0rxu8atUZing6gaHWwUBotztP33Y03h9L/y02Ps8YtdBwbbodw04h4ieRyv7c55QqAmG
         F7AS7vlD5Vmzme9N26K9rZ75kHWbwvHwMbDvJ71H25H7Y5COKUmYTFUzgCnZrm9pX6I6
         NEpA==
X-Gm-Message-State: AC+VfDxwLgqdTOFCVX01v3wxyW/ljRK3UnQ66UQ/V3n6Tl+hAhS8N/e/
	G1B2esrcylpqP7/zvzcjo4vOrmVj7snn
X-Google-Smtp-Source: ACHHUZ7BFKutOddfAvI8ltY6fxG4ugpMD+YbWGB0EQ+yV6UaPweh0t3ry+B0nZFcGDzDjvtX8EMf8dfFMhPB
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a6b:6e01:0:b0:774:9732:324 with SMTP id
 d1-20020a6b6e01000000b0077497320324mr1569372ioh.2.1686079747656; Tue, 06 Jun
 2023 12:29:07 -0700 (PDT)
Date: Tue,  6 Jun 2023 19:28:56 +0000
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606192858.3600174-6-rananta@google.com>
Subject: [PATCH v5 5/7] KVM: arm64: Flush only the memslot after write-protect
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
index c3ec2141c3284..94f10e670c100 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -992,7 +992,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.rc0.172.g3f132b7071-goog

