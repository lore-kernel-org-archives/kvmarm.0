Received: from mail-lj1-f201.google.com (mail-lj1-f201.google.com [209.85.208.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FEF1BC9EB
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732808653; cv=none; b=OrMaGd2mYpsM4JPtFiJrQqhqe2T2adzryaQNt1VYmfS+lw0fKNijOkmxXVosvpn+EbjHJu491C/o1d7hs4J9J0LMaPY9cypIhFAahrJSkqMAeNNU79Gy9miXwm90PJUMryF3VqlWHsziY871la0qGNVHSM+6it00IFepzUrugPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732808653; c=relaxed/simple;
	bh=zefgSlkWiBMEgrarllE+ZW2iPiBzKadDUa8/gGaDrLc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kPPv2A+4HoyYPA+Vua7VoLhrfS9Ch8VM0eMdBxiLF3lSjXedvVx8gbl/wuJRCqADEBQLQd6vy31TIoL8vAPrFpLj1lNndiXY+7qQE3kbGppG1y0GyYJmn3i0fmNlC/QkgQ2E3oTPSf7hoqmHJck/FIlltc6WY1hRkwdVJwtl3+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U0WNYQHp; arc=none smtp.client-ip=209.85.208.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0WNYQHp"
Received: by mail-lj1-f201.google.com with SMTP id 38308e7fff4ca-2ffc3b6bb58so7122821fa.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 07:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732808649; x=1733413449; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=khn7hS+L97wWEkf+qZmLW9FxPYu9tRvP0eTp4rFXqec=;
        b=U0WNYQHpvzK8xAkvq4QxMzD5bs+uEFO6rqfGSmVxvkInxva0N20MJeSXSd1lsevp3P
         M56umTFDn4bBGfPcVMbmJ0s3zPAmRVOOVvWZ1Oqxvk2aWjkgrYFuuXU96FLGmKuTVYFk
         mgQZVHUd3N3ZD0Gw5pxDNnRekYT3zaELs6yNyhpZ+rOFeXBOVCspr8s7yGC1anb/zvGl
         DxJZ4p0ZsuRTOYxDlV5gcZW/LVBRhbbHx+k6WUZv/TVv6rxnlGAsowjKOkYKEj1uhzp+
         +iDW5pXuSaAZ+5Dgv63+xpd8/QYsoIiaLnUBxkyUGsGW5NHbajh8UjbJE0pXRaXdTOFt
         PDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732808649; x=1733413449;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khn7hS+L97wWEkf+qZmLW9FxPYu9tRvP0eTp4rFXqec=;
        b=VFQLX4vLoTFiWVDPLJu8/J0qL5LevrLJHvHnmH8/kyVqTZYoB/Xy0mcx1fPfXG3/O7
         qN1kkHul6ENLqhw9b5wogjZbMrCvX/pWt1lFSzHAdyDpofuCYUpP2USCmlVik4LYc6AM
         kOwzXdAnkR1LrjsuR9bEUK6RfcqyDM31ynQu/bLSD8J2XIwS9Ehdmi6kS1SPHmajmW/c
         LT4ZL2CzCDos54gPlcQ5dYgOYPrDDoWgZmDczeUuBPS0aRNtIo8WnizIdSeTuoHhq6l8
         RBHmuOsPYsw394qI2cX6tR2VEXUN9Mpk2AOro/EeqbVr6OuyyGAtSAXUMgw+oZjP9JE2
         8beg==
X-Forwarded-Encrypted: i=1; AJvYcCWJMFxkjtPThYQTmb1J1QZ4tSPjvgay0EwXd10b/VQ7ysun4pHGJUnZR0qm1K5eHthldyhdxFY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMBQcttGPz7/FkmiZoaNah2ifFWtHQ7t3iw9mBYUtrR1oPd1So
	s3MF0EtqRGnpDgil/N5U8r6cdQBK0HiSMtp9vCSbkabDYQySknCEdoVRE2P37asuES7iwFqDNBi
	jS8oeAg==
X-Google-Smtp-Source: AGHT+IEA0vqV24/H61fVxAlPgPYdRuvNXFKWFHK/tbHMkyqpm9uAL9gzQ7g11kF30kEuklavdgUcHm1MkzJh
X-Received: from edso5.prod.google.com ([2002:aa7:c7c5:0:b0:5cf:e1dc:7d98])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a2e:be0d:0:b0:2fa:d84a:bd8f
 with SMTP id 38308e7fff4ca-2ffd60cf809mr40534651fa.30.1732808649614; Thu, 28
 Nov 2024 07:44:09 -0800 (PST)
Date: Thu, 28 Nov 2024 15:44:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128154406.602875-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Always check the state from hyp_ack_unshare()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

There are multiple pKVM memory transitions where the state of a page is
not cross-checked from the completer's PoV for performance reasons.
For example, if a page is PKVM_PAGE_OWNED from the initiator's PoV,
we should be guaranteed by construction that it is PKVM_NOPAGE for
everybody else, hence allowing us to save a page-table lookup.

When it was introduced, hyp_ack_unshare() followed that logic and bailed
out without checking the PKVM_PAGE_SHARED_BORROWED state in the
hypervisor's stage-1. This was correct as we could safely assume that
all host-initiated shares were directed at the hypervisor at the time.
But with the introduction of other types of shares (e.g. for FF-A or
non-protected guests), it is now very much required to cross check this
state to prevent the host from running __pkvm_host_unshare_hyp() on a
page shared with TZ or a non-protected guest.

Thankfully, if an attacker were to try this, the hyp_unmap() call from
hyp_complete_unshare() would fail, hence causing to WARN() from
__do_unshare() with the host lock held, which is fatal. But this is
fragile at best, and can hardly be considered a security measure.

Let's just do the right thing and always check the state from
hyp_ack_unshare().

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index caba3e4bd09e..e75374d682f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -783,9 +783,6 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
 		return -EBUSY;
 
-	if (__hyp_ack_skip_pgtable_check(tx))
-		return 0;
-
 	return __hyp_check_page_state_range(addr, size,
 					    PKVM_PAGE_SHARED_BORROWED);
 }
-- 
2.47.0.338.g60cca15819-goog

