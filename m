Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E26F1487E9
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561015; cv=none; b=EWq2c2CIUnoLqxdO/VArlRbWfm8NhkbptFVBUz5hjkeQVgVLKw+MDTCZLAK3bihwELVRYGF+Q6JS/TGXQrXJkL6g1L83IWtW9mtCfmT8+M+snbKxmPYFqYkh1ZJKcPwF8kLVsplnmjXsxlNhapeUI8UwLBq+2zmmXUwpbJnh6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561015; c=relaxed/simple;
	bh=MixoWdOhQ8NsdmymvfoRtCtXnmr5IIZVEen1QWRnpu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oq3cu5fdsoHwPRqDBH54iUrB6F12HOi30PHyUhfYbOFVbP7nbG/JP6OQnwsoFPuhALEHIm776wKd6NxelhQFd8X8qmiV8Mv0d9p4ABPNH+owrtHS++ENtHndSoXYnD6COKUwL2gd+/ogC1KCXgvgcIvmUqFR8BGmodLTpOBUeAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0nfEnayO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0nfEnayO"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so72291276.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561013; x=1712165813; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l43n2S4wFiC8ulJfXzIZV38kCMrsBjyyjKkSzPD99Cc=;
        b=0nfEnayOKXxn7lkUwTPJ56f4htCrUh3mpcn33quUuriAUVppmN2fSbJ/+kojOj8Maq
         M1m3GUU/FE+FPY8SP5KT6BQ90/em4cmtmf/VSHGDVucrNg+KAHbrXo/Ged2ciia+EUm3
         zFJXI+tQwt62Wr5+uPtfItJmWrMVUZ9AqmIesZ/WOcUIko5BDAo6AAcsBOzX8YxpW9WV
         77Jq0tlHDlhUh2fJ2J5bChTnyYPYpSTp1Ie5INPkVAKsweTHZCZHDFUGx+Njh99THTrA
         NS/u6KpmzOU1E6WHyAeu1DbT8pXXZy94Cj6HfhGAsvu6fbtKkQNgTPaN+kuQKApCUKuF
         HC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561013; x=1712165813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l43n2S4wFiC8ulJfXzIZV38kCMrsBjyyjKkSzPD99Cc=;
        b=peUyL6uEBPJ6dzr4TejlJG0r/qBvN3UyuV10Ez/iNda2g+9Hln2n8Ia6v8oP4Ovsw8
         HO2qEWqgwZmriNhkQXq9X81u5hNvewjZarf5MyTZovIib/uChEWrSDL4UPsiMxyihNpp
         uZHjAPBXidZs4zXdDVeuzB7uctwsL5KkEIt66B2wFfkmABLvjYKancHtc1MctyP2WiFX
         n4BOn9syR5KHTYzfOVG5KAAHq9+SrdF8LU/x2nCQtGPHiE5H0evfD5M+SXbmVROzk/Bn
         0LBt+UWt56dXIE619kttI0cHx86GWiNtWecK6brt9Apw0NGTNDu05j6DmID22qgC89SE
         wn7A==
X-Gm-Message-State: AOJu0YxOp5g8JqliYbXSGcOtTkQ5ehrnv0cLb+kMGDa4Z7Ijj6/baZl6
	iEycRj72HFZYlfG5FpvEitTLrD7yufeHv3yRBjppdeHH88P7V7mAXqAisZ8zvVH0w9Hmz1AKH8o
	Wlp52dj3/b3QJD7D6cztbBkKDq2NuCNF7uEyNOg6jVnohPwZYBvJaY0erbCcU30t4eNSHDDaT57
	rxsqm9B/qEepc5TVH4FkfADrWLSQY=
X-Google-Smtp-Source: AGHT+IG0W2b3EWg8o/BA0eleK8hdXIFTxfZ3GthHXddeE4vzszCppfq6PKjmttWrOGa0p09qt8Hqq5eeDQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:160f:b0:dcc:79ab:e522 with SMTP id
 bw15-20020a056902160f00b00dcc79abe522mr63766ybb.11.1711561013330; Wed, 27 Mar
 2024 10:36:53 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:20 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-34-tabba@google.com>
Subject: [PATCH v1 33/44] KVM: arm64: Issue CMOs when tearing down guest s2 pages
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

On the guest teardown path, pKVM will zero the pages used to back
the guest data structures before returning them to the host as
they may contain secrets (e.g. in the vCPU registers). However,
the zeroing is done using a cacheable alias, and CMOs are
missing, hence giving the host a potential opportunity to read
the original content of the guest structs from memory.

Fix this by issuing CMOs after zeroing the pages.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 7b5d245a371e..fb4801865db1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -429,6 +429,7 @@ static void *map_donated_memory(unsigned long host_va, size_t size)
 
 static void __unmap_donated_memory(void *va, size_t size)
 {
+	kvm_flush_dcache_to_poc(va, size);
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
-- 
2.44.0.478.gd926399ef9-goog

