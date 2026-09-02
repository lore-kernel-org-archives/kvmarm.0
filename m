Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAE44AD4D0
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367304; cv=none; b=TmcgCAqNYyvhjJAZEMRY78yvML03gI/ErvQzuXWouNRuoJsm++Hb8apL1D1C4Mo8OiH8gGKAu3/RPUJ6BbTtqxYoYUsflh3cwxiixEVRVJFA6erboPGMD7PgfTt/1eYdU7MrmQPNzhDfeb+74SQyJ3CbWb2hIRVePIOMZsvMPdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367304; c=relaxed/simple;
	bh=UVGy0HhxZ+yDIeNG6eDI6eU+6NSVSRJ/g4F95JRGveA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDgv8OlPjFBqurgdgGcSTfMnP0gWTJ5v/xV2PMA9UvcNCxSiNSUUgC1KrprrkfoYy5Y4QQbo+KErtvu1p8bAOGHSs0GpVCo7H2KcjBKdBONwLWdTVb0mnt6Rvi3k0hXVRnD0DaP1EfgzL6iPSI7YpNsIZX5A2uNDeFvaRXjNgLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfP5818A; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfP5818A"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-85524903a9cso946493b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367296; x=1788972096; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wcKMUlmJ0lq2oBOCUrCto8mVZjPEk4eBpEgiK6nEFRg=;
        b=mfP5818AJPPsmLPfI9eRi4vEpxR2N+xxniMGj02cYCXYHZ2UFfqrJEVxnlKCEchRi0
         7VLxUuM7eEsYnxo2AxspHlLIzG9mIShuNMn+OamW3LbVMcvMqpUhAl6/vcpBMy1UW1Iu
         zv7p/KIc/pWV/aOPY00ZOWrcP1QgFubQJwmVJBXWbx2pPNlpwxZAEIJmnpYQDXEmkF07
         y3D0DWhYlOn3RlTVJ/0VvlkMghTFF4qrpztBwittG4zlmlryBOrfxLVE6ezg88P7U6AJ
         YMp8BQ0LL9qHQBYOmPgkdt83AcbV0T5Iz/HXNvWy2bAzkVujLoTGehh3TrACeBJYrfUp
         WkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367296; x=1788972096;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wcKMUlmJ0lq2oBOCUrCto8mVZjPEk4eBpEgiK6nEFRg=;
        b=CctWSrYRS6wgajB+EtQSU5Xo6nB7BhHglBjyUbbVTl1PmdObXmXRhZ6pgpqKzt/hsu
         UugUt3kKPMvlRj6AlwcF7w8aa23pVGD79tD53NU97I9MSUEM836wAi39Antd4wxwODKc
         qZU4K6tvCytYlqCz/gRZi88Cr3ok3nLMAroGIZ68TxKzStwFzzSfTvX8Sxm+tkkxoxuc
         owqGdJjTD36qWhvx/8pznX1MsgJh1AGxA+uB/G4kRNjtrdSYJs0p+XU5aR1mzdWNER2Y
         mzM275mFuUGbY7elE+cnbxcfbNt9RGUx9MlArY22PlSVUahsMyJoFzBLrLLknGQFG98N
         TaPw==
X-Forwarded-Encrypted: i=1; AKwUvBx4ch+c5TV8oQxaF6jp25ZeJ9Sk646tOJyMcyAfWnILz3iv1RcUOwUDwQ5xdfp/qKMDoI+W5nM=@lists.linux.dev
X-Gm-Message-State: AFuF++m6VlZv/UUt/Bk68NybafUFYsE8/VpeiIu5Xyk/QTB+rDYjsZl2
	X5lP3qS/uZdHzggv701ay7zNDDbNJ2GiDqql4KX2QZB6Iv9oLITyj9vmLibmmK0O3pvUanPQTXT
	P7lR2xw==
X-Received: from pfbeb17.prod.google.com ([2002:a05:6a00:4c91:b0:847:87ec:2a9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:997:b0:84e:f90e:492f
 with SMTP id d2e1a72fcca58-85ed25e06efmr8429625b3a.7.1788367295680; Wed, 02
 Sep 2026 09:41:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:12 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-10-seanjc@google.com>
Subject: [PATCH v2 09/20] KVM: selftests: Use the innermost page allocator API
 in s390's IRQ routing test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use the quad-underscores page allocator in s390's IRQ routing test in
anticipation of dropping the @min_gpa param from the primary APIs.

Note, it's not entirely clear that the test *needs* to use a very magical
@min_gpa, i.e. it's possible a more elegant solution exists.  But that's a
problem for a different day.

No functional change intended.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390/irq_routing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
index f3839284ac08..cd26cc1aed80 100644
--- a/tools/testing/selftests/kvm/s390/irq_routing.c
+++ b/tools/testing/selftests/kvm/s390/irq_routing.c
@@ -36,7 +36,7 @@ static void test(void)
 	};
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	mem = vm_phy_pages_alloc(vm, 2, 4096 * 42, 0);
+	mem = ____vm_phy_pages_alloc(vm, 2, 4096 * 42, 0, false, false);
 
 	routing = kvm_gsi_routing_create();
 	routing->nr = 1;
-- 
2.55.0.966.g6673acef38-goog

