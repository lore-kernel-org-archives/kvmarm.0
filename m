Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F9F2E4257
	for <kvmarm@lists.linux.dev>; Sun, 17 May 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779040218; cv=none; b=fJr4TTRhfYUUYnPoMFC8pWfZrydvT5LyWJlO0Eo9qb7RrSxp8spRMwwChMXIPQtPYAarAXo7i/vEGjau5pvPjFea1MvYjPBKetfJiRwvg1kmmswKGr5ALXaF1grjjoA2EOaQibVzqaF9Md1bhinlFsLCVcjhDsqLvzkt6brbuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779040218; c=relaxed/simple;
	bh=5hmkXCx2wWYh38pdsLtuClcdaCTRkzAepiYTtF1cs4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WOt3T+nfah4tg62qASuuAflD2GEumEJLa5lbAbK0GHUNdj5eI/aJEf0OYj7QUiSXgWlrDN85OxJ+x10dJQTu9ExJgUfimF0Lc228yVoy2tpIrpRH3KQk2Q+Rw58jIu25M+ASRjmtOsPqhOA1g0GiLH+xSQNyL9ubOqnQ4v8docs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AP8FKWdB; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP8FKWdB"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8b7dccd6fe4so16344316d6.1
        for <kvmarm@lists.linux.dev>; Sun, 17 May 2026 10:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779040216; x=1779645016; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AEwo4MAtXfHhC/yEWJTYYWISTgdb20g3+/oxORWHNec=;
        b=AP8FKWdB69SB4cNa7HdkLBxHDW/d19Cg9pkywRpdw/U6coXypHN0IPMvoMNFawHcxz
         Q7Lr1dpemOAQRwq5T6KbBbwe8AYw9hFnuoPzPyG0M3SWL5SNV5c0/fsGPf6EWiN52w95
         EmhMgO7icQXK/4xgctDYNQV999O03yAgTcWTux1uMCA+O8sz+u6ykhhYi3jOHutza6rt
         ktG/2Vfa0S/fwdRbuPq/ZNpDqbGfTc68MQu2GVDkts2Geioz9WvaRjRwtDhWeB8lbY+e
         Ll0oMVFHNz2bCo1Pl8Sq9P6C0YgbC82R+t5cbuwAox+Dm8kafiN2KQXGTAcJ5EXSJ+x7
         pOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779040216; x=1779645016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEwo4MAtXfHhC/yEWJTYYWISTgdb20g3+/oxORWHNec=;
        b=Ts/RerwdcFSzUXapg6/4g6D3Sg6VDeOtSlDPNd75lM9UdMGO3jUuHQ/QGu3gKTE8h6
         qi7OGoKY66/5QLjebjMQU0w2AmxZcCp68tfsH7bFa+bE80V0c2r4vaBYWSYnbtF5LWHe
         99G5SYC1YgK+wJ49s1XCpbOzSW6wRY/6YNaARcYbcFx0nlpEzpZkzDzZRrhKGjIe/BeP
         vU34HH/gEaYgyP3EvJ1aSqkGtcjXinK51BbtLC2U+bshZDDx6sdYYmDpN/eIhgNsDOGw
         0P1/w/4JUj0hdikMg7Eo+0gh7v3NjrNLoTkVzDA/FKAhAPhGwVmzZ+B3KD5n5xtP8HhO
         GL6A==
X-Forwarded-Encrypted: i=1; AFNElJ+/tbGTOn9TMET3ioFFfBpBhCUyrDle3sFz7FqsLg9HU5xPhQjTfAAh1nQbSrHqKsxpbeo2FXY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy05nfIRsAKNJV5gsbLwMz2J8eZPR6PUJrM6193j1gWIr6/p/Dq
	7u7e6iLPnOecl4QO23dIUmIwkreGqafbRYeXhLhG4slm9O2oPljOHx8d
