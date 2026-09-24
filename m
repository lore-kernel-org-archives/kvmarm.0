Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15E444E042
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244321; cv=none; b=AYP86BbryYJK8g2ZBwUl3vTVcwuiWz+7PN2lZWIiGkxPcx6MnQJe7RXHKABjkLwUFQbyE06WvAJm4Yfl4dW7PPx5PqrfKRyPxvTjgk8gdLBYRGr9BwKzgOSG4xQZsoNdJi4VDD4t5bCk+kgLxl5RmUFwV9TO6DxAHq7njFkgnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244321; c=relaxed/simple;
	bh=48GblSGj/J+GQHrEzH5ZnJ25q4weDrNlBBC6kw1wexc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tjJP5lc+7JpGcwW0gwv4JQIjwb0MFG5P9YQQs2P/Gxlhl4cLCUYAUHxTyXqgjzoCRBQHBBHav8VZPikejPFd/pyK+L9uBsVg8W5P4AfX25WxflwnyosLquHjStKUyiJ85ens91b365tnwnF4VfblBP7YEGfV7dbQydBd9+hGfNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nvIuuL9H; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nvIuuL9H"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e6422198fso12787895e9.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 03:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790244310; x=1790849110; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2O5/B8XsB5AMjGVtBJTzj4plcOP6VCanhCNxSU42J2A=;
        b=nvIuuL9HB9YVPVwE/bNf0A2yWqiE7Tz3FqWqlh120ekxFGW9+IcNtdWKN8/zyUXoSw
         skawFGhQAoKX/pHSr8CHcDqZvjPhcFjOgat3Aj0j5+VtGvISas4AjNbTqUKsAx3XE7g+
         ljB7I9iVFShBTC0diSqNNwju2ob3F7zkKrYjbMMNGen4i0NnaHlzMQpQkH5+3W/8m4cG
         2vIX5t7lhwjaT5Gc+vLNkLDZNesJ4TA6sM4A2ZhsyDNxciXjEfrp/WqndXuWMPQMuCKq
         IJgljukIzqobRUDfxS/MNFIgyxUkgUyJaqCObVXrBs1DbSLDFRe0NWGmk+mWdeMt6tN7
         Pthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790244310; x=1790849110;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2O5/B8XsB5AMjGVtBJTzj4plcOP6VCanhCNxSU42J2A=;
        b=yf8XG48iZfSq1A6c+/pQsGDlXhubt9hrrP7cUV5ZSRb2/sZGiTnsPELEjSuTfJnwG8
         vrPAJViqJ+JPgh2gt3ePPM6Dy7NCRUBdt2WAi5KylhP1B3IF2+cIMINg5nzb+q1R4AQC
         UHs8ePYBDZlBohpYPHWYUL07MTOS05mNqHEq5DkQCyyJqhuGsn3IBDWYfBRxDvheNIxq
         nhvLgRi51+bS8O7CEZWBDJlvVZIvfuH2UXqXgS9Pv5+cECyL3ekL71DPPZQ/yB/2b7hH
         /6wAW45VwBcjjkK9sqmrTQ95dlsCEzSVoUiA4Heu9CrfdFsm3F22sXg4q5lJ4qcChIQD
         4vwQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfzc5SEv+Unz4vW3q8olUYUe6pSCqNQRbtuhfxK3vvJAIFt8WLKfe7P4QvYd9hsBj8EYvFNcY=@lists.linux.dev
X-Gm-Message-State: AFuF++mEerhUL8gaEqEPlppJRwezK9MsQisG9+5K9WiOUBi71Bohv4AS
	3iXKOX37hrRlLBJaXuoxFvS0gDUcre/sBF0jnDID8Zx5yYzdV8tlk1ip04Quv/6HBjbHBY49J/q
	6Xo3n1immPR3okBkzNgz9tA==
X-Received: from wmhp5.prod.google.com ([2002:a05:600c:4185:b0:49f:e3e0:4ca1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3494:b0:49d:870:7a69 with SMTP id 5b1f17b1804b1-49fe66d0768mr30398025e9.12.1790244309273;
 Thu, 24 Sep 2026 03:05:09 -0700 (PDT)
Date: Thu, 24 Sep 2026 11:04:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
Message-ID: <20260924100459.831013-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Disable stage-2 ptdump of pKVM
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

Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---

Notes:
    v2:
      - Point Fixes tag to fce886a60207 (Fuad)
      - Pick up Reviewed-by from Fuad
    
    v1: https://lore.kernel.org/all/20260917081510.1539013-1-vdonnefort@google.com/

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
2.56.0.rc1.310.g51773c2048-goog

