Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114346;
	b=oTqmvmTZ3dM+VGpr4SFQPRRrbyak5/RRWaoyYHzoQpJuVdXKGZem+/FTc12IWPkplpbJ
	 XbGehQvy9Exi74jsWK93CNnH2mLbcLNNVYCrY4Pmt1W2l/UUcH4BseVeTrXkN1ECgzVH+
	 /oHsouTPPEj+pvPmPJ1UMkIaI1Y38quEKC98k72sRz5/ZkVMDrsqNaNLs3GVtLcOikj90
	 FMYxDP/7Kcpfdhqunh3Tm69hdBqRk8wVCIPqTPUT7aaqCmDvo3wYb9k8WiwR5rA7vKGtO
	 4/8yvq7bkkZzB84s9TpdjNO1eTzKTeZcDlmoT01Ab+R62EugnuhxmQYz/GPfbfbIn1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=pLq92bALDfzVSwPCFwlrCOZ9rlSOsAmXjgSBQp7hHGc=;
	b=yJMnIBEkYpHuGbtiqdehdWxNLc0ni/Kq/hD6Rj5uU72aVzqIa1z+RhzZh46oe9IllAaI
	 eocDTQUTRg+fpDRHbzO/rKEYYz6pOwqbWnPvCXQ7s023+jO+j3CZx3S1RAAfMuc1eth02
	 6wzileVIBxqfw7YJ+XpwYHnpkHaXYXbHhavEq3YroX5Fo5jXfII8D7skY9d801MrYdTNT
	 4YDKyUWBS3yNBpxqvDS0I++KrUcpQjA5GLPb4doDrhBIjWwk4UtRspZkD5PZS7JiVYUDG
	 gSO4894BX5bGK3QKOhs6XqCo3QCrVS/ZkhIaa7+o76Oe/TKbcE6Jm5qGS6/WE6BMH6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KCsOlbBm;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B578E60A6F7B
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B578E60A6F7B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KCsOlbBm
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e778acdbc6so171521b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114345; x=1795719145; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pLq92bALDfzVSwPCFwlrCOZ9rlSOsAmXjgSBQp7hHGc=;
        b=KCsOlbBmv/4JsrFFUzeR+GoJh2Py1EWY4CaM2TBozW7tuMI7uyjUbR/FmhrWT29SYg
         A8JY3uaw8i6xmNgEjEUjeBSPWKWANGW/l6hdZZ9HeCcvYD8BmYM3P3mQIypL0KBPsB35
         F8ZLfFVUFobiSY7y6mXuy84xTd6O/4XE4mNiAigvxr6eZoHujB1f9Lx4WYwvZh7H9Y6f
         0dFPpFZjctwvH/IK/qDcuNAZfMN/6Oq82O+g3/Kso4suK3HrQZbGOH0IpoA52oldh/91
         kjGvXHz6fCTxUp8ZHs/VqmG8CYx32nVBB23qtubVgxJIIVUtcFERcPGPHc+py5jpMW6N
         /f+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114345; x=1795719145;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pLq92bALDfzVSwPCFwlrCOZ9rlSOsAmXjgSBQp7hHGc=;
        b=jcF9yvWHMVa1NKXw5d54pOGrVOLECslZ9oTgYJzJ0vwq66z+FeH3fUwaWKTGirjERk
         2HtI2bwks3bgUIChj/wpsW0bn+ERxDKdoK2qfzl8Pl8NOEz1q78pbg0pM/z6tqRvu7lL
         GHIQBkO3yWUnrcixRKb6388Tdhtg0Ufy7zznBarDkPd7Pns12OUb98K6Sq4nDSiZOoaE
         dw5/DOKCEY/5Wyw4sJfm341egVqTa10nfHOV29zPUhwUOeS9MAftrga1BxS1aF4/muhe
         HO9qOukcyUZE2j88lCUIVdQPQUPTvQw0kjVIuHnqY8AZzVkbYRAOrEGRf/azxkdofweP
         dTHQ==
