Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B594A19ABB3
	for <kvmarm@lists.linux.dev>; Thu, 19 Sep 2024 11:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726743916; cv=none; b=DLIPCr0ajit/qFDeqEfmWMrxgkqn2YFEBpDI4U9qonb48tJI0Wjoob8pgdiO73av/OwGN0/amAmAX//Z1cBaGe/ecZGepN9bS4X7foI3QDSN+a84ONHYG6rzz9Amwluq57Kf/krL0UC7pLa+LwZ1z2IBfRNYk4OEumU3q/7X9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726743916; c=relaxed/simple;
	bh=3tBKuMSNiEqOBNl1TqJsCFWHob3aBxFmYeKC/wWSHig=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s4vu1XQnPUcq+qCFBKe1F3+2fX64gP0b9uEgkvzfTdiSpp+qEKmM0+fJFEWhsFvTsE0sWGX6hXPfTpxiiQhOk/l1vbZB9+1YGwlHhBy58P9+XkmwUn19l/dQOA0HypvXGnRAZ+14CtLv3nxoavPGI5py76jCjSi+5myeqM/YNAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCyO/Gn9; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCyO/Gn9"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42cb89fbb8cso4604225e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Sep 2024 04:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726743913; x=1727348713; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PVSpmCgkepJu2AD0IS345I3pxIhdStTaP53o4gUqYrg=;
        b=tCyO/Gn9TZYr/sBeIEkdVa84DA/Zs2XZpCcE/j9rUDOPVFWaXxkgNSmMmoaAdO47aJ
         ec8LXPbw9sJff1WF6/AOBtrf55/U3HWiuVizJ4O453SKejRRVL0GnPogu5lOGex0/FQt
         aptWcG9F5yqJglbra7AjtTnYTm6NGDGMGDTtbkg9iSrm4hoz+taEPwJGuyfoqfdnJkev
         bjmOI1TF4gJcr4p1ycH0W23lD/3tGLRr+33aMhFeHWoMm18BdT1J9D3B4VPCX/zdmMab
         G1KADqFTaLpLqRNiyTdQePpd5wRLlkajQjg5HCQFp55AlaH9PcVHki+qTg3Ws+6o5BQw
         hdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726743913; x=1727348713;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PVSpmCgkepJu2AD0IS345I3pxIhdStTaP53o4gUqYrg=;
        b=Svqj+ObStomvo/+XEdk/hqzjOAnV0K2BR4KUvCMsi4Zz2yRpKXbQN/HhwcsWAgA/vR
         kd9GVdzk9oi8o5sC5K51YGpNJBLBTgiN6zir9LxFlwFicnC5LZ8MAF5+Q+kqEvN12uTh
         8kvLOJXA96kb6xTtcHEqCDSg1HBCyKlK7lXllNIcm3oBFENLjH8243CxjC7iz40LBhnE
         t9qjY85KZvOFE3a432iBwAWWntOKC77WVNmBqAPQCPlFO5fpjBflA7tESzfqZZbOF4nl
         5iY9xdPn6H/q0i0K0lLYyux0zaaas97fCv+OStIdmSqk8nuepAWYmwTTa8/qfEe/zGYS
         CLYw==
X-Forwarded-Encrypted: i=1; AJvYcCVyLEUroW2sWv8ySaSUhAVjtz4YCES3akrgUZXbuqU8rMkJVsjy6Rj0P/WzKGS86nnxQqXiRC0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwW0VYykNbrkP49soi2UjWQhzP8MMg1M4jWNg/TX0P2sEYOJJ0n
	9QnGEqGcOrbTct8BtpWpU0Sq+xHaifPzOPw/S+W7u7bYeQq/dhL02PYdHPqwEYcuOdYHww/wfxr
	H+9ABCZlD48uqK85gaA==
X-Google-Smtp-Source: AGHT+IGNAc/mKMsxKhvSPcBGuwnp56YULE0MbmMMckAVz610vPhrT5OEJgRTXYfrmpbvRGmuOxJ9mrpq8BHwSYAT
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:adf:f04d:0:b0:374:c44a:a71e with SMTP
 id ffacd0b85a97d-378c2cf83cbmr28244f8f.4.1726743912520; Thu, 19 Sep 2024
 04:05:12 -0700 (PDT)
Date: Thu, 19 Sep 2024 12:05:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240919110500.2345927-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: tabba@google.com, kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On an error, hyp_vcpu will be accessed while this memory has already
been relinquished to the host and unmapped from the hypervisor. Protect
the CPTR assignment with an early return.

Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

---

Changes since v1:

  - Keep CPTR set outside of the vm_table_lock.
  - Collect Reviewed-by

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 187a5f4d56c0..077d4098548d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -574,12 +574,14 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
-	if (ret)
+	if (ret) {
 		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+		return ret;
+	}
 
 	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
 
-	return ret;
+	return 0;
 }
 
 static void

base-commit: 98f7e32f20d28ec452afb208f9cffc08448a2652
-- 
2.46.0.662.g92d0881bb0-goog

