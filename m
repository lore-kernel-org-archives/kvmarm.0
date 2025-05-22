Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF82D1F7B
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957961; cv=none; b=dHNWQC5TO+Lmo78onRsa42SSh4+5dwDKLrq2XqWLlbv5NKzp6OYNnJ+OibhPT1xKSZ2HpSz4iD1j5jd+1urDiaf9KFutcAdMHnltxnWt2csj996fbIBM57tQYJvHjWrywB6LbgoxonhUVhHnB7SDpLy1ZoUxd5TmAcViBfXFbR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957961; c=relaxed/simple;
	bh=p0PPeyoesUCt5v+rFyNj8jJ5WSx3eI7L2/HQ4wMbmx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Py/i61MASxp0eWnWPc3ghcjRR5pTPSFYR3ETiKmuqTqrFOsSO6HW486s2pDQqbP5l7G6GpsVS9sCZBefCCNnsBK5cIRSezA0qdIAWRo2xH+ie0LmPcyuL1DpemHqTGPbqmX9mGOJb2FB+vEa9IA3EQDaVTfr/2Ubub8vCmtvr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A+iqIB2+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+iqIB2+"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e38174e5so8375865a12.1
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957959; x=1748562759; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xAZka5nPnl0zzhBog63136UQG1pDC/RMIYFF12/LKjA=;
        b=A+iqIB2+ms1XGczp2figCb5bQOPC01U9+Ezh90cH8jyU/GebFJC55gNPYoNTNId2YW
         4hERZq+89PKRyZy6l1YsVTFgGYhoVnlqxxiI/yhRl14KMKFAGWxB0VodmUJxm5UJZpXK
         +6sNPfLkBIul+al76DO4I970xHAUHrMyeUWehmCGB9XYcbS2ij1Yy3WhBbqL6ShUicaV
         8+OZcSdCuD4IcEB636JZsEdKuo5VUDI7HMDrS4nWjjT3P8Biw/hwf2EppB7p6MILlCud
         qDwzwW0c6IAChVsf1f4eHuWwE2g9wIkNvEw2nDEqZ7u55jfMCey17FWruhT6xC30qO0e
         ylyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957959; x=1748562759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAZka5nPnl0zzhBog63136UQG1pDC/RMIYFF12/LKjA=;
        b=HtuE0sl/kUh2xFw4hd5cnkeBTigJ/6H4CI4VbRN9EedGOYdgcJb4q5cTW4J1zeznPm
         RItN5LGM4EIhc+BfqSJH5UbadZeGbQ81H9lfkbPqmkEHwQ/33LaQ5Oz2ZENKvlcujOWG
         WGoIUQOD0rbCsyh0uCttQSrA+rWjnN4ty4avw/NgUYh1hK949Fp8fSG5qk4+e7Op3+Wd
         6ejo0KmYqsSZrcf1L5TucF242fGCRVQyb1CPnHpw+QsIRM8TOb/lguOn+dvEMheNhNlC
         yA1W1+8IcApieouGch9cQrgpkVf9RSpx1IoCP8+urqjRzWQTHMdnTdVtPGDnwCIiNAoF
         WJLA==
X-Forwarded-Encrypted: i=1; AJvYcCU7JU7Iab9RZxopAFMHDtryM1dHbl3+2aqR7xClajKTWacCGjnMFH7N6HVlVSdgAlYXSTAveNc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLw3d/ukfeGuTuKLx2DZkNAtSOvpHn67H3N1AV37IrDZ8yA8Wo
	UnLZAYGFaQ475uNqOgckWaGoruhj9UzqOtcLCBh9wRylCiRMp+2mOoIqNXeQ/HyW75+sod8dl6Y
	QFUskaQ==
X-Google-Smtp-Source: AGHT+IFTlML74x7TQE+fmnLc60J6Zc3gXJFbZA8aAHEiRQLh+dPZA/uq2RIsrb3gSzl5/rJlFLqbanul+U8=
X-Received: from pja13.prod.google.com ([2002:a17:90b:548d:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cb:b0:2ee:fa0c:cebc
 with SMTP id 98e67ed59e1d1-310e96e87e5mr1351003a91.20.1747957959540; Thu, 22
 May 2025 16:52:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:13 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-4-seanjc@google.com>
Subject: [PATCH v3 03/13] KVM: Initialize irqfd waitqueue callback when adding
 to the queue
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

Initialize the irqfd waitqueue callback immediately prior to inserting the
irqfd into the eventfd's waitqueue.  Pre-initializing the state in a
completely different context is all kinds of confusing, and incorrectly
suggests that the waitqueue function needs to be initialize prior to
vfs_poll().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 42c02c35e542..8b9a87daa2bb 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -256,6 +256,13 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
 
+	/*
+	 * Add the irqfd as a priority waiter on the eventfd, with a custom
+	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
+	 * underlying eventfd is signaled.
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -395,12 +402,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		mutex_unlock(&kvm->irqfds.resampler_lock);
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-
 	/*
 	 * Set the irqfd routing and add it to KVM's list before registering
 	 * the irqfd with the eventfd, so that the routing information is valid
-- 
2.49.0.1151.ga128411c76-goog

