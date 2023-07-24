Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E96AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:41 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-cab7304dcccso5020710276.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202321; x=1690807121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvy0wc++N/cptPkBvCZEeJZtE4UusLj3ZdBNfN3A3Tc=;
        b=H2w2u8k2UTHRSKy4i7uROfZKq8tAgOuthH9ltjCbqp8rJAKWJwhN9ALORrurnpkCZ1
         1vSqzuoasOEvY9iSy/sM3SZxdIFXlY0/3mU0vWCmTYZmnY7f8C8EPitR+zI9X2033CBp
         olVHdM3q5+OcK7S3oN7uIfaQgHWmGFSmFJkmFja+JNSZiDB1dzMer6RolB0a/dxOakuU
         GjSwaf1uasS5oktMoMKvDaPFPq0rF+wQZZSPoKfyWbAXrt3FgL3nqCymzbOfsMcReT7j
         JZrE476vgACTEPjuyZGjKdcwwZOSo+KqqGAfsDZYoex1b62AjKNTyjctDaV7/Y0nHLa6
         vH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202321; x=1690807121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvy0wc++N/cptPkBvCZEeJZtE4UusLj3ZdBNfN3A3Tc=;
        b=ic6nLbxkIj4meJLNtPgEW46gYoAWoV7rdc57kokDUIsNsm6tFjFz9UCULY3gR0a7RA
         Fv7GpI1br9ydeN7Bq8zG69EjEkVp4pMNWjo8kERvi6daqDdTskrL/2ziUp+Uj4kfCEjY
         lnDAtCkMybUb3M2SfGOeu8piCnXg7MugUnhu87qB81SvM34uFnrq0Ei9+h/wWRIUEfrC
         5RvN1Ra7JLFglRXfzdbDMCDmCJCtmO7GudsSxM0q7I6VZ/Gj4NpSIqchxbVvdXZe5utp
         SZCYu3EUq6Lku+FbXD3gDCDvyohKxK4YGPGkh3WXJhAk2dYzFn6luITxzvVKOgW33qqo
         XRAA==
X-Gm-Message-State: ABy/qLZEpOjPWnNA4rW5JkrW5uKmk8F1xVswaNQ89CfGTQuq0Vgv6sLC
	Dsj5ovvD6qVZK4lWNFKKdrlcRAPnTX/dc6V6fzTkalVDnWiGHCEKp4HiYKsu7lp92cMiJTjJH8p
	RG9PecMGqwonUCyufbusZSC5dPiLGyQ6Bga/5aNGnU1eGRVL8ZHPYkQzTe1Y=
X-Google-Smtp-Source: APBJJlEceQLSZnOI6mlFqcjfeTXE1C6u6d9ts0u6nL9i8jTIssrXKMl//H4kg1+7c1PUN/eH7NJUSQsWmw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:8182:0:b0:d0c:e71d:fab with SMTP id
 p2-20020a258182000000b00d0ce71d0fabmr26266ybk.0.1690202320821; Mon, 24 Jul
 2023 05:38:40 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:25 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-5-tabba@google.com>
Subject: [PATCH v3 3/7] KVM: arm64: Disable SME traps for (h)VHE at setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SME traps are disabled for (h)VHE when setting up
EL2, as they are for nVHE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 41c5b02f38c5..b7afaa026842 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -293,9 +293,19 @@
 	check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme_\@, .Lskip_sme_\@, x1, x2
 
 .Linit_sme_\@:	/* SME register access and priority mapping */
+	__check_hvhe .Lcptr_nvhe_sme_\@, x1
+
+	// (h)VHE case
+	mrs	x0, cpacr_el1			// Disable SME traps
+	orr	x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_sme_\@
+
+.Lcptr_nvhe_sme_\@: // nVHE case
 	mrs	x0, cptr_el2			// Disable SME traps
 	bic	x0, x0, #CPTR_EL2_TSM
 	msr	cptr_el2, x0
+.Lskip_set_cptr_sme_\@:
 	isb
 
 	mrs	x1, sctlr_el2
-- 
2.41.0.487.g6d72f3e995-goog

