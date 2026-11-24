Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795560617;
	b=BNibjCotbMoeVDeWVxJGMT4Ol5DeCvTLhSH68cswHJ6nF3FlU0/WDHkcpK8J8dOtAsP0
	 DZY+tCyEpXFjYfuRo0sdZrKPMURdiFIZqwy5pH9MGZkwZkJfj/C+svBfpY/ibV0IYYGFf
	 E9dhOuFezBeQPDR2zyu8h3q33iAks53RfWzS3g9CA6TAylvl6MJ9N9RZaQoO12nNDi/iy
	 aGJ+pByoNgTViV+H+1CE3EwAKo52ZIS6UNV1BWonCKzn5V+UboSNke9eQqGFwBlypqh5y
	 /noyzjjXt2LHOfPwv0oWPiHWn5Wf2qAibr0Aubqd+yMEOFTwyUwnKskVP5P3KPoAA2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560617;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sVZKaVNqfINKaLZaT1Y8yFr4I/GfwQE92cCdjha8+PA=;
	b=pK8doQZpDJoEINBn3WxgCnEZmZRzqxXE1IhPKkbCBKllswtq3wfMXdYnxeUYYuV0jWdK
	 gDMOA4EqIJkynT2ONPijy4VI8OOF6Tzp58Sszj6sMdxyuw1T33gP+xTHQOoXC0qTf0sOS
	 gw5pWhfRYcJEsEQnNiiGInOv9K4AzEqFh2yUtDVCDJMTj7F0x72MwfM43mxqDeEc3ZW4S
	 WaZaFSwjrRRD84Yl2Vmu8J/8DiAR88E0sDw6OLFhsjKmBU8JH5IMh6K69npGTKPPrciIl
	 b4qj3vh07+bdv/Te/KSsBwoYD916LlWhYMMm3lpV7rmxZDqhHZdHZTH4gSf0f+YLtAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aashishsharma.net;
	spf=pass smtp.mailfrom=aashishsharma.net;
	dkim=pass header.d=aashishsharma.net header.i=@aashishsharma.net header.a=rsa-sha256 header.s=google header.b=NhAS41Xn;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68A606A680
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F68A606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aashishsharma.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aashishsharma.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aashishsharma.net header.i=@aashishsharma.net header.a=rsa-sha256 header.s=google header.b=NhAS41Xn
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso10879101eec.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 14:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aashishsharma.net; s=google; t=1795560615; x=1796165415; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sVZKaVNqfINKaLZaT1Y8yFr4I/GfwQE92cCdjha8+PA=;
        b=NhAS41XnpJYM7yWuPOmESMyubGudyb52MV5nJExlBFDyOpSofjKjl83ku2dUkBgW9e
         3Wf4nkNNacRbnzaDrSTXZv52uqA69BaFo8HGnzlx7EIZfPGXobOFiI+ffhDWBNasEKXW
         lAsm0ySOYlamreqYdFqhDij7FDXWVT0+feqk6GlihRHB5PiwyR7MbuZwsozMEkl6/4rk
         34NMyCyq/nvXCjFuLXJerp5uUgTfc4tmWJyRsQo3749ASx4nuNTskHEPcS44ImLykneB
         06sYyuMzTRdTvvmGI+MiS+o699vJBIzL8X7CnC6+qrh5xumTsUPNWyMV3reIigdtt998
         /gRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795560615; x=1796165415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sVZKaVNqfINKaLZaT1Y8yFr4I/GfwQE92cCdjha8+PA=;
        b=kTV3aeO/LxsMvm2gRTbvcWaS8ELTCFdt2+lzOU1NN2vDEFE0ytz6V44YAGlTXwzPSF
         ocwkpZop/Wmp3AgujNyhswFSSQE6nbef2V0hXgFa6tIb4v/MGmkf39SX3ZWM9Qf019pT
         UNLyo5jRTSQgSL3gSHiKb0IJJAGfzggC9UzJVIKh9KcI8gD3yLP5/o6wBQm8n23PI4Xb
         wSLjJEik6lzAD/jCNVlnXAd3im1S+x4eNoortO9y6b8DTb+jY8seoCJcirtc6yz7H4gd
         1Fp8DmAuttXr35sGD9JVdPInmfGhaVw6buFZC8l292qG6lKRhdSJMTYPdOEwyuyEHZX6
         deEQ==
