Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDFE3546C7
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773294; cv=none; b=lEFYUI4dt0ckxKWNeNTsDWO0j9fJbElnaXXNhwtLB9CVeN0xdG5e47C0R0rBhbGtjrfTaaltzqzSRUnGjGz4Xmnty0SveIL2PWfTLNGONQstuqv3THIxy8+5Sl1VU3oI15cWfTRM0HiHNzoyKO2RJaR8Mk8a1QnNCP60ZCA5kuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773294; c=relaxed/simple;
	bh=kPbNiuUzKQMjXCofUmeNgcpZ8erTJTd6Icx4iGmHjGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sIIMyP73quscS+3VX9VYqt4OtZ+7Yz4mb3kzhGE6IMXT3uqgQ1fjkQSnkNzsBcJLHyMhFyqEOloQdnmQf02s4MEKIt4WcQyQnpDmExXnKyn2Gd6tvSITpuaZnro0s6Dy76fc2hFk7iLsC65fjXvjjz6wBoX1LYsTR/W8B2WVDbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e838wlN9; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e838wlN9"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-460129ef947so527179f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781773291; x=1782378091; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6i1EBve8VgH9NFCJHV43H1GJ8AEaTDJcQZdwOxP7rs=;
        b=e838wlN9CkW/ZAUkwWeFW8da2XeYH3SDh9j9W+d81AGL+8Cp81shQJ1EMRCbsg3S8B
         UVSZoKha3s7RrYn+ghtNsE7DXZSaWerdvXp1+IgJBsmzuFzhRaQnFk/+EkEzLW+8ogjq
         HhcZ4LGx1Ltx2nYhoCxQ05UfaAdrkG1oZs7g7evrrk71GxaXOe2gbO12QRs4JBNIM24O
         vNNEvEYovMgiPVDntH2+vXrmUQkZ7add1lFqv1Bc5cqZ9au576MLW2YW8HSLXaV5PALL
         b6vLVnnTkX/HHF4Vq+EndOKbLgV4qKg2YkMdRb1W319u4NViQ5xsiWsTqw5HFbg/z8yQ
         4QJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781773291; x=1782378091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6i1EBve8VgH9NFCJHV43H1GJ8AEaTDJcQZdwOxP7rs=;
        b=Grh0GuIVG8PMsjWd62TAUOQ3NVUhFaSoe1/o3XOsrL+GN1/gDhknFFfnymy4RK2ZWi
         1krZYbYg/CTHiMZTNXWibtt9DJK4rqv5NryeYmAUz5VTgn3MxDG5S+lVIJ9bkNxtwP7m
         XsO7/Q7/6LCFf1ZDZUcwklFQM6Gy0H6GQuoVgo0Mfyb0x41jhNsGgEtModryRxLJ5woo
         nMJt2s7SrmxHdTjj9+DjsunHtpB9I/KNRS0ohQHFHd6BV56yhMdVn/epviaiMMZdNRkD
         svXxBbY+I1WFkmh6cKuNQQYxvv6+gOrzudC9gOm2fapKZlvP5GOu66DTNTdLKPPUUdpM
         0Fsg==
X-Forwarded-Encrypted: i=1; AFNElJ/JSpEDh93OL5R4qH8XGbcDROFyWgw3PQdFb8WAGj5C25Gnzddj2Tzdm1VtMkt0Y94Sq39GM7g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfV6oM7lV9jfH/rE/mLAXd2oNZLcZTEIRflvHS9iTfeXRqlbOZ
	P+JJq5G6QnXu4AJ7tWd8toALL9gRBibHop4+cw3E7cZx2AWAsrxyl4tSvrxKG2KyXQt9bUVwD6v
	gJw==
X-Received: from wrsg17.prod.google.com ([2002:a5d:46d1:0:b0:45e:f3ae:e713])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:f488:0:b0:45e:ea65:d329
 with SMTP id ffacd0b85a97d-4623627634dmr9439000f8f.7.1781773291246; Thu, 18
 Jun 2026 02:01:31 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:01:26 +0100
In-Reply-To: <20260618090128.3913688-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618090128.3913688-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618090128.3913688-2-tabba@google.com>
Subject: [PATCH 1/3] KVM: arm64: Drop the unused EL2-side is_created write
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Keir Fraser <keirf@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

init_pkvm_hyp_vm() sets is_created on the EL2-private VM struct, but the
hypervisor never reads it: pkvm_hyp_vm_is_created() and every other
consumer operate on the host's struct kvm, a distinct allocation from
the EL2-private copy. The field is write-only at EL2.

Remove the store; host-side is_created tracking is unaffected.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index eb1c10120f9f..30dd4b2afc26 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -433,7 +433,6 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
-	hyp_vm->kvm.arch.pkvm.is_created = true;
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 
-- 
2.54.0.1189.g8c84645362-goog

