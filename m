Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0A125FA3B
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817632; cv=none; b=DsBXJ8QW2loFYyeoSmIDDt2sQ6xf2GFTIkA+IiHzrJ+yfuw0XqUft4sYH8LpIv0wp8+6Y/Ssy51b3V4OgfK+7yt3yoSQS+L6bkY6u7SkSs8qhuWwLU6K1ozNWd/zmU7HFyGqIoxgAntcHA2880neu+rLnCfxOhqmq5ERhd96FZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817632; c=relaxed/simple;
	bh=sqgm1EIxKlNrAgPRJQWz+ccC/dJ7P7wFp1H9ZQzuLhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iRdrfHNj4MnjAeewjTeQyLovO85FTWGrGPPXIyQkTRtJDal//a6GZyABYB1l+icqS+hQQwTEPCfkSM4UvDmYrtmbiUqrhrW1a9Rapp2C8bZZubQaC+W5GhPEVraaK/g/l2Hpr0u3V8lfxuZrbfZNKwvbL+k4fhXRYv2W+wrMMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FhufQ6jF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FhufQ6jF"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ed2a7d475so2822224a91.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817630; x=1754422430; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JJX8dU8+n+0QNuI44F28R1+g564ctZSa7EPvc3ZFM1U=;
        b=FhufQ6jFvPeno9wz/3ho1CQB11edjoq7YZPH1YHHq5/yf+Ame2wnUs55v7tXS5hSuB
         D5wl35TCfsOztx8kZCt3Nzfbf9x3KooyTmLtkx8sRGZPKhlWYUG9QHTL0w8sUpJsaOSG
         lTaFLH2lR///RZ5nyJIYZOMqgGQkBnvd/8tBHnKvGJTQea5AxlmqES+3+KHbuE+NLxt6
         vr9uKh8N/PJluBcGjJ8F3c+c0XGSjbcrDrINtKH+NMzXMKzGVUu7OAFD6DLqOUtiz1tS
         S8NHro/YFnyiPJPL6GVbk80TxSQa6gxurDvrHUQLewqAn0+sldfQEcO+RSlPhT/DKCRs
         OPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817630; x=1754422430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JJX8dU8+n+0QNuI44F28R1+g564ctZSa7EPvc3ZFM1U=;
        b=ZHsgIIwcnOs5RJd0OnoREswy5u22onVkU74hnYNYSHdrKpvNiSMVqWZXCuJiUFfhZs
         mbUhPFi3TST/jth3XWj8OqXWj5PARjUmqEyd6Uze126tDYu8xQ9fwA0QTNJ4KHXZZSEI
         mej/eMGNQSNWFdD32b4SxIraOXwVch1qnr5QHuNvNp6/bxCuskXq7+C8xHb2pWuvfOJe
         kxclaxi5Ni0lT6i7Nj7ws+N/ohGlof+53VoPtqWEaYOiyO58j/99Yei1mgAs5o9bO0mw
         aiviHi7qZCnzr+fZJrGRVyGCKoYnb4VwOtOECcnDLXMMJJ1bp5W6UKG5jx0VLNSqyRHD
         3xtA==
X-Forwarded-Encrypted: i=1; AJvYcCXK9dnSDE2ZwIaXZgA0XNvPWw9r/VhZgKSZCfMjGXrCLyYB96rGvMfJW5Z+IJ6oJiv9y0AVdEA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDumIOWBsVAiI4hfhzVRKvDe9hDIMyWotohouYspvzAYuF4/M1
	JTMIDoApJhfHCEVGP1lR0atJi0ixnvWB/MT3B+kd6QPj30u4ihI3U+1WxzqXEBRsBFJlE+HagjM
	T+bc82A==
X-Google-Smtp-Source: AGHT+IHfEWMEuUfBMeiKYE9aLfHbALVYy3IIrBllmmLaQcn7q2hIwc6mBe+teoBHRd1eD2W+YlhcAuMLoXU=
X-Received: from pjbpv8.prod.google.com ([2002:a17:90b:3c88:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33d2:b0:31e:c8fc:e630
 with SMTP id 98e67ed59e1d1-31f5de73bf9mr824146a91.26.1753817630463; Tue, 29
 Jul 2025 12:33:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:37 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected pending
 S-EPT Violation
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Exit to userspace with -EFAULT and a valid MEMORY_FAULT exit if a vCPU
hits an unexpected pending S-EPT Violation instead of marking the VM dead.
While it's unlikely the VM can continue on, whether or not to terminate
the VM is not KVM's decision to make.

Set memory_fault.size to zero to communicate to userspace that reported
fault is "bad", and to effectively terminate the VM if userspace blindly
treats the exit as a conversion attempt (KVM_SET_MEMORY_ATTRIBUTES will
fail with -EINVAL if the size is zero).

Opportunistically delete the pr_warn(), which could be abused to spam the
kernel log, and is largely useless outside of interact debug as it doesn't
specify which VM encountered a failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3e0d4edee849..c2ef03f39c32 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
 		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
-			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
-				gpa, vcpu->vcpu_id);
-			kvm_vm_dead(vcpu->kvm);
-			return -EIO;
+			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
+			return -EFAULT;
 		}
 		/*
 		 * Always treat SEPT violations as write faults.  Ignore the
-- 
2.50.1.552.g942d659e1b-goog

