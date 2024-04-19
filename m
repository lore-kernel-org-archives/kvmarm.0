Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B28146453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513615; cv=none; b=kos5Q0Zt748t2V/IG7v47Z0nGkNLlrdYJrOIBUsuz1AkfqMNZHXtaTlfwsAhofDeC4p0fvp5BkVZKGrYqvAMGq+tk3El/6LkIq6BvnAoNMBVxwEgd2oO3V8gBr+W0Q6+f/1CorlduBkZiDF1EHqFa4yVT8Ts3INslSEJ+YuqOC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513615; c=relaxed/simple;
	bh=q0c8lIPISRC2zgYR3QRg99POexDAPNNVN8nZ07rNwm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GdfZjJ3ZEuzLZSEMj717umXqJs9dp715/h2uttpD/FNRcuUNSfHgIYtR/Zu30NQTvgX4nUWrrDn0NCGU5HskUZIxmXLt2lu1+HZts+/J4bl36cjrlFVC3psjKKKeL/mhj5v7kXOVvEtZsPcNQmAm9XccBbTrvm5sUjdxwn2/HZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hCddSJwv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hCddSJwv"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4183909fec8so14574765e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513612; x=1714118412; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlJbzAGB5rwzDf9vcn6vhM7P59YJhMDFjOqGlol9fsE=;
        b=hCddSJwvtJ30Z1qyjxU+ryjgwARiWxQktRiknhOlmuhQLBMivXs2vGU+FqjAE/zTB0
         Eio9/pMOJ2L9pXsrEwpxSxuCAyku5lUrDWDQFrlfKBhyL+iNiYOa9B1Px7x6ME+aU3Ro
         LMqX+7UOLyi0cw+Do5TBGTE3WBZ9mD75B+9Lnk0GjGTXPCxrrj90kP5/5hFjgx87Gxxi
         dn0ZcYSNjiYz1Xi4tig43ACAkOSRKG9cuYEd85LMFX0X3cOxYKY0drHc07GRZdHMfgvZ
         k80juPoeh+9C8Yq5cNTt8dluuZm93wY72bf/wz5PcF7g/oI5u92PNEPDrKfDc3Mw/rXP
         iEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513612; x=1714118412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlJbzAGB5rwzDf9vcn6vhM7P59YJhMDFjOqGlol9fsE=;
        b=rVXYa4CA5Vgs6D4+kXHkUlJGAH/Vk9rYEXKekKAb4b5DaKYa2kobc5zt4Z4Z2yD/gO
         HPbZ72j4nR+Og2Ml/RyePwQvU2Jun2oPFUSeCTvgcS495vyNCVVHvugCH1rJVwy4MvXm
         Iub8Um0LOab+G2ZIkt39MbexSHtkc29jsgh6brUBN0WnCySABG/cfblP7xm57t4gcVxe
         QvB43JI8luNpwKX+G6K46B1SfsFyubaaat3dkVsezpAuuUnVfILXTO8Zjq2KUIjdW46I
         A6uMqnW1Z1kmqsNVrHYN4jzn04LwzXQSb3Wni6xx9RE39ebTk0L1xaVLOvXFvp3g86BV
         CVtQ==
X-Gm-Message-State: AOJu0Yyh6c2h0r1FIQopb8pOiDzlcdWbYPN50d30vk90eGgXftuVWJQH
	QihPbyO828IYIo/u1HsDGpEshOuiZMyAgHYa7+piwu0wlmzCFZwBzsj17isMWdbrDqIcRKSqzv2
	jL503f5WWPccpTfujSh2H2Am+UtMmJ147SIVIgY59yMY+WinCHUnqkHxr2BSl+fgI+11sSlW6DT
	U+R7DapTFPLa1t9GHP/8IzPnLx0oI=
X-Google-Smtp-Source: AGHT+IHVCpVV6ivE3YSFLLqw4UZVlt8ExMBrfZ63nGhkg2SztkhGv5r7623tDmhdIWUgNQmLespCM93eGg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5102:b0:418:739e:d48 with SMTP id
 o2-20020a05600c510200b00418739e0d48mr7745wms.5.1713513612582; Fri, 19 Apr
 2024 01:00:12 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:23 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-14-tabba@google.com>
Subject: [PATCH v3 13/31] KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Fix the comment to clarify that __pkvm_vcpu_init_traps()
initializes traps for all VMs in protected mode, and not only
for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 315d4ebe1d6a..16aa4875ddb8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -200,7 +200,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values for protected VMs.
+ * Initialize trap register values in protected mode.
  */
 void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0.769.g3c40516874-goog

