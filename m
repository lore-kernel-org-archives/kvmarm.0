Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FC13EDAB1
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290839; cv=none; b=chO8zptn1paakTXw7HPprSh865Qkg28NcPsMwly6GHPM6MFLAfacI1fy/42o8dfvLj04U87+pmv+ikSG6SPwrsQYCku7KhaeDRJ12ypQsWPCzdf4AJL7XNj4oMkFU319xqZQau7VV3aeZRyJDCaoJove/wQSZ3Ilc0PSMzdg5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290839; c=relaxed/simple;
	bh=fgpq6rQSLEWQtHbMKFat++lqoFBcKp12CqmW8ZpWJZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YpZ5e1Jt6ORNA1xu+lCi+SK47c+SsZhIDGm+aM1Ku5VIl+41/D/tat0Gi5kkl/ATA43co+YMgKPxP/33Nny3QuIzBiPsFayWytxZROBSeI4REYad1+oR9JKMVOXmlNbYCn0taS9bUh2AQT7lQ3JLaN7JqkSS7EOxmIBSvMZG+kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KfWpcXYK; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KfWpcXYK"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6874f70372cso669639a12.3
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290836; x=1779895636; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DJX4EJoKniCBYBRiPrwr9iFrJzTWXNPzF+QsbMYmjU=;
        b=KfWpcXYKLHsKPIWeefTeYzgPvyFdBwGRMkyEp6wBUn58/tuPqs365MaImMts3w+346
         bAtxaNxEfJlNW4/CZYHu04b5MPGCwL4r8cUVlu0paZzap54NXf55n70vNv6NCbd7VclA
         W79OCGJM+vtpFVacbYu6dfKiFpUviDc7VXCVPKqDDeJVIOwtchOo2PPpyvYqW4Xw7g/7
         WVfSoy1mP+ulqyE0k8PLOMU0WCpqPpOvP1zyEKj8tEvpaP5s2SGfH2wfwTV/9FO1SYk3
         H5oG7eyIp+BpfPRqOoAvnDgS5vNp9WhpXoZUXUTbtyJYh8o99QSheFat+5S2uw7N5Ysf
         jjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290836; x=1779895636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DJX4EJoKniCBYBRiPrwr9iFrJzTWXNPzF+QsbMYmjU=;
        b=O6DzXMGNQDfxbi3wzlO5fK+ROjOgiDjgEOCt4Wz2BHxLBckahFcipjfygChkkBulvf
         xyhgXUGP4ihGB6YCMuGkbr2aKEYE+/LwS3PHlI0ghbMJ6acqhHmpUDWZkCmLj3/Ea6ew
         G5CtiDnxgyNxTh4xcY3rXoCwu91kn1egaRuQBF6plNocMsYh3eQajPhBgnxqZOk0a22J
         GGRhEUuy+sPFuNH49dH+kSmkH+bwfWiiAGuBzTI2zCEUBpw54MHFI3VfY4QWROjVmy8y
         SReZ/SJo7WzD0RqLhIvg849CNxpCHnx3OeBCN5J/vKksngMSvtfnPLrT/1u481OGTRfc
         SNZg==
X-Forwarded-Encrypted: i=1; AFNElJ/sF24Bs5FFarz7/UVkZT3psW2A0kg92GxAkjGyDe5DSGtZ1jE9AqyIZ2+oyixW3zDirDhom7E=@lists.linux.dev
X-Gm-Message-State: AOJu0YywgnI7x90oRF/0RdDRfNdzBcnVeK65vjbVK2cP0cDS+MvOe93Y
	Uxyoklz0XFF0TQX7U78TmNbFz01AI3VwsqQ7+gimRPmZr7SuXE76l3WyffqOhpDO20m1Q3yg64P
	nmScDsQRnHVmB6SbEJ7Vwgw==
X-Received: from edys23.prod.google.com ([2002:a05:6402:17d7:b0:66f:c143:4ea4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:d6cc:0:b0:674:bf55:6f40 with SMTP id 4fb4d7f45d1cf-683bd58a136mr10437148a12.26.1779290836035;
 Wed, 20 May 2026 08:27:16 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:35 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-3-vdonnefort@google.com>
Subject: [PATCH 02/17] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d3137c16b632..725bb0fb941d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
+void pkvm_remove_mappings(void *from, void *to);
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 773426a68d2d..ec59da1322a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -146,6 +146,20 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+	WARN_ON(from > to);
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+	hyp_spin_unlock(&pkvm_pgd_lock);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.54.0.631.ge1b05301d1-goog

