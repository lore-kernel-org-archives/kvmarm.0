Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963191FC1
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:50 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3143a431a01so3838664f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779209; x=1690384009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cC/D17VR5OBfun43qTvIGnaHyJKx4hQdC42tIJHzoa8=;
        b=doLDQEpKLrsyc/8/cLjPncO35yOqbyQe1S2MFPqRKrk8Z4uDzWgHfbs28T4nwW05EW
         1iNmRCYUqrcheBh4pPjlH7fU+J0vqHL3a/bBB10M0F7do7ri7SEvAs1cmziNUYnEbRmd
         bgrej7+SPiQagDHrOL4swX/TePYQJxD9HpQVIRlLX17Qyyt2VAtmh66Gt2dZld9OpKvL
         z3FGiBASu+yrMt0fjqigBGk5DVs+UV0bO+uXi/jHaPYU+MupRI10ZciPqQ+Sdr6SHeF0
         RfrBrUp5WvuOpx5jSahSPFaAi80NQueMoWGsGgubSLwQddsKHgyUGapdvxS/ryIXFFTi
         1FDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779209; x=1690384009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cC/D17VR5OBfun43qTvIGnaHyJKx4hQdC42tIJHzoa8=;
        b=CMu2BZEY8HBq54gKkNJT5l4rFPTKX2yAZp8U4WGOfdodd66xIemNBMBbc502fGasZp
         AoDu2ezAZ7tv+UhbRCbwQk82Y3mxzGmQuSlCPuEPzMJJ7pN9x65kHzwziLjg/deVBNvw
         IGk6K088AvlLhnQBZKZxvxDb5GCvCQUS8BlmOuQ9LdAun+0fGrNTTfBfN0VEZdCDrKYN
         PDAk3mrhWAoaQONK8VC3laHQ4/Wh+VDFZwCStEkPLtmMRNi+HSQ6NvacWdXT99QYJfrO
         x7U11HFzvc0klnu5+BO41f+IxeuCNIHN5OvqK81w6Q35pqxAGyNckzCfjhyuuoK2ZXJh
         3UHQ==
X-Gm-Message-State: ABy/qLZL8RQA5USaywF6Dqlw/lh4SlAYH2kLX0/LD0KMZUl3L98vj2uq
	EbrjZp/wWp7rNxRa4r/NM5vAwwK1hwNby44HCvvUexMtAusRAH9hGL4C++gGRoZd+AYgM6USDA8
	r7U+SYpPzy+KQYsfCCB43ivsSFZMARH1HUSfZE27Y/APhGJZLZdEU6xu6J1A=
X-Google-Smtp-Source: APBJJlEghmKUrkgeK1fKHwyUnudk36ziD2/xWtwdpS6OSYQnktFng10GK0N3wDm6dYL6dF/k19UdhhDiOw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:530b:0:b0:314:1238:ca17 with SMTP id
 e11-20020a5d530b000000b003141238ca17mr784wrv.8.1689779208501; Wed, 19 Jul
 2023 08:06:48 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:37 +0100
In-Reply-To: <20230719150639.1968034-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-4-tabba@google.com>
Subject: [PATCH v1 3/5] KVM: arm64: Use the appropriate feature trap register
 when activating traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Use the architectural feature trap/control register that
corresponds to the current KVM mode, i.e., CPTR_EL2 or CPACR_EL1,
when activating traps.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0a6271052def..e5ea517bab9c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -63,7 +63,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	write_sysreg(val, cptr_el2);
+	if (has_hvhe())
+		write_sysreg(val, cpacr_el1);
+	else
+		write_sysreg(val, cptr_el2);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-- 
2.41.0.255.g8b1d071c50-goog

