Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A53D5C26
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 12:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367589; cv=none; b=pS7T/cKyuH5wqHM4LoXVvgU08A0mrdb9PY09/0XBWd8sukSgHNDU/3TMDbfZki38/e0KBPNm48r2vm/+a5vcQkuoL6sk38pCx4iJGpx04zfr9Zzt3SmOTrui5M0pA/roQyEwwOuajC9C17RQxHJjB7Z1WmFdals9vhwX7S55J+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367589; c=relaxed/simple;
	bh=BiQi4oMT+X87FMSdg3R2NUFjvYlr9OpbO5jaNOqH5YE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HB6uZW3PyJthnadIMUYtuVnlfV/vc7COekFpTdgVaLN55TdtYvJJ+xtRGvDj+3cvv8q9iUJ0iG05Sn/ohORLe7Z3PbjhKmgO6a8DBwC+NZVm3CTb0T4hK7bh6TcFzMgI+fO95sefECqvtJNyNCOYuzzD/RgLe/Cz2TzpCVWQXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gY+HxfG+; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gY+HxfG+"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fe6894f3fso36018205e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 05:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779367586; x=1779972386; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya0EIolpgZkRZly38TaGSqahWi+4I2R7BKxWyyv4pQc=;
        b=gY+HxfG+x7q0Ij/d0afvhxaxvJKzY9C5hrvlJ7cnvHUsAWJy+juOkxvGY7TfIHAbUR
         FNgAiYMCH09ciMJ/NOk0t11zqtSRFHcpkXk9dV5T6CCcp1W+JgK2uXmohpEehgoKmQqq
         KithgILZrqbvGNKTIt1iMJfMp+q85hb/LXohc/ySPt8NQ6mdmCVE2TizgX1v+5LcYDxH
         A4i9YcUjjPaEGIvu1BXmQdLvUtIZ6bEF1axDdWLbogCvMliuoVFH1jSWSGDdHk8dxkMg
         IB0rAz4YlDVNOyraTmS2Eo9w+vH1AmW915MjSX4kHQVODcciOi+zmNI1qZP3kd2eaBYJ
         42hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779367586; x=1779972386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya0EIolpgZkRZly38TaGSqahWi+4I2R7BKxWyyv4pQc=;
        b=DRk/RZ3adcBpMiPwyjDlHtmD9CiFrrjxD5vQ5WQHEAwIf2zbDPDSdBzwjocBfLCsy/
         32r1IaeY7RKYOOf7ZC/qaw8Hu1v4DiEVsk44HE19o0Eo9de+ie/p3pkT4NzxiwMIf3Rn
         bvSHhE2riJvqIhAkt4l1xso30nQmszyk08IarEfAszRTVxVBmiqgNUEHF6i8c8eUMRKi
         +eqs38XM0g407rsuelCklJRHNeEQ6EhryNvMht4X7HkPQnvcERfJMD4QBjCWDOy+5CNl
         cOS0NKcGvauBKOOcVjlrwqbSSCL204PmLVf0ssemB9UbUOXF/3bPrM4EP8b488eHep8m
         Otsg==
X-Forwarded-Encrypted: i=1; AFNElJ8LqLFhsoDgNAp0daPQrj6+STaIL7wp3kGfOIkssjRcf5l3SCJjg7RsuLIf1r3STjEIy3yQ+dQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWVw8H2gKbRC0325A+QCwMvRs+c9Sn/zbFUsJv3JBCZc/oYy5E
	iLuwYlZoYM38NLRIGutomNpdstw4wxafm0DFpZUUAmfRgjnhyhhWnN94G89Xiy3Jl/5zuLM6dMU
	9r3/w4W6nPJaEb2ergTx13Q==
X-Received: from wmom17.prod.google.com ([2002:a05:600c:4611:b0:48a:8f50:6c57])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3545:b0:48a:54a6:b29f with SMTP id 5b1f17b1804b1-490360a87admr35403265e9.17.1779367585711;
 Thu, 21 May 2026 05:46:25 -0700 (PDT)
Date: Thu, 21 May 2026 13:46:12 +0100
In-Reply-To: <20260521124613.911067-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521124613.911067-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521124613.911067-3-vdonnefort@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Fix rollback in hyp_trace_buffer_share_hyp()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

When sharing the trace buffer with the hypervisor, if sharing a page
fails, the rollback path in hyp_trace_buffer_share_hyp() misses
unsharing the metadata page (meta_va) which was successfully shared
before entering the page sharing loop.

Additionally, if a failure occurs, the cleanup calls
hyp_trace_buffer_unshare_hyp() with an incorrect CPU index.  Since that
CPU's pages were already rolled back locally in the loop, this leads to
duplicate unsharing attempts.

Fix both issues affecting the rollback.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 06805b426101..8595f9bdb3dc 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -212,14 +212,15 @@ static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
 		}
 
 		if (ret) {
-			for (p--; p >= 0; p--)
+			while (--p >= 0)
 				__unshare_page(rb_desc->page_va[p]);
+			__unshare_page(rb_desc->meta_va);
 			break;
 		}
 	}
 
 	if (ret)
-		hyp_trace_buffer_unshare_hyp(trace_buffer, cpu--);
+		hyp_trace_buffer_unshare_hyp(trace_buffer, --cpu);
 
 	return ret;
 }
-- 
2.54.0.746.g67dd491aae-goog

