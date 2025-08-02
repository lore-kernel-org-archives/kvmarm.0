Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A4214204
	for <kvmarm@lists.linux.dev>; Sat,  2 Aug 2025 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754131093; cv=none; b=RsdO9xvYU+JZIE6cxENRdkp89qrtPKO6V7C9iUHGhzmDVdNrQM3uK2o3NwYb9a4Z8y/dUu5Ywv9ULvijmZAhuTXb4qRx/rPa2yc0rkZpcO4cfBbxSI14egB+Mn6fQ751UBhOn1d+hqmoJWo9PvMh9iSQthBhrCph4pp3tun5mhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754131093; c=relaxed/simple;
	bh=78NVjdNVPg30hTJnbWBWyc33Oq0igcvoln/WVrBhAt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RWkAQuVEbpA/EbwWErhu9L5n9NsYbUUFcfh8YEwp9xdLVLBLJlnTjLuMaloBQlCw3MWXbKfDhzzY3zYm75DexdMW2PCLhj5eYRCNGpCwLOcOGPszNquFJqk+JAho8u1H4BdWyQXk+RWAXLxJLqjIImQh/a7mgbu9CXOwb+GbUh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=DnxyNdlP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="DnxyNdlP"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24041a39005so12122175ad.2
        for <kvmarm@lists.linux.dev>; Sat, 02 Aug 2025 03:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754131089; x=1754735889; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G63QXIxj+Dtjk0K95q+UoQIrd3RUwOdJawqBP/rtSGw=;
        b=DnxyNdlPOhYGDHUJiVPTajf3Rb5yRvxQrD1T6ChQtyHMJdDUobSOiE9IgYqXbXkDHl
         DXR1CY0Oedk/O0HX3h3b2nXuE4VIGjEuaf6EvhS7CAqUE9qFC+EgGwhuBahjkjow6f2t
         U1+3cINYjmmWfk5lCi2TPmHCxg4ZgGUIX4vPVnNKOnTJJLVnDyzFbRJpfMOLU3Ub1srj
         LXo23uNq6Wc7Bful0Bd/7x4g1kcZovTpCJc/d7wjSmsdngrY72eGZjle77ogd8wZ74fH
         lBNEPF/8s5s3HcGq55NBdgQKNiAP0X/CV4/Evg0kTs/E+FlqviHi65Lu4RvOubn/rz0+
         hdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754131089; x=1754735889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G63QXIxj+Dtjk0K95q+UoQIrd3RUwOdJawqBP/rtSGw=;
        b=xTxcubM65Mg+kiErI7KsjT+UBCdu3Upbp1cu6u6WfJQD9+BvMFunGsBbFRWKt+CYJ/
         YasDlRY3LS0/JmrcMQ2xNTBMe7XESAmHtIy4RJqLgQrPr+N1NaxMmZxiaEWI6zRnLrwl
         gj/qrGNDVDFE4EtiUscd1j2YpdbSOMFUfw2yQiL3FlH9UsoV0k/rbBnOzx2UviUniIRh
         DG22rVtXKZXJ3CrkVA1JCf10sfqPf6ftjorV807SVc1SjgL7tutZsICjMjEMwiA9o3o8
         Cl2TktZTCeuWlZMaI8yhC6Febtg29Iy236Y5yszrJhxYby6T6+qcnfIalyHUq5s7Vona
         hsuw==
X-Forwarded-Encrypted: i=1; AJvYcCU4CO5ikJhCxmytdNQ/dhjKBfJ/6ApM2L0qwlXKkezE2qAsIVUbIPR1h66ANahrdiUYBPJXhAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM/l5ki9xwfBr5Pt9da24lm+eVuZe8UogJd2qqMouf5JZWUQNi
	WJpDv4yWM3/Q+JQJYFPVtsFBxD54b/BKtrEczkl8MtgxkcXWMoAMJAcU1/8Nm/Lq68pf+GTN1N0
	YA10cVwO11qeB2/5lnY+DlRAzs5H3/J1PkV02n7I9ASfSTLeUkds=
X-Gm-Gg: ASbGncswjC8NeNN9FUosl3J70MU7c2sia6iMEaxyAzPF5cL9jY6Igru3b8g33aokn1+
	YQInSvyLhzNnZPMH4eas3x4FfsG2WelR6NGVYy4a3zuB1QEW0QViCAwnm8hBEjAVA/t8H7RarbV
	f+rLXJcyWpF/DXtiYf9NlwRKiFyteoIlyZy08+YfgMXso204rlyg5r5HJ5+48wmBEvH2FX1zZzg
	gTXDaUSjMyHE1XYjoJOvB78bk7fyDdozNsp6KAnlhyCWy4u73FNrZxMJu3Au1LF80XfR6t4MRLr
	XOMj17Omt9cPgOFWsC+VcFxC4WhJwcSWdOMe41DNtNuc5WFVCtDAjKRQJUucmACpG5JewRvFUXc
	sRjx+Rgvg7PzsTHvHUS6bR2K8m/5f7Hx5pU2hzthkxjEaRpsZMIA/ewZLThTa
X-Google-Smtp-Source: AGHT+IET2miJQcQuyN4A48qXGASFh6PFQlmTNZHqpeRrnOMmptg7WMuDBI8s0Bnz8/+S9PgeZ151wg==
X-Received: by 2002:a17:902:ea10:b0:240:3c62:6194 with SMTP id d9443c01a7336-24246f6a8famr37337425ad.20.1754131088712;
        Sat, 02 Aug 2025 03:38:08 -0700 (PDT)
Received: from zenbook (1-162-100-196.dynamic-ip.hinet.net. [1.162.100.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aca205sm63963445ad.193.2025.08.02.03.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 03:38:08 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: ptdump: Fix exec attribute printing
Date: Sat,  2 Aug 2025 18:40:21 +0800
Message-ID: <20250802104021.3076621-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

Currently the guest stage-2 page table dump has the executable attribute
printed in reverse, showing "X" for a non-executable region and showing
" " for an executable one. This is caused by misjudgement of which
string gets printed for the executable and non-executable case. Fix it
by swapping the two strings.

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
 arch/arm64/kvm/ptdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 098416d7e5c25..99fc13f1c11fb 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -44,8 +44,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 	}, {
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
 		.val	= PTE_VALID,
-		.set	= " ",
-		.clear	= "X",
+		.set	= "X",
+		.clear	= " ",
 	}, {
 		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
 		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
-- 
2.50.1

