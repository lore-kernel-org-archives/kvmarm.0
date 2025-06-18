Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6621E0B2
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220690; cv=none; b=uRnefZS69a9OkazmbVHDM+VEcn3y21ZoNuTmk9Ia2rG90A0MxJfkFXi1Oj6eBGOcoJsvFQllWwlC23abJeckV9NGCebTUSlNtY0kf5qHtCgTHxgY3SUDeAKPs/KQhP0+j4aSaWM5UtAWqT308X6wEHcRyAYl3yY3APdX3wR1ugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220690; c=relaxed/simple;
	bh=0cy61o7VXZiqX2efmaNB3wv8cOwqSs6G7BooJP5WYek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ntyUN/Dfg91JRmI+WmwWXqIkcDPqAj0MesjncixSlKeZKgNFJGfJt7CizLrbPDd1l0EWJkRf9L1ITR2foo0+rGCY+ONDvi2fv9e2v7QdcQxQ7edTYkrqKtNHUM06gowC9mDqi8hOeimeuuHLzDGpuHidvP1ejPTnsVHXCODIzhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y3NbbJIg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y3NbbJIg"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740774348f6so5496640b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220688; x=1750825488; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=urfbfbke44pGtnk/FCqGVDeVvBhaC6syv0bCNmnixkg=;
        b=Y3NbbJIgS9MiZsbYZjVMklgExO2xL9qE5aZVttT0cs9wRPFRe8MwrHAlKLd27XUIRs
         eUqg66VLk7QDosgWCrUASCLfTtHBsh7XcEkSv0gkrTox19GKz/DuJYM8M/OrKi+4LXNY
         N1hKDtM/l+EVJSIrVyCmXas8neJRc9aNYHrGzPDsxieNBa3z/7unorq4v0DxUNPnxFRN
         O9MEdEDyBLQP2kYpFsFiPQP/h9W/CPxs+7rsh/u8uF+LNBrYtNb1Oe9JhKFk/h4KqqYk
         7corlDqc8mbytZz5bMpvSDsehUx01LmYSH8MP7xpxLYWejTBiyajzhNVdpDNqp5XHRHI
         eomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220688; x=1750825488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=urfbfbke44pGtnk/FCqGVDeVvBhaC6syv0bCNmnixkg=;
        b=pWtC9mUeP9tsdwjwv+sNzVZq5HI5zJSsjmGm3oyvPeXHZLAy1LfKbMLtq+JXhdbpGu
         MhayprpXxidGAZoSdUL0QhAIRxwyc0rgdyHYuhNCgatn9ygCmpQVnbJaaUuGBudww52U
         leGd8u/WBgWFEgF7l9oMD9pEj3Izvb7QlJvEaEgsZ4EX5opGXPlTr2d5c0YAXSPxqbq0
         JeXvujGo48wS5z31tSfRfFZ/g7d8H3SpOujJhHGxctlKEURMzudmZl+shKbdscctIXPG
         Z6ir3whDmbkDhj4oriUx8LxfnzhyQThL049RLN3IGw2JjdteIPKMtfawMU3QGHWMqpfk
         PhsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCPCR/qvUlUr7tovtJQDUS6JZsezI2fBJs6eP91Jh0fkiVXGsHF378BeC5/yDQkH3oRpJ5rE8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUSavqGhQNoE++NlLEG04E2FUwZyuYssnUpEdDM/UvT4tf3O95
	eSTgl3wduPBmC7KybfTzvoefcWiOe2xAZ30qNaLVPdD4k0FGtZraHo++7DNmk0vnKtIJ5C894Bl
	M6PS5Mb+UYoBEn2zmw6GMAQ==
X-Google-Smtp-Source: AGHT+IFPdIrbDlRQ72BheICD/uy5q1y4Z/C5VNYBV8bJ51Pda+epcBJA7XWiJKZlOD5QXWSznMTbbr9aSRYhmJ8a
X-Received: from pfbde14.prod.google.com ([2002:a05:6a00:468e:b0:748:dd5c:e882])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:21c1:b0:748:323f:ba21 with SMTP id d2e1a72fcca58-7489cf5c8c2mr21855970b3a.1.1750220688256;
 Tue, 17 Jun 2025 21:24:48 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:23 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-15-jthoughton@google.com>
Subject: [PATCH v3 14/15] KVM: Documentation: Fix section number for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	"Xin Li (Intel)" <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: "Xin Li (Intel)" <xin@zytor.com>

The previous section is 7.41, thus this should be 7.42.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424c..ff0aa9eb91efe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8528,7 +8528,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64
-- 
2.50.0.rc2.692.g299adb8693-goog

