Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485381684A7
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236728; cv=none; b=NMq4RLJaPLP8sKHrgOVM9EbfSyEFOAn1Miav4sK5VVV6Bfk64R+5hteLdTDQ5meVx8r3+tJrViGesprQHeIIunEgyTO9PswNdmYSn7l6x/3RlKJYC1FtF+ZXu4gSJjl5LPF1KFazxUF9fVkW4VgBSLZPJuM7dBLgjPFFugFWc58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236728; c=relaxed/simple;
	bh=UylfwD3oilt2Ap00B9QfJgsS5JbmMx/LZPo5qb2iVKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HJ5vXLO1A5SEx/djcnqxNaUXtVp7YsB+aPh6hlJLiPziEjNItsKuiu22tE5jFC4v2g2PivaPAprfvx7sez+f4nRdjJcgZDItaF3i7mi+deWcVbQWsgOQDaTOy9bcIyCM5QDgW99xgABENnBevVHv0iS0QnJ4j3UGosoMUfCcfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hzx1HT6J; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hzx1HT6J"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e08bc29c584so4111790276.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236726; x=1723841526; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=br3FwjgDzPooOiG0lkeIxLVZHvjVaW5LdrLy5p4r3+8=;
        b=Hzx1HT6J1hngbw+cDOWwD4i3bKkpIGR+O6FtE5mH7gzzTVbDnbWEuQWN2+5dDyu810
         OU1h21YZo0zWBdlCwaAED+Y5JO1+R1mX5HPgCLdveEzh57pnSgNdc4unsxoUElT3+O/Y
         7Ilshy60IUvo145J2pBTTUbqtQepxfbDibay6ukZ14KEsmtjilY6jNOw8TB2LJgWrdeX
         mqUzGHfag6wRBnQ7WBuXxuAhoIVGkNeEKlpmQ3rCEmJfLYn2/SVq/ELiJHkr4Uq2dMIX
         UP8ZGdOH1JhnOCJNrSLfYD5F2175W6x8iA+q7fNloMHphQ6jxZ55G2fhaERg77mFkeYE
         H/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236726; x=1723841526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=br3FwjgDzPooOiG0lkeIxLVZHvjVaW5LdrLy5p4r3+8=;
        b=oTHxqGCMG///IxdAnaQKnhobVEDAXUtzWi0aYBv7vCcphDarGpCB10TjIlpwfWxx67
         6pjaxuFseBE21HJR/aPuSSfhMVKKis0U+3V4idN2P6myaVQHh1AKenm7Ppw7gwx4oo7W
         anJV9M1wV5W8NsDMoI5A6ZbwmYortaVIOv7/dQmQKX9NCeywBfM5MRfoNb89hXwZRieN
         PaioyjK8tXeGA6/i2leL/6WR03fD3LHFUF53vDLK466gX6xFM+2z1gByDTtT/GvOjIb/
         Q9X+W2DxbfRsLwRRjXPrGDwtH8DOC3Fs+VC7vA/WzmnrfgZQuK4pfEv9u+hdem6hvEGk
         23CQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWnwhY+wNBYlT1hRWidz0vGI4xQ884UfpbOnunxKAXncm7s69br5X9fAUUJng6fraawXMRu8X8Un/RCbS82vzTsUrU5Hyl
X-Gm-Message-State: AOJu0YyIMjEuAtENGW1WjCL+51FGUrinPT7BHrQhxnmJsfd2/KsWVKRK
	r/+gZ1qhAkbqqoiqrx9YUQ02NyLw+byd87dOqHrglXrIsPzto3ql8njlNZb5aukEbj1Zc2IiHh5
	+O9p2kK1sog==
X-Google-Smtp-Source: AGHT+IEDwdW8UPrl6O8L/dLUe+yB4KqU+io0AFuuQD9m2vE0SJljtoLO2dozJZ1XveNUHCZDlwUWfzVuIHv+5w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ac5d:0:b0:e03:3cfa:1aa7 with SMTP id
 3f1490d57ef6-e0eb98c93e5mr4591276.1.1723236726226; Fri, 09 Aug 2024 13:52:06
 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:57 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-3-amoorthy@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2
 fault handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a memory fault exit
when this happens, which at the very least eases debugging and might
also let userspace decide on/take some specific action other than
crashing the VM.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..c22c807696ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3264,6 +3264,7 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 	return -EFAULT;
 }
 
-- 
2.46.0.76.ge559c4bf1a-goog

