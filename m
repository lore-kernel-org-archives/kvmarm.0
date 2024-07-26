Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AB156F30
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038078; cv=none; b=pxvoBiUWBY1d0pXJuzxJQMEaXf4/zkRwuHjF41zlJDPsTTbMT0OSCrq0KYZq1alskLFewoV4O2aJF9F1raFY88jWVGHLGGn4Xufw7T9pSV+brHQmr8kpHK4648lvFjA8TtwuZcdQaR31TNdkfHdRci5+leku5NeZ/L7O0wDgpFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038078; c=relaxed/simple;
	bh=xUjZCVI6Pn1FEhfDqaMS78eNTpmQssm1VgccWbaB3YU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mvajaH+C8ZpAxsJQJcF+TVy4M7NVfLRkXTPc6yxSj88VjMaqmod3Tr3B/bUKSZQWaLlCmpEhG/Ya621GU3ss9jbAyYRqJPrqKHb8vuCBHqqve/DNJnQ3QckEIVba0TLgBH0PRM0aNevWhYwkGMVeXsSap8N2gKaJDDXdM/9u4/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sRwjAaGl; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sRwjAaGl"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d23f0a3d7so1451409b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038077; x=1722642877; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8WWxSeEhwRY8Kz5lKN5dweAMeNFVe6itBQweyIKsQVg=;
        b=sRwjAaGlt0HaSswc5wQDgu1VpKRuOj/yVyCWaQbe9PiqLJpOH9t4hJWn4+0V13mwQA
         SaEvsxY8H/1h6+13ncnAJHyjchaY3/HMb5iA2g6Evf26GHaXh7ezfzLI5gIU3mtHWOrp
         yVjQd4yqdcAHy3wqI15E+QjDq3H+v4cyo9F7EjWMSJHVdNtOGiDGB8XVrJWRR80stsma
         a7Ub0gHWqG0Lmmh5vlSIimGSO1ACdpslxhVgfojaiAMMR+3+VccsMO53cXjQ0TgbPdgU
         uY8LGQi7wfVTcZajPOK5BzsThlHNVnzFkX+AfV3fYr9cc16ARKW1w9P2RhFMve3j9nu4
         t7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038077; x=1722642877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8WWxSeEhwRY8Kz5lKN5dweAMeNFVe6itBQweyIKsQVg=;
        b=cs7Qq9+coQcwmbS4sy4Ccu4xUWQCWQ4WYMGeyUriR0UHj1hKVpfwkW7Czny+7t9F41
         RsX0dKXECL+zO24brtDAI9uYhct3kQRramIJdu2ykXPA3Ywt+yeHhz3AhS4meTwscUEk
         RLqlR+g0CxpwurCJ1/P8JFsLJRt02iZPNK2vYnyayF0Z657I5W9hjtWmLtD8ev4U/7lI
         o4ubOH/2Kpf8RLs3uyhOdGacF4Bb8WnVS4aPVHsXOX0WMtFaMGoCMDuCIGC3ku/pBUAm
         fozGjlLxUGcLqMQcomc+2HmM0/9emyIhZxuQQYdn56IiRxdsYqsvOYuk0VWICCjPYBGv
         hReA==
X-Forwarded-Encrypted: i=1; AJvYcCXhHsSTlJ2TGJrBEUoSNueeLJJYeKN57P/LMiJFqsri6q8wTK8nS4cX1Zs5AMRSLhSFl2f4IHxwivauiQctDQ2x9o+1v4tO
X-Gm-Message-State: AOJu0Yx3GUInJHg0PPK+qZRc47FIXkgFCP9QdSQDfo7y0DDOPiYV5HMw
	UnYp6+qu/o6Yvk3+aKNFqGQZiWKLFJ9gTfPnqeocjVPASY2HUpoSkmcRT53XiRhKdZ/+gBkztWA
	wTQ==
X-Google-Smtp-Source: AGHT+IFil497nfsH36PcPgD5gbB02jEmsX2CuGy2fe2s5ytKElT5nFsSQdr9eHlR2IIEavfJT4DgKyMZ3iM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:66e5:b0:70d:1e28:1c33 with SMTP id
 d2e1a72fcca58-70ece9ecd04mr10022b3a.1.1722038076443; Fri, 26 Jul 2024
 16:54:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:06 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-58-seanjc@google.com>
Subject: [PATCH v12 57/84] KVM: RISC-V: Mark "struct page" pfns accessed
 before dropping mmu_lock
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

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that RISC-V can convert to kvm_release_faultin_page() without tripping
its lockdep assertion on mmu_lock being held.  Marking pages accessed
outside of mmu_lock is ok (not great, but safe), but marking pages _dirty_
outside of mmu_lock can make filesystems unhappy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 06aa5a0d056d..806f68e70642 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -683,10 +683,10 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 out_unlock:
 	if ((!ret || ret == -EEXIST) && writable)
 		kvm_set_pfn_dirty(hfn);
+	else
+		kvm_release_pfn_clean(hfn);
 
 	spin_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(hfn);
-	kvm_release_pfn_clean(hfn);
 	return ret;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

