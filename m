Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF74017C98
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556657; cv=none; b=FD3kZATqGCScAsR5clCa/Dg1NzuNALO2lqojzar/Q65V9bwoFt9hYRfpxprNgtuuIaK1SywXGo+GCaa9EkMGqmUeu7k0eSkXPvH1zr/KG8R2FDneVDR33cFAa/Jj1BuMAsprhnPBQscb+Th6taEOKDiBHi2RGNsQ6KbadjoDCrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556657; c=relaxed/simple;
	bh=x+G/SKe65zYqmcjfUDWiwO99pE05MNdhz6X9PomzPYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DtpOpG8JAdAiLnNoDotGeXHzRK6UHtkhDSvKOeefwgMzbgMrzaBmIqL8SFNDkdvP865SJBN14s21WSRzzStfPwjUv6STlnrwXc0a9vVi15l5Lo+Ursla03yhEG7BqN9j7Q5vrSNvGgmxAlvYQe4IPa4T1HWoUroMk79cTiZqKNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tEWqm/st; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEWqm/st"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so6693917a91.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556655; x=1737161455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=tEWqm/stSj9kxK33dw3klGgTKtZI4sjgr7ur2HfmG51UbDpIAowuhLrXaMgJwUGRrT
         5EbylOMno4p8JpPqxtH1c5b/qPTCUyFVXgaIMzYSEAPZ8HC1Z2JvqLDgXF29hrTnp+uv
         fwQP6JUU1hScJJgIVbUpBJzP/rH4dzEe+dcReuH8ERfq7Sq8AkEAbjPd2yG1CXpw4E2K
         2zNVjcSei4y4FGBKcuotMAi+8FdpnWAeYoABTucEUIacr7TY3Kf/Wq8WSOSxfo1QQ2r0
         TImlnwFuFZxfBiG7y/aJ1U8xMtwA289Xe3FlW3B924+9mEYupLCYhSAKm+16vgNQmCyA
         HSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556655; x=1737161455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=V0Wcyw85Dzy8S0UpSKeh9dB0wPwd4/kxkzN4luTNECNN5AKeEGlY1slsvW2DbM9/WC
         2UFSONC2kqOa9uKmKz1d17HFbpY9KK8JzjySnaDj/n/osrgCoKAiKFjabFBqnk4Yy592
         plcaQoDacuvI4vJhw4iBhG7/jzle471uBQwJ9Sy/YHmpPX6KXIKOE31g8l3qHqlzhRED
         njkiKz3zanoTecz+M2s1l/MeLQnZ5a1DdkvGmif2fe5r6gfTzvqXIrqjBLSL2DnwESlS
         ByRh9uX6zhkfDilO0BIIZwXKLZqckNY3XrHpgIJmIxqmzBHiT4P1f/2hdyF3/srGMyfu
         HYig==
X-Forwarded-Encrypted: i=1; AJvYcCWNnaw+S2PlmHJWFht25Yym0y0QUyuUwU8VOnbJTQBDJUcaNilLMlHwydNxdkw9uKTvtXeicGY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRcJZzgo0rZ5N9l2xH3AzrzPdf2vWsSTo70cC9a/5RoI6G3VUh
	dx6CY0U0nH4413Otr9Q5zY62UGeEodCOQGP04C+plKqJIz905KNeaywaLz4dnkiE/q+X+scfuTC
	E5w==
X-Google-Smtp-Source: AGHT+IFaIgnmyMwcv0JpFmACh/zvowyMAMYrlakJCH8pPaULUTBzt/qI/JqGqmGqNNZlkEWD/D5dHaJ9LLc=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:2f4:47fc:7f17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c83:b0:2ee:fa0c:cebc
 with SMTP id 98e67ed59e1d1-2f548ececc3mr18761170a91.20.1736556655284; Fri, 10
 Jan 2025 16:50:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:42 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-3-seanjc@google.com>
Subject: [PATCH v2 2/9] KVM: selftests: Close VM's binary stats FD when
 releasing VM
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Close/free a VM's binary stats cache when the VM is released, not when the
VM is fully freed.  When a VM is re-created, e.g. for state save/restore
tests, the stats FD and descriptor points at the old, defunct VM.  The FD
is still valid, in that the underlying stats file won't be freed until the
FD is closed, but reading stats will always pull information from the old
VM.

Note, this is a benign bug in the current code base as none of the tests
that recreate VMs use binary stats.

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 91d295ef5d02..9138801ecb60 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -709,6 +709,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
 
 	ret = close(vmp->kvm_fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+
+	/* Free cached stats metadata and close FD */
+	if (vmp->stats_desc) {
+		free(vmp->stats_desc);
+		vmp->stats_desc = NULL;
+
+		ret = close(vmp->stats_fd);
+		TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	}
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -748,12 +757,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	if (vmp == NULL)
 		return;
 
-	/* Free cached stats metadata and close FD */
-	if (vmp->stats_desc) {
-		free(vmp->stats_desc);
-		close(vmp->stats_fd);
-	}
-
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
 		__vm_mem_region_delete(vmp, region);
-- 
2.47.1.613.gc27f4b7a9f-goog

