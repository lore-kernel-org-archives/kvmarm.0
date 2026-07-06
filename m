Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B763F88AA
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360480; cv=none; b=KX6wWag0z5WwzyL0pc39wsRKsqDZ0iLnkgfXW/+LDMzvW0AbaP12jTl9lBywuOWxfsSGRTe/bTRBB6WGX8c01xJBbGa0VN+Bh70U8cXkt9CAP0G19KQulsNAYYizdbK6jwgfHMN/TqRpJ+C2zlusziut5/EunvzQyK0A/eG6rDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360480; c=relaxed/simple;
	bh=j6Q5bG9ZhRH/Q0VWXegrBoBNRzf3HVhkLsu6QP/xkvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xqvmqv4MM2S4IdLKdOtDQAcDuegTx7bJyZsXtmgRA/hpmIvauzDtkE7rVZaCCzWsksohL1ptfhhWk0FWoyBah4vSUH3sSAko6g5nMljLzoIfYyO00T17WFo2UFbsUPx8/u3Cpb+MX6NNAH/Cft1i0Q+q/VfR3FiBSq0vF/MyGkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=myMmFZOa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="myMmFZOa"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493d88406cdso12770775e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360478; x=1783965278; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=trWQgM2b/pmHXMfLQPuDpI6xP9R+E9nF5QwkDxcB2UU=;
        b=myMmFZOaEj91T6UhxjPSn5c6F1H1+/stC/AZsn6KAvXA8eHH54s73/diyhV76yQXnM
         uAoipg6+W18gnSJGuXE4ta0fMDZjEG1cNzOCmgHNhRD9ZSImYGYGUV0tFS3fIPDu+Dg5
         EEyLN2KixIh/SU1D4Ga/o3YbwEUVhbsgIKXshDmRrbpPWv5HN6Hrnzd6Nmv0mxpZsGfF
         pmD2sjsLTEr7e9mEKDqPYIj5it5/QJ0MKOiVqNvyhox1rcvviXtfw4YkVW/96OqAXdzt
         9fx+XutUDbD57lHqP9bANF8BLOCtZMhsMIa5mgthtaDew+Z/D0mCxGtuhH8/hGtyq80g
         2EFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360478; x=1783965278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=trWQgM2b/pmHXMfLQPuDpI6xP9R+E9nF5QwkDxcB2UU=;
        b=YW652kZ3eELJpcALBX6s6D5DBCKecrgc7wJzkecqzru2VXBSkfAS9IrhpxMnRWaQR8
         WIz4NhNLgrz5UuODnuvM6O4C5v7/h9cV8b0OF6RRcV5uyPRJzqRWPkx6XVb2BWj9IwDB
         ggkCw/k/z/kQ8aMuGnPjJkgQYTidNXla9/i1LRuiczHmIHz/ZVSusiF29xva17FY82xx
         lI+IcoerYMyDDHxSjIKbx+qdncgFrC1UMDJ0hyvXtR1G6QuP2XePYPqYGQgGvljoRjJ+
         2oNi65EVwCFMzn9RrUPZi49mZ/1b9O0nQB3CNBf9ypIjUs/d+lGp/Yj0SdW9V1BOpBU2
         keBw==
X-Forwarded-Encrypted: i=1; AHgh+RoScywe/vpD3GFjiaX3mkW1zHTpRnYQACRz2vlUiVoVEDIH5aO3lMWGoRwcK0fyLwbPcgcGvxs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoyjCINopW6fDOKdzQigKwotyMkUDvJpk4yLCVP3H+ZcbrBsR6
	qq8X37hI/2iK5ufvwgKDIBfzw9L7ij8OL8v23P5qJh43fyr7xow2KyCrQcv4BG7P97wy5HBPsrf
	K8zbpEk6kxtiB2wfiHNdWXA==
X-Received: from wmge10.prod.google.com ([2002:a05:600c:13ca:b0:492:49e7:fff3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:c4d5:0:b0:493:c633:9cf1 with SMTP id 5b1f17b1804b1-493df062c26mr13727105e9.3.1783360477456;
 Mon, 06 Jul 2026 10:54:37 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:11 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-15-vdonnefort@google.com>
Subject: [PATCH v2 14/18] KVM: arm64: Use noclear for PGD in __pkvm_init_vm
 error path
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
index d9ab58226889..0c82f1ddb93d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -861,7 +861,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	kvm_guest_destroy_stage2(hyp_vm);
 err_remove_mappings:
 	unmap_donated_memory(hyp_vm, vm_size);
-	unmap_donated_memory(pgd, pgd_size);
+	unmap_donated_memory_noclear(pgd, pgd_size);
 err_unpin_kvm:
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return ret;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

