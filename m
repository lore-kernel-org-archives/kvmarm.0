Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0443CA4AF
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784112672; cv=none; b=VPl4xYXUKuV4JFoJCFVrVZxR5gVsv0iE5Al2tg5didsjEG6kVjEqfyIWbmBVo3PAe5NMfwBh7yO5f82b08i25GkJDa3t/T+MyC2ASLNKGTgZlYhaQPloWk4wORowckx0yz+kxbpYMsPX2VFsv96rsMwfn4Y6ZFoK60lFf3ovgLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784112672; c=relaxed/simple;
	bh=qHuuahOhWCgMrhXxu4vZWmkrsOESQSF+i78oRDWtwa4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=glFppPi8q6zJsEm0wtWm8O0xSyDrmsTMYli3Ogg7zcDugKTDmzGJTeO41CF6wSuEhzaoUrpecqsQ0VZHZNRckVduYGYd20bbeKqFdkO6hYPCoxhc4JChwNUGCOcJjcNRQfnVW3u1EZpMtBvDR9JpG/AnnRGZz+weUwGcYs8yRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PsvWN3o5; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PsvWN3o5"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c160b9c0676so127675466b.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784112667; x=1784717467; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dwtuWs6fZAlqKW07ZWIa/L7IvORP1bCSU0S6TTxBnXQ=;
        b=PsvWN3o5yoXoGi6nwy8oCZZ7MaHCgA80z1+Vq5C0lVwGiFvg8utfvRl6ywehScJwLd
         OEvadMhdJe6xk7lxJnGlhGx8HGwR9rc74CG3iq9/QIiKizX1DYIJDG4wPuXIWOiYyAVl
         ijar++fE9jhdI62kDqvfS3xQ5RyTFySscV++sHTq2gDhaaNydcZy4WJ8t1c2YbPTKkCj
         30+/BOeVNgtyqKxju7wx3vsIzn4TeRIjYVTs6JOTHWK1hzztSqEISwzsZAO3j7x4pnur
         LRBVypVQbXmOY1K/AGc+vVEnNVTITdwI9OEZaBdPsQK8b2tuM8Hif+af/cQ5E/m8GYZN
         Y2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784112667; x=1784717467;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dwtuWs6fZAlqKW07ZWIa/L7IvORP1bCSU0S6TTxBnXQ=;
        b=XZR4Iiy6JSHme3jxJf4ueHTXW8lORXyo0YPlSDD7BCoXCCKjJuoyB3TtNhatmC9QWY
         q6UDZVBWwCnwhwhCyZgr/nU/9Gt46UD1v4Jg4Ic32z60J4BhcIPwe5M1dg/t9HWsKmPs
         3eolocIGvAMR2AIyI129frzKCzBEixRd8E964IDzQTpVvpS8JwBqFRCGlddrcgGuAvYU
         H8Ur/rfwoJhboLB575DXSLvsa67SReTD8TwWzoCatEa59sH5Kv6mh7KRBJG2LdBy19a1
         BleTg8zfakAoCtBefDjeoAGZh2Da2T//YqevFiJ33LJbNhl3rp81OE69M+1/cFMOkWSB
         DD0g==
X-Forwarded-Encrypted: i=1; AHgh+Ro4YsvE8krJFinfznOp0Q8wbYfyxF2c50hnyI/TwNv2Y+FosjpFectROrk/atX+1qIIlxaXHtk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJSCQpckgkgLd+1aRtyC/wlao82/T9ONz7uwD9cVvNzHS2qF8Q
	zQvS5fv5yMPjoRkbOVArJCMgLnMvpa8igUZY3xW0B1plhatYuSpPTHbBfdcYcNnZANbWcKbKJlp
	tJU114kCb5R61qLOu5qqmOQ==
X-Received: from edn4.prod.google.com ([2002:a05:6402:a0c4:b0:69a:a0e5:c4fe])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a703:b0:c16:66ad:f8ff with SMTP id a640c23a62f3a-c1666adfb6amr360778566b.39.1784112666977;
 Wed, 15 Jul 2026 03:51:06 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:51:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715105100.3178255-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Fix hyp_trace clock disabling
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

--- 

v1 -> v2:
  * Rollback hyp_trace_clock_enable() on __tracing_enable error (Sashiko)

v1: https://lore.kernel.org/all/alczBmnItMwq8xj4@google.com/

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..9bfa368dd841 100644
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
@@ -304,9 +298,15 @@ static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
 
 static int hyp_trace_enable_tracing(bool enable, void *priv)
 {
+	int ret;
+
 	hyp_trace_clock_enable(&hyp_clock, enable);
 
-	return kvm_call_hyp_nvhe(__tracing_enable, enable);
+	ret = kvm_call_hyp_nvhe(__tracing_enable, enable);
+	if (ret)
+		hyp_trace_clock_enable(&hyp_clock, !enable);
+
+	return ret;
 }
 
 static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.55.0.141.g00534a21ce-goog

