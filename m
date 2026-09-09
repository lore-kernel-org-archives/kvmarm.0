Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1463ACA71
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788935602; cv=none; b=fqePoa4wwA9zkXOPPKDpsmd5L/qMtHt2onyW5L+xk4srXCYbXDIK+DrS2kwPG7m1k+NCiOZsgaBAOWRTHcffCxedDKzUejadJfcms3Dbl825Umd315gmnqKLMIwyWP1X/7eEfHBF6vSZzGgvYKPPVmOTd0y90tjx+LLNFjqoOjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788935602; c=relaxed/simple;
	bh=krSppx0TcOsuOQJ7CYM8RgsVBRhBOK+EVkbPK7tCfNE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jxfd1vK5silxQ8FxBgKqNPA1Bvn72dGYgalPBux9qKYqGmBMjzdKbGkObLnfCZii4iroJU5mNtQL1Ye3JD5l/HrQ0YOyJ0vULWFlYlwUzXsfWocil2KUqUA2c0YoLEdUYIk9jRhODh4zOSZVTncv1/Xz26MckS+wQ9vh5tUZmqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8z0ox6a; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8z0ox6a"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4843f205a5bso3446664f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 23:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788935599; x=1789540399; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eDa29l8MMaO9ypybeVRSRc5/JD7r0AQ1OrapMHcmZ2g=;
        b=i8z0ox6asDiA+n1gZ0N8qW3orciLoETbSzWYDKRgRtaH64WCcXIuP44LuCijmrUGZY
         sOOVe+Pea+2jCQ6XrhQyxg+7pLptlvFYrlQbpIWV/5oYw86LT21eq6FxyitEdec3cFD1
         IPKrQLdr6iVPQ0vylJWAVy4xEfX7Ue4LhebTfSS8yzij8odSmrEnYlStcu0kr/VE0yFD
         Stfar+QjYqNVBdJn+ZvWNp7wk2bWn0ZPF7Uj1KQ2tUvMsL0kcega5cCu+5tTbAJk0Q62
         ddS0/aIU28RZ5ZbD9+5KemEQ3O0eiEZ5CH+BbYS8xEFW32negespgPYcA035JfNdHDVT
         sDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788935599; x=1789540399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eDa29l8MMaO9ypybeVRSRc5/JD7r0AQ1OrapMHcmZ2g=;
        b=bkNEs4+1bz3o97kJipE0hURCcDheJSjRaIag5h6ydev6yWA7R5gg4pmlVX7eX3Do5W
         NfZgrVKI0TeZE1xsNQ01bLQWzHrOI/JAW08EHiq6DymkiedC/PoZQYMLemTqcExPA4IU
         FQu5TuwaV2Z2fk8W0Y7iD2rteSA6FOcJ8mOrpniyvUM6VhF2aTKZljU3HL4DdJMjM0MP
         703Dly+LjtcsMitqYfDdQEs9zlmLCdaGFkT2p3u6be6I2o+tG4yza69dNi4qcC+3WhRO
         xVEfclHmdAuZk4RS/RxEGoNiPpYvXX9/otlvDuoCRdH/gwZuqUOY6fbGXCb37JlmTxKR
         ZgRA==
X-Forwarded-Encrypted: i=1; AKwUvBwyLERwitdfmARXZLWGOXeOuby/3/lt8L+ePmT8wVaVmZYO1Hd9P6TbHb2VFFqqwsq04mjDJ20=@lists.linux.dev
X-Gm-Message-State: AFuF++kSuvD+ASV0HAaO/VJoSrIm80SNAhNZ1ivlHiODWO2FzXE5n3mo
	CZGB/NI0N9GP+8BEM28Tc3CS3c3xiArV5gcEt/6PB/aS8DfeS04zVAK3
X-Gm-Gg: AYBFou0UZ3MAaAUqEZiHF9Tv561U3O324fT3N7Majke4tQAilLPz0S5PXRE6ifQ5IUt
	k9CJ+NpX/IW5TNMK2/ItqIvZhPIH8HnE2tQeqjELdqL55jMKwtlmSifbHqcp8bg9yLy2SChCZs7
	4kDwrrBnNIN61CF+KzQMNK84b+UD0n9O1kR1Lxw6mYwG2k7+Ejx35wuBuYGuzS205yHVBPphs9Y
	zFP0J57bSv3K69EjqLMF2dKh+r0y92SY8dNHirvFNtoVi7IRj3vr/PsngYhGY9rOHCAdNgimnR0
	7/OzhQkx1Zc4oTKyWim2/vxuotdswXQSEe5wX9DsGcbF5jT6BJG88vTr55lcaoEhYOBYC/nIqfB
	A6UxxPtEFwDIY7i+AO68eOJSEB9avhyZyMm1i4OkB2AGO/gpnZQ54Z25IozBMR2eunev+Rmgsn5
	6V22fZTU7D7Mb3RA5nqEzp8hylPAxJzz2C1yMpkIVN2FvxLqeKcefIklbOwterTTeWlnsh5j4ue
	cVKF9LhSczO2lmsaI3HrgO2i7dejFMK0hstqRYsDQrlE3l7c27xH9cR1LRweJ7+j/2cPYMd0tpd
	6mh3RVQT3Cx94iZbaAOBJO0dO1uM8QetsO0HIrKsYteP+jZCyLYU
X-Received: by 2002:a05:6000:2885:b0:485:ac55:dca1 with SMTP id ffacd0b85a97d-485ac55dddamr2682301f8f.50.1788935598707;
        Tue, 08 Sep 2026 23:33:18 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-114-212-219.95.114.pool.telefonica.de. [95.114.212.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ab73c2bsm39734495f8f.22.2026.09.08.23.33.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 08 Sep 2026 23:33:18 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
Date: Wed,  9 Sep 2026 08:31:56 +0200
Message-Id: <20260909063156.89636-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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

Correct the spelling.

Fixes: bcb25a2b86b4 ("KVM: arm64: Refactor kvm_arm_setup_stage2()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..c078cfedce19 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -532,7 +532,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_get_vtcr() - Helper to construct VTCR_EL2
  * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
  * @mmfr1:	Sanitized value of SYS_ID_AA64MMFR1_EL1 register.
- * @phys_shfit:	Value to set in VTCR_EL2.T0SZ.
+ * @phys_shift:	Value to set in VTCR_EL2.T0SZ.
  *
  * The VTCR value is common across all the physical CPUs on the system.
  * We use system wide sanitised values to fill in different fields,

base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
-- 
2.53.0
