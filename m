Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2167B46C859
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250194; cv=none; b=jcrT/bfH7iGaKBGAqjZCbRYQ9Lcj7N+Cz4qt2nFkhx4xFM5w/ZieJVz6hf1fUzT0RaoBM+xygpk2B8XvDG0rduCWYkLGFD7aCqZ+cZkbbe/4z5DK+YFPmZxJ1dEeOTu3wlKoQ9k3h0TcHnwxHfMAlsYe1uBtZZj0ll+7XZNRGeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250194; c=relaxed/simple;
	bh=L4xPoqKp1rKEukY8cSf7w/1IbdA0r5tMUck4kqQP4Zg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sevqxRKD1mWw5EVs3780FcEVWGWpTxmvEI5swm3pukkHgqcO8K8spwx5oYpklAw/graK0H19uW8TgrcuRB5k4oxcxmQIryL7D8exak/LEzVMmBMRLmx3VyEj/WtoKCRLd6iT9/RM8TfSkB12j6GiZo7fRoXlWQ/y8wIRtIZnGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sTadnOgd; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sTadnOgd"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a57aa07476so6109770a12.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250191; x=1788854991; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w7ohw21peF1wa7DEgIBZtn4bdrDZ/CehDFJ7shfFAF0=;
        b=sTadnOgdHKLXOe+NtnqHGt6X71lL3rchGOEKbtMgE5eX/W0BsNI25xDCx/KI+gDFGN
         J5oLc7BYbgKbHAu3Cl1eoG9f86yQQggr2XLQBpaga8rnYlyHSnPxggUfQpurQ37wLCJI
         ktkC5+tKpiVI7XuZ9JSwQit20sBQYKI8AELAXnT6MetuAgswTTR/9WgKZ97Yladg/AIz
         VbhBT0UZAuh7TR89RgDX+FSmB91eWhBf1Vh7KizvFrUjdyVWhp8YK+UB8Q+4QsudRCFR
         YQG8vIFgKsJl8sEq1j43ro9+fr7gSsfrai+Yb4200IE6hxrWziHK6pzERX6Pc5xJeTom
         4GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250191; x=1788854991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w7ohw21peF1wa7DEgIBZtn4bdrDZ/CehDFJ7shfFAF0=;
        b=fOg5+YUXe+CdAviICclfkZ0ulv0jXdiQBgS/oA3FmL0nGS3umSKl/ahvDtsDy+ZlqR
         Y5gh1KBYhQxgFpjcF7Hwz/LWbRvycfvePeUfuQHr1DsPgmHlVQpwE7v52OwMPH+zyZbT
         MMaWKabCZsKQzYxz5jHDzyRHkRldWL7P+2Or9ti3KlvJHHS5GVGP5IY23utAw9RKnH03
         xpSBHwuq24EHRQX0xyMPRfGSKJBGsWW4MLYxXtXxCMUhLkAfSE39C0L5/NEcxIIoMjLG
         m/zS+28a6IwZsmfmhDKYBJjuYPUI93gOLT0hRtZI6xgdb7vL/a2yXaGfsofg9ft/6I9y
         mIYA==
X-Forwarded-Encrypted: i=1; AKwUvBxVIoYpWVVGvD14H0nK9UnU6jwEIhYouqx3k/ymMRc3BGoToF3EcmOu3uSiqm7+H4RD5TfKXIY=@lists.linux.dev
X-Gm-Message-State: AFuF++leoV7mYKR3PB/W+tiHiA348bIXuEACzanBfaHIOT1U2qVrbH5J
	UfWvT6Fdt6mY0EaoJ4T7ChJqgn1oQVAio/HfIzQNnimsqoC1fsI6uawpv8hxSlupC/Oh/M2E38U
	rWNFahU8kLyekGfAYdjgacA==
X-Received: from edbfd6.prod.google.com ([2002:a05:6402:3886:b0:6a3:facf:9e96])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a6d2:10b0:6a6:1719:3f42 with SMTP id 4fb4d7f45d1cf-6a6171940bcmr12374431a12.6.1788250191164;
 Tue, 01 Sep 2026 01:09:51 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:25 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-3-vdonnefort@google.com>
Subject: [PATCH v5 02/18] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 85f1e3c711d9..00cadd13ee5d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
+void pkvm_remove_mappings(void *from, void *to);
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 755630c0d15e..9ab7f613fa36 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -164,6 +164,24 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+/**
+ * pkvm_remove_mappings - Remove mappings from the hypervisor page-table
+ * @from:	The starting virtual address of the range to remove
+ * @to:		The ending virtual address of the range to remove
+ */
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	WARN_ON(from > to);
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.55.0.897.gb25b4bd76c-goog

