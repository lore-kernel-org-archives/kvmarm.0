Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E3C15098E
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618274; cv=none; b=rAYJfFyrjqRkYPBhd7U9/L6bzehrZuxm/3PeOqGU5cyH3P/sy7sq9Rrm0mxB1k1mTuUzVg+f3mj55SzNPKbQ5fNSzyP/6aKYrtQh7t1KTGPNltUGbpHC5BF4GQPjld1vGWd8ErFtyR/FrTfoBxmgLUzW3iNo5XwtKMIs2zWiWnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618274; c=relaxed/simple;
	bh=T0s+s3WWpAHm6/Ds0XZMRP50GdBlMYG2JZS6OaYhozI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ug9G3EWNWgFu8t0d4/nqO5zt5INws1gOZj0yanuDptwIZ1vufJpI5YKfxnzYkX/kpsvvv3n20IrTH3q5onor2N7GlpvVzPjzC75PMwCqUU1wNtxrV/+4lR7u56qIt2klC30TbRq652uwVq0Nt2Tu6fFFexAvcj2kht/ziGnYKIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x6Bjun3D; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x6Bjun3D"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608835a1febso37315477b3.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618272; x=1709223072; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B40b4r+ABegtiwQt7mlJqgO3WEbMRBCir96KVlqSF2s=;
        b=x6Bjun3DZTw7UEvvOqxQp2r3rTp9L3hL31N6y5pWV4mQ48YfrVdq88cKY45E5NYMGm
         87D6kLd/SXmmMjdLtK23sm/f+I9JvtUHIxGXtznh3u6qR1jHwVULbFl6JUhpoytDW7tI
         b76bQhcK9OjZT95DjSLlPpQPeBCx+ZV8aiSzE9d6SzjJC/O7/1KZV1pYmfhK3Azas175
         g6po3jU845jzjewpyMQ5TNKWEnGcaaTFiFu2+bjkQJw0oLznOpbsOB1lfthDBYuwJ/dd
         FmIibYP/RfdD0Y49JnyGp1+8j51y1ftyIxG/4j7IMh0Z3F4aOyLUZ4RrrHluyRHzykFB
         u95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618272; x=1709223072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B40b4r+ABegtiwQt7mlJqgO3WEbMRBCir96KVlqSF2s=;
        b=FsE7vUfuRY0t1WR8GVqkZcyACVeFFXNZ7+oOvdi0Cm3/oCjApX2htdhx9fXITGClHw
         Vrlw1WFCjyjegmCyeAfIouDJJZ880jGfmhtY5yeJdlziK+Jh6LVF5HFCtWC8TLyA6AFM
         lxrKmWzDXTrFvwz+TTvgufoAuidmOxslNiHtcKLcDpzZb5nSPR17Mskn9LYw3OISyah2
         iHstacy0eXxyR8JWcTcwoFLsjYezQmfffv47dfClAA5hGyowRs7U+Peb7/55GTjO2wnM
         JvimvITt2CstdaYwLgf2m0K2apnsUsT1rKIfCNSbxwUkbT1x7DakvxcRXK0nJO6hLYYB
         5QfA==
X-Forwarded-Encrypted: i=1; AJvYcCVFPtVXDRSDI/SECYh9f0ofEZunE2N/I4BiBMwDkkwKfm7Uu6AUg1fEkQC/9OsYQxKE/9LfgL/r4tk8rU230GGYUL++OKyy
X-Gm-Message-State: AOJu0Yxl6JsmzQTDQmZ62Awlu8rpuKHgqFC9gwiT3n7opQtSF8rGf8rM
	xZ36BlEfNyyvxXn8EihE+jFOJ5wYYQYJktDE2Am8GyKAKv/VD0ppr9tAzR56vrmkKXByT3WNIw=
	=
X-Google-Smtp-Source: AGHT+IEmrrpx8IE5wp+nINUhI83syufxA+Jp+kPhgAEVJtrrWmcQztCabNzm9qoyjLeXrGy74KFBRdDXgQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:f008:0:b0:607:f6f0:bdca with SMTP id
 p8-20020a81f008000000b00607f6f0bdcamr4659775ywm.7.1708618272146; Thu, 22 Feb
 2024 08:11:12 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:30 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-10-tabba@google.com>
Subject: [RFC PATCH v1 09/26] KVM: arm64: Strictly check page type in
 MEM_RELINQUISH hypercall
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

From: Keir Fraser <keirf@google.com>

The VM should only relinquish "normal" pages. For a protected VM, this
means PAGE_OWNED; For a normal VM, this means PAGE_SHARED_BORROWED. All
other page types are rejected and failure is reported to the caller.

Signed-off-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 45 ++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1dd8eee1ab28..405d6e3e17e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -321,13 +321,44 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	}
 }
 
+struct relinquish_data {
+	enum pkvm_page_state expected_state;
+	u64 pa;
+};
+
+static int relinquish_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			     enum kvm_pgtable_walk_flags visit)
+{
+	kvm_pte_t pte = *ctx->ptep;
+	struct hyp_page *page;
+	struct relinquish_data *data = ctx->arg;
+	enum pkvm_page_state state;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	state = pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+	if (state != data->expected_state)
+		return -EPERM;
+
+	page = hyp_phys_to_page(kvm_pte_to_phys(pte));
+	if (state == PKVM_PAGE_OWNED)
+		page->flags |= HOST_PAGE_NEED_POISONING;
+	page->flags |= HOST_PAGE_PENDING_RECLAIM;
+
+	data->pa = kvm_pte_to_phys(pte);
+
+	return 0;
+}
+
 int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 				    u64 ipa, u64 *ppa)
 {
+	struct relinquish_data data;
 	struct kvm_pgtable_walker walker = {
-		.cb     = reclaim_walker,
-		.arg    = ppa,
-		.flags  = KVM_PGTABLE_WALK_LEAF
+		.cb     = relinquish_walker,
+		.flags  = KVM_PGTABLE_WALK_LEAF,
+		.arg    = &data,
 	};
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	int ret;
@@ -335,8 +366,13 @@ int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 	host_lock_component();
 	guest_lock_component(vm);
 
+	/* Expected page state depends on VM type. */
+	data.expected_state = pkvm_hyp_vcpu_is_protected(vcpu) ?
+		PKVM_PAGE_OWNED :
+		PKVM_PAGE_SHARED_BORROWED;
+
 	/* Set default pa value to "not found". */
-	*ppa = 0;
+	data.pa = 0;
 
 	/* If ipa is mapped: sets page flags, and gets the pa. */
 	ret = kvm_pgtable_walk(&vm->pgt, ipa, PAGE_SIZE, &walker);
@@ -348,6 +384,7 @@ int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 	guest_unlock_component(vm);
 	host_unlock_component();
 
+	*ppa = data.pa;
 	return ret;
 }
 
-- 
2.44.0.rc1.240.g4c46232300-goog

