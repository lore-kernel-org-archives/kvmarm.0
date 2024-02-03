Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8B6612B
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918969; cv=none; b=kiR6ije+miFTYWr9UzkSyC24k6qg3HBPuJ8KcjvGdIIDhZurTva4ARcjfIiz/QwjrPg1PmH5bYyjLbI9vdfMrdA4Pjhysv4hHVD01mh34nZj893jnTujBVZE/4m48QMXH7LeLWTtfiey79DxYkqj/Navt/6bdkA1SNd/srW36Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918969; c=relaxed/simple;
	bh=5adFsddT99jRoR/vIsu3Y6j5XoRwGq4E/i/qqsJ/xJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lih4ng0N1u0RrmV7fSvhsG7U+B1V2Xcyyz43H9h9RHig1GBuBqF0mJgKGWPPMlDbfdXw4XmcEQuXsSXMxq55ie7iefG24goDREUO3vBIuF7ftC674oj+1CnXlx7kI45LAyoXLQ9qKVjc7xd1ADZsQoIq+YgeVKPkt/XG19xziZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2fIol+E4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2fIol+E4"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6041bb56dbfso39644127b3.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918966; x=1707523766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EJcVR2aXcmJcYN2R0niM7r+O1TbQOV0XdUcPDJMxbc8=;
        b=2fIol+E4P40ZCapCNyfi6ULTmrVd3XeO2rV4iHAXfP5U5fCfULKGEUkdruWbBm0hTY
         txhdaGlMPqLQhocA7g7JX66OvBFLroO1nNJR37gNygkQMkubDuFhXOztM+If2AxehTsV
         T9rJ8zsjJsilvUmbtBnMmi9gK/l3lInrGFE5rkh86kwDcb584PSybkuDGdLVPgcki2/D
         z9KnZ4gQzRRe4GlDIISPrFyPUXpCluiR0PZaKP9oNJOyooXKGKhIL5vq3DXgUHBaUzVF
         ocAqelkkE4Wr+2nXULQ4jUcu0aavYfQbBHhhWeQcST3xlQarOoGbGIFyVvaTHiSf2RqF
         VPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918966; x=1707523766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJcVR2aXcmJcYN2R0niM7r+O1TbQOV0XdUcPDJMxbc8=;
        b=IV4KyenuMnoS9ObB4RdqPJFXpOxv9NzX/fLBroKsCK36FPpgNyLbgM0wSUCIEd2oEO
         1osJlNpgZubMLYC9l1/tLd5hw6V6ctmeGeFs2Gs/tcJ79yTZgvAu3TKAoHyDV5l+qYE9
         R9O2Ws6L9ljD+9l5Y1RGe4dF5GvSBYIvHWNsXOwL249i92xEkm82WlOaSah5db9Hhyfw
         ba/ex7I26ZweQ8StfiXciBeDs7IGAnQFo1vClztu7cVuIUuK+TpGRWXq1r1s5BaQqX0E
         Kv8zJF+/vCc0Cm2tmGwA+tWdU13B2wy4VVNE0BrQ7i5GMwPb8YjAfWoVdofhlR3cHh6o
         sI8A==
X-Gm-Message-State: AOJu0YykwlRwrXbkXd5XakMBCbNXaLbMXK3JRBBWqq/Rdp8azdLcivBL
	xW0MQPAJaUQy9gcY25dVMxekQrSq4Rf0cbzcju/uOpr/7LUwRa/UbKaa+vGgNKZNyKWxOFKvHZG
	iqw==
X-Google-Smtp-Source: AGHT+IE1s6EJfVGREtZvX37sLQNXxMNUUf6YnupI42R7gjK7Gbj5RZLdSqayMtCx5amfWpfD3Lqf6oThk4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9b4b:0:b0:5ff:6041:c17d with SMTP id
 s72-20020a819b4b000000b005ff6041c17dmr1167011ywg.2.1706918966644; Fri, 02 Feb
 2024 16:09:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:09 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-4-seanjc@google.com>
Subject: [PATCH v8 03/10] KVM: selftests: Add a macro to iterate over a
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
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Add sparsebit_for_each_set_range() to allow iterator over a range of set
bits in a range.  This will be used by x86 SEV guests to process protected
physical pages (each such page needs to be encrypted _after_ being "added"
to the VM).

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
2.43.0.594.gd9cf4e227d-goog

