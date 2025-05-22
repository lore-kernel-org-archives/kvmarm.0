Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB102D1F55
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957960; cv=none; b=mo1JkWdc0dwaK3eZPCaIqu8toRORQWQKMwC5sGS56/DfRdx0smJXUsCk6vcptydQVXwGGO+DToeaxCygif2wSuf3WOXxsJqc6vh1wiW+AlVBx0BOQIwqyf1s5g7M6w9tM5Ux/Jy9dwtr/04/DZm/EVz2drywUG7t88qD2gk/0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957960; c=relaxed/simple;
	bh=FDCJRuUBom6tgSithRuLUJxsTxJG1RjcxbgGSLyCb6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mpTAW4wdXJmlmV1lYXSPNm3P3+eQSY7OExfvBEAn6F2uv/sW1YI6fv7xEFgBdmS8N7c16PMooO2FiFC+8bgptTKpPaRBaFvah0wjdMJ3CY70T06Fs2Mfi7fZIOdDrpWAg1DH7zHL4GVrixxOb2A5Le8d4pnraOorJTPcoJawT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EscQk21R; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EscQk21R"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ebfc28a1eso8055834a91.2
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957958; x=1748562758; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tVNl4A6Kx8naMJGZ1E0eQITkQbAsVFllM1f24lX+kzQ=;
        b=EscQk21RtevGDNS6XIKlDL/4Cdcwm93NhS0c1LSRth6d9j6EjG0FTcY8yvu83C2Pq9
         sq09UhUS3nsaH3Uye07gNjmwGyAswLFqya+ncXQ8J1bBOJHKj2HIt7Ei8tCzjd9OueHM
         XOkh4WiHV2eDbtB+wGTNlBantsiRWXaTPp6MDjlF8GNtQ2bFsX5OAVE54663XJR4YayP
         7IF5IFnYWgbnQRc6quYDTg1ndaE9njUUGJLd0Ys0LwUttBlozTA0/GzI3+35eEjtzMUE
         N1dvgBWM9BJpekIwJOJsa+2TmfKxHDxOjYaxeDGm0vHivA/DUvIqed5+6XGItOCaviKl
         sOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957958; x=1748562758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tVNl4A6Kx8naMJGZ1E0eQITkQbAsVFllM1f24lX+kzQ=;
        b=kPu0vMaQQyaKV7x0/DJHJa0hoE1dIsbTcdaIS5s33sMOzWN2Spp/0lUgEkww49nXGp
         s4tGA/yhZmnVv+o73qnqgTGFPuF48AonveO/l0jZLA5a0NMGGFg9Jn07c9O1pQGmKiUk
         c8x6/7mk44cMdb8P2lVM2noEOmaYnKFqXRgseesVjOgGVpNTlfKwsh89HdgilwGZeuGd
         dRENTZUYtYf7tCD+mEjP8hOCxI7YGoK8rcsAkQ0j3HlLwr/ia62gbLqtJI3XpJmReXYD
         l0a5qe2cjkrBYe1r1htVg1j254U3WxX0xC7dghb/qLhBMJ91FiHemwofDCbHDAFZGyvH
         pyWg==
X-Forwarded-Encrypted: i=1; AJvYcCXiFCfhdb+NvfObJFHEeQaVKBfQlmBTfFL3ABNPENaEZU9Ln06icq7qoMIAByr5+kMuvq8DSK4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyooqvlT9OQhOR7NUzcBL9ppilxjSC9ADIkvfq609JIKRBsvx9J
	Yvc6SsEncHY+qheXn3uMmL4pa7BN9DwIgfMOWm2MhLb2LHmxv9xwdvgCktXFImaKPtLMB/DU9aG
	fprS/KQ==
X-Google-Smtp-Source: AGHT+IE81WM2WL+8EnB/6FCP5IRyDnOFUDXq+HJraLf558ghdMXYLyDo9m5RHDzKNMgflX319IgqoMhIQGU=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70f:b0:30a:2173:9f0b
 with SMTP id 98e67ed59e1d1-30e8322596bmr38028577a91.28.1747957957818; Thu, 22
 May 2025 16:52:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:12 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-3-seanjc@google.com>
Subject: [PATCH v3 02/13] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
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

Acquire SRCU outside of irqfds.lock so that the locking is symmetrical,
and add a comment explaining why on earth KVM holds SRCU for so long.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 39e42b19d9f7..42c02c35e542 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -401,6 +401,18 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Set the irqfd routing and add it to KVM's list before registering
+	 * the irqfd with the eventfd, so that the routing information is valid
+	 * and stays valid, e.g. if there are GSI routing changes, prior to
+	 * making the irqfd visible, i.e. before it might be signaled.
+	 *
+	 * Note, holding SRCU ensures a stable read of routing information, and
+	 * also prevents irqfd_shutdown() from freeing the irqfd before it's
+	 * fully initialized.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -409,11 +421,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		goto fail;
+		goto fail_duplicate;
 	}
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
 	irqfd_update(kvm, irqfd);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -449,6 +459,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
+fail_duplicate:
+	spin_unlock_irq(&kvm->irqfds.lock);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
-- 
2.49.0.1151.ga128411c76-goog

