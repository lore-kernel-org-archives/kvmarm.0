Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B7BBE6F
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648990; cv=none; b=uE2/+fcAQZbm7bSRIGzQFNC19rVI4cQcIwtNSczmKEVqoJAtFZjX+4g1deavt7bO/315RJfqZTBzqc88ZDpPll8ItCd3mRVoDss9ZpVbsVTxK0wp9kw6RnStiH1rbtXZRE2jtS30Ft+B+AjxzEAl+56K6t62uBnGXgD1W+kWo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648990; c=relaxed/simple;
	bh=LW9qJDJFMZKoAzuMjM4EnMGD9KOMiSIoIkVhiiIE6n0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=phS1NMDzRKSS88RY5+GBB9iD5S2L9Bci1bnhtrdFWqGzyxY3Sig52AdHhQkD7lwnSApwcURp+tRi7UfAEpirvR/A4KbxUsLs0RG9OfP5y3pxjrP25u+PswC/Zd4Z2VRBmhigN9Y3VRv2xyuwr6qq0L0XzcELPHT8X8P6Tqzq1sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CpC2MiQ3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpC2MiQ3"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e04e1ac036so259694b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648987; x=1709253787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jhSBUfusWJ3ofLKWMGpg2YDRgo1XDnuJP2HRidQqwH4=;
        b=CpC2MiQ3zGJs1AbB/pjWW5mIqVnhsKES+s6ZNLiuAdjcfUsDE4b1hgjP6Lpoicd8bK
         sncyxF58GW3KIv715J8SpUPEjL0b9O3hw1dIKW5U753GPNYvtQ3XXr00edEruFJ5hJQr
         CjuYfdVcJtiClK0ymwQuL9MEMsFpTSLUkh5axKYG8EhTiTaZrkbDqws9OSe4L5Sgzw60
         nqrDgaMssXLqIGoDa1AAazFA63aOUVQMk302IPkzbCB4jawxiKk5hEEBMHZdRCvKoSg/
         rKRj67JYZKqRghBWZAKxlzG1Ho2t8263beWUOsQyDX0uQ/Q+x78YoQVMzm3bYjNEPLyK
         5ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648987; x=1709253787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhSBUfusWJ3ofLKWMGpg2YDRgo1XDnuJP2HRidQqwH4=;
        b=QOMdYO0ZUYdOTTo4zacZtBxUYO/NvMcCSslEZNiLNc3QYScTDDqf8j+k12y31hd6Sy
         rS1T6uqkZwzw82UhLQF3ie6KjBKsA3WYGUZ7ZoAUJUhoEsMV+4zvVDKp5WFWz2xUSvgY
         fciE7mPM9+UUI9QaP0ePh+9GTBkRS1XVo76oWsaN5fprlOb9OJXRMAmI5OHzCjEnYkdj
         qN5gjR/3Gv8E46shJHhmzznrcEvNoXMl89WASCZm2VkRDstE0/uH/ZDEWgANGwEBbDO1
         8U/sLIm6AS6J0HCbhSyy1DvnwRS5FNnOU7F19kqKPHNUe7e8q2uPRevg2bTnfS1nfPX8
         XAxw==
X-Forwarded-Encrypted: i=1; AJvYcCWkwu8DLT+U+qn2z696LA5RZnavlDaIuJHlnBmW0GF0Yk0s8kBdWsLTEbUmX4FqKiH/zZrAHXJo8waK8rPuJ+trKL0WX91i
X-Gm-Message-State: AOJu0YxEPOE0s7vnW5ipr+wGUwnM09HZtmKbdHvDrjmvFAQCpuKnVIIx
	PZyj94KNbvfj7nYgTAPBme8560Gf6tM59oYU/MFZD9JEQXfOaIJszv8hEtoIlTiDMqbxtRb7Vnn
	srQ==
X-Google-Smtp-Source: AGHT+IHIxuf373oGf69Al+lWSIf6Q+TRpWLvL/aYM1tJ8IvZSlPzsioXOjltEzRkvK0lvpvWJZPUowBn/iU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22cd:b0:6e4:643e:e215 with SMTP id
 f13-20020a056a0022cd00b006e4643ee215mr24254pfj.3.1708648987517; Thu, 22 Feb
 2024 16:43:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:50 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-4-seanjc@google.com>
Subject: [PATCH v9 03/11] KVM: selftests: Add a macro to iterate over a
 sparsebit range
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Add sparsebit_for_each_set_range() to allow iterator over a range of set
bits in a range.  This will be used by x86 SEV guests to process protected
physical pages (each such page needs to be encrypted _after_ being "added"
to the VM).

Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: split to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/sparsebit.h | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index fb5170d57fcb..bc760761e1a3 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -66,6 +66,26 @@ void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
 		    unsigned int indent);
 void sparsebit_validate_internal(const struct sparsebit *sbit);
 
+/*
+ * Iterate over an inclusive ranges within sparsebit @s. In each iteration,
+ * @range_begin and @range_end will take the beginning and end of the set
+ * range, which are of type sparsebit_idx_t.
+ *
+ * For example, if the range [3, 7] (inclusive) is set, within the
+ * iteration,@range_begin will take the value 3 and @range_end will take
+ * the value 7.
+ *
+ * Ensure that there is at least one bit set before using this macro with
+ * sparsebit_any_set(), because sparsebit_first_set() will abort if none
+ * are set.
+ */
+#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
+	for (range_begin = sparsebit_first_set(s),                      \
+	     range_end = sparsebit_next_clear(s, range_begin) - 1;	\
+	     range_begin && range_end;                                  \
+	     range_begin = sparsebit_next_set(s, range_end),            \
+	     range_end = sparsebit_next_clear(s, range_begin) - 1)
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.44.0.rc0.258.g7320e95886-goog

