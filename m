Received: from mail-pz2-f13.google.com (mail-pz2-f13.google.com [74.125.228.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2BF3403F1
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789704145; cv=none; b=LAa4li2EjW10yIkR2BJ6gmigpSesZDJKd2gGbW6KCjyIAogVeGO/jhTnFI1o4BNMeZkqDPdnBF6+UhIZ7luvUZxpUK/wm8GPLQc90P2OozSUpwpCu7vZMKPz/4RUvFr8sLlIHK8ifAA6TOoMa9/8hxiGmFf3vv1cLu7rVkPhzaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789704145; c=relaxed/simple;
	bh=P2D+HO4mVjiiJJBEZ4gNAXhX4ZO8+x/M6mEGCWV3xNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XZtlWLNazvcOFljoLKFnY7ne7tlRAlNE/lYb+f9rQisA5ql2p6T+/FaBcYJP+7ieBfS+hYxiwsAKevEawf+AUBwpL9iNdIns7uY8pJQ7BWcrjy8Wyg331+0NM5xyVB7Ff3+04VilER64cnusFpZi0g+EXJGLZG/10PktBK3Td1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=drRcRjLw; arc=none smtp.client-ip=74.125.228.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drRcRjLw"
Received: by mail-pz2-f13.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so127426a12.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789704143; x=1790308943; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RwTY/5NxTgAeB7jQNGmeRkMgpBA9gU5D7GhrWXLQQXk=;
        b=drRcRjLwjUF1G4twcdrzmQdEiGrnxdB/3CywQXGOVnBu6ygCuztZYFjAMuFiI33PCb
         7P+zu63RV8z9jcABHAUASfzFA4xayrw6HbsmE3GZavOcX9Xs4lno8LsvTMGPbSLtfUiL
         YKF3AfIbqc4oRaPUEOi9IohpONLxTTvVof0SAWU3W5Adpp8jvvunIpIezOhHR9IBjh+D
         GuXRTKAMk0sHxs+EvAh8k/eyZYIIbnZC9P3bNEW00jEK7izzeWTOhTH67eVC+Xx0CKzJ
         +BIWXMJPcrhSpi5xBy5zOnKGM2Z37XiwiXVMOMN3xBMM3vlxcFazVYg+xOE9mZXeKF9u
         NI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789704143; x=1790308943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RwTY/5NxTgAeB7jQNGmeRkMgpBA9gU5D7GhrWXLQQXk=;
        b=whGrOhSq6QhPvQl3Q9rykBDheHzsVroYZfxD6EzUzKGAq/WvSDPollMJxA/g2Hzgsm
         49sfSiu2fODEw1a3De0t3+L11F4Q61ylf0u5+lunFp2SxUQ4miVHUZnp58FvNpvC4FMx
         X0o5jg53pYKWNyDbeVfMIljOt8zMsQWzsb1MJiTs3YLbZmFP4ztPESeNe1e7pdCf7yyc
         p3YUk5aA3+i9VJhVHo8iDuaZHFM/uY019aiyJU8pIMPsyUim7LAqwPDgFP78aFq+k784
         IdjY+Podl40fH2+oVR8gZqamOv4r1o8WfvO06JurNU0VqvFynPdEuI6Btvu3uNBGtIg9
         Z4Hw==
X-Forwarded-Encrypted: i=1; AKwUvBzKbJHkHi6DLFc5p/hyc4AcjZ4EnY96fbVvSFPnsRO96ydLinE1RZZvF+9q8Lh3ydTQETZ9JYg=@lists.linux.dev
X-Gm-Message-State: AFuF++k2OUz7NwbOxb9GW89P7R2+Jc4dayTpBM53FAaVYYDi8NzTeCKU
	deB39E6Mvs5ijPdmr4os0hmou2rSgH0uJQubHpGErz5bnIZkVPr3O7+L
X-Gm-Gg: AYBFou0x0dUfVQUj+aphu+VXWFoSKSSusI616fMjCiS0ae1mWz5idnJm6pt7BJaJH7G
	gSGILxtsFhsKU1cyO+ec6dPATnbwMR4dSwwAto1FMk431vtHZ5O7t9JLyTO/8E243oTY3lzNuaA
	oXXhDBB3MDfvmYqpD6fP/fa52W1Psscuva97HalplZ79SqmURNuU5Sa/3gyC7CsnhckfHrXAHQb
	VeRID9yrgoAnB8QeypAhPIJ642m1bqeFV52xxXHC6Cb1mQZRkE4I7Ua1dbbdc0vaPCAUS0FO1al
	DPdxWwgENs3q2OTfS2kg7xKiB9Q6x+rA7Qrz5mFVdGsBoxvN7/OcBC+yFC2dxnKg6c9KGBlmwVW
	2qXO/HAoWzPvRmp9ieZVu9ixkz/W4mbxAnC5oUYGRIj5xMpDUajV5h1MwDSpxlIeGMg6666i3Nd
	990YepM8qjaPEDoP6jZa6Q+s0ryvFJNEmNRFrTCueHl4d7TstWAV5f4FoJVrRuF1Ozkm0qxZ59c
	TrgLurv81qehSR6fzweJlZcBMe1jR+tXHnaUcg=
X-Received: by 2002:a17:90b:2fcd:b0:39d:ecb6:8d40 with SMTP id 98e67ed59e1d1-39e54af2148mr3003726a91.4.1789704143301;
        Thu, 17 Sep 2026 21:02:23 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:608a:778a:c473:ac82])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c287be968sm719908eec.26.2026.09.17.21.02.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 21:02:22 -0700 (PDT)
