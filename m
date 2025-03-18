Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF76211462
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315137; cv=none; b=hSl2HNIYVltyS82SCu/YqKo/JBIMgCr+IsxybwMcSaLwjCzlbNbYQ6zLT1i8K7BFPs25YVRyW3nHUi7S8CKriZQVLZ4pJ3V+feJD0hMPyTbyCUA4cUpWoAkMezHTmBmTf6ktBFj6oPs66PwCvN1ZOUG93iwF/J2jdUALO4MyOZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315137; c=relaxed/simple;
	bh=J1w3wfRE32zhiryslT+guZ7VzCeopgfRWQrYjFcSKwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQhKcWqBIJv3AoQxy5WMDDy/4UTFTi3vqaOLy3U2HBAXXuYqPp/27wDNO58B3/Ur27oeWCT+vFSIrqEJ8V6VTpGvQwYwpZMrofVMPysg5VmRSBpn/u6G3VrJtlJLWlz54j6U3/PzQftE9I/TPbMmMVEzOq1CWHr/ZExOYsl+QTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ps3S16QE; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ps3S16QE"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cec217977so24352125e9.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 09:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742315132; x=1742919932; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=82xqydvgKJEdTD6AS9zEoISi5ga6dIOMUMPwBL0TAWM=;
        b=Ps3S16QE/rLTq+3dqRw/SbUxbjqdB0Iq0+KIFUbSVRoGE5NOz0JMzex4CqBKmThidd
         0F+sBMg64EIdXmhRONncuJjroq72ELkeo09D4gqYeMeXHjtEN2XcYpFUqobGowBcXbWA
         G594D0UTZYhkEqO0MZuWmQmLRs5Y57nvC48417p98bywIjwGQSFZijeJ9yA6NEhAc52J
         I2vYYMNr4/6YDnt7rC+U3QrbXhCQvasFCYSMUGB0g6qM0+fn5sBZFhPSbHnXBUB/tPcB
         cx/pIs47QlEz3ZqQcVZkQaFmleOdO5BrGXzRY/qLcHFQ7t0OZpcRS4RoHEd+NKWvHoxV
         Q1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742315132; x=1742919932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82xqydvgKJEdTD6AS9zEoISi5ga6dIOMUMPwBL0TAWM=;
        b=HoFTyq5tNyZmHrCitREIQFvwWDdO0BF+rKDcCzUyHlzfDwTS5bV3dDrq8HEG9AMMkE
         DvkMk2sRWBmTmFIYyO+Wv6i8M8HlFYdYWU75WbZtD9NVkgjNCtK58zOjOa9QFAY/xhx9
         Lpy3tpZ/eimiexBl7TZnsWPrKj8mrs6AsmwddAlyOv8wusU6y9z/U10ktwtExJDzf3wf
         kTu34468uu2iVrJy/rZpL/tld9CjZros/RRv2BmpmsEnmn8VrVbHU4e4mwGowXrAOghK
         NQhJ5uNUi3UVx+CG6MHevnAW/TDegcMxdU9Fh73/HOlwAwIl5e/NVBLsL0Qq4505Bpyw
         4AqQ==
X-Gm-Message-State: AOJu0YziTXTOZNET1MfOu2DHOWx+AUL+RZSSOSkCHTDXm1HdsuAaESCa
	tiNK5HXhDpjax+gHvwi5eG55wnXZ0+zXTiqB43KX+See77ebnukyJT/PNBh4owRRCC+9H5C+3tm
	hKrF0nd3kOJ4WIuuUl1JpBd4AMg==
X-Google-Smtp-Source: AGHT+IFqbXkqs2Mp4b7p4DEZXKXsbkJMcBqeeMGJEs4JUgbYXZRQtxNivjVbKfH+2JB9M7Bhly80ZxRnTmUFvY4cw9c=
X-Received: from wmco3.prod.google.com ([2002:a05:600c:a303:b0:43c:eb09:3784])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c02:b0:43c:e7a7:1e76 with SMTP id 5b1f17b1804b1-43d3b951acamr22481225e9.1.1742315131880;
 Tue, 18 Mar 2025 09:25:31 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:25:08 +0000
In-Reply-To: <20250318162510.3280359-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250318162510.3280359-1-sebastianene@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162510.3280359-2-sebastianene@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: Use the static initializer for the version lock
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Replace the definition of the hypervisor version lock
with a static initializer.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e433dfab882a..6df6131f1107 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -69,7 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
 static u32 hyp_ffa_version;
 static bool has_version_negotiated;
-static hyp_spinlock_t version_lock;
+static DEFINE_HYP_SPINLOCK(version_lock);
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -911,6 +911,5 @@ int hyp_ffa_init(void *pages)
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
-	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
 	return 0;
 }
-- 
2.49.0.rc1.451.g8f38331e32-goog

