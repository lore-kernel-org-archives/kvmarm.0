Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B6B2746B
	for <kvmarm@lists.linux.dev>; Sun, 23 Feb 2025 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740324253; cv=none; b=qZh0bstQTn7GP9udiMVIBiapmUnAVCv8vNGyBQH1hsEbOJhfTf2WjqnrhVNgjoQyHkw3R0cZOAocpuTY0XUiF/f8jaTejCupDHyEVOCmrIu1uc/0GTm2QCswi24ZSfNVVXqk4jarpck/plYRok7Bg1JkUaWHDGNjhLjl2+kQMko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740324253; c=relaxed/simple;
	bh=QTCnTo7jATyvi6ibfSdkLeYMevxjmJzb6on/eLLP7Qk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SM4yj/nusVSAbNaGUtr/9Jnvf8g/dzipfK8yFnp8P9Hf8gKI5s+RcIqvxnMyy+xRiiJJNixsWZpAWbrPMbF8TxpzlrcK2Mt4+q3Qc+uAOadlk6dWHQWOROtgVB2D6HI5i0c23JRvNiVb9LgF+VQ3hplbxHoE7GKrR39LlDnW+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMP0ix+N; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMP0ix+N"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaecf50578eso713962066b.2
        for <kvmarm@lists.linux.dev>; Sun, 23 Feb 2025 07:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740324250; x=1740929050; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xyt3PPaYlNgcA/j7n+n0sHAguVTAN2baVeJuxMTgLrE=;
        b=BMP0ix+NQResmQwMFAs/kLV447Amn2Ryr1EkcsXKSLDSBr2Faqdiz8SRikCMOmABIm
         1Qp7XLKsKK5WLSPV+Ytrhy2dF8NVqDeWXwZG4XkCKsAdiWl9Y3wU/+RJ+lbWan8Jv0bp
         1C/8BkUiQyivqy5HSErTz+3lWPPfZ00XOisX4jVthuy+RxJmK2nV2IAB7MZdpSp7N16d
         kODjW8dwjxPzyU+RxsHhgGJjVCrldJKjSQbWYU+CtSVEqQShWiCKEyK2IuZLdSo3k/aY
         YEJeA0qo6HDiw7huYDXqwELjvgGTS4QWMOUn6Ici1FzZTFmWLdxuT3XpcGU9Fu+dM4PL
         7Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740324250; x=1740929050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyt3PPaYlNgcA/j7n+n0sHAguVTAN2baVeJuxMTgLrE=;
        b=CqTIDlKr4muzRfKQcJ3Sr4NW5pxqM8uKA0SPhCCDWjAFtreG5CL9jFO4PMuayyJIuO
         6scKL4xLhNciHHDqC3Nj7qpj2tfr3icu4uo6vExplZtlo9pWD/bpkXkr8jPTIESNVoTH
         krBCvo57Pj0JkPSoXukOCZT0SMo/09O0aOktyt1zPGmZoNfANFrb1LFJcJ69oVQYLSw6
         WJcp/am7kfREA/q03Koc0LQB08LFMsYJdmPaxyPHg63TEPRo9iRRGUJPnxwE8tJQLCso
         dmWQ0BG9DdppyA9BCPdhS/nOLwzh8a1nxCG96ElXmMLx3A4YuYt9kabCpsnuLXXrs+EC
         SzVg==
X-Forwarded-Encrypted: i=1; AJvYcCWGMEN/DMJcnPSuCO02mUGalr+epgsUDBA+ZXv2CW5kylWLCsioNpIb4DCazAncy+2qOi4IHME=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3JIahlRTZ+u9rHMd5YVtdSVm3xvj0NIp1OazdxlgEp/qF/5oL
	afImrFd3dhJ1m0+tzjQOdQhjG01HUZ6/eh7UT+sX8WOw2iNR9eL3
X-Gm-Gg: ASbGncvsRP73N02DOi56MvlYprTFiKkWC3sjIjMe/1yVt8fZJMInxcckRYQQmN1Xgcy
	Toeqvc247SqiwN620JV2k1aM/QlW+A82KeZzZCFp9GyX6rdD35j7IwtlXPo51l7TPN1OkvLwsGH
	D5juzDKFXtsnkFg6Rm3zlhbVnuyYXXcjibZq+n8NCmqONbRHoqZj1x+vfQqkdbm0dRz3myHvERb
	dyrKvKuSE9Saj48bh3QqWd3/tbaRvJoAQ7Ev9sxuOGu7UEVPWMImVDy32dp80PEH7HuuY9A/Q+e
	8ytwxmbUQPk1JvBJjtjQlOW7wjaLyhlY/bTKgOc=
X-Google-Smtp-Source: AGHT+IFIRu2Fr+hl9WNpDQE0EmyLzkg8g5O+I7r/hC7hqDYW4YUCySAui9U2daVsbRmLB7U7g+OQpg==
X-Received: by 2002:a17:907:d2a:b0:ab7:fc9a:28e1 with SMTP id a640c23a62f3a-abc0de5a487mr1018666366b.52.1740324249605;
        Sun, 23 Feb 2025 07:24:09 -0800 (PST)
Received: from localhost.localdomain ([165.51.10.62])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbde327701sm872767766b.164.2025.02.23.07.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 07:24:08 -0800 (PST)
From: Salah Triki <salah.triki@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Salah Triki <salah.triki@gmail.com>
Subject: [PATCH] arm64: kvm: ptdump: Initialize .owner fields of kvm_*_operations
Date: Sun, 23 Feb 2025 16:08:44 +0100
Message-Id: <20250223150844.628175-1-salah.triki@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialize .owner fields of kvm_ptdump_guest_fops,
kvm_pgtable_range_fops and kvm_pgtable_levels_fops to THIS_MODULE in
order to prevent unloading the module while these operations are still
in use.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 arch/arm64/kvm/ptdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index e4a342e903e2..50f7d39333d6 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -185,6 +185,7 @@ static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 }
 
 static const struct file_operations kvm_ptdump_guest_fops = {
+	.owner		= THIS_MODULE,
 	.open		= kvm_ptdump_guest_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -244,6 +245,7 @@ static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
 }
 
 static const struct file_operations kvm_pgtable_range_fops = {
+	.owner		= THIS_MODULE,
 	.open		= kvm_pgtable_range_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -251,6 +253,7 @@ static const struct file_operations kvm_pgtable_range_fops = {
 };
 
 static const struct file_operations kvm_pgtable_levels_fops = {
+	.owner		= THIS_MODULE,
 	.open		= kvm_pgtable_levels_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-- 
2.34.1

