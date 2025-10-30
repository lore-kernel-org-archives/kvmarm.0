Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32B393DE6
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855050; cv=none; b=VLSOssAGJ2nTTh3tixNUMF61haadd1G2alo5q9a2wEfe5gOzYvGljagyZ5o18nuHzSNWmllCLSwneXnVeuXiCY9YgK7mUvdCa5IM6xumlzAP6Wi3pKR9eAldbRKGOOpdBHDRDWNEKTJYrN/kOm/nAjLGeKuRXLTeUY4xuWefJl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855050; c=relaxed/simple;
	bh=4WxHGoE93VOocFQ5wN0AUJ/80sFNRiS2hdmgOFi4y/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ftg/wYif5ZkjWZ9vAQuHjy/4rNV4681LeCXef3eZJgn9efDiZ9i9FYR5H/0r5Um5s9cNc5xiVdAXNCkt9IZtOhuRfkE1I8rwq2rGJ59sMRvWmChH/o0ig275sx6PNfPafleiT07bAGKZgVj0/AsWWfaN65/xleiRzqh55RqBl9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nuwEaa+q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuwEaa+q"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce15aaa99so1086943a12.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855048; x=1762459848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q3vUMZT0yYe1EXEiRgC8c4U03xvX09k6brWY3B4yx5I=;
        b=nuwEaa+qH18RZiQpT3TD29LLnHgFBGAhu6HW4ruRXl0tlvPS/ilGPXMJXOPGKCSlSu
         cwqsk6RWe3ayC3b4dTMeEvzjDmIfrdknYTN9glRZ+g7Vc4NIrla3zWo9xlfFhLbs4963
         Tu97VPlSeaxag0kI99VKnEefuDgHhorUIT1Xgnx8YwT8ujCR/b3iWpHj8C0Sr2NPLaG4
         0t7LWdkUNUyN6R+HN3RtP/67DXgbPGxTswHzqJlVOb3zx9XEY0OiJUakgymECXdc7YCA
         FTswyhUo6wk9H23FxArnUR97aKJo8gjm2NDU3RGw5YzjLRWpMpAe1fh4BwbKutLcvY6s
         lUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855048; x=1762459848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3vUMZT0yYe1EXEiRgC8c4U03xvX09k6brWY3B4yx5I=;
        b=bLSewPqMZt8Um/1UMb1dn3aZZYDDocdPSSPKSu5dL1bk+Mpf8LWn0qg++OnVa8ZaYC
         uShA6ahIqyrhiZuLCYrGkWIEsPoRrIFnoR+BTyfee50SmT7mVuty5CLVs57KF/Y+BsSL
         /hSGr/Sd0DdWEvFpwFO7I7/Xl8YAb1hKYb/gIelDTgkH+8+fctdpLRKwykypbbtbvWJu
         EqzyUVQ0vgXYxTXeW+O2S420ejPjz2dMaeImktOBGj0YST0akymBds58eprCnbQBRHuU
         8gogr0dJo6+cbuMPiNqnKPV+Jq+OF8Uhy1oT5ju3m1eK6pIBo7T95og7XSUs4kO0BMqu
         HeSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/Jn7esvDFm+k/5OdH74gEoWL8bIi1zwRe1Z6Y6t7vXlomN6i/78kLzMiKg/5EAVZSLyuoBqY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2Q/W2fkOpkKiAPXr0fXz1xV65plYmcEZ8OHUd3J3eNiRr4z2a
	5Oio+EbZq4m4y2MITF4a53pz3JvI9Kz7mp+H28NcRSTPyIYwRaLqc0W1ZDRvpv1FbAoyrGdWHFb
	yNUvvVg==
X-Google-Smtp-Source: AGHT+IGMIUiQfnFXRwKgU4xakuBoSsZwl0KV10BIrj34ojpFyNKXcMvJLG+bxMBFJqWMl0yCEf0bmf3P3I0=
X-Received: from pltj3.prod.google.com ([2002:a17:902:76c3:b0:294:8e58:7348])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2348:b0:295:1a63:57b0
 with SMTP id d9443c01a7336-2951a635c07mr12598385ad.23.1761855047670; Thu, 30
 Oct 2025 13:10:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:42 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-20-seanjc@google.com>
Subject: [PATCH v4 19/28] KVM: TDX: Derive error argument names from the local
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
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
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
index 5e6f2d8b6014..63d4609cc3bc 100644
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
2.51.1.930.gacf6e81ea2-goog

