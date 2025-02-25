Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71BD126C10
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740448419; cv=none; b=oV00h1euBDhkD2gBiGOCUBpVnphFfMwaz6EHhnNZI6HK0U5OlSDwqWyqugd6EDV1Qt31rnO61I/1vchJTYgZvW8TIQ3R8ZNxIUuO8Zp1etdBL2Q4tWCkS3llR3qOyJy1n/Xa2HxP+o/mq7Nw7ZVBaqA9+YLytLDDyew/ajbmCd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740448419; c=relaxed/simple;
	bh=uk9F9tBYFF/EkJD9htt1GD0op2QMyfK9bfcyZ5umxhU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Six9BQetMqbPcU4sV28INHW6EHqia/Mb/zX/LxdyViYUM05Z2YOQp3tX6sUZPupL25MKkx27Hz7pz5O82vNNHtNzhTLxHvVqsrUX9Ej3Ht/i2Y8vebVpfyLEmQklEFO6052zsWTTNumfIvBuuKfiIkGXbXAB3AIOVftdYBua/NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vLjUxE8D; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vLjUxE8D"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-abb7e837a7aso407624266b.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 17:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740448416; x=1741053216; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mVBQg35LScynYQPBsFgs3dGrm+AD9n8KyZeHIALpKpg=;
        b=vLjUxE8DN3+a+/eeTczpDo9PH5Cs9fHV98n4yYJd35gM2yYGwbFxHiyzYO8A+7n3zY
         IJy8bwpObLoj8h8XC+oLgDCh8dUR+GnKHOzkze2Zph860jNcDJcWnKGQh6yhqsq5RLfa
         3GJPAO9hWfeshVvu206QlO1WNFBhYhKsinKMN7It6wEc09LPp2ncCmpXP579Aa7vREg/
         w1/OkmyVRCRepNVPwcVeZNfxr94rk3z7jMFXokmqDXeWU/ypdgVz7wcWxu+sBRsHqyAl
         uaxymyy4HZE6UiU2xRnpubk0OwfR88V9iSzm5HosPoQdgvgrYGo5VKTBbHB22XNWdeUf
         OfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740448416; x=1741053216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mVBQg35LScynYQPBsFgs3dGrm+AD9n8KyZeHIALpKpg=;
        b=u3mJog90f+5PcJvt6ZOGPlhV5eZXJNYlobolbstjJIO6g+XMa4rfAR8iKn78Zu1jd3
         /lOkOWX0O23gxOH13UDKiFDPJLx/iTtk+FAxirGYAhAewfMwO4RSdyd+knWjw/PXyQDC
         rwHPEvr00/ev6zsH2NMNm/tDYhTGCCOtFyXjBL9nYe6p9hS4RWU/4rRkOlXyR9IZgsRD
         rAMx4ZX5j7ijf4GopTBH+BCGNImnVKd9DQc8fzKAx56PixXuX+U+XX08bNKosD4Leej/
         ADkgYRHqYteW87rzfb7ekidyKP4VRE/SaBWjyBRT+FxfpvBJz6+6Vd8BWvcscSef8IyY
         nSkg==
X-Forwarded-Encrypted: i=1; AJvYcCXj89zCUKS3H/DCU5l7jwcsGNqHGWblieJyJKXOur9/w/WA0664DBDgoyJuQCh4u0pkS3BlVJE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMGmyDmbC4ay6gwjcKg5d/koLIY2zlXhakyWF9Pti2cnynF/Zm
	9XF97qXv+SMFuGIikYvYElN3hl0LwCi6Vp9FGcBuV8FojxjsInWFHk34hM4AdiAJI7TIgwRDWzQ
	d2a2t2A==
X-Google-Smtp-Source: AGHT+IEOA9rIjA6uekoY3WihM+tF/K0vVRrG2dIyIogwJ20oRerMsyDc12AtygClhb6MD/mhH+yOzfP2W+Kp
X-Received: from ejcvg17.prod.google.com ([2002:a17:907:d311:b0:abb:78a9:ce4a])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7801:b0:aa6:7737:199c
 with SMTP id a640c23a62f3a-abc09a079d1mr1474527866b.15.1740448416319; Mon, 24
 Feb 2025 17:53:36 -0800 (PST)
