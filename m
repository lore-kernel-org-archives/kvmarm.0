Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A637F014
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589309; cv=none; b=bn1/wWphY+aiHVkgEdxOl3jUCsVs7GayITnRTIkXZJ+0+LZTD/tjU6k2EPIo71SuEXZ6MDN9rqvbdERFMResUQ7rUq5vkNgN/PliC39REBL08RHLQazTZopLJEDfYdI0+YwB4TqZRi7H9rmyHAUaEEQ3pFWbS54OVuBsnDRXWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589309; c=relaxed/simple;
	bh=Jn3LlMjiPV0qhYCwdAN21ZHQQiVushSf9HRxmuxNJIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AepYnUt+61cy+0ayTzDFxs3pIxa6CM6c8CjU3L5nQrxOoosbodGRpufwwfm6nA0qwnGS0Za2VIZXgIn22DRWmZ3hvxBHLBzdp1O1s6lW++BKMcG0kD7Lfv2rypRE62UiGphY7q80yh+KqHulGuum5Z0SRR5oUhxWWnFE3fq58j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aYyR9rpm; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aYyR9rpm"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48876f48669so2066869f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790589306; x=1791194106; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sh6Pmvo+oky2qgEQsEeaC94BZWoDkn7hbfzIYXVj9ts=;
        b=aYyR9rpmSYJi3BTFjAU0bd1J4l2ZGq943fyyUXQGnFtT2lZ1lDtbQvE9iaV4egYgeq
         I+ahuHURasIFHKHRaoVP/sGHDRbwv8t3XZZ3cStW2Mk/SQjwP8u8D224K0QQ1Lxn4wm7
         RWg3jNdTCP+HL4UdLgd7qnr6ogTBfsfPDpKgM4dPKFUSQOUzaua0wzDfeqpSsSS67t/I
         beBLVRCCqXhuAK67kgBcOfBL0WFVjAYcQz8ZTZLBuawnEPZeJ6tgmvS4cSGXOZSpn0BB
         SWF/30BHfrY3h0f0Aibwle+ZWw+uEyxkxFerQTcE/4rRH77M0esAME3ToFXcSXqOVLAa
         GnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589306; x=1791194106;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sh6Pmvo+oky2qgEQsEeaC94BZWoDkn7hbfzIYXVj9ts=;
        b=E4fBKrK2Q+tIBJ6pgGXs0uP1xH36tLIUSfWyCdfj52P0fuN76tFVfbdb+QOhpQgvli
         NTLGKUE7jCKq03qHTYCOF3stFP0kEmBlNVDjOriEwxvIWPfQ6FbxFyWI33OrUwsccsX4
         9nDU+0w/fg+DjZP2XVZgLaNBVV35HWojKGve27tYHq4UX7ROqQkhjCabshxgqsZJ/Pwr
         dOGYTVaiA2WeDpJIc74/771X+CZHXx1X32OPCUOWweSHhDaa4wYyqTa1mjYg9fxUzMZ1
         j1/Pp7WSFR8sJvqO+oq+1U0D4UVbc7mOiEQ0AF8NfurTEitwiRntey8s2cLbMiD6V7dv
         D4GQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSd30z5n8rfSvOr1Qz0n/zBipyzbEz2dvYleQ9vcMhfpE6X8Q10YG1Nyonu8RAc2goEm94uJM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJlsEwgDzNAvUW/ktH8F59MrE44ODd+2RJu1RIAhLY1Ai/GRlZF
	AgWDZChwRlEqBrCRKWtW9DOOzX9u2wFBsog6PjU6grixUNXw66pK4w1/jkli7HlkHqM6rkHpEAG
	3zFWgQrolAMrWCrYKETzx/Q==
X-Received: from wrbhe29.prod.google.com ([2002:a05:6000:15dd:b0:488:8b42:e490])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64cc:0:b0:487:212:a412 with SMTP id ffacd0b85a97d-4887165f6fdmr25234575f8f.9.1790589305543;
 Mon, 28 Sep 2026 02:55:05 -0700 (PDT)
Date: Mon, 28 Sep 2026 10:54:50 +0100
In-Reply-To: <20260928095454.3255918-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260928095454.3255918-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928095454.3255918-2-vdonnefort@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Cc: stable@vger.kernel.org
Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

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
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

