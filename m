Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E9D38DC4C
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044561; cv=none; b=LiXd/yudNwvdUHhI8fvAga4YACCEqi+UcfvG8/7ot25J3XP+7iceZfax8EguUOfzCNAW+/5zd0HAfpmBTMP7CwBw1owsOBLQQw/PphXPtKqDz/+D6rWKUUF7jg3kUOWB2ZrH78vESJd+mPDXcMZJLFuRWgtdWNZnRlhQzL7tDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044561; c=relaxed/simple;
	bh=M2Ifb8ZR+HwA/H1LGAE2C/jP4eVMt+pmNz86ycTCoCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=quh36j05Knuq33usEa/BAYSyj2QSBO161ahGRWkMVZPUvKowUTF1+0F309irdw5QAiBjAZ4htYK4ef2ihkGwV6kreS3sTP0TdZblVvTBsRRUiKHCvE80nkZAyneUcpDhNoGFyJmPK6yRd8ztddzXvXTk3dkii9ty089B/nLVoGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kFt6ESKj; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kFt6ESKj"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d5d00fd19bso13649905ad.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 02:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787044560; x=1787649360; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7jHUMARs30oMku7rrAHEp5fhgY0hNDCAk+0nqtnlfj0=;
        b=kFt6ESKjMkzGjMWLXys4zIZN5FM80wnvUbfHtyKQd2ncvyqcPhWf6yH384nS+xlI0s
         dQFvS/UAdTboEiEiIiH21RIcdJ00yqv+LJJso0L4yc8pjNIwK0ZU7qBs9coGuGEuBsSD
         e6Jwkb9fHGgM/iYscaToiuqmUivbG9Vqtw7zXBvK+YMwnh0J5J2hiTq/VDpKEopJr4KJ
         3YkLQ7YiN3nsraPzuEsrIZpEAHrkFqu4oCa6IRqCEmkYjRnvI3Q0lletML4akIQg3xz3
         lGjrD6ujxBnj3sXCC9rtAo3mSiYwGYE/jkBF5X69PujZMyGtMGs18IkPUoPXfyJxgcaJ
         uwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787044560; x=1787649360;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7jHUMARs30oMku7rrAHEp5fhgY0hNDCAk+0nqtnlfj0=;
        b=Xc6AfXPinTDhZ4Kd/dKUN72OCV54NUShqI3RaDM2A2uirrVJpXOAAsmeOcBpu/Xj9n
         W3BLoNqqA5MaywbQOVhxRWW8pyD70Pw07/rqDIde6kHlZ2pbLmRAjNoLr8Q4E2apb3/u
         aredcfEb2tknCIkvIV9L5HAzyCEOmpxnssKRopeeZk/7O0WLJdkFoO/32371gkoulzvn
         bHF5EhNljN00Tp3JFraU4j65XPnAHXYudPJE8WUC8IKXFQk8hVlKh8YPDw8h3r5QF5x5
         Z3kXDC/WsE3z/vOkIJ3prSJB9vmF8l6stjjG60Xa8hw3zY32mN6MkeTEITr+gXBU4QOe
         62kw==
X-Forwarded-Encrypted: i=1; AHgh+RpDrErSMm6oRa1x4RJvlrk/f/i2kHAYNF4kZOcyOILuVGJvywtIHrVB8MEq/xoxMoiiz/HZm4c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFlB+O1bkbO9HQZQOh2oHVYVxCZjD8dhH0Gh61Dg9Hm6ZD3arx
	nOkqLTm19PwHLiCkd+CfOYTiQJTjqIZwLKhfpCMtgE+umZV2ZthJRFW9bCFTPxgoKHLf47lLwJU
	lo9Wa5AtLGTK3Pt17TOiyM8ss9A==
X-Received: from plbky6.prod.google.com ([2002:a17:902:f986:b0:2cf:75c1:ab87])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5cd:b0:2c9:bf82:dd11 with SMTP id d9443c01a7336-2d5c4f38113mr76619975ad.7.1787044559821;
 Tue, 18 Aug 2026 02:15:59 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:15:52 +0000
In-Reply-To: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787044557; l=2004;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=M2Ifb8ZR+HwA/H1LGAE2C/jP4eVMt+pmNz86ycTCoCc=; b=j3bFONysasSYdfRKZGzzTAvRwhttD2/ahY+24IAmXMaUu0NHy2Fu2f+igLek2uckCdA21JPeZ
 SpwDdadSI28CzEHJTFEC/85MZAcMO0lcD0WYLfkAzsYZ/YxzsQNemOq
X-Mailer: b4 0.16.0
Message-ID: <20260818-gmem-no-return-page-v2-1-5298f42d49bb@google.com>
Subject: [PATCH v2 1/4] KVM: SEV: Treat unassigned RMP entry as benign race on
 PSMASH failure
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

When handling an RMP fault, KVM attempts to split a 2MB page via PSMASH.
If PSMASH fails, the only expected return value is FAIL_BADADDR, which does
not distinguish the reason for the bad address. Hence, another RMP entry
lookup is required to determine whether the failure was benign.

Specifically, KVM re-checks the RMP entry to determine if another CPU raced
and already smashed the entry into 4KB pages.

A concurrent operation (such as guest_memfd truncation or hole punching)
can also race and transition the page to shared, removing the page from the
RMP table and causing PSMASH to fail. This can happen even if the page is
still referenced by KVM, because guest_memfd reclaim transitions the RMP
entry to shared when the folio is removed from the page cache.

Treat an unassigned RMP entry as an expected race when re-checking after a
failed PSMASH, and skip logging an error warning.

Fixes: c63cf135cc99 ("KVM: SEV: Add support to handle RMP nested page faults")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fcb41dfde4c02..b2738362a928b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5074,10 +5074,11 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		/*
 		 * Look it up again. If it's 4K now then the PSMASH may have
 		 * raced with another process and the issue has already resolved
-		 * itself.
+		 * itself. If it's not assigned, then this must have raced with
+		 * another process that made this page shared.
 		 */
 		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
-		    assigned && rmp_level == PG_LEVEL_4K)
+		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
 			goto out;
 
 		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",

-- 
2.55.0.699.gb54405d56f-goog

