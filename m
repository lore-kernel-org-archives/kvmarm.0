Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB61394797
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 11:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792234990; cv=none; b=Q4oWgeg6WHnoBmvcHkdssM/eNLHbOeSO+h3G44gRVckQjEPXus0nLTor5K7ZN3Jp/D1ClWpMXFadHMsUGfN3TsVybUqtJFRbNR7bTloZO2NyK/fqXsYQyx85kKS/BuIddCGP+6AnuexHmFzPS45KIXpwAQvaZPSgbULwdVdRYvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792234990; c=relaxed/simple;
	bh=TLOEjtKkkyoqOjy0bb8E298VSARXyB4QATRkuXYijPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5lR4Euv6PFrrJJ3doyQBFwBERMsWCPL1G7BCoTNJhHktI0FwZP9uf1BGhxZ/u4Zt+Psqswfbl5XYHrzZ8n/p2kwwFRjO5Sec9tBGMl5bONaAbBLdY0ZQVi8Am2Dakdf43oCCzDjr8UQwDFqWLeIR71bv2z9TZCAw5ek5dvZPiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r20zYhZ9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r20zYhZ9"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e8fe8e343fso2758205ad.2
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 04:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792234989; x=1792839789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2VJKUNI2Amz8x09Pyp10zZpRdq+9eAmweb0GWmitbzg=;
        b=r20zYhZ99pb/wlkoLOj2ne5ctKTzPtkDw1ksBth2LwFi1Yb9kR3SBG9slX+nh2HNNW
         olnRHANstEa0O0hmEIlmOXvcdVLIwSkG1Ip4FdmVExsHHMitHt8P6LX3qeMv13/u9Ez+
         ILtoiF9r1pSqlPqOE4tcOgkRxB2bCYIZ3g7C8HhYXvGtyZXvE7MshrUu3bEgfMzt4kKp
         rpqemj9P25QssbjwfBRZIZBzuOuPSuH6TM9rcP3NDLpL4kz1dK6xuqKCp7mdueq19QwO
         LteLdZ6rVaoxmfkKRE642AOFuwe2wGCoeNRoKApYkANeMBGu6YkKq8M10b9cuKsfBtSD
         lm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792234989; x=1792839789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2VJKUNI2Amz8x09Pyp10zZpRdq+9eAmweb0GWmitbzg=;
        b=XLnR3fgkeOjNNo+2W9S5VDFdFkC8vt/XjsttaeXJTupscAwz8yPcdepLr06gXul+Sx
         pxSgsX6dv2SCCBTLVXe8r1TD2p2Ykhp84kcKSCd5OvGogEfNWLWbtu0IEcYwQu1U7TxX
         gE08Q7ybTqeImD5wy/l8RZh0qGIxIgVuXQve8EB2gxQh6JOBPfC9cJEpfnfTQym65QWB
         BF7jj1dhzMzM54Sc9YP5/uEfvSoasDEQqHOHpoGrAUtdDExe6KjxEpc0E7RCJ/CxB019
         vmdQWAehVnzYGnq5lyjbD4rwFHS65fdmM781aTbeWCu3CywmizAa+RXN0wWBIosHMXty
         KMVQ==
X-Forwarded-Encrypted: i=1; AKwUvBw83u8k1qg+FKAMInjbDtA0v7Gu8+J7WvNHxGBrxoA+aQPXtRUhnYD+4mtMoLJCXoiU5iOhHDM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJoODunOTU0pdHES0keSX8wyegV1j2fVjhyJ2C0Ks/zLJLdosUO
	G63qNZKHdI0tH8KYVYNM42vCFN1+2rG5fS/YBQYRKDiv9yQSnPu+dkya
X-Gm-Gg: AYBFou0jNK8UdvQemBFnegQ3wHj9hkhz9afsFtXZmU9ZLdXvacqQWTd6RnFvy2/DEVz
	vTE7ZZEb9qvmHwWrJskyG1FnyJZAWyUsHNYQDHa3H8ezRGuRAUcouh6RLRtYaHMfIEU4TzOUGpn
	KTEbuXPz70qqWV/sqgj4+oMCm2V2WHwK4LSdreH56K1ToP1C3yUIAfkvXyg1d8EB6xw1JIN4XXa
	Wtm5dIhzHAXhqfEuhIao8bsPkooyZHQNkZqHrI0aC1dvQpnZ8aOoxN7EXTW+ceoQQQDKvH310/j
	W9AmELL5KeiEhq7Xc4YqGaZw8+dEkR8wfcVTSG9yitzyaCvRxi36X5BH1Bd1tVwy0uQ71jwFeqX
	cZqbWedVrgYsfQfZutmjrW8HTiXtxC2OnR12Yw42nQz2I5+MgbJkEBvEC1mDBvPQ9JRzWK70mU4
	t8TosRuodxlGzDq7n26b0Duo53aKiJSX4vAvpUApnaJm1DLLmT2q6x9LHNaVxX0wwaiK68dJawW
	D93Es4wfHLYwJjbQyHvLg==
X-Received: by 2002:a17:902:e949:b0:2e9:7dda:bfce with SMTP id d9443c01a7336-2e9a6d3c1admr19606475ad.74.1792234988014;
        Sat, 17 Oct 2026 04:03:08 -0700 (PDT)
Received: from x1c ([2405:9800:b670:b64b:7c65:ff3e:80ba:b06])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804dd9sm20559955ad.16.2026.10.17.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 04:03:07 -0700 (PDT)
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>
Subject: [PATCH 3/5] KVM: selftests: Use the shared memslot base in memstress
Date: Sat, 17 Oct 2026 18:02:11 +0700
Message-ID: <20261017110213.46199-4-tharitt97@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017110213.46199-1-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define MEMSTRESS_MEM_SLOT_INDEX using TEST_MEM_SLOT_BASE so
memstress and its users follow the library's reserved-slot
convention.

The tests affected but require no change are:
	dirty_log_perf_test.c
	demand_paging_test.c
	access_tracking_perf_test.c
	memslot_modification_stress_test.c
	x86/dirty_log_page_splitting_test.c

Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
---
 tools/testing/selftests/kvm/include/memstress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 0d1d6230cc05..4da03541e805 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -17,7 +17,7 @@
 
 #define DEFAULT_PER_VCPU_MEM_SIZE	(1 << 30) /* 1G */
 
-#define MEMSTRESS_MEM_SLOT_INDEX	1
+#define MEMSTRESS_MEM_SLOT_INDEX	TEST_MEM_SLOT_BASE
 
 struct memstress_vcpu_args {
 	gpa_t gpa;
-- 
2.53.0

