Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D83CBE6D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052658; cv=none; b=j1e2MVVh2D7k+kPQlXPyK2unESItq5qJdP5+In+7xwmxh1oryRrceozFlhW7D6+Mb51MRYYSghoRGNYRCQkXuMPBal7alv2JhKO9QHHHcbrt3PoaBIfVImc5BtXiJwqIcGzRuGOh+7ugJW2Kpu1CjFpGHwt7BVQVtMtnpCTg25U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052658; c=relaxed/simple;
	bh=mxi/g0FaxjexQONpL8gDyj3+J2M7UP6EPbdnqaQKL8Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s57nLDxs4Zj7lAF43CjEZgzpoyJlBEpWKcYWTAn61P4tyL1NFxRCVgQPA9WcmdwWOYqpaHrb8j7T/mg9HZjJg5ToaCHRwbZamLwSOSyqiFyzf1SHkhqbiJmJP9+VrsirHzXi8V6VqOLJhchYgXlacLvV2t7UT8oGMpVntJGRcFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o3pozvv3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o3pozvv3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-492488f8583so66157425e9.2
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784052655; x=1784657455; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cfKdTJ0UW1n66HS6tgSej7/MevFTojdr1dMFwbyGTJ8=;
        b=o3pozvv36rbdvSvmmgi7fiketVXDaLpDKNlCFo6TyPRcOm3FLXgcyGnsRG+DiWpKXc
         Tb3gBHZF+LiBNhe7UYBsvNRzKzCbUW3kTYUJyIH1vRP/ZA6a4KuMBQrw1GvAb9FdXhKC
         Gcn+nOYmex2pDWKs5WtmyGo6kXoFU7hfYf06gDKERCujSEYqk2C8HUM3BDZLP17xBQ7I
         VMtPxtJizQmP5RrLCa3OMC3oGg3HD5G7PwtqIQ44fA+q9LtJ2u7/CPxxMNIYJufo1I2h
         xeAAAdY0y15qy43geHi1moxfxTsDT2Q7PccoZkWLwrYTEb/6w12VWhxFfE7mSedirn9a
         M3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784052655; x=1784657455;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cfKdTJ0UW1n66HS6tgSej7/MevFTojdr1dMFwbyGTJ8=;
        b=ib0OxjqzqLR4rs1qDmLLsgVWi/faJnCEycWbUL8ZNqiSxTR+PhjG59qiSWbP6gKk1q
         JZIZotfHbjRjKe+wbkI1LKrtl/2SyPj3gNcuP4/PGt9I/kqZ11TXzbAeOZLpYXl4yzSg
         EFQBbieQrRAb/RIbncgbhY7Vh4xBSCOVv4E1oCbW5HbP3zcYTeiaT9GFDbR4v7yvUl1k
         CH3cb3UitwOzCyKqMQtqO7W1fVqvc/o/1nb837L11PcdHwGoU0TMd15hLTLTvCFypEyW
         CcL1wa+BPThrJ+mihbQzNVUxmTRuNCzDCELnJEbHvxEbdDvnaGKcdCeAGK0XM5xkvlFy
         2qaw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+awpAEP4Wo5s9tRSlMmRKnm/oyHpI1OV77JOvqsgI8SI6LCTjuVE7R0/TgLTgwgA2jaeJlU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUxfmLGbCTnU0w/z+xb4V75yRwHe84AdpNac+TUV3WnKH2ndl/
	eXmXEBSPSrl6qnH2l/7QLl07JIi3A0pcLoAsd9IZMsqyOalBcnk1wgZeP4jH8F8tZlkASGjo2ug
	Rtlwkncv9UNlmizFmT2noDg==
X-Received: from wmrk19.prod.google.com ([2002:a05:600c:b53:b0:493:c111:8ed4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524c:b0:494:df:8895 with SMTP id 5b1f17b1804b1-49538a0251emr41049885e9.24.1784052655128;
 Tue, 14 Jul 2026 11:10:55 -0700 (PDT)
Date: Tue, 14 Jul 2026 19:10:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260714181010.2527225-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix hyp_trace clock disabling
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the disable path in hyp_trace_clock_enable(), which fell through to
re-initialize and reschedule the clock after cancelling the work. Return
early instead.

While at it, cleanup hyp_trace_clock::lock which is unused and
hyp_trace_clock::running which is redundant: the trace_remote framework
already serializes calls to the callback enable_tracing.

Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..0b03117a38ec 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -37,8 +37,6 @@ static struct hyp_trace_clock {
 	u32			shift;
 	struct delayed_work	work;
 	struct completion	ready;
-	struct mutex		lock;
-	bool			running;
 } hyp_clock;
 
 static void __hyp_clock_work(struct work_struct *work)
@@ -110,12 +108,9 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 {
 	struct system_time_snapshot snap;
 
-	if (hyp_clock->running == enable)
-		return;
-
 	if (!enable) {
 		cancel_delayed_work_sync(&hyp_clock->work);
-		hyp_clock->running = false;
+		return;
 	}
 
 	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
@@ -128,7 +123,6 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 	INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);
 	schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS));
 	wait_for_completion(&hyp_clock->ready);
-	hyp_clock->running = true;
 }
 
 /* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.55.0.141.g00534a21ce-goog

