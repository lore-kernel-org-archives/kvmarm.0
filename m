Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61371842
	for <kvmarm@lists.linux.dev>; Sat,  7 Jan 2023 09:47:04 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so7742914pjq.1
        for <kvmarm@lists.linux.dev>; Sat, 07 Jan 2023 01:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xg/n7KWUh512YkFFVRRUXhVVh0fTVxc6svqLIUhoNiQ=;
        b=0I34P5jJlo/nvIXTeYrk4L5+O96rTMlwJ7WfyGOBNeCiyIOR/qyT6PW/FixkUUG1m3
         l6OcWphnyNzjBSHkuF7YsMU1kTgtZrkzDqAVgsOLsrqt/OOoX+VCqYWvp+G+C6QBygb1
         C+qTUegaPeODZ89vA3BSBEYIySlSW0jgD36dk0e4iyfVrPGWgTzrDpHcOosx1ga5dcJE
         DhJKw5qDaYJdE2y7GU1dyvC1GCgElSvN+W+EC2BkZRxKjr/Zplg+safg/Sb5Lzcnmhlt
         1fDRVA5V8zW3i4VcDdoAAuc2m173pFgpmeQ2sImfO5gecqdrybO/jv5EKapreU68zyaO
         uDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xg/n7KWUh512YkFFVRRUXhVVh0fTVxc6svqLIUhoNiQ=;
        b=vZ+etw8++OZucYh3LrfO9oGYBMWl5blX41YS9w0ReeULMIk3GBo70f1gQQ9TPCA9Vz
         mTQ5Y0J9rA8loSCeJM8dhLHJzyOiHlOVwTpYBKNcTzsDKe/kFcB4rkQv02opa5+TUTEo
         xA3GRTWGanZ8T9QOXUgrG1FcYx9ugnrIJNyMyMcVnzUxDDZMAUdYKp5G6q3bntxQopMa
         rJirsGj4O8I3W0o/5xHB01f51EElysvu97+lFYy/oWelAgNAHc8bnh47xKYO3wSDPqtM
         sYHDrA96VVobxk5hR7hbeDEpInk591mpBB49sI6f4KZGEVNFy/jECmRj6B+YxOJwb3Da
         jCuw==
X-Gm-Message-State: AFqh2ko5XJ8nfme1bO6uCZCf7leoTtCO4hBD8FnX9xkfvx+XcW6DZ4Xn
	wTLZFWia4f7CuevFHck/xnYPgw==
X-Google-Smtp-Source: AMrXdXt2FGAgxR9arR4ysw7S46BfkCKb4vip2gayWL9RQ803JqvJKtc1hGSoJT4gx1OOm3wZy6CdQw==
X-Received: by 2002:a05:6a21:1506:b0:9d:efbf:813c with SMTP id nq6-20020a056a21150600b0009defbf813cmr83882135pzb.5.1673084824363;
        Sat, 07 Jan 2023 01:47:04 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00183c6784704sm2263449plc.291.2023.01.07.01.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:47:04 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v6 6/7] KVM: arm64: Mask FEAT_CCIDX
Date: Sat,  7 Jan 2023 18:46:28 +0900
Message-Id: <20230107094629.181236-7-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230107094629.181236-1-akihiko.odaki@daynix.com>
References: <20230107094629.181236-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CCSIDR access handler masks the associativity bits according to the
bit layout for processors without FEAT_CCIDX. KVM also assumes CCSIDR is
32-bit where it will be 64-bit if FEAT_CCIDX is enabled. Mask FEAT_CCIDX
so that these assumptions hold.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/sys_regs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d5ee52d6bf73..5617de916c80 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1155,6 +1155,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		break;
+	case SYS_ID_MMFR4_EL1:
+		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
+		break;
 	}
 
 	return val;
@@ -1718,6 +1724,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
@@ -2219,6 +2226,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
 	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
+
+	/* CCSIDR2 */
+	{ Op1(1), CRn( 0), CRm( 0),  Op2(2), undef_access },
+
 	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, CSSELR_EL1 },
 };
 
-- 
2.38.1

