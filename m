Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D1410A1C
	for <kvmarm@lists.linux.dev>; Wed, 18 Sep 2024 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726679123; cv=none; b=CH5hvHonz/PKzMuJ8kPCdYrZeX/aiHABrgSQWGJzi7AL7trbNEY64f49HRPaKjCeJ4bTcC5V8tXIDW3dNWJy85w0we3bwQDS+tiqeRRw9Up9GkIucEeuA92YV9CY7NB6C8PGKdCKjkJRwrjs2SfUDNR+FPnnUuGHNILUP7UeYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726679123; c=relaxed/simple;
	bh=C6Sdin4L4P8Uc223o2WpV/b0UsB7Giv3pLkwQ+LPdJQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KzwbQn58nuZvRaWKim77cWRxAQ+pd5M4J5U5QN6io+i8NzWf9icfflPgW5xj8pzvucECo+RkK0SV7/M2jBlnxlcGrlZmO41ySkvLP88k4Agu1h6BSN1c66NUv0eVjeeiCCkkksF6Zfjr9wr2xjlOQzDFoiu/HTmh7iFLn0Ue17o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RBws4eJi; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RBws4eJi"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ddd7800734so57097207b3.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Sep 2024 10:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726679121; x=1727283921; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W0m5lhjqNfvnG9TQVTKzkJ/jW36WtD3+uHO46+Dw1pI=;
        b=RBws4eJiFfbaw+mJgzVqddnH5XIyB5s4/9ffgWevlTNv/J+MRoxqgDw3jDuT+Q8Wcb
         v5Xv4/8K4RFfk9Mqs+Ssi4Q9foP6YtSiaqculq5LQwiVDTThb8yDVDBX3LSbi7ZUStaa
         fM0JiLpTBiU3pGNVgqG9fFdbNzp59jc0S92WlIclSfiaWnJ1QBxPgrv5tdy5+78goyVh
         Y5aB9Qv6E0XYdqCmdr6rQQ8cesHlz9j0c+hGOweO+xbJ0ZtitXikIKJUCaJdzoIhasht
         J3tL0enXgvB3WN0/Kms89/3K0SXeUft2Ar6gxt5un5ehLXDrxGu5nUaF+cqkZvU/JUKD
         CLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726679121; x=1727283921;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W0m5lhjqNfvnG9TQVTKzkJ/jW36WtD3+uHO46+Dw1pI=;
        b=QB3MaRnzyIcl+vvq6fawJBqbb7t00kFeEOqkgJ6KFD9mFCu5GnClMNvRd1IlMTviBG
         EPYaj+dEZA8x6wmOmhJvqGIGYDyQZLnhpY6n2YXn/oo8KrcEwwRlywXN0g27mCVllTo2
         Az7gwYGrPxCP+UOJdogaHkmM565rQGE8vDPhMHJK5yej7yNByfGu9qgTpgc3JBLFfO2a
         84qbGDrAwsB3UWibBobyP4iWl6wTWj74PrGft82oIlz8o2Vy7H2jhcvtA7ItojZB+ej2
         Cvhbwth4rW9PS/d/YzcvR7E87YeLShIWrmFwnM/LKrBgkqm8XR6nUAn4H8IQ6FrPyx0h
         pjPg==
X-Forwarded-Encrypted: i=1; AJvYcCXU9lWtipHtPHIfuDfsNHs6H9nXVKQ6hyV8FWX5f9IX3sKvH9W1I501p3FPsQAylRPRU+WVLEs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHYCGnZPBy/1pVXp7TWBDbehm4nm2trzk3BYatK503t597twb9
	0W5Aup0Iij5pozhlFVnUvu7H0ASZbhpvNv+t/snB/1A3vEYhtlzv4JnYnvNL3rpo7Ny0s7lNPwq
	G4fjkvKzpYaUzAd/qKg==
X-Google-Smtp-Source: AGHT+IEC2GIWL/IMW1+MJjGNTmLl5DZPq+aRo/g3k+8N2morVQNRZoj3JOGgZgDYgRbMTH2FbauBcbxx/BFZ5Rpk
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:690c:d88:b0:68e:8de6:618b with SMTP
 id 00721157ae682-6dbcc21ebc2mr7976957b3.2.1726679121112; Wed, 18 Sep 2024
 10:05:21 -0700 (PDT)
Date: Wed, 18 Sep 2024 18:05:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240918170502.1881517-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: tabba@google.com, kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On an error, hyp_vcpu will be accessed while this memory has already
been relinquished to the host and unmapped from the hypervisor. Move
the CPTR assignment to prevent that access.

Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 187a5f4d56c0..7e7dd5fc66e3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -571,14 +571,15 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 
 	hyp_vm->vcpus[idx] = hyp_vcpu;
 	hyp_vm->nr_vcpus++;
+
+	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
+
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
 	if (ret)
 		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
 
-	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
-
 	return ret;
 }
 

base-commit: 98f7e32f20d28ec452afb208f9cffc08448a2652
-- 
2.46.0.662.g92d0881bb0-goog

