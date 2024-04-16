Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D852907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261431; cv=none; b=kyuN1z9DECRp/6gn5mqzewXeA3FnLUUFJl01A0YOiDrCysIisUV1HJgjcWgdiagnawNc+6H3gzT7Go/h9uxyDj6pv3Dbtg3Y1gC0mytFHgZ0PWAzguX0VpviiFc9xhImuGPr+KOXGoz/6+qfHTAlsX1Z9XILCeOrmnyQ3xMDgE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261431; c=relaxed/simple;
	bh=ouRyPT952cpvB/K1oZAWbkoxBQ5GFlfWtv8aihXH8sQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YHX7hNjbwgCRvSOmCQpZ0u6GUxDA5E8rR5imVJNPD1s0qMXE++q4nsgI/WVBIBCGU7U8jp8z0TbsR0VtjJPoVADwGmcFKiWXwXxE3h+Rt62+0qJae5/VGpIsx4jqt/Po20xg+h4ibMT5wZf6Q8Q6hQAfuyFel5WunmoLkRQMjow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YdT3mhX+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YdT3mhX+"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6183c4a6d18so62851227b3.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261428; x=1713866228; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha7IJoYQ+3g7QlogTNFW5MaEL8QI9C8LEjpSkpmbDPM=;
        b=YdT3mhX+moZfofiHc7E5nsTY9vGwvQBqJjWfooin9nYgr4DsftQxEld4ItwnUOUoe9
         4NrHoG6ymT4iC/eZllFUvsitp1+JUrAtkGA1C1xoNqC54CcezNeXiH9iAsr6uM0T7PlV
         J1UJvl8UYav9ZDJhsyZ9oOqYLSJ5xdJS2zRLeZx/37FckDnp5jxFovYYMDv3c8fpTHc/
         /3O6XSRjvMszAaZCJRgK9+mDmaLsD7ckUxUqn6GAOcf/nWf/Y2OY4G6YJerUxkz+nS/p
         flwivA0w7zA1wbKm1pztYf6/aFznP8QockvFxGkcMbz2uZKyVoYEkhPItRDDOcwVb6Mb
         DrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261428; x=1713866228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha7IJoYQ+3g7QlogTNFW5MaEL8QI9C8LEjpSkpmbDPM=;
        b=Bl94RnnL/7SALyJQ1RXlMlJ45/oASgZLxiI3cO1j35XxK4uz2IvcLT+y141/owQUfr
         3pLNVUoYfd8EWO9kNLYyv/i6/wyJTyHBQR969/aEw4UHxLuUxVqraGOCrhdGI2C4Ygxp
         lyMa2noPY7eJ7uTftK0zKb02dKYYIc7Q+AnJUUDIpWXV5IPCNrB6gi1krwTj9qCi+9L6
         +EfoMIjD6JhwMkoiyfqkDc/cIchzIFIXblveVGh+kNNYMd+eMjGMcv1MbGsy1J4Z3HaS
         Yri566CIht4j82T7zPcO8an2vRZuZy/sK1h2b6o0Gkg7a5F0Q250kmTDz5pRgRiptSjQ
         uNBQ==
X-Gm-Message-State: AOJu0YxafkH8zV6Gik9XWuI2KNhf86ejIoRrxYfyljG+TBKcl5hO+ofu
	fyp/Q+GDwtGD78myhsqM4Bb5wgAcl8zvRYBPek5tCfcZNdMLsa0z2IfXAT9/EP0fSQEH2+1BaAo
	uk8bgXyYZArRFQRU/+G32EkLIzn592q8JKSDWF0t5CUKUVduVX3SSH0vc4p42vrEJ841vJNwZ2Z
	lkab8kOo3vg5Xmd87vM4eifSuLvDg=
X-Google-Smtp-Source: AGHT+IHiC4z1gqzoyLx3EvhsovOV/1m1RIJd7KAtaTkFpr5IB/xKhypcXaLsB3Wl62Gz0gr5dVmVWFFakQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:c241:0:b0:615:80c8:94eb with SMTP id
 e62-20020a0dc241000000b0061580c894ebmr2952397ywd.10.1713261428569; Tue, 16
 Apr 2024 02:57:08 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:03 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-13-tabba@google.com>
Subject: [PATCH v2 12/47] KVM: arm64: Add is_pkvm_initialized() helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Add a helper allowing to check when the pkvm static key is enabled to
ease the introduction of pkvm hooks in other parts of the code.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 261d6e9df2e1..ebf4a9f943ed 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -82,6 +82,12 @@ bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static inline bool is_pkvm_initialized(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       static_branch_likely(&kvm_protected_mode_initialized);
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -89,8 +95,7 @@ static inline bool is_hyp_mode_available(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return true;
 
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
@@ -104,8 +109,7 @@ static inline bool is_hyp_mode_mismatched(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return false;
 
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
-- 
2.44.0.683.g7961c838ac-goog

