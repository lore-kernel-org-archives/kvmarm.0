Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DA6175A89
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443039; cv=none; b=KV+7+c18W1ops8krGpKdWz0/qYr4R1AyUxQGlgckJ5nikdEff1mADo6VOBuERp1yLizFL0EY2CIfBTdoxe65NhZoRXN5fEjNmi3QMk+UxyNj0BEJuyfur1psoCHnNTMCsn8xxNh6Smb1pu9JME6F5IEdFiJHlJ3UiQse7oj3nig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443039; c=relaxed/simple;
	bh=9EoaKoyI2ilgny4ABrKThX57+lzKh3U5b3ticBDsZJw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e15XzwEhS14uq55bVEdGOcdsENuYWt4dCUnw3wllDyJHhqR0qMQozZtByAdQZFY776XdjwJQ+HDBSA+OrZFKPSYbyqjYdojqkPDEb0tGZfwvS0lGa45w0Mb1KD7Sk8EI45eh+yTYsWArIAuKw0RCf4CQ+VKLAPUd79ZfYVtTeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tt9/ykFn; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tt9/ykFn"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c158e733fd6so193649966b.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jul 2026 09:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783443036; x=1784047836; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X4tE949qRBkC4yYjzPjGurt/S8AoL1L3JbunAkJmp2w=;
        b=tt9/ykFn9QqCNlOPKVCPDd7+h9H3pV/F+bfYJW4AJGbriZgVrEkW6OXZLdzUyFlI3q
         xsnmYQzYxrWd7+YtI/s30Kecn9FwEqEEI77eE46fNshwdBum81d61ckUcgVbFBIh55qt
         eqKF3njHwm6K4uKuahWqsWVuchEw0hxrbOqEw6xOA0OTcG6TYON1c16ARzqmd+T7MQwh
         7Q23VurpsYDuHR3cHHb6R5NGyl3IkOIT4zo4mWaqOt2DFO4FRN1cdBUexvlZMa8M5UcR
         gBd8Eln2Mn+TLgYAb77+jhlUlFCr1MY/ZIUesSk+144p+eRQfRMsq9l44MysxoF5Uvyw
         /Opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783443036; x=1784047836;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4tE949qRBkC4yYjzPjGurt/S8AoL1L3JbunAkJmp2w=;
        b=g7SCtPht/LcetmHxk9jR+4I5qlzFB9tFMLS4hytQaqjIJbhBrsV/K18wOD17cHfdUi
         oFnR9Z/gdctLREXdjsG+BBUUEKyU0i61HUVZyt4FLw/ZBM4JdpY1GP3l8tdLinE4GCcl
         d5pf5VZLpdVcpH+iF4GkLpnj23XmNVZtL1utBxOdEcQVfSB9ZzkWcyzHuEGX+hPmiX4J
         nCxKCRlF/HDyDuNGQnPjVSzASTMgn+0HwbuLHHeL9GNdnEmlsWjq5OpNKprjEmxnR/b+
         C9SbNhfwNuoe2qMYQOBbMghiACAOAyH25TBkAX5VOXCgw/JrDsASETFXcNFdqt3pYwGK
         upKQ==
X-Forwarded-Encrypted: i=1; AHgh+RqxP7nESTaBsAHFyQAGxsjFI/AWWPgbnmxAfi6FJAr1qt6y+f/dZu/6A97IuCy7sD4PyVXN0t0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwDXI+rnYVBoqw6YNsuNd26rt+j5DEpjn2D8cwyac7f4eMnDOK
	gyzHIDhXwcml/hl0l9e5TS60RGW/IXo0enJ2Pw3KTdCDp6V3683ROenwWgajzqQmtqyE9fdd0+R
	iA9ACli702h36FVgKfgerOA==
X-Received: from ejed19.prod.google.com ([2002:a17:906:1753:b0:c12:7900:90b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e8b:b0:c15:abe2:e1df with SMTP id a640c23a62f3a-c15abe2f250mr283675666b.43.1783443036203;
 Tue, 07 Jul 2026 09:50:36 -0700 (PDT)
Date: Tue,  7 Jul 2026 17:50:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707165029.3410701-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

In the very unlikely event of a failure in __map_hyp, the allocated
backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
this by freeing the pages on error.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..5fbbfd40376f 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	size_t backing_size;
 	void *start;
+	int ret;
 
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
@@ -171,7 +172,11 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
 	trace_buffer->desc->bpages_backing_size = backing_size;
 
-	return __map_hyp(start, backing_size);
+	ret = __map_hyp(start, backing_size);
+	if (ret)
+		free_pages_exact(start, backing_size);
+
+	return ret;
 }
 
 static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)

base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

