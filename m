Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C73CE4B2
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807788; cv=none; b=UUAIpEYnztMjVlnjJmmTuVfihXQk4xx7Pf7COB7uy2ZXHT/ITPBcTcCKBXZwoXMcsgFy9+8YDPn5Eev0WSf2faRjXB8Xa4mxWAGDoCLmr70AxR06RwS2bSEhLNmrdjx7pTcs0pqGJRiVaQJcueUvWcAPEObzgx5RrNGXo4AMKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807788; c=relaxed/simple;
	bh=ObgOCDMC85s7Bm+uCQyKTE82mofMGHWimv4+K5Z7ga8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jp3CAzaltXfz3vmwObS+SkUs0gyfo+XqMhuCoaVnOUt+FTyQNBfB9IInKr/jr6DhOyGiVajWDXmSkbIqJWw+kllA17Vo5akG4iFp4gwh/jC6lOuJ+f9gAvf3dEg6+PCRjmgUoiaIUxPxppLIugwQfGWOSE9SlUTAOxLsT+W+ha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3mvRl+k; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3mvRl+k"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837907ec88so102589605e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807786; x=1773412586; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fixqNHIgRdsXrQKd6GcjLA4m1QZ0grB448V81HUxHL8=;
        b=y3mvRl+kb1rOVdKsf+ilRmeaivr7RHrwZiJJ6GgsqZNkANmdIX30V73PRJGim1rt1e
         qTg6mD0sT01Vk0gug+IF6iSZmQ/saP9UnSqvxpo2aJ7CMZT1iOdZzjhhPAsDRGIT0XQd
         Sp7Ozmxk95rRJx0h7PIJN5I/lmklWbFuqa1ATUa5LAmnWHMS7XCWBsvLVipKYs4TkPqB
         Xj1aolRY+SSUNGDbo0OCehKcb52xTMcAsyrWSXOWy9jN1uxlhy7StwX23FgG8w5q22+b
         I6XCXQ7/76x8FHw8PgSh2Zlsmv+ZqtHEtdeoH4wt4pACgNbl6t9HQbgqRCa+kLMw7N5+
         9RhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807786; x=1773412586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fixqNHIgRdsXrQKd6GcjLA4m1QZ0grB448V81HUxHL8=;
        b=GkHtPiTJgjDHPtwIIKz6oz6q/kiJmHWoY7AA7bphn/n+12Y5YEwxYksiVLKuwI+hot
         eSj8S4kxFDQAzbE8f2eqkFcdyKc7qSafMvvtLDRMwNqVXOswrS3eWfTaLChxrtikjtgq
         B/27NRJUVz1aYkzVKBumLVdnSBnzCT41GocXq/bwvkv7cmUbJ2z/XCp+9L5kLHo0n+3j
         xrJEl6U7bfcciZrFtYnKIiDky0LECWVpQ7VER7BdbDfgVJkGKPllx3yCeR2KqCaLKp5b
         c42igwQU1tyHQBZ6ytouvFvxOzNGW0Goy7ifsFN591XODiieHFnxEzDHgING1olJqRns
         ZsWg==
X-Gm-Message-State: AOJu0Yz+qXlPaZOkMUu2NpI46sHmhcIOniHdDVKWMwLguOqrl7IcnoDK
	+6yg7UGkG/uvGoWjVVLwpeEtg6Pv+Pb9H7omZS8HG41Qdo33ykBBmQRxeOa4Pd8jJ3vsXSYQ8nU
	C2Ce+bo6rQfqXWtz9oJ2BMA==
X-Received: from wmet19.prod.google.com ([2002:a05:600c:2ad3:b0:47f:c96e:8381])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1551:b0:483:43d8:8d68 with SMTP id 5b1f17b1804b1-48526967b79mr40105665e9.28.1772807785798;
 Fri, 06 Mar 2026 06:36:25 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:36 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-33-vdonnefort@google.com>
Subject: [PATCH v13 32/32] fixup! tracing: Add a trace remote module for testing
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
index 791128d7fd00..6c1b7701ddae 100644
--- a/kernel/trace/remote_test.c
+++ b/kernel/trace/remote_test.c
@@ -28,11 +28,11 @@ static int remote_test_load_simple_rb(int cpu, struct ring_buffer_desc *rb_desc)
 	struct simple_buffer_page *bpages;
 	int ret = -ENOMEM;
 
-	cpu_buffer = kzalloc_obj(*cpu_buffer);
+	cpu_buffer = kmalloc_obj(*cpu_buffer);
 	if (!cpu_buffer)
 		return ret;
 
-	bpages = kmalloc_array(rb_desc->nr_page_va, sizeof(*bpages), GFP_KERNEL);
+	bpages = kmalloc_objs(*bpages, rb_desc->nr_page_va);
 	if (!bpages)
 		goto err_free_cpu_buffer;
 
-- 
2.53.0.473.g4a7958ca14-goog

