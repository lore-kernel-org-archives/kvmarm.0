Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1B129BDAB
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239674; cv=none; b=h+MRfE6lFWS530c9ry5PdVPdsAY8QSHcNtCReogjh1LKag5397O330p5Nk+5XynVGZl/h0hswtOpbMk1tC4A95v8vvuN9zrixOFBtTMTV1he6WtHpu8BP/+yanpk+7nprsxJuBU3V5X+TW8FFCuW4pnmGTR8TH52yZt3PD/SEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239674; c=relaxed/simple;
	bh=jIz3ScXXXh+q4woqtJpj20/JPTadkV6HaL3oiLnNy90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VTdcSxTBSfyRX5quptoDMQwoesHH6qwavacpY/7H9RgjvBFWgvYYcbyeO2X+jvToAUWyMIwd5Tv+cANiZ9lvlMxt21rH82iH6Mp0gUhPL2k1tVPxI9qmnjrPhhyuF4D6d7jYUeps0FpnhRt1Om9luk8cbk/amAJfhrbCtgC7K8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tw0SXK5c; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tw0SXK5c"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c93f0849dso5097875a91.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239673; x=1768844473; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GjcQk0a1UAYd4d2F3ain9c0ugcRpjACAg8kxbdTJqns=;
        b=Tw0SXK5cJwaZafZ+MV++2vFbHspL/EiLe7Y9OrMNnKMVTfWGLO4Ce26WqaPWa5LFAz
         RFSmdTPd8IZMdkNdGu5ACtETDVFRS26jDUuSdT/TcwDMCPogF6wC3M+qJ/9iJ9/DM5XQ
         PjWtU1BXIgpnMUyOCyCqf5Sinxce+SVUkidWoy+5N8C1wwcshcILy+p3XSP3ivJlpgV7
         AJgbLC4dtHiFMjLtMUWq4zdeP6Vt2jaflw1tA4uw/Cmbc5btGaeypz5VtW6mZKD8UOIB
         Og6EdMMn4UbMDrzgW7/r4M5ANPwDtWs+B4IJ3Ap6apJNPVL0XM2+F/3p2XKQCKGlwG41
         TKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239673; x=1768844473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GjcQk0a1UAYd4d2F3ain9c0ugcRpjACAg8kxbdTJqns=;
        b=Af/x9SofW2dVf+wX6u6w9+SDfGqAU4eFlI2uJduoiGIg40ZLlP9HjkfXnZHkMBMjRd
         Vhmu2tytpynM2mROX6OMNIf1JpsLqKgODWC3raG/VXKSkt03vC+ldGMW09FDaW4XUQoe
         eKm61ZspHgF912QCoV6ltct3JgDydEKv9W9T1jOQdniLTe3bRgBPiZ3cF30orPe6pV9J
         Zx7svlnlvSOb8bCS/9qCAq2eRufgUKbhHCeF3N35pbk085ZFeqFhUJ31Wq2vODNUVgBL
         NJgpDgZH/Sb7Uf2LDH2XMlN5gzz7Sl0RCc+gBflQr2EcNvbp7jELzQGDMZg0bIUEvfsY
         HEUw==
X-Forwarded-Encrypted: i=1; AJvYcCVTrj5nMF8p/TvSlMe9+anUUrUEO/ecNBceJG+armJjzSCYnMiu0kq2AwxI/wCkv1Zn/lSFeQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgAtt+nNerXuTkokT4rAi5TehZm+kOvNRYfoBQX6EwkveGWuA5
	URMeojk1F71YP1bibEoheJtdUCZgJ4aCEyExFi18YGlW82wnUHQs22bRbiCq/BCTqpiUld4krbx
	wQwrpQg==
