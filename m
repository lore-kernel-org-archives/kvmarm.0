Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1FD4D58F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zuVAmp0f"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db084a0a2e9so4562254276.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771775; x=1702376575; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDTgGGybB+AQ7IGaR2Nl07imJwzSaW3qApqntwyoxR4=;
        b=zuVAmp0fJ5KNslPACxoYlr0qjVeHQ4/NTNw6Uq5A1V6ktnrQfPVA7NSiG4IOh/7MR0
         qYmYkYis1aVBD6pNLd2dmNH6fRijJVoKwsfQZCB49pkCW1GCf6guM+ufuqWGAkMidire
         X0GrPDNJ9KrAumK0uzsgnbzRoalhXHLeDsP9SiLU1FuObPHh2N1pLnbJo8SRWZwSkmId
         Eilzm8RCmzmwBtqO/N5VWesIbJMqNw3ElSRYs+TiTV68NRtSZ26v8dRoFqybmLLr0Az/
         vL5AqXcZKS5W/dJye1iAqqmKsQT6HwJjj43lLjv4g1WcJwJCGuXo3Qt7GoxwQ+ohbgyt
         HE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771775; x=1702376575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDTgGGybB+AQ7IGaR2Nl07imJwzSaW3qApqntwyoxR4=;
        b=ioEq5GI0/fQgeq/b+Yjpf6qbEc+1YgGdoomKZqt97y4OrEQBNKIznCddBQacr2czjg
         t6HScW7mgm1qIh2wgp0+qmcGlwehaXVPVSZg6MP3b4lxDwnRrdmtTLpZWlrSzYmwndqW
         hclVVPrSR8OeugJaQyiSbqERqHhp6UYbELPuuPoaKGbQGKewe44dXDq1SGGkCmL8M3Ad
         amEzZHzI5s9010LV872Pj+MorcdjAgpgg1fa4hTrWvuFaZm8X8v+lczfpMAvdnSLtXLg
         kw4fepbsXs5gv2BrL2EwOatvlt+5b1TfTpzuYUDyQYfWUtKoeZ7mns05VYB6VkmgBHYb
         uTPQ==
X-Gm-Message-State: AOJu0YxYwakhboIBAS2o30wTBOEV/LlS8S+NFEc/hIGieIRcy6HVcXCN
	bNI1f9+WEnnWoAQfffNjAGf97NmPzCOdETi4Y/gcODbuyjKFeDqewmtH3OHOQOhVES4ufJH0ZnX
	IW6HPyYxZeewkqrUAjvHXZ6yPPY3WmKkfsQuKuX648iIyxzlSAj5woHzlubU=
X-Google-Smtp-Source: AGHT+IEEGMURNx/6RxJeYsi5qiSPq5a6jKcwLZnJ06ABD0oOVTg9rCRSj91Ag42H3fpP8C2xXhI64oWyuw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:6f8b:0:b0:da3:b4ef:29fe with SMTP id
 k133-20020a256f8b000000b00da3b4ef29femr1098953ybc.13.1701771775107; Tue, 05
 Dec 2023 02:22:55 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:44 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-3-tabba@google.com>
Subject: [PATCH v1 2/6] KVM: arm64: Add bit masks for HAFGRTR_EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

The HAFGRTR_EL2 register isn't used yet, but it will be in future
patches. It's also the only FGT register remaining (not including
FGT2 registers).

Add the masks for completeness and future patches. The definition
is from the latest Arm Architecture System Registers xml
specification [*].

[*] https://developer.arm.com/downloads/-/exploration-tools

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b1061647e837..b0dc3249d5cd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -379,6 +379,10 @@
 				 GENMASK(8, 7) | GENMASK(5, 0))
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
 
+#define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
+#define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
+#define __HAFGRTR_EL2_nMASK	0UL
+
 /* Similar definitions for HCRX_EL2 */
 #define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
 #define __HCRX_EL2_MASK		(BIT(6))
-- 
2.43.0.rc2.451.g8631bc7472-goog

