Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34144287515
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058807; cv=none; b=j34HN1rZGqJQHyHgG8ye4ZsYHjVVDrUxSmdkk0G5sp7QUyLW9RoB4qgrVwQuJuFQ9p56WVM8IjRKpZL599NG0mz8jbSJJUFhKYeV1Kpqbmpo1ydwpRkJzMEShu8Dra74251Uo+BvUraT0puk+jwewXhfgNVz9iUZ2jhw3IBg6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058807; c=relaxed/simple;
	bh=aLq6w6iMVx9A+GXdrTT+UqPhvEMW4mi+b5uKE2VvZds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWb36BNmm0dTLeuR20oaDfvXw0MbgAPagSjBMLeb2ORYiMqKaUHhwyyAhsuNZbEg0ixMIIYSra3IAT9OZwIRo69CJB+FEAJCnKGuveiCIV+RWJF2f7C5JAMAf5jaudxHFrQwFKg4FcfnpZbSCs468qS9fMl54lmUv7w74LvrE+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ob+snX3R; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ob+snX3R"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so31924965e9.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058803; x=1752663603; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=ob+snX3RTSGL17Kv42gU4K8WCI1yzO0ocxoD54Ubsr/UG/fqRUemWkMRK9Gpz1uBAg
         T4TDAKRUJrlNrcO32JK1qO8z7/j0IaEG918ANpAapJ8LVFBXneIgnQ3Xz1GNSVzge+2R
         mBqMWC1d4ip/Nn3fm+ZRjg2STO4Ru7ReBt+qeeax58jWsZcq/aGo8wiRaGZ1IsXKxn5J
         at715lh9GNkquJ18tXc0eF5mRbGb8erJM4nSXGPRGcx4KVT/lW9mFuGQEu3wtOe2xe7w
         SK2rKGW7G8haIGtAOpWK03M53VA4seVqJqkTNgq5fyADYmuF5EcUc5qd1NvsQx6AEbKg
         7W1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058803; x=1752663603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=Het5kynkca135j1h54Yr1mTpFRXlCTIGn74pnuFPPvpDY335kUfm7M0YloOo0nX2mh
         RgZ+OPvstZe1oqBr00IQgjgylC0LTljBnEM1kfpi/YibVAyRNKFSYGNU8Iesm7zHGGMF
         q2G8lWYuuk1J0HFlb+ZX+mqFI1/JZYMDslv4/nfYqvMnV4sG3huydUbrpJ/B9431Aqry
         /b39trG01d5A/tLiqZE2G4Ff84nVG2RK7YrSikSmaNpe/yewqnjV3geInIc8DnJNs5h4
         wBAyYJU5ZUXfF3jkiaIYrUi7XbNShgrIRqvqvov7w5lldj0zPj7XzpwY4BgNk7PjWQVm
         PlhA==
X-Forwarded-Encrypted: i=1; AJvYcCU3VOrp8HcECs5XNr6QCq8tqWSRsD1XDch7uEqmXSQ5WSZxX0F8+kFxWxuQ+QL6B/BbIrCrUG4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcxghZHlVu10/U5pR0ZCpIPcMX/+tpkZ/9BY/emKv9EpVPJ2+/
	PPAsLcpxSV7sBRmMXRgVKOd9EM/0bU7G0InvCnhRNciPxiXaybuW094YQvSwMqkao77gVo+crXL
	lBQ==
X-Google-Smtp-Source: AGHT+IEHcK0/eYhpImfsFIrZ9G5hwIe5rWA1tVA/tSDhd6ENx7b4ZDeNGv0Vm2z//tBc+ZaDxo8/tozz+w==
X-Received: from wmsp42.prod.google.com ([2002:a05:600c:1daa:b0:453:65ee:17c9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4746:b0:450:b9c0:c7d2
 with SMTP id 5b1f17b1804b1-454d531e5b2mr20392145e9.11.1752058803467; Wed, 09
 Jul 2025 04:00:03 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:33 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-8-tabba@google.com>
Subject: [PATCH v13 07/20] KVM: Fix comment that refers to kvm uapi header path
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9c654dfb6dce..1ec71648824c 100644
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
2.50.0.727.gbf7dc18ff4-goog

