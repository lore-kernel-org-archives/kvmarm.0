Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011FD4BB7E2
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270999; cv=none; b=TEj78UeWK0Kz50X6Y3ukZfFJTFdF1UtNw4Pxcbt3CS4AXyk+zZzXv1AT/mm1SOjhsmC2T1jbdlB5py0feMDMzq3yahitCUm0xxXWSeRNEUnWq+f/vX3FAVWNDPjBlJkoU9OHraqzhK8XQd6zqOiJ7QOSI1ZG/e8eBxTCF/+1zXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270999; c=relaxed/simple;
	bh=dPoD2KWcJdBMoqLmCayL0dkgGb1iTFvhuDn+uK1Rbmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FH+QNLbp3d0Os7V/1VEUpzc0LhOhVMpGbcubLC1Tl5KpP9FB3BMi8Exme/I+SiFR2QvyHD24i7JUsMDHHd6TrRC8ER57YJM/H9b8SjhoqzrTjsoBfjnpWdTp4hD8fO5g+mI42aELFkyq3VU9H6nsgNrYqIZPkv2hZzaYjPPdKXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k2Q08UVO; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k2Q08UVO"
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-809f1af7992so32909a34.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270993; x=1790875793; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5UB2VMD+EAaxdax2pXXlz1H3xk/sziSl+ovTL17nQcA=;
        b=k2Q08UVON2c38eTomKojd7zySbxPR3gubvIwzuD++TkpUN1qQirg1dWK20hHISMRxY
         OSwLROosMbumob4FxrJtqnXjgbDHwCeED15Wsr9qxpxWHbjoLtD9KQfV18Q+DFPO7/bE
         Q+ObDS3WgeAF7VwVf2JZMiMXbMs0Eaby+kApdXHINPzgFyd7ZNVwtZ0PmBVlnUma/cDm
         /11UCbPwhNsBoBCDmjJfGWuFHw/5baAr7ySTEmDG3ZYZaLT05NaH5WUOaFPg27+gGrZJ
         pXEQH4v3bOgf1jNVYZHrH8cCAVZNr53wotkyUfIrv+AW67KQR7YUstm1W6R+iwXX4THA
         ywdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270993; x=1790875793;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5UB2VMD+EAaxdax2pXXlz1H3xk/sziSl+ovTL17nQcA=;
        b=nJO/vNtVQQZzYN8yzjGr8WukJCtIj2GCVLLQwLn921RpoPuPTZRrEo0GxDfXZKYyRL
         PWy/9mVaAM7SNxC/OFWlx9oilg8LLb40848/5JUJNhpzIuzvcRrt1FEWsGpupkm0SrgK
         LTZJ2O7iQPDKW9dsc/M3EYAYOCOSGp5Tfd8iQ14M0i1LWteamAy2p/gYqQZzIzr3lO5d
         O8HF0XtuvDfbV6yF0XbO07SJ5832mV/knyqQFghwzKwb+9EdWESkFqZnB6+msdtVWHXu
         +bdYZh2/YvaRM0HSKK38q7aAAkVZNfCVDdqpRIo/BJUSKdrN6JZ6aDd6WHrDi9LUnpxr
         iQeg==
X-Forwarded-Encrypted: i=1; AKwUvBydlAKZJU96E2aT078kQ4Js6iPjHoeqhGI+dRbZ+0BMQJLYN6r5ZWjLWWmJJI4aHSZZkYL3924=@lists.linux.dev
X-Gm-Message-State: AFuF++nkmUtAN/eMdFioa7rtZcaVdwcCx6ICaJfs7zIKqpP5KmV11Bid
	NPzbiKCWjMgXYixsBlc1j3GFiodE7H0+kdunMGHGdqmeEeEEmRuiiF+oV1lsa24El6kUn2d/jC7
	Kdr5Wi2T2tYAQUtLOVDUT/fydTw==
X-Received: from ilbel26-n2.prod.google.com ([2002:a05:6e02:501a:20b0:50b:1d1a:8453])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:199d:b0:4d6:90f4:48af with SMTP id 5614622812f47-4d72e966ec8mr3960018b6e.49.1790270993044;
 Thu, 24 Sep 2026 10:29:53 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:21 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-16-coltonlewis@google.com>
Subject: [PATCH v9 15/22] KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to
 resync filters in process context
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, kvm_vcpu_pmu_resync_el0() only scheduled
KVM_REQ_RESYNC_PMU_EL0 when called from interrupt context (such as an
IPI reprogramming host perf events). When perf_pmu_resched_update() is
invoked synchronously from process context during vCPU load/put to
reschedule host events around guest-reserved counters,
armv8pmu_enable_event() calls kvm_set_pmu_events() and
kvm_vcpu_pmu_resync_el0() in process context.

Update kvm_vcpu_pmu_resync_el0() to call kvm_vcpu_pmu_restore_guest()
directly when not in interrupt context so that newly rescheduled host
perf events have their EL0 exclusion filters applied immediately.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 6f60f86fad387..a8214ab52fcb5 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -213,14 +213,17 @@ void kvm_vcpu_pmu_resync_el0(void)
 {
 	struct kvm_vcpu *vcpu;
 
-	if (!has_vhe() || !in_interrupt())
+	if (!has_vhe())
 		return;
 
 	vcpu = kvm_get_running_vcpu();
 	if (!vcpu)
 		return;
 
-	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+	if (in_interrupt())
+		kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+	else
+		kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 void kvm_host_pmu_init(struct arm_pmu *pmu)
-- 
2.56.0.rc1.310.g51773c2048-goog

