Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1834374ED
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VQn23l3B"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso1598543276.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563826; x=1700168626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2mOhK5FoYcXL75GR8axKmDOtKXDH3smigWBB7T8RqTw=;
        b=VQn23l3BH/KJEZStPaDNw/gRf74EvQ9P83e+Yv2D5Le/RX0b3UAL34lKAC6QPIX8UK
         bJMxRPD5qyoqoVtmpa9BIo5zXqDZDc51xaaFicmTgyeBM4APw5bW79uwiBMC+4O1J2su
         G2KKBXodcPWIiteXRcj72WlfdaOpXrHUVNrc6ElKTeULfNb9aEAmoK+iCOXyHSMd9X6Y
         9PoQX2U/geFQ9QmWwibsp4I7/5b6oELMq6gy95KfP78wwwFQvbLlzCzz7ZPTY+dX5JDl
         JzIznmIx4rFMNdq9X6xGdeaB2sqtxN8rnqktuCDje8JzWir2zzklDNoNR9bHXOOnGQaw
         mTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563826; x=1700168626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mOhK5FoYcXL75GR8axKmDOtKXDH3smigWBB7T8RqTw=;
        b=O4zNHsJZbmXpczUqQ++y/qdI4f0v+ZYbXq67h3ujkl+d4dI9Xc4ea4FtjqRcBScyIt
         BiRgTjbb8hOqbrKRQVVJgGHRpKJtvgLExsHki2VeTp5DgWSAfHMk/DicLbVWjCMzH2A5
         YcrlzKElMk1cnv8SMIx/H8nbbX24O58pu/+6ReGgvN4ifxRWyKsvq36ukPc1t92IOrBb
         nKy/qUnbK2gbq1HwwSM0dYKrdito1gI/A+KKsmEsNFBvk3wDFLRJYnb1k46G0G3VZH4O
         X8bPBbol1AFqTaVqc9e2BTgFzIQPVMnUq+dRHnsUc9//d6r3z4BgsrxIauyIG+vTvshE
         Wajg==
X-Gm-Message-State: AOJu0Yyjx9FaFlIedeM0bdwrOaFdG/qVAsfJTHaWcttXGMs8sTm54zyA
	YCIicYxx8MlPvWrz1VtURfBk3bKUqGTS2w==
X-Google-Smtp-Source: AGHT+IEevm9gxrKUT+zKzL4wMuDoD2o6L3pgb1/3TA3DxCiu1yUYlIaSqbwc2y/dH2L/0EUx5ZlxnIF/gqvflg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e64a:0:b0:da0:29ba:668c with SMTP id
 d71-20020a25e64a000000b00da029ba668cmr143892ybh.10.1699563826668; Thu, 09 Nov
 2023 13:03:46 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:14 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-4-amoorthy@google.com>
Subject: [PATCH v6 03/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f521b6fd808f..88946d5d102b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3055,15 +3055,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.42.0.869.gea05f2083d-goog

