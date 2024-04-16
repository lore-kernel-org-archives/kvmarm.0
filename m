Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E1B8624C
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261485; cv=none; b=CG+gkoX6fZ1j4q2IDGITBgoo3NrU3lcA3sKO+GHQacXqaQcCRs8wifVXk54NIe2Fa04QcbSFNXmi21GhYsRD8U13YNGt6vJvl9IKDxvK8o3awe/+U01O6A8DoHzI97RK2zXIcLhdElsygi6WI/xBdr62weADvhW2F1fXMn4bEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261485; c=relaxed/simple;
	bh=o4F0upcJl3jceahU36AlVsn3onpojDjnFx4w2KrjvmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nCTnABnfGjoCii4e2HwY8DNu4dLR8E5x+GqDbq2QVcL57NVdVEgNX0S0Ok5RosKKMJLEfNJ1y/YCOKiMfIEn3HAEo+Y5J+I/c3jOGmkmJjztavHrn1dRwJqqrzAzaKb3+JPWXy3kdh4PUow/GDeU/ODG7nb13OODFfBpnkDc9w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w+pV1RNE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w+pV1RNE"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ae9ff0322so16712497b3.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261483; x=1713866283; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHLBWYbJgzxFPZrvHIRl7jetHirnTP8DP3eLNMJieOA=;
        b=w+pV1RNEntO66G95eWTEoOKYnp4PAh/OPXwW/LHyBOzEL3qH1oudDP4ET6Q7atbdzZ
         1x8viWe/BiksfvImE2XJVZglfN/JadYmOj4F3w2aKWKXO2632TSmk9cNgBNlUi9OXLuY
         vFhSbFInQLyNBN/h+MY2LXZ6DMSaLObqQHgCQfm+Y7S8Y+bKG0oVUnR736kkjJ1xnGzt
         Vo3Rwt8ALw5wW4cMzOkD7XDjvsq7e4KFTWW18ww/zqT58hyGCRwMhoKRPFSaM7Br2PUA
         v7UYduKEjn68ogCnbo6vad2ATOysHq92jAwiPOnbgpg9jH0+VvcFA+RIC6sW7JiQUzf6
         HnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261483; x=1713866283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHLBWYbJgzxFPZrvHIRl7jetHirnTP8DP3eLNMJieOA=;
        b=Qq8lYdWna9ZbhonGw7Mk4woQmDfG1F4bJA0D3CJRYP7U+017yDw/o00mePB2qQiP5a
         GWP1cDiSIE3X1xKvhqq5RlvbIqxHsLLzgZGoCUEBfOdKlUBYa7UuuuVQLU13sYIOWy37
         gjcmzINsMQyst+t8YrrKDB7GaOlNSy10tC1GRi/Hj02zIYf0LZlbd6xGUtW/n2MIBHq2
         HPkAblOr9z6BsF4kEZoGTi7eMskwzYTp92M30ouYUEbGXTyPmG5yVUBPbyUzTnldTA7A
         F9BXOzy33bEcXQMNw94Gk53qsV0kBIGgtJPX2p56+EIQ5iSH0jfvEWhhnqgACARtFpar
         c7yQ==
X-Gm-Message-State: AOJu0Yw5godU6fLtZ1AzGYZgAFdECdKA1qYlSb9qgJlfxb7Z944dnOTT
	eCx2cBs8vtKJhmY+QJwnNGy4ExeI9oxf30rqRuW6tn0vV6Rru7XyOrf7l+mWTX5pGo+sWzRzlrZ
	NYZFLDGVtzIy8rAGRKInpedW9LVGS0nFXoMYedMgtus0aNPA9x1dr5ykNfmSeZvj3b6sqPdqi0V
	yS74ooSA++iVFJcZwuZTs3lhkNAUM=
X-Google-Smtp-Source: AGHT+IG7zsGxAqLEsGXVMUBnXjzoz1jB6kNnScrYXJqas6xWkBmHMpkegLWqtgTkHNPKuCqkJaqTpZnMIg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d790:0:b0:618:92c6:64b1 with SMTP id
 z138-20020a0dd790000000b0061892c664b1mr2639603ywd.3.1713261482966; Tue, 16
 Apr 2024 02:58:02 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:27 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-37-tabba@google.com>
Subject: [PATCH v2 36/47] KVM: arm64: Check directly whether a vcpu is protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Use the vcpu_is_protected() function instead of the more
long-winded way of doing it through the kvm structure.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 41e3db960ccc..580297a701d8 100644
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
2.44.0.683.g7961c838ac-goog

