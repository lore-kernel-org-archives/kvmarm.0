Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC01358E2DA
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789067142; cv=none; b=nSjYfFiX106zp5w5WX75QxRL9Z7lDr0LnzkWGb8ROPMLRUnk1s+K8MDfH13nusTMsirgLH/EDCElHdNvS4iIUe+UhFfTKiGEpMBKTebX8zg72LbHzyZbOYXJd6lSfV0j6rTn4BR/HrytqEapLCVlsZINaO7AYwjFtf4iLR8hoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789067142; c=relaxed/simple;
	bh=BrRosa09qPfnnT8wFRJjyDdW1mX7VGPRwUOLAULnwBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQGvI3gPG6i9OF/udgiucRHXVqY4wyMot51fmDVb/n3VhjuURIeyRIGtSTCW7FoHGNlIauzgIteGmSbZxtruA/EWZkYedhFpGBf4uCDWU29Y5D13j2KbqFjGBVPhrG5dmrcJE2U0quAQWWLH+svaTlcgfV4e7mVZ+wu2I9DGfwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWrT9YHs; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWrT9YHs"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49b965570d7so2019675e9.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 12:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789067139; x=1789671939; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bDPWQKpYK210YH7pdRtFQhVqun7oclqubAHor3TmIiA=;
        b=hWrT9YHssyJFXbQk+eRKiPBqQv0QLDIvkQ3p52MNtUDV/7cEimxEojidGMJeLKbNb2
         5LZt4g04dPxrdnXVtNfnOU1NzqYMk+hmQrQ961+41o0V1UMKh6Q19S3qCelp17M8yp1D
         6HCWbrtzSZ1va4mb5Z4iiQ67cVfuGUa5CO+NmFj8RXWY1d9Ztahg9k26jB/PI0J/8JEr
         6Pi5JzDQd+/BDZzVavZa9VOJWM8Bj4S5V+LHmq7bQp+eyGxLTzafWNeC+nV8lCjjFSQu
         qTN+390b/Qr43hUucgTp7bY8aiXOTIHyIdUMN9yA+xMKbXYk1PHN0daQjKNZpfAaQJS5
         QpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789067139; x=1789671939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bDPWQKpYK210YH7pdRtFQhVqun7oclqubAHor3TmIiA=;
        b=hxS/BwmxL/7ARVG+70Zvm/cMBN/0J+oZLiYD1a8Us2NQ93ubkdwfwIYPLeSJCCfdG8
         9UoEt2wvAHQuzPTc8zv4IT+OSxWEmVqDXvBRHl8RgjfFJoMlv58a4UD0Sc2tldmaL6AS
         ldYN6WtvaoqKBS39TO88Hisq7J7TV1U7JM7PbyhZE5I3Z0ptlq6O0gooEso3PFEwCMKY
         wiqmIva+FVXrimj9hKiMtjj/lVJVkUbupJgjLsN1LxAYxbDlPpWES0TJsbKjQPCS20rp
         WsEUX7A7G0jt5mPe5eqSMhohoeU8iF23R6esp86ipF2MjtoqMbIkjlnyeEkOMkBxGx5w
         xyhQ==
X-Forwarded-Encrypted: i=1; AKwUvBykNOfZRWDDkLTPrgwFfDIano/Qcw8JgQ0rfqa7NytyZZibcBbsfwwNfOsfEPpTEVLwPznBk9Y=@lists.linux.dev
X-Gm-Message-State: AFuF++n2T+Hp2qM2J9MraoJbry2DUZ+rdF7yiMgEAsB73vVhpVxdGqm4
	EKtvTJv++Bpq5sAfS/HMYYKHk53yKhTcqKZ1BRymeAu1RzU66YywwY6L
X-Gm-Gg: AYBFou2tkaSCZzYmA110YvPL2tVgnPTy/wkRnHRk96Zucp6bMxFlbZc2LKoJqFYmyL5
	wmBVnMG4GE7baBRz6LazLnbSJpHcAOqu8m7TC9Li1Jbw/gSE3DkGl+xeJDTW2KcgVpGsnJZIhCM
	V489yMkgfUWrJAp6Cy9tqPtIxHUjSb1xznIXKAkW2Bym7VyuvWXGqg0wFUbIxbak1QvY1EvE8ni
	ey3MIizA0Ul5vgg7/tQO/2I9+lyBAdDIjZfy2WXLUIWc43+1xSuLAyHmg88Z7JqDMmOTgqyFjx8
	sWSijYmkZMtuBh1/qX7gTzzivLt9NYhtb0ibTwPJe4iOiYvJvREsuli1JY8yXuz63ApaobS0TpH
	RBhCUOfT0lnLrC9FjGyGwqcKJS5SEukSwm2vsBEbHnlFLlcGYOlzno8NX/rzJkHSHCKnpQKi1LQ
	QR3lZ3emwrCaM52n8AEmuTdHY8MJD400JoELBMyorjpRk4MLdsR9QLmrwbo2DEDPF5pPWH4Xerg
	qr4Q/ZEl2J6adnFTzMSK8lT8gOIsaS6LAAfm3gQIyzyRNmyRwduEG5uO6bCMgsQr5CennEluZNb
	8jMWats3JPBGijKrpC0ChE4rPSJY9je6P/39w2+gszO7ree8UHbIrWBFQP7yq1oEXSJKqQjDUC+
	GkNbTZNY=
X-Received: by 2002:a05:600c:1f8d:b0:499:be2d:c290 with SMTP id 5b1f17b1804b1-49e6198933cmr5181655e9.9.1789067138621;
        Thu, 10 Sep 2026 12:05:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b3d9-b901-601c-58ef-b3f5-74f5.310.pool.telefonica.de. [2a02:3100:b3d9:b901:601c:58ef:b3f5:74f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60adb075sm14811665e9.13.2026.09.10.12.05.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 12:05:38 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
Date: Thu, 10 Sep 2026 21:05:28 +0200
Message-Id: <20260910190528.4483-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>
References: <20260909063156.89636-1-kmehltretter@gmail.com> <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_get_vtcr() takes a parameter named phys_shift, but its kernel-doc
describes phys_shfit. This leaves the real parameter undescribed and
adds an excess parameter description to the generated documentation.

Correct the spelling and describe phys_shift as the IPA size in bits.
The value written to VTCR_EL2.T0SZ is 64 - phys_shift, rather than
phys_shift itself.

Fixes: bcb25a2b86b4 ("KVM: arm64: Refactor kvm_arm_setup_stage2()")
Suggested-by: Fuad Tabba <fuad.tabba@linux.dev>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
- Describe phys_shift as the IPA size in bits (Fuad).

 arch/arm64/include/asm/kvm_pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..20d12da3d28e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -532,7 +532,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_get_vtcr() - Helper to construct VTCR_EL2
  * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
  * @mmfr1:	Sanitized value of SYS_ID_AA64MMFR1_EL1 register.
- * @phys_shfit:	Value to set in VTCR_EL2.T0SZ.
+ * @phys_shift:	IPA size, in bits.
  *
  * The VTCR value is common across all the physical CPUs on the system.
  * We use system wide sanitised values to fill in different fields,

base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
-- 
2.53.0
