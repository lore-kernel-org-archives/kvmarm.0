Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF5E54CF6C;
	Tue, 22 Sep 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086744; cv=none; b=YiECJUkrTzUS3b+CsSvNAX4vz4nbS5nt0ptZ0+QnNZvrHMYMTy0MdNhGEGiHT4vWLvbwCXxAqtml3impU/eZdqZulCcD2WlCqdi7VKOhFdqJkpIwZYInt+GYVXyodKqfyeoGbWGGqw4AvCvrXzoPvv1TmNg4RWDpm4UCYtvVl7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086744; c=relaxed/simple;
	bh=Wox9mL75hsFbcgIdf6d99gH1zw8jSQZBJjzuXgfg9vQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WkVjRlMtmZV+t+UeL0zqbcjddR1sOazY++jpIsK4JyhdqgrLjj3nW5J5Yc5QbmIQUg3VKlANUFsCeesil/58Hd7zh7M/xti3IzHAr/Gv5oIB+v/nzlSYx1A5mVEQgvHq9yaFEZ3JS9TFFTQkYzdaf6Ka+G30nVffuMR5odt7t2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyCN7jqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyCN7jqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAAD1F000FF;
	Tue, 22 Sep 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086743;
	bh=bkdY5QoUikW/hUKBv7iWovzBUjrfRCs9UqHmvb30Ogw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GyCN7jqN/CoIWJFvNoFAxgIBny2D+4pinx0yeYCXlJ0qgkTiWNdHmcfSnABRL27t5
	 AdKsMarz7IAili5OC/C/c/cpaa1kn+04VIFOlwkG0ssy70FgVpxGxKRLPkePuomdOP
	 ycZLUgkkIW0WxfelkPC9BQcTN+oE0wsKZxERH4gn733eTpjGd07RdNbeDzWM9j/B2x
	 IctnTTN779RapU4x/BNVT/m4QLXwtYZTK9ffUeA81HXM3+8v7t/iwdU8uEiwvya2fZ
	 KORWTYTbAm87j9JgxdDfL+eJYvxa11DYH4wtynt11F6zyE1todu2/6nILg9Lk6sUNQ
	 VMXtfE3FWcJ3Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:18:02 +0100
Subject: [PATCH v3 08/14] KVM: arm64: Propagate EHWPOISON in
 kvm_s2_fault_pin_pfn()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-8-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1982; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Wox9mL75hsFbcgIdf6d99gH1zw8jSQZBJjzuXgfg9vQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29UneLW3mulbBneA24fAuw6orzls0shrmCLupdR6Xc
 GK7flO1o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABM5qMjIsG2D+GFX5XeTu6RX
 fz3DV9nu9Veh/tgWcyb/S46S0fXmexkZLubp7+2RFfnFU64b+YS5/cNMT4bL4vcUV82d+FWNYZY
 MGwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Currently kvm_s2_fault_pin_pfn() handles a poisoned page directly by
sending a SIGBUS signal itself.

This is an odd place to do it, the caller should decide what to do with
errors, so move the handling to the sole caller, user_mem_abort().

This lays the foundation for stage 2 pre-faulting which, arising from a
synthetic fault, should not send a signal.

In order to do so, check to see if user_mem_abort()'s caller has set result
- i.e. whether it wants to be informed about the outcome of the fault
handling.

If it does, then it is implied that it should handle the -EHWPOISON error
itself. This is the case for pre-faulting.

Otherwise this is real hardware, so send the signal.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 221ea069f9bb..2576b967d20e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2016,10 +2016,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 				      kvm_s2_fault_is_write(s2fd) ? FOLL_WRITE : 0,
 				      &s2vi->map_writable, &s2vi->page);
 	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
-		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
-			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
-			return 0;
-		}
+		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON)
+			return -EHWPOISON;
 		return -EFAULT;
 	}
 
@@ -2261,6 +2259,13 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
 	 * get block mapping for device MMIO region.
 	 */
 	ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
+	if (ret == -EHWPOISON) {
+		/* If result is specified, let the caller handle this. */
+		if (result)
+			return -EHWPOISON;
+		kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi.vma_pagesize));
+		return 0;
+	}
 	if (ret != 1)
 		return ret;
 

-- 
2.55.0

