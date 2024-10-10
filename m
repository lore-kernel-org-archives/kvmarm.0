Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB95F215026
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584850; cv=none; b=A/c1FCTttoBQ/EvRRai7pAi+VlG77GuR6715unKFIF05BbRoy2mz6JbSw5F0YZW3ehoFo03XNP961a0KFcTVFAQvNYozlzQ5tv5ykMYyfwZyDfvqHDxmYDLmG3GjNIFvP9wW3WmSnKegLfVkeeB5ITdNvYXzH4gHCOPHXoiq96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584850; c=relaxed/simple;
	bh=hdvy6TBStdDo47jCImbsHkCH8/fTSGPuTNA399ptBEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OFLFupt/j1io6JF+rgrlFaef8OmOg4fhnfXNyODRfr8oFQLv30+evLYwRTnSwHrUfGB3Va5X0whYD0sdzE0W7QRpzDE2b9krh29BR8o7DG6PkFliBBZ7LBqsD8fHFM2g3mjf4/igjLGf/RxlXZ2i7BBUl6vK8SjXrnfO0SXKJmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txlZbPBp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txlZbPBp"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea0bf14523so1033823a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584848; x=1729189648; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t4DEWxyHdS8FH8bmPlxV35CavnLWtw4MDWneo+GIfaw=;
        b=txlZbPBph9vUSnvNiVUMd8KER4MIjcMUt0PMWghEahLGWn8roG5Lnj6siE21ONZ99K
         NEu1j7C1L2pQCmNKVHHhuwbAK5rgQf3COGyVL1RhjT6uheFWyA1NpMeFck/ojeTOXgZM
         e9iYNGZW7KaFo0Vmhit4d0H+loqRMMYsEx0CV8L+atn7AIH7NqaK5d10QUwu2LfI6Xgv
         GCXh7KaEuGZVzgi08JZD0DNM1/Hxms1XdQ1i4hVW+cAUGINSvtIYbck3sgbkIIAZCjfN
         DrODzDEEabRb0mfqQI2wxkrrzyTo2DaRV7qvffcNecJVZ3nokMWsdWBhZGM3ME44TRhp
         CpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584848; x=1729189648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4DEWxyHdS8FH8bmPlxV35CavnLWtw4MDWneo+GIfaw=;
        b=cBWRFMFmSY68oJWuK3emME/E4vEk5i1NgIvONhJdenwydU3tQmJ8ToLQ/vKKn/xngI
         EWAaaZ2WcQCv5A3BP+RZltPHNz0KUadOfz04Oy7ZP/DKwED7WyEKyh3BG81IUwOMTP7D
         FG5QgMQFpFfMRhCm4bLSXtAsUARKIAOjJGA6zyPXuEl1r0jC03aB6OVh6WWHjzqyHdth
         0xgF3NIy7uGS7hoK/6uKu5TDX1tXxptkwL37/RmT7l6AGVshcNRC7q41E84xDDP0gTEv
         Itw8ETvmnjZe9OC2quKQV2tZ9QM7MwEPAg/pVcXwEySvYLBHSpH3Ua2V3MUvlLEDzxdF
         yYNg==
X-Forwarded-Encrypted: i=1; AJvYcCUZQDNOFf0wRKw9VX7FULTsLQT3d0Muvi8S1+ee/1Z3l4PkZlysXvUMjp6GFVgLZdrSwib7ewQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywl8wYjWwuK2K+dvEB8WFf8OsD/7DmEkVj/ETqbAEg7rx/mHhbg
	qS8hKz7t3SdnyI+PiFYWkvdr0n6i5vROfQqCtnZ3RaGTXQXv6h9Hz22PgeO6xzv2zP+k5Cx6SH0
	1ig==
X-Google-Smtp-Source: AGHT+IHU1NaHt28BJAfE9+Eihx21gIRaHWD3wJUzNDiwOfeaS4l1n7K6hdxyKTp49hAFCJqVbhS/fDDFwRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:2545:0:b0:7e6:b4dd:fc0d with SMTP id
 41be03b00d2f7-7ea535b0baemr20a12.7.1728584846518; Thu, 10 Oct 2024 11:27:26
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:15 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-74-seanjc@google.com>
Subject: [PATCH v13 73/85] KVM: PPC: Remove extra get_page() to fix page
 refcount leak
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Don't manually do get_page() when patching dcbz, as gfn_to_page() gifts
the caller a reference.  I.e. doing get_page() will leak the page due to
not putting all references.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index d7721297b9b6..cd7ab6d85090 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -652,7 +652,6 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	get_page(hpage);
 	page = kmap_atomic(hpage);
 
 	/* patch dcbz into reserved instruction, so we trap */
-- 
2.47.0.rc1.288.g06298d1525-goog

