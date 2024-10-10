Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD88A1CEADB
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584724; cv=none; b=O8p0UFmuCg2KuYpYC3LyKXAU1eg3TESfhTa8GlJStjvlsQuvkOD2Ee/N5l8lWjTu/HljN7ogoZS5BMaCBKrxUpS/f+PXQe8ugPh55GO4+kYKRp+avnCku1V6b5mWJ9ZWHHDHe6S+UJmvC33w8mhcYZ2QBtEcvN6M8Xq3e5+tJ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584724; c=relaxed/simple;
	bh=rFmsStC1d1lztIwj7oxh4zyq4MQj9meeqHdDcxeq/wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BAe34OgeFBISsS2CLsGpS9Z0wFraAdc+uncTXnArcvK/7ur9OX/yE2Lp3VUp25JAWZOD5phr6Mvo++gL7OpLt4Do7nDr05O6Jpcv03P0WLvuwlRvC+CMXh8ZE7ER+HlOO78+YQRgPBB9PoitINGszHxu1B1zLxdrEevBETZU1f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dnVcK4CI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dnVcK4CI"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4fc1a2bb7so1382446a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584722; x=1729189522; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RdgAxVyxp31c7WibHLiyIF43paER00mxZOAIHhsdwhk=;
        b=dnVcK4CInxga8Vwk5pi9602RjkaaWEkHTXGgR5bB8stuIAyy4XP5hNhILg1fqb9ITi
         tSWgDzOZ+0/40DiTsTctrYnwxFGl66mIyHTQTNbETw0NNzku8KRmSeUkeckff+fhcTg1
         ArpaRPz7KD4yFXtXcmwmxlV2ZXYVX/zlTsWWPhuTDRV7G/fdrY7HNU7GLGJRBx6Lfu8I
         eShiqaKRnRo3nDg4aN0iXTayGctbzVl7jp7rUjp3XvT+9vBSHtNAZlB+bxBs6fB+oYEi
         qqupQLFXmrBMmrT6yO90meWjU5KpPV/pmoMlc0e6KdkOttBBDdH39zOYpFii7IEzCrF2
         OqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584722; x=1729189522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdgAxVyxp31c7WibHLiyIF43paER00mxZOAIHhsdwhk=;
        b=kRzh9hNJkIBsPhXv05ZEnuGBV4RElnaUvOumdS0f2gqA0LXKJeW3SE9KqvbjbFxfuz
         o+bWrdgUEXZUkFZ5/eVBqKTVpyrT3YodhPYfv86xdgqQgrzRz7CUso077+J+I5Bvvy/B
         8nuz8ka5mHBBVICzKG7gPQO6dRZtHxBoSics+WZGzJJFdW+lW3XJTI4V9pQls8VTA0RS
         XSUHygAHm2JL5Nrm2lGRh9eaVWfi8OT3DOUYnzAWH/qK+4c3mArQ4LgJ76qeAPQ7SvTr
         vDxTzZKFVAO/NxENFjbP3nGRAIw5HPpxPRYHa9qO7UaKwYGQIIqwvfxiHbD1fEV6+W0A
         VFEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWbwazHbcdCT6XiZicL7LTnpDuiJTl8Hp7GmCZx7GFmnMmX+tSyvTYQ+FWk/4hESBI3q63tdY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0tFVm5UBQaMzEtvDONNdhAeHiXJnjbxQLVIgbUU3ry47FUGh1
	yOwkQugtoT88G6yOBrCwerNRTh2AEFbthIV15WWC3z8L78R63MvPDVc0zxjC6fjZJ5N27AmK6Nn
	DRg==
X-Google-Smtp-Source: AGHT+IH031wjBK6zBugJiyQwbgM1S3WkZumhuZG0/47H7WWzE24O4tbIqX0eqBdD0TzKWzHgCchY3qP4ics=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9a94:b0:2e2:da81:40c1 with SMTP id
 98e67ed59e1d1-2e2f09f2280mr107a91.1.1728584720854; Thu, 10 Oct 2024 11:25:20
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:16 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-15-seanjc@google.com>
Subject: [PATCH v13 14/85] KVM: Return ERR_SIGPENDING from hva_to_pfn() if GUP
 returns -EGAIN
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

Treat an -EAGAIN return from GUP the same as -EINTR and immediately report
to the caller that a signal is pending.  GUP only returns -EAGAIN if
the _initial_ mmap_read_lock_killable() fails, which in turn onnly fails
if a signal is pending

Note, rwsem_down_read_slowpath() actually returns -EINTR, so GUP is really
just making life harder than it needs to be.  And the call to
mmap_read_lock_killable() in the retry path returns its -errno verbatim,
i.e. GUP (and thus KVM) is already handling locking failure this way, but
only some of the time.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 17acc75990a5..ebba5d22db2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2946,7 +2946,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 				 writable, &pfn);
 	if (npages == 1)
 		return pfn;
-	if (npages == -EINTR)
+	if (npages == -EINTR || npages == -EAGAIN)
 		return KVM_PFN_ERR_SIGPENDING;
 
 	mmap_read_lock(current->mm);
-- 
2.47.0.rc1.288.g06298d1525-goog

