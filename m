Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2BB51DDF3
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865021; cv=none; b=W3z1bGDVVpspBmgm0fCqSWZbQDEkqexn4vjgBOCrPRoD6h7QomWuvVps4y4hFaGZaXERrTv5t5G2nPH5BgcliFpCqFxmoCDCD9TODJHqJwNeeYdFF7WUQGQwO8bTFX2bC67PnWJ6L1Wf53cW/CtPCsUt1uEO2eW6p/mP2q9/lUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865021; c=relaxed/simple;
	bh=m751UqJxw6xBW6H9UAoASRCaTHvvhjA5cyhyl4r3DIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UIjFTZHKp+6FZjs2tY3C11t6gYxkTNJWNd24F+/p17jTeNR2+wj27ReM2Qxmudxb7jf9AG7fhDCCxyz7FbVql/SFJOm3K8e/Yaqvm2TRMSngkHtcto6iMXXD22AYcHeXnb9zEQMJhBVhAnt03QpmQUSLw2ZHOOAC3eIN95xFDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WhQuh4Mp; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WhQuh4Mp"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c29959eb71fso667908466b.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790865012; x=1791469812; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Psw23Q8CDCixSo0VTysz6iofpq+/aQRzLCdg5lEY87E=;
        b=WhQuh4MpcI/lX3nqUEtu0MriQ28zLT0b9dKtkzUP4PDUbY4UEapUT0ieD5ewTi0hCw
         Zh7hva90oTUcIPP2MuB251X9m21BebbOi7e8WEmE0G/Yv3eKtUHJ5CTmztrKok51nZYr
         WDDBbQV8QzY0euzeA8A9u9jj9f39oFVAXVs53VXjCnEzE28mlwM4qju18S2GTxoQ5At3
         hDcU0TQmFAiv0W4oVQ4D0wZSc/M7rgm3Fsi09U90FVmGNKvUkm21NOIY4TX30AAqysuy
         OG+cCVyPW+dj4WIEmdIbMiiNUn2zfJHyS2TKQIt3MedscIRZyqc57dzflEWXSC0QRIl7
         DwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790865012; x=1791469812;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Psw23Q8CDCixSo0VTysz6iofpq+/aQRzLCdg5lEY87E=;
        b=xaDM1GYq1g6ySijjJwgBboNCgVpODMWUNVRRmweoB7LehfzUrvC+5zP3X6sl/wI3wA
         KyIGWxAxjMkO2612f/bAk8hSs7At0yXM+ltuad+v3l35hfQz7X8BHFQjQgvGfd2KYIqL
         AD0Ko7MbiqdgQG2kLBIY/42nDXOo2NJzoZXUYhyRlht1GGNDqODPjSx3bR2sQIByCP0i
         8DO/Kx5+mQK+uF3EWdxXtO/9dk52f0X9mnRglswEZrSVmZGnNw3Cnb2u2UPdl1rtyUf1
         Nkzznn7FYnKklA7uSAXwaOX+DL+oWcUMls8XfLDH/EX0zkNlK0oBcv3IDSMYNdXamR1a
         KqGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQrxkKNDMCQtjrpMJiKGeO1sTfioV2RTj+HcbiXDxGQmpeSlbtVjSCU15QFu+04Mcj9wJjX/c=@lists.linux.dev
X-Gm-Message-State: AFuF++npOk+mwMawaFODnlylAq1heZQ61O/patD0thqeWGzIsEaod0wa
	5o08z71wTsF39JxX49tBV5KEn3teYfmFV6M9lA3VBOuAR1oMJy9lpY1eyDg2f+TPoFvvP+8wx6e
	tu3D+oAF3T2Ko+XbB7aVfEw==
X-Received: from ejor16.prod.google.com ([2002:a17:906:5490:b0:c2e:410d:6657])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:99c5:b0:c29:555e:bf2 with SMTP id a640c23a62f3a-c2e23e0f1acmr372654166b.41.1790865012282;
 Thu, 01 Oct 2026 07:30:12 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:29:59 +0100
In-Reply-To: <20261001143000.3371786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001143000.3371786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001143000.3371786-4-vdonnefort@google.com>
Subject: [PATCH v5 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
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
and a list of arguments, such as RE_PRINTK("foo=%d bar=%d", foo, bar).
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
index 676e803dc144..78346ac77585 100644
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
+	REMOTE_EVENT(__name, __id, RE_STRUCT(__struct), "\"Unknown\"")
+
 #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

