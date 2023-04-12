Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D155A936
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:19 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id t66-20020a254645000000b00b74680a7904so13784677yba.15
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335318; x=1683927318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qcXR+cj62Nmz/QQQB2g9N2pbdYpcmmyV5nmt0T5Wjo=;
        b=jKd+t0UtWM9xdOiqGRYNFX92os/otTxaJl4Aq9bIi0v9GANiTqkZBL/I45CujgAQS6
         MzK4MDvKOetboWsJ3AHeOfQd/NePDJlf65y7kIDGm3MVGQnsV8BAB2K34AdrUiC0Dhn3
         ETjJ1PEuxflgPxc8u+TwmpiZ1VExPHDqjNtsatLtld6xdOsm/BMr4fHWr2dAljkvCJ9j
         t4SUTI6Jq4R2QOZv+CxYoQeTRoneT7k0B1dC9jqxfcJA9b5ur1FurjeI473lS5euST9Z
         FDKBAA7J0WRtJLH7ZUmGAUuavMkA+9wKoI/V/FPWkmO6R2om6cXKIV2IivywVuTD+ZpM
         j57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335318; x=1683927318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qcXR+cj62Nmz/QQQB2g9N2pbdYpcmmyV5nmt0T5Wjo=;
        b=h3VDpjohGewZffcs2vcJGrcl5oX+wXD4kcdWxPbUnW1d3pHZhz3k/pampdLpn1sWkg
         B3CeIS/ft2ZkamQ9gnFDfZEbX91lRkMb4oLSsrCEaoMZJMbVnCk4kSgwYIu08LLKBALt
         lHSmy5E7rl0Als2GaBQ9/IYai501n80c9Zl5OhhLXjhcZOe6iGM7forGhZOiedOJht3S
         wN+mNqOdiAixgx5+dZPEEa6NTe5TJOMPKIxiF6JbGRjjJ6FcOYxXKyiZHWhJG5Ut+cNo
         z6b33WP/8Cw1d0fgQftyQ4EDRidSItiSD8pBvQuo+prynApX3d5fQ2NgXnY7+1xo1XsX
         YyVQ==
X-Gm-Message-State: AAQBX9cMBNY8lPOM4SXVBfxjO5EHWrQstTP27g84qoFUz8KtLR71VFuG
	maq0B6mJVkvu78pXN4bqLjwRAesGHx4DKA==
X-Google-Smtp-Source: AKy350Zu8+mZvFG+GBSeyU7SYAPl8PpXVNqqRPXN8kTxiuOldRi6f9+m5WF52N2/PJJYK1MSzUO1lNI0nmUPUw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:cb97:0:b0:b8f:52e6:69a8 with SMTP id
 b145-20020a25cb97000000b00b8f52e669a8mr753519ybg.13.1681335318559; Wed, 12
 Apr 2023 14:35:18 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:34:52 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-5-amoorthy@google.com>
Subject: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN
  at the start of KVM_RUN
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Give kvm_run.exit_reason a defined initial value on entry into KVM_RUN:
other architectures (riscv, arm64) already use KVM_EXIT_UNKNOWN for this
purpose, so copy that convention.

This gives vCPUs trying to fill the run struct a mechanism to avoid
overwriting already-populated data, albeit an imperfect one. Being able
to detect an already-populated KVM run struct will prevent at least some
bugs in the upcoming implementation of KVM_CAP_MEMORY_FAULT_INFO, which
will attempt to fill the run struct whenever a vCPU fails a guest memory
access.

Without the already-populated check, KVM_CAP_MEMORY_FAULT_INFO could
change kvm_run in any code paths which

1. Populate kvm_run for some exit and prepare to return to userspace
2. Access guest memory for some reason (but without returning -EFAULTs
    to userspace)
3. Finish the return to userspace set up in (1), now with the contents
    of kvm_run changed to contain efault info.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b12301..ca73eb066af81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10965,6 +10965,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (kvm_run->immediate_exit) {
-- 
2.40.0.577.gac1e443424-goog

