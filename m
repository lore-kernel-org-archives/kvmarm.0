Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114345;
	b=VUG95sqZv20r5ZsFVb5ukZ+YbwfvVpghC1uBx3N6B18uEyhK9O5K3D7MHuyZEi+kAZFX
	 SrqAsrcKvWRKDVefLo6LjX0W7rcfYPO0eO4qfCyVXwsDU+WqCstHeOxxhRnp+4RHkUnLY
	 /WfRobBLctivruQ5ZsvzpNwcQ/mvCqtO0bXEj4dOOD1bj+ZjYiE1bHDfyyEHd3ysmUoXK
	 EYlPf4DFdO90kvgPnVt1/Ob8B7oAnT5gV1XkI5RoP3U4eFiFcMrVOlsYeP5nr82uzRAqn
	 /2lZTKp7o8/lDFWgZdF/F60ZQL5mep2KUvmIZGQKqchmpI3X5GO9WhMYY10FBVCaiLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=gDyW3lpBDMB0NqyM7GSJ8o96cb3fLFzZmtMS+6iJK0k=;
	b=tqGwgNDyj50zVkNuNaX+RvLKP/wpiI7aRvJxmLku1IAWaRzTyDO60TjXkqrCfAmv+5Sy
	 /yJUjkylPZEh1wMMYOKp5RUepR+gxlKdpLWjKGQUVm2T066XY8a2e5u699nqXFPGpSO14
	 neUxkjuxAiKqE+mapQhosUl1b8avO/lrcVwQTx2frT6dirqAio0NjnTIIvnQ8Gg4uXQsd
	 zWiBJGI1v7eiSxbyqkqELv9l+jWIsm53X+6wyHrTgeqV2a1j2B1lKts9SlqXGa+gx7dYm
	 t60BJwJJFxd0kS7pXZDbiOlYTwcM9Y6qIydLKnzZQTchh03m2mJducVKF5d9mqmcXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KDSdYnGw;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF35860A6F57
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF35860A6F57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KDSdYnGw
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-84c4dce8182so141932a34.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114344; x=1795719144; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gDyW3lpBDMB0NqyM7GSJ8o96cb3fLFzZmtMS+6iJK0k=;
        b=KDSdYnGwQ1aliWn7lQN4fWt639YoI+Dx4z2Tl0yVJy2z5MdhnCB8vm6cUfVS6K8zX7
         wA09NagtpGvCK1HjMdFvOn/0Wc1/D7Y+DQo5bYzR7O1cYfb+VIKcMHlk/8cA9cRD0k+q
         yZHeerFtQfFiGpuRSoSvXB13vYvPDLL+ehg9QrYW5QEGPt4p8TDOWE+9d2RrUZN0V17b
         wlDbyadfA/zgZTP6ecXkMZJ8F9c9C7ts0BoFSjshBkJ7ZoXNjZBoXrVCKkHkGdCx0IP4
         smuyuZIomN2PyL21hMLrTmcS9pkm8O75tGUBc/wNHMu/M4nnml+HvgldwHL+nKW13msM
         MW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114344; x=1795719144;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gDyW3lpBDMB0NqyM7GSJ8o96cb3fLFzZmtMS+6iJK0k=;
        b=qDEXwswQU7VpK+afBw9Y0GeDvvG4i2HaraIF1LYwGVfX3Tc23PRe6jg5ZtTaS/Nl0q
         1unD6FcJT56CjB2J0Wm2nT7a9ky0zL65yef9NzJONbBD19Gzn6X6ukgxXkf/gJInyJKL
         rMmA2wUiS7TpiDLYptLeRppGz35l+OQBCm57p33qELTOcxAoKcOcJL8ndZ7gIb9oJXTO
         XUaltfKXZpZwDoR8GpAmosn6G279NaIB9OpR5mxXkHNxS8Sju2zUlCy5LJZ+wZbWNBWB
         J/QLbV1G4ulYtGK9waH1zBEuZ46ovOIPVDdjqhTmZRNrEsfYiLa0KWwWbQL3UdDeXqiD
         rHbA==
X-Forwarded-Encrypted: i=1; AL+hErHNFMb1rCzVRIjcctj6kkEfASQNi0EX9HeafqxUoooajofmv3Mdb4xJFJFWZDGQRLTEJlFOJfo=@lists.linux.dev
X-Gm-Message-State: APuU4Z+J0ugtebyFJY/jZq7/K0xvLLI1O0YeKHui3sjdHQBYuJWFOB9S
	HtIjUGtt5FEZKdFwtxObFLzq5snKcW/wsyXS41aOMp3eYnJtd33MkFE60s/j2SJDEP+ndsqLrJm
	aJmhn3q8SYXIATcxM9PgutaWydQ==
X-Received: from ilef19-n1.prod.google.com ([2002:a05:6e02:6193:10b0:51f:7667:1233])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3189:b0:4ea:18f:64b0 with SMTP id 5614622812f47-57a0c19af8amr826925b6e.67.1795114343396;
 Thu, 19 Nov 2026 10:52:23 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:50 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-9-coltonlewis@google.com>
Subject: [PATCH v10 08/33] perf: arm_pmuv3: Check cntr_mask before using pmccntr
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When the PMU is partitioned, PMCCNTR_EL0 is reserved for the guest and
removed from cpuc->cntr_mask. Move the PMCCNTR_EL0 availability checks
(cpuc->cntr_mask and cpuc->used_mask) into armv8pmu_can_use_pmccntr()
and un-nest the 64-bit user-access fallback check in
armv8pmu_get_event_idx() so host CPU_CYCLES events fall back to
general-purpose event counters when PMCCNTR_EL0 is unavailable.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 973d4abcb3a6e..9ce915754b0a5 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -1013,6 +1013,10 @@ static bool armv8pmu_can_use_pmccntr(struct pmu_hw_events *cpuc,
 	if (cpu_pmu->avoid_pmccntr)
 		return false;
 
+	if (!test_bit(ARMV8_PMU_CYCLE_IDX, cpuc->cntr_mask) ||
+	    test_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
+		return false;
+
 	return true;
 }
 
@@ -1025,14 +1029,15 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if (armv8pmu_can_use_pmccntr(cpuc, event)) {
-		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
-			return ARMV8_PMU_CYCLE_IDX;
-		else if (armv8pmu_event_is_64bit(event) &&
-			   armv8pmu_event_want_user_access(event) &&
-			   !armv8pmu_has_long_event(cpu_pmu))
-				return -EAGAIN;
+		set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask);
+		return ARMV8_PMU_CYCLE_IDX;
 	}
 
+	if (armv8pmu_event_is_64bit(event) &&
+	    armv8pmu_event_want_user_access(event) &&
+	    !armv8pmu_has_long_event(cpu_pmu))
+		return -EAGAIN;
+
 	/*
 	 * Always prefer to place a instruction counter into the instruction counter,
 	 * but don't expose the instruction counter to userspace access as userspace
-- 
2.56.1.708.g77570a6a1d-goog

