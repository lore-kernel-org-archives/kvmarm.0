Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59631C3BFC
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339659; cv=none; b=a4djdFrKYO8qW5M7DLv05INjbIVzRjYgQwvceRQshG8QSZpcb1k8ly9btG7kFEfwg3SJRJF7GixQmfVt9eR1M/dKVGKss7BRjuIhIAr6vwAA/XOroNOWeWuKlbe85oJSMfaDAVgUePcgc4YWVeNH5K5M1xnIkwE8YvgMXxiZypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339659; c=relaxed/simple;
	bh=Pe5YIDGyVsJn3IDNSsuwg/PtWitlNtJM3kxtfZFGD8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NoYZPdSmmWEPE2cCOhs961hVeHS3mlNVDcwnkKN8F+MYfaeEKZE9Ca9+Ae4j7CUvZu7xmIQKn3Ap9VYFTGRk38I4Y2fN5r352N1TQQNJUwyzP039f3+RmtDwfqJeT7NA+H9M5YLnsoiWoGzrnV/248O/NkfFzzFz1KIDTEykHko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4NV2kfsy; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4NV2kfsy"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-5f206aacbceso106468eaf.2
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339657; x=1733944457; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifppD8XOVrlj0Y18bnChdCi7ngFpMAIfTyMrOgFm5Gc=;
        b=4NV2kfsyAV7R8XSBz7M8t/CaQeNlNkJx3CLvdCBhRXw1FhqlHmYyqxm3iMIW2R+7gV
         QN9CfXhDh4g162YU/RpYxDpmmkpGvbm1t49Prd5/x2CgMlgXsH4XuCz3rjUgQ+NpvHda
         medKdgMfyYH5l3mKTv1gA9jCsvFRim05sm5rCxMD+N10J9HzHcszt85i9FPdGo4v0XU7
         KlC1g1VDy7gh6qw9TL5KGhZASM96mTYbc/V/GQIasJGuPnTGM1OsVlbwBOjYxu1w7fHL
         G6NEP3oYcAp/T24vdadhopRNVQZFWbenTlXFbK3WZMe4bzsY//MHMWI6Ki4GOat821Vr
         GNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339657; x=1733944457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifppD8XOVrlj0Y18bnChdCi7ngFpMAIfTyMrOgFm5Gc=;
        b=wTrGqDMom4Ip3ZN0V90XP+H703Ld6hCh9IOIazUwhtOBZZFOTJMzNXq03ymQIDWaEP
         UkS69HWSqKu2OxBMw6AHwyzspQYDU86FZb+v+Aam93e9kvC4mmZvAFoiTgtIy2FhlOQz
         F6ZZHxXAJXvhIPYWihWO4eVtiMPMiBaJVy2fz2aXNGh5MmidEReSynzbG+eOioVqykrf
         ebDy3qxnrLs5LzhyzmU+N9CDvmKJskkOjQxEKkivAWRrzmD8b89RQ7PtZ2Gc3XCSLvnA
         j1kBQvsWqXTkEEkg6HQqjj108++1ecvjV3/+j8YgVuQ6QyosiYv9lJDQhY9ieo3U8oWA
         xaUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzE2GF3/xlJDnyQ5QXi77SLt9OhHzn5Pfqzs5xPdaRn/Nwzp/fGhUw93P1BXS//uPWAJSoOpI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz97BYNUbj2GGAjm03CM2sQxw80VnJEBKSTqotk0+adRBhI0+0s
	Wecl+4C6JieUlTZ7HRjVrBatF+jDjMp7T9vUeHZborJt5hOhrZCpaOdq4Dm7BpCEHIVF+f+8Mdu
	aJvDqsGVBnF2R87QIgA==
X-Google-Smtp-Source: AGHT+IGqVM1yUneXF0DiEvK0H0RPVa3NLvh9Vv5/V4X8bp9PJGOl+SW8n3O2HwvzvAHA/QzfxuBonL+2sIMiSocO
X-Received: from uaf26.prod.google.com ([2002:a05:6130:6d1a:b0:850:15b2:33d7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6359:230b:b0:1c3:94:8ffa with SMTP id e5c5f4694b2df-1caeabc2133mr709229655d.22.1733339656984;
 Wed, 04 Dec 2024 11:14:16 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:37 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-3-jthoughton@google.com>
Subject: [PATCH v1 02/13] KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This flag is used for vCPU memory faults caused by KVM Userfault; i.e.,
the bit in `userfault_bitmap` corresponding to the faulting gfn was set.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 94be7e8b46a4..641a2e580441 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.47.0.338.g60cca15819-goog

