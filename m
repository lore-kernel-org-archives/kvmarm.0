Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4DC2FF464
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769673; cv=none; b=ZP3+31ji+zMiV/ltqSojER7BFJxLgzNcb58HKb6gaqDm9HOxz2UwL4yZQC6h8uhgSgvi8wMex2usZ+v7FkL4JHeJSHJiAVPH+op6+mVnqnUd+z7VBAVy8E/wQAHz+jAeQIGjy0hcKUPTGrgg1Fv8SkqKBOxL4qYe556LuTWwRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769673; c=relaxed/simple;
	bh=1w8Rf4FIk8UShH9xK6GMjNGhBeuY0pcttrOoAcb/Rxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vE9bwpfjJilqQ7HX4FpbaqFER3vLKobzwO0wg6RmXL0tSYDD4BX2W30SwQEuJhWcPSpLUpoHrc5Q7JXpsQ6x46KMuRRqDCJKn4qIXrwc4BA7pW5FVDnGbviWgvocS9hGROEG8wxr5V/lwVL/L/0ShMwraXfJPNl8stH/bVUYaL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JgJwE7Qp; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JgJwE7Qp"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a52bfda108so602937f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769670; x=1753374470; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=JgJwE7QpVDc/3y1aNHV7zx+ejSmOD2BtWspmnRyU2cq316KgehWPagzub/mbQo5HBT
         rCA9IltcPPUo90IF3u9hzzMcb23gr3wlG4i7BLWr4zI/IOid7Ik+RW9vYZ3DmlZ1NWnb
         0hEiJinh8XYHLHkIqb2xNxVhmTX7HMd9BmqpY0EA27YkodcG+aSt9cd+BsC4pbrBHggA
         MENeiPrShfwC3MYhyKKQTzgR9PeCkYjK/7ZJHsRax4svyUUsnfK/fUcp+j1p220Eud5K
         RGjQ1E22bqAa+CUYi6Wz418Cof1eC9ud4xVyj9jpuXbFzQFh0YfZIW0FckzutNoq2eSz
         NnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769670; x=1753374470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=joX1j+4MAi5UWen5fmsaEVJ7CXVuJlElwMkxge6Yh/OaK+7bipVTvqfHeP3mAQKS15
         BoW4u3Mdq658Pa9vQr+3OvsICXyVaezF7FKjTXtGeCiRJn7nu+PPLPa4CONpKl7jUGDW
         amMf14OuPziTLwmJQ++VVq3Bc5DOeRABnmj2UUqrIUF3+dsvw+IZD+KrQa8LZAmYTjUP
         pQzjgS5ZqQvp8dCwk9D7o+G7ZfuvsGSRhNcSGejmeBc4Zm9N5zEKh/CMX/psAxZBaz+6
         5w4vm68dLdiHnsdJYiuADjlBzHk3t5UDOqXEwCqCc9BN1aY+Ex7L5GTP/vSwb1a/8z65
         Xr5g==
X-Forwarded-Encrypted: i=1; AJvYcCUiyvxuXgdDCaVmlxm4pdqGT/+jtdibdsstPFztsZezxPAnDXHYCjAuveJS24BihdTOY25Rlhs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywf/mJiZSitXV7wra9+ZGjBVXzjJd6mmWpq7g3CO7AOP8agvryI
	p5/bqTOXMBTJbNN80AOmedYZJHVHebXjJCDP4FgyITTPnMPKWoRLbwA70NsHO7D/QUwEQSg/9/2
	R6Q==
X-Google-Smtp-Source: AGHT+IGrLJKVjEgj1SDZnlDcjyoevRtzuYkOn+gCuJEKU5WteK+MJa4KEFRnnHxiW/w0ZR9dr94c/ATmfw==
X-Received: from wrus4.prod.google.com ([2002:a5d:6a84:0:b0:3a4:eeba:2067])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4305:b0:3a4:d0dc:184d
 with SMTP id ffacd0b85a97d-3b60dd95c4dmr6783204f8f.27.1752769670073; Thu, 17
 Jul 2025 09:27:50 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:27 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-18-tabba@google.com>
Subject: [PATCH v15 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Handle faults for memslots backed by guest_memfd in arm64 nested
virtualization triggerred by VNCR_EL2.

* Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
  whether the faulted memory slot is backed by guest_memfd.

* Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().

* Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
  Some of the guest_memfd errors need to be handled by userspace,
  instead of attempting to (implicitly) retry by returning to the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dc1d26559bfa..b3edd7f7c8cd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
-static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
@@ -1216,10 +1217,25 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 	smp_rmb();
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
-	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
-	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot)
 		return -EFAULT;
 
+	*is_gmem = kvm_slot_has_gmem(memslot);
+	if (!*is_gmem) {
+		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+					&writable, &page);
+		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+			return -EFAULT;
+	} else {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		if (ret) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+					      write_fault, false, false);
+			return ret;
+		}
+	}
+
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
 			return -EAGAIN;
@@ -1292,23 +1308,36 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid;
+		bool valid, is_gmem = false;
 		int ret;
 
 		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
 			valid = kvm_vncr_tlb_lookup(vcpu);
 
 		if (!valid)
-			ret = kvm_translate_vncr(vcpu);
+			ret = kvm_translate_vncr(vcpu, &is_gmem);
 		else
 			ret = -EPERM;
 
 		switch (ret) {
 		case -EAGAIN:
-		case -ENOMEM:
 			/* Let's try again... */
 			break;
+		case -ENOMEM:
+			/*
+			 * For guest_memfd, this indicates that it failed to
+			 * create a folio to back the memory. Inform userspace.
+			 */
+			if (is_gmem)
+				return 0;
+			/* Otherwise, let's try again... */
+			break;
 		case -EFAULT:
+		case -EIO:
+		case -EHWPOISON:
+			if (is_gmem)
+				return 0;
+			fallthrough;
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:
-- 
2.50.0.727.gbf7dc18ff4-goog

