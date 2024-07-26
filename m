Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A559A1862A2
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038071; cv=none; b=DXjeBPtrmfzA0T4lyWy9RLL6mQq3G0fkEFmuSIQh565RE8cvGF79lohdCtKUe3S6J3Swc/QsVWCZlkucjs8Un2vwCqP8Rb07/DEhpTVlVNxjQyiaZyawkcfTa9DavX1Q9cY42OtPBnJA91Xd6HKlkMEGCQkcKR8XwdDgkfYVXpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038071; c=relaxed/simple;
	bh=t1qRb0jq3mEdjTFuwQYR/NAnoG1UlhS5OUQ+Ga/OUT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s3LdssSvrmaUJQrOn8f3XIt3p8aekS4JwZEGlm5Vk2MwSTtmIo2VmUGSNMzH4hDVXM9qrpSH/gQOQiPeaBnbosjUISWYCdqHOyYSDCbw/17tyxtIPSQkPibFAb2K0QEERAwhCEiuZZsr2Rg4zw1BaujsQC3QhXY/Gzons2zADCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iSmLPlcT; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iSmLPlcT"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70eab26e146so1297583b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038069; x=1722642869; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp8vWxWuEfoTun4nd23rTIy8nVqGGlQS/g8lo8vNdQg=;
        b=iSmLPlcT3dDRiIYKOqPQkumzPY7HAYoSW5cwAYK2W5GQYWDB+xDvR0H9zMqMs3Ax67
         92WRcRk4xN5QL59I7bSGuILb1c6O0HFhNvLpV5aZ7r2H6ZSyAemwiOvAewiolzk/MyWP
         FOmPmAsGoAF/VAnlpeoaJRbJGlXyVxiOCw6pUXEjtNLKOgUPvCd2Js61XnebjZNuqGzg
         UD5SEHLaHWmVou5jL4GtPvyrlx8yQSYfr79HPNIrkjKZ62Sexek7efNcxmrzc+zb6rMV
         sUEdN/cI404eOK6A1lr1rO/ABKx4gsa/RPqwjWQdkQTMZg0EIpTDD8VZyuC3LppiSNhz
         fqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038069; x=1722642869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tp8vWxWuEfoTun4nd23rTIy8nVqGGlQS/g8lo8vNdQg=;
        b=SS2Z/H6/6Yr84Ud8SATjMo2EZzKDctQgbpBWqz6aeZLbAzpxDWv9qyHJ4z23i/nnMZ
         vW3PvrC5j8mC5cb6dxM8G718+Ije/8ItbXAMrt6FI1lLh5vV7qGS/R3wfud6UAujUChk
         p8++0Xvl1Knk8U9HH73ZCYahm5+oqKRRz8gWoxAQdO2X+hhgIvV09izt+s57O1p1vy9M
         IWR4ym1qAwXYZwwILKvnRxh7FvaUDrYrGlwL6YK8ZPOyZJWsdAwwqz5zGG2UsEE3g38U
         SQA/GdRpBSgerZMjwt2HeOguzEBK76BduRrTodIVfzMOsvbifp7EFHztfclJtf6s6wMi
         y8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXT5PuGhuff2rHbuZPSg6ORHjMYP2KXMZefi1RclcEOgN8SSMniehgx7kYQICbrOb5kXDGQaBOXTnztuVi56+lqKRK0VMX1
X-Gm-Message-State: AOJu0Yx3WxP8E8HIFWQ912GykSu+Q34QRhs6pGbUGoKMCNHTTxYXpnVO
	//bD0nltdgYItWbK64l70aIzA5xbqIh6r8zVyoAgOvQVQf1LytkJKepNAR1OsXCevPx0o6FIaKH
	SPw==
X-Google-Smtp-Source: AGHT+IGdEcu09Hin88e0jkC1IJzP1gp2m8bzTdpaUdhQIiML2lxsNf415Y84GaeMaBcBrlwhHWl3MjBIRUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f1c:b0:706:71b3:d7cf with SMTP id
 d2e1a72fcca58-70ece926b55mr9310b3a.0.1722038068878; Fri, 26 Jul 2024 16:54:28
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:03 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-55-seanjc@google.com>
Subject: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns accessed/dirty
 before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Mark pages/folios accessed+dirty prior to dropping mmu_lock, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).  See the link below
for details.

This will also allow converting arm64 to kvm_release_faultin_page(), which
requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 22ee37360c4e..ce13c3d884d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1685,15 +1685,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
+	if (writable && !ret)
+		kvm_set_pfn_dirty(pfn);
+	else
+		kvm_release_pfn_clean(pfn);
+
 	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret) {
-		kvm_set_pfn_dirty(pfn);
+	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
-	}
 
-	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

