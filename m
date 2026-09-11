Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5595486E6D
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134683; cv=none; b=r9BYyBeAs2HmZx92GIPhel96mzYaXSuuKgXseNME3vFV5hPFqtTWeNzbwGhUt4Hrpr+xnZ0VPWrLC1Xv+lhXy/RA3otzH5Db4A3t2RvwksK+Wq+zrXT+j4idsBbd5OsDg3HHA8SraR8aVDvE1wV0NSiLxn7LUzaYwtnDIlEMldE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134683; c=relaxed/simple;
	bh=FM+Y/b00JCVlYvgq+9se4KrnYVsbjVcMtU8GIzq5FZs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rtu0UTJ9TpuuRm92R0GW5hFT2m53G0SnjD003lI5noS4msjvO3gAQ8fXvHcIcybegAaj4NWKQzmJk39O3IAQHYioj7e6kWRQs9FloJUAB4SiUSySrr33rKB4cx0juHBv0f6SFVczjo97B0mG4/+204G7vgXMzYnsfSz8wTLcDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cdpf3v8f; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cdpf3v8f"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49ccfbe060aso6230095e9.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134680; x=1789739480; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lWgZZmmnOkZYQth1/fyVx8z10swfdBk8thJUjR+LyQM=;
        b=Cdpf3v8faKUoaiP95eAv0Zf3SkfLqG6Ti491+yWff6RdhJgKuB7D6+3nbxp8DsGUYq
         VAEEUjyMGSkecO88WzGIji13xjS4LRkTOY5IBgUzTD5xLzyFp34TThQaRBxAom2znt/D
         pxq3SkAF9UAxIxYXFKVIlsgAAlDty59+lcM7j0S5crYoTxdPG3aVGgZLd2NX6Y5hC/pY
         Ikb6Dmuh4OLOkLxa1A7WxbhJig0+dvQjJ3tiTbI0gDn0WimVRm5J2SMAFm6kILex57px
         SkmpLJFy7urFpLWrOPMFxXWZ2RX3NFLc7RSrNxRuQSi8D5vIqm/oGkL+beHKdYpqDciT
         ouSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134680; x=1789739480;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lWgZZmmnOkZYQth1/fyVx8z10swfdBk8thJUjR+LyQM=;
        b=BL8yIcM/aMstr8oTx1dvqMy+gBuYVuzDlCyoCkH8Xx8gA4KbhYW7ePKZFhUTosTgVU
         yPl53Ql5tZCQaJgolbWfGFGYOyv7UOZy5FliXGeiFBZwKkn74e25wCMpHccrnn6bElrX
         vHbGR8HdjwHlpaY4ZjAbaEUc0D0wXkQigUNt6LoLfDjgoed3fSwTsnKCOXbjePAr/b9P
         v0V3psh6h9T4iXQoKEFEEbRVMkUUvQDi/el/6jM6qtDCFXICmVFBlfwykTlLyahLuhA/
         ynFxN/d2NrtkY4m2rJ5OlynftB4EfJa6vfdBa+tvTn3/UVVe2Fre11Nxc2EFHCZ3CVFt
         jQRw==
X-Forwarded-Encrypted: i=1; AKwUvByPn1mM7p19DkoImhcPlJEv6UxW9TFzhxuEipbzD5uY2k4K9WJxXpPUtuOfBsQYdczKQG0YVW0=@lists.linux.dev
X-Gm-Message-State: AFuF++lK5jKe1xJBTwXwBxrjnlBy8temQdXi5JRkQwtKwQpQVN3g10M7
	hzjX+67/H3C3Ve0YIbrvwGB0CXN6Uq+q8buvGq6EAHUl4yctpdChKtDfYMTIsCVs10IgaQWFWfr
	GlXhvxpdQ+xqg3/gH/zeB9w==
X-Received: from wmoz24.prod.google.com ([2002:a05:600c:798:b0:49e:6060:6da9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5487:b0:49c:fa21:e747 with SMTP id 5b1f17b1804b1-49e619dbc2bmr48299505e9.29.1789134679658;
 Fri, 11 Sep 2026 06:51:19 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:46 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-16-vdonnefort@google.com>
Subject: [PATCH v2 15/22] KVM: arm64: Warn on pKVM guest stage-2 block collapse
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When pKVM is enabled, the host relies on a pkvm_mapping tree that
mirrors the actual hypervisor-owned stage-2. The hypervisor is not
allowed to silently split blocks or collapse page-tables. This should be
treated as a bug.

Therefore, WARN on guest stage-2 page-table collapse which would
otherwise be fatal anyway.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2893183c2056..2e8c241f76c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -226,6 +226,12 @@ static void guest_s2_put_page(void *addr)
 	hyp_put_page(&current_vm->pool, addr);
 }
 
+static void guest_s2_free_unlinked_table(void *addr, s8 level)
+{
+	/* We should never collapse guest stage-2 tables into blocks */
+	WARN_ON(1);
+}
+
 static void __apply_guest_page(void *va, size_t size,
 			       void (*func)(void *addr, size_t size))
 {
@@ -294,6 +300,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 		.put_page		= guest_s2_put_page,
 		.dcache_clean_inval_poc	= clean_dcache_guest_page,
 		.icache_inval_pou	= invalidate_icache_guest_page,
+		.free_unlinked_table	= guest_s2_free_unlinked_table,
 	};
 
 	guest_lock_component(vm);
-- 
2.55.0.1007.g17ff1f9808-goog

