Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796592E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AKdecgNn"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3333aaf02b0so7127203f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548132; x=1703152932; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iO5cgv8s1+7lRn9EEBAbuMss8Z8UN6A/g0VvwzwiLdY=;
        b=AKdecgNnnuGI6T9B3Gsdzw/sAJ/s5iXc2leg20c1DSYKZmJTEzy81LvrH4Qxger5ea
         amvoTxxyc114Qvi6D/Aee+D8SmI46bZZNFGI5ZW5PwF0bWRUaayXlz8IUFSRId9rGE0Y
         Gzoz0fwEF8iCr14Hh+NrogCBKhwOqvytiULbQ70L+vmMIjrxkB503St6N/zAxByG44Ly
         SQRE/A74rvP9YK8oZUxGffsdbJe8iWjy6DDyGRz31Ehq5r/oXmqCJejX9iA46mqVK21w
         0DuVQbcI0W/lGSA1CeC1VYPyZIzGNe//nuT8awchNuJPNXcW855uGIgaKDyr7eq7mzO1
         EpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548132; x=1703152932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iO5cgv8s1+7lRn9EEBAbuMss8Z8UN6A/g0VvwzwiLdY=;
        b=JwACTv9A4rOfkH2TJw4iUhRUuinnKb7O/6o4LqPwTgnwg3fmMWud3wfc3q0a5EKp6A
         9WmWQ8zpvzOuSnGQBHGTNq0QYTUScdBxxnevgFJ6yRi7I/iuUIPOEfVWucckZ4RKoABO
         rRxZq8FYkK3pGzqXtPC7RKLWTFLdTkzexIgrWS7SzGaeY6OOQfdqYbiU6vLIzcqh0v8c
         ZdP6cV3s2xMboqxydutM8o1b1mnvMJeBXw5+/krIcC+Ir+hYy2bXGxCsWW0/2gUcZJpE
         htsfMHEGyItHOaieuxnxoimVY93tJvmKHhsAN8oGVAVaUR9pusTu8JRbUNeHpAhh78yz
         d3Pw==
X-Gm-Message-State: AOJu0YyMY2avFW/v9hxs7NR4dM50oLIEYMvfs3qk5KbNUlTheXODhs5o
	AiJP7OLmOyNtPRTy/QHDSOlZZXxC9JD+vl2I18pXm4FQ0fO78c6BWfZgimFYgNKSYysHuYvd54D
	S6kIO9xTgUvCHzJIffDti0n0qV5CYRxM6BPBi9BRRkKBAD2/POZC0WxGUZEg=
X-Google-Smtp-Source: AGHT+IEKuhuE+8t070Z74NIEk6C7Bliycci+lz+5qRu4aMv9bjpk2q4FwL5YoB+4kB4l2qUOVyCBpGx6TQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4b06:0:b0:336:4a97:9f70 with SMTP id
 v6-20020a5d4b06000000b003364a979f70mr1368wrq.5.1702548131670; Thu, 14 Dec
 2023 02:02:11 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:45 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-6-tabba@google.com>
Subject: [PATCH v3 05/17] KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Do not rely on the value of __HFGRTR_EL2_nMASK to trap
unsupported features, since the nMASK can (and will) change as
new traps are added and as its value is updated. Instead,
explicitly specify the trap bits.

Suggested-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f99d8af0b9af..7b4909dfd1f5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -110,12 +110,15 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
 	}
 
-	/* The default is not to trap anything but ACCDATA_EL1 */
-	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
+	/* The default to trap everything not handled or supported in KVM. */
+	tmp = HFGxTR_EL2_nAMAIR2_EL1 | HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nS2POR_EL1 |
+	      HFGxTR_EL2_nPOR_EL1 | HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nACCDATA_EL1;
+
+	r_val = __HFGRTR_EL2_nMASK & ~tmp;
 	r_val |= r_set;
 	r_val &= ~r_clr;
 
-	w_val = __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
+	w_val = __HFGWTR_EL2_nMASK & ~tmp;
 	w_val |= w_set;
 	w_val &= ~w_clr;
 
-- 
2.43.0.472.g3155946c3a-goog

