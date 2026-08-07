Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5547A87A
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121032; cv=none; b=AUDRBoI0olqjicHmV4zJ3AWDEo7JP4VrlwYv6PvBqkSCUjGz3FZdER3klKRmTvaww1oPzcmDI/tdscJdHrb+PTCjUpPmKUuuIOK+RYJarO6NqbwaVmKtwMDNehcZg4DziQqDqQCavk5xYCYNY/Y/eaCIBsUKklmO4E4m4uRpYjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121032; c=relaxed/simple;
	bh=B+kAmOvqka3yjYQ9VnbQJbNnM0ujY92oykRZepshn3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ILVsEq4OHvcHB+Em+U2SjnWQ/msIIL6XabIVnPI3I4tAmFdkygS9QJEpcJE4kmFd2cPOwmTMrKr4LsZ2CftntGVJ8RxxgRfaE9LLIpOCm3pi+NAOmtwolAzHh5WJ9QOWjQyUjA+/xag1yR33av47M4w+DESGwfHBJ6d7JSznGcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KZcRVN8W; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KZcRVN8W"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15dfd34e4cso272261666b.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121029; x=1786725829; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aee98ZEVCnU/nGC9n5IlQRH4Fbf+7bsHwlgyxI01O/I=;
        b=KZcRVN8WIM3Qb575OTNf45L5p1fKFQoGVrOBAWC0AbV37RraC4O/dfS+KY1tsr5R6+
         DZ6l/cyZhHMhFwECb2tE3Oy1tvcD61VqELXbs+ZlTjNGWM4xBbyqeyHdxJhQGaK/UcgE
         oBP0U3mcRF0nkuWyIStgtSyXqxrL0eLxtFoJoiJvaUFa9ZAAbIX0HmibY0O6JnO990vd
         9lzrbfJAylF0kppTpF8aBhqlDaL5jdfaWTcYoupSe5h54bcSYMrA28kkbpA1/9DhECsw
         r9ohco5+BShiToZCcc5Y7ubVDeGbM9pxWckrz06oBaSIhoyM8/tp08Qc7icm/tOQqBpX
         UgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121029; x=1786725829;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aee98ZEVCnU/nGC9n5IlQRH4Fbf+7bsHwlgyxI01O/I=;
        b=drov6QJCnFep2ehd1/cbJyDEdspHA6awTbTYZ+KfdWnMXubeWFf8xNqOzR47RFI3yZ
         kk0CfWURozw2HHLyktZkMw02eYJ35m39dSL5A0fwZA/8Q7ZNpxTQ03x83ZSK1WVWaLfH
         xMMfz80dUSDp0Px1AIS88E3bnO+vLSlR5dnnkAIRNh3/wAfzGKN0rRmVhD6t2fnlO7aT
         NLEHNjUdTkx9KDjVjLhqY/jEl+sEebwW7V0Ntp9rkbiwgjEeRZW4ZD9QsFssE//2x4px
         fAaL/8SAzgwdxVSA7vSP2LGZCZbo1LtllITc+OXOoQK6m3uMQ+I4eqbYDGus2tuPjhGT
         n6cA==
X-Gm-Message-State: AOJu0YwHdgVrF2rMx4S2ot2iPrKiSLnolyplHR8aVM6QMlZTwWGJtcbP
	n/IZBMuvpgUb0FgtMvdwoXldPnT+2OLJHWauWCty/xVfXKdjdlFfAeu890UqKK4YpKlC4uLsOk8
	7SQju7xRMP52en4JkiJX+O5bdL8eFfg==
X-Received: from ejcuc8.prod.google.com ([2002:a17:907:c888:b0:c16:7c0a:26a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:198c:b0:c20:2165:f530 with SMTP id a640c23a62f3a-c2039d52e72mr1393700766b.28.1786121028433;
 Fri, 07 Aug 2026 09:43:48 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:17 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-9-sebastianene@google.com>
Subject: [PATCH v2 07/13] KVM: arm64: Restrict host access to the private ITS tables
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Make the last level of the tables(DeviceTable, Collection and vPE)
inaccessible to the host by donating them to the hypervisor.
This prevents a compromised host from patching an entry with an
address that it wants to write to and then using an ITS command to
write over the memory content from that address.

When tables are configured with indirect layout, shadow the first
layer by copying it to a separate table, update the gic ITS host
driver to use the copy instead of the original table and share the copy
between the host and the hypervisor. Make the original layer
innaccessible to the host by donating the table memory from the host to
the hypervisor.
This ensures that the pKVM ITS emulation mediates the
configuration written by the driver in the first layer of the table and
sanitizes the entries before writing to the original table programmed
in hardware. The update phase of the original table from the copy will
be done when commands are sent to the ITS.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 161 ++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index e943ab972aa5..1ce2f9d8fcf9 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -237,6 +237,20 @@ static int pkvm_setup_its_shadow_cmdq(struct its_host_state *host_state)
 	return ret;
 }
 
+static void pkvm_teardown_its_shadow_cmdq(struct its_host_state *host_state)
+{
+	u64 i, start_pfn, num_pages = host_state->cmdq_len >> PAGE_SHIFT;
+
+	start_pfn = hyp_virt_to_pfn(host_state->cmd_host_copy);
+	hyp_unpin_shared_mem(host_state->cmd_host_copy,
+			     host_state->cmd_host_copy + host_state->cmdq_len);
+
+	for (i = 0; i < num_pages; i++)
+		WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state->cmd_original), num_pages));
+}
+
 static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
 {
 	int i;
@@ -249,6 +263,147 @@ static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
 	return NULL;
 }
 
+static void pkvm_unshare_shadow_table(void *shadow, u64 nr_pages)
+{
+	u64 i, start_pfn = hyp_virt_to_pfn(shadow);
+
+	hyp_unpin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
+
+	for (i = 0; i < nr_pages; i++)
+		WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
+}
+
+static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u32 psz)
+{
+	phys_addr_t table_addr;
+	u64 *table = shadow;
+	int i, end;
+	int ret;
+
+	end = (num_pages << PAGE_SHIFT) / sizeof(*table);
+	for (i = 0; i < end; i++) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & PHYS_MASK;
+		ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
+		if (ret)
+			goto err_donate;
+	}
+
+	return 0;
+err_donate:
+	for (i = i - 1; i >= 0; i--) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & PHYS_MASK;
+		__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
+	}
+	return ret;
+}
+
+static int pkvm_share_shadow_table(void *shadow, u64 nr_pages)
+{
+	u64 i, ret, start_pfn = hyp_virt_to_pfn(shadow);
+
+	for (i = 0; i < nr_pages; i++) {
+		ret = __pkvm_host_share_hyp(start_pfn + i);
+		if (ret)
+			goto unshare;
+	}
+
+	ret = hyp_pin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
+	if (ret)
+		goto unshare;
+
+	return ret;
+unshare:
+	while (i--)
+		__pkvm_host_unshare_hyp(start_pfn + i);
+	return ret;
+}
+
+static void pkvm_host_map_last_level(void *shadow, size_t num_pages, u32 psz)
+{
+	u64 *table = shadow;
+	int i, end = (num_pages << PAGE_SHIFT) / sizeof(*table);
+	phys_addr_t table_addr;
+
+	for (i = 0; i < end; i++) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & PHYS_MASK;
+		WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT));
+	}
+}
+
+static int pkvm_setup_its_shadow_baser(struct its_host_state *host_state)
+{
+	u64 baser_val, num_pages;
+	void *original_table, *snapshot_table;
+	int ret;
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		baser_val = host_state->tables[i].val;
+		if (!(baser_val & GITS_BASER_VALID))
+			continue;
+
+		original_table = kern_hyp_va(host_state->tables[i].base);
+		num_pages = (1 << host_state->tables[i].order);
+
+		ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(original_table), num_pages);
+		if (ret)
+			goto err_donate;
+
+		if (baser_val & GITS_BASER_INDIRECT) {
+			if (!host_state->tables[i].base_snapshot) {
+				ret = -EINVAL;
+				goto err_with_donation;
+			}
+
+			snapshot_table = kern_hyp_va(host_state->tables[i].base_snapshot);
+			ret = pkvm_share_shadow_table(snapshot_table, num_pages);
+			if (ret)
+				goto err_with_donation;
+
+			ret = pkvm_host_unmap_last_level(original_table, num_pages,
+							 host_state->tables[i].psz);
+			if (ret)
+				goto err_with_share;
+		}
+	}
+
+	return 0;
+err_with_share:
+	pkvm_unshare_shadow_table(snapshot_table, num_pages);
+err_with_donation:
+	__pkvm_hyp_donate_host(hyp_virt_to_pfn(original_table), num_pages);
+err_donate:
+	for (i = i - 1; i >= 0; i--) {
+		baser_val = host_state->tables[i].val;
+		if (!(baser_val & GITS_BASER_VALID))
+			continue;
+
+		original_table = kern_hyp_va(host_state->tables[i].base);
+		num_pages = (1 << host_state->tables[i].order);
+
+		if (baser_val & GITS_BASER_INDIRECT) {
+			snapshot_table = kern_hyp_va(host_state->tables[i].base_snapshot);
+			pkvm_unshare_shadow_table(snapshot_table, num_pages);
+
+			pkvm_host_map_last_level(original_table, num_pages,
+						 host_state->tables[i].psz);
+		}
+
+		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(original_table), num_pages));
+	}
+
+	return ret;
+}
+
 DEFINE_HYP_SPINLOCK(its_setup_lock);
 
 int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *host_state, void *priv,
@@ -294,6 +449,10 @@ int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *host_sta
 	if (ret)
 		goto err_with_host_state;
 
+	ret = pkvm_setup_its_shadow_baser(host_state);
+	if (ret)
+		goto err_with_shadow_cmdq;
+
 	hyp_spin_lock_init(&priv_state->its_lock);
 
 	priv_state->host_state = host_state;
@@ -312,6 +471,8 @@ int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *host_sta
 	hyp_spin_unlock(&its_setup_lock);
 
 	return 0;
+err_with_shadow_cmdq:
+	pkvm_teardown_its_shadow_cmdq(host_state);
 err_with_host_state:
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state), 1));
 err_with_priv:
-- 
2.55.0.654.g21b8a5bc05-goog

