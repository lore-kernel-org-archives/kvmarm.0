Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33546374DF
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/dSl1gf"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso1598508276.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563824; x=1700168624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e/ZPH+fW+W+TWa6v1thwgh3xl/A5VwjzOhARfEMfmNg=;
        b=l/dSl1gfwS95xLJJcoYstPKj/MGu0JmqH1SEEZ/lzYuuNlOIh5RSFPVQwfKETOF11J
         fzFCMqd0SGBCONGOuq28P6iyjL/X7l+mjihJSWOksgdntV7jSvqWblgqbsSYd0q7NZgJ
         QGE6U0x9gBGnCVQJBkoPMkPwwT9yMFQsTmfJHZwdgn5Oh6Kv0tcgeGZYM9lnhzpkDxMe
         y3fF7l1huIrh2feE2b2VIk25119jkHXKtoWV4u7RmYJlTAHhwez6cYMf/4txcGR97AQJ
         B6pJWmmiFKwLJb62QN5B03oOZUKy6B58kvki/NJIK18K29Dt6FTKTrlDsVDIsotqJ1Hx
         MvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563824; x=1700168624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/ZPH+fW+W+TWa6v1thwgh3xl/A5VwjzOhARfEMfmNg=;
        b=IhlrwVBO5fxp4Vk03PGG/qliJLBxB2cE9def4N/2/F/v41bJywKdD9Ns7aFPkA0jLx
         u2VZaK118U+OQDCaHROLyHgqzDqT2fm2IzZlr/Nv2K8F+CCiSzDV4jIYRw6YvtnK5SGQ
         iYjc1RzKooRmtP74OuA+EsRfy6osAsGSUsHx2zOWxRa9s3gJOQ/bstiHydUKqQubXpwH
         vtgfmXFOCcqTcmHZuydbxUUEJt7ztbHjMi0MMaX5/wRVbdR9fCeNy5oWkr1n8hWXhbUs
         euTY7SLQOAl9JQPTyrCCY/RO+mM74svhKXYaeOcDvDsVZPOSZGWXmVBJ+OY58ujS32+Z
         lnjA==
X-Gm-Message-State: AOJu0YwlH7Clrm7w8bMBehJpdTSZnZQCaJmm69V1xbPF/vkBhOhrLJ78
	eYk+jJ1fnlhOkxhlVXpzK1M3hgiW8+/86w==
X-Google-Smtp-Source: AGHT+IGaEfaKBu+8pNYilCRAtbdsyMyIV0FpZwyPySRyn2xcyuTHN8dL3ZSfFTUzVJm9BYhJ0Q8k+CrUz239dw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:828e:0:b0:d9c:bdff:e45a with SMTP id
 r14-20020a25828e000000b00d9cbdffe45amr176664ybk.12.1699563824210; Thu, 09 Nov
 2023 13:03:44 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:12 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-2-amoorthy@google.com>
Subject: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The current docstring can be read as "atomic -> allowed to sleep," when
in fact the intended statement is "atomic -> NOT allowed to sleep." Make
that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9170a61ea99f..687374138cfd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2983,7 +2983,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.42.0.869.gea05f2083d-goog

