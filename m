Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460F414A08D
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561025; cv=none; b=EinrVsNxuJhqSwtuIGohfw3PH23XQxp/erdCv3fylSt/JrLonBcP5A3VR9+mISdWtFnxWmnwk2QajVQFNCAOxF36CDLlB5N0Jog8CBLjyrJVYVFlLz3vifFlvSy1rAcvuzilg0pKev/bNaFy8yyIHxiJtvqJxznNzeBxwEuTetU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561025; c=relaxed/simple;
	bh=4lsaGhAgjaNQ5KizJdO9Dg5iOs84CyIarDEzmL5ACXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+EECKiGfZL95Pwbh1pKeGuXfb2rHdkIotdu0mnfWBwhiIqZGt5gP22vdCX0GXP0emDeStMcyQVN7ScxCovbOqaPz6mMAtBYwAjlwQ4ENEZAQVekpJMovvjTVJayzhIn9RE7QNjVEFT+Br+tRaZdzwOlgb37oBoe2UPQIXKCo4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEW8u5jm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEW8u5jm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4147ddecd52so671145e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561022; x=1712165822; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xcLP7O/Rb1ocKJDLSqfktl6B/DcHw/CX6bdl0GmfbQY=;
        b=zEW8u5jmZTdMCK22TfK0fIyw/DzXdozrFS1r6Gij6zR0eLgJLmLnpQZnRep0tIySxB
         L9PF1/d63V8jFc7BXisutdcyd75pS01F630iG/b10p5jXvkIus4oOqLTQK/uVDY0Rstg
         GymlIrH7J0wQgDxMqmDWwijtQyj1u/R+XfAtYhGZb0/l3X+D3vZdb1hRp0U2opaw0Kdq
         esI8u0EqUkfgXhx+YL3MXTEMiLEUaLZEz2K0GaYT1tZXCbKomw0cLe2lKF1gdhXnCeGo
         9BaKthl59v+d+H54I+vSXDPbhbmjD6hpi303yUBY7C/v9wG/hwoEhb3zoS4S9F1i/gdz
         jHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561022; x=1712165822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcLP7O/Rb1ocKJDLSqfktl6B/DcHw/CX6bdl0GmfbQY=;
        b=iW4MWIZD0NQ09qfrk651FMCSM9Yb5sNcVBZRehrnLFrwkVPX2wjwkdgziVs/pqYM4e
         8Fc1ijlg4kjhGSx3A9OrcSkqxsqle+4E3USx5ucK0yIiW6G4WYB6YeQOdXCXnUVvbTEg
         xvco3YvbFNSmhkT/GZFdx9pRwX9dyT29ZVrROyVstQT7fcxNu/8vmcbENPCh8mF93gaH
         bEvPR3tYPO0B+0ovjFbhKn/OgIw34T8bsgh4R34naaf0zHOHW78n/4wbUBNZpObK9Z7u
         N0tfyCn7OKhET8iRyWCC/taoWGITNjrYgNFaJ8VE9v79av39LwXgUy83ld6fQAb+eoPp
         qZSw==
X-Gm-Message-State: AOJu0Yz9X9QIFEs6YGBy5lLqpiFSqhzGSl9bZaydOWDdWxgI5iYjvWRU
	OIihlwDCDXUVoIV0hnQeE84dze3VuXLVtRq7Q9K+dV+5z4keKPb1bisBY4qHvmetOnNNbFBR6Jw
	4CYXp6ZcAalsQNfY6teMAVkbdJ6ohaaj3Zw//miBYCTWACdv7xnvWERkLCLDeWN35GfDgE37ymu
	LH9h6uWlf1P9v64d3EPyXvTQvCaCs=
X-Google-Smtp-Source: AGHT+IEnkve2k4dfbObMVRShJB1Osg3mqfSIiADG0DcuLgN+fRplLTScJ8vS+cXzK/Ee5h62NEuoDT5yjg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fcc:b0:413:fae6:4bac with SMTP id
 o12-20020a05600c4fcc00b00413fae64bacmr895wmq.2.1711561022366; Wed, 27 Mar
 2024 10:37:02 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:23 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-37-tabba@google.com>
Subject: [PATCH v1 36/44] KVM: arm64: Do not re-initialize the KVM lock
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The lock is already initialized in core KVM code at
kvm_create_vm().

Fixes: 9d0c063a4d1d ("KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index a0af0926d9f8..85117ea8f351 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -222,7 +222,6 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 int pkvm_init_host_vm(struct kvm *host_kvm)
 {
-	mutex_init(&host_kvm->lock);
 	return 0;
 }
 
-- 
2.44.0.478.gd926399ef9-goog

