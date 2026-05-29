Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA892369D77
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057085; cv=none; b=Nr7rSiW8r7Y9wVvbzpFzsKnkpaCb9NQPHiX5FYLRMet+2hJBdbOWiE8sQTckAEzPsQgjvnGjsVIMdsav2uG88cnJ/FDEswtFK3NM58jIyM6/gJaTOAEx3NWNd2s5kNfSEWpGRVhUWGkwiM/AND5yNGSGMz+ybOyWzXBuamOjc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057085; c=relaxed/simple;
	bh=XKVmY0P3IzoFeX03y+LKtJHuMV/YCFLbyf+QtduVf8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SfZxMqMxf6MNTRiV5p9/fPFHIyXP74jIImA9MGyG9d23sohow3nJcoHOF7MlDB2gzhU80YCuN/qzCwyJsTf0N9Mx4lxD0alS0LYjNbPW4piV23AsfEQzxECcXew+IEaWwDFeeX9WFwSiKMRQwGrl9Q20OtsdNLemn9JeamSNutc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxBH3rNw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxBH3rNw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4909c0f0ba2so5351885e9.3
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 05:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780057080; x=1780661880; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7DIYy/NA1CowFMUedyn+8E7FgwfAdykU+tJsf37FuI=;
        b=bxBH3rNwaaH7GucsadM8vko+4snmFF8WMbfoyB2p/o/q8cKq71FOwqFo1uXp0Y8U29
         YY49cuTM1H/VTVgeZbXGcm+u+A5Nan8Eu0tf7f5DkyX6zU4sy2p/h0toRmA/Si5sCRTc
         +FNF3BgmGf1fZ7SrPvtSkzqbZHm14z/wPDgPRoEuLTlWPJgpbRLK/akqv//241yo85ak
         IOJnyIWONEmRJ249eoETgIN72BMAeflmtMATlhX4v2ZG9IvtJFRinWlg3+G27SyOawxh
         mBFdSZIIhjc+Lgu5a7a9hMpAxYGuNoZQmlEqKmVSlWDZCZVL8ZUW3GNwaD1utbI13+qO
         Ar/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780057080; x=1780661880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7DIYy/NA1CowFMUedyn+8E7FgwfAdykU+tJsf37FuI=;
        b=HCYdRRqvnLmOKB9k3QLmeD/jSWHhLdWV6oVUGtyjXAvwTJEqufWDi0/zQKYBMhl0Sy
         O0VLk0StcMfQRlxgcog9N0/odEy7AuXYVUiN0xk0bPyW2NTi8todG6QBN+AbtrklQmSe
         rYTfKncBJWqbG6EuT7gfDTT2HOurkmeQmcpH9v22cXx9jvbDY9cT/eNPc3uRV1hTpgKs
         mTGhVteiL+CSxPizs4ZGnwfOvRrCU0bPY6Oz/lwBZcHXHk8KxQpCPBjUqKeBVxRhnvn+
         VGa34C28brChljutbfIywRfQhopqpRrC+fd2SWYYt76qm73mr4xXFVRuPfENCX33SVFx
         1Xhg==
X-Forwarded-Encrypted: i=1; AFNElJ97nNLR5Y8aRmjCSWsST1FxRJfZpH0NuwLJ+mLYri0dcYFW5FohZoFL4RwEHguJu4DX+Oj8Zm4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxedUdtgmmMmE/J5Rr7CYqiqjlRy158MREYERm5oKZ6+Gf9OaLx
	89Uf5I41ZvqhEtYmv75Rqzd8mJSTak/YFXy1F+FAkCmVhOEqMj61rNlpo5f3z2JdfQYpSMnvUn7
	xFw==
X-Received: from wmjt12.prod.google.com ([2002:a7b:c3cc:0:b0:490:3974:b74f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d09:b0:490:a1a6:6f24
 with SMTP id 5b1f17b1804b1-490a1a67021mr16515805e9.15.1780057079441; Fri, 29
 May 2026 05:17:59 -0700 (PDT)
Date: Fri, 29 May 2026 13:17:54 +0100
In-Reply-To: <20260529121755.2923500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260529121755.2923500-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529121755.2923500-3-tabba@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Avoid host/hyp share desync on unshare
 hypercall failure
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

unshare_pfn_hyp() erases the tracking node from hyp_shared_pfns
and frees it before invoking __pkvm_host_unshare_hyp. If the
hypercall fails (e.g. EL2 refcount still held, or page-state
mismatch), the host loses its record while EL2 still holds the
share, breaking later share/unshare attempts on the same pfn.

Invoke the hypercall first; erase and free only on success.

Document at the kvm_unshare_hyp() call site that the WARN_ON() is
left non-fatal: a failed unshare leaks the page (it stays shared
with the hypervisor) but breaks no isolation guarantee.

Fixes: 52b28657ebd7 ("KVM: arm64: pkvm: Unshare guest structs during teardown")
Reported-by: Sashiko (local):gemini-3.1-pro
Suggested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4a928fb003ff..e08503e89fc4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -524,13 +524,17 @@ static int unshare_pfn_hyp(u64 pfn)
 		goto unlock;
 	}
 
-	this->count--;
-	if (this->count)
+	if (this->count > 1) {
+		this->count--;
+		goto unlock;
+	}
+
+	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
+	if (ret)
 		goto unlock;
 
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
@@ -581,6 +585,11 @@ void kvm_unshare_hyp(void *from, void *to)
 	end = PAGE_ALIGN(__pa(to));
 	for (cur = start; cur < end; cur += PAGE_SIZE) {
 		pfn = __phys_to_pfn(cur);
+		/*
+		 * A failed unshare leaks the page: it stays shared with the
+		 * hypervisor and is no longer reusable for pKVM. No isolation
+		 * guarantee is broken, and this is not expected in practice.
+		 */
 		WARN_ON(unshare_pfn_hyp(pfn));
 	}
 }
-- 
2.54.0.929.g9b7fa37559-goog

