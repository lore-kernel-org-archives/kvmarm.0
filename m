Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B011FB3D6
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584758; cv=none; b=BbscEg19m9yDnSYpvLqAWdyl1MlSLXeVmWA5zzHCuioeAR/Cxp/4ldC/s6Cht1z27UfWa848147otqZhuZll8ll04+/1R/BdAkMF4IpEkK6fpmbMwHUWmdaBoylQL6kXGUnYrGVZaetZ0xWfehpiAVlLSm+Vj0QPd1Oq1N41kgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584758; c=relaxed/simple;
	bh=bnwD3uEfCD/YcddkLJu8d23/zYqKX46jf2vKJvYQlNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fLpnJViU0yQced6zi03jcSDOCSwRPQ6DrjiSycslmYVVCVIEullpV//mlddLfcNGgJgbYzYBYu1Jr6kUAL3htxUJComNVdqEKHR9jcWGbmKyimm0xgm4ih/EFIJc2fdNMJBUzhtkWxPcBmPMVt7ooLHwe/tsHihY3gformHU0RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TVUvfdR+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVUvfdR+"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3231725c9so23554707b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584755; x=1729189555; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/prKt8Bu+DRISNBcov5NrkfgoAIYHMahITKzCWpSrCI=;
        b=TVUvfdR+m7Nxfnjkj+na4eC9ADSx9Yl4kKr/+bK383QLJwmPxTUxJEzWPO2OaOvbXZ
         Ag1agHIVKTczUT9iNURRD1guiPjySwXiAGcxjW9PZ1nctNEsXF57w432xyGhglOmG6Ir
         gsoGVGBBIcGv/RpcO0+MUlzfNYiO9IdF/lhpjITXWRi0H0AUSC9e47Bptm1AkL7jrs33
         LLwolx24ghv461tz7IXkO2nDCjmAfLseJSqs5UxQlfVZcIvo+cx0iuIitQ1TCuf3Kpp+
         qruTTyV8BdCp3/1icPY4/p1Tt9enkeNVRPMQx7dfYmPwCh17nj8FJR3dymQNi4SKPLeY
         F0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584755; x=1729189555;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/prKt8Bu+DRISNBcov5NrkfgoAIYHMahITKzCWpSrCI=;
        b=B+GUNvInfF05aZmju8F5SjzDjISpUVar5a3msoh8am6otVIG1NX06ltCBARcYn8y7V
         sh4FlknJzo5qEB1V9d3Cfx6Oe8KHJ5UcKqXwFrAeuwhPVaAdcVFvmPkdmGSeZfruTDZv
         oARpb8veGGJAXqLUa1ouJDqqmv3UNzRBK2ZGFkfVZNF/yppq0FDEwojuggaSECyoCo1q
         W//d0ptUw3UiJwbSIxdqa8U0h6+fIagJYYx9zWIOecXpYb/SCJz4PGMKVs4RmY9QItTm
         X/PQmSj2zQmQzlo8UWWPZbUf/FCzf4xlv6trlQBCcAvbcKVcjle3eSYq4VfygEakReXB
         PWTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOQqRzCWKVMemthlNAb68C5NKMuEZFYAnqyUSAvtwc0j2+1Iph/S7RQ68Dt8Kb0YaPwrs/72o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1I8rhMgtR7TXnPHxi/0EHVbkFftDks8HInUqwhhk/QhPYkVYG
	971HlvWQI3h8u00lPum8saE0QoT4MmPENp8Pgyw+R1QqCVvhjGxCs04RkHJr051hb8CE3jMamPR
	Q/w==
X-Google-Smtp-Source: AGHT+IHNZW39HKgOpo4XLx10sqcp5MldEDD35H2r/7z7SkgDatDPvbEuIFyvlgb9BtXWEl9gaR4EDWCFxGs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2093:b0:6d4:30f0:3a74 with SMTP id
 00721157ae682-6e322171640mr1011347b3.6.1728584755409; Thu, 10 Oct 2024
 11:25:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:32 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-31-seanjc@google.com>
Subject: [PATCH v13 30/85] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
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

From: David Stevens <stevensd@chromium.org>

Migrate kvm_vcpu_map() to kvm_follow_pfn(), and have it track whether or
not the map holds a refcounted struct page.  Precisely tracking struct
page references will eventually allow removing kvm_pfn_to_refcounted_page()
and its various wrappers.

Signed-off-by: David Stevens <stevensd@chromium.org>
[sean: use a pointer instead of a boolean]
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e3c01cbbc41a..02ab3a657aa6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -280,6 +280,7 @@ struct kvm_host_map {
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
 	 */
+	struct page *refcounted_page;
 	struct page *page;
 	void *hva;
 	kvm_pfn_t pfn;
@@ -1238,7 +1239,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
=20
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset=
,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long l=
en);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6cdbd0516d58..b1c1b7e4f33a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3093,21 +3093,21 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn=
)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
-{
-	if (dirty)
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-}
-
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *ma=
p)
 {
+	struct kvm_follow_pfn kfp =3D {
+		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
+		.gfn =3D gfn,
+		.flags =3D FOLL_WRITE,
+		.refcounted_page =3D &map->refcounted_page,
+	};
+
+	map->refcounted_page =3D NULL;
 	map->page =3D NULL;
 	map->hva =3D NULL;
 	map->gfn =3D gfn;
=20
-	map->pfn =3D gfn_to_pfn(vcpu->kvm, gfn);
+	map->pfn =3D kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(map->pfn))
 		return -EINVAL;
=20
@@ -3139,10 +3139,16 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct k=
vm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
=20
-	kvm_release_pfn(map->pfn, dirty);
+	if (map->refcounted_page) {
+		if (dirty)
+			kvm_release_page_dirty(map->refcounted_page);
+		else
+			kvm_release_page_clean(map->refcounted_page);
+	}
=20
 	map->hva =3D NULL;
 	map->page =3D NULL;
+	map->refcounted_page =3D NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

