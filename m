Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF69368D7C
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782538; cv=none; b=c0nkVnbVKfabYQ1B3uSZuoQ/LF4MsvYgoeSE/FZew6U3liFFrfF7pocYVLaSmPIYeawg7nWJVnbKH+oT5qwClSLS5Ms5UGWMRZvfpJr/DvHSZk/NzrzoEJSqkM/xLDP/KSFaKarK8Gm+950fUQB7HPsaCVkzmZNKJp45+KiOZgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782538; c=relaxed/simple;
	bh=Gl2nh1mna2y+23rQhB706F+C3kPnDuofPhmLMj/aF+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DX2TZG8+NDuSKf7MrjClKX9fZCvoF7aGuwE1oqB3r6mknVVC5qLP8mX+QHpKc07pqtVUsAaYE8TtA002U8vyEUPtnWtNn125Se4nXJu+lPhEsrzvKq25o9YINPTBxbzg6N20mQsvkf2irGFfluQNUOEVrpdZSUKJsrKf/rSGc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flRxJwGH; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flRxJwGH"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e64b80b94so32074385e9.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790782526; x=1791387326; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUIvVU+0Or2i50OK5aEmy7zfuDDVyaBvx88xnEwYFu8=;
        b=flRxJwGHgzkGOUMrMAFa7thB8a3pu1ENFFpvSO6AOzyKSPiqvXzZtw96DevbhNQlNU
         AbPWuUhcrvVd+gX1n9SgHp8Me1/khxZK2WjURmZNsZAP5MghmdNLaoD/sMSe7OwYtflb
         c14Cg7uIVVgVfiz8vUC8UWcuRKwctVf42PvgOEniRWFDVvcphBRwRcW0xQgPMomeSfhz
         zebRYSjWBxn69ixZEFSCEyX7XJErUfdaVl549qP8Q4n9MnC5FopCDnaKTC3gMP6QYvV+
         hihBkgx776W0J6Gk1PQ8fUAoz90QbFmKzvbQUuYgiKAaB91TriXIGFG/e0r1cCg0MSBC
         f5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782526; x=1791387326;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jUIvVU+0Or2i50OK5aEmy7zfuDDVyaBvx88xnEwYFu8=;
        b=p2YhzMQ7E6kn9Gs9GjHPbevkrvPCYl0H5LUALPlFbrWTkmWLDXbIla0StFo5hIUatD
         Vbd3qUWxY/nP9RHk2H4RS3IMS2XSF+0ZbpPaEb4lDXG070Hp4qSfwU3o6rY0K0pTk3Fg
         gzHpbZO/wo0fZAzUoS+/72DwQhd8SquYW+xHUNooIQST3Yj1cB5RCKSpuyXrHQv5IjAd
         SAgGyJegKbvlV/tkHdSs08olp+roMoK8o4/vWMUqbKFO1/Hk/fH2vChuHe1YfaLqtVpn
         kTzX0q9WdqDwYgwSheGGeNvjd2wjpoWIbajoPYHfM3eliuHr2WO8iE50n8rrF36zqZEn
         3Fpg==
X-Forwarded-Encrypted: i=1; AKwUvBx2f/pyNElnjYom9nl0aiyyAmAJThegkiZ5Ao4QZMdx/XY+QWbj8kLGSk9wD9S3BuJX6s91gls=@lists.linux.dev
X-Gm-Message-State: AFuF++nMRVkaXeKfSrG55+wtCo+Sb6wz//EdaiJ+vhuiiGlPw3XXlRE4
	mbqqWPjKVUvtXYWiHapj8jK62OOL94Zds99s/YcJkjSFAjPtSEuJTbdYcXNou9kUETv4n4Egcej
	bO5OrNOPwQXXCj/tfiVaXAw==
X-Received: from wmep22.prod.google.com ([2002:a05:600c:4316:b0:4a0:626:c24f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f55:b0:49f:f0bd:1e40 with SMTP id 5b1f17b1804b1-4a01b11ded8mr34376735e9.23.1790782525939;
 Wed, 30 Sep 2026 08:35:25 -0700 (PDT)
Date: Wed, 30 Sep 2026 16:35:04 +0100
In-Reply-To: <20260930153505.2144559-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260930153505.2144559-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930153505.2144559-4-vdonnefort@google.com>
Subject: [PATCH v3 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"

The current REMOTE_EVENT() takes as a __printk argument a string format
and a list of arguments, such as RE_STRUCT("foo=%d bar=%d", foo, bar).
Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
function. This intends to support the creation of a "printk" event for
the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
a dynamic print format.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_remote_events.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

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
2.56.0.rc1.315.gc6ed9934b7-goog

