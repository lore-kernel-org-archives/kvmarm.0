Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A2F2D3A7B
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957968; cv=none; b=jOIKFuqfRtTSMWs+CErXUmU88vrfBMdi+MvQrT2qHqUP262hVtf7QZU7jzrfQh9eVDet8bNNGcrRivSWsBH7d7IoJbd9ZxVYueQB2a6ct7q76xa5VzBIq3PA9AulpTLSS0asPbvxGv0BogzIpU0ZIjOLbbuN5LjtLutSgl1be1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957968; c=relaxed/simple;
	bh=Xjq+huymn2c342iWWiY1CbwR9+2osfFq6dqedGxHGtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tfNJU3vilE0z4CRYNA63vDGPzsYKUrXWh+EtoKTxTuuwx/AC88sp5WUvaQEHy0sOXpyHnlWo7n1tkLGyWL56kR216CB/hA0lNdBmABliOS215EMydOmU5YHe5OIu2ntyLLOZOffF31n3PKL7eIyAumP5W7k4LVal11JKOfbup1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b2UZXORm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b2UZXORm"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-745e89b0c32so1323988b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957966; x=1748562766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rhj01gCo8zRE4ihm7mjL7ntGfsdvBwkWydK82rp0ihs=;
        b=b2UZXORmJ1cXWwsABpWhYyAyrXSArkrQvzSOdpAFrn1Vln6CxerY+h8Wq9asEJYooM
         zkEvxG3qhxMtxyzELQnfeQJMOrBoNxk0Xaj4oM1Fb/kPhfMTirti6wQjnWJXOa87vl5k
         DWhMxkodGVBflQ+ebBUv+dJYBND/YIBdShrt92j6CQ03kABxpUGODTbUis29/Sr12I2X
         ZLe5TdQT0MiK6vkpS8isXGt3QdEl21f/gFw8Ys0ti3ctypY96RifSrwRCPnuaAufvmk3
         m+rvaCu+LKt1XteVbQs6qN1E7lBIF83f8+GyD3ueCbRiVrWAWgpl2KREfH2KMJM59myy
         ahnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957966; x=1748562766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhj01gCo8zRE4ihm7mjL7ntGfsdvBwkWydK82rp0ihs=;
        b=DSyVFnl7r9sTuGAlpAyG67JO2vnyCmLKM2xX5720/47+XyVeOkobW5yOINex68LF4W
         +9ZS6vXsJ56c3cDTB3t8pykId6GuUIQp8xurZRhIChZBHqAiyva3+GAo03FywKthc7m3
         z6A2s8RVo2I0IgphskaXrj+9EQmSOkx2AMS8V2PB3iIHKnhmQN7SdJ/ZcpC+uP2jimIW
         SXlNBdCpIYob7zRTOZO0hZQ/xLiNOp+eBkPUgdRVZS7nD53udMwbhErP1JvKRgGhrU38
         3zbyRtL16DRqb8AJ3Pr4vFQGfRP4+0a68WCTBPEhkLQvOjhRaIfcuDIpLybkCTz3qCaG
         E3DA==
X-Forwarded-Encrypted: i=1; AJvYcCVxDtAR3+I5rr1Cmk1d6kVAp5vYXSsaA7hjewJi3DccNgvO2ixKyE/6EA3eknC21AyqFqPpKR8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm4HzpOlGDB3e17qWYRFvh9uZaS4sQU2YgnWkAf0xBANoHz9Z0
	rzw2dRyKtwlWQEjn319qbzKss1eOTGReGDIBTPQCOEWmHfT4kJekgipmTo340JRCgzwDOxP39mr
	jbIeXgw==
X-Google-Smtp-Source: AGHT+IFcXQOzVhyYyYRvvhxCpwMSPB5FWKzf2e+esBNAhvIROXYgtUD8Jyc4OswUVSapVQEWgVgXYmNxl9c=
X-Received: from pfbhd3.prod.google.com ([2002:a05:6a00:6583:b0:742:a60b:3336])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8594:b0:740:9a42:a356
 with SMTP id d2e1a72fcca58-742acce36c5mr31613679b3a.11.1747957966116; Thu, 22
 May 2025 16:52:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:17 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-8-seanjc@google.com>
Subject: [PATCH v3 07/13] xen: privcmd: Don't mark eventfd waiter as EXCLUSIVE
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't set WQ_FLAG_EXCLUSIVE when adding an irqfd to a wait queue, as
irqfd_wakeup() unconditionally returns '0', i.e. doesn't actually operate
in exclusive mode.

Note, the use of WQ_FLAG_PRIORITY is also dubious, but that's a problem
for another day.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/xen/privcmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index c08ec8a7d27c..13a10f3294a8 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -957,7 +957,6 @@ irqfd_poll_func(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
 	struct privcmd_kernel_irqfd *kirqfd =
 		container_of(pt, struct privcmd_kernel_irqfd, pt);
 
-	kirqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &kirqfd->wait);
 }
 
-- 
2.49.0.1151.ga128411c76-goog