X-Gm-Gg: Acq92OG/g1VhECeVGEp0B8BGDce/pSu/XClVrTiNqlrwnTPwMEsGS+//o7dRWU3082/
	NK5Hi0dGpFJA6ZqtkHPDaqbwkaPSuxizwTK8J7P7AuGYlgOA4w/JM7QRb4MFkShfj9Q6P0QVjMD
	p059ERwh0XdhUykRYvVyenF44GKbABJoSt17c3thCpPsolzOcvHOVsDBjZJNG+vFJRbsiZbDOba
	9ysdaSPLm0vUNaF9tB57lWuvUyjPvmy2UyZVu0LLqExB+5/Frji4VYnEuqdCnrmETsf/9iwmLKT
	TIF/a2P4hwZsYfiJeMBS6ZSsUhXjR6x+Tpl1HQRcCRZDAzNkNuHEfL39xb5BFobCByyrrmsnhdL
	x66EUeDXWSfcKAbVRNWj/xKsEmP0+EL/R1/qvfMPCrTq3OJns5ks58HJK9JdhYfxOG3Uv4C5HsD
	T0ZwrTh92LH5bcV7tfSGfRmX+JLZtCWiciugWRgQSUCg27ilME1CzeSDSaVu1WPfXiWhKc1Foe5
	b8rCI/BSYJV9jFgkndOnqAlk+yIyh0HuH/u9fg/AwPJbXIMdM6Vrw==
X-Received: by 2002:a05:6214:4288:b0:8ac:a82c:1c43 with SMTP id 6a1803df08f44-8ca0f8fe1dcmr198672686d6.41.1779040215896;
        Sun, 17 May 2026 10:50:15 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3609784bsm28551436d6.16.2026.05.17.10.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 10:50:15 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic-its: reject restored DTE with out-of-range num_eventid_bits
Date: Sun, 17 May 2026 13:49:55 -0400
Message-ID: <20260517174955.273004-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Userspace can trigger a host-side denial of service via
KVM_DEV_ARM_ITS_RESTORE_TABLES. A Device Table Entry whose Size
field encodes num_eventid_bits > VITS_TYPER_IDBITS reaches
scan_its_table() with a sign-extended ~18 EiB length, where the
loop holds the per-ITS mutex and never calls cond_resched(),
pinning a host CPU for a time linear in registered guest memslot
size. The accessor is any process that can open /dev/kvm and
create a VM. The same out-of-range value also disables a
subsequent live bounds check on EventID, as described below.

The MAPD command handler already rejects this case in the live
path:

  if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
          return E_ITS_MAPD_ITTSIZE_OOR;

vgic_its_restore_dte() reconstructs num_eventid_bits from the DTE
Size field but does not apply the same cap, so userspace can
install device state that the live MAPD path is documented to
reject. The restored value is stored in dev->num_eventid_bits and
is then used by vgic_its_restore_itt():

  size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
  ret = scan_its_table(its, base, max_size, ite_esz, ...);

scan_its_table() takes the size as int and assigns it to
unsigned long in the callee:

  static int scan_its_table(struct vgic_its *its, gpa_t base,
                            int size, u32 esz, ...)
  {
          unsigned long len = size;

For num_eventid_bits = 28 the size_t value 0x80000000 truncates to
INT_MIN as int and sign-extends to ~18 EiB as unsigned long. The
scan loop then walks the registered guest memslot one ite_esz at
a time with the per-ITS mutex held and no cond_resched(). In a
QEMU TCG arm64 guest at EL2 on v7.1-rc1, with an empty ITT, the
ioctl returned -EFAULT after about 14 seconds with a 256 MiB
memslot and about 56 seconds with a 1 GiB memslot (linear in
memslot size). The per-iteration cost on native arm64 KVM
hardware will differ; the loop shape, and so the linear scaling,
will not.

The same out-of-range num_eventid_bits also disables the live
vgic_its_check_event_id() bounds check, because event_id is u32
and BIT_ULL(32) is unreachable in that comparison, leaving
subsequent MAPI/MAPTI handling without an effective EventID cap.

Mirror the MAPD cap in vgic_its_restore_dte() before allocating
the device, so out-of-range restored DTEs are rejected with
-EINVAL up front rather than triggering the int-truncated scan or
installing a device whose num_eventid_bits silently disables the
live bounds check. Sizes within [1, VITS_TYPER_IDBITS] are
unaffected.

Fixes: 57a9a117154c ("KVM: arm64: vgic-its: Device table save/restore")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2ea9f1c7ebcd0..a5dcf9a6a2854 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2307,6 +2307,15 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	/*
+	 * The MAPD command rejects this case; mirror the cap here so a
+	 * restored DTE cannot install an out-of-range num_eventid_bits
+	 * that vgic_its_restore_itt() would then convert into a
+	 * sign-extended scan_its_table() length.
+	 */
+	if (num_eventid_bits > VITS_TYPER_IDBITS)
+		return -EINVAL;
+
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 
-- 
2.53.0

