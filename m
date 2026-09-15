Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519249364F
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461889; cv=none; b=Nl1cRQrOVTzCEK1nzP/rhBtvatUgf0KsWswZ301JjcWqYUuPeaBRJs0s3Kbozoct1B2weuF1jfOffKq2FhTeVfiM7Fs5Ba5E+BPc7b8db0XrPUInShOo8qsgPcecYwH+GtjfEXy/NdPwdQG+v/AMDmu8stj8sH3qgJB1J4TH6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461889; c=relaxed/simple;
	bh=vae5d+plLcM0IjChM+wNH4FShn+1kYkbp5FoYWeKmh0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YwNtc7VprdP4njqTpgwTgDFS6JghhjgUvTTPSsrZSg5Uh/5RntLWQGYfqS7WQRJubJprHrC+LMzkPDj0IllJu8TvY2W7i5oqydPL0yAgk5KzVSqsphCRd1VG4+4U8xie68ysx0/rg9BfuUvIuGZE9XI2YOEMP6RvxWJkDEec87Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dPRfEEJF; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dPRfEEJF"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f77056cfso2302221f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 01:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789461885; x=1790066685; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rohFya9ZM43Y/1RiL36Hho8NC7KJKzxy3Nb/imDOR5k=;
        b=dPRfEEJFsx1Lg5179kLKzZk2vBHfEQa/99XRASgSniKCzSUqj+LysdP33EykIn5DoW
         dUsMyg5yQq+rPJzNVwNZotzofGVADFe8KEwUbeaxZsd9hQOFsrDCsk7KUEpaAUbpbsRp
         uwFS8i2MOX3xdL0SINEmH5FPQpwUVaNQ1TGB4KHSSn+2CBL99D3xzvEiMuZNkQs1FsTk
         m7PjkOD7a833WQIOuAZFvoJDNp66qBx7Gu1Ca8Ag1+t5EzAKXiAG+1feKuFqgIzHLJyM
         0T9BeEs8dO/OPtohaPSWLtQrvjB4Me9mXslZt7h2b7l8bR70mNnFsm9sH6fDjqkeBo2U
         iU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461885; x=1790066685;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rohFya9ZM43Y/1RiL36Hho8NC7KJKzxy3Nb/imDOR5k=;
        b=0wYFLUD9xLmyY893Qx0QAtkQhGjOEuW3+JqzPCcxJq+bXd9gI2ilbXehBMG+geXv9J
         Iwb8F0ul/8uXr7qUVrwn1DfdTmChl9C0mXuVnpTEpqguE6aMvbeoBZRxP2PwYDoaXiUi
         5s7H0pRUMoraj4NVXiaj7G4qpb6skYHiGBRjuVMz3Abz27UfaJM6GJmaIyFwu/bBTwnb
         fxg7CuG56+daWU0y3Wlm9jf4U4U77tA1DogTMuw/i45virfw/UZZrn7qYir2drbP7RVO
         6jHNyy5B0tbSu32qfZtk7b87l1WC+URp2lyaUSviJ95guGUkC0qK42iRMnzGkcfaqx31
         5XYA==
X-Forwarded-Encrypted: i=1; AKwUvBxCpywUMswne8XLcd7OuIiDRJVgrzhkPnSvfuw75wRqMB3GtSZROcn1kuBqZSNcBUJob09qntg=@lists.linux.dev
X-Gm-Message-State: AFuF++naS6tgkXABDRTxiwpWXkSfGIbCJYm1OqOFH2iGpv2RG/Nafuur
	e/S1sUZq1x2Elmxfq3hr2jMBDrKCLu2Du1/sEijFrMQ574U2Gqs3kWO5QzPKflzaZveB/ERtBD7
	h0/SPuZOurZW19H4VXyPegg==
X-Received: from wrdf9.prod.google.com ([2002:a5d:58e9:0:b0:47f:924b:588e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:985:b0:482:fb97:2ae0 with SMTP id ffacd0b85a97d-48702ac0254mr7380237f8f.14.1789461884745;
 Tue, 15 Sep 2026 01:44:44 -0700 (PDT)
Date: Tue, 15 Sep 2026 09:44:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260915084438.2076072-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Advertise MMFR0 TGRAN for pVMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

Changelog:

v2:
   - Collect Fuad's tags
   - Reword commit message (Fuad)

v1 (lore.kernel.org/all/20260913203108.3343404-1-vdonnefort@google.com)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8758c6801776..ec469d96516a 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -121,6 +121,9 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT(ID_AA64MMFR0_EL1, SNSMEM, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, BIGENDEL0, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, EXS, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN4, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN16, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN64, IMP),
 	FEAT_END
 };
 

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.55.0.1032.g73a4cd73de-goog