X-Forwarded-Encrypted: i=1; AL+hErGihmYO8y6Ik6d0oiW/Xdi0OsdEpHHctZ2PTNpdYOFbacwh0LrdxjpTrEzDeiO0aeiFXZUuiHQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z8j7pMgSMp0jte4rqpnAdeXXLhycAJvIOxi7G6HDSSaSwh9aSZ0
	f3P6do7YzG3ZiP+NK/XEdx5ro3ISyIj02ee4mudnVCpGiKKoikrhwGKNH7AM20fXbkM=
X-Gm-Gg: AZFdTZd9nnKIJZbZOt9Ljhs/FC2azFYlZ7rUxnu4Po3bJQhl8rsnuHPX2L4MNikFAyF
	FWG7pezdCBgwZ+r3GjBWh2fA6A7xFJcmybQlh5NnKMMegdbqRdxuTn1LLBuv1kfblbvOeFWLTlp
	8jxb/oBrBSqGzfw6VMVesWloLTOF/aRwS8KkaMZhCq8iX+AQYwmPNQrsnFtjAerbLBgWOmdAEXN
	Izs5Zo/FYq46GSe5G8FgZyjbBrTgxkm+H7IOoIPdEHcxnYyPGbw5J4Pjp4WOLIwXa5oilN8rq6Z
	l5MLYJOuDsCMUSYmOY3qcBNpLT6chKHhrMNQpWUB3xdvgdj9/OrVe75DLkyPS7PnYfLg7fFQJpy
	0lQkWzqUn2Gl/r97TueXCVbcokPnY6zkTAyJd2zhYqwquR+l2Cj0EZZdQ1cXJ+aJAzRwirFad3f
	NCDr0j9wooAdC6zN3vgE5nNHMem2rnTJ4/YOgwy+0jKUWbZwgAgM3U5c5pDnO+XmyeMSnCjzFaA
	c2mq9qWeQ+mCPyc7espy2hXvghzkoMd9UkU9+fP21ouz3F2H781Xduy5gQ5DkYaKjIwt/nS/ztt
	c8m1Ugv++kb8fQwKIx9cQ4PeagUJ+lJxdGl7hzbYYkuq+dPeww2Jt+rvQBO2G7LYeWkHrAI5CwB
	uoFbBF7LrDZDDMqMdSvh71tThNBBZPWQQxQM5Tns=
X-Received: by 2002:a05:7301:4284:b0:382:1aea:c21d with SMTP id 5a478bee46e88-3857191bcf7mr17176831eec.41.1795560615370;
        Tue, 24 Nov 2026 14:50:15 -0800 (PST)
Received: from shraash.sjc.corp.google.com ([2a00:79e0:2ebe:8:be5d:9202:acae:6527])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-38566cd46c5sm58294406eec.11.2026.11.24.14.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 14:50:14 -0800 (PST)
From: Aashish Sharma <aashish@aashishsharma.net>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Aashish Sharma <aashish@aashishsharma.net>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Do not free split_page_cache in kvm_arch_flush_shadow_all()
Date: Tue, 24 Nov 2026 14:49:59 -0800
Message-ID: <20261124224959.685002-1-aashish@aashishsharma.net>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_arch_flush_shadow_all() is called from the MMU notifier ->release()
callback, which can run concurrently from __mmu_notifier_release() and
mmu_notifier_unregister(), as well as concurrently with VM ioctls
accessing split_page_cache under kvm->slots_lock. Calling
kvm_uninit_stage2_mmu() there invokes kvm_mmu_free_memory_cache()
without locking, which is not thread-safe and can double-free
split_page_cache.

Call kvm_free_stage2_pgd(&kvm->arch.mmu) directly instead.
kvm_arch_destroy_vm() already calls kvm_uninit_stage2_mmu() once after
mmu_notifier_unregister() completes and all VM references are gone
(see commit a3ca3bfd01b7 ("KVM: arm64: Destroy stage-2 page-table in
kvm_arch_destroy_vm()")).

Fixes: e7bf7a490c68 ("KVM: arm64: Split huge pages when dirty logging is enabled")
Cc: <stable@vger.kernel.org> # 6.6.x: a3ca3bfd01b7: KVM: arm64: Destroy stage-2 page-table in kvm_arch_destroy_vm()
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Aashish Sharma <aashish@aashishsharma.net>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..2440ad9fed87 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1472,7 +1472,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
 			kvm_free_stage2_pgd(mmu);
 	}
-	kvm_uninit_stage2_mmu(kvm);
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 /*

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1.831.g720f3f5937-goog