Date: Tue, 25 Feb 2025 01:53:26 +0000
In-Reply-To: <20250225015327.3708420-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250225015327.3708420-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250225015327.3708420-4-qperret@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Selftest for pKVM transitions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

We have recently found a bug [1] in the pKVM memory ownership
transitions by code inspection, but it could have been caught with a
test.

Introduce a boot-time selftest exercising all the known pKVM memory
transitions and importantly checks the rejection of illegal transitions.

The new test is hidden behind a new Kconfig option separate from
CONFIG_EL2_NVHE_DEBUG on purpose as that has side effects on the
transition checks ([1] doesn't reproduce with EL2 debug enabled).

[1] https://lore.kernel.org/kvmarm/20241128154406.602875-1-qperret@google.com/

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/Kconfig                        |  10 ++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 111 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +
 4 files changed, 129 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..038d7f52232c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,7 @@ menuconfig KVM
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
+	select PKVM_SELFTESTS
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
 	  Failure reports will BUG() in the hypervisor. This is intended for
@@ -53,6 +54,15 @@ config NVHE_EL2_DEBUG
 
 	  If unsure, say N.
 
+config PKVM_SELFTESTS
+	bool "Protected KVM hypervisor selftests"
+	help
+	  Say Y here to enable Protected KVM (pKVM) hypervisor selftests
+	  during boot. Failure reports will panic the hypervisor. This is
+	  intended for EL2 hypervisor development.
+
+	  If unsure, say N.
+
 config PROTECTED_NVHE_STACKTRACE
 	bool "Protected KVM hypervisor stacktraces"
 	depends on NVHE_EL2_DEBUG
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 978f38c386ee..31a3f2cdf242 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -67,4 +67,10 @@ static __always_inline void __load_host_stage2(void)
 	else
 		write_sysreg(0, vttbr_el2);
 }
+
+#ifdef CONFIG_PKVM_SELFTESTS
+void pkvm_ownership_selftest(void);
+#else
+static inline void pkvm_ownership_selftest(void) { }
+#endif
 #endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ae39abc7e604..46f3f4aeecc5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1083,3 +1083,114 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 
 	return 0;
 }
+
+#ifdef CONFIG_PKVM_SELFTESTS
+struct pkvm_expected_state {
+	enum pkvm_page_state host;
+	enum pkvm_page_state hyp;
+};
+
+static struct pkvm_expected_state selftest_state;
+static struct hyp_page *selftest_page;
+
+static void assert_page_state(void)
+{
+	void *virt = hyp_page_to_virt(selftest_page);
+	u64 size = PAGE_SIZE << selftest_page->order;
+	u64 phys = hyp_virt_to_phys(virt);
+
+	host_lock_component();
+	WARN_ON(__host_check_page_state_range(phys, size, selftest_state.host));
+	host_unlock_component();
+
+	hyp_lock_component();
+	WARN_ON(__hyp_check_page_state_range((u64)virt, size, selftest_state.hyp));
+	hyp_unlock_component();
+}
+
+#define assert_transition_res(res, fn, ...)		\
+	do {						\
+		WARN_ON(fn(__VA_ARGS__) != res);	\
+		assert_page_state();			\
+	} while (0)
+
+void pkvm_ownership_selftest(void)
+{
+	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
+	u64 phys, size, pfn;
+
+	WARN_ON(!virt);
+	selftest_page = hyp_virt_to_page(virt);
+	selftest_page->refcount = 0;
+
+	size = PAGE_SIZE << selftest_page->order;
+	phys = hyp_virt_to_phys(virt);
+	pfn = hyp_phys_to_pfn(phys);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.hyp = PKVM_PAGE_OWNED;
+	assert_page_state();
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
+	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
+	assert_transition_res(0,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
+	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
+	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
+	hyp_unpin_shared_mem(virt, virt + size);
+	WARN_ON(hyp_page_count(virt) != 1);
+	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
+	hyp_unpin_shared_mem(virt, virt + size);
+	assert_page_state();
+	WARN_ON(hyp_page_count(virt));
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn);
+
+	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.hyp = PKVM_PAGE_OWNED;
+	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
+
+	selftest_page->refcount = 1;
+	hyp_put_page(&host_s2_pool, virt);
+}
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 46d9bd04348f..54006f959e1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -308,6 +308,8 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
+
+	pkvm_ownership_selftest();
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.48.1.658.g4767266eb4-goog

