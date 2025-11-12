Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283762FD665
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939263; cv=none; b=j0l5VQEki/jXLxo3aNoV0x/sdTvA+2qysD4IHgE907fyNPKcEY340nszAtq+gGQemNZH7jq7+s5hxRW32LAsZtKTxpUnLSB392nr6i0vT1rDbz6rHxzvz8jfg2z1Mx9T9qbiB7kGb/hjcQpYgU9A4LioH+JHoi4ZtwPFIwN8wC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939263; c=relaxed/simple;
	bh=Wz2/Lx1AgIZmPXwefCNzKtHAzIJhMwvxRKr00EU1IDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BfnbVx8Ok7Kjr8ZwU1lYm8HzGybfZqRTHYXoCqcisriy5RFmTbI5x+rrZXWm0D1BnD5OA+FYCdc6DnpJSOeimZOvdW4O5tAVsqnY07c1jGuz6h+Yaef3UPJweZ3EU/kgPdpvTGzKUHuKnTWogtYH1GnxhGtwSn5P0GmgktXTuqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EhalfsAj; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EhalfsAj"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4773e108333so3953305e9.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939259; x=1763544059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha/YRLGp8HBWidSTkYnv9ioTPj5VutIpABv4fgu7GPY=;
        b=EhalfsAjgHhpegWwgOYYjPoSiQpe8ReOYoX7n6SAZjdMSkDe+97MZD/s0HAO4yScxR
         zuEWn9jKxQZw/4tqhLWmPT43A5PIcT8TX6jAJxNySmKTVPW6GF+L+43CFc5oX2fGnpS9
         sl+ZyoYcIU38P3Z52s623kqYngxCHuCDh7IumFlcKC0Dqtm1bFgt/Hitcm7kc++z2C5Q
         B0Nn0kUEVIGNEAAjv2VuTrW0luOLLDmBEGIbROcNomg5FcqcmGbvKTICrd4DDBbmHme9
         AgQUMq3I81ORBtkpZlq5Xzwv00MWTxfjkZKmMFSTd6ue2rEz+LVvKAl2ELvUfNxupCOT
         jTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939259; x=1763544059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha/YRLGp8HBWidSTkYnv9ioTPj5VutIpABv4fgu7GPY=;
        b=HMiB1OkTA+Ua+PqKgESIXxIDwM//wwClGrPRPDu5mVxyfQLqFU3HgD8uNj9qlcxUxv
         K2GEqe0hNgUuWhn/YLQ/XRXOGh4gN9Yk9G6tSbFPnC3Mt7lly9dSjg+AlNzN2Mmwfxkh
         a+2EY4N/WR4cK+M60wNB+yYs0IuqjhGtjc6bzvFKGHD/EVnaM37b3SQS746jFHpx8UiF
         BHs2gWdrBpbHqGcpESqbnWoIveiHCIxaN7Z33/ieatK4I7K19KEWzAfT62q7YogwpPej
         faI20fEOCrhg+wRa6aaQDj5pWg1XraiGJp2S5xLvC0RLudszYdUlMwr3XO2lC/T8/Ihr
         jfdQ==
X-Gm-Message-State: AOJu0YxSpDL5+v0Pxazglh5ILtLVq/QRSqOo+LzSuE0sFUmSwcxe+k6/
	8cWKeM5L3F6+iyljH7XynQKRxuct2Yq13EBtnhQRVIlUx42fPzKFWncOUxv/AQcOeLD8CsOWa6V
	rp786KbAgJrY+sIK52J3x+ldM91AUze2q/4u0jfVB3TPSu+4xr8j5hbWi3cLPbfXhaLxwghyiiO
	duwERf/jIu/9pwZQgF6lS7XWppb+q0fOQ=
X-Google-Smtp-Source: AGHT+IHPoUFaCLXOjMyWSCfx4qzg7cUE3fpxwRgUakYBHYLPzOGYHPaTvZj/fIrra8Jk61aAvHQwv7ghSA==
X-Received: from wmjq19.prod.google.com ([2002:a7b:ce93:0:b0:477:3fdf:4c24])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3586:b0:477:7768:8da4
 with SMTP id 5b1f17b1804b1-477870438bamr20235595e9.7.1762939259550; Wed, 12
 Nov 2025 01:20:59 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:51 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-9-tabba@google.com>
Subject: [PATCH v4 8/8] KVM: arm64: Prevent host from managing timer offsets
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs, the guest's timer offset state should not be
controlled by the host and must always run with a virtual counter offset
of 0. The existing timer logic allowed the host to set and manage the
timer counter offsets for protected VMs in certain cases.

Disable all host-side management of timer offsets for protected VMs by
adding checks in the relevant code paths.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3f675875abea..f5407301c8f9 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1056,10 +1056,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->timer_id = timerid;
 
-	if (timerid == TIMER_VTIMER)
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
-	else
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	if (!kvm_vm_is_protected(vcpu->kvm)) {
+		if (timerid == TIMER_VTIMER)
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
+		else
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	} else {
+		ctxt->offset.vm_offset = NULL;
+	}
 
 	hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 
@@ -1083,7 +1087,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
+	if (!vcpu_is_protected(vcpu) &&
+	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
@@ -1687,6 +1692,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
+	if (kvm_vm_is_protected(kvm))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 
 	if (!kvm_trylock_all_vcpus(kvm)) {
-- 
2.51.2.1041.gc1ab5b90ca-goog

