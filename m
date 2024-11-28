Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C31E4AE
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755357; cv=none; b=Gi3XpiXv51WWbL9cdUiKyLZk+rVsAtG0xQSHw6hT7pGrx8pwIB6INc8HTowxKPVSn5+LKqjrtseOKAh+zSJyAAFwi/GiSK3ms+l9iekXMBndHxGoO0FHrbb+4JdiAsABqTSZ55o+ZbNZ4a4QtZbnkAoKJv4ec3H7EiMC+YqMwL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755357; c=relaxed/simple;
	bh=/I1QDhTu7A4uX6aQjK9uL6OFtLwJ4Jmbm1md8fy4gPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oSXWecEIBh/Y2AxJJlxPuSvb+sJrxBROb2qXGsTeGPEszAFiez7WhdY//CQWRUxHmbbTVBdvBd2NFX4YXDnyDLbgPCtEF9dN9B/oE2sqT9afMgZH0jl3W0zflq7ALai4j+GdkSbWSGq39nNc1gCeY43aRiJTbK4lmRJz/1ticww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yL6RbHnn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yL6RbHnn"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea2dc1a51fso327617a91.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755355; x=1733360155; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qVBMujG2OTqdwJQgPPGju5b8tNjOmRcixGV2iZuWWwY=;
        b=yL6RbHnnZaxMYEGhsXWEqEHp0kVa/rCyquEe2VMrsbSZaHAfCiYAHrAAtrlcVIek4s
         4jPqOnx0T4zr4O40vdL+zJdjjytRG9N4ywHN38rmv69xtBixXyouGmCetb3rvy8b7N2X
         ohIgiFGj9/cXMFMHgIki/enDGvFLh6pkatOi5qsew30hknrRNhef2r3/GIjE7P+U/fkA
         ExcEOjMPTl2vx4XtVqR2LNibpm5o8Z572Q4DLr1ZU9yUpv7lP0+/QvIyr/5SGdPS84b6
         2zDiHZI/chrSQqvI2/mgDJAKodn+XkzYCyhBPF+GCU9ucXuYVS5x6tpq1dgUC8V/ZYWK
         rbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755355; x=1733360155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVBMujG2OTqdwJQgPPGju5b8tNjOmRcixGV2iZuWWwY=;
        b=sSlxdDNx3c7BHC0BLEzWaghXI4LGFGbKgqvm6N+avD72ddnH3r0JlOIhkuroOFRITd
         os91eK/bWzVksl5+D9V2hJzWkNGn5dWoOoMIYNy5Ixn7KNMA8v4WhO/2LdAtPGISdesz
         BZQhSrQeNmwwDONnRS1Kvpd65o1zw4eyR9W58NUfgyLfiWkDaLc1y6b2P2n4Tvc+IFrD
         n3JHUQWJYrJ7itzhQEfOP29FH2Dx9fqhHTZVmiwXRoRaktxflakBSNgyBOOiImALAv60
         WwplrATHHXt+1CmN0W/AqVyDsxL332krdjnHvAY7XBojl7Yi+4aRpkHWxK2hxbjUhI5N
         u3tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEnl4GYMRKa43Uds4o4iz/ukQWHrPCD/uiKul7NTF+ABsqq2m15vtU7juH5fN1UYZQJjEzhXo=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywauyn0ijr6ugrWI8UnbHw18/wO4R8EF3SkuYeHcPQHRyDRZdcV
	4xc9MgQqQ9ij7K2NQbGDjlvwajSp9/4xktdJi11Ksa5jzD5DhDvR3FjJ9DtS4JSOZnBtYU24B+j
	BIw==
X-Google-Smtp-Source: AGHT+IH+xlYFxzyyjYgkHwbv9v8SXpOlp7wHMGVgiCiV61K5VskA6YHcas7fec5b54n5jx+SjDlTSzyBffA=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:2ea:7329:4d
 with SMTP id 98e67ed59e1d1-2ee097ca9damr5929096a91.34.1732755355263; Wed, 27
 Nov 2024 16:55:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:34 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-4-seanjc@google.com>
Subject: [PATCH v4 03/16] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Assert that the register being read/written by vcpu_{g,s}et_reg() is no
larger than a uint64_t, i.e. that a selftest isn't unintentionally
truncating the value being read/written.

Ideally, the assert would be done at compile-time, but that would limit
the checks to hardcoded accesses and/or require fancier compile-time
assertion infrastructure to filter out dynamic usage.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 287a3ec06df4..4c4e5a847f67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -707,6 +707,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
 	uint64_t val;
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 	return val;
 }
@@ -714,6 +716,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
 {
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
 
-- 
2.47.0.338.g60cca15819-goog

