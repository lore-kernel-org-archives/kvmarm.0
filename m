Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C6B28A1E8
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550146; cv=none; b=XODo6QTopqN/AullRnBYwVn3PJev4AljK+8Vyls6M/KLJ9aS/EPv8trdrDJ8AY+NGtMyLbZ6iGvynTaC7QY6onY5E0fZtEUrirC/DeRyNFCQ/cESKfFJ4t3OqKCcn3g/QIHi7oXvX/KMp+7GRELvzTEo6lCBSNWEy2v/YF241NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550146; c=relaxed/simple;
	bh=PgCe5Ig4Hz5VA3Et4j2ZYh+G8htR5m2rXa4V0St1e+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=caC3X62rXiHNodZUVmhDQ/E2CBeKOGpOJSZjeqI6JWQjeS0hPAE7zwfRZx7mqOQS40M9+tfKYu8oLR9UH/6yTmxTok1cuDgQhj4t5PyJgfvKT8uYPs6+PZDYhka9xoQM+unIbH08W4O1PTW6ph4zwkp5aaxHoTX3Z4d1Vw1YtBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwnAlyol; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwnAlyol"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so27641005e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550143; x=1747154943; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=njQ3TmZpiHbN0W0T2NSyLt6EnFI9+R+BtiPGKvCoesw=;
        b=cwnAlyolz/GG8+F2P4yTmlZIl8+5lA/FMpXeZgtATVtfG9BLAQf8q1cvGTh/jcwYyF
         yNIq4x/byUvEHjliMuD7n37LYD8W17XiBqAd0EhQsjPbN3ze1WWEsQQEfGllLa6BH/6M
         7VzRzofEJlZeis+P1PyDwb+Zk5SNCihq/r7jPo1DgRaP6CGQIYIlsm18Dw5qDPaEW+i/
         6Bvu4sEsK0rBH3q0vkUT1g3UNYYO+quOE5xe8vK4vuyOQmkBs3k/BtGHiiB/CU0T0XTk
         AEkTp8Jo4rCnn154NwRWp+UW0g2/RzutN28ey5Vp8lqF8FkZh6ZrEo8Ch+qg1Tpl908R
         b6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550143; x=1747154943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njQ3TmZpiHbN0W0T2NSyLt6EnFI9+R+BtiPGKvCoesw=;
        b=AOqV7VcNN+EVrg7HgJUlvkeRabTjIve8SaFwh0LBj43pnmDvMzt8/Vnd66DFKnsQfw
         ePhUpUSl2DDqzv+nrurrYd1sP0Clnkf1Mp3XjZqTKWJ/N9a/oSk/Xkkd5fsI1ub4Uv/b
         ac0wczr4OYFOyfTje60zm0zN//IBxSZYuzVz/k9ykrZEl2Cn1D44qZ3qS9/DTgKrrFDm
         rddGUMI7Y+amuy0TbgHEhUtgdRdr/pTfBovgnZf59PrZ+ToRQXfvwEOdZ5qrX3j3OZpU
         snDq/iBVuF6hA+7Cmx4HLdiEMuLymV2fZX6WWDHieb2TetKoKdhWME5T8ajG6tKcJ4w7
         2G+w==
X-Gm-Message-State: AOJu0YwChgdRQKEOym2O+6S8wOkHovQjWa+bPZw0dVJ+MeqFWZJjG+cb
	+vQTcMhykhtd+XFNacGb1IJzDBkSfbuydzTYVlxzS951h38wiwh1etcDjfPugxCh9YTf+XIPce0
	QY683iG6f9VMmCiK8hg==
X-Google-Smtp-Source: AGHT+IHF02PKPiIhJbOE1ndD3uShLpPGP1nAp1HVPAQRz98xV5Rm4WeCONHAOCoe603i2rkE7H3ckkLeK9deDeKS
X-Received: from wmbay12.prod.google.com ([2002:a05:600c:1e0c:b0:43d:1dd4:37f2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154a:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-441d0fcc750mr28382805e9.8.1746550143106;
 Tue, 06 May 2025 09:49:03 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:09 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-14-vdonnefort@google.com>
Subject: [PATCH v4 13/24] tracing: Check for undefined symbols in simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The simple_ring_buffer implementation must remain simple enough to be
used by the pKVM hypervisor. Prevent the object build if unresolved
symbols are found.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 8f5e194eba71..a2f1489e11af 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -114,4 +114,19 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
 obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
 obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 
+#
+# simple_ring_buffer is used by the pKVM hypervisor which does not have access
+# to all kernel symbols. Fail the build if forbidden symbols are found.
+#
+UNDEFINED_ALLOWLIST := alt_cb_patch_nops
+UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
+
+quiet_cmd_check_undefined = NM      $<
+      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+
+$(obj)/%.o.checked: $(obj)/%.o FORCE
+	$(call if_changed,check_undefined)
+
+always-$(CONFIG_SIMPLE_RING_BUFFER) +=  simple_ring_buffer.o.checked
+
 libftrace-y := ftrace.o
-- 
2.49.0.967.g6a0df3ecc3-goog

