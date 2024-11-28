Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4D2AF0A
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755359; cv=none; b=glKXbxzcbEPn4t3cCTiork0UOeqmIB+PKEaoZjYjYDh67BfvzD+BOccaSjpFsclRFinErcbka1tBtzSxRytmPhtBpDddd1Vv42YW5f8ooTE7VcoaM5XyxOpl6rhEDNybM6FRIRcTFvYhR8oNiL5dI2/oXgzyDzy7p0mqMKWBdSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755359; c=relaxed/simple;
	bh=WNgn4lu1ApV1cGqCgEdQ8UELTIdxvWrpSXPjrrKh+zU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BLXoD7vF5BWLQRdFkuJDzd3drgPEgioahmwqzLG+zj3sqiee77mlvCrwLJJQqUr3r2pqY42GHsQ/56WhkJng/7ffzuFPcBTwr/bxXKeJQFsERwhHAVnZI+BLf2J94mursg9ABlpQvnGdYVlXN2b/EMlQojPiiyZnmxsVOBTwaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kMIL+qTc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kMIL+qTc"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea21082c99so271521a91.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755357; x=1733360157; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VnpBHLYkUch4fOHU4hkMVn/ClZoihkAVUxnB9ZaI9Pw=;
        b=kMIL+qTcSEmhRfAzBOOtSKJuZ37vvo/U9B0FNg8PRqyFegAC73tUrBFNmQfs03pa6A
         JnkYOKjEyHnTVTmaJl1eP7CEg4IfwrXMPnv52WNgdAlhOQqaZUMnQR/nLwIZnaQrP77g
         2sAIJOgG8oS4Dv+t4RALRiwGuQDejegJWb6CtXkGwhUMeaEv1Gt+3MC52WqHs9rspcm7
         FWKLqiKY5d0uYjASgpvBi5kITm9mI4/MWF9DzYNQ7I7dgKLychXX1VQtpzSZgWu8grDH
         8lcvBtu9Ktg2yPqEqgxGOf6xVtbgiYFdNjlD2FDCxmE8SP3IUbUXuLnmGJiAuVLPQ1OB
         7lNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755357; x=1733360157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VnpBHLYkUch4fOHU4hkMVn/ClZoihkAVUxnB9ZaI9Pw=;
        b=RQ6Bsr6M1cxjaXKKWx6O1a/7ke7syUozEk7SjZ3SpGOOLfswPfXizbNpAVr3kpPxch
         9G4JQBoj+S85MvccDTK+bs/SlMh4/zGhTwg18BzKEMrjAtyhepFdQaO2/XBtbgZ7l42B
         kid9+l917CWs0lYfBxn8t6Y5rUB1GkL/9DjgSpZzBWAL07DCfcigmaZrehcmBdUMhSwO
         70lxut8rx/B0NiO3ytWMs7B4cuYWPggBU18ZYv5RIL41uAl9WEOfpxYloIXBhjuAIsbP
         pnybm+q10/1KvQbhWjcEwlTrUrOtx2CtdUt/kC4fAQeCeU5q67Nmrqks3JG01BM3uPFh
         TAxw==
X-Forwarded-Encrypted: i=1; AJvYcCWKCyBiR2p1UrVx2M6EnndE4sBiw/qMpML4ONpUgd3RYisjWDgH/+NGPZ1XAQ/MDfIVfZCb+os=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjYRRfKn9jWj6uUFSQVtYuuTMKYE7Bn7XtxQjlnKDuQSEtZGn/
	47ovtx1v6GzWbRD8hF2BexILBYKzgSaIp6dQSpEFlxubvE4Z98Xld6qUN8uI8ws1jc2ncqQEBTD
	R8Q==
X-Google-Smtp-Source: AGHT+IGNjVu9IbM8M8x4FgAf0ptLY31wfGw0nWSewj8xLv7iHu7ExU2Pbfe7utzxkDM6gVPdI3CzS8OquPA=
X-Received: from pjbsc10.prod.google.com ([2002:a17:90b:510a:b0:2ea:d2de:f7ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fe06:b0:2ea:83a0:4798
 with SMTP id 98e67ed59e1d1-2ee08e9f0f7mr7211038a91.3.1732755357079; Wed, 27
 Nov 2024 16:55:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:35 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-5-seanjc@google.com>
Subject: [PATCH v4 04/16] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 480e3a40d197..33fefeb3ca44 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1648,7 +1648,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.47.0.338.g60cca15819-goog

