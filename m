Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93054275AF2
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572071; cv=none; b=Mj4L6JG/byidA3ogxmlPrQqL7KC4hVflE2qmBxvFZYpUJJZabxYRh3owy0uRCZZ6ZkzWAthCWBNbG5ClbnE6+Uf8HoOWnTKB24aUTn6JA3/dgyTOH0HA4mI31qmrZt7OF5zKnao/qGgjbXf8JyLrx5/3Yym/wjY0ZbTGOag4hhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572071; c=relaxed/simple;
	bh=1w8Rf4FIk8UShH9xK6GMjNGhBeuY0pcttrOoAcb/Rxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VN7r3bWePgZwsr3jaL0jMF+Z/eVmnyqcBaAwIaqeB7ZFLdOFqew/ilvzsJrsC3v4rpinigQHe6EuLvlyOvQmqXsB3t797AEEml73ihN5hO0d1GFvY1LpPK0nbHAq4aU5TY2+F06f3wKruFz5Tnvh+JnuQqkZmz3bGv6X3NGB7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F6kZCad7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F6kZCad7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45624f0be48so4830005e9.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572068; x=1753176868; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=F6kZCad7LyIUD0uwCqIVcAWuH7XSJctKx5AtvQ0HMi1VT27WkyBoLNaBJ6vRkaot6+
         HUoVs0AS5AHcfqnjbUZurLFBsU46jbDBTzdjyHmfFgoLy4ViZXwvNlOaK/q6599gePHV
         k+q8fBDKZW/79yH4oGQedRT9KGIWFMiugVYaa4JlMsu8uzU3NSX4E7nlrbUnE3ss42SR
         CunwIxE7N40WG68syluRSvhSOLXX4PiFM6G03VXnX8+h72ZVsbXMoPVmNxUAnGV5fKjt
         GTEs7iFrgwZ2XIC1ds1RAHcysR+FIzZgFSOfbfiVueWJqBWXx2o+VNPMcWJ5UCpRRUAQ
         ViQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572068; x=1753176868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=Mo0cGMj6efQjqGGcGpjD9kiG06zo9e8O+EPH/FdcfhqkGFAx0pzPobBx3bpJC1qrYp
         xECYeJoF6NP0ESj2ndk0HKW4Zy760y0BZbqomTzdBrcigwoKQoizUpq0JKri+QSZB+j1
         FpPGoF/9NfSlj29F+nxaio1qmKI4FHBkvD2S3LTD8+e79f0zKSn+GAvTOb003hH4n09U
         qHZ5U2GN37fs0BReahlwh5AY1mcV6Ntbgy9bZEyUWozymVDX3ef1iq0dYrF1OicrKRxh
         J5/kK2Cj/saZaaeo8CZ4I1Np6P56CtqSx1VH1V4vQ+j3GCtneFTxh0HvcMjtrEVDo6vv
         pueA==
X-Forwarded-Encrypted: i=1; AJvYcCXsznV4Ovrb7dPA1+rLaFlMFSshF4RkGN8XxMFCwgGUbrcdACrg42aXUpO/ZLFBaSk6rGcjsSk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlIc3Olhzp18EXGqYyKtLfit3hEgaHpdUIWOhXcBrS96QtKXTl
	yDAqnKOxETZX8j0zs2/N96DXoH9Ap2tB46VWRo5vJTQcmWyWyZ+GUaj1hzHMnRMcGPIEbpEDYtp
	8bQ==
X-Google-Smtp-Source: AGHT+IGBogaOn/a2nRCbQgtEGBqaMIjNeCnMyNgJrpcQg8cMebuy76dboaZmnJsfg8PNbJXBbdCUps7GZQ==
X-Received: from wmbes26.prod.google.com ([2002:a05:600c:811a:b0:456:217f:2625])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34c5:b0:43c:fe5e:f040
 with SMTP id 5b1f17b1804b1-45565edc8f4mr129943955e9.23.1752572067858; Tue, 15
 Jul 2025 02:34:27 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:46 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-18-tabba@google.com>
Subject: [PATCH v14 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
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

