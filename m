Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCA3AE718
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805770; cv=none; b=WD+lCRRSWkLVfMqgOCftgtC7dGKLA1Qoq8Z+b+XscspyJPcUj3euMbekijQubxewI6SU2UK1GVJAA9RGC/pbeziDDteBNPBk9FX01awFi9gwTJTRwg1RFCyBXaDrmsujriJhGLbOjZJwIbtIeJ39E6uniyUnxvSJe/zO4foALDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805770; c=relaxed/simple;
	bh=dssjA3u+VFXpsFKHFhYOAlR5Hr1cip10VgtJuYqdW38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZhTEAvf0WjusAjZCh6P67h7pHz90hNskWtBcg/wQvTj+4T6ZXsoQnDFNeUDejp2iU8HWY+ZY4QOe4ZGappAhk+j7FRXgul6TtmyGqZlTIqkhNXbNOSVfovkFw+GkqUSw/CgFBehj6OsY6T3oipZPUuND7vki4gRM2bobj1GJPh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2KalVPCR; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2KalVPCR"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-66184f62c28so1859352a12.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805768; x=1773410568; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nrle6LcPHnpw57JFxD6jZW7nwqfyHVVEsUa7FBi+veg=;
        b=2KalVPCRei0H2s9+Lkyu0h4ngw4rzAdL1glTAE7xave1Ns4atEF6pOnTux4UP7UgLD
         iR6rpBqr7RQx0HU/a4o/uZ7+SLQ+T9rTzCjpgNbOUM4FWOnY69MtpnHkza4oJt1as0Hs
         gXIZ9TfZGVcr3h7/o3IntEgsivrLFVjm5iDJyxdXWL9R+SYcQztK7UL0Cp3duhmBBJ5u
         FDYCrq9AT6kpIN7wHM10no6ixAr1AWz6Sad55+kybNIJzfcLLNVc7JhMsfFUdD2VSZOM
         2d1NcTLcFAIsYimbBIYv40ttEQMtiz21/pEUP+2BKSyRjL+fpVhOCmdNVV1JAqcZzVsc
         krhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805768; x=1773410568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrle6LcPHnpw57JFxD6jZW7nwqfyHVVEsUa7FBi+veg=;
        b=c4jMtV27UdZB9JnxoLzgoJMwQeNZR6lW57jc4Jti9RpktwoGq+uPxa+8W/06fOisGs
         HFPKjQI8vVt9Zyd+kPplCdIwIrWqSQ6mkcEdKFjmd9U2G9i6UtrQ/+ITzXK0seqi+CnS
         hYCEDXVNFOpv7gTUrknEYjrlnrcuiXi8Zi6HEJPr5Q3qMWQX17J0eurmSkmIFSJh33uv
         tfg0XgIn8x93cJt5FJfWvB+0wHvNNh1CmqkSzI+9BVW7BpZEEknetMFfKbV99B+koJlz
         jJbDt7mxLj+nYnfJPKlaoze9xUlTXYjX2pOaef+H8Olpar/M179Up5+tbMbk/EHbUfep
         R+ww==
X-Forwarded-Encrypted: i=1; AJvYcCXY8gG5633a9bdNPY8QZKly5uG10NH3K2lfmSJf3rn1ZGRbvtwdWndINwgHOwSzznoUVquvbLg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx84bp7K8i+f03E7EITiKNLr4aazIIkMcTzJR4/Aydlo6Ts3PsL
	9fmk6rSG1a8JbPnb+O6xbZroSV5fHHZbYt2O7CUnxNhr7XByHCPMEjwGZZ24mxkZWxbCdFF3UL5
	QLw==
X-Received: from edn26-n2.prod.google.com ([2002:a05:6402:a0da:20b0:661:18d5:ee37])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d48:b0:65f:9c21:e68e
 with SMTP id 4fb4d7f45d1cf-6619d45a9f3mr1338158a12.5.1772805767541; Fri, 06
 Mar 2026 06:02:47 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:30 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-12-tabba@google.com>
Subject: [PATCH v1 11/13] KVM: arm64: Optimize early exit checks in kvm_s2_fault_pin_pfn()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Optimize the early exit checks in kvm_s2_fault_pin_pfn by grouping all
error responses under the generic is_error_noslot_pfn check first,
avoiding unnecessary branches in the hot path.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2d6e749c1756..9265a7fc43f7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1791,12 +1791,13 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
-	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
-		return 0;
-	}
-	if (is_error_noslot_pfn(fault->pfn))
+	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
+		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+			kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
+			return 0;
+		}
 		return -EFAULT;
+	}
 
 	return 1;
 }
-- 
2.53.0.473.g4a7958ca14-goog

