Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3EE4483A2;
	Mon, 14 Sep 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388840; cv=none; b=g/k0RW6oMz1aR5yBbxKqRPvqpudMMUVGsZGeKTHv11vBXKM0nJwwptBGLdCk+7bPGKYc8Mj3Tio/MAK6llmJ1wYr2iylxV/FD/ZKElB3Z5zKE6j1HABQAUuT3ctcjvto3ak2QXS2wHjGqGgDABqB35n8hYEEvhDZVmtC6y/GL50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388840; c=relaxed/simple;
	bh=Hb4EU3ooaVPX0vORXtq1G56N+69ZYTRtU/gYDr/Xt9w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XN94sbCvYcmphxV2EguqRQ27R1nTdCQBQ/Nf0g+jPBieXkumZCXOuSORPE2agVUiMnuYseqx6sAQjgWsrVHw4BMi2sdHHYa1Id4iQvmfp/8koMr9PfMJdDk4pVfF6DONd4eizxRriM/HpKNDKtEEaqgFsqkZBn65rmNrRqs4HVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbA1+Er/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbA1+Er/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211091F00898;
	Mon, 14 Sep 2026 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388837;
	bh=d44gE0/IL0gyA9lyN7r1jK3OuMoXRfrYJhQ+4wSHM8U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VbA1+Er/iWG/56cK3BppcKN06PLdqOGhz/rBvvOCk7lo05ELrzewdm7Kvn49pjlaK
	 I+fVuw7agdYbnPzfh+enQ+6/sm54EhVrTdXveTDzJmm3n4y8A8R0lNjNuaW2by2Gfr
	 4K0rZeeJ59RRQhk1MUtQ0Fwcwh9t5pzZV86l0BiWwWxKhGAQnBWnBcqkZdeyuG1g2+
	 0ge4jV+cSKVF17sako6EiAwrD4TeYvck5sZ0vWttdkN7Bl9gTVRPsDp97a77xhNAYL
	 jSJYykGEcy4wI2Ea2ww7EO0HtpqVzFaWOTmHEidBVBiU7wE0+w27KsCTHyff0jzvjt
	 5aHDTpHYT6GkA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:18 +0100
Subject: [PATCH v2 07/13] KVM: arm64: Propagate EHWPOISON in
 kvm_s2_fault_pin_pfn()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-7-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1982; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Hb4EU3ooaVPX0vORXtq1G56N+69ZYTRtU/gYDr/Xt9w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/9qbKIWcyhaOuTB7wW/pmysejLhhOHH7Jh70y/wt
 lxav/HgiY5SFgYxLgZZMUWW51/E9weJhM3rvODvBjOHlQlkCAMXpwBMJO0+w//Q/x4Ma0RVQ334
 7rIXmNj/mKEeJuC4v35PmescCeWNKscZGaZWv5unp9nA0vN6bp3o1pvHdt8+rGDNwLv+XKpb5DV
 lVjYA
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
index 8c23fef4ecf8..eae085a622ff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1946,10 +1946,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
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
 
@@ -2169,6 +2167,13 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
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

