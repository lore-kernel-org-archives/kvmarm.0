Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865380;
	b=iC0dcXuOVlUDEgf5uwmBjtXFu1UqMdCGvioAvr+fbt6FdOZS+OTwO6MqFBap67RKubab
	 VxmH9OXRAdMYyKE57edF+YbZlGayaqgd+F82kGvyc5Kkm2FBtTmPyAWdq46t9IqTvcbcA
	 ebKJhcNO/hpdPn8iZshIx+MJTXABIlKYVUaCHC96rbgnGzqey0npzK/+7wDHjfI8NAEaL
	 msy8N1QcA1XEbfzoK4XnVjd1Cbz3HvSmobLnYReTAojbgNLg1Peeh6qkup1WZGLo2Cosy
	 tQDnakeWdPbhuGDWNYNbpdHcQ7hOFl5kIDlHyBdN4yTq7+TGqkz498SamHcau/t2LQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865380;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tr8NkJMHl3FHlQcbzwhDnYMo8FYHNDVW44KQY09vbOs=;
	b=cY5pme94yNdh80vLxKUJu+1tWlXctnnrziemGuF7aUXszofqCXiBaSezmjDMl0I5hUBY
	 4m4tKa+1UvYuw+bj1H9I1LqrUPHviPx0wgr4wTC/bBpYObU0QwTlPjAGUdlcWVy0AWcns
	 AJcsn5SmZ2jfjo22DXUqNbewH1qnv1+WVy/oo+wgeXvbW465b8EE2qAbNsWAANI4akE4U
	 wMmLJkk5y7jepqkM7HOouxdWPXwvQkEIErWMASGbkEhOmpuNy0v497Kh43ASIyNhlsxUo
	 Msr5cj+EugM3C7vFZDnEufNj1fCv5i4ZoifTE1AdP3gWMgbP91JCMqONifn3cdhDH8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qE+S37o+;
	arc=none smtp.remote-ip=95.215.58.128
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CAC606A328
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 07:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36CAC606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qE+S37o+
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=NufnUWPoeGRDltZSqqytUAf9Oe1HKZ1J1ChJkjlHQ68=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793865372; v=1; x=1794470172;
 b=qE+S37o+Msp/zZhIA4Bb/q5Ng+r9nVyAXNl+njlYlfoSYJrWMRglD1RoYHcILTA/195rBZqi
 n6up0Xisgq9OBp8yThEG0d/u7qJF3beICgrksYLt5TdCjhyCgISRL1acd7oFjzhGh1Y+nKJt9pV
 o0RN2zNX0trx/b92v7eUg8KI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cccae0cd339b3153;
	Thu, 05 Nov 2026 07:56:12 +0000
X-Mizu-Trace-ID: cccae0cd339b3153
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Martijn Bogaard <martijnbogaard@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: Check PGD alignment when creating a pVM
Date: Thu,  5 Nov 2026 07:56:04 +0000
Message-ID: <20261105075606.367005-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105075606.367005-1-fuad.tabba@linux.dev>
References: <20261105075606.367005-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

Martijn reported a hypervisor crash when providing pKVM with an
undersized PGD allocation. Indeed, although the size of the PGD
allocation at EL2 is not under host control, a smaller host-side
allocation can lead to providing pKVM with a misaligned PGD, which will
cause the guest stage-2 init to fail in a bad way. Specifically,
guest_s2_zalloc_pages_exact() expects a successful allocation from
hyp_alloc_pages(), which can only happen if the pool has been pre-filled
with a physically aligned high-order page.

In order to guarantee allocation success in this path, check the
host-provided PGD alignment early on.

Fixes: 60dfe093ec13 ("KVM: arm64: Instantiate guest stage-2 page-tables at EL2")
Reported-by: Martijn Bogaard <martijnbogaard@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
[Fuad: Returned -EINVAL and moved the check ahead of hyp_alloc(), with
 the other input checks in __pkvm_init_vm(). Cast pgd_hva for its __kern
 type, updated the comment, and pointed Fixes: at the commit that
 initialises the guest's pool from the PGD.]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c        | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d4c332a918035..5b624b1ab32e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -186,7 +186,7 @@ static void *guest_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&current_vm->pool, get_order(size));
 
-	WARN_ON(size != (PAGE_SIZE << get_order(size)));
+	WARN_ON(!addr || size != (PAGE_SIZE << get_order(size)));
 	hyp_split_page(hyp_virt_to_page(addr));
 
 	return addr;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d1..03e530e15b4a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -892,8 +892,8 @@ void teardown_selftest_vm(void)
  *
  * host_kvm: A pointer to the host's struct kvm.
  * pgd_hva: The host va of the area being donated for the stage-2 PGD for
- *	    the VM. Must be page aligned. Its size is implied by the VM's
- *	    VTCR.
+ *	    the VM. Must be aligned to its size, which is implied by the
+ *	    VM's VTCR.
  *
  * Return 0 success, negative error code on failure.
  */
@@ -924,6 +924,10 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
 	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
+	if (!IS_ALIGNED((unsigned long)pgd_hva, pgd_size)) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
 
 	hyp_vm = hyp_alloc(vm_size);
 	if (!hyp_vm) {
-- 
2.47.3

