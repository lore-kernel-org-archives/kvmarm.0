Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B3151CC1
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618292; cv=none; b=XvUd9OxW1HAFoGErgOU0Uy0FanG7bqHf3WDaPaEXM7herA7Pmgwf1ITAWxysA5xXQ9uiNtufSUZPetIUy5PBScT3+gZf7tTHCj1pUxsvvBs3g+wxg6fhMjkzxzXyoaS6AOMuogwe/89EFtEsCe7pSC9ccI8owqDvj0cminXg/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618292; c=relaxed/simple;
	bh=P3DcGgFx1Esbt3sQL+P8sgYw965ej+0hqQQdppF2RNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fSVb9w+6/mSiukk/RVAoVFf8NKLVoybkLl/MjXG8hqEa7XCLOZrWeAUGwibsGBjGrNe45qcfCoQkTjBCQSsZ48nSPIUkSBzOGNKU1RonKfReQwF63pCXoWKbOfY/iszA+7T53cgVe+NSML10cMFS3nPQX7fCgbiOXtdeTf59n6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oepSkKMf; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oepSkKMf"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33d782af89eso1231182f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618289; x=1709223089; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv9AuM4saXbATXwsstWXJV9w/3pxWYR1H2v53ay0HfU=;
        b=oepSkKMf62LnzLlm3O0cPo6Hfi/5cBHBLJePD6jfqWW4v0V/iAUaMtZUEymEj0ggBP
         wF1Vb8DOLYOgDl3qi+9gsA229qdtmU3tfcKccAxgNQeFx9qymJ9v2OFFFKSjV72aYgCd
         xwLS+dxgvoZ52+Y9BTu4xlVRXxHYEAljgSccB33KcU5e+fcyuqXDID7g+osNgcequAyP
         E9qMzWLZPfav3ck+hDXc7ke+5U0saD0XLsG7bkRFbejZiYCv7Gdmwg4GEgk8cIJPtax1
         uBVgNi/uq1Fc5f6zdLkKYcJCDQYVGT7jhPfxvOqbvs7XNRO/e/1nD6RJ3786hKJkAQ1C
         QZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618289; x=1709223089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv9AuM4saXbATXwsstWXJV9w/3pxWYR1H2v53ay0HfU=;
        b=N8acuB7lLMGpUS3lqoW0RjnAlbaJ9egKUzrATrk+6GJ426jnvBduRm/s5mkC3AchfJ
         zdhmo78oHV4t03Rh5eyGIjhnjbosx4Bn5grileJp7wi6LOdqJuBprkEHRUqMK6Lg5T/1
         uIPLsZsoNyo+4DNoDV/InfQtA2tzuEZRX66MqAqq1+mJ9zLvy7qS7Wugp8g0WmH3JiXi
         loScIpYp4kQmiYspPBv5psBgkcp0tPlmmNFYfKlUsZ0BC7n1FghN9mQiMoLS3xo36sSI
         6BAMDc0d0cnOQ1tPzTNNevUyA/a2kjHHZgxln8WarltaBSRxmsGmzIDmDzzUaHYMWpk4
         elCg==
X-Forwarded-Encrypted: i=1; AJvYcCW10RXs5pM4F9a1jxuE8PdcHAwvgJl+xvusr3Za39u2WupVN4vBn0ceiB/uyOmxS7/q1HjsTkuPUKT4NkbJsqTfw6qIwwLU
X-Gm-Message-State: AOJu0YxEAaC2ae6Wy9IMyNgGoaJEZFCMY+N9yEEkMllrh8XimsqfZhoU
	qjmdsVgpj44EQluWqo1w4AbpW59OZrTp5S6kME+tqzkS53BQo3ZQnpYwIwcarPE2hYBgkLR7qw=
	=
X-Google-Smtp-Source: AGHT+IHZJHrajzF3EdpiiEZnjfvNIhoCy7C/iyvPxzB5DChrxwU0aVBoojhrAAAyoesSkpogr4EI2GCUFg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:b613:0:b0:33d:19b6:30b0 with SMTP id
 f19-20020adfb613000000b0033d19b630b0mr34674wre.8.1708618288892; Thu, 22 Feb
 2024 08:11:28 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:37 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-17-tabba@google.com>
Subject: [RFC PATCH v1 16/26] KVM: arm64: Add a field to indicate whether the
 guest page was pinned
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This is needed only during the transition phase from pinning to
using guestmem. Once pKVM moves to guestmem, this field will be
removed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/mmu.c              | 1 +
 arch/arm64/kvm/pkvm.c             | 6 ++++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 99bf2b534ff8..ab61c3ecba0c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -210,6 +210,7 @@ struct kvm_guest_page {
 	struct rb_node		node;
 	struct page		*page;
 	u64			ipa;
+	bool			is_pinned;
 };
 
 typedef unsigned int pkvm_handle_t;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ae6f65717178..391d168e95d0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1502,6 +1502,7 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	ppage->page = page;
 	ppage->ipa = fault_ipa;
+	ppage->is_pinned = true;
 	WARN_ON(insert_ppage(kvm, ppage));
 	write_unlock(&kvm->mmu_lock);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0dbde37d21d0..bfd4858a7bd1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -271,7 +271,8 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 					  page_to_pfn(ppage->page)));
 		cond_resched();
 
-		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+		if (ppage->is_pinned)
+			unpin_user_pages_dirty_lock(&ppage->page, 1, true);
 		node = rb_next(node);
 		rb_erase(&ppage->node, &host_kvm->arch.pkvm.pinned_pages);
 		kfree(ppage);
@@ -362,6 +363,7 @@ void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa)
 				  page_to_pfn(ppage->page)));
 
 	account_locked_vm(mm, 1, false);
-	unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+	if (ppage->is_pinned)
+		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
 	kfree(ppage);
 }
-- 
2.44.0.rc1.240.g4c46232300-goog

