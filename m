Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1813429344A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829745; cv=none; b=HIqB6Oarkpu58VvlatscSoZFAHWfdwaWz3PEUUl3EkaBV9ogF4lQyNOYqvXtW/YTy/6+Zrdzh+rLQDw2heWSED50yQeQuETrH+Ki6cgIARIhLy5cd8RWQZbSf4geehkvswWTAg9CH1entmkZtO70ao1vEiMphbsOYGOs2ZQFX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829745; c=relaxed/simple;
	bh=t6cvLBrPM9/1VtvPzsJKVP/et9Zij9EVmcFUvQb2kwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lQogoy8ZhEYB7p/rZXrrnbzTPzmLEKcIlmuZUkyHhorpEPim8OvbnFa8zR2pyr8RqNWLPz8xBy3de54CmDiJjqZ8Lnmq4wRZrBSe1eY4lDqpNvUwTaeeG3tT4D9mPE+Rf9MEYFDfq4q90tWUA9yAyuINVMz1CGYK4ydi7PxjvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KSMl5jIm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSMl5jIm"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so964437a91.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829743; x=1754434543; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M1YWU7ablLeHyEQZv+XErUzYidgNy71lF3ZCKk+Y1ss=;
        b=KSMl5jImeNeWAlM++zJQe2nqJoqPf+oFyvwp/C8Wdz3yfGCPNQv1hM1onZZjhNetji
         DEj96hU+sh3xL+uZg0Nl5jVXwqMLlesNWdjmzqfkK2428l5O1Hgq6Ubrw8pidhZGZreX
         Si2ojH8cia+tcmmE/lItr6iCJ7RjXSG8+XYs6EcNwYGfFPqRt8suOTUyMAaGbGSQ0fgg
         STDGai8TJr92nZMPnOpmAwYAVY1Tg8vyMZxpKro9cE2E64ySqizMtTzVZZicaYtujRKQ
         hbUw46aWq2ym9Q9P/54cOKkjMO5gi9TqjhHnYHsT16YiJe1ZumUmp6JICS5LcrO2tj1R
         gxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829743; x=1754434543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1YWU7ablLeHyEQZv+XErUzYidgNy71lF3ZCKk+Y1ss=;
        b=v0Xlqd9QlrtA4Oq7G8dLapzlU9pe52OKf/dfn8E/NcLFqmcscvFoyX6LD4a0toZbSH
         1Tet99965IevMZSkenT5FvUp03RfTWagK2oGrQ7UP5PKrNsn4tyuoI4cslFJiPRcT2Uz
         QIaRG/AK7C67oIcsvOWGw66zvkpVU1+JDQLQOnGXOixx2vvSQjuYp5p4XHDe/cBgndub
         XoaEbJB7tMTmzocE4ucb+Xq6ReUMfpoctkyHgThcpeubZcLX3PTP1l2ZZi7jLzeMmbjE
         6zkXN1mKClZtLGaIt6/fmSLZnQo6As2oAlE+FyO54WgJ48I7Kk1ZrG0+Cs6v2TIOeEjT
         240A==
X-Forwarded-Encrypted: i=1; AJvYcCVDH4lXtGC8AVj7HFrSt8KrJSUoL1wxAV0Kblmt9UzoJk59eB0eRIvQNJbxr+DrXU7vLTrDpFU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzChC4VBpuFfv85ULv9bNXEh01p0I8YdJSjB491+VW+XErqHz6z
	7iJ+0pnPits+UT8gVhG8Vwk/psJPNS6njP3f6lm0pl9/CYt5IGSMN+Sh+Hym/K0fnLDYTrnVTRV
	+0r/GnQ==
X-Google-Smtp-Source: AGHT+IGVcslDz7bQMIRMZU+0Y4qmg1DflFiXRNbdJAEQP1alfIjp0PIHNIVeHhCtlJmnFtEV0iZyubohx5w=
X-Received: from pjbqo4.prod.google.com ([2002:a17:90b:3dc4:b0:31e:cbc7:c55d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5111:b0:31f:1744:e7fd
 with SMTP id 98e67ed59e1d1-31f5de569fdmr1627875a91.31.1753829743638; Tue, 29
 Jul 2025 15:55:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:39 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-9-seanjc@google.com>
Subject: [PATCH v17 08/24] KVM: Fix comment that refers to kvm uapi header path
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

From: Fuad Tabba <tabba@google.com>

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog

