Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043C1D2784
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 08:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881844; cv=none; b=Z4i+MJ9o+NNwVJVAv5d0gnTTDpcVTlpDkFM8Mk0F3ehMd6+LPJT7mZJ3PBxEg7GMNEKfarrs96tC4SJc21i3SrmyxsepAAFlSF0rXt5ytIG8TG4xqJgtpM3/aJ6XNzIRdYsotuaL9y+1VFp5S9qou0LpygBiQ24f6Yr2hQJomF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881844; c=relaxed/simple;
	bh=yF+g4F+OY52/0KR1mFa7JxszhZTeu/CQOWPnoX3pVpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oYoTkFOC5Xp2I7MDXeOQfnZt8whqhXKElq7b9+Zpa8yEOrn4wi+1+rqtW2VG7Q0DygTcbm0oKqlgrHYKtxkjQ6cg4QZEXY2+ECw0XPASE8yGenFZoX6v4zaHQ49y0r26QMA6V3VtKDz6pu6Ney9O6OA8gd+PcULPtvl8XUA0X8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OJxbmSzg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OJxbmSzg"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e292dbfd834so10734307276.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 00:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881842; x=1731486642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4GbN8ZDurMjcmVHL6T0Xi9xUq1GYOGvqk92rYIEnWQ=;
        b=OJxbmSzgTSQH8eb3hEZGwlgIwrxm9iYgEuN7X6KPfYne7gNbDQV4AnoGzPukcGXSeU
         L9UEU5CqXUiulTjQ140XqAMjcO8o33mvhYrWVckLF7u21+RLLBxkb/HugyFaCjAXlPgl
         JxJoWHO+Cwjx2lJ/N+GqVMryXEvqN0bnwx9xl8lE7giAyU3C/foQzRz7SfDf181cCyNj
         ddRBcOBvFhF6fZBRZkHmMrYlz8tzo0Xl+SH8QFzNA9pdlLecuwqQSzejSy+ewC2zjXno
         UDGCzWnKnyIYeqZodrIhTMB473MkAeYxA4mTUNQ0a+SGB0J8Fk2F85LJBeOPu6NZ+e4V
         EW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881842; x=1731486642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4GbN8ZDurMjcmVHL6T0Xi9xUq1GYOGvqk92rYIEnWQ=;
        b=vSUxc3I/zaHNo0Yn8ePogLyxgb58BfJU0XxQ0goMPsLCxf15FSaZe40hT7/YxDP2Gf
         754RzCrmMv5+rEB+Sco8pzj1VaKZVRc9okCCutPw1xuVKK0vimTGLCQ1cCZFhAz6aT/W
         LY/omF0iYBl+ufv8Wm/r1c1R4xTJNQMPRQGChIIyWEqtxcAnhuiYL0cL2tlA3hnKa2WA
         nOMDtkn4x+JMvM/pdWyyLFmMpZhEuHtVy9DbdgOTtkx3LF37nP9qhZoXXuJXpPJMwbFQ
         5LN1GaZcytZ7N0pVwPQj7zRTYZEJexao9MsAnGVaxzDqXeTMrNjJHG0nEZQAPK1aMvIX
         +6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH3IyEUBH5v6YGcfnAiqw5jf+kLooCl5y8hmNKKOfRaLjaTfn/XBc9Nw5AGIbUiZU2UcD0Lug=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze6UNDhLXNWXhexRJaVlNuzPCYkOvmxDZtMC3W7Qi59Yo4O80e
	ksm9LQ7kE2T5b9m3MW3yelJj3TONPh81kHSWbnG/OXHVQMuwo5X/9E6FQyLS4ZHE4Axcd2yNS97
	HoTCXCgKRCCV5+6xhNRtokg==
X-Google-Smtp-Source: AGHT+IESgZ2HUDGTGAdUvYoZM+ViRqBFK9RcS/H99OhminhorZqyukanemB5KOr2KI9Z7I4wBJZ181jopq1rHk8LBA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a5b:308:0:b0:e33:2432:8b75 with SMTP
 id 3f1490d57ef6-e3324328dedmr19767276.7.1730881841856; Wed, 06 Nov 2024
 00:30:41 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:32 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-2-jingzhangos@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

In all the vgic_its_save_*() functinos, they do not check whether
the data length is 8 bytes before calling vgic_write_guest_lock.
This patch adds the check. To prevent the kernel from being blown up
when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
are replaced together.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba945ba78cc7..2381bc5ce544 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2095,6 +2095,10 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
@@ -2250,6 +2254,10 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
@@ -2431,12 +2439,17 @@ static int vgic_its_save_cte(struct vgic_its *its,
 			     struct its_collection *collection,
 			     gpa_t gpa, int esz)
 {
+	struct kvm *kvm = its->dev->kvm;
 	u64 val;
 
 	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
@@ -2453,7 +2466,9 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
 	if (ret)
 		return ret;
@@ -2517,7 +2532,9 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * with valid bit unset
 	 */
 	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
+	if (KVM_BUG_ON(cte_esz != sizeof(val), its->dev->kvm))
+		return -EINVAL;
+
 	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
-- 
2.47.0.277.g8800431eea-goog

