Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C5C213236
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137901; cv=none; b=D0EpsXFrF1k61k3leQ2wjuqX73izJC4sKCQ3oo0qnPgNXAJ10GvhQWZnD7ZgLM4zRMmYT44l9Wuy9/KMBJeSnoHAu6aFmMd3dBvIldCxM9KknusUX9JzEJ/CGbfXQR3lfwyqUXr1H/raH9xKvA6U9cxXTrJ9+4h8HYN3nlpZJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137901; c=relaxed/simple;
	bh=h9y2PxHa3T/iR0irvc8EFzsEpKcI12tJbooS4AaFVxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISbTodZL2Dfu35elTM+ukDY+eM1FrQpOx3Jx+IZfBo8u0YX50i7iM1Zo5IzGDa+y8gwlkKQQaMl6B/JmbOAS/bg6E9aW1RdlBcP+s3wXnmXcInboQQguvFzQvOKfU2EtgZGiBPR9wBQV7frDp5X5K7xDhJxjH76yZB8jhzOfCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtYbBlYh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtYbBlYh"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43eed325461so6793685e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137897; x=1749742697; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya9V8PlB1f9QKkO6N2m4/v94EO/9DMMarQp6ACk30eE=;
        b=NtYbBlYhH+z77PVpbb6wFnzKLHZEf2ygAbgpSgg01HrRqjP+pj+aTVRf5Jv9xp67+Q
         5Lhk5qO2Z/QqO5t3usyXY7mAu32FSWPpTnp01M44FYavePlMzjEreSVObhoYRDJ2lg58
         DfZiFD+r19pFd2KWhOW5TCc6MV4Ko9QTrwnQUf9E3hy0WF6BeJKuqBLznT0H/ROb+hHI
         /oGFNa/oZdmJ5QgV/QbBlqDU8vvOX6Qd8fi/QKRYbzSLcs33nHv+WR+EUzQ5lyYhen5i
         9fNQhvK4iMZ5nJacgxTZ7KiC0j9F1jGoHgatYiXgZF2ZL3wTS7T6s1ETd9UHqbcq+9r3
         5fZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137897; x=1749742697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya9V8PlB1f9QKkO6N2m4/v94EO/9DMMarQp6ACk30eE=;
        b=CnoJ+nezAPvIVsp8utGiWAukYw8Mz7jFwSvwlGZ42TRFcOAMRa6qqZZ0T/oR+b+22Z
         lT4+nojBICGyAp1/6qqqEzHSAfnlXbiAtZBLiXDBEGKVGQOYwp3zG/BW4ZZtyRSzj+0T
         x1IrOPVrVAGmSkxumls1FhQ24yxjUce/zY7afjL+gLN8Fl5ElNznY1EiKOjaTPv1XO+/
         dL8aDNhK5IM3CQQJdV06LEB2OX2dbE/1TuqebkRif7s5DDOBJ871rGUiqIMIcQnw0/cq
         4UarwHdeXsQaccQ5Srr4gfgXA5/OJV8pjGs46ath6S8iBjprhRUUSROnXq5LySu3s/4h
         PBHg==
X-Forwarded-Encrypted: i=1; AJvYcCVzMZTtsjm8V/zhP9Sit3ci+9Z/5ibYxwfP7MHZi56J4LysqLMtOfu1fdrB97khN4/Dm0N0V7w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2feg+j2FQcpsDa015uAtBma8goMeN8C7ZW80Qt4mLhETJpQl7
	G2uF9x+BWpEwaFQa7Zxmt/kTWV6r44jsbY4haRklULuxBtN9IpMY47TvYl4pkfL9XrkRdgPREXr
	OaA==
X-Google-Smtp-Source: AGHT+IFhrDIh6gCXeF6nxFdv6Zput8Ia9sHzYK88p92EvJQS2AgWKQpdoJNqkVyvlyFiBZqhNRmwPvnK8A==
X-Received: from wmbhc7.prod.google.com ([2002:a05:600c:8707:b0:442:f482:bba5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3106:b0:441:b3eb:570a
 with SMTP id 5b1f17b1804b1-451f0a6a94bmr72946715e9.2.1749137897069; Thu, 05
 Jun 2025 08:38:17 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:49 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-8-tabba@google.com>
Subject: [PATCH v11 07/18] KVM: Fix comment that refers to kvm uapi header path
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
index ae70e4e19700..80371475818f 100644
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
2.49.0.1266.g31b7d2e469-goog

