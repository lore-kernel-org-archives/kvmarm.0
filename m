Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCAE3CE481
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807788; cv=none; b=POfMqJSgn6SHL/HSlr9OsF1uh9PthYPLLZOFHbl9JzepNRDpfcejkFenfnSaVG4HvsV2uK+F56FwNpwQU1F3sxO5nbYUk8uLiNBeRrbUZX+4vsb/JnlwCe6WNCalICYMyR+elfx5IAkoBmKVM9WMj5m0o/XtK0CldSg+paHTQFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807788; c=relaxed/simple;
	bh=ea93niBYI+Rj/6YycglV0K0bDZBQ2z3tLiTBTzWOxio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OGQSCbUmhHEshJshoCH3DM3Mp+NoQeI7I2W1bRR9fOnKPo8kQ7hlJ8OTyUhKvvKdPZj07Rc4aiGG10trcOe+zpy1kezAyWH76ojz3uxRiwcufQUxE/Ig8aUwdVVdLbmPk7dtkd/3q8sNz6P9iTe31Xw4hNfeOPTKgmkoRdbKwSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZI5DBV9Z; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZI5DBV9Z"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8fbe7a6f41so817515766b.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807785; x=1773412585; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nAzsYfyBwss8qjbiN9KhoiGNV9RHrAQ+UoLBq6ZtFBA=;
        b=ZI5DBV9ZYl7iHY4h8slcbfDj0nHSGPDQZahEQNUT2uN14033CbycQUmUWPytHXEPgs
         gEU0+VcgTiSylxT4KvpgtdNHHnpo7Ew+/pADzhsaPmE/2O4xLH78W5129LPl64nSnOKq
         FdutUDPIFeCZdYKuKOlLxA6dtFoNodlEqNG7VXRvAMorc4BCWYCAqe4YbWtBDbqdyFje
         6B5TqZY+NseBik2BcwNrUoDmuNI+bRH+ggbRR/JQRulSimWMcLXSxllwrS8PODcxDDL8
         JwnU+GQdnUoNBf+NXZcklMbSybYk3NNhGrRee4oCqJ89+tq2WR7SK5gmG1Fj4h1CWdL2
         GeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807785; x=1773412585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nAzsYfyBwss8qjbiN9KhoiGNV9RHrAQ+UoLBq6ZtFBA=;
        b=L3d5KyDUxIuQPJKLCfLv/iLDcJFrCNV5qIeT2AaW3Hz8AFfaDdbEvkJSgm76KZyanw
         +OEFZ3G4w4T45vWdS5a7NHpRLYzQqu2WeyDh7MHiZr4DkZ3LxtuyiYzkYSDUgViLxMQ/
         ImZLVv85/l0sCwUcn5I/IETJfiIRXYWJQlJQ/HnRUfBOCyxW5uWQjO09xN6m/wMjq+8b
         upKuuklgiwpBWlqhOkUkT3xL84vV++46rHEdQksOsmmrXUJOjWHhWBGUS1OwXzYBP2GM
         I5bo48VR72T0K4K8arJt2NvHaCdca5NlYmANkDpHO30/3b3xloupfs1rHP9HlT+ml5Is
         5QXA==
X-Gm-Message-State: AOJu0YzcilqVEP6uJCWfXGMwpRr5jD9dO+JH9UQm48P0EE1js5zA3pUA
	iiUD0UqPhjOY2rx1q8IvP60nxi2K5k1m6yvhEItO0IsdM+XfK35ZYbGg5lq9gc5hUKA8LBx+44y
	W6h57pEwg+FoErV4iEIlgzw==
X-Received: from edge19-n1.prod.google.com ([2002:a05:6402:a553:10b0:65a:1fe2:dacc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:944b:b0:b93:56a4:d6b8 with SMTP id a640c23a62f3a-b942e15531cmr137153666b.50.1772807784377;
 Fri, 06 Mar 2026 06:36:24 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:35 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-32-vdonnefort@google.com>
Subject: [PATCH v13 31/32] fixup! tracing: Add a trace remote module for testing
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"


diff --git a/kernel/trace/remote_test.c b/kernel/trace/remote_test.c
index e5023b9d2611..791128d7fd00 100644
--- a/kernel/trace/remote_test.c
+++ b/kernel/trace/remote_test.c
@@ -28,7 +28,7 @@ static int remote_test_load_simple_rb(int cpu, struct ring_buffer_desc *rb_desc)
 	struct simple_buffer_page *bpages;
 	int ret = -ENOMEM;
 
-	cpu_buffer = kmalloc(sizeof(*cpu_buffer), GFP_KERNEL);
+	cpu_buffer = kzalloc_obj(*cpu_buffer);
 	if (!cpu_buffer)
 		return ret;
 
-- 
2.53.0.473.g4a7958ca14-goog

