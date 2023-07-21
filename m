Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1521174CA
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:59 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-314291caa91so922397f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933118; x=1690537918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fw/zi6S9TpUpn6bP4HvBi5LEnCrD1TR71KwU6RzN2og=;
        b=dX9nIf8HB5RqzDgcMs0ebk3DLuy92QeXIP7DWuxG42pzMoGE8HNn/BKAJSHTPRfciT
         beFdwked58PW04XQwNxoLnKBNNy8eZjfGGzZKVifVG0E8+UQ2N16c0ahQLTh6EyMolK/
         XQDXQeLeZEMp/90DAg9nsG5pdjV8idFAr6AuuNBSE7ponFqWm+8+ADVP682+A033YFVk
         GXhFlIaTDVUUBenaqp02s7e6C+TJMmcuDEHBn7PnDMduEhjYfe6u3b9ZBbO8obfNPtsx
         9EFERtPlsdMqRR+ZYu8X3oxj/KjmvUYJ2B93tzm401tMNZC5Ff37FX7sNkGPDDpRWif0
         p3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933118; x=1690537918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fw/zi6S9TpUpn6bP4HvBi5LEnCrD1TR71KwU6RzN2og=;
        b=SqNAWzbrgIPYzQFlCPZ2SRyzTKEZjn98YWlno++cd1U/iu4hDpgNeLVtfsrzrbWQlY
         OKA3m7EH14pv+teT3rXtouKfNVd8nV3siHMI71ynwKNAplBm8hzdEdBOaDIziynHsG/+
         4iZcgqwxiVeXETnww6kiFsKV+y03D0FLX+Tht2cRpi/tM+ob0vlQ/79nbvv+LMhEt17N
         ot+NCdSjAazXI4uchGC16QN5x7PFDeJsCGIabqkVhJgGQ0Vy4T42dFOeWIMNpoXSGcJT
         IOdqiBH014UCMhrh4TH25gt2pM4t5UguVlR7ioFsi5Fxiytkd/RnOlpe0wVyCVm9p7De
         kihQ==
X-Gm-Message-State: ABy/qLbdfO9Xn32+8Qo87wAKlXCBfKsW2MC8eYAlG9aQnIVFDSOC3zH/
	MUQfio15ZkadeBUk8nn9Pv3rzwbZYUjBRCRHWWvQU5y4mYniEosfM/eny2pycS2lmcD4lBSyRIX
	EGdi06Yn1UBfO4HWPu/IaDkC32g7XtB3el1KKliDT+bQKtME3IIq25iMQDik=
X-Google-Smtp-Source: APBJJlFCMNNVir2PuTIB9/sWw+SsuZgA6EnZlKp5X4H3MSUKHdmVPcPKdpr0NGLikUedHg+FsTdjY8HgSQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:db06:0:b0:313:f2bf:4c43 with SMTP id
 s6-20020adfdb06000000b00313f2bf4c43mr8487wri.2.1689933118124; Fri, 21 Jul
 2023 02:51:58 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:42 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-6-tabba@google.com>
Subject: [PATCH v2 5/7] KVM: arm64: Use the appropriate feature trap register
 when activating traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Instead of writing directly to cptr_el2, use the helper that
selects which feature trap register to write to based on the KVM
mode.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0a6271052def..e89a23153e85 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -63,7 +63,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	write_sysreg(val, cptr_el2);
+	kvm_write_cptr_el2(val);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-- 
2.41.0.487.g6d72f3e995-goog

