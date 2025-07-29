Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE5A2874F2
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829737; cv=none; b=MbU9xDYi3YRvOm8ygTle5sKND/TcxEcoQKPWjcf/nX0Yv5kGEnVJICWzYy4cLaUGyjjhxcD67Kx0mY5GzXAwQwKGYIwcu0Li97KyfPzkz5DkVuePQMtJfYVfzaBmby2DUg/qxCs2EYNq4ut690HB4CTlhqtHuylk+Bd6PSI/5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829737; c=relaxed/simple;
	bh=WhA8GcOHwnrQQI7pcMt4+3KPgdAVeYE+NdluYFw+Lok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TxGoNVJz2cJxahSdL72O4rDqDjvJBvpZ9MWyKa42Za0eYVyiBup8JzNn4B9+C9X4yIazZgVr5ECFBF3hALc6oca7zzDczioflTWupWQHlCzxtwaW0UEO+YbdSmGPbmrC4hVqPZRt/SmqEppgPcqm4q6f1TpcsScLRSBhyGwdZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RuGyFDVE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RuGyFDVE"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2405fdb7c15so19378735ad.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829735; x=1754434535; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LS+T/y+NsOpuW4oCoWoDJ8akduRknfqoGYJRkz33V1U=;
        b=RuGyFDVEIgZzLXroiQlfYbjgPOa4m21tiom9WJJ5yJUC8RXx4Mc0azqsgU3XOa9yOA
         9Sk8XelOlDWicXhAAdLNLM1Ld7vBHpAV44uBmNSz285zVU5EXg5p6JkAtJZf3k8ucRhX
         IVm7Ndlqi3XHnuxvIYOoBTm9k5XEFCVeUMoEIvr3GRdndWDcPjkNcxVX4gPWgsV2NLCB
         mvrAOnFJeQdjZXGK3jF43OuKJHvNIcSDaxGJf/TUSXjMxHCgh/Q/5/NgThiJ+dEKUbdP
         VCYAjOPxP9zmIsgwXhSvKv4J0Um0HJ/bkfm4xMhXxAQTwsWk1/kO9m0ZO++h6BoEYJoc
         n3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829735; x=1754434535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LS+T/y+NsOpuW4oCoWoDJ8akduRknfqoGYJRkz33V1U=;
        b=H48uy7ynqbqswkAr+JqDxQi67QtwULzCx3lOvAGwqpDEJp89fsX4dfMvw4jqRexvZL
         gog8tw0/r5Fu4SVQhfMgdqyP4UgNkJzz4elQmUfYFraDGWZLakdhg7Dor8A3j7kiAWgV
         gf2rIUERG9y0qcFDKZZvVXwPSiRdTW8+XvGwk7JwVi06f5aamNKMykLsUauE78YnnQf0
         L+g/EO+jOlxK2o1pUP7O+cC3bhvJdip9X8UcH3b9WW7KE4OBzSg3DdyzbtQ09QEtC6Rj
         6vYTYG5U32HkMF6o+yJV10/Wvpjcpt/XsBF3w94nqgBPwS41PtRp+cYn7DUoJV25coOv
         j1JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFoQ5as9Hw2yVVzmX+vVCQVNg+OgMYWbvYN+Dly5JIjeIgy4M3OmnM/o+6zd9AQ5DFZ7RZZ30=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKSllO5GvQv30xkVH+RYCC9zFpo3uWJNHapW60HlRRWYUewSIc
	lCm6AH3zRhFU3PhWAx6dwspJeUhyaRW0oAEyNBIUk7Ii63Bf5rRi1b6C7CKWhuS3IruNPZIiNGj
	+OAqOzg==
X-Google-Smtp-Source: AGHT+IHpmI5t9q8abNBgRyh5X76Xt5TR0J+JP8kdnFD/iZ18CSlsLse7XJRB4ca0uWJ63xXXHrffCkBn52o=
X-Received: from plbnb8.prod.google.com ([2002:a17:903:15c8:b0:23e:3914:f342])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e890:b0:224:910:23f0
 with SMTP id d9443c01a7336-24096b3d823mr14938045ad.49.1753829734856; Tue, 29
 Jul 2025 15:55:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:34 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-4-seanjc@google.com>
Subject: [PATCH v17 03/24] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly
 from KVM_SW_PROTECTED_VM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
conditionally selecting it from KVM_X86.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9895fc3cd901..402ba00fdf45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
-- 
2.50.1.552.g942d659e1b-goog

