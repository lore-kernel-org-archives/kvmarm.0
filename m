Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5B4566A
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658755; cv=none; b=AQ46Lqm87xFJhMC2FleLJZlOK0Sy8l3f5/9AJa+b+n98hcH7vZe2e6HE1Nh09FJNx6PSv7rdDmJ5ZwZwZ443Q6Ap0JMjQiPD1uxXP/TDb2/rpUsOvC/io6R7RdQOedhR5I/1u5MZKwF2JfF/aSDyTEwSaXixOjhMY/FltzDcj2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658755; c=relaxed/simple;
	bh=ngrqdUdgvu+/gBHMswn/cnVSO5lL2tVEodHB9BBNKEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qggdfu4g5G4v7bjRfICz2paLpwosNsLbPhwtKYoWRyDPy+L6tCpJ3dwkKf1GRcbXVRAMfu5leeYe2dt+6IpsTn1Yb/ckRRmSfs3nfTj6kfZYgxx3aNg6FBPO7IdYCKnqiXFFyBsu8zAhWqZlOly3tgdyESxyEMnBeIDKgxUDdLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ii96IkYR; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ii96IkYR"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728eb2e190cso1305575b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658754; x=1735263554; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C0bgCVLlKE2bsIas/97mE7OWeLqD3b90q0/zRCnz1gQ=;
        b=ii96IkYRgmm1YbPFUmXjRuYClNg6wJk7O9P11pGF+9XabzogxUG0JPnHw43uqPFkE9
         gz7ReAuh4FACojciZWt6Z0XcDpCxym8TFkzet8X/TXxVMs8RibpDKnLnOSToFdD6T0uw
         arIGnSOw+FmsRciYUTHZWhp2GekDEiB1Ra11GJJtfYY/aIN71kdlZYuomP4BUWTn+SGg
         kZcBqZBgib2SS+Pj8QnaqEumMI5FN/l0r5CpUKqn3Z57UGwvMw/aTsqcw7ZXgRm/yHzc
         NdPtn5x5f6YDQ3nG7L7Lj5FDUYvYaEKns4vXYbtWdRbWcEZpd6W2sp/04hhowmpMYyB1
         CEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658754; x=1735263554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0bgCVLlKE2bsIas/97mE7OWeLqD3b90q0/zRCnz1gQ=;
        b=SQ7gulJ5ZupXJUeIIhMlbHN/rmJD66DBRuQkiwnRXlXIjs3k3Ann+Sk+SEk3RKl4aR
         47NKfSob/z3yuGIEQxTLWBBFqO0HKLIDutIFGN4Svb2+EtiBbBRPfItmcNaLzkG2kTMI
         OTt8FnDcr9e0P3gALNUqPHkLDQGk8qypK3W4zm154G3hQCdh0vnhRlA4CsK5H7eGWhMH
         gqIRp2GGMuJgnKdSs5s6KEErcvgs7sBuIXXHb9i99BCH7SbveV0HfH1ijwxBkjygcWPl
         4mTZiKSZaYQGLByEvoAhcF4ySG+AmgQXSJRZZpH317RBpAB7z1vemez5ziJqvQYl3uq1
         tZcw==
X-Forwarded-Encrypted: i=1; AJvYcCWTwHSzih27L9k+2zwoe5GNcWgTW/jxU32Ck2Y1ZFH9XwisPhlyTKbeK5XQy6dEIb/upQLJR4s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPwny645C6PoEAOVzmrOqTVE+IDQKfir1LESYBtpzQnmzMTqSP
	e0P9ifV1/2e8FIdmO/YD/I6CpQqIygaDGx20zUpUrp6nh8UowmE/Yze//DAlvBCEaC5YOwIxc/j
	jig==
X-Google-Smtp-Source: AGHT+IEnCf3mHfBvLfwshZ15Q9EpX1HZcjdF08kZ2lrJwSlTx89Hx0AQSr2Fy6V/QWuDYbh+JhZtgEK5cgY=
X-Received: from pfbbd38.prod.google.com ([2002:a05:6a00:27a6:b0:725:ccfc:fd85])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1942:b0:725:cfa3:bc6b
 with SMTP id d2e1a72fcca58-72abde404b0mr1283201b3a.3.1734658753719; Thu, 19
 Dec 2024 17:39:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:01 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-4-seanjc@google.com>
Subject: [PATCH 3/8] KVM: selftests: Assert that __vm_get_stat() actually
 finds a stat
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fail the test if it attempts to read a stat that doesn't exist, e.g. due
to a typo, or because the test tried to get a stat for the wrong scope.
As is, there's no indiciation of failure and @data is left untouched,
e.g. holds '0' or random stack data in most cases.

Fixes: 8448ec5993be ("KVM: selftests: Add NX huge pages test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9138801ecb60..21b5a6261106 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2238,9 +2238,10 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 
 		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
 			       data, max_elements);
-
-		break;
+		return;
 	}
+
+	TEST_FAIL("Unabled to find stat '%s'", stat_name);
 }
 
 __weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
-- 
2.47.1.613.gc27f4b7a9f-goog

