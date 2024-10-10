Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749932185B9
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584858; cv=none; b=iVUHa9sT02UP5U5Nx29F2IxUMEnyN9N5ku6BCVRo7u+LP7R2o/9LJcahmwbjXSyIk69e74Ly6m9YlqkjE2IOITQEXa+YRGmjM/EV0PF1svnWeoSx4sMAYKijf+09uIqeJm7j9xdYpHqW/2F1NiRYbbBsX2Ova00it9vdrOsHAhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584858; c=relaxed/simple;
	bh=FErwCaq8NdcoMJPhpWM/50ZCDjLg7qNPTjMbO8/YuvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ar/O6jh/n94QUQ8i/aDniA3vka/mMRStZiyzPcaxcDcssRNiyjoRerlxgS+zMqqL3kkfRN0jT9BUzOh7emfnwwOiaKO41/H1ZQrJTwD/YSqAPr6GjOduEVZMypcKkKx1LN1w3e3eGbIGM5snTTIl1pNc/R1xI2r16npd9q63YeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OEM3qSJE; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OEM3qSJE"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea07766e09so1070445a12.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584856; x=1729189656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04eHUk6AClz9cRMQcjlWjE46ZR1uXceY2ogFB00LGDM=;
        b=OEM3qSJECA3RT9Ck5cp5iFniK2DC6yhWmZwOO3sC9z3ZhpjDV9glurW+NwzMBtMqil
         posU8N5BmLLmOWkXxsg9T48h6HrylUInS/Zv0BJHj+kqgzLjFIfD9WpsXu+MCQPaWcyO
         sw1W10RoYQowMrMyFb1W9v/nctlNRXqrh9dSjzXjCUwxwYG5GS1khsfm62YZFivO/4Qq
         /3LtnuEFdHwaoEERCC+IaCUPSipAY+KSl8UPIdzWDK6szI6/dulRioxwjSU8lpAwAzDo
         oNb0oYYokmnD7EEQjLrrr/3nFnVhPmYmMBKhZYFGIxw/iXhW4lR9vizUglI+O+o5xTt3
         H5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584856; x=1729189656;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=04eHUk6AClz9cRMQcjlWjE46ZR1uXceY2ogFB00LGDM=;
        b=g0AEEEYEDDWjXloWqYU0V0vq7paRrxEhjMJKz2XqJvYrRsc/8vHbWOLxrwH6zcXUao
         AvOWV+wPi6EbhIo5MNGYsQ0sEjpXh5r8OmaM9Hk0f6bG8SHgFHW1MZBn945pbOjAr/rs
         /VTD1L+GDXr8igTXmtTuiBVdTjTTSABcplbxZL3OL6206rTGLkYqaOnUxFjkTkKBrcFL
         fk6NTebEDwpSDHgBdzA5dF/RC1FHKN9UbteioBHrCO4KvmrDz8FRyC0Hbx3eBpVo2ryU
         3LSS9Km+OBf0BQVcRhXuvZN+1GcVJodRnDUA9KJ27NzOMnoUUBhBJTTdQzHao6TwEWS0
         xMpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrqBKdRbtdW6NjtDrKxy+ZGx24rqRx35/S7VL1nnvYicKNry2v1UM1/AcDL3cYJJGhQ4mNmFg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyX0aCJwvzj1jfMBj6nRBP3jR5goez0y4udavfAtYcZkcvG5QsT
	dvDKNx+eBypEFw+JqU2iNwe9JZ15H096yOZoNMd23Jwb6XKraX+/9HJQMesf8hd/4VFw+bQYZQa
	XfQ==
X-Google-Smtp-Source: AGHT+IHGiwNd3UbnZUzPre1tk98dNYoM10q7gFGG4lq0PldsJuDm1rxMHI+g8Yc3UsVnmkzWnOurUMFmqIQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c4:b0:20c:8f78:67c9 with SMTP id
 d9443c01a7336-20c8f786946mr26385ad.5.1728584855618; Thu, 10 Oct 2024 11:27:35
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:19 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-78-seanjc@google.com>
Subject: [PATCH v13 77/85] KVM: arm64: Use __gfn_to_page() when copying MTE
 tags to/from userspace
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use __gfn_to_page() instead when copying MTE tags between guest and
userspace.  This will eventually allow removing gfn_to_pfn_prot(),
gfn_to_pfn(), kvm_pfn_to_refcounted_page(), and related APIs.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/guest.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..4cd7ffa76794 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1051,20 +1051,18 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 	}
=20
 	while (length > 0) {
-		kvm_pfn_t pfn =3D gfn_to_pfn_prot(kvm, gfn, write, NULL);
+		struct page *page =3D __gfn_to_page(kvm, gfn, write);
 		void *maddr;
 		unsigned long num_tags;
-		struct page *page;
=20
-		if (is_error_noslot_pfn(pfn)) {
-			ret =3D -EFAULT;
-			goto out;
-		}
-
-		page =3D pfn_to_online_page(pfn);
 		if (!page) {
+			ret =3D -EFAULT;
+			goto out;
+		}
+
+		if (!pfn_to_online_page(page_to_pfn(page))) {
 			/* Reject ZONE_DEVICE memory */
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_unused(page);
 			ret =3D -EFAULT;
 			goto out;
 		}
@@ -1078,7 +1076,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				/* No tags in memory, so write zeros */
 				num_tags =3D MTE_GRANULES_PER_PAGE -
 					clear_user(tags, MTE_GRANULES_PER_PAGE);
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_clean(page);
 		} else {
 			/*
 			 * Only locking to serialise with a concurrent
@@ -1093,8 +1091,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			if (num_tags !=3D MTE_GRANULES_PER_PAGE)
 				mte_clear_page_tags(maddr);
 			set_page_mte_tagged(page);
-
-			kvm_release_pfn_dirty(pfn);
+			kvm_release_page_dirty(page);
 		}
=20
 		if (num_tags !=3D MTE_GRANULES_PER_PAGE) {
--=20
2.47.0.rc1.288.g06298d1525-goog

