Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFDB2C237F
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135736; cv=none; b=LtTeu2XSO+HjypHAjKOY6uB7t0vAXRWPEecckonPyX14evX8cF9XdpokJqAODhljLHX+2GLmZSbNzqJOpO48CRqz3xDktB+zOq9SV7nokJtVgCgIwjmFjMO1DtjHtOhZRjWDW+DEwkAKmE83JYNXHilEo2GZdRFkVKL97d49iJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135736; c=relaxed/simple;
	bh=2ZolxtbeL/TfZv1wuBul5eMq3hwecEq8h3mFaMWxBTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=noNsK8YQhygkwcTHwOsJRxyMS18dPhPiz5azx92cEYyh3CkSfdkjKNQjrPmBbn+o117nfLtIS0RK6E2Yxd+Bvdss8mHaQfsdvi/hVftX26mO19PAkZepWhNhSQrmBRRXb6rNAYPntJ1C3lBeaTV2NFwBwcadQi47cRNEgIqqbi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hM7P8Bn7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hM7P8Bn7"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso21900581a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135733; x=1767740533; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aempC3xup8zdxs82u0niExWKRbrEWWiY7rS3u4Pr19E=;
        b=hM7P8Bn7m9FhoNEly49FRwNXKsLxPvDngLisSpUOo7L0Ya67kuH4W/+CODl0vT2qBX
         NyCgziUr+eQtw170RNwO1VW8ogk7sAayQ0e+xbVpPcq9/NMdvtxinegEHnPwBJC4Z4ll
         u7naL5/9aqaB+B1vem+4EPtrNySlc2H+4I6YTd8QfrdgeMHBKfirF/79lM1yJn3+E9/b
         xRXsfuOK5sdqmZgUASnixXTjxcB1/WEzGC6CXJkaUoEOXwpYWkrwft+MnBd9JEptsiFl
         mMY/rb91jUqB0Yd/9LmJZpJgXcOPTbLDzxK7adSG6UOo9gSqlPu92tJ//ViePo4wXNtZ
         BKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135733; x=1767740533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aempC3xup8zdxs82u0niExWKRbrEWWiY7rS3u4Pr19E=;
        b=AJnFxOMP64Io7FtVwkSSxEKhEQTN5CNqAaZnjAhyPEARVkcDReAcSRai2Sh8Y+1Zm0
         axaICEO5TU1xRecG7ud7tnVcmf5KkDHfXe/01gxipFVGCMgxs5jKRuGTXrZBAAdqxZwQ
         +xouCdSa/085uci70JRhjVavXGNS/EESMEho3OUiIONcv5ADXMsB9oHH0X+BpsHTqq9o
         2cwHEP+cM9FoCkVcOWlNaeELU1nvVOEMCpNI/XrUTk/90S8zLZL8x29Zos8DWRUZ8efy
         pK7AhXYgzbuVEGUxskGm7FIm06aa8JvR8KwG/5JMF/o9MMuAHiN1Gm/P239XLlo6g1jG
         ljhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzM+nyiUzWCZPQUj8AnltIdiQPnY8nRv3WRaQZPquY6r88OKTBV8qWsI8/OAKA7LGULKLfzvI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/iUK1UMsDIOGW4K8cM7nqVKDF5j821V10ef9HgwQK3ikAyv8l
	JJzHZgMOSE3gMLF0ahmfDxeDER7qRrG6fq0ZTh5IruO2TTdKBVN8SuE4KZm3ps4yRnwmA6gVa7w
	30DHCDw==
X-Google-Smtp-Source: AGHT+IF1//ZF8YQZFDW338R6CLvvv/Jhm6bfFusPZNwPuigVsAoIaoiYhFuoR4zT4Z2vqbXSCzOrQaND/Kk=
X-Received: from pjbpm1.prod.google.com ([2002:a17:90b:3c41:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52:b0:34c:94f0:fc09
 with SMTP id 98e67ed59e1d1-34e92139d60mr28142377a91.10.1767135733534; Tue, 30
 Dec 2025 15:02:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:41 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-13-seanjc@google.com>
Subject: [PATCH v4 12/21] KVM: selftests: Add a stage-2 MMU instance to kvm_vm
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a stage-2 MMU instance so that architectures that support nested
virtualization (more specifically, nested stage-2 page tables) can create
and track stage-2 page tables for running L2 guests.  Plumb the structure
into common code to avoid cyclical dependencies, and to provide some line
of sight to having common APIs for creating stage-2 mappings.

As a bonus, putting the member in common code justifies using stage2_mmu
instead of tdp_mmu for x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c1497515fa6a..371d55e0366e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -116,7 +116,12 @@ struct kvm_vm {
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
 
+	/*
+	 * "mmu" is the guest's stage-1, with a short name because the vast
+	 * majority of tests only care about the stage-1 MMU.
+	 */
 	struct kvm_mmu mmu;
+	struct kvm_mmu stage2_mmu;
 
 	struct kvm_vm_arch arch;
 
-- 
2.52.0.351.gbe84eed79e-goog

