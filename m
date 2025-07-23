Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAC428A407
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267647; cv=none; b=etgKJQphfkfeX6bfZtPsslNhiKYsCKlhBfampwrfEeWssXXzX+lDRs+RJITCKg5RF61dxdt9AZbFJDpA6cgFrnsNCUE4BcZqewIlDcK5nXBf13qhFkVTVolnTsmOt7LfwYLCJjyvJW7s6nk+SMiei22jEsWGs7FK1vJnCEWptcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267647; c=relaxed/simple;
	bh=X2UnKEstGo4dvjCoZ5gOAq//oBrh8730fp8cQehcNxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GyQjlv1zCc+lI9eeM4AIMFWWIOblb21MCR7F7haYCCPNkhWibipBEMR1kvD/g5MMk1X1qThFsWwzkaSiaMmdtHQ7ZrBfQmBB/SqBevM+vOrVyf9YAN+cB9MIurbboUQKiusNyA3Y7/0D1UZ4LilWlVOdeO1Re4jzKt+8rZ6QLMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CbwHYhA0; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CbwHYhA0"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso3692381f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267644; x=1753872444; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=CbwHYhA0fnG1bryJSJLcYQQRXbZXSyGKCNV6yfAE7KWywSJumuQH0ENqm5q3Zv1No7
         A9c5pa1MPlyfGiUapt0WNtGSp0rFuLJFCmKlRtNDpdO94FqPZgNeAbRFYT52Pyjwcy2C
         MpgqJ7ZfOOrFcT1l45lsetJvqGzUFP+IMybOHvRoWlPhCiWKcTRHw6nY6bHOr87q++RB
         ht62jwwf2z6rbgM+nwj17vQnO9ma8lb0/30RCwZD3MM4/CKDDH7CIJ9NF2CH5aBpaMC1
         zymy5RILJrKI0NPkY6vqomDujrB/m39iRxIFgys3VV08oZ3HR4E/OrDpInNkKHoxbnaV
         vBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267644; x=1753872444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=B3NvoPvk3y2jmiAyGUK0i5w6ddfkqbsuEZ02EBOP2e2q9mCpOnsxROIP1zdwb0Jod6
         ZLEcIJI/RjsS6epdzoMJpNGNN3zCjh8K/1mkLxlm55cqH0gz4oD4QcxRQg9X/QQSSIV3
         GzjU/7TuPjaZXSrgSaJlJ0xHr/b4UFrlDDwHfeM56eMG2bd89p8x/UWhBwUy779OIcaW
         ljurZl+07WixOzlrrgKQbWA3+S9snfUdToKutItfDAEKNhmUPZMLWepuR/SQO0uG3n+G
         qf7hMpUn4Fe8aQJgo4Y8eG9lL2aS5vfHxh/8lG1k419ci8Tv6eKadgK0aVNOaCKRsdH6
         IYFw==
X-Forwarded-Encrypted: i=1; AJvYcCUbPCoklX3Rx0BAX5DmIO4SPvAPX6jJaXqYqCOJ1yuQ8z/ujtlniSHKOr4xQtDGhrwHJQgmPDE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRt4GQk16kL/+SN0N4d+mEo1YgjAcGI8vxGUD2ZkjshnEYHjAv
	q83gY87PDyGBvlPlw0/RjGWsuMB3r59cA2EsA/uuIn2HhZODJKfog1G1LO3co8KSmTmuYGXi88F
	qaw==
X-Google-Smtp-Source: AGHT+IGh1e+V8SmScKMa7B9rDGNrVFkyz19g/99WYS3fME9s9rYU5XZGuebCy3D5fzuVYuNyo6dDcGaEqw==
X-Received: from wrov11.prod.google.com ([2002:adf:edcb:0:b0:3a5:7883:6563])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1449:b0:3a5:1c71:432a
 with SMTP id ffacd0b85a97d-3b768ee0916mr2198617f8f.14.1753267643374; Wed, 23
 Jul 2025 03:47:23 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:00 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-9-tabba@google.com>
Subject: [PATCH v16 08/22] KVM: Fix comment that refers to kvm uapi header path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c25b03d3d50..56ea8c862cfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.1.470.g6ba607880d-goog

