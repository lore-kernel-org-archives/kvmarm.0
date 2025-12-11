Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27E72602
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 22:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765492956; cv=none; b=aLxtU58vMKNkIvkdvYE4KhqlJA98x89BZDloe+PgCV82waj7QhF7SNx0jCTRteIe1+AxkMrDCiINyqDhpZwdzkSxaHZqaeIPLnpFsLTMLftNBufYgYGGE6cveZ29l1npT2g7DX7Bsno9pPrVx9wIKsQuTCakFUTplm2s1bBMM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765492956; c=relaxed/simple;
	bh=fUPB2/Hv1IzZFBNQEC6cT0D6etcd9BtC0kpIBSupw8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k8ZIoxVX+VH8pVZhSG81CVAy4c1HWWCI93gYTCc/Kg4V3DkNQsLoIPvXvgaAz4tuZWGIef1A4nKdmWETr9cLCLcoS87yyzVz/xfhbbL221Xm4m3WgvAow5OPNZGmuBhyMEoHy1qyuWg9b2GCnrHAb7zLQCldHpqJybFjL1nK1cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNaPRKXo; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNaPRKXo"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6492e7925d2so740442a12.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 14:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765492953; x=1766097753; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=84DbFclcvWGhH0X3eMQoqbcZjFXuGcswjNd/dBhqEq4=;
        b=XNaPRKXoXdM0IPiCeYwpvp+2DLPbL2PwUrKeK1Ol4436YLaGXuTFTyUBJSvgMnK2y5
         AGfmD3Rr+o/XsiVWyf9WNcli/sx/+f3+5HWVvJi7R8KwufascQ5CwDu/l6G0HiFSd47q
         LH/AgYN1wflPZVzPpUz5TXoNxBFVM7FsCxx+9U4mPV1GEIanooZ4qc6TW3kO7/lpQYX7
         9Tgn0D7VXWn0Ii8RQOYXeKP2eLTc3EPAi2d1DKbrVcR4NcAVMyQ32Af5I98LidlCuj4x
         rPHkya6dNOUT+My2UZz3ErIwa98uQ/iNiWrh8K9guBA3fjtrrNw41PRtNvbVNAKUKck+
         Elyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765492953; x=1766097753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84DbFclcvWGhH0X3eMQoqbcZjFXuGcswjNd/dBhqEq4=;
        b=AminpG/dqjbhjto7EKJTj0KmE+ilbpyNx1uvDk4QDbcar3azUd9yRhD0dkopjtC2kz
         lEPoOjG9P3uyRumd0GrkATmWw2/NvBg/aOP6fI0WC+3i/QCwhsO+f5ExPAEZDkgm/G24
         2ZvdfGOwnKiiXtLLFyAsCLLZO7FOciTmCnICctEBy2xw8XTgLYhlXbmIsrIbmDm+FFC2
         EoNNn5BlnpeVEGGTZdZfqEMJ7aoXcqYKFJG+U2LDy13dbNWkgqIh5uU8iqhcvD2COL9A
         W31ZgmMk6x4GJNcPRBSb+RVW+aKbdPsMHtRh+oTOYyQEHWoENpA+BswT6sbmzO2mZ/pe
         7DTg==
X-Forwarded-Encrypted: i=1; AJvYcCV+YJrOaGr0q9a0u7AbvKNCYbHTn1n3TgO93ePBuh1RH1UkIYStVsdHXSew3TSVQp1FCq/EOls=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLiv50VApJFFiVyxwb+PYwErE8P8Btc7tDsqyyMxSlU9RAUUUg
	dQFCh++OKCx3SFOklbUYZHxFACurh3Q8jMWdsXrRi3Z8Et7aN3NwVnay
X-Gm-Gg: AY/fxX69h4qND8YAFvxyDn5yEecoXgtR7ZEf82nsFTySje+bGDtTeDqRWVlqiIBI9in
	Ndb3ff51I4iCiKbFHakA8q+6Yg+Ej/ZuX7KkQWko3WNDLHH2W7061gz7lJ79PmlKFMkZzrWg9eX
	O1Pkd4NzL0FARIpS2P+83vWSxA/1SKA0H12Mwj6bngV8EKza321WrieLnbr0nGWBPhUC4H4pciP
	p6jcdMw0fLI0hK+TbS5SBjBzePaEcedkrZJYVnXhQxtZqStbfVtwLUdsJEeUhx7Fx36bdJ1nLba
	jHXpEOwhHqQKcV+YcpTTRiTGdpm+XZxGeShV2ORcIo+OE56hDU/RXvDqKSelJRNTLlLrPnetfkj
	xrVxG2Pbfl83TcfpV8dTIpcZqFT0GyY/gECHdHLMBxJe6o+WzfM1AOE35/V6or14zu4UXdTqeqr
	5rwq7smrlaV0ObEeJvh+ayu9uoRg==
X-Google-Smtp-Source: AGHT+IHSMzaR0+lf2JeWcgZlJKX/fHc65ILX6+tANBTqwa8ZXUapW4ZCMc0KHZxyXl+MMn3EgF0THQ==
X-Received: by 2002:a05:6402:27d4:b0:640:9e7f:675c with SMTP id 4fb4d7f45d1cf-6499b136cefmr51218a12.10.1765492952786;
        Thu, 11 Dec 2025 14:42:32 -0800 (PST)
Received: from osama.. ([2a02:908:1b4:dac0:ddc3:acc0:61f0:9df6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498210de52sm3560718a12.23.2025.12.11.14.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 14:42:31 -0800 (PST)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: [PATCH] KVM: arm64: vgic: add default case to switch statement
Date: Thu, 11 Dec 2025 23:40:28 +0100
Message-ID: <20251211224033.18079-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The switch statement in vgic_validate_injection() handles all enum
values for irq->config, but lacked a default case. Add one to match
the pattern used in other switch statements in the same file and make
the defensive return explicit.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/arm64/kvm/vgic/vgic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fd..a035ce6231e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -369,9 +369,9 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
 		return irq->line_level != level;
 	case VGIC_CONFIG_EDGE:
 		return level;
+	default:
+		return false;
 	}
-
-	return false;
 }
 
 static bool vgic_model_needs_bcst_kick(struct kvm *kvm)
-- 
2.43.0

