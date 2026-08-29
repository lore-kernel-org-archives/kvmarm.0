Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9F36B05C
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 05:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982628; cv=none; b=hlTW3z+nVOagqPl+Xn+Iavid4FFTRs1PdazNS0nuPM/dC3hSfLbxZt2ARdbqti3nwUNMDowo4SVrdQCe3n/udaQ0p81h9v6TimqUxdwiE5XI6fCUgkLv/+43xIGAfguBk3KWMiRf1biVgjCqrd/o/pBUhGVm0zK0kwlavhRuYyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982628; c=relaxed/simple;
	bh=aru3gpZckcqhzLmD1P2HSOiefupvneO2iUB5oqNw958=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U/uyGrkrLQo6NwDMEjetWoEwIgHSzDgfiPytGAcJVQE3zRd4ZjAPEzgI4tAt1fJqNwPEpnDRhJIEY4QcPHVfQZtvoN3zMQ3RUlJdJck8jO+QwI4P6tunIZnL7SZuHxt3kVQEEu3Lf6YmljmB3337s/OBvFux4+YFJGp4fZaTApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUcGmRYt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUcGmRYt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-495590dde14so15687505e9.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 22:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982623; x=1788587423; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBWN6j8OnBuuPy0FKZmRrD0AlW+PPdIjJrnUe6crviU=;
        b=VUcGmRYtHABloHNKwSWwBTzipCzo5y8nedLtXLQgvD36OZh5bwCPgkrR7+xoas06dm
         bLqPtqbfMXHR0wSiOaTtmiG7QejmB8DyTPj3GpY5tSOxBYWz90+CgVzFC9oEzbcB+lrp
         accH6yTSjCqxPeg9JwBlNl+7pRaL++XL6E6NzH5wSr8/lm4lwmLLbHAUJSYJau7gGk7z
         HkgFCTTJyj1/k8TvtbmwVdw6nfocBGRttnErNCHIziSkXKZmj/jP3TCqoHXGqkOaiNpe
         8H5ThLwF1/klOmetM/AMbGsQFHBc2GaIign5wThRJMPZ23GGXJa2ON8XYJ8s3K3JExr5
         xhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982623; x=1788587423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBWN6j8OnBuuPy0FKZmRrD0AlW+PPdIjJrnUe6crviU=;
        b=phh/WZUI+NWQui/L9cUpH2ZABXNv6Bt83CogzdVYqRM+cb1k/WsZC3SKOLHO3ZGWBt
         Ng/WvbcO7J19DvPlcF8KBAj9jTCG91jpfGqJ00b4knJsz5V1nkf8NV+wpj2vAw9XZ7jy
         FmR6rAZGF/WQVkhncBMLV/xINNnHQA7G4VOuHjtkNsnXNwN+iyvai3Bwi54VTXvyZkbX
         1s7mzYw6TCkdWfpUtMZx4yX9906Jvfv+mY6Wg3eQC5pYMVI0Oa0UkckPo85zd++Nj70c
         D/rxjsAyy1PBQmlOtXVConvFX+WDx2ly6vhvdlf6S5+jxJbpZdnill1Xjtqzv1KxLlM3
         UwnQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqyUqiy+hjcUmvaKJu36Ajy31LJxAAg3smeR42sIWoQ2BJBW5K2ctpxmw0srTk5nLZ73KkPRc=@lists.linux.dev
X-Gm-Message-State: AFuF++nXJ3g9xNnNexCuZ8b3+QczHsKbvyYK163C50M52UNT9F115wAC
	L/5RKe5XReWLejzd/ccXYI9Fc02+2jLW5Ii7EJY2RTfh4roDIMsNFthb
X-Gm-Gg: AR+sD12jcteyrnUOT8WoXdOFIX4CER/++C+B6+c7aY6z+hmsgXTmzJM8FukbhoSZfhq
	XyeKBFzqZ0HufuboW5m4T3F3z+Iu9tlgbU+PoYlRNPjo79puVKFKCA+ZuvLRRhQ2lvFTMvQCaRh
	cjfpOtZbXnEspCRlwJDuWxyqnClWnnCDYwL7t4cwooiMvhJvQnwxZ81qdJ/Ou3xOR2ArR/V9u+v
	r3ZnEGapmS8aPhxkyB7t77pGGi9NCMmgZ0yRGxv9xOgSI0mhlfHc1FteOKkWeOJGCMXuZdfwmMg
	0ffqzg4Ycj/8aGMCaeuaKaHuQg+osWIpGWllsp/oCWiqEdiqvsphnMlG95ti9hcuatzjMHxS7b0
	8nyM7fT6elVYkW6CdyGzLXvhi0Z5PZKHY8K1GOZYnLgGn2E9kS9S+ETP75HAiBOVILp02ehJEHJ
	YUeP6ebQ/SKUetHzzEyaVdq5jVKsYdsMand6t0cQFLpwztECGClQmwz/AwSHzVMIuNc7xRf105d
	/SODpW45DurSeTKyN151gFmwxDv17LqyZeBMHxm1wc1Kh1hqw++iL6B0zDbTp+spcLjpH4n03DR
	VtkfTU0HrqroGnnPDA9G
X-Received: by 2002:a05:600c:a47:b0:499:be9e:49c8 with SMTP id 5b1f17b1804b1-49b91c50957mr150918935e9.13.1787982622515;
        Fri, 28 Aug 2026 22:50:22 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca3e642dsm35357485e9.2.2026.08.28.22.50.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 22:50:22 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
Date: Sat, 29 Aug 2026 07:48:55 +0200
Message-Id: <20260829054856.70549-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260829054856.70549-1-kmehltretter@gmail.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_smccc_set_filter() only rejects a range if its inclusive end,
base + nr_functions - 1, is below base. That catches an empty range
(nr_functions == 0) at every nonzero base, but at base 0 the end wraps
to U32_MAX and KVM tries to insert [0, U32_MAX], which overlaps the
reserved Arm Architecture Calls ranges. KVM_ARM_VM_SMCCC_FILTER then
returns -EEXIST instead of the -EINVAL that the smccc_filter selftest
expects for an empty range.

Reject a zero function count explicitly.

Tested with a userspace reproducer on an arm64 VHE host under QEMU TCG:
EEXIST before, EINVAL after.

Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/hypercalls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fb..dfa25bb6f25d 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -185,7 +185,8 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	start = filter.base;
 	end = start + filter.nr_functions - 1;
 
-	if (end < start || filter.action >= NR_SMCCC_FILTER_ACTIONS)
+	if (!filter.nr_functions || end < start ||
+	    filter.action >= NR_SMCCC_FILTER_ACTIONS)
 		return -EINVAL;
 
 	mutex_lock(&kvm->arch.config_lock);
-- 
2.39.5 (Apple Git-154)

