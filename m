Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C4819E45
	for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 17:50:31 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-77e2c123e8aso472034439f.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 10:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369830; x=1689961830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpR1MspLCCKbLGu542rFrU99snL12qe0SU5vnENHbnc=;
        b=obkQNETduI4Wdlr8DqbH6rQDpqF2mUi0lafiiZR1QXrNN2+tKemED10KMGrakG13Nq
         +F9e7JIuRjiRR9EfoJnua+9jPsENy4Tu90Vrn/2nK11OMp8Aj/golURDqyPfJ94Cfrxi
         hdWdLoNiohD/PMMDEG0mtQHMd7A92j4tIxNPh8D/cM9gYPH0WwqnOU4OcPsZKdr9HTOs
         pyGKjpe6+P6Xcb6ByP94N+J+yZmYDJogpjw8kcjVcP5B1YTqtAJdqi8Hp9kutYXKuAUx
         OCxMudA25zodKFZSyAwbz9vLyvHyzcqnxGuKjUldsdPVjyx7x6uGCQbzc3ZzHDMDOM0D
         Kg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369830; x=1689961830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpR1MspLCCKbLGu542rFrU99snL12qe0SU5vnENHbnc=;
        b=cXpRNIbmXwLDoSL3bBQQR3GL2oYNbOmYnil6VBUj+uZIPcIpBTHsmX7shvexyyafDg
         wb+ueA/aU2/0Lg3s8ajdG1CaddoKyeR+B0KCMMnXNxMzquk5U2dSypD8v1cHYZ85saQY
         5873BPncwIbVNR+KJcsm2DN26ucKEkYnqkFhk8rPL4CNP/T3hB89wWWFSGSkCjAevUbk
         fs0KIkdS/tVyl7IsErtTs2coaa/4gHhru4PXD88speBzuEK/vhRqRFdd6VhtZVmzaBj1
         3Vvdb8gm49YI8z2VTL/4uag56aKSMlkoZLZYpEbWPEwuhIVoTNp3HHiCXDWd01JUU4X2
         M4+A==
X-Gm-Message-State: AC+VfDxS2aDLAej5/SatW2E2D9act0PqKHMoJNeC0Ro/A4LzEbeS57pf
	8TOxGvgge7YeagJa0nQjmZcsxrhiwHgk
X-Google-Smtp-Source: ACHHUZ6lEejYkvXSZImNPgkcjtxASyr0tUJRYFuyzfo7eVoPr61PQ+mo3lAqnIjMYGuKsT4NfkEe3+3Un922
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:152:b0:777:b38d:2333 with SMTP id
 v18-20020a056602015200b00777b38d2333mr5713635iot.3.1687369830330; Wed, 21 Jun
 2023 10:50:30 -0700 (PDT)
Date: Wed, 21 Jun 2023 17:50:00 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-10-rananta@google.com>
Subject: [RESEND PATCH v5 09/11] KVM: arm64: Flush only the memslot after write-protect
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, David Matlack <dmatlack@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
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
2.41.0.162.gfafddb0af9-goog