X-Received: from pjtz17.prod.google.com ([2002:a17:90a:cb11:b0:34e:6306:8cc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5105:b0:340:c094:fbff
 with SMTP id 98e67ed59e1d1-350fd17061fmr123119a91.10.1768239672675; Mon, 12
 Jan 2026 09:41:12 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:50 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823927928.1374831.6143260021717522522.b4-ty@google.com>
Subject: Re: [PATCH v4 00/21] KVM: selftests: Add Nested NPT support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Dec 2025 15:01:29 -0800, Sean Christopherson wrote:
> Yosry's series to add support for nested NPT, and extends vmx_dirty_log_test
> and kvm_dirty_log_test (with -n, using memstress) to cover nested SVM.
> 
> Note, I'm mildly concerned the last patch to extend nested_dirty_log_test to
> validate KVM's handling of READ faults could be flaky, e.g. maybe if someone
> is running the test under heavy memory pressure and the to-be-access page is
> swapped between the write-from-host and read-from-guest?  But unless someone
> knows/shows it'll be flaky, I'm inclined to apply it and hope for the best.
> 
> [...]

Applied everything except the last patch to kvm-x86 selftests.  I'll post a new
version separately since we've had a lot of back-and-forth on that one.

Oh, and I fixed up the ncr3_gpa goof in "Add support for nested NPTs".

[01/21] KVM: selftests: Make __vm_get_page_table_entry() static
        https://github.com/kvm-x86/linux/commit/69e81ed5e6a5
[02/21] KVM: selftests: Stop passing a memslot to nested_map_memslot()
        https://github.com/kvm-x86/linux/commit/97dfbdfea405
[03/21] KVM: selftests: Rename nested TDP mapping functions
        https://github.com/kvm-x86/linux/commit/60de423781ad
[04/21] KVM: selftests: Kill eptPageTablePointer
        https://github.com/kvm-x86/linux/commit/b320c03d6857
[05/21] KVM: selftests: Stop setting A/D bits when creating EPT PTEs
        https://github.com/kvm-x86/linux/commit/3cd5002807be
[06/21] KVM: selftests: Add "struct kvm_mmu" to track a given MMU instance
        https://github.com/kvm-x86/linux/commit/9f073ac25b4c
[07/21] KVM: selftests: Plumb "struct kvm_mmu" into x86's MMU APIs
        https://github.com/kvm-x86/linux/commit/11825209f549
[08/21] KVM: selftests: Add a "struct kvm_mmu_arch arch" member to kvm_mmu
        https://github.com/kvm-x86/linux/commit/3d0e7595e810
[09/21] KVM: selftests: Move PTE bitmasks to kvm_mmu
        https://github.com/kvm-x86/linux/commit/6dd70757213f
[10/21] KVM: selftests: Use a TDP MMU to share EPT page tables between vCPUs
        https://github.com/kvm-x86/linux/commit/f00f519cebcd
[11/21] KVM: selftests: Stop passing VMX metadata to TDP mapping functions
        https://github.com/kvm-x86/linux/commit/e40e72fec0de
[12/21] KVM: selftests: Add a stage-2 MMU instance to kvm_vm
        https://github.com/kvm-x86/linux/commit/8296b16c0a2b
[13/21] KVM: selftests: Reuse virt mapping functions for nested EPTs
        https://github.com/kvm-x86/linux/commit/508d1cc3ca0a
[14/21] KVM: selftests: Move TDP mapping functions outside of vmx.c
        https://github.com/kvm-x86/linux/commit/07676c04bd75
[15/21] KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
        https://github.com/kvm-x86/linux/commit/9cb1944f6bf0
[16/21] KVM: selftests: Add support for nested NPTs
        https://github.com/kvm-x86/linux/commit/753c0d5a507b
[17/21] KVM: selftests: Set the user bit on nested NPT PTEs
        https://github.com/kvm-x86/linux/commit/251e4849a79b
[18/21] KVM: selftests: Extend vmx_dirty_log_test to cover SVM
        https://github.com/kvm-x86/linux/commit/6794d916f87e
[19/21] KVM: selftests: Extend memstress to run on nested SVM
        https://github.com/kvm-x86/linux/commit/59eef1a47b8c
[20/21] KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
        https://github.com/kvm-x86/linux/commit/e353850499c7
[21/21] KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU
 	*** NOT APPLIED ***

--
https://github.com/kvm-x86/linux/tree/next
