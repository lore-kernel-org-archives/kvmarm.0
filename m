Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5039154C17
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618287; cv=none; b=UekSvNBphz2gnww5+0iUpnsODgZmqWM//62tNu2THSP4y5pqy+cn2s9D8wR9YZpUsrEOMmj/RSjAvi8KjhsPrKfZvSLXdUkNM6eO8mSRrF6L5lt2OfJL1IjEQGxoC97ItUFQtCT4NMWtiNbM7SvBC+AKgQAN975JVdJ8Ip933zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618287; c=relaxed/simple;
	bh=1fhJh/ibEAt9iibbZOz9A9qGlg/9anxYzd7bD0l9kms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ked0GzRoePiRSoSGZLOASp927i8hxAsdW0nJUqCQvzvz7Ljyt4ragKD6gLNmQsUXZ9psvGBOspzjoh+8VQ1A+FvcgVlbkf85TGnA3z2j2LfNWHFEzvcaXq54s7VJfk0mKuYhGRd/TgSITTyquEjqn2eRkV2AAkGXB46K87eyaV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3wXsHJt0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3wXsHJt0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41252993d8dso28747645e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618284; x=1709223084; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JeXGqmOcCD6OWH01LjQYoqIdkS33u4slmuUVqoK/zr0=;
        b=3wXsHJt0gCZ0oQ2hnsxPZNc1tUV06sT7/rJNgJSgZyUUOot3cA7+dxTqr5SKKYwBwi
         lTjUjK+CCiG6FNaQJxe8FoDlJtclv1MdWoi45xxK+iHLOq7IiO+BF4kkuiymRPnjDA04
         LYI0phTorXTAIPOA3rIcN9pseKvaZO056EKNT9Cw4FrYWF69tY9VkJR3b+cUWmItHaTB
         4BLML6/9+l0TaA9Mf+NUyprjODVekiIjISeDCMpw7y/hCzPd2MFpl9yPOgWdcg7ZMXkl
         YfHZ/ZRhctWY+uqU0WF9udp2p+QSVeZkTCfsdhqcia9YxvsvWdFgJDkAGWPRMKaiUINT
         SH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618284; x=1709223084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeXGqmOcCD6OWH01LjQYoqIdkS33u4slmuUVqoK/zr0=;
        b=ERFxaNYjP4W3Pr4+qIc/oGR8JHN4UiqSdEgrJfEOFXM2p1yNGaaBSwVNKAvyZp1yjy
         hbdxwKgOHrRNwgKbggzCGrScJHWGSlGKY9Wz6H/hDEEfnnQ2FfSxWjGVco/V7WwUGLf3
         iLjV2ORW1Ki+rUNgL5jlj3g/roZQVPH25Suu3K5WaZJQAi2htso1PYEzBJRWqoZv1QlH
         9Tx0u1B9BaZKkIhTpUUXZbskwSLRcayOs+YqI3upvIVqNAeeN7VXx7Da3/6aXZJFkgsa
         dLoH797YfZKdt+ejp1w4GCZ+VzS9l/QcA+fOc976YZMTRHgY8krGJp54X9nESwVvCaem
         4Ybw==
X-Forwarded-Encrypted: i=1; AJvYcCV/HHkQY7FruyKQtj6MzdDvRZh7j/19+eLxS/UePNqycIYBqcgAKOgHGA3imjHPTO+2X24/6TRQIZkwpbaq1curaK2OJoWv
X-Gm-Message-State: AOJu0Yy8u9DmUB9iMcKSSKQOnZbf8dzcwyUiuk1drzbUvyVX+UBaKY3W
	/rY5qT6Y0XvfyHTnHzGTRY+LRG0hQbrG/L+TXU9lAwSfkezkDbmYyNNYWXLUf5QKvOlha9gfJw=
	=
X-Google-Smtp-Source: AGHT+IHKd6JqGW6Vstnw5Qq8fNH5c73bty2H414xCAYg3AGlYLFMhVl1S0JC1GCtT88jjKDZLnmCrPVUzw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1f17:b0:412:72d3:cfdb with SMTP id
 bd23-20020a05600c1f1700b0041272d3cfdbmr24338wmb.2.1708618284296; Thu, 22 Feb
 2024 08:11:24 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:35 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-15-tabba@google.com>
Subject: [RFC PATCH v1 14/26] KVM: arm64: Refactor code around handling return
 from host to guest
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

Make the code more consistent and easier to read.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab7e02acb17d..0a6991ee9615 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1085,17 +1085,14 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	int ret;
+	int ret = 1;
 
-	if (run->exit_reason == KVM_EXIT_MMIO) {
+	if (run->exit_reason == KVM_EXIT_MMIO)
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret <= 0)
-			return ret;
-	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+	else if (run->exit_reason == KVM_EXIT_HYPERCALL)
 		ret = kvm_handle_hypercall_return(vcpu);
-		if (ret <= 0)
-			return ret;
-	}
+	if (ret <= 0)
+		return ret;
 
 	vcpu_load(vcpu);
 
@@ -1106,7 +1103,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_activate(vcpu);
 
-	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->flags = 0;
 	while (ret > 0) {
-- 
2.44.0.rc1.240.g4c46232300-goog

