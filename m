Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8239BFF8
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773315357; cv=none; b=SAnws1Vtnm//KAs6A30WtpDcG6XJH6Iwfxl8vhgEbf6PPz/Vov8kjAinZaDJzbtUNyhlUtzKySdusb0hFM9aS4zPfEMooa9Esp063f2+JdxRfD6eVAjepdUqpAOo60VGf7GnECuuyCasfgYFv7Gx5AlRkhhLzy1kqvOK3IC75WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773315357; c=relaxed/simple;
	bh=luIBTGBBRJ67RNao0BWmDsf9r0yENl8hSkn4XXKgohc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IIUfJFGYDgd0g+gRCLdRLrcIfBd6KGDuUCptY3Br6/eCvL4lXDRZ7CD3WmLRhpcGXqnqdKyWwdyJc9sc46IVTkVFkubCrkLgABo+2I9xLuovvASadiCfiS52l/Ct6LD/TzyoqiZdr5muIx4okO8RuieDawU5qsPAOyeXGf45hfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YVc1JofT; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YVc1JofT"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439a9182148so597507f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 04:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773315355; x=1773920155; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MQysXvwEtyjr/4QwzwV58b1FSM2E3DJvALB+KxzJwQ4=;
        b=YVc1JofTTijJgI3q5hXXEAN0ASIk9uWmhoYGvYPn/4K0Ge23MDot0nD8B74IccvfOI
         m8E91l6UGqn7mJEm4oc1F+rvZmsP9AIHn4xvSRhKOJYBvjcrjhpqKyEA0kfquxUP1Ww9
         Pp/wSM8x6kYv0esDIE/OSCOKfRsvwIaS9QZAWQS35hfca7+1M3f2Ph5dj6ams1Imi8fl
         KG6/LHi3nXlbgvPFw491ML+lZD18eMTq6cyuCY2SQo/KcBN3freU3+cml9fvuSObybV1
         OGSPE2l37MzRSoDPH+7jWsrZanWRsPXvJxNkSMOcKME4Gwl1AZ5MJ/JXfB1XkqYiGvoX
         Rssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773315355; x=1773920155;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQysXvwEtyjr/4QwzwV58b1FSM2E3DJvALB+KxzJwQ4=;
        b=q8HPdzhlNaZBlFaTkF2j4+JY5T8335JVjJ2g7ewVF9RJ94xpjVqxBuvWXDDTVjXQMB
         Z/sW6IO2PexgKjZzyIar2IpVUOu8dvE5N4cF+sV9gechmXBlpkKsASPxdgs/g5OzBVjy
         0807UtRGFqsZjwLGk876kcUhcj6Rb53penYfKMUB/TW8LyQyXAqCYxRUhNrTtObrsz2Z
         XtPznMiC2WPVVlktqqIoQ0YseEIgFqGt50Iw7uz2ZqU7K0W3FsGw0gHmV8Wyy5vm+NLv
         tqSO00ZXzvQlJJjRSVh3sf5L0nBhFm1HOw25gjTEsHtxEQvXZDQ6hNxpM9PqFVMzqKrq
         BNSA==
X-Forwarded-Encrypted: i=1; AJvYcCWjgZwlFh1LfmVtxalGvcVD7p6K9a6b2Lzf5Strs+FuUZraG2ufFpkbEdYqSzEHqmv1PleAXw4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP0LNzQQ0djxViaZVu/Cz36FTRlH26vSckkVAIo3tRlB779NNy
	0nHAW3NHp6KSOuoLzvtlurNZoCGKDw4VEVtwldg4MyKA0hmH7TGW0lbrF6I1wwnAKNkdVIzOFvc
	WfLGD2tCHDrcKy8mzUQX4Hw==
X-Received: from wrbfr9.prod.google.com ([2002:a05:6000:2a89:b0:439:ddbd:5bdc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:250e:b0:439:b629:42d7 with SMTP id ffacd0b85a97d-439f822bd11mr11329258f8f.46.1773315354685;
 Thu, 12 Mar 2026 04:35:54 -0700 (PDT)
Date: Thu, 12 Mar 2026 11:35:35 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260312113535.2213350-1-vdonnefort@google.com>
Subject: [PATCH] tracing: Update undefined symbols allow list for simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org
Cc: rostedt@goodmis.org, linux-trace-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Undefined symbols are not allowed for simple_ring_buffer.c. But some
compiler emitted symbols are missing in the allowlist. Update it.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 3182e1bc1cf7..3cc490aadc99 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -137,7 +137,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 # to all kernel symbols. Fail the build if forbidden symbols are found.
 #
 UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
-UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer llvm_gcda llvm_gcov
+UNDEFINED_ALLOWLIST += .TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
 UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
 
 quiet_cmd_check_undefined = NM      $<

base-commit: 455baa581922086f1ad44c76d4a3b03c265ee950
-- 
2.53.0.851.ga537e3e6e9-goog

