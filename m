Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85A364EBC
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 16:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641350; cv=none; b=QpRUooUvIAAYdWTcK/GPoNP8fOCOE2LRpq0OKhSVHU3IoZUJu6QYQNsOwOW8Ry8vZSPZ37SNApdejIGI4Ys1Lqnu3s/OhSuFkAtkUbox55GXMvGUpDNYABfe7ooB7VGn/XXv3GGlHyHYlku4AuSqfXx1HTtvQC6Duh7lnkYYwlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641350; c=relaxed/simple;
	bh=/xgapYGhd/TA/B5MXAVB3XXtgz3ZRTvK/g/SPJvQHAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mqq338Ghf/KzBTiRlKe6gwZsblCFRP2N5zfAlzNhPmvuHQVK4cUtRaznthi5OonaHSm/XlqJIxkcyFstUUJAw1FXzAxxdu3CfkWiJTUwGFRo3PL1qQ7iR9oD3d2eyhw/lnqtuimA3OuHfra37FrdDQce39cLwXiKUv9CjMLtQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WxNmafIt; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WxNmafIt"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439c5f65688so913536f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Mar 2026 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641345; x=1773246145; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oCJqMFMJBFzo1B9Dat2jPTYOPY6jcDnrEpSARx0ibE=;
        b=WxNmafItn/Q5eN8/GZ51FV8lQYcFoyraNIaXnd8Bsa4r2cdBo5m6hjckWmA36bgzQ9
         IRFlJdWInswtfXN0yjvwC939jPZhx74l018cFS1eeEfz4K8fJ/D+uEFiQwwBf80pfsfD
         qWOw+Gv2RBiLZOY0B4ThVRIv+q7n6DwLex/itLhnylIYZqzgOsTteLYs25bgJ14H5fEP
         7Tbc/eNQAMUbXeimpNUU3B8U3PaYmMKI7zrIyKrY/9aiP9jnh+PH2KPZyzG4ysPCS/CO
         kglBiRwou9fCuWq8vk0peEm+xqsTOtQ/OAgtbjyFnfTQqSrLu1kUIyri5h078eSUg6JE
         Y6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641345; x=1773246145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oCJqMFMJBFzo1B9Dat2jPTYOPY6jcDnrEpSARx0ibE=;
        b=nldqFSJLk/cJPvSXKZX3rcYPRU/smWUzsqLimlgTrWAoMj3vfymLu+WtTTuYo/gSy9
         k2+HADsArg0pwGhBZ2Hr4YfxNIXxNeBCs5l57V57FD6qx8SYY5RKlQH6Mgn/PF69vpuC
         G796NBild0XxY+y1VNAAN2MpuF07HAWGWaihig/7uJOxJTG52KAfv6LnKlSzyjNNJtQS
         xiAIczWUrO0AnnaS/2VMY+e7j/qIrQuhwq2/WLGfPSmx4LLNeXRyuUXKRkFJRNTuc0Qj
         /wYlBQuS49+WeSvAaVkvvAYDYubY4IPCeGYjMs7Rwz0QbznQ/8J+ALtnInyYPl2N2gJC
         6VXA==
X-Forwarded-Encrypted: i=1; AJvYcCWRonY6SgW8+90FZ4GsK3hbpuRovRrBlqKOFJJgjWmsZQ1nbAtve0wlkALssYtqPUvg1d5mzu4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yycw6Mr5n2P97HB/BaCyRNcok1zcH8DTTmXiqjlr/H4A9aIjvej
	ZIFZplhry+PRpM/YXm1xaPEuF7cWSylpuV9zLKSC3CQM41tc4A5KoaFpH/u0oBw/980tpfOwt34
	SDw==
X-Received: from wrid6.prod.google.com ([2002:a05:6000:1866:b0:439:cc48:d5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1acf:b0:439:b3ff:9ab9
 with SMTP id ffacd0b85a97d-439c7ffcb29mr5321494f8f.48.1772641344607; Wed, 04
 Mar 2026 08:22:24 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:21 +0000
In-Reply-To: <20260304162222.836152-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-2-tabba@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Fix page leak in user_mem_abort() on
 atomic fault
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When a guest performs an atomic/exclusive operation on memory lacking
the required attributes, user_mem_abort() injects a data abort and
returns early. However, it fails to release the reference to the
host page acquired via __kvm_faultin_pfn().

A malicious guest could repeatedly trigger this fault, leaking host
page references and eventually causing host memory exhaustion (OOM).

Fix this by consolidating the early error returns to a new out_put_page
label that correctly calls kvm_release_page_unused().

Fixes: 2937aeec9dc5 ("KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ec2eee857208..e1d6a4f591a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1837,10 +1837,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && s2_force_noncacheable)
 		ret = -ENOEXEC;
 
-	if (ret) {
-		kvm_release_page_unused(page);
-		return ret;
-	}
+	if (ret)
+		goto out_put_page;
 
 	/*
 	 * Guest performs atomic/exclusive operations on memory with unsupported
@@ -1850,7 +1848,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
 		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
-		return 1;
+		ret = 1;
+		goto out_put_page;
 	}
 
 	if (nested)
@@ -1936,6 +1935,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
+
+out_put_page:
+	kvm_release_page_unused(page);
+	return ret;
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.53.0.473.g4a7958ca14-goog

