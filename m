Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C94C2907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261418; cv=none; b=R5YCjEanQQ/p8FLe9VK3pzvV99+21R3E96M4gAYnvOjf2epUvyn5pKsDlZIkPpHiTiPjYIWN9Y1lhKYPystqg8962AxPypzymaIMzoGeAWbq+o0tKsM+6VHp0HfnqpG4F1hGZWIANE+YJox20BIC+re48qLveSXQ7q1oQxyc9Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261418; c=relaxed/simple;
	bh=MgMXVeSIHxvtLnkhLFq9eIssYPNxYADi9bKg31l8mgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y2L7Tvbqj1B7pYJ9GoqUc77PQSDTTKXMjCO1GacGCa4bGeMiLAcwLXIkwy+Jb99CHnPJSB71v/Ui9ss7Z95MiwZFEczev+fXiu8HWE9Y6ATYNhbhEXcdPxIbZB94s4JHPb6AUS+FoOSnsR6xKozx5qieEjOM0E6mKK036cQS20o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XKc0OJrD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XKc0OJrD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41663c713b7so25364185e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261415; x=1713866215; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdW9gWRjLdzJopsGZ0Jg+J0LCIyxLJlhQ5QPIbZboXo=;
        b=XKc0OJrDZUCgGUfuFgxV7r5U9a2qN8V0V62okP39ykOBYa6TE07Uhb0Qi4uj54b+DO
         eeakt0v6hALSZsd386tKGvXUznea4KQZ+sYMoy1DUGaJqFez6sV3L80m5Iap0Oi3Rea5
         vz96zxHz0PLKY7WVsVlVd6ib1JLWhVX2NgDJpjy9TPYPw7FnnR+tpSF0cgnMnQgRga4v
         Ay35qYZXBAXqYZTSoqN1RhBkp66+yATuRKMmzbAQ8SaS/sVK5ysgpBFYvA+Z+ivZlwTv
         di3prV0heE5ilTPWcroODE+MA6Nrr9S+IrkHF5+d82MSUmKutZRJypNUi42ZjcExlSa5
         RG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261415; x=1713866215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdW9gWRjLdzJopsGZ0Jg+J0LCIyxLJlhQ5QPIbZboXo=;
        b=sQPJNl6iwh4NMWLz8z+GR/+828ejgFDpJsEVzLQvhsbseopsYO6FGjSjjy4FEpprkC
         hIgXLvSE71GKWlxOq4ZuEMRWDEvuBRlJTxg43oaeEi/vyBhu5xz/ZuPeqkW7dejOvR5P
         +hEfXSrWt/qWJFZOAeTouzKwbDjSTlZj476x+X1hk5n9Lrpy4zVjUJOX3oTYQ9QV895+
         u4l7hJ7Wp44O1RmvY377tcHuG9LuNwDqR7hBSmdSW6zxICWDzDshwztFo2wvTdGfvfmt
         X5js8HMaFLOY0G23pcNVeUZFw9Toz5BAe9TaFqnkJJUFRhxOsiVZoQf81KQSJuFi7WY6
         kliw==
X-Gm-Message-State: AOJu0Yw0zqB+UFAJ/27BF43dbA8yEKjiPpkgQ+MZQP3Hks+odiF8RrUp
	yS5HkrGIvFmqPO5wxEVlAtMAHLi/2u5xv8hxMUeBLvLL2L3n0e1aWikCqvUU8J1kRppJWS4rDi9
	GXi2pQx18kffYi61rHKR3igRxffa1pvQU5zaa667yNosg69NRnRr8uUm99M0DSPmxQWSgp5omr2
	24NheCXOOKTAI8tQRzb1I+AAcy2bU=
X-Google-Smtp-Source: AGHT+IGOoIclkmbBI8c3JgebyUoke3PE7x2XPsRtRrBn+Xs6587fK03dGTWa+MbP5c8l8FamExFWaF3rHw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c9e:b0:418:273a:6d18 with SMTP id
 k30-20020a05600c1c9e00b00418273a6d18mr12970wms.0.1713261414904; Tue, 16 Apr
 2024 02:56:54 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:57 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-7-tabba@google.com>
Subject: [PATCH v2 06/47] KVM: arm64: Change kvm_handle_mmio_return() return polarity
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Most exit handlers return <= 0 to indicate that the host needs to
handle the exit. Make kvm_handle_mmio_return() consistent with
the exit handlers in handle_exit(). This makes the code easier to
reason about, and makes it easier to add other handlers in future
patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c  | 2 +-
 arch/arm64/kvm/mmio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e57aa3502e13..0b5473fbbd08 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -974,7 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret)
+		if (ret <= 0)
 			return ret;
 	}
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 200c8019a82a..5e1ffb0d5363 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -86,7 +86,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
-		return 0;
+		return 1;
 
 	vcpu->mmio_needed = 0;
 
@@ -117,7 +117,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 */
 	kvm_incr_pc(vcpu);
 
-	return 0;
+	return 1;
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
-- 
2.44.0.683.g7961c838ac-goog

