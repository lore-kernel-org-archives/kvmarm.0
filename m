Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDEA3F23DF
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290852; cv=none; b=EMt0Vu73OQuC69CWqlVJvgn222tLz0PRlzMvq5Z3+2IC2K+aync++P4b+n2jEx3BPztgUW2k5PHqbZVQ0Gtche5H7aTD/KtjHB9C7936fuQ6oJzin2+Hl16uDl4vnJebVecV0ZKfFD4fSP4Y3ZXPdus+JOQtdRBo1D8rWfoECHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290852; c=relaxed/simple;
	bh=ZHiAXlM3LBg9LeChQ96wUvvfBNbS/j+V2ZSh/zR63wU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HPyqUs7Y4Alv8IwViopNAqgxNwVaX0iuj+Djy3WB/u3GgMWDmvHt00v8e8fwmZAne9CusQdFGdQuvBOJAqEGNGbFu4EbMgNwX3SnAk+HHgqCuTCf4pAzbglGbMyGChIdTANuFniv5LmmRafqmaAjIFur4cpKwBrYqOgIWo2eDKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MUFWGPrF; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MUFWGPrF"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so3300649f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290850; x=1779895650; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O3rJL/Yi2DgP7I/iMEJLiWJwqpREFgZnSjxLrASERUQ=;
        b=MUFWGPrFHrNJygGW65eF+kuKQkOwZMV2J1B+t6Y0+3OZMXRasyP0vjIP81xr8ySEmv
         dTa5mkWYHNJrqbOu1gfAD9VG3WQ6Pj/KEO4U9wgDaB0RVkHz5lYSxg/x24I2A8ZQuLO/
         T7mQpu2OjAogt6sb+vHVZ8KihjSyrKdhHiVK4XjNV0fcsoqyEBHtJ9h305cof4XxLk/i
         2UJtE6RbUfPjgCwz3Znk5lLA3rxa4hvoTkjYTL211GXq1xV7kxKn2/1FEuXTmEJC0H+J
         30DYMZ2YbKHyLInqYmWT2Q5czrXQGWpfLL4hRs23Fda6sEMP+WnFCqkD6uesoEAxHFtX
         /BDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290850; x=1779895650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3rJL/Yi2DgP7I/iMEJLiWJwqpREFgZnSjxLrASERUQ=;
        b=fCBRvDwIdCngboZxaQmIRpiGwU6zVB1Qalv8/vnyO8u/lf2O+5IXT5sYlJaSQPx84n
         ziuOpKlQ/EIetDxeTUK5/2/qQZVGCwVWTLtgtzzKKuwC2bYXs1OJF52+cYC1wYcY2VCu
         CMnFq0e7OTJGmd68bvAQ6ALReArtjFzvJKuaPQGcl2XPKSA12SYzms3Trg5a9GxEdyts
         NPZqfZWzpp+ptFMsEk6GKCEwkmQYSbRTYEwS8a1mGaBaHdZ7T+TfLR19zL29JM2lfVSP
         +rUrF+F3xtalErER1XjJAvDSmxE6NMBe6ZhmUU9xKpFnNOl8hzplOvYULJXOreUlg8y9
         y0gQ==
X-Forwarded-Encrypted: i=1; AFNElJ+rxeN0qbsAy6GClJdx7tpAb3Y1WS3ykjx4rKB/nQpr5ipf2pR/6+9je2KtANQBP88MMHTEnCk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSZHNchsfbUE7LcMBA5953yfeIYtvHEOOUR5850O0GCQ5c10bO
	qN22eJpAOvHYp2lyBwPfYBeKRaGMSu892tMvPIOaZ32Tzr2tIe/WuUkOakQ7VDzhH+kXx/eGgad
	Qa7rlCiFirdvYlXxP6+aDug==
X-Received: from wroz5.prod.google.com ([2002:adf:f1c5:0:b0:43d:7b52:1f8c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2313:b0:448:7049:a6c9 with SMTP id ffacd0b85a97d-45e5c5b387bmr38092483f8f.5.1779290849666;
 Wed, 20 May 2026 08:27:29 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:47 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-15-vdonnefort@google.com>
Subject: [PATCH 14/17] KVM: arm64: Use noclear for PGD in __pkvm_init_vm error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In the error path of __pkvm_init_vm(), use unmap_donated_memory_noclear()
instead of the clearing variant to release the donated stage-2 PGD back
to the host.

This intends to eliminate the clearing variant of
unmap_donated_memory(), as zeroing the PGD memory before returning it to
the host is unnecessary in this failure path.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ebdbe9c92689..3e7f7606a3da 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -845,7 +845,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 
 err_remove_mappings:
 	unmap_donated_memory(hyp_vm, vm_size);
-	unmap_donated_memory(pgd, pgd_size);
+	unmap_donated_memory_noclear(pgd, pgd_size);
 err_unpin_kvm:
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return ret;
-- 
2.54.0.631.ge1b05301d1-goog

