Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957712E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tU3oQrjS"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e1b9b10dc0so38610087b3.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548136; x=1703152936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Da8PEljTHFtyAdAg/eiKbw+wWBtYdo/VV9CYke8DnEQ=;
        b=tU3oQrjSEWCrl+s3rTgGvnBlSBDt3IhokOnH3SWzQE0GMmJH/46a6hvpckmFXUs7le
         W3p0VIfuDZQKcYWxdL0U3mo8fYJ4d+nLu7kj6sF0hUHsYKe3A5OiFm9io12pNpF6MUIk
         0gtI6kqW5bfGCRzlKXPaCqdBWrXLrXM1gd/FA+wduiv//i0mDtYMNexhN2CeGkSviAkV
         MKCdYU14P93MGqIzc0f7Wd5pcxzfniVXn1AnxFj3Ei2wHEummgt0rjeGl5u4erpZBZG9
         jhXZvjYdL5SZaVB+Lf8NVqQduLdqOWWz3dZr063Q8ra9WfdaXSl2AgSQD5Mf0g01GUuo
         BVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548136; x=1703152936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Da8PEljTHFtyAdAg/eiKbw+wWBtYdo/VV9CYke8DnEQ=;
        b=PwUpznsDRpmahnN4KcHnqhFm4ZLropghN3ALqdYmH1bxzr2EDgaE6n7HZIqjvhvhpI
         KQab+pPLp7Ydn8uoWKJBFChh1EaZtAmz3g9jyRmGdoUFLuWWOiPa7cjspGnALVnmq7NF
         9bn7ZHqzPNGU24lqitmGdXauJOqaGJUxIbDoXR38bdKU3H8WiutopytYIWS9YAeSbslZ
         z/hCmkGIlswOwZSDJFbOYEfAGPsZXFhzyOKmqHvW2aQ4VA0VzNdCdVNrmg10geXCSxdv
         93PBkn9VYnc/h5Mj1ZUE73sflTNRUTR60ys/ksLez8asjT+nhLKXO8TpAW9ZSOTchFxv
         56ng==
X-Gm-Message-State: AOJu0YxN42z/2VHxL0ru5HHdjTeN3EGYa2iF1vkWU2G0muuJ5nKejWON
	pkyjt5fLJV+LoVUQ+j/FUcW0vyVllyahuzOPb4sN3Tlo8vJpIBqoQRThqGv6369nAqjx5pUgwX0
	hx7/PvdjdvLTxfoEM4TalBycV+umY64NL6+Gpv3UtOkPpAcvHFPh+rm48Ip0=
X-Google-Smtp-Source: AGHT+IEuw+3Pg+LXmSjMTI015X5o2FNJIMfMU9lFQxidELjvY70BfLIQKtuu/0eWkY2P/YRS+CobhfzYvw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:185:b0:dbc:c7f0:7c2e with SMTP id
 t5-20020a056902018500b00dbcc7f07c2emr50863ybh.2.1702548136159; Thu, 14 Dec
 2023 02:02:16 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:47 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-8-tabba@google.com>
Subject: [PATCH v3 07/17] KVM: arm64: Add missing HFGITR_EL2 FGT entries to
 nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the missing nested virt FGT table entries HFGITR_EL2. Based
on DDI0601 and DDI0602 2023-09.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8b473a1bbc11..89901550db34 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1117,6 +1117,11 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
 	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
 	/* HFGITR_EL2 */
+	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
+	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
+	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
 	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
 	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
 	SR_FGT(SYS_DC_CVAC, 		HFGITR, DCCVAC, 1),
-- 
2.43.0.472.g3155946c3a-goog

