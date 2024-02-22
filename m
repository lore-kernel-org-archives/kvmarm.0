Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D615698F
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618308; cv=none; b=mcgk60Gr2Awy2+N/Wdl25bVoni9YslMCWt21I+Pxr7ZtnyNB8TwVxzxISBXMY3z0xbik4sN7mZDXhWv7HPpmLp6EtraNpya16znSYNr/+F+chBQyuI9TXi+fqIYf3zlX+4tDrdBwLzB63eyLKtUZmcwG+9PTn0btZj820dvvjMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618308; c=relaxed/simple;
	bh=d3ZeocOs4Kyg8UrCOOCwBKEbac3l0L4Q+zVvMeYcmug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jgryDb0o9bmU+666/muPAqhS0t1o15KT6o4HVGv+IU+LJuM46w2rf6fdAqOQ3Brqb3IDHIsGvbfmZEhJ1mvKQo1dhOtNeCVNrCGOLpusio5r4JVSpBfR3xoBE1E6TW+xlojp612sD4mvlW/tE+V339ID3dAKZEXFVegaUa8XTRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOuZS8Wb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOuZS8Wb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-412792ced95so8207695e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618305; x=1709223105; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Wm13XLqZtqI/huCH/OwOakJm6WxWY3N6/pLv1GzC4s=;
        b=fOuZS8Wbw3pHYLkFZFKOOL2dEjQETa0laHuyRHKdOYSZgLr6de7bwuQZmjSdZl6zer
         kt1x8JVd8LgE4Pfl37BWv0+I6uByPFLu74ABdp3gsEuDNl7EKYWEadEki2HhfL9z62YW
         PIOOdUAbr1v5RUYS4kdfA3YvaRjTaZyUDtZKElKUXempcv9mdVPKHINPdhZ8BjLbVZVI
         xal5JZ4tXAr9YwyEXz3GYwIMJWfaW5UYfyIQAd1/3PtBglZl1DK07N3JCujeATDAo+dK
         irNIndyylRn3HZ78wlxYXdWsjHi6Uc1NymDyYhU47CJ8SGMs2lQ3RO1MWIb5NbtPRbke
         PcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618305; x=1709223105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Wm13XLqZtqI/huCH/OwOakJm6WxWY3N6/pLv1GzC4s=;
        b=jfRm7/vlTp5uFFzzY0o/Ci5m7OcAdq/eGx8u2lfbtqcVZYGf/MhCu9rceDIDL7LN91
         ZqTwrFP+F4HQvlOa9o6//qzuOcKDkxWDUgG+ocAHDDkXDAgykrmesZg4TXKA0MwpqF+y
         ZxDgzJ4RTG9A/I+T0vQ70QusQGen0wHKQd79NNRzVdYLpKCoqmIWI3Dj+lGAj3/Nqwb6
         u6vJNuJU0u8+Aztl/FvirmFOHxCPKYYDdsRgZjKyUIL3HjLc8CWmoIytZtCUCnqRjeXI
         m2PvLplsiWXjXiUHQlUHb0eykX5lWYnMUBWdCLXI1maV79qrJI308lxitAJ5oHDgeKq7
         wCBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXuRSxhq6l9IMzuevxI60WbVIICDYbC9amwI0Y7HRQ3sgffSubGZs1eWxN+qirpfqoQ82pVDTI1/cOglqH5gqpzS6lP2vF
X-Gm-Message-State: AOJu0YwKCdumKtQ7GHdeu6Xwgxbwa4kssi1jBKNDwuuc/naPAyWqFm/M
	4ozJPEKe/c51/8A5ar1lijOZa5EM6JQCGwiSO/cwrWbekyX6bYAi9MQRuZMETCk7MjoLLIzqMw=
	=
X-Google-Smtp-Source: AGHT+IFd02cd4+mhEBrGL9G06htVBY7nFke1Fhf+G5eKfge3JmeTjKERsofCDEYCArQ/kzkItDMwf2BY4Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3490:b0:412:8d52:573c with SMTP id
 a16-20020a05600c349000b004128d52573cmr6427wmq.5.1708618305241; Thu, 22 Feb
 2024 08:11:45 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:44 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-24-tabba@google.com>
Subject: [RFC PATCH v1 23/26] KVM: arm64: Check that host unmaps memory
 unshared by guest
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

After an unshare call from the guest, check that the memory isn't
mapped by the host before returning to the guest.

If the host has acknowledged the unsharing, by marking the memory
as private, but hasn't unmapped it, return an error to the host.

On the other hand if the host has not acknowledged the unsharing,
then return to the guest with an error, indicating that the
unsharing has failed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hypercalls.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 56fb4fa70eec..23237ca400ec 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -24,8 +24,45 @@
 	f;								\
 })
 
+static int kvm_handle_unshare_return(struct kvm_vcpu *vcpu)
+{
+	gpa_t gpa = vcpu->run->hypercall.args[0];
+	gfn_t gfn = gpa_to_gfn(gpa);
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!IS_ENABLED(CONFIG_KVM_PRIVATE_MEM))
+		return 1;
+
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		/* Inform the guest that host refused to unshare the memory. */
+		vcpu->run->hypercall.ret = SMCCC_RET_INVALID_PARAMETER;
+		WARN_ON(kvm_vm_set_mem_attributes_kernel(vcpu->kvm, gfn, gfn + 1, 0));
+
+		return 1;
+	}
+
+	/*
+	 * Host has acknowledged that the memory has been unshared by marking it
+	 * as private, so check if it still has mapping. If it does, exit back
+	 * to the host to fix it.
+	 * The exit reason should still be preserved.
+	 */
+	if (kvm_is_gmem_mapped(kvm, gfn, gfn + 1))
+		return -EPERM;
+
+	return 1;
+}
+
 int kvm_handle_hypercall_return(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->run->hypercall.ret == SMCCC_RET_SUCCESS &&
+	    vcpu->run->hypercall.nr == ARM_SMCCC_KVM_FUNC_MEM_UNSHARE) {
+		int ret = kvm_handle_unshare_return(vcpu);
+
+		if (ret <= 0)
+			return ret;
+	}
+
 	smccc_set_retval(vcpu, vcpu->run->hypercall.ret,
 			 vcpu->run->hypercall.args[0],
 			 vcpu->run->hypercall.args[1],
-- 
2.44.0.rc1.240.g4c46232300-goog

