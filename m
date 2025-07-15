Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D42D6603
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572047; cv=none; b=PeggUm0A1cGmtjC2ZnhyvNX9qptxYlCDXUCGrB3JsYsrcjcxF9MX4rdGnlAAQrTeOLqx7ZfNFyaDnFu79V6VbK1NUNKxQnv6radsQmF6g02QiCyDxfa1Xm8qsXolTkIKKMEi6JmOx+kutSorCfKvhfVXiWrKADhw4wguMD7oKIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572047; c=relaxed/simple;
	bh=eAbMIJcHK/F51o9nr4guiznjnDwffZaDRzSajhDolHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n1XzayCrrdFb3rVccVItMyqZgz/kP9jJ5dm3PGsgLz0go1r1dP0ReUeDY0MIv2Z/1BO7N9j9a4YVZTUTk24c4lte5K51xzA+gOswPSm75f9SBxiODVoSX4ZfRTGo2TUZpbdtUOogHvCakxNe8Ddz6AH++hybyij1FXICcH7+sGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bS2mhecm; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bS2mhecm"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4fac7fa27so1935441f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572044; x=1753176844; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7j61AiDEYKRdqOr/Xh1CHmy2PK2pOlrkOryB4JYpx5E=;
        b=bS2mhecmQFjEPyExwrO97/DAAviziZQJl9Q8sudDy4rVcsqL1aW76H/kyz2P9HgwQl
         z9KXUwX/33nIzunRlfyzR/lVfjO53VEF9dwQTO44sI4bma+Xlf6W/S6sDuN0p++P2iOa
         MUl6hwUO3MZ/MNxBa85hpS+kYYGqtH2GuSZQv6fbmuI9GPNan5vHN01jybrXS9zXAZF2
         mS4oEx7YP5frT53CxAGI/MOUtphC3teNnacY9s/HPOiZE9qIr26tdW7zo3A2PsQkwtf0
         GYcqxTougl1UzOwvQEFZrkd0zsxFiKsnBZ2ikxSBGXKhBXGbgpm9X0hS/kwrtgWWiQbq
         Tt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572044; x=1753176844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7j61AiDEYKRdqOr/Xh1CHmy2PK2pOlrkOryB4JYpx5E=;
        b=MY4Pojg7I6/Ls0vuFpH03j/z7rc6+btOWAx1DNFc25/BwzzPuETm5Ljhl5OUtUL65l
         vvRESmcDq8ewYTvZ/dknumbojwaktY5beL15Mh6H/lzsOUeVGd2MJi59lCSzLZ25lEkO
         GK5/jbEoZvvnekLhin84qt3ts3CmEI7MZtq/Hnn89a4SW+vXV5hu9qgZDtX4AG4IUqaM
         G2/CwaPuyZsakLrX2gfe2aeqJmuVxQ1cmD6TQTe5iOxK0MzobmGeG98wdDioW77jS+ur
         9BJQQMdObrnLzzSWrUNudwkuvU0IjJ0iVO7KSAElsaWv0KEyCChmd+e3M2vWLJ6SRCBW
         R76Q==
X-Forwarded-Encrypted: i=1; AJvYcCVh8yFTWtwWWEBWJlxkqimtnXzxkDXVVYDBmurqqsp4L1rDU3uE1ziS78CghGMIcmR/kTPAAMc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/zyRfaJry4mOsvfMW2G4jw6VLZDwO3qM1ddcq/0XKKUh/PQ9u
	dUVS0EOIr9tAdCfnlrocItstH3p/eO0jsvi7asKzh3If1f4bWSrWUP1Nhh8h36x8LFg5/+B8SYa
	Zcg==
X-Google-Smtp-Source: AGHT+IEOvr3wyT4KsjEFui8u47n6x+FVFq3D3Cl0DCM7gD+8djYdie0rM5VY70PS34cmaOF5B34O1xWZrQ==
X-Received: from wmqe20.prod.google.com ([2002:a05:600c:4e54:b0:456:43c:dcc3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:200e:b0:3a4:dd16:a26d
 with SMTP id ffacd0b85a97d-3b5f2e0f727mr11480418f8f.38.1752572044316; Tue, 15
 Jul 2025 02:34:04 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:35 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-7-tabba@google.com>
Subject: [PATCH v14 06/21] KVM: Fix comments that refer to slots_lock
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

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed00c2b40e4b..9c654dfb6dce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -870,7 +870,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 162e2a69cc49..46bddac1dacd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.0.727.gbf7dc18ff4-goog

