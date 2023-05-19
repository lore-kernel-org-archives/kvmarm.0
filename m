Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABCF362
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 00:52:40 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-33156204adcso43503965ab.1
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux8TuKlucx7+2ANrW96xfpSzC0srXjlkGkFfov8Qh8A=;
        b=nfSM+9p6k+4DETvto+y0GWvj0T9Pn8cMCjrch3oOD/Wt9bRMqYA9UGLB5sbBIFm3bE
         ErGeQr5UdDquGK62ZHTcCSsHQAXPCCLZVOkbzbU6VHi8oy1BBkXlDTx1rUSKGHyXEkcw
         CRrFCWWvlBNXVCva7myDBYAhGGf/U7gd9GAipG1KEYCz1LLOkJLWaSE8T5nm1cEdVlR8
         5tP2tqRGprEouckvewWTYmoYRDgGUs1jXpJueLe9UdjlIwEd5LWNV3rcOeywTjR8qcTr
         7fzQ54BFSSQK1VZGjDitJwXDp65Cwumn+1ym/giNrZSEg0XMB2EwauEgdfRfOpuh9nka
         y5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux8TuKlucx7+2ANrW96xfpSzC0srXjlkGkFfov8Qh8A=;
        b=U/M0LaI2cQyIq097u+7euNkizyDEPmoHngbD0S3wUmp7S3CTXDnWRyo3aAn78ZkL+B
         ULNWBIICRTR9WMifNAim2pKvNOJgXzFp1a004srNZ0dPMWBV/Wn3g0UjSlKXuRovH4ju
         4fgGapQfQ+dYN7BcpOcAHom7E4vLjmrgxOGb/2dWbGKTeUdEhkz90FNf0/VBgyJ4//LJ
         KOF7DQx7QvVjnl0nFTHdSDRl2fEjqncM1B0iJMClsAS6m4Uyv7TgwJRE2gsmrtyIAdNs
         vT0QrCJGBa/CcN7zWasCMjXSDuwGgGF5I/7KzOvSu021PDK5wf+3W6KFN8rxnp5EwRyV
         lRVA==
X-Gm-Message-State: AC+VfDy34LyQM6TLRHzdn4J/KgrrxvK8DDWiLiN9wtWILVNnoiaPuu9p
	TFEw1Rc4XN68qExAEnWkdZlROUhQIYwC
X-Google-Smtp-Source: ACHHUZ4mrHRBUPTPC63HrBmyYMpoPQXoQJAtvWnxdjoUIHpL+YcJ3GzassZ0JGPJascAshL3vG7BYy3W5E7i
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6e02:786:b0:335:fee3:37c1 with SMTP id
 q6-20020a056e02078600b00335fee337c1mr28210ils.3.1684457559778; Thu, 18 May
 2023 17:52:39 -0700 (PDT)
Date: Fri, 19 May 2023 00:52:29 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-5-rananta@google.com>
Subject: [PATCH v4 4/6] KVM: arm64: Flush only the memslot after write-protect
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
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
index e3673b4c10292..2ea6eb4ea763e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -996,7 +996,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.40.1.698.g37aff9b760-goog

