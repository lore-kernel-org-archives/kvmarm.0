Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188FF37A848
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789320938; cv=none; b=PSGnpqkF+X8WXM19Cb9BnoUBJwt1llQlG/X4GqmZqFXC1sgajRL0iXavQE1rMj+WTTh447q3NfIPSBgbjWCRZS2xxcQgwsVzqEDIa/Z01klEB0b/ll+haDfZGqSRpgnEvY/tOhHD0vpIBCZb8rPT+LfGdqNTjnb10GJlQFljTB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789320938; c=relaxed/simple;
	bh=oojpCCn9S905n9dIf4cWhtFLz3VR0tFaovcpa1/k+Yw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XHnDQXCa2gIF0M4ZslVrXKdZBhikVWrUGSF3obyT5JdfshU8YM8HfTXubO69LRyVa8JoAIZzswYsAo65X6Zjx+x61CSvFMRUoLYcBkX8GcbeFevWVu4voKZeTt0C6ZoIen74FuJ5hHFeVZ63tJwjjtwV2kaW1BaH1KXRRH7XuKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yu5CWv/d; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yu5CWv/d"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e6422198fso15724055e9.1
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789320935; x=1789925735; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WrvnXTAqvwcTzxE8seUUXgtR7H/O9p43WXWIeIPgMYU=;
        b=Yu5CWv/dLB+ojAu1QLI5th+sUFsGh+ioPh51/iIL+MiU1PQxqVrUfBuiyks+IplUKd
         HdtcggCdfAqJuR7zFtHY9ZC5kiaKfLsj/C1LvxyZDAYbOps0Gwww4xTzIgivC/6LAvC9
         eh/1ViazlH+UESMEUNi6UjKy4efQFz99Utp31Q95kbGRl5ogVnhM+ISAe3NfpCiWpKCH
         R+uMCBZvxrILPpqR3wfCWUELravDzQmA+w/TNRtdUvbblCWN5nto4BFQUgmpWsZw2HpW
         UByCghvZ/V6lrVEnC2AmIUmY3eobJTkgL5VoXBst7azerabj7KLshWs4F5yTY7DzJzMN
         TRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789320935; x=1789925735;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WrvnXTAqvwcTzxE8seUUXgtR7H/O9p43WXWIeIPgMYU=;
        b=qZIMeo3yc4wEf4xhSIWWVt4u7o9uTmm/X9q9bCOpQzDykN7hp/0jNEj/oqY/KICEQx
         m4cqEqEz4MmHnk0L/2j3MrmtfGNXmakLtXSoogTaRqTIAFMEjPrPXnXZcakgFclC/JQz
         Qge02Ox1Ngxcwc480DstytoiIyaw+mrqA1/jPkAHVTrLMhFK2GDfwuBHJgxoHTyUV6IQ
         k1QPAmsdQr9P7S1S8m1GZkU5w0ZjoF/0umNm1V0dhyTqVo+JL2NseOODGtPmWDY24roT
         +xdqC1ziXqpowxx8yyai9TsOI+VFhPP0f/0OOEvHFD00SQB0pSSd7HAJ+oHDJhmdepG9
         L4PQ==
X-Forwarded-Encrypted: i=1; AKwUvBzah+o0Q8Wi4gZQjCTtEIGoecksvNeAg7GPZUm4nwk6tDGhOl+L8cqMMMD7shFY5MByxquRcwE=@lists.linux.dev
X-Gm-Message-State: AFuF++kHWQe1T7b4IWPrEp6WFpCD1pqb5nnitWVtwZ6VfTR2dd/yBlxg
	XrNjeS6O3rminnHaJ8hDYYLvJ9JHXnZ7JiUT2O4p0MQn9tMmy3BJMGZ9O4CZQnemy7AKY0jK1Nh
	4MZIc/A0RCZxeljZk6vpJgA==
X-Received: from wrbfi2.prod.google.com ([2002:a05:6000:4402:b0:486:ef8f:f47])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c493:b0:49d:2607:4ada with SMTP id 5b1f17b1804b1-49e619bf31cmr255115085e9.14.1789320934793;
 Sun, 13 Sep 2026 10:35:34 -0700 (PDT)
Date: Sun, 13 Sep 2026 18:35:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913173516.3122436-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Fix protected VMs fault on system with pages
 larger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
of pages larger than 4kB") fixed the boot of non-protected VMs on system
larger than 4K pages, align the fault IPA down to the page-size for
protected VMs.

To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
as a parameter is aligned to the size of the intended mapping, while
HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
system page size configuration.

Add a check at the start of pkvm_pgtable_stage2_map() as we do not
support !PAGE_ALIGNED arguments.

Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c  | 2 +-
 arch/arm64/kvm/pkvm.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..e8d98957531a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1756,7 +1756,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
+	ret = pkvm_pgtable_stage2_map(pgt, ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE), PAGE_SIZE,
 				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
 				      hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..1ca27d01a3ec 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
+	if (!PAGE_ALIGNED(addr | size | phys))
+		return -EINVAL;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0.1007.g17ff1f9808-goog

