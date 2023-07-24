Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3925B6AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:50 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-314275b653eso2035617f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202328; x=1690807128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=16iMKWf0z7WreQdZZ/3r+benf5UyGhC6ljZvClyrUfI=;
        b=iEDRqLjjL6farTRl4XSlJdYmByh9z+Yel2EmGXGlwgooFgHzal2JmelsI2JiAKHGA+
         9USEIR2+TxiQnnGKiDazEfdueLgc2R7xtGxs4qOnxvyN48IfTajkOAMF+forrac64oO9
         8ZJaJ3IQILT6cX9kP7LWGBghHXTxQaB4LViuHsskTm71cda60curmZxXqF0An0AcBaxy
         DJ0lc8D9CEC0A86iXvNcTaRgWCypp9PoIvmazCGwVyqozy4IiYUWaUQNjpMCLnczqyYn
         H0u78dKn3tj4hl928AWjy5+HOKCTSeo3xNFoSN7cqyBVP6zMO81n1rN4w+6GoWbnzqP/
         jqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202328; x=1690807128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16iMKWf0z7WreQdZZ/3r+benf5UyGhC6ljZvClyrUfI=;
        b=dT0aY3Y/X/MK8PWm6f5aYsi/iDc50JtPxvajLfEuBK2Y/KSJYt/rwVDZBM0+uUl9tG
         Oy6/JvNOBoYm+sNMFzDjw6iAv2fy8A4u7EY3cOUd06wjtl1OVzvigKJhTIIgN91yQW+d
         UxfNXC+M1xF2Ld8v6CZCrqTwjsJ/9oc+tdD1oDs8Y+1+zNiOZ3w/oJqwkh9ERdXzVLnm
         UuapTAXYBls8x8/4QizelXjgNFTmBe9jyj5hYZEBcGi24zJmk6nZIyA8j/a6VU2cEOn3
         rKFqI9qYOqvBC5kwfguzPFF3IpCHuo1ZCMX7g6AAR/taBnBLboLidxczIXF7WRdCQrDi
         x1sQ==
X-Gm-Message-State: ABy/qLaWK9wGfNSv3yelDe4cANkL2nlMvypBZBNsbP0IelVsX+t8PNXW
	B/TdnaCYQaYp33HxVGxDHG4AHa7p9UkDFTUsaTJr+RSunxV0MCJd/8Cbi0wrh6/qIRaMQBFSPZa
	3RB4lEK7yNf2igp3YkymgPJjqe7xiTgxLK4KAHTSRhWknDR115b3j6BiE/P4=
X-Google-Smtp-Source: APBJJlG9mEIQqKuVO0Bn8OeuD+f4ziboDLuWRhnbM5CjcfhqcRiuIN0erx5o2THtvR+NBQjz9dqUcePOjw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f249:0:b0:314:10e8:b01b with SMTP id
 b9-20020adff249000000b0031410e8b01bmr56671wrp.12.1690202328250; Mon, 24 Jul
 2023 05:38:48 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:28 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-8-tabba@google.com>
Subject: [PATCH v3 6/7] KVM: arm64: Fix resetting SVE trap values on reset for hVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SVE traps are disabled for hVHE, if the FPSIMD state
isn't owned by the guest, when getting the reset value for the
architectural feature control register.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5941f6dce49..adfb7d0ac55b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -588,6 +588,10 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 		       CPACR_EL1_ZEN_EL1EN);
 	} else if (has_hvhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
+
+		if (!vcpu_has_sve(vcpu) ||
+		    (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED))
+			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-- 
2.41.0.487.g6d72f3e995-goog