X-Forwarded-Encrypted: i=1; AL+hErEeofNbA/ONFzultVH6zeuEK9urRkAkfyF7l5gz7u3fsOu+2KnDxOgKDUCy/kqRG+T4zYesdV0=@lists.linux.dev
X-Gm-Message-State: APuU4Z8yYqY5RwE2njKMXoGmWUnO1BbvTWe06/p5KbAjqfNpzGHaLvJ9
	sLIUyY1kNhStpzLP1Ij/D8pzoEkEf6tEY97nuomduWVI0ga3ek7nxgcjN0BZFXgnGIvPaqPU1Ei
	GGi6In0owE/qRAuWSNGccxAqRPg==
X-Received: from ioo10-n2.prod.google.com ([2002:a05:6602:864a:20b0:9c7:8645:9285])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:178b:b0:55c:8ed:4db8 with SMTP id 5614622812f47-57a0cbda8b5mr953892b6e.62.1795114344372;
 Thu, 19 Nov 2026 10:52:24 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:51 +0000
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
Message-ID: <20261119185215.632334-10-coltonlewis@google.com>
Subject: [PATCH v10 09/33] perf: arm_pmuv3: Allocate counter indices from high
 to low
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

MDCR_EL2.HPMN assigns low-index general-purpose counters (0..HPMN-1) to
the guest and high-index counters (HPMN..N-1) to the host. Allocate host
event counters from high index to low index to minimize collisions with
guest counter partitions and avoid rescheduling host perf events on vCPU
load when enough upper counters are free.

When allocating a 64-bit chained pair (even counter idx - 1 paired with
odd counter idx), verify that both idx and idx - 1 are present in
cpuc->cntr_mask so an odd HPMN boundary cannot allocate a guest-owned
even counter as the lower half of a host chained event.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 9ce915754b0a5..667ce27d2347c 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -957,10 +957,12 @@ static int armv8pmu_get_single_idx(struct pmu_hw_events *cpuc)
 {
 	int idx;
 
-	for_each_set_bit(idx, cpuc->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
-		if (!test_and_set_bit(idx, cpuc->used_mask))
+	for (idx = ARMV8_PMU_MAX_GENERAL_COUNTERS - 1; idx >= 0; idx--) {
+		if (test_bit(idx, cpuc->cntr_mask) &&
+		    !test_and_set_bit(idx, cpuc->used_mask))
 			return idx;
 	}
+
 	return -EAGAIN;
 }
 
@@ -972,17 +974,22 @@ static int armv8pmu_get_chain_idx(struct pmu_hw_events *cpuc)
 	 * Chaining requires two consecutive event counters, where
 	 * the lower idx must be even.
 	 */
-	for_each_set_bit(idx, cpuc->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
+	for (idx = ARMV8_PMU_MAX_GENERAL_COUNTERS - 1; idx >= 0; idx--) {
 		if (!(idx & 0x1))
 			continue;
-		if (!test_and_set_bit(idx, cpuc->used_mask)) {
-			/* Check if the preceding even counter is available */
-			if (!test_and_set_bit(idx - 1, cpuc->used_mask))
-				return idx;
-			/* Release the Odd counter */
-			clear_bit(idx, cpuc->used_mask);
+
+		if (test_bit(idx, cpuc->cntr_mask) &&
+		    test_bit(idx - 1, cpuc->cntr_mask)) {
+			if (!test_and_set_bit(idx, cpuc->used_mask)) {
+				/* Check if the preceding even counter is available */
+				if (!test_and_set_bit(idx - 1, cpuc->used_mask))
+					return idx;
+				/* Release the Odd counter */
+				clear_bit(idx, cpuc->used_mask);
+			}
 		}
 	}
+
 	return -EAGAIN;
 }
 
-- 
2.56.1.708.g77570a6a1d-goog

