Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C9B2931CB
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786323387; cv=none; b=tUeaaSXCV2QK05JUS1+cdOgT51Xux32yQZFx+L4vftQc93/4K0pj9dVZ32VY3srWry2tYXCmocUkU6sO+ditIcmjJvxPlSfiP1ploMXkcOltVtMr/YrxSCsBKv0Z3wXux4kB5yZZzWMdD6OMtODFNbM2PDKKGgTsCH4DtVlkrVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786323387; c=relaxed/simple;
	bh=rJry1y/C4IOyBGrEJ8k2O+n8bSkoMmhplCKSO/Vr0po=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dWZc+lpaGY2En83QXVWRq9Wk3NNUIka1WvDH/wJ4CxXPwAFNETmSnXFIz/lSeREIJGhow/Wz6y9fysjiVELd22S8yEZVDaZ2pPFkbVCAD+oPYv9h3WjQr7W6ftUX65MUBQi1tcRFK8yXY+/RAdVxB5gcTP4c25R3uHWOWFWasTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gaVYZ76c; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gaVYZ76c"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-495437bb891so10389715e9.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Aug 2026 17:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786323384; x=1786928184; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+bCXqXiVHaA5FZ3XKQFV9NmmEszADDHeGAjplPg15vc=;
        b=gaVYZ76cGf9TQCY95kNNIKMQpP42R4PiafFI1bJ9FVnnqXREL0NhFc4fqWNqCfY5OQ
         JTnF1emHnFPF5wku0FA2YeUFG9D92Uz2FzM1f6/vJbBvod7tyf8VyM3b/rQhbS+gLzRx
         CSGdaN+AWLhaH6ar3Ze45u13d8ccfhVI3kUdKZR4seDnRV2ZnEJFuVssRRmetFJKJvIA
         CnE7t2g0hiOtS6LrWZt/dr7tQioa8NhYKCbU2PiP4B+3hS/uCaTc1jSrRgn8o1a2rrcf
         TpX/eyxooQGNoyi15RXOqavq3MPwGt3FTM8jAjtTn47aKzuFPtvgBMqNJlUVYI5inQeK
         4zcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786323384; x=1786928184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+bCXqXiVHaA5FZ3XKQFV9NmmEszADDHeGAjplPg15vc=;
        b=M1TwvKHm3xDxJId7djHAUH3pfI+Z256oGSZ/Cezr0avTh+8rNPdBw4iMA4Uamq/T5c
         vH44s3QQbTRIhoeHnhmYLKaH1ZSw9DeMeCiLWugU1SVYUT901Sqc9+Styaf/i7Q/ebJB
         9f2MTLvubAS3cbHQ6L39Zye02PzuNgbaElAoY7Vu8DPTz27iCNokYuvm97SS5oK7BgHu
         7n+KWdkUogyLuLEZykrtebA7UqAg8RqCqqlotcHFjhdglbrOhcy8HP8euediEB3hqDsK
         3ds4RPB1Q3uQjZ8zmzZms0+8p+bQQlSAsXBxS+6xdJQH7KWBXRYbHK3WW7ygQDcEWhrH
         Ei7Q==
X-Forwarded-Encrypted: i=1; AHgh+RpBRWUqfeg+2zRE1QHdkqD7h0s2YYuB794a/lyG3kEtueSa0c4trALNX74bcGtimwEDZjrYf9E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzH+Dkd349DTl1LOSmmWpbZhf/0bCOa9+hR2kXFXor4RD3AAca5
	wFSc/Aftrudsg7mVrk0vZGEXXCK/nf+KVllZT8Ocka46gnVTxaB7KpXz
X-Gm-Gg: AR+sD137Qm0fTW8OpO9Yw6vrEVIasI5+y9jbcJkEc55LkMZ+py8QP/hU2C8osZDIxIy
	/wuYI0hO+16RC+tGVTVYSeChEsoHtH+Eq0HfYvheDskpvsT1563yBhFZ1cjuE445QsWAiYysH8q
	g15b6cFSHRMwVI8mRwrMr0aC51aa/+se+qX5gj8wgTtFG5XH25t/O4RLKqjgBgXH9Kbn+7Lypdd
	7xVQinGwjEmrAN8uHnsYVMpe2yqKAziQ62wJTdQs7v9FCl7V3Rdq7VyxRV7SElqLn9UsWUFD1rc
	LHz+3SyTAWk+JQpNhmA6ICAyv3LQv0JbehkezNHtWwlFDW7efe0u/TBEaiY3qYQtmFRMB0e+vQC
	clp40PuL2HkLdUEeZNt2OhhRJMMta+oWe+1kcUSO/RSKKMHFkgvxJqEH+wIbbChrB7kPhNk2QS9
	Tb35bQNfOn08YE3NQ/8tlyJ+R8xHObXV+Aygwjplgg2Omu30tkrIR7DEEek795Jsc2AmWgmKtJI
	7ndEcD4iNxsPT8hDMkmYsYq/+hBvxoey9TFMkGzqt814AlIokADsJovTXuSFBYCrsW2y6ZIJZTM
	WrYOcQf03dvQ4WHjeMesGnh5pWxoVIJgX5rXZurevE0GwO+b7lt1dhLPY9zeHjFiTftf
X-Received: by 2002:a05:600c:c87:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-49962472d69mr139626325e9.6.1786323384059;
        Sun, 09 Aug 2026 17:56:24 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ac88-a501-9c5c-9666-3a00-3cdb.310.pool.telefonica.de. [2a02:3100:ac88:a501:9c5c:9666:3a00:3cdb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995422016fsm302405405e9.8.2026.08.09.17.56.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 09 Aug 2026 17:56:22 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
Date: Mon, 10 Aug 2026 02:56:16 +0200
Message-Id: <20260810005616.13227-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The consolidation of the breakpoint and watchpoint register accessors
switched DBGBXVR<n> from trap_bvr() to trap_dbg_wb_reg(). The latter
selects backing storage with demux_wb_reg(), which only handles Op2 values
4 through 7. Since DBGBXVR<n> uses Op2 1, an AArch32 guest access hits
KVM_BUG_ON() and marks the VM dead.

DBGBXVR<n> aliases DBGBVR<n>_EL1[63:32], and its AA32(HI) descriptor
already selects the upper half. Map Op2 1 to dbg_bvr[] alongside Op2 4,
restoring the pre-regression behavior.

Fixes: 3ce9f3357e9e ("KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Tested on a Raspberry Pi 400 with a minimal AArch32 guest. The unpatched
kernel WARNed in demux_wb_reg() and returned -EIO from KVM_RUN. The
patched kernel completed the access without a warning.

 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d4579..2862df188155 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -889,6 +889,7 @@ static u64 *demux_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
 
 	switch (rd->Op2) {
+	case 0b001:
 	case 0b100:
 		return &dbg->dbg_bvr[rd->CRm];
 	case 0b101:
-- 
2.39.5 (Apple Git-154)

