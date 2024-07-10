Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F8167DA8
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654975; cv=none; b=mwf8OwFd8uIzFSelxYld0kMVOMf7Tifo5hFQskbd6VGBVhLs006otLwd1FZ3zUn4RIrQXXSRGzp6gkwK0KybDWIcUIT0iT9bO5l1RoSll3a5bxSTpgllULTXggh8FLVwEDs6Dapf6Sv1Jso3ApisAR0wIn2fiopUsRKWfVxQmTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654975; c=relaxed/simple;
	bh=9nGVvjTtRrzXeDKQT/PGApCposmumXI12BdKtg64Aj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e0qz0+2pzaBcpniU1puQOWvSRCZR387EV/rzbhVS4eazQWRkKZs9amTdQ7ZhC0C63cAzmMqStQ0soZcTAv3CJQnKqkHfNTimQ3Rzo7w6g443Y89ttDav7+G1JIbP4Rbj9TYEYgRDBHudKz9tlTTecELMgSomW3SLbVSwoKe5tGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H32Kmc63; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H32Kmc63"
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-81027bdaca8so55225241.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654973; x=1721259773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=86wUnUhZHhvP2m3KtD2mzNoNsfKZM3y2BVe++0uTyFA=;
        b=H32Kmc63YgWV9k13j0+LRkK9/D+TaWrImx/8jXtRCOwCL8CdGzXAM/8RQp/GejBOGt
         KpFt9NfPcHSGSmRcVykrS/ZzoLeskwu0u8AQLMqxyl4gF8Hh23DgQSa0EcAQMxH/TdbW
         UFMSEIB5t7z8iS/EE3ShYu9yScbGnVyqZoZogaJhJdcxz5HGdqcAO2W8WbjpEg7B7otE
         Ai8stRB1pk18IJZydKVn9U2KcB73sxVjXYoKYhyvusaa6w06m4nEUb0SFRlmWPhEGAoK
         MUIgnWonyzFFOY8LX2mhcwc0lxi/68lRjY4fTJwiI1/hfUzxOmBBNwJ9gjPWDfiP2zz1
         AXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654973; x=1721259773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86wUnUhZHhvP2m3KtD2mzNoNsfKZM3y2BVe++0uTyFA=;
        b=qubPG9eZ+4RGAzLQyiA5KnPuWMDkN8f4a7WUCFWGUEYkdu0++bqzjXJFJkoUYp/OFx
         iZIAgy7IlppPbVC05sur3uvduzjHtx1Kgfl5Hw6Sku/c5kHsE/Hby4X8c7EETybe01+f
         MNlJxwWP+fOD9c5bOfVoxpGxz5cGHPTKOAom0Rygc1CGNISyu8x7ADUpjUrWZsbIOOU6
         N5nRzLNMN2tnfpTZwu4rpa+Vg9GcVXDMPVdhPdnH5eO/abojxFUnJylIg4Ad2HBIhGNB
         aSLr+wp9r/hARXyBu/J77GeTk5jl0zPBIofCnxo73iZ2GXaJgFmaJ9e+tTmJRCnokV5T
         rnQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA/tUJQcjFX9r4+rRRGiRyK3iULQjB7oUVSCz4KMjCFia0a+j3TgwfHTCdPBEtW7f2TMNy2oJ1JvvcyAxnwUD4wx35PkJX
X-Gm-Message-State: AOJu0YxoxVg4t95CkkSFDgxmi9Ylzw7eDbICOrXjb243fDTcynL/leEh
	kGoXmbQrVvWKV0uSQNaq7bV7PmN2P1hyxo5JhqtMEEllxoTQY0Gpy0pwgBRKqUqXqA9WTN3/5da
	nvQLY58krI4tXMDTJfw==
X-Google-Smtp-Source: AGHT+IFuuD8TX5cMTXqfbBITU1Rk5gbgp8/gjNqtfzjUDzjMtEhdHehLKT0HBMd1mO2mStlwTdwfc0NYjYZ51/Zs
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6130:2c07:b0:80f:e89a:dc21 with
 SMTP id a1e0cc1a2514c-81076f04ee0mr30519241.2.1720654972976; Wed, 10 Jul 2024
 16:42:52 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:19 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-16-jthoughton@google.com>
Subject: [RFC PATCH 15/18] KVM: guest_memfd: Add KVM Userfault support
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

We now have to pass our struct kvm into __kvm_gmem_get_pfn to know if a
gfn is userfault-enabled or not.

For faults on userfault-enabled gfns, indicate this to the caller by
setting *pfn to KVM_PFN_ERR_USERFAULT. Architectures may use this to
know to return a userfault to userspace, though they should be careful
to set a value for *pfn before calling (e.g. KVM_PFN_ERR_FAULT).

While we're at it, set *pfn to KVM_PFN_ERR_HWPOISON for accesses to
poisoned gfns.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/guest_memfd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9148b9679bb1..ba7a981e3396 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -542,8 +542,9 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
+static int __kvm_gmem_get_pfn(struct kvm *kvm, struct file *file,
+		       struct kvm_memory_slot *slot, gfn_t gfn, kvm_pfn_t *pfn,
+		       int *max_order, bool prepare)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
@@ -551,6 +552,11 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	struct page *page;
 	int r;
 
+	if (gfn_has_userfault(kvm, gfn)) {
+		*pfn = KVM_PFN_ERR_USERFAULT;
+		return -EFAULT;
+	}
+
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
 		return -EFAULT;
@@ -567,6 +573,7 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return PTR_ERR(folio);
 
 	if (folio_test_hwpoison(folio)) {
+		*pfn = KVM_PFN_ERR_HWPOISON;
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EHWPOISON;
@@ -594,7 +601,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
+	r = __kvm_gmem_get_pfn(kvm, file, slot, gfn, pfn, max_order, true);
 	fput(file);
 	return r;
 }
@@ -634,7 +641,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
+		ret = __kvm_gmem_get_pfn(kvm, file, slot, gfn, &pfn,
+					 &max_order, false);
 		if (ret)
 			break;
 
-- 
2.45.2.993.g49e7a77208-goog

