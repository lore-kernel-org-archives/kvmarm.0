Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40001F890C
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584741; cv=none; b=RSdSSnKBNpfRbTH2MKM3p2BC1fveINkl0N+lB4emJqzhy/wUrbz7lbnb6wBc98VyWOGEIOpM30E3g3H/VVJkpvvGivKZpnZkm7tKm1NdU2pMPhDgrSbjRWq8F2vZLKuJUiY65dI0LSfYqkUlxYgzNXNm+GBuNeLCmhGlR0rkt0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584741; c=relaxed/simple;
	bh=ZlT2BBZrHMf0x3c0Y2iKgnaJviq4ilGlr1zNhk4Vq/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a18oQNaqJOWw+KDMvIPh0IX8VREdWkM9Q/5GknviX//ARaHPz9DlIAS2mRiCVxSf74XrPOcFyLuM2DMrFyRn6CmTAMHw3dYNAQKerk8NUhFN8KfOLDjgDBI6G+5QCRFErSyLNU0csUCB4PirsawF/vfI/qDopl4TDw5jvEkTltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZRnTvrHm; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZRnTvrHm"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e284982a31so22432717b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584739; x=1729189539; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wU+jX/zRq5GV793BchOJ2bBXpO8AjDudJh47DKJg70M=;
        b=ZRnTvrHmgc1gF8kMJxrME49G0VFw/u/xDgnyUY5oyT0UAJ8AJ/yg24sgTw7z1IlXbS
         AYZakdSgA+SEZj7xi9tWuxqn63n+kr7smdRWhWZjBU/bvW3PwI0HsmOUa7ZRuDMkYWYd
         vITBy2hroF1z4Ar+CsTd3YH2ob2deOwUGLwfVn241+lTf/KuViPP5P6MPJO77uv/qfWj
         CZRm92enoa/y7Cxms6X/SloWgT+k8xBB+nmVDdnBCgHaTlfYuWWVVA+XYo/+fONPQGIX
         7d8Mgphl9V+7m6uOt4kC+RqU2jMiiP8hMVfAu9nURLbNnrPnbOHgmCz+3YbPqeZRiieF
         W6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584739; x=1729189539;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wU+jX/zRq5GV793BchOJ2bBXpO8AjDudJh47DKJg70M=;
        b=Q6PB1SY1n19HuFPLSanK4NYA9DUChIYpj8D/D4o3V9Z5Fwnk/HF7OoDUoXQ0RWV8wh
         5vlymkOaBSTE1tlH7KwVRw60+13TnwfuZU/wl8eGOogyO2qyVTiCrEWK1UAjIxZTvQwO
         LzJDpQYaW5kfhLUEMIOFj8TglTN45jHSAEEQDLaDE7rAacvKhA+Q3OxMQQvR8rrz6ZLy
         /GwKlbiv8DGBftgzt2qwi7tVtqidE5VW0FI5wcGI1jb6xro0DXwRVkg1YzoXJtB5j7tE
         8wMhoAq2VO+ePFsRNU3WhEXRvjhjqELJwrPIqOrfE+xKhYxa7zw6d2qaTOHaExsfGatQ
         SbdA==
X-Forwarded-Encrypted: i=1; AJvYcCUTkbTXH0zZztNZrysRuXBnv4eNttbbk3GNALE9TdlDVOG31hHiFwYEqidBRlXD8c34eB49dUk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxe4CcsSN5g86n0dOzM3aodFPuOCf3djuvEQZOnHsxDiK3f32VI
	BiaZVnxFjEA3NFDvUXTBPvK7S3xfplcscVm38xisiY43KsDF96G5ymkdZQw2tpQyZGgseaHFZ54
	c8Q==
X-Google-Smtp-Source: AGHT+IGZ+3mddEgfwOZrB7Mg/yEB+clUKORcl3gwcx/GeFypDRI64NMuGnBtjzJ0gTzObJ64BsofGpKHxtA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ab6d:0:b0:e28:f8e6:f4c6 with SMTP id
 3f1490d57ef6-e28fe465652mr58758276.2.1728584738891; Thu, 10 Oct 2024 11:25:38
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:24 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-23-seanjc@google.com>
Subject: [PATCH v13 22/85] KVM: Use NULL for struct page pointer to indicate
 mremapped memory
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

Drop yet another unnecessary magic page value from KVM, as there's zero
reason to use a poisoned pointer to indicate "no page".  If KVM uses a
NULL page pointer, the kernel will explode just as quickly as if KVM uses
a poisoned pointer.  Never mind the fact that such usage would be a
blatant and egregious KVM bug.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 4 ----
 virt/kvm/kvm_main.c      | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cbc7b9c04c14..e3c01cbbc41a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,16 +273,12 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
=20
-#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
-
 struct kvm_host_map {
 	/*
 	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
 	 * a 'struct page' for it. When using mem=3D kernel parameter some memory
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
 	 */
 	struct page *page;
 	void *hva;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1c9a781315c..7acb1a8af2e4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3067,7 +3067,7 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
=20
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *ma=
p)
 {
-	map->page =3D KVM_UNMAPPED_PAGE;
+	map->page =3D NULL;
 	map->hva =3D NULL;
 	map->gfn =3D gfn;
=20
@@ -3093,7 +3093,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm=
_host_map *map, bool dirty)
 	if (!map->hva)
 		return;
=20
-	if (map->page !=3D KVM_UNMAPPED_PAGE)
+	if (map->page)
 		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
 	else
--=20
2.47.0.rc1.288.g06298d1525-goog

