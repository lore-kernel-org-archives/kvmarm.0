Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B198187337
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038076; cv=none; b=sOkQOw3/GMljiYTliMus/JNrjuoNjf1elvKEtb4LNTMkvmh3IKBnxWEN7AyHY91UG1Nd1hJHwdBSv34Mhu+d5PnWEyD2Oz1CGtWKNvEP8hjXmTku1zs7EMFp+N2eEJEMK0BSK0aIwX159OVEzZRiWjAMuA1yXvN808NjaWUnLvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038076; c=relaxed/simple;
	bh=ZzVpAxjr1daPEmxzWMhozlSzguFi8sPCSDoFWGHBH/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OluKqLW0lPG/R2Iia505QirmoQ1TRXboBG5/DNguQ9rDy6IZYbZEegmW8+IBdX1Z1qw6rqsP6yQTNFQaR1PNlHBZoHIOOS0irrMBRdxqWRE7GtnWOMuElxznVZWXFFr2PrHAvDXroel7kqAiMIb+HC/gQ/cEqzgBvCC2+1n98C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OlHHvdM7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlHHvdM7"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb4bcdd996so1365958a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038074; x=1722642874; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EmJI7mCwitfWH+6LwHkJyXugWKEFSS3lkF1NSC2iA8Y=;
        b=OlHHvdM7vluw8rVC1JjSFNeh4RsnHv4yMYK5Xy4asBH2Accxsb2Bh9BTJO+qu7Bion
         b2zxBeSlDC2ODK15gfHb4ntPWshKNQ3/AnfNirDRHHJgRmjij/G85KBFNSm0K69vQFKW
         LjwcMjY+dP1iIzYJJeCKzyCuR+4VLafd2L6xFz2Jrle99j72OokzaC2TrRwkWFktQrsc
         8kG0QX6E1nGWLHxGATdKM3XIPY1oNn3b16Ade+Dyk9fjzOEK045xxopE+CQsvNJuZoDU
         BOIP3bh8NlPTjGStJMQLtxx8vnY7YCeLfazsLCixrH4B9QPJjbmMekJelxu/Yqtkm3J9
         szLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038074; x=1722642874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EmJI7mCwitfWH+6LwHkJyXugWKEFSS3lkF1NSC2iA8Y=;
        b=glqodUZbXBCPCy09c/4qYt3kpF1m4mppfUr76EkPw5LIlg8vRL7/x5NIQsBhMqkm1V
         pBltZky6+QrxFmSulQ2qflPiDsGwssPmTvx2rN3CA8Q+mdFt9X4VDlczJhIU+61j7KgK
         Uh6vor2VcjA7K2q80ZAPyiQ8bvp2+suql5b0qOV4FnfCXFrJycFKZrmlMVznn8G2a/eS
         5rcUiSUrwAurkeHrupLhR1Yi91Ex1PgFrzI2d+GmJN5V2ZEdqVI4QX9dIntPeMC/6ysE
         WkxuM9XpbrVUfG6w7+YXR3gQTNSNjW/qYplA77eKrwyaPKH6ivvWYnIGu69HurObFM6E
         4lRA==
X-Forwarded-Encrypted: i=1; AJvYcCUAZFAbi7U+Qy7vS7qPWtdoLX5NuRA5RxY7LipjsO82qWsvR1iWvdYWe8nCuuO77HHBoCo9IxTV43jnaYk8ZDwGeWerTXTz
X-Gm-Message-State: AOJu0Yy7OVkkoy6MQkzbtDE+MMO59cpxzbU642eWlD7xtpze7JvtBciK
	45sT/zhEhRBpD2WLEqg4Q5R6LCUUuNP0fSE/01RhTJtI5NaLb+yh3WyK2zGUFUHNT8IN6NCyb5k
	Ijw==
X-Google-Smtp-Source: AGHT+IG4DskQJpICSO/7ZhzoCwUBvTBXkkJhFyAvydTVcsfBboV7ccXE3z2KESMy5r+D4xCglFGTF0FLhYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:470e:b0:2c8:632:7efe with SMTP id
 98e67ed59e1d1-2cf7d1673aamr10630a91.4.1722038073062; Fri, 26 Jul 2024
 16:54:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:05 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-57-seanjc@google.com>
Subject: [PATCH v12 56/84] KVM: RISC-V: Mark "struct page" pfns dirty iff a
 stage-2 PTE is installed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Don't mark pages dirty if KVM bails from the page fault handler without
installing a stage-2 mapping, i.e. if the page is guaranteed to not be
written by the guest.

In addition to being a (very) minor fix, this paves the way for converting
RISC-V to use kvm_release_faultin_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b63650f9b966..06aa5a0d056d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		goto out_unlock;
 
 	if (writable) {
-		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, false, true);
@@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
+	if ((!ret || ret == -EEXIST) && writable)
+		kvm_set_pfn_dirty(hfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
-- 
2.46.0.rc1.232.g9752f9e123-goog