From: zjamg <ndaugoing@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH v2 0/1] KVM: arm64: vgic: fix UAF/crash on remote LPI disable
Date: Fri, 18 Sep 2026 12:02:13 +0800
Message-ID: <20260918040214.85580-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yuchao Zhang <ndaugoing@gmail.com>

Hi Marc, Oliver, and KVM/arm64 maintainers,

By code inspection of commit 6da5e537f5af ("KVM: arm64: vgic: Pick EOIcount
deactivations from AP-list tail"), a race condition exists when a remote
vCPU disables LPIs while the target vCPU has an in-flight LPI in a List
Register (LR).

Specifically:
- vgic_flush_pending_lpis() unconditionally unlinks all LPIs from ap_list
  without checking whether the interrupt is in an LR (irq->on_lr).
- If the LPI in the LR happened to be the last one populated, the per-CPU
  pointer *host_data_ptr(last_lr_irq) on the target vCPU is left dangling.
- When the target vCPU exits guest mode, vgic_v3_fold_lr_state() starts
  traversing ap_list via list_for_each_entry_continue() from this unlinked,
  poisoned (or freed) last_lr_irq, leading to UAF or an immediate panic
  when locking irq->irq_lock.

Solution & Scope:
This patch prevents unlinking LPIs that are currently on an LR in
vgic_flush_pending_lpis(), ensures *host_data_ptr(last_lr_irq) is cleared
after folding, skips the ap_list walk when eoicount is zero, and prevents
the fold from resurrecting the pending state of an edge LPI once the
redistributor has LPIs disabled.

Note: this closes the primary race (the last_lr_irq node itself is no
longer unlinkable while in-flight), but the fold traversal can still
race with a remote flush unlinking a subsequent non-LR node in the
ap_list tail. Fully closing that window needs the fold side to take
references before dropping locks (in the spirit of the prune-side fix
in commit 7258770e5814 ("KVM: arm64: vgic: Handle race between
interrupt affinity change and LPI disabling")) and is left as a
follow-up.

Changes in v2:
- Added the fold-side guard: vgic_v3_fold_lr() no longer preserves the
  pending bit of an edge LPI folded while the redistributor has LPIs
  disabled. Without this, a flushed in-flight LPI is resurrected from
  the LR pending bit and re-injected while GICR_CTLR.EnableLPIs is 0
  (spurious LPI delivery to the guest), since the injection path has no
  lpis_enabled gate. Thanks to the Sashiko AI review for pointing this
  out.

Yuchao Zhang (1):
  KVM: arm64: vgic: Do not remove in-flight LPIs from AP list on disable

 arch/arm64/kvm/vgic/vgic-v2.c |  3 +++
 arch/arm64/kvm/vgic/vgic-v3.c | 14 ++++++++++++--
 arch/arm64/kvm/vgic/vgic.c    | 10 +++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

--
2.53.0
