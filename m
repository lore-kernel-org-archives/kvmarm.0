Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0A1299AB4
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661203; cv=none; b=OLYuFVJdf24mbEx2y/TKr2cMtjUfnsTUZiGIyd1gmkdDiOfmqJiK0KfZyhN3PeZcUXvsHR/+gftXlImN+Nj9GdYo2mBhaxqlw8+SjmJLFfSPqJTAy80gO5CiPRwoDHfyB1l0mXhvFHkSTQX4wYmTBHGPm2uPB81p0aDj2bkKL8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661203; c=relaxed/simple;
	bh=tg0l56HvAdoWWKikkxStnVhmDSB2cUfpRDPGIT/ddFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vx0PytgHahv3/dSUmxQXv1aSH3MzINEw2bgaAGqmriGZguCycg9Yt6IM/aijdW7xqLp1Pkkq9oDKJjl93LsR0jteuIStSXPaMg/b3XFle8YZ38IQ8cL9W699l3q9Bqykn4+plDANYY1/9QK4hv4J+EsQKavVLiK2W/dX7cF6Hfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qkbmeseu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qkbmeseu"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-269af520712so16811865ad.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661200; x=1761266000; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Et3yNXLGMeuamTbAzxTVAbjwKav6YdsiHYhgXHS+lqo=;
        b=QkbmeseuEJmsD0CXY/fWJzEBI0bnQdfZZ5meviTa2Z2S0P1pjws7pC+vxXFZ9aGcPG
         OUfI/V7yuPqK/DQLakttk1atrkKFiXgOhdcV0a5KQNOqBOACRHsOznSPPnvKBvn8Cj4W
         omBajeieltkW6jm1nutdvH9dM0LCi6RRmJIr+ENHXHuQr/nH1GtMCjlLPZzclKQijCjA
         FujfeYojRyEWNxrpkKnZLh0M6H5WcFk8DwA7JU9XboRuRWBjl7dYZjXmxhkV+SvoIk8+
         32GVLGEXWHTpooZcWEj6m3uyiSZYLnaQgpFjP8IH/SypJ52i3YOIHHC3Yi+s1Lo1QIhc
         TpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661200; x=1761266000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Et3yNXLGMeuamTbAzxTVAbjwKav6YdsiHYhgXHS+lqo=;
        b=Rsv440SFv1fIVGVupsSeP10uV/2116yywstkhHfnSpq/STMZKcW1rPJjvR48ZfYHPm
         dPNuWBWxrgl63dzs0jlba5ZjVSg7AL4Xjbl5S/3Zt6XsitUeHeK2EPIWleIUx/656ye9
         V4EVvRpn+r77t2IpC/Tm7kuAOOlv+Ij4PhT7C29qbfQEkZsUdvUttzj2llzKiBCh/Pcz
         u/COzsOXpgACV8txLHHMbELhZ8e/ozJhsQKQDVmpVAaSwR4u3hcozBduklGYJIYuE20L
         Bgwwej/2EM9Jt2qH8XbwZyFZ8Pcoo4EACRAIe0YAksv90z2MMtV4yI/zddda4fu+uMh4
         8Ffw==
X-Forwarded-Encrypted: i=1; AJvYcCV/Lf7t7j3ej/HOInd9ehZWLZa/RlDy5ELCWlOAnYUsVYFMc1zz6D/mWHkyactwjy0NOV+Aiao=@lists.linux.dev
X-Gm-Message-State: AOJu0YzehXXN857JlmF/U4nDYhbhwVV1jvBVPglXdv4VnXE/H+9SJMXG
	9P6zCwVx65oF+wYe8uFNIYf/9d4v6StoeVN4HhFi2Cz94S8LfMgdfN2UCinvnSpgKw9FN3i326N
	XurnAIA==
X-Google-Smtp-Source: AGHT+IF8DlOutKWl0i8m+B1TfQqXPthFr1585kr7hlu5o2md7/0QzZzZHhKvSNGyUqeTAbPYZaEbqdnIEp8=
X-Received: from pjbmr8.prod.google.com ([2002:a17:90b:2388:b0:330:49f5:c0a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e544:b0:26b:5346:5857
 with SMTP id d9443c01a7336-290c9cd4b82mr18056465ad.24.1760661200311; Thu, 16
 Oct 2025 17:33:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:36 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-19-seanjc@google.com>
Subject: [PATCH v3 18/25] KVM: TDX: Derive error argument names from the local
 variable names
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

When printing SEAMCALL errors, use the name of the variable holding an
error parameter instead of the register from whence it came, so that flows
which use descriptive variable names will similarly print descriptive
error messages.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d587a38581e..e517ad3d5f4f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -41,14 +41,15 @@
 #define TDX_BUG_ON(__err, __fn, __kvm)				\
 	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
 
-#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
+#define TDX_BUG_ON_1(__err, __fn, a1, __kvm)			\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx", a1)
 
-#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
+#define TDX_BUG_ON_2(__err, __fn, a1, a2, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 " 0x%llx", a1, a2)
 
-#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
+#define TDX_BUG_ON_3(__err, __fn, a1, a2, a3, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 ", 0x%llx, " #a3 " 0x%llx", \
+		     a1, a2, a3)
 
 
 bool enable_tdx __ro_after_init;
-- 
2.51.0.858.gf9c4a03a3a-goog

