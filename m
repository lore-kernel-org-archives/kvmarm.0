Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E32364DE
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UERcparo"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcdf587bd6so955764276.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548159; x=1703152959; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ3NwtPLUek23R4jO5ryAbc+RXV6V+XaVPuMrIGMVy8=;
        b=UERcparoTnQLL6wASdJsbR9rk8TKseLyVUX07oAuBrIVtG+KcTfBzC1aN2N28W3B2D
         NzYNBxEwx9lCsD0zjOHUMgRjkLshO55M5cFSdXMgOOG5fZo5r76UCvGVPx0LPtWUUcj+
         UkZ+XpiNM0/dUnoAEH1dShXAK3nDYCTyxAvwcbb1jYM1jn7gCscBHAWE4N0Y3E0mEtX0
         3udpW32te6zzWyk0oRZ0LSA9zZlyaAh8Bb+eywb9/foafcSEWs8Vvd6VlvYZ5qyu5kWH
         NklK5zEQb4mRSev97Qk2VBW5OV+mo7PJY6uoyu26gqDkWzXIWM2h7nOLGqUSJK+6m6WH
         LEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548159; x=1703152959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ3NwtPLUek23R4jO5ryAbc+RXV6V+XaVPuMrIGMVy8=;
        b=WQpvzSTjG2KnxsCFt263oW1J4+ZluWT8yLzAkVD1bbdhMKPQgqIBYsaUTjiOconfMx
         5YGHY+89wYHb6EHhRK8vr+dYbikrXCdpxLpolRs85L8Rxwq4LoqKxTzEoRcG4gr8jbj0
         UB4CeF5776qfjPmIMBsIp4lPpHguo9/fW3GnVbsYZvT30EX2l78UGaGNBSP2R9BqABhz
         r4mtM5Dexj2ViOORy+NoQbatZ2menoUqtQuPtnu6pC/OyC8OVMchbE7G4ItkczdR4Jlt
         VG4D92DRcleLXvv6qfJHM5IjojwVEY2tlnfAjV93W83ze2JoWKZO+/MybSH6hzgKEzOL
         nsfw==
X-Gm-Message-State: AOJu0YxQhjZpH8nJgzNZf4CLwVnC2+jAAtKGxUr0DsaPHEzGQzd6sBXP
	ilKm4Nzbt1kg6q6ZPr2atV8np4IJYVSYXZBycftPQZ9DymstW0ZZ58oO18Iz20gIUxJgOjzsTx3
	fOxXRJAqHjZU/cbGD4KKSehIZ/UlaczFvePC4q21+7OO/3+rvgnPA6ofozuQ=
X-Google-Smtp-Source: AGHT+IFegaKEFW4myHOQsqPxjgTrzClJ0RE+4TCPqKKb1gBoPmBB99hEXMdBnUjfibDl/STy1jRxn+C/Ig==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:8a09:0:b0:db5:3676:74dd with SMTP id
 g9-20020a258a09000000b00db5367674ddmr102624ybl.3.1702548158582; Thu, 14 Dec
 2023 02:02:38 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:57 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-18-tabba@google.com>
Subject: [PATCH v3 17/17] KVM: arm64: Trap external trace for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

pKVM does not support external trace for protected VMs. Trap
external trace, and add the ExtTrcBuff to make it possible to
check for the feature.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9d23a51d7f75..84b5c3f387d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -136,6 +136,10 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 			cptr_set |= CPTR_EL2_TTA;
 	}
 
+	/* Trap External Trace */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
+		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
 	vcpu->arch.cptr_el2 |= cptr_set;
-- 
2.43.0.472.g3155946c3a-goog

