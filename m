Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ABC3ACEE0
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 08:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789632924; cv=none; b=TztjWrh9BzY1hcRV7XaQ4kWClZ5QBsODy4A/OToyIVk329ol+Hhwz+eZRAkT0I7qsoj2KbNVNB88Xceu21cQmL/ASTjJPOncOZ5EwkROaYUmmi4sL70rEzccjUB46W3ABvXO/xIdB4jvVhFZ2V+jkAN63SMEZ5Q85wtn4KGPCsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789632924; c=relaxed/simple;
	bh=65RXgIKwn7FBq4M59clkTj9L/t/zdkOCHrwmYbin2Rg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kqpWHcySnMG0o8bVY2DhReKdyafi83HtYp17phdNbGjRtshjzHHbZDfoxSKy1uwq1E1B16EPCvhFKdaZybN1tFj132BOolHWlyHFRnt5LtnT7QRGzB/ghQRaIZk7cAp31WwLF14AbJBguRSZklGsKQfa/yaTgfhTy+CK9Vf3+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xes8yOv3; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xes8yOv3"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso4646015e9.2
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 01:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789632921; x=1790237721; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=reUNVFknWKauPO5wtoSWArEl3uNO/FMpDcLAwU7OX7w=;
        b=Xes8yOv33OV7Np8Mmh+V4aWdaJVXPDpZxLRVs39eu9RcSOnlcQ3hcYc+WRXpxWJ4mN
         A713hZ51ch7SGxcEvNlvxYjOTyx6NzbFO5ZV0OFgmSlcwFBZ+dcvUmelJV5w43bHkuht
         tcUkUUGu0d3fErbY6ckqjNchfKXpMXL7/0IOJzjmH0kvTq9aRGUWks4iaOrUtg75C33a
         jSeMNoeHDgoH1CHoAt0JqNY77KqrkOUBGjZWJ5fcHbjeXPGoKYzAV+NIagVDeMiOuzZK
         aciL/NWOlQ40zjKcDKjXElu3BXfQuvcwd99lGB/HsI9W90ZWdjDNoTbqV8KCBMlz7T21
         o29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789632921; x=1790237721;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=reUNVFknWKauPO5wtoSWArEl3uNO/FMpDcLAwU7OX7w=;
        b=FG3zJEEK7hXUjDB4KL/Kp/J7V6zOgde3GAF33qbsVGfzdEE3dHNSaCswQAu+g8vN05
         gSBtI4aPuRzOP8e6+c6GSr1BPlujbWwakcDjBaougbLxfnU/LuNGpZ3jH7O4hXA/E6Ff
         KEjrAOCA9QI0NsPHVpouw2Gzzr36LX49rR5VhJSEf6rzNkiqiCmFX6pbUxCcE1OLLOCN
         ZGWNzGvre97+M4OqX72X2D/lJtosPb77At4xIaCELakHo9mhL9euDMrFwYXkjm5woe/S
         WN28M31HhvmBnZEbS7DZO83G9pbIAJimMIfo6ftCZ2wku1MRWsA2daxfwHlaQVWBEAwB
         8e8g==
X-Forwarded-Encrypted: i=1; AKwUvBwAizzejUr35/XtuMiDIQy98ZyrhRPd2nmq2gpSTjezbZ0GOD5weXfdo94ZXTk2sNANiGGjvYA=@lists.linux.dev
X-Gm-Message-State: AFuF++mf3zPEVqDzcZ97jRbrI4OlbpFhZZqacjenMtdD3A3kojvvAjhO
	DAiH8hgntQ6NIo3F1viJ3r2Ep6WRtpyGGXY7cNsb0sTQj4VQ8h2Ry+B92kixD4XRT6g/g9zKne/
	DQ5654/lyMoXmhf4yBCTw+A==
X-Received: from wmbjv11.prod.google.com ([2002:a05:600c:570b:b0:49e:65f1:a3ac])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5486:b0:49d:1d7e:4085 with SMTP id 5b1f17b1804b1-49eb732347fmr68061125e9.22.1789632921225;
 Thu, 17 Sep 2026 01:15:21 -0700 (PDT)
Date: Thu, 17 Sep 2026 09:15:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260917081510.1539013-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Disable stage-2 ptdump of pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With pKVM enabled, guest stage-2 page tables are owned and managed by
the hypervisor. The host's pgt is uninitialised.

Skip registering stage-2 ptdump debugfs files when protected KVM is
enabled.

Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/ptdump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 69899797dbad..87e5e7a4e612 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -300,6 +300,10 @@ void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu)
 
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
 {
+	/* pKVM handles the page-tables in the hypervisor */
+	if (is_protected_kvm_enabled())
+		return;
+
 	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
 			    &kvm->arch.mmu, &kvm_ptdump_guest_fops);
 	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry,

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.55.0.1082.g2b9226bbc0-goog

