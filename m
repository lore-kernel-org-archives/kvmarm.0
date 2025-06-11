Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D08295DBC
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648829; cv=none; b=VpMl3so+riXUtCluCsZ8ZYjqtfM7TEilzkXZcF/7iI8eXv9Wx+pz8Hk4pHqmklISFqO/sRJIBagH2NvBbk3ajQSMWHPESdZcH8GAJ036GqA3jF1QsGemoSfAipm61TJ59koOY5A49KMOW7fOgWqFtBT2CwOW0VFKz1drY1OjKnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648829; c=relaxed/simple;
	bh=uVZJEiHocoaakWHyA3fg/NdyzZ7cVeeLc6jmjENhZ/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aV/m8n1yyXZHphl4Xbl3kwlxbEdlBqudgbTg44X9AVWirrFgjIusoWoqLGcZi78TWxx/6YW9LhwXovZF+iPYJMO0dt1AdrMDlk4RXGXgdBD00rTEvKDiBZ0Fc4Zb3aD1o/Zqhv8WPNH1LW/ga/DTaMRwm/hNSrAgJ4QGAsOP/kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JtoODRCz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JtoODRCz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450d9f96f61so44894365e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648826; x=1750253626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ipoP8xNDjEIconCL8zxlaSKecDJQOQHycTLmRsr3jsI=;
        b=JtoODRCzoVkwVkaSe1xPErgm2y2iMaeBDPReve594cseVUVpGbNIrEWGaWgYqx6yx7
         ifDoeSLJLa/I02hGPbAjUEweSf2lrpoLY4ssIGJICZTfNQRnO2LFMntw8yDpiE5hIHPU
         Lxt2W4+xCFY4g55GDP4zh/vS7lt9XUiI8vyB/exNvZd2RDTMeS+WfxGSOHF57MsPLmrf
         DZAsQc+qTQo6w8hS1E/40bGofow3fF8IOR5aIzL1olavF9IcLprpths1HSZCPWcF6a2j
         Za0IkZaq30Hk1XaJbRoHku4lqNiXvUryGk2M5zS3tyyKgWwzP1wiDUOJe6RhiO8TSEL8
         YTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648826; x=1750253626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipoP8xNDjEIconCL8zxlaSKecDJQOQHycTLmRsr3jsI=;
        b=gIG2DzWqlMC29lb+ndQ8MNCurm2MiMhzhCX3zQRQgdGZngDs5XL1/D7W+qzTE6uRyn
         wItkz2JOj+8rkQcGEiwNC2KnylrvGHJxCFEnWah31dwcAYxJ3ppiMJhB8IOrGn17rK2x
         MbDm2Ln2+3u08QU6zNqGnQAQH/T2MFupTWpjHHHpUiF6VQV1YSGxHqklYHspLngVTPdZ
         ZpT6lAefuKSD9hrmHrwsHs5pegbo30X1kxwWur4A5yQ9Bqw6ISmCTdbRWYppEPqKc/ah
         o4Sy1+gUd5psSTdoJTwgB5C6AyfcCcXFmjoW7/wcq46aTunEVLcwNI7W+/NHbWWsd/Ik
         7ZXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW7AUnGjEjv0bV42k8uI/7ra8eGkytyfLXaaCTVsRq6SL06VL4DGxJit4ExQN2zrIS6lRoT6g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAmH6YzU/nbwQRSASbCS9f1S5q7zmhBcMFytVdzX+jksujte35
	ZfQubA7VSOBedOtRW0SnzEv1PAh0wbvLircOi7c+ag8AgLMvf5iyQyurR2pSs9VNMxjyroz7Gzn
	UJw==
X-Google-Smtp-Source: AGHT+IF8m/89MTXda+VzDrvu0RJ/n7UpnITSLdxSxLWKnF222wfDhxftmaJ4GgCm4ymT4m2HSbwt1QBpUQ==
X-Received: from wmbez9.prod.google.com ([2002:a05:600c:83c9:b0:440:5d62:5112])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1448:b0:3a4:e56a:48c1
 with SMTP id ffacd0b85a97d-3a558a43563mr2743213f8f.55.1749648826221; Wed, 11
 Jun 2025 06:33:46 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:19 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-8-tabba@google.com>
Subject: [PATCH v12 07/18] KVM: Fix comment that refers to kvm uapi header path
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
index aec8e4182a65..9a6712151a74 100644
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
2.50.0.rc0.642.g800a2b2222-goog

