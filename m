Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015814831F
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561042; cv=none; b=QmIlZy15MAI4TpLwBxARtKtSGpydZuZg7+k5kgtUPOoUN8eueXed0K/1QQQN+IrLSA7GBw2lxbu5wyfVWYY2GdlWdfG23yDsXqYy4MoFBB3p9e1AW5r/uJ+Vx8QghIXD4IFzZ71sJlXIBJGNf9/M0ASBzGU87K4qoW4qfHgwKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561042; c=relaxed/simple;
	bh=4ZodK/YChdEx6NyfeaQo6UPJQuF+YgV6CeexDQ+Om2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OBIVvffK0VFx52a+ZJDBW5VfO3m+PY2/OMFHousEHt6jQ5Hn2QUiUzPUomBKnLHIm1DLQo/7KXpez2LBTy8xh533mR1pBxU7L++O470vAmRmrvvT9DPA95cYoah+uSr1MteTOSr3O5pcr9ZSRT1SYrtJHxEbJPFu7xQ4o3CYzoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2OPYzd9; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2OPYzd9"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a4ee41269so1931867b3.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561040; x=1712165840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U9xNS4D+R7fMaUz3BSadxzCxn5rAxoigNBWDeqDPIjg=;
        b=P2OPYzd9TuBAYkl9yBKj2RGjNd4frw/IaIVaiwtfxAZSGx2aqqQCo0nEGfijcgVlRo
         KgAAxN6ioiSJLn3VrGZ89OY7k7Qpu3mkGgLQUupUIdaqBrIuIb8jn6YH39+JCKINUASg
         U7BAx1l7puHUTl6nX9cwpBwWYKh0KkZ+4h5g6ehYFwnd8oVmd2o/3hFlMhOXbu6wf3QH
         FXYrDGbpC/CQl21dZFJNH+a3Ab5VRdyOIOCUAzRyZByyF8tHeHMSLw5XbQ+TCwmskSVZ
         Ng/wOp6AWcQ0QqquDL0uXwH8EspgucTy59r24ZVJFx6rNGeua0UW02EttPO5PvaT5HPF
         ciUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561040; x=1712165840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U9xNS4D+R7fMaUz3BSadxzCxn5rAxoigNBWDeqDPIjg=;
        b=iOA+dM7V/yhbcH/sJQI5ezDoQrNRnN/Xw8lyYXb3awa/o4bIJUzLBATrS5Acq7s0Tr
         r8mH6LQCripfm/+l0A9DawV+KeUQ4InX1tCS9pXlNuU1oiF8oG98SOWm5cWPyMxqs8F9
         m86mvMFdp0wOmhFeFHaxy0rpjpXJfcXn4+UjXmqzMcgg2zamlxipNl4cqUYVXJemWxVw
         aoPvGeYtRiKXJq3H0b+Wv0/Da0aljqvUhztqzc6Dj5bZ/CvNdo+b2FzYdAEaK+0phrQK
         4ug4ZrCZtmmGZ/ewSu+LZ1ChCFuiGc+6ThkXr3l4qOOFzTHBWS2Xm9vq0FQW4a1WgdJb
         il1g==
X-Gm-Message-State: AOJu0YwCFzf+kQbgZshaMtAYA/B8N0MF/tHR1fl6qAXxSDBsF7t3wRI1
	KZxpU9Cbycb7d7JB6dU3ryGsVenRbsMqjSUuKwn8k7zeWP2dcYCJUZ2hIRdsDNCknL5bnh16YEA
	jTDx3jw5iBBWzmbFwvzaW4lJrrNMRbezMqSztUmI2GDE/0DSrIEyf3kyVgd4KVFe4upCE3eTlbG
	6SqS/KGJiggw1ONsjEpfx+gQuuheI=
X-Google-Smtp-Source: AGHT+IH2WUH0JYc+2MhHl+KcbO/ih1y1tVnrLS8qftwhLDACkYHzmnbQeMmt2ekUMK2bXsFgJcOhZsBB9Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:df41:0:b0:60a:3d7e:2b98 with SMTP id
 i62-20020a0ddf41000000b0060a3d7e2b98mr74727ywe.4.1711561040330; Wed, 27 Mar
 2024 10:37:20 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:27 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-41-tabba@google.com>
Subject: [PATCH v1 40/44] KVM: arm64: Do not support MTE for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Return an error (-EINVAL) if trying to enable MTE on a protected
vm. MTE is still not supported in KVM in general. This check
ensures that pKVM isn't caught off-guard when that support is
added to KVM.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6e3c57c055d6..79783db5dac8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -86,7 +86,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
+		if (!system_supports_mte() ||
+		    kvm_vm_is_protected(kvm) ||
+		    kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
 			r = 0;
-- 
2.44.0.478.gd926399ef9-goog

