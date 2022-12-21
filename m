Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702A33FB
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 20:40:50 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so3594678pjr.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 12:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlWUJTvQq+dZLt1EiuVf3fldzhye5smOXD/qjtYfqYw=;
        b=cnS90yFkMSYqf1fJvDCslqRqWI9XecMY7K+W7HEgUppJd56KXhNrYd/fTP7vHdA8wq
         v/gTFBNb5//ZkaCm1yJQeiCwdOGrBVbmk1wBE/38SCK1iSWxyHm4T9FpkwES7qKk5y4/
         R7avY1YkvmXWqT0M/2e41ih4xHXll/nne6xvkJdUMTnYJ4r4x37dYqVxUe7l/SF+ns0F
         K7jPEiik5uNjU+qXfnG+k4ycvuxBfXnFd1TAB8lKjzGIJ4O4x0cwIPnq+Vg4K8Waqgbx
         NrXCxtbTxqVtZn3fbPxKEP4gl87okYXy9QVmHaS+oWh7R+HAB3mKkhV0KK19rI0bgjv+
         N13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlWUJTvQq+dZLt1EiuVf3fldzhye5smOXD/qjtYfqYw=;
        b=zAqvCdb89Q2i4zZ/ZgTUcaiU9SsLbMNXmNBnCKtXWsJt9+izfD55LID2i7oj5Ykv+1
         seCVXw4uaYtjZ1mVE2FOt0XAyMuq20WvUIJ8LE8BXLz0Slb+6qhwl+tBISSh8N6hPB4r
         RcRoKMTbKZTXFqQZXeE5BdCMRvzHG2bnHDFSwtQFXixBa9MuxW6ZbTnpz9XXFdYWwEuD
         NCRMqi8nt8x4fBY8YvrCCBg7DKKwM+B6utJkkOPyj31FNUQbmmr+F1PsSeB/pidvlVKu
         PULytRvKJXFzqjXoIiIKMwIefCHNaUHf/Qb7vLWmHKzKNgdLPbD/iDKpmkCOot6uYRey
         uizQ==
X-Gm-Message-State: AFqh2kqR8O/HTCHKMg9gPgZNSADBuWSBAP54UUaKzz3pZs1/IzX88CQX
	mpwhXs/rZ2O93k2ZySphxAxdGA==
X-Google-Smtp-Source: AMrXdXsV5Jl32Rh3foVUgXPCsZHnUfIjeIK8Q46LFotcnssb//m4oLdfOaYs086TxCiv8YBDTcpTzw==
X-Received: by 2002:a05:6a21:398a:b0:af:8e92:3eeb with SMTP id ad10-20020a056a21398a00b000af8e923eebmr4823145pzc.9.1671655250012;
        Wed, 21 Dec 2022 12:40:50 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 12:40:49 -0800 (PST)
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
Subject: [PATCH v4 6/7] KVM: arm64: Mask FEAT_CCIDX
Date: Thu, 22 Dec 2022 05:40:15 +0900
Message-ID: <20221221204016.658874-7-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221204016.658874-1-akihiko.odaki@daynix.com>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221221204015.1Uf8zos7TKVviZ6Kj9nc_9DrJqKMGg0HxnI3q0PH82o@z>

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
index f4a7c5abcbca..aeabf1f3370b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1124,6 +1124,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 						      ID_DFR0_PERFMON_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
 		break;
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		break;
+	case SYS_ID_MMFR4_EL1:
+		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_CCIDX);
+		break;
 	}
 
 	return val;
@@ -1605,6 +1611,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
@@ -2106,6 +2113,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 
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

