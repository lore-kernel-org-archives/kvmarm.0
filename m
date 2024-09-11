Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5315171E69
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047056; cv=none; b=uKyrysIkRjWD2q76Yva4TVjpU46hHvFLDVCTo1CXxUw12DTsbyGks3cesmkdgI/tOrwAVtHi8OeaGVlyISZj/yukMmKV8OY61an9o3uNqOguFyXi8bH2AtapwC1fSo++RyRWWTWGXgJIBgBe59nOpbd/HhHKcuDhLYcjfEcbBa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047056; c=relaxed/simple;
	bh=/8SgJehhjAGO88IlldewWFs2KgAfI8cLjbzPRVcr1YU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XpzdFA6zDHRoNTh0Ck0WpHZuauZJGS9K043cPCx/+Pv2HaOMZM8948yvkYKIHjO4Z/vAjOWsAEF1bkbqHShcmsJXcIxMD2OZx92zTF43S1A8I9LdoJAvpMOjL+efZRm0qouutwNQqcCFTioo7FWsRhckbdhC0g/a3NI4fmUBHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YPKGv60M; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YPKGv60M"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6886cd07673so47912077b3.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047054; x=1726651854; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oIPB93isriVCRhj0WIuzCaItTxePKQBs+tjSg5k4Ryc=;
        b=YPKGv60Mia86whcN1Ozs9MCK/0whwEQP+21SHDOmMCbqUkQ5A3gY/v7kr9FPX7nGSp
         G5wZHMazrjikqHR7yqf/+fqMg0zUtj4zevBHWJI+LONNMLU8IpMkJn9+cNTh1Vuee5JM
         KXKqmDVESZfFGtbIYJ8esB1oRxpW9szVBkGj0iDbjKuZKbWys3evZbqTD3F43KKCqb2a
         havwGI/pUyutoAypacSnCyac7ab1ihE24zBWA9XOJa3pv9DzvMlzTW+D3s8UxbGUqIQ/
         xNIFyTPNYS15iayZIZCgVjYqiOyWbkjAoAqEeQ7r2QGWnwrp05FK/6Xpqslf9yIybDMN
         rMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047054; x=1726651854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIPB93isriVCRhj0WIuzCaItTxePKQBs+tjSg5k4Ryc=;
        b=TA/wHPqL6gQ0/25m4nB30TdXwlhAT0zoWSR6VITbj651Cuevq6cmYNXBKJqCn8NnT3
         E22qc3elKW0nXw3kX3zR+zqIp19MENs7FZYZRAqwxkl+xUelMu+ALVk3sEJxP9T1ybyV
         Vd/MotOVhUL135L3oYWzdlVqHtxdL7Fjz1H8PJn3YkqonNZ8/14PJAmejKlwC2jrPl14
         ruGRR2muqs6sSm2otl+zI949L/5hTx/dpqx8uUV2r52GwbU303U40+KZIW5HSfnsyoWT
         6+qsvFZdBxTmZp4qz76bqA1oMV1tWGmip0oqC71gz5PEt9ntX6QNEh8fZZy85YuvIbeL
         ylSg==
X-Gm-Message-State: AOJu0Yz8qGBSYPSjmxolmjTSSTr6AoEdqGun+lpXD/s/wCz3S1cEOT+n
	3bzMjn7MQxAiwC43rJK+OZzhNoX2GnXNrHZpwNBSUUcPzhtp57M1cuTMRk+ErBl1Ua1MAhJtIaK
	9fFuFMOSbA3jYiWvgsw==
X-Google-Smtp-Source: AGHT+IF2SiSlHA5A9IgUvxBmmpL9JBXohsa0oAK6x+0ugHFFFRQb+SttHcejAg07bk/cX4Oc/0ZawYqPIQm+mLqf
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:d607:0:b0:e1a:44fa:f09 with SMTP id
 3f1490d57ef6-e1d8c260cc1mr2900276.2.1726047053855; Wed, 11 Sep 2024 02:30:53
 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:20 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-5-vdonnefort@google.com>
Subject: [PATCH 04/13] timekeeping: Add the boot clock to system time snapshot
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>, John Stultz <jstultz@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	"Christopher S. Hall" <christopher.s.hall@intel.com>, Richard Cochran <richardcochran@gmail.com>, 
	Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Content-Type: text/plain; charset="UTF-8"

For tracing purpose, the boot clock is interesting as it doesn't stop on
suspend. Export it as part of the time snapshot. This will later allow
the hypervisor to add boot clock timestamps to its events.

Cc: John Stultz <jstultz@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Christopher S. Hall <christopher.s.hall@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index fc12a9ba2c88..e85c27347e44 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -275,6 +275,7 @@ struct ktime_timestamps {
  *				 counter value
  * @cycles:	Clocksource counter value to produce the system times
  * @real:	Realtime system time
+ * @boot:	Boot time
  * @raw:	Monotonic raw system time
  * @cs_id:	Clocksource ID
  * @clock_was_set_seq:	The sequence number of clock-was-set events
@@ -283,6 +284,7 @@ struct ktime_timestamps {
 struct system_time_snapshot {
 	u64			cycles;
 	ktime_t			real;
+	ktime_t			boot;
 	ktime_t			raw;
 	enum clocksource_ids	cs_id;
 	unsigned int		clock_was_set_seq;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5391e4167d60..db16c44dccc3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1060,6 +1060,7 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 	unsigned int seq;
 	ktime_t base_raw;
 	ktime_t base_real;
+	ktime_t base_boot;
 	u64 nsec_raw;
 	u64 nsec_real;
 	u64 now;
@@ -1074,6 +1075,8 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
 		base_real = ktime_add(tk->tkr_mono.base,
 				      tk_core.timekeeper.offs_real);
+		base_boot = ktime_add(tk->tkr_mono.base,
+				      tk_core.timekeeper.offs_boot);
 		base_raw = tk->tkr_raw.base;
 		nsec_real = timekeeping_cycles_to_ns(&tk->tkr_mono, now);
 		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
@@ -1081,6 +1084,7 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 
 	systime_snapshot->cycles = now;
 	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
+	systime_snapshot->boot = ktime_add_ns(base_boot, nsec_real);
 	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
 }
 EXPORT_SYMBOL_GPL(ktime_get_snapshot);
-- 
2.46.0.598.g6f2099f65c-goog

