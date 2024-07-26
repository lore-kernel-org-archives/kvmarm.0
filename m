Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF8717F4EA
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038026; cv=none; b=BS2y+dDq/rZhhg+2n5dP+rnne21gP3mNQZZmb8WAbBNWzf3x7+Kzf54/qQRJOOiIff4Ni3/iOTxPY13Vr5KApaGIB0q+3tuLeErRCi6LdKH+MQdLBE5I1od/CBZk8S9oAIaZNaEY9f2SvsUZqOT6X4BswdlLCI/VvzJ/tx+IEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038026; c=relaxed/simple;
	bh=uf9ms+u2NfXkgc6o314wQs4yJxndrotou5MTD6pjg7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GfBEXzX0mnZoamSjVJwQFeet6WDHE2OPHDhU97io2/M5hozJ0kICmUG9Rn6/KNMeu4AY3/t11p07XUXgmouDveLe+5sSKgtHNAJC/h42910Ck4PfBdOnpb6cMEqaW+jLG8fvtyQwg8ayC0+5u7XD5jntpw5aZY8SJst6RdqSJjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l21dYVtt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l21dYVtt"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65026e6285eso5570537b3.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038024; x=1722642824; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bC28fbRseb42Ch2zMqBFWEix5TOk22ZdgToO+ip0K/0=;
        b=l21dYVttetvCz4UMPod5XKROMFtpJhnQ0ryZQFqATLz2l7sm4zFfK8YucYd/R4mPOG
         MKU8BtNd9Gf4sM5cwkgOI40RNPngBuq/1l7LmfSiV2WRCp8lTMk687qcWqVHmibp3fxu
         Mkt8ZmSXB78+PtD3iSEYbFohrGf3mVaNVag+ira/92YFWRhH00ScmrxHIYlvM7niKZhT
         tcjtCr1kHLUuOS17wLiVUEHP+6j9EKk8rXuGsigwFM86lETKwFdVIn4c+EV6AKwmFl32
         MbczOaHlqQUjEliWU3Q4Ux0v2l7hhOuQqbixMxq8/nkHOBERhiA56ngJwanzjnhH4Qjm
         BuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038024; x=1722642824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bC28fbRseb42Ch2zMqBFWEix5TOk22ZdgToO+ip0K/0=;
        b=YZmas8v+u6dUSnO9SiqU62yk7yvycg2cOfmj8UrzUl9WXkIzxps8utmxbJ+Ys6qkwH
         TAh4oZYRCky8klMxGFk4nnHnH4e2A7qI70k5JYBQt/7MIWPXfOBicLn9HoEzfSjRrRrj
         9dmI3x6aVSERABJmAumXz2tztaRX43Uj2X03IvRrK3yleJQpiWtCkKcMhhEQkde1isGE
         outR1zPo8llUC/wULNHsyZb+/DBgMqG5wvfeIAiUawWZcvrBsDj98pm0wHMzWvl9D/aB
         5IVYyCyCgBE3Y5aIzk/GEh5fmlv6hj/oIuEult3aGs3DcAU7XiibMwq02F70sE7o1bjl
         Vnjw==
X-Forwarded-Encrypted: i=1; AJvYcCXqruOiVS0jP7M04g6dcF40mMACRow8VH1Yg4pmoVXbl8nF0E7+JCT/l9vTXFoN9WFxc3eMZEfOAnfw6BCq1HSgakHQG13+
X-Gm-Message-State: AOJu0Yw96x1bu/yxmDm9XnsjUacLq/SB+tMnkcbosKn+623d50OrtDl4
	wcGw2GpdcSMF94EooEPjQC+pcdIf3XqHrQWu74CQZtxtVFSNIJUwAI1R9PHlNQxA/kdp0IG7jk2
	xSA==
X-Google-Smtp-Source: AGHT+IFe6CawsiHghHJz6goDA5MI5OiaYSIvtgnV/oY+y/tLOOW/H4O66kyosfEcqs3UQ2nQeG3uHH/jimU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181d:b0:e03:5144:1d48 with SMTP id
 3f1490d57ef6-e0b5452490amr2050276.11.1722038023813; Fri, 26 Jul 2024 16:53:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:41 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-33-seanjc@google.com>
Subject: [PATCH v12 32/84] KVM: Get writable mapping for __kvm_vcpu_map() only
 when necessary
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

When creating a memory map for read, don't request a writable pfn from the
primary MMU.  While creating read-only mappings can be theoretically slower,
as they don't play nice with fast GUP due to the need to break CoW before
mapping the underlying PFN, practically speaking, creating a mapping isn't
a super hot path, and getting a writable mapping for reading is weird and
confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a46c7bf1f902..a28479629488 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3142,7 +3142,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 	struct kvm_follow_pfn kfp = {
 		.slot = gfn_to_memslot(vcpu->kvm, gfn),
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = writable ? FOLL_WRITE : 0,
 		.refcounted_page = &map->pinned_page,
 		.pin = true,
 	};
-- 
2.46.0.rc1.232.g9752f9e123-goog

