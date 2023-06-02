Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA921C750
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:51 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba81b238ee8so2974527276.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722791; x=1688314791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/V1kGubGBkIfoXYJDQ07ubxHVuJGyyAsuFFc2aDgLOw=;
        b=dAmbCS03qFxxsMaqx8qnLOWwCpo8ZGOtPMgwn3xK6ba4mFWhcxkmmVOrM/FFp4vhCG
         csYUKDWxijMqxcej2K6vKAkSVdr2i2aogv33PON1lYkKZLilkwuVkkR5tkmDZYOw2NmB
         f+bWPC9zJepmJqMfdpUYS26chQ2GYQ4WbogfMcxI6nATZ4UF7ahlzhczQ2Mc1lAMmSar
         AvyR4mqbb58ZbeIeZp7LIQgxVPReaza5QvbgaJqSHiv/IgMFZsQj8va70pdSNEQxNGbQ
         AcetQeLdV65lMsliQni+9gRTp6dhl4iApuCCXFlTgOQE3m5wyp3HYTDLfS300bpYHSEi
         2OHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722791; x=1688314791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/V1kGubGBkIfoXYJDQ07ubxHVuJGyyAsuFFc2aDgLOw=;
        b=jbhRtuckXuhLE+gEMjcD599i+iYcXe7OlRb0KoXfQRA3MaUo0H1WC564iK6uaMnOqN
         dikTgDjSrx9TMBZX+cPf67FWi49fqA1SpYVh2wlrHRxCJYhqL05oJyGF1RwoUqcpkQqo
         1Ys8NljAivLY222pwTOidkk3ZTkFpWa2BuEvGWceZ/IMfLGJ4E45dZPlLAzj9y7Q0vtT
         SKvIIAw/cIXmMaHzIuwH2qX6+aXt0nK708gfRbzZMvNcwZVzFopcavameP5c6O7TF9VK
         Wa94ODs6YJXMShn3NUKiVqgGeKgqLf2YkDi2GVb/XsNZOnmIFPvyghT4Ztsc7JZCbCzt
         c7cg==
X-Gm-Message-State: AC+VfDyx+K+DHuNudOFBGaJ0thR6dLKt5ffkeVgqv6Z0JB1xolvV/Mdt
	ll3zG1De1YBJfjHOqmgJgbskj9iCg4E6BQ==
X-Google-Smtp-Source: ACHHUZ4+4GemqH/Mjtd/gPSOa8r1fMjiXMzCqKk+FgepMOQ0q53LG6ACHpD2OnBz7aqhvf26Wx2mOHHyWhAn0g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1021:b0:bb1:35e6:6c4 with SMTP
 id x1-20020a056902102100b00bb135e606c4mr1245366ybt.9.1685722791063; Fri, 02
 Jun 2023 09:19:51 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:07 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-3-amoorthy@google.com>
Subject: [PATCH v4 02/16] KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN
  at the start of KVM_RUN
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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
index ceb7c5e9cf9e..a7725d41570a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11163,6 +11163,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (r <= 0)
 		goto out;
 
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	r = vcpu_run(vcpu);
 
 out:
-- 
2.41.0.rc0.172.g3f132b7071-goog

