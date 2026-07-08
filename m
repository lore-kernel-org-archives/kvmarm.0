Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934EC3E9C05
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497475; cv=none; b=p7I9HrTx1duIKvZ9rT5D61QavdqSLuJqPiK57yZDxyrNbh6lV5XTzp4QeoOcDZzWniGFMNxiTa6tTCApO3EvlB1X6EdXijlOSr166uwT8PTS6zWL+zS1gF5Wh9CkoAC64IEZIfQK/3voNRH4AHeeiLLAoNVWck+5hJSZZR/Ol5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497475; c=relaxed/simple;
	bh=hZtsxisaPTY5ToDb2Nu0+RQ+BpvWxp67/nOUGgZNJ/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gkaUdLFzWPc8eOwQDkOF5Zj+mhGQ7Y5fUZaAbBtc8Vkd5YNGnSXSBYE9KetNGlXA2b/05WUlJ4SX9gOVPrR0iins0MO31zqFYRjiKqXUtRrbTKgupA2q88CiNX0NAdGj7ALCoS4yIe7IIRGDbtCUfwwhZZSFZ7sQ/3LypJsUS+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X89nom3r; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X89nom3r"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c12823d7822so35651266b.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783497467; x=1784102267; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9u8vK7y24l4tdEbBKumAzRQyzhCWiiUx4/oaY05z2cM=;
        b=X89nom3rA8p+36f6fBNu+XsM1LW8MxRUFRsyWajqfJlh4zKxwgNyXBSiRXBw3JEbIv
         RIuvhx1F7ZT6AYyiKqKgMicUV2+EKNOqTpm8LQ+H1WD8V7KX/W7sjvTrd81yg5z0UtWG
         Y0RKHR3zfjjOSa4rtIgXuGDyXNvLiIzMaJ30Y6K/GMz1BVSypt20Xf3WDU/IX58wOazi
         OvDV5zGEmLJJX4lz2i3F1rv0a88a8emxn4+sasP+WTS9bINCVoMgihiZKNTSLi6yDgby
         mYZeznktrlLFlBp55JEWRHcUHN67Q4Wu0VRI/6bTkz6LjF/B/4gfd/2Smc+HaBkPVLpY
         xHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497467; x=1784102267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9u8vK7y24l4tdEbBKumAzRQyzhCWiiUx4/oaY05z2cM=;
        b=N/JwXIDMlwkoDQcifs6vfWAeQqBqNFdMmhKK8kyqBxkQQLkXjsb73esmuMa7LMXqro
         DYsTrrY8qO8635dzlgnBi/VaUpJgyBqqBtLW/iVPh6zfC+sP+o8VdVWM0WBY9E1GMU5d
         XuTmS9Iy8wX64qF1QSC0Fh8Od2XN+Rscw1WVBWquYZ9uUfUjdQijpeD3wqifxN6P22MT
         LeQ4t7+OA6U11Z/j698QYhyVe28hJKkj7xH/BkxFKldtJLadGhxN24XSlQT1GWDZNqaR
         G36Iy0JuT7b3uClhJR3+5+qsZEAiBMbZ+M2lbH/XUo8TOzsAgFDo8M91JM/wYm+x2mD8
         mPWA==
X-Forwarded-Encrypted: i=1; AHgh+Rr2UL2pS/muXfGcqAZEkoGwbqaE9E35fcR6LAnecWru7sgts8silhBW3La2qA9QBb/MqHWnUbU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwV/8oEbyPKsYSbXLfKs9/ozZQXXTNlrDaLbRAGjBctWAkhFXJP
	aG9t52BpuQ5HrzD1hjJLOj3LyCftXc8pg6vGhziFOtuj5EEPW4vV4OENgxFR4zmbFha/PP6BX9W
	UrTk2YWVgI8P4PWj3M49LaA==
X-Received: from ejar8.prod.google.com ([2002:a17:906:3508:b0:c08:301b:2ab6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9454:b0:c15:b9b6:6b17 with SMTP id a640c23a62f3a-c15cdec7abfmr74573266b.4.1783497467071;
 Wed, 08 Jul 2026 00:57:47 -0700 (PDT)
Date: Wed,  8 Jul 2026 08:54:34 +0100
In-Reply-To: <20260708075435.47419-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708075435.47419-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708075435.47419-4-vdonnefort@google.com>
Subject: [PATCH v2 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	linux-trace-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The current REMOTE_EVENT() takes as a __printk argument a string format
and a list of arguments, such as RE_STRUCT("foo=%d bar=%d", foo, bar).
Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
function. This intends to support the creation of a "printk" event for
the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
a dynamic print format.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/trace/define_remote_events.h b/include/trace/define_remote_events.h
index 676e803dc144..4f4d58e37b84 100644
--- a/include/trace/define_remote_events.h
+++ b/include/trace/define_remote_events.h
@@ -35,17 +35,26 @@ do {											\
 
 #define RE_PRINTK(__args...) __args
 
-#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
-	REMOTE_EVENT_FORMAT(__name, __struct);						\
+#define REMOTE_EVENT_PRINT_FUNC(__name, __printk)					\
 	static void remote_event_print_##__name(void *evt, struct trace_seq *seq)	\
 	{										\
 		struct remote_event_format_##__name __maybe_unused *__entry = evt;	\
 		trace_seq_puts(seq, #__name);						\
-		remote_printk(__printk);						\
+		__printk;								\
 	}
+
+#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
+	REMOTE_EVENT_FORMAT(__name, __struct);						\
+	REMOTE_EVENT_PRINT_FUNC(__name, remote_printk(__printk))
+
+#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)			\
+	REMOTE_EVENT_FORMAT(__name, __struct);						\
+	REMOTE_EVENT_PRINT_FUNC(__name, __printk)
+
 #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
 
 #undef REMOTE_EVENT
+#undef REMOTE_EVENT_CUSTOM_PRINTK
 #undef RE_PRINTK
 #undef re_field
 #define re_field(__type, __field)							\
@@ -70,4 +79,8 @@ do {											\
 		.print_fmt	= remote_event_print_fmt_##__name,			\
 		.print		= remote_event_print_##__name,				\
 	}
+
+#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)			\
+	REMOTE_EVENT(__name, __id, RE_STRUCT(__struct), "Unknown")
+
 #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
-- 
2.55.0.795.g602f6c329a-goog

