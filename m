Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208A18412C
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038060; cv=none; b=JgLKPufeJ7mFCUU1qXwb+hd5RKSru03cFqxpW5EtHEpunxXwrUgw35IauK3P5s5ndrwNDeBDc8EpvNmrXv4Kv5VkuxocQInVXH+irjwr1O39A3mvhcwprnU+b4ggXM4T3pgA2TzQGnZH4h3ZywUd1SnQlB5zZRX+2r1l5/5BY68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038060; c=relaxed/simple;
	bh=bxK6qVpynswZ8R8KEFFqM/NCnF+uG5Y2NSLbD2Gkxm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQs3dwDNrawy7049/3/SrpDAAoFTto0LY+7mRM4/qFST5JwAGpsiFxgX9MNAyTIBpGUa5K3xRCGTNeuZEhHAvr5Vzd3xALPun+8a2nNzdmAzQ5UgnLuDYEFZn7X+0ALT//+uzUwFNNxtlXV9kIevcPeXxt2Yxe6LwXfupi2ha5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qqe72uZS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qqe72uZS"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb600e1169so1649952a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038059; x=1722642859; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TqUPaGEc7V7k122pX7jZuWDsKBXmCX3Y3KCoLsEzljY=;
        b=qqe72uZSoqrIa9nfW/8wfqPAq8v7aucYgYQWu+BntU8RtRb/bppUkPnqcfnnHOLc2d
         bt/Pi3SIEtRqsen9YsMc4Dz2/52RFz0C7RXoRghdIz6BsOVb9tUUPbg1AkbHeTv/Exqy
         MzAYbt+wRgJV9GH3H6w9bWLYlF15kBNgcJeHp6BzsGx8AhNnZoG5mhxklKxmZdNHZn7D
         r3qDpghyHC/SJULFmOHFTokNFxVZKz2dZMBLsydot9J07WiOgeSFboL/Kf6VMu7LGSNs
         2f/HZmVSNwDvWxIN+I1YrUfwKDY4uzCzMqfZXaHOihTtsOaAUEtqauyOnxxQyDDGY7gH
         GuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038059; x=1722642859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqUPaGEc7V7k122pX7jZuWDsKBXmCX3Y3KCoLsEzljY=;
        b=w+rgFqpNWP707Mt4fAdF+ewz39KziKlZexBm6wOweCo75dGiDNfXDzPmRUHKhuM5OV
         7isrWLeateywBCrlEHy/0NzNpPnZwLoaOWlIDOsm6E/0VrAP3+7THF800/hQxh/fcoa+
         nUYMbVQBoG7AjECUOUFrVec+btBfbCSzPrGxD/hzD5R2sE91JzpCEQN/A6D9yah+tlf8
         9Rt/7sFRRYoCRORUbCN96o1DwN6YkdxTZxkgL6R4ITebNx7vHdUKBwOwtBWCKVMQbxMh
         SB8uShqLRs6njl+1VUWnfNFL2kXvzLPjdr7lKmrbnXsOwRXPbscv1I1UAscL1lIEaowu
         Apug==
X-Forwarded-Encrypted: i=1; AJvYcCX9S8n3oq6CUyxfjiIlvy3iYFyYx1lyJ6qiM4nuHdYyu141jCgtttGG1ruwsUevdHcFfKVeEGfctC0wkwSVezGGJy87Uwbt
X-Gm-Message-State: AOJu0YzVEOZa6uFaIfWINR1sAZkqjJdzixwHndF89JjSQ+Z0g7tV5cdP
	/xAabIxgIQNRfvpu3EnpWscAuZBS6s/2aeq4mAxc3btl/P9TK9VoSa6L0PLsmjktoyJi4P64MkA
	tSg==
X-Google-Smtp-Source: AGHT+IH7R2Sq6ws3raxo/M+HjUZh8HrSGcUFKZNBVKBew2cgXvpkeEwYajfUFO1jgdCm33mambqvR7vew2A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:19c4:b0:2c8:8288:1f3c with SMTP id
 98e67ed59e1d1-2cf7e08defcmr21966a91.1.1722038058548; Fri, 26 Jul 2024
 16:54:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:58 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-50-seanjc@google.com>
Subject: [PATCH v12 49/84] KVM: VMX: Hold mmu_lock until page is released when
 updating APIC access page
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

Hold mmu_lock across kvm_release_pfn_clean() when refreshing the APIC
access page address to ensure that KVM doesn't mark a page/folio as
accessed after it has been unmapped.  Practically speaking marking a folio
accesses is benign in this scenario, as KVM does hold a reference (it's
really just marking folios dirty that is problematic), but there's no
reason not to be paranoid (moving the APIC access page isn't a hot path),
and no reason to be different from other mmu_notifier-protected flows in
KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..30032585f7dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6828,25 +6828,22 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		return;
 
 	read_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
+	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
-		read_unlock(&vcpu->kvm->mmu_lock);
-		goto out;
-	}
+	else
+		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
 
-	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
-	read_unlock(&vcpu->kvm->mmu_lock);
-
-	/*
-	 * No need for a manual TLB flush at this point, KVM has already done a
-	 * flush if there were SPTEs pointing at the previous page.
-	 */
-out:
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
 	 * will call us again if it is migrated or swapped out.
 	 */
 	kvm_release_pfn_clean(pfn);
+
+	/*
+	 * No need for a manual TLB flush at this point, KVM has already done a
+	 * flush if there were SPTEs pointing at the previous page.
+	 */
+	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
 void vmx_hwapic_isr_update(int max_isr)
-- 
2.46.0.rc1.232.g9752f9e123-goog

