Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492E051AEDD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064007; cv=none; b=GO2MYUNF00KryVSOH3HRKhY8mDgy/p0siJeldH43uk3OT9Xfq2BiclDAlplNSTFbd728bZhE9iboyVfJ4e6aNT1BCELtOmTAc9w0MRPNRGx3FBOvUhspo3HNxSUpnkLCM64w7hb0DPrG9cIkHIDI/a9aTUfguX/QB2jPrgIyNng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064007; c=relaxed/simple;
	bh=fgA/DOzOgyFrie7kteFJYTL3C5kdV1edAhl0ExNfxMo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cj2qzBmMXOnpuvkHnp3YiHrJ/IAw0h8t81i0SKqLhsFmqF/c/JWXCBI0vUQGbXnhMPUBaKpSAj9arZsu3VlgSTupNpbL/sXBOdDufREjYlWyBgwFIaMVKgHUqZoT4BtntgN1gmVcH1SQFa/qT0xTrgkSsmDI0SwR9BAjGvOHLeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XmaifPs8; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XmaifPs8"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49febef74e3so56122345e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792063998; x=1792668798; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=34I5YMYZwWqkMn99f1ZPfTg1ZL3IhEhk5unHI1E/+wY=;
        b=XmaifPs8aTu/kx0hkJRkWM3yUXFvFxyRNlyY+n7JFyz1c10ZkI7jexWN8YYHcEhr/A
         bJ6dk/zYQ9+Imbcn6+Jh/DVYP85L3CNOSanFrEs9TZ3F2MVFsLJ57BRpTaDSuQU4ottv
         JOXom0iUoTcS1kJTzSvb0/6VDyfGFiYh3hJoZCJ6Gz41Y9hYxi8/6Yo9mhahJgiDlX6m
         DBegkLj5m6ydBDtovYWukELpGpV4bfwZpeFPRyXissl0bbfJMwd3Ok98FZw6nALWb+1A
         YvLyZXr0vZh5G+kSZmn44xUVmSJtI5tJ78WmJ4PpCeTN9fhrR180slG4npj4n192l5JU
         ZtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063998; x=1792668798;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=34I5YMYZwWqkMn99f1ZPfTg1ZL3IhEhk5unHI1E/+wY=;
        b=gn2QR2KSfCqyjO56arOuzQdgkfztQyb9N3IMzjEXSYGnnRlbvNz3JVoDgqg6LLcoVz
         tUHEvhDAmebjsTizdHM/cYT6OYXkv1BBpNG8CO7P3Un43zb44GGYN+yGnJ/GpkIgw8jO
         zOK2gN5MlkqdqBuhlo3ClokZ5h+unfZfQ7hYIRWtD1L+lnzVciqfaF/KlRi3sKRk3NTQ
         5CiuZHaxebELkvVdmlh1g0es2NiFlLZ3zWH49PmQhpJtXLrqUx4M7//ockpbObWx0sXY
         yqXShgOuej2pEkf/BeOCeq5Re7/EAZbjIzR3AKOk2BVU17cHV5EzQF9WwcAJi0mwUVkE
         K42Q==
X-Forwarded-Encrypted: i=1; AKwUvBx8AQZp4I6NDumIqNFUbY6EhccfjtVF7C4d5e7YQe8E8TtdQbOX9FFFTGnA2PWNLLpnzQCDXYc=@lists.linux.dev
X-Gm-Message-State: AFq9FYLOjkhiwGS3ceDnASjUmmpIypUa5AhviuoAouGg6C+Hr4acv/cp
	giapf8JlZVb0uN8ayFj+5zRfw7LYJy7RQApzYKcGEtpET+zk10nmnrLy71AX/BxmjfHXaEvJ8Ln
	CcgDLvqcoGO1aCd4U0NH9qg==
X-Received: from wmbjq7.prod.google.com ([2002:a05:600c:55c7:b0:4a1:939b:a0c5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83cf:b0:4a1:ac66:604b with SMTP id 5b1f17b1804b1-4a1ac666a65mr165997135e9.1.1792063998106;
 Thu, 15 Oct 2026 04:33:18 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:28:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015112814.332084-1-vdonnefort@google.com>
Subject: [PATCH v1] tracing/remotes: Fix TRACE_REMOTE build when TRACING=n
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org
Cc: mathieu.desnoyers@efficios.com, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

TRACE_REMOTE relies on tracefs, eventfs and ring-buffer which are only
built and declared when TRACING is enabled. It is however possible for a
config to have FTRACE=y TRACING=n and TRACE_REMOTE=y.

To fix this configuration, have TRACE_REMOTE select TRACING directly,
just like other FTRACE options do and drop the TRACING dependency from
NVHE_EL2_TRACING to avoid a circular Kconfig dependency.

Cc: stable@vger.kernel.org
Fixes: ea908a2b79c8 ("tracing: Add a trace remote module for testing")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610142301.GBepPVmS-lkp@intel.com/
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/Kconfig | 2 +-
 kernel/trace/Kconfig   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..e179b8ad79e8 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -74,7 +74,7 @@ if NVHE_EL2_DEBUG
 
 config NVHE_EL2_TRACING
 	bool
-	depends on TRACING && FTRACE
+	depends on FTRACE
 	select TRACE_REMOTE
 	default y
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 0ab5916575a9..6587450cfcd1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1329,6 +1329,7 @@ source "kernel/trace/rv/Kconfig"
 
 config TRACE_REMOTE
 	bool
+	select TRACING
 
 config SIMPLE_RING_BUFFER
 	bool

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.56.0.385.gd3acb90ef8-goog

