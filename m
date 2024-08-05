Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F6715F30D
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879224; cv=none; b=lFBZtyiOx1gF//lV7F4XhwKgIQkgEbl2ocXMusH52dJbIPvV0XfChMk29S1G5O+3hPBSArHCHhSbdWGrBttBV36f6vVflZ2hCXWBlvcCb68jx+sw+IEYjMi+PyLSVL50nJv1ANEZO4X11SNZs4JRIojaIsuO/MWsZcnVBHhoDYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879224; c=relaxed/simple;
	bh=NAaMm6FGtBs8x6nFLXiqetgb9vZiBdZM5njNqO7VMq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mRlKdUdaaef3NkeYQww826Menjf1i82DfH9ag2k16sQvjDl8NIgWIEfAp+vxJxThO+JLLqLzteHW3Tec/OxTrM2zLZwBt8Hrx+9SqLuHK9DnnH7wF4kxjO0sMgRpzGsDESdhFy1cZZJWbhj8/JVZ52q1HijsJeNGX5h2+X4l4bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUiMqHqM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUiMqHqM"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso9362099276.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879222; x=1723484022; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kqYBFDb52MPeQoQy/x5YAwWC+yZc2pnNoTG71AB8m4o=;
        b=cUiMqHqMkJdazlHoEu3x7YdNWW7jiLYl43Jx6cWDVCgrH5e/DMmUrFF7fqFd2HTR0o
         cQTuoD1nKGctJ4BuM9Lw51CbZcfyfDyfcsk391mtrxPHXUaWCdWF49KYaEQ38xDFDv7T
         2Wi6CYbu8qn1RzTfgYhF7nbX0YBdgrYTousfl0P5pXkhra36gKsxKjCcNIiGCHS9M1l9
         TOrj2/sSE/RnmKvEdoTYJz3V8ESnOKcceAuyFD6m5Y3kuEsw1y5KapKQfERmsk7sPjAY
         0loM3Fkx7hot0BeHcK6Hm+I/l70R17V7f/22K5lr9o+YEWXqzkSNCcSkRKppoIlnwdgM
         3eGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879222; x=1723484022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kqYBFDb52MPeQoQy/x5YAwWC+yZc2pnNoTG71AB8m4o=;
        b=lGGAVpq1M/6v2kwGNgwjeKcdUn0l+83iDXOIHrPQxMWLmbINIAPA5l9ajiMtU7+t7S
         8Ux6vq/zLXptw2Nprr1pulRkgTqxr7tyIgMmVSfqHHU1mr7zBXp0yUCF4FjC1f1OyeY1
         fJ5hXGdIlbrJKuH8tnV2wdutf5vUMNfXnVNZ0yF9M289E3046InPIcNsKEsNeNNl43ng
         iVhOvpBD5kwZK1Le/A1e1MzyC6dLKWDWBeL+NYbqU5jaz8DrgQE5Nvvzd/A8rveBa9U8
         J0vMAlrjYDa6BptJgkvfd4bMnX3/z/3T93ADDEmnqw+StjEJMbU67aPqTtca7x52Ncao
         4OeA==
X-Gm-Message-State: AOJu0Yx4qOXrrJsmoKe+D7RLqfNfuQmlk3lJ3/cfnCBUCqZr30XmGj0N
	loeDtSGLOXFvevnm9OLsyPQ2cVwqhTWZU+Ug0wwYYYID1EUQQlEohhwJYSWPSRs/EhFcpogVIrE
	w5wh94nYrbs8N+yHy9g==
X-Google-Smtp-Source: AGHT+IEIqTC5soeTi7XhOJFGunpo1Uo/bgIUzGPNgE1Bj+oW/k1Xa7b1SXbIHscQIRL67F5+ZVYi9Q8454PcydIa
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:6902:18cd:b0:e0b:bf20:4ff8 with
 SMTP id 3f1490d57ef6-e0bdddc9faemr490069276.0.1722879222591; Mon, 05 Aug 2024
 10:33:42 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:27 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-5-vdonnefort@google.com>
Subject: [RFC PATCH 04/11] timekeeping: Export the boot clock in snapshots
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On arm64 systems, the arch timer can be accessible by both EL1 and EL2.
This means when running with nVHE or protected KVM, it is easy to
generate clock values from the hypervisor, synchronized with the kernel.

For tracing purpose, the boot clock is interesting as it doesn't stop on
suspend. Export it as part of the time snapshot. This will later allow
the hypervisor to add boot clock timestamps to its events.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index fc12a9ba2c88..0fc6a61d64bd 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -275,18 +275,24 @@ struct ktime_timestamps {
  *				 counter value
  * @cycles:	Clocksource counter value to produce the system times
  * @real:	Realtime system time
+ * @boot:	Boot time
  * @raw:	Monotonic raw system time
  * @cs_id:	Clocksource ID
  * @clock_was_set_seq:	The sequence number of clock-was-set events
  * @cs_was_changed_seq:	The sequence number of clocksource change events
+ * @mono_shift:	The monotonic clock slope shift
+ * @mono_mult:	The monotonic clock slope mult
  */
 struct system_time_snapshot {
 	u64			cycles;
 	ktime_t			real;
+	ktime_t			boot;
 	ktime_t			raw;
 	enum clocksource_ids	cs_id;
 	unsigned int		clock_was_set_seq;
 	u8			cs_was_changed_seq;
+	u32			mono_shift;
+	u32			mono_mult;
 };
 
 /**
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2fa87dcfeda9..6d0488a555a7 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1057,9 +1057,11 @@ noinstr time64_t __ktime_get_real_seconds(void)
 void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 mono_mult, mono_shift;
 	unsigned int seq;
 	ktime_t base_raw;
 	ktime_t base_real;
+	ktime_t base_boot;
 	u64 nsec_raw;
 	u64 nsec_real;
 	u64 now;
@@ -1074,14 +1076,21 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
 		base_real = ktime_add(tk->tkr_mono.base,
 				      tk_core.timekeeper.offs_real);
+		base_boot = ktime_add(tk->tkr_mono.base,
+				      tk_core.timekeeper.offs_boot);
 		base_raw = tk->tkr_raw.base;
 		nsec_real = timekeeping_cycles_to_ns(&tk->tkr_mono, now);
 		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
+		mono_mult = tk->tkr_mono.mult;
+		mono_shift = tk->tkr_mono.shift;
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	systime_snapshot->cycles = now;
 	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
+	systime_snapshot->boot = ktime_add_ns(base_boot, nsec_real);
 	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
+	systime_snapshot->mono_shift = mono_shift;
+	systime_snapshot->mono_mult = mono_mult;
 }
 EXPORT_SYMBOL_GPL(ktime_get_snapshot);
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog

