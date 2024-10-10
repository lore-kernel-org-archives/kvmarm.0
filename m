Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C1220898F
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584818; cv=none; b=iSTV/7w64nf5WKiga31XvM9G3ZZuFtap2WghtXkxKusdQoiIHyOYzoRGLT7VGg1XW9zVZBz4e3nkR2tEgewc+tIGHBaFFtUXeMVueOeDPWLEsLiFTvy4Ej7TwyK/zFfIoM68pJX82kEPz4YsFCabOJ2wsVLppgsb45sBxOC2RpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584818; c=relaxed/simple;
	bh=XU8sCtvYc/Uw+Iuw1o18evVVUc/CvxyvropaE1RipJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LZIEbUQ1KYh4r0a11nHpZHWrjGkgZsIdVBxSb36/E9mJnx9XKpPuOo1OnPA/yf77lVdTDKLqy4t0toXPhBiQG1nG//H/8eRpSjZGUvIGS/apSsZe/HI1VJBshhomeM2FbiVjegFSKqJCGlB2sktct9pACBXwEv2RTAkGk4ZJt50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oQg1bC6J; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oQg1bC6J"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e28edea9af6so1639185276.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584816; x=1729189616; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h7pIaRprT8i6iodquNsVL5vPZSNT9KsZLdIQsfz/EL8=;
        b=oQg1bC6JNVaW3VQcZ1fENf9eR58+8KMpwZHRC+o8ePJ+NmDA4Av7WUH9PMUODmpA3U
         wKM9rz7tGhGD7T9UoQOHGQvoz7Scqg5yfCAhAPRamR4n/bMuYx1C/SG5ukGMFB97cMl8
         sk6jCUTtShbpe3gUExt7zgdHOckaESAlit8xHXIhdLlU6ivFZstYLSVbM0vVFIxrVA+3
         dNNJabiT5Ta4AA7/U9nZF9cSz1l11ELEg9qTwldy1UfUjDN7pDDxuPK8kxUDZ0RMlEc7
         zeOSoDXHgqJmYceNHmqBNXRqRaL8WO0zwVM17+wNQJtu0Ht4T84WjH6KnkOHvOtfjts2
         2PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584816; x=1729189616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h7pIaRprT8i6iodquNsVL5vPZSNT9KsZLdIQsfz/EL8=;
        b=uX4Wq8ONf+PyIms7U6jVgydYRig7Wg02ApOOz9M/WLoY9CSoTN5MovS+5KVDsveF54
         efNrf7os1rkSGLuPqcVczbtjmabzUHCXKlCa2afmVMECI67yRY1hOjDSEv5HILNLz2Xa
         IyPwuW127Q/ENIiI2nGWO7BeYK8utjtlyM6kS4yDAVX7loukUfIcnJcVI6UooTVmfBJ+
         O1IvMvZysaGTEJQovsnrWyBmS3ZIWWTEtd5nH2ZCiffDt+P+eVv5E0QUf+MWSFCCvV6Y
         Wh1GD2hSk9/FgtWtL+H14vDjV3mvYtmDnKlG5nXH1NiZoiZEifTHLsBW07juIctiNmcO
         /Qog==
X-Forwarded-Encrypted: i=1; AJvYcCXOEnudb9zeZAMiMUSfiPEdi4N59WC1EL9tVkKoK2luvfbtVAIb0b25Z9qoLr7F59ac8NOL25g=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrNGZjbfBf4PeT2lqBobjV7dC5BhmB9nC7rZRfUeKsSwUabJLm
	K9EzEBeCe3LQwbKsOIgwZowrYjO7KFSoIqsfZEgz6husrZxm9WqBDJ2tNl4rZPFHQfvuaK+RQFG
	ZPw==
X-Google-Smtp-Source: AGHT+IER2ThMFqRrPlrH2YqE2Mm6yZZ3YtFM0VnOojG5BgkcM2HHrRnMjpl0ZvMfhTqewlD6nF2BR0rNKwA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:c45:0:b0:e0b:f69b:da30 with SMTP id
 3f1490d57ef6-e28fe41d0e6mr89144276.9.1728584816073; Thu, 10 Oct 2024 11:26:56
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:00 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-59-seanjc@google.com>
Subject: [PATCH v13 58/85] KVM: RISC-V: Mark "struct page" pfns accessed
 before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that RISC-V can convert to kvm_release_faultin_page() without tripping
its lockdep assertion on mmu_lock being held.  Marking pages accessed
outside of mmu_lock is ok (not great, but safe), but marking pages _dirty_
outside of mmu_lock can make filesystems unhappy (see the link below).
Do both under mmu_lock to minimize the chances of doing the wrong thing in
the future.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 06aa5a0d056d..2e9aee518142 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -682,11 +682,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 out_unlock:
 	if ((!ret || ret == -EEXIST) && writable)
-		kvm_set_pfn_dirty(hfn);
+		kvm_release_pfn_dirty(hfn);
+	else
+		kvm_release_pfn_clean(hfn);
 
 	spin_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(hfn);
-	kvm_release_pfn_clean(hfn);
 	return ret;
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog

