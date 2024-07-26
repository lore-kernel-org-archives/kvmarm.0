Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A1117E47F
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038022; cv=none; b=BkFgRuIqvZ5raapAsCydPOhQQWr5mEAYTJTYk375Wpl5ZkB+tEh5Se3YbDjmFdG//cEYj1vuchW9HlJImNORsjbh7VQtkzEzqeED9fyqO7MCPeUap9bLS3XmIXnJJV4Tt31Vyt4BfAMI8V5wSs00o6bP+Wc5T6UaZJb3+aJzI8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038022; c=relaxed/simple;
	bh=Ha3QOJ9ztlbiDtlpfFA1Gmi3O5m4m+UNE8dfT+rqtiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1E0uKQEasSScHlaCNlktsztNCk+H+VjLeq0UVYY00OA+fNWaAVJX6FawOb72xrE9LP27pPkHmI93hquE1wZz4EOvGQKYIcMEXVuPvyuaJo8kmsak4cap7atsU8vyNObg0jxCigtFl9WH7+5tzYWbJri2gRt4aSWFKMYTpIHneo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XFHje9kc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XFHje9kc"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03b3f48c65so446176276.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038020; x=1722642820; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ABkrzr1cGSxzpfOXTkcnfxpngM7W7Byv3yxUL9/Xpog=;
        b=XFHje9kc/CyTO+iiqLn+glqd8m1PnaVXDQ2b0W30tGAxJbV4w9ZrwYjdEzW/v173Au
         YbVUl8EBAXE/nNWZuNxT/Bm5EbSHREhAYfsX+2ZVZ0HtIGNWA2IkENNhZ1oO87UGea+Q
         pg20SjlpITATPffF/w3lcZ4c+qO6HucsTRYM2LqhZ0VPvvMFdvIYMpa7wAKdcA2as4jM
         9qkF24E0sCW/4aTQ4ldzIKnMM6icwGYq6Qrm2MX/E8D+B4C06tvfcxzPMt8Uh75m5ahs
         GKxydL8HWUA8cvn+ohGSopu4qi97OHbTfYqSzZ2rf/mPvxkMfs2/mH/GF8DFImkSr68w
         hEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038020; x=1722642820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABkrzr1cGSxzpfOXTkcnfxpngM7W7Byv3yxUL9/Xpog=;
        b=Omn7nHGE8nkBoEopXASglXZV7ThMhDn65g5MOZ8riQNZCs6coiKfmAdsmoXMhsmL/U
         91qo8yNTUJ+JerjFKqSneIuuvmzxLu1j3zs02A00nA/5t2rN4SQF2bViYJIqPvIFCE3Q
         1XhBiiIUgU7H0uK4E73p+syhFusD+FgGqVFJW1E5HBB32nKRJFEVGO0utf8VF8+rh8Bx
         saNOiQgJ2w77XvoW74XKnHKxwjd1eLaGJn6b7u7kZXqmEtt5IEBrLFRmq5spZoRhqrnR
         3MHLPXQs2inmxrNBG2plw2lovWjVJUpq7ADUXd4HNtDJL7m13WRzIR9c9jSJnHCZD09x
         c6Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUtsfvNbzH1xJ9WpakV2tHsvZ9ommuYxX7/n1CnyyH8G723wXcpxnIC9RBw14jEmG794vWLyz/Qa8ou06rZ51Dh8lfl93W2
X-Gm-Message-State: AOJu0YxJ+OdkGogRkJdaKfWLu+0jnp36XDjQnSduekyNBcQI0yeliHlL
	cyrV+R9jM/7x7vjO6DjkMl6ov/KEJLKB0r0OHRTri3YeI6O0mLGWa3cV6+IqptCuLB1wakqCz7D
	XLQ==
X-Google-Smtp-Source: AGHT+IF9e10ucuu5PEDYEm2t1VHH57SvniduNcr3PDVCEbnd2uQ/527xnsEGixiu/Fx7KhH32OKutuDbjT0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9004:0:b0:e03:b9df:aa13 with SMTP id
 3f1490d57ef6-e0b5455eafcmr36206276.8.1722038019655; Fri, 26 Jul 2024 16:53:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:39 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-31-seanjc@google.com>
Subject: [PATCH v12 30/84] KVM: nVMX: Mark vmcs12's APIC access page dirty
 when unmapping
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

Mark the APIC access page as dirty when unmapping it from KVM.  The fact
that the page _shouldn't_ be written doesn't guarantee the page _won't_ be
written.  And while the contents are likely irrelevant, the values _are_
visible to the guest, i.e. dropping writes would be visible to the guest
(though obviously highly unlikely to be problematic in practice).

Marking the map dirty will allow specifying the write vs. read-only when
*mapping* the memory, which in turn will allow creating read-only maps.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8d05d1d9f544..3096f6f5ecdb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -318,12 +318,7 @@ static void nested_put_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
-	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
-	 * and if it is written, the contents are irrelevant.
-	 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, true);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc = NULL;
-- 
2.46.0.rc1.232.g9752f9e123-goog

