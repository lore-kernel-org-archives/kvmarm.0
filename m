Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA21204087
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584785; cv=none; b=T81NvTwi8IU2bO9DBRe2meLLavh5GaBjGWFrbggsk7Cs9LXcRlOlSzDC3aei91BYYwwVBQkh7eXDa/loP56BFP0DRIxWkqUet/BaKW7KWTWI4pW9aY6FZPJLBZuIBqHeT6oGWHToEzU1xgoRTZhzz+bjnVWC+0YiSLX5Og9kSvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584785; c=relaxed/simple;
	bh=acp8IhS6KrAOGkkRIhpxPxZ31aINXkAYcQRqekRRiYM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCoBJpo7gUB4MDJqKYIvpezqr5VpuwHjcm52zTTJdzAQ4kWbYav9btCBG9cOMGQq1gxejgEo3Ph08BMA49LacJSthklcDe60I1rWu2IxtKJm6+HOJIoHPywNFP3dZmYRx4lfG6Z2KvztnCiYlJFbkKMwmtAVxjObHO4sQAzCj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e6vkh4AU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e6vkh4AU"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e32f43c797so11872057b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584782; x=1729189582; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHy2j9VNwFKd5G/Ubc3O4QkXvNoIm5ox3M6XZ4oswcY=;
        b=e6vkh4AUmtis+/LsfhjtbeDtHoFC2zz93N/powEQSHIeTVuL/7obmGczo5AOTaX0J3
         j7CNVkKybdFIA37hsvbt2XMI5s8VeMWFGvuqwTaXkajYZLZ8sPhy9LlU+wch1fBpO67k
         7+caniiR/+a1/kT0T6FJeOOmyncvlgdGO3dNmDk0V2zaohS0KoLbYbMX7nB5ohVnTpJH
         8KdGQ526Sl61qBrZ58zefpdTit8Akfc8uY1eZxAXy+U3q0QNY+TSuv/NFOtYUhG2UfqE
         unTFxpsdL5HE+YSYTQd0rd68ZhyKp7z0X2pn2Spn+yn3duz2ahlI/5Wi7yMR8Pouxx3u
         dNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584782; x=1729189582;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CHy2j9VNwFKd5G/Ubc3O4QkXvNoIm5ox3M6XZ4oswcY=;
        b=Ffre0m2yl+fl5UpQWZbbm1NWejQJ62noogf4irwxhXiOBVkTfNyesmRwDdxF/sHJiw
         4qztq/pjEBuDSFyJzxufvYmNrQQNekoiz+8jabVshzaLL+ofKN6KTcslVx94IPMHK302
         fovXYG7qsmELLnKD0htaLG2wVIkXVizOPn3zXSMW3ov6Va1E7EWkyDGpZLk9Z/IPHcB3
         DPH5JfckbyRihNettY6eiOs4A2LGUoy/P8crQYi4QRjkyJWosz0oqRFFyyz1VTViPwF/
         9kGAOmKuWA2v+WIyzhAKIxMlc+fjdg2eQq7qQaziHxVr7EOluNKmztkitE9TWbczAsdj
         Pn5w==
X-Forwarded-Encrypted: i=1; AJvYcCU8vcpk4Ogm1IzimYzwVFKmvk5p8Hjiqvod9ZtNvy1a8o94wgO9ZbPc9V2Sq6ZYBdAaXeZEJb4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1wWj8aluWewFdSzv953bh98SHvRZF0QUIG0KKcVn4S9pYnH41
	2jAUVnuKOLZ3rHhSuLkqEzn1JYfdxe/yInrnzujZBHI7NsApaARocJW96K5KChuQikMiQoRSiES
	jiw==
X-Google-Smtp-Source: AGHT+IEBXjEpYcXfPYRm3Nf4G9ZN1ucR55aqjscHr2p9QPsSrcRZYI0185ucK64AXquh+1QVcruWQv+kNDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5605:b0:6be:523:af53 with SMTP id
 00721157ae682-6e32f2f4e28mr919077b3.3.1728584781575; Thu, 10 Oct 2024
 11:26:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:45 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-44-seanjc@google.com>
Subject: [PATCH v13 43/85] KVM: Add kvm_faultin_pfn() to specifically service
 guest page faults
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

Add a new dedicated API, kvm_faultin_pfn(), for servicing guest page
faults, i.e. for getting pages/pfns that will be mapped into the guest via
an mmu_notifier-protected KVM MMU.  Keep struct kvm_follow_pfn buried in
internal code, as having __kvm_faultin_pfn() take "out" params is actually
cleaner for several architectures, e.g. it allows the caller to have its
own "page fault" structure without having to marshal data to/from
kvm_follow_pfn.

Long term, common KVM would ideally provide a kvm_page_fault structure, a
la x86's struct of the same name.  But all architectures need to be
converted to a common API before that can happen.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 346bfef14e5a..3b9afb40e935 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,6 +1231,18 @@ static inline void kvm_release_page_unused(struct pa=
ge *page)
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
=20
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page);
+
+static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
+					bool write, bool *writable,
+					struct page **refcounted_page)
+{
+	return __kvm_faultin_pfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn,
+				 write ? FOLL_WRITE : 0, writable, refcounted_page);
+}
+
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6dcb4f0eed3e..696d5e429b3e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3098,6 +3098,28 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu,=
 gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
=20
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page)
+{
+	struct kvm_follow_pfn kfp =3D {
+		.slot =3D slot,
+		.gfn =3D gfn,
+		.flags =3D foll,
+		.map_writable =3D writable,
+		.refcounted_page =3D refcounted_page,
+	};
+
+	if (WARN_ON_ONCE(!writable || !refcounted_page))
+		return KVM_PFN_ERR_FAULT;
+
+	*writable =3D false;
+	*refcounted_page =3D NULL;
+
+	return kvm_follow_pfn(&kfp);
+}
+EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);
+
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages)
 {
--=20
2.47.0.rc1.288.g06298d1525-goog

