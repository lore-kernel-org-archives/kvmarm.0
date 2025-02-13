Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918772661B4
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469927; cv=none; b=kI+aBB+Ia6z4Idyx+yVfVYSEiNRTuFyJ3COMwLuiNezZ198O8CftAEMsWbpZsHhjFRVH+9VhBf9ZDIebcAsO12uZCQE0Rd3o6ayJKHik4/kdiLhybyM+gbEHJ5rObUyWGnJbppYLHgt/bDnd5MR9pNkfIViWMfaGmN0mFdS+ywE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469927; c=relaxed/simple;
	bh=hbnkoWg3lv/YYFKHJvhomB8fITcWyPweyE8n5wrds+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=enXopxFldMyThoKA/B87HvG6fSCVbhBOVY+lD/vHgvgEVbit1KHgbRgeWY3I27nQaWiO5W/EKZ0P7U4eBXB+0azXtceB06WesdgqFPX4pJ44HsSVjeNbzpD6GLyl/Y9jZvyMg/MpCh9M5uBsiEep3EVyukpsGqK4htd/BY1dsX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSSmgVRF; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSSmgVRF"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ce3bbb2b9dso7641435ab.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469923; x=1740074723; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWZgB5w3eSM0BtzO18X6A2qHryHBneRbetiSxyPOf/w=;
        b=cSSmgVRFT6BXgpwUR5pmvyBVwewYm77CB16WgDwoYqwuI5UyHJ3NFq6C8WjyOXxLZ2
         ubTZsW5ktE1WY4+T4KtyUrDGKtxKPS6mvWEdSsk7D3VTZjsNm4/3FmHKLQNGhhBHUFmN
         jDNugmHvx4kglOI/B+W6+nA0liyyxk4XtfpAHaFkzfsOUMjlI/xywgTEhxXBpqjukAnn
         b7OGX9TFmFm8xfRDEiNG1U6ZKm+xre+0qF9Rhh0WaSrzCpXV5vFgOS+6AukeecMjEDXc
         y4EBHaAUrlfcoXkHsVG8SOjG/EV03M0pxujWjFlkGPoL/Prlpy4yEnl6/VcYlcpp5R4q
         vGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469923; x=1740074723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWZgB5w3eSM0BtzO18X6A2qHryHBneRbetiSxyPOf/w=;
        b=s5ty46WUe6wGVc+0X167GAzRi3URvXVKWENjWM1rkj5kJtndbbqpvM3k+ptnAzJsRM
         Bdxk/8N2dn6cjHYKu/kdTjFGAqZi3kTwYW/Z+ikANbQzfpGjcnjSRvYyu9jssGrb8OFF
         X+yOHtWaqTlZ9DGEUraI4fAQvUzFXUL42IBXe9KujOH2K2VCHWQhWa6ujjIl6QP8JN0i
         kjeWp19dfYyRAX8Yj10sm5EaqOtAtdSuSL7veZo7DPu49uGWAD14unOyTHvLizALVc4J
         ziCUQDfScruxagcJccqV8tIGFA/YM1SE1EisZKKnHHwxo/H+J/N0UNiRtWZ+LUgZ5sYE
         SZTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGpPBZjs5evcdRqlyb8yT/0MhZGPauxuP3L64GJFliSaxMLb6FDc8qzCW2X+YU43u78OJAwH8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSwklUABUpwOfvt4Hg7WroqPzLLJdvh6pcCn/mYpoGZIILByUf
	fFKcVm0vTjYwoseAe2EuHzNTgQg+oCoqu6ViNE2uDFdzUORnujBbTlnv4HWNjAL/FJWazDAVGZc
	poB73FbToAlJiH6EXx1oSrA==
X-Google-Smtp-Source: AGHT+IGInJOaRNM/UmxApk8AjirtA1Ey5wL5ojkxOBaGdRUfXbOtlN+CuOjjpt+ni2zL9WpitRvyEXXQjjs//eksWw==
X-Received: from ilbec25.prod.google.com ([2002:a05:6e02:4719:b0:3d1:8322:8ecb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:144f:b0:3d0:47cf:869c with SMTP id e9e14a558f8ab-3d18c31c4e8mr35827555ab.19.1739469923254;
 Thu, 13 Feb 2025 10:05:23 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:17 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-9-coltonlewis@google.com>
Subject: [RFC PATCH v3 8/8] KVM: arm64: selftests: Reword selftests error
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

It's possible the host has that many counters, but HPMN restricts us
from using them.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32e..b5bc18b7528d 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -609,7 +609,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  */
 static void run_error_test(uint64_t pmcr_n)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
 	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
 	destroy_vpmu_vm();
-- 
2.48.1.601.g30ceb7b040-goog

