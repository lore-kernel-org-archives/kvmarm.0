Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B251514C5B1
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561030; cv=none; b=p/++f+SeHdFOms7lqEK+BotY38R/adXrs0b8iUhSmjpbtsTDHLJZPJrY/xeWK/lfzVIJShvXZreKpcE6VAUF5oJf5wPOYy3pcGCLdsvaBAq63SE5lkz14sGWXwwFJiAXDuoc+xK6cOAECnCJhcyZZbjiYjtDq/gU5nmRNS6XHPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561030; c=relaxed/simple;
	bh=xY6y/oFUALqR7J4+y/L/E/A5zoogp+I3bFi56mP5zPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JEfDsMcCHtdnCnZ5b5SZvDBZvC9DMKtYKMgCqs/WrkaS14O5ma4C/Xa8T1M0LQ4FWqB0dTXFtPzBrzZD+uSA6WbfisR1PLZFZLJKYGTqrfcYg790Hv6Z3OsJ1hB6uAgUXAuLV1nZOYQ/dVr/H9wH2HnXvUpIbsbEpgnea1QsWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yfi1oZ5P; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yfi1oZ5P"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-611e89cf3b5so1275897b3.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561028; x=1712165828; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=btnsnCHNal8kwzgQn91OuUJqZjc3ypA3M0LwdvJDu9A=;
        b=Yfi1oZ5PgErIUhBf4/P8L/Ami4eMwVUjW/po2X7XN8CAfrmd3Bvbc6xnsoCoyI6iFs
         poGfEcb5lrNrhBwXYBulJWj6xwgqqc/b9DIOtPFF1zEiO7Il1dVeJoXzG7l+tTY+mkTG
         IlygKF+NeluSLiTTY8k9Hh028VCpDsFUkOAQJ5qZm3R6KVbKMmnxy0J8k+zT2rHu++5v
         o7kdqXEwFfv4F8csxPy6V3NNKxiuy3aaiAOFuLozRa3ZesdaUV+lseLzsLCe7PV3LItp
         R9F37v49vccxd0Lhk9hKg6mtzg4AhNfMoHCtV2W0NYI+HfwtpbPQTxaqOk08B1k7mWa3
         WnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561028; x=1712165828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btnsnCHNal8kwzgQn91OuUJqZjc3ypA3M0LwdvJDu9A=;
        b=rI2KQLlAmxlxgEyEkChdYvVNIHPQxo+WuZkExWwo95Zm67OCdnjm1KutTd/+gT1N4O
         iWyND6MK1BtFL/Xk9SJFduiMgT86sfX2kaFNFFcJCsvX6CyPVm+0iuxqOoxvf1KvGHT8
         g45Tp7gALURlExayLaKslB9kyTyjpk8v/tnp5PeNJGYyug1KEjO48Sq267nCunuG71r7
         jKq/xpEE1kxv9UqGcTb3O47NhIrw8PNhR1FpDFUmdw5SgOkrzYUfo+lT4ZlrQXWVjy02
         tzThnkMnyp2gc795riqAvAc3tdBPSJRz/h+/GPSfdW/rhNBDmOr3vmUtZLwBDHgyher2
         vFkg==
X-Gm-Message-State: AOJu0YzZKY2w++94K6BLdRcU+02HRzakQo0//Lhd/hRo78e0SFaa8bgk
	1kZAAedRCXbs4kdc2HnGy3UL+2LM/LhOQua4zWsAKO3RE2yXasesvTnczyalUeoQRkMYHkfxPx5
	cLZjCH0sggKYzYEXHLH2Tdv3XEG6qT/3kmMnsGi7Xju7CRjeSVDTDuMuYMyu5lmFe4Xw8Iaunpa
	2lTorfZteDAeSsm/gG33iwB1B+WAo=
X-Google-Smtp-Source: AGHT+IGJ/A46KzVHiTHyaHB8SqFMR+DrRZup55CRJ/JmWhx+bK+Z86Q75sA1KeWDEYCbhbe7HDUq6Qor6A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:b768:2994 with SMTP id
 w9-20020a056902100900b00dc6b7682994mr65020ybt.0.1711561027716; Wed, 27 Mar
 2024 10:37:07 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:24 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-38-tabba@google.com>
Subject: [PATCH v1 37/44] KVM: arm64: Check directly whether a vcpu is protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Use the vcpu_is_protected() function instead of the more
long-winded way of doing it through the kvm structure.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 302b6cf8f92c..28f3a6323940 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -209,7 +209,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+	if (unlikely(vcpu_is_protected(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -228,9 +228,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
  */
 static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-
-	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
+	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
 		 * fit for purpose anymore by making the vcpu invalid. The VMM
-- 
2.44.0.478.gd926399ef9-goog

