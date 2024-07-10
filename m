Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82B015FCEB
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654969; cv=none; b=GZcw5jTc3RuKkH/vM5Q/Dtl0pjAyoGh3pH+aXi71QSF8Tx6LOe+h/Y8CxFR+IYV9zZKZpcdK8of0obuiJhwOBmj0alBUD7RkN57IZO75NTve2XBFT88ZQjLgljlpEicEob18w/tbxza1iIMagzcoB73vOmCmltxOklv8qBfwzMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654969; c=relaxed/simple;
	bh=EiaFG/eYwx8Esdk1XHkxgkjzifP+kflmXrizk7/imlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Eo8h467dMORI+tYCmveM2Ti2fTdORrr53nkpvQtqySJUHJwD0YTYW2lOAPxU+tJuO+Bw+E1aFVk66ZYOYQnLHnQkVU9YWwP7E4rF30ALovTIWgT8yRqSjTtWpwDVCb8WMjUx01AyyNPQJDH5aOfU8iIZBdIpMKXMAXijilgT8yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QOC31xbg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QOC31xbg"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03a40bd8afso513346276.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654967; x=1721259767; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=45lnTGeGmxXRWR2sOGpDAv49wjAnxo1Jn2Fj4ejBtf8=;
        b=QOC31xbg8QVbYvY56UYlBdIviiEumSEbhx92N8l2uo8zFxn+klxt/epCnr1hfBi+0n
         eo/XIPMJwTeXN18QF6b/U2F+r6sB3wp3Whg/jIjLe5PyfS3EWpX9FQEGyh8h+TlZ4PB6
         aog/BbxBPj9KpJqmY0+oN7xvAUh6JqDDV8bVMRcM7fsSodMtcgfBoDDE1AwTH1iFhe8z
         niL1UXp7f05K1EKPuGSTlg6mqEIJuUr++2KcomgqXp8KtAT5LP/mgMZ3VzlPqg6s9FRK
         6mRwtXAIiVaWnErvwLvG0/2juw6hHpKeXJnxyk6jCPG9NQnEO/NJuxM6xOG5oXEJLEWk
         eGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654967; x=1721259767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45lnTGeGmxXRWR2sOGpDAv49wjAnxo1Jn2Fj4ejBtf8=;
        b=FnyHHEH94G3YAXZUzThX4p04nZ8ACHsvCH618Gmd2XA8cbNUp8lywf9oxI603GTVSc
         HIaQ+MVVtH13bA6ptvVY0w0PlAX5qwHlrab9Gok0PKLe0466fOG0GclHFslTv0rygjk3
         FCKYY+nh3z0HB8RF+TkzRlap3clTJlxQS3Z9I8bh4Mk1IesmjFnzkOJjf490Lfx3+BiG
         v2FgsrKXXhJYTUFg6M7+ZG1dhvyRf9/URmpnymCWe6u64+HctRvHph0SGiPcpeVIRQrz
         pkPZP1st+MnAKe64B2oCYGkhEE2eNKbra+5eDbAfSmbxo06Zxq+Qyi8iEmC4ismrRTnX
         bpCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbLc36WFtaq6U7eQ501QfPOpwkku9VlPQBBiPZ5LTk52Jmi0v1SB2uhOvEEra15VBF33+dkLSEpQAkyOuS0lyZb2Jy+aOM
X-Gm-Message-State: AOJu0YyFxyhe/2wDfet7QR0gJ8/pLGsyV6jgu7zmfC3AcUWNlEKNlrE/
	cugLNRzy7nuHQpncpiDsvxYQr/nuE/RBbK2m+JJfmPFnSZ2xiCg0Wf6z2PHwFTVRduSNrfGvZIy
	t0c8ZGcCsedjsQtSb/Q==
X-Google-Smtp-Source: AGHT+IFCxPs0hzUflzzz70jRYwVRx4Gd4jDUqm7Yw06oBbmfCbRIBM9zwU8x8QPsTa/dYviA394CpxXkoxFldKzv
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2381:b0:e05:65b7:32d9 with
 SMTP id 3f1490d57ef6-e0565b7352bmr91773276.6.1720654966908; Wed, 10 Jul 2024
 16:42:46 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:13 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-10-jthoughton@google.com>
Subject: [RFC PATCH 09/18] KVM: x86: Add vCPU fault fast-path for Userfault
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Without this fast-path, we will take the asynchronous userfault path
every time, which is inefficient.

As implemented today, KVM Userfault isn't well optimized at all, but I'm
providing this optimization because something like this will be required
to significantly improve post-copy performance. Memory fault exits for
userfaultfd were proposed for the same reason[1].

[1]: https://lore.kernel.org/kvm/20240215235405.368539-7-amoorthy@google.com/

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b6a053758ec..f0dbc3c68e5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4380,6 +4380,13 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
+	/* Pre-check for userfault and bail out early. */
+	if (gfn_has_userfault(fault->slot->kvm, fault->gfn)) {
+		fault->pfn = KVM_PFN_ERR_USERFAULT;
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false,
 					  &async, fault->write,
-- 
2.45.2.993.g49e7a77208-goog

