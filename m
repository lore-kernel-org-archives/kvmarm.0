Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C83E4C99
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360478; cv=none; b=S0RptOD8KxJFBW/Z1Ma0H+mJuHQvzlBCndGTaGsB6gbcOD5Tc9AAtnEPYUE//A+akwahhstYB+1cU7IsDK1w5I0ckfZewylOJBy+lwpdI5jomnn+WYrExfndmCQPSYGxG+EXlYFf/WGgSHKr96x89vuiP2LITJszCGFkorZQbUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360478; c=relaxed/simple;
	bh=Cvvr4XCxRsGWTi5hfByvAZCy7EGbJ2j6jI5nIp/JarE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YrepuOiDYl+Gtjm9PfRHkug09v5GGzU4fdrOgElKl3kro8CNPDpR57OqlyKE7vkE9cjKG+yFueWWObYUuNmEY96kIwOvr+0RHas+h5tCZkSTGF5+7diayoHt4Ad9PklFXnIwRGMlFMlhKUr+ewx0OogXBrAb+6EOnIQXRLkPv5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pK9WtYDc; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pK9WtYDc"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69a1ab55774so2629322a12.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360475; x=1783965275; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TQiMVMx4zM7AUICQBs4M4uVBI5SQsJSaNu2y2QlLlKE=;
        b=pK9WtYDchanB6thIMVzd05qCmwEyYU54i1lC586cYSEYrMkznb/YLOOEeQCMXVs0sv
         6rVzZp4gDgWyh8Gv17rqcDKysfyxYeGXNr3F6wE15nHcsuCfIcHQqlJFrhxP4+0kTJrv
         ADzMiuV2GABSWTNNW+Vq199fFOmYb5v/OGx/2Oi9EWS3Wdhnbn0i5de8mNGgTPFC3EpR
         h6XoxKx42id+5zrpQr+kgBY9iEp9PleuZH5r4GO1/5gxE6YS/Rp8HwbMC+5KlRIf4Giw
         7R/ypf1pCe91C1XQ2gTdIk9JIJ+4PoEeX10Xse/U2alfOHPvLW3N1Y2kuljuwvpv0SAx
         P/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360475; x=1783965275;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQiMVMx4zM7AUICQBs4M4uVBI5SQsJSaNu2y2QlLlKE=;
        b=h+SOB87t6BuSWZTHRSYf8uLaKC4ziqXt6lP0MO8wqCzXYk8y25xLUScdC707va2uZ9
         xekVKjTPcQ2iK2UWvWv0jAGko07HIwt0gsTzby5ZXotPfzMwROyBVD1DUYbhvLOWlqos
         SgxJWtPmkeOuNZDSFlNRkV1IDlAvO7iZVFLDyzxX1NZYOdgM+bGZyYs2RN7JDrx/9VC1
         c9Weh6Pw4a7St7KVBBLhneDCp26aaUmj/QOzwuaoBCoaUYKtR/rTzKDR/wV9IYWdSo25
         M6MEeSfLPoS8bgXpe6o6Up+pq2BX18zlFFcD8+TywrOmtAnVtr4ws2onP+A3iE1snL+z
         i+Sw==
X-Forwarded-Encrypted: i=1; AHgh+RpMPc2HcbwFxy/HnJae2lA5mLBSypkcfti77kojVZMQf146gWXFu55dbwjOCjzT3AREbGHT22s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhwnWVkn6CCkt9v4CKvipWLiuOoS95SXUJhaeQ83G5K6ARINLJ
	MXQKqa1NjKFHe+yQVtRwjIWBigFYZ7vEAkxJSAkybRE8gDDfGcsGE98wQ363hOuSC8dkumrLrLU
	xaPiHQahExplHgBaot2oNpQ==
X-Received: from edrl12.prod.google.com ([2002:aa7:c3cc:0:b0:698:c100:5437])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:516f:b0:69a:6f1:d2f5 with SMTP id 4fb4d7f45d1cf-69a85c49758mr744077a12.40.1783360474512;
 Mon, 06 Jul 2026 10:54:34 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:08 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-12-vdonnefort@google.com>
Subject: [PATCH v2 11/18] KVM: arm64: Add a shrinker for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem.

This allows the host to automatically recover unused memory fom the
hypervisor's heap allocator when the host is under memory pressure.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..3dc2b9d2c322 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -122,6 +122,8 @@ static bool vgic_present, kvm_arm_initialised;
 
 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 
+static struct shrinker *pkvm_shrinker;
+
 bool is_kvm_arm_initialised(void)
 {
 	return kvm_arm_initialised;
@@ -2526,8 +2528,8 @@ static void __init teardown_hyp_mode(void)
 		}
 
 		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
-
 	}
+	shrinker_free(pkvm_shrinker);
 }
 
 static int __init do_pkvm_init(u32 hyp_va_bits)
@@ -2713,6 +2715,18 @@ static void pkvm_hyp_init_ptrauth(void)
 	}
 }
 
+static unsigned long
+pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
+}
+
+static unsigned long
+pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
+}
+
 /* Inits Hyp-mode on all online CPUs */
 static int __init init_hyp_mode(void)
 {
@@ -2883,6 +2897,16 @@ static int __init init_hyp_mode(void)
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
 		}
+
+		pkvm_shrinker = shrinker_alloc(0, "pkvm");
+		if (pkvm_shrinker) {
+			pkvm_shrinker->count_objects = pkvm_shrinker_count;
+			pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
+			shrinker_register(pkvm_shrinker);
+		} else {
+			kvm_err("Failed to register shrinker for pKVM\n");
+		}
+
 	}
 
 	return 0;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

