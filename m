Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E461FCCE4
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849105; cv=none; b=n7DWxDTUtZK5zf34l62cWQuAzkCb1v5jaOpqqfINJ5vaz06TX3H9EPc9zVj8xIh2gETCSOgo0okBC/9RfJ665mRIXj0e90izDXzEjg/SD4PH1NgYmpG9sVk+61+/WDfVQOoGSP0q/5nA2VMPe7RcUIU7MA/HL3SwFX2d8yBWsgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849105; c=relaxed/simple;
	bh=lyrf4f3kvKG7BFrUmhjOGbMpwkOJI6N2LuTWXvsNpQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ImGyYrUrBUssWwnpUVnFp5HWgJnUYW207CkRewgJp+phn1amPEfzZx2aMApG+zL2mwrVZ66PV59Npt9K7rp/GJ9Mka35eMxAznYQEcRQRuBZKSDbys5qwNy8GtzScThXpCddtt5Bh83AnSfi7jSmbVnEfIF9eJv+4OKeOy1nPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=WQI9zvtv; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="WQI9zvtv"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223fd89d036so11367855ad.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849103; x=1742453903; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NkHO/0se169XNtMWH0w7f9TQn0BTGs8vu96SI051qqc=;
        b=WQI9zvtvrBKLNdjb9MVxnNxjZE2Viv0HVaRR6/6+u+BPb7d0tzyEjMIlmidXKNCqwx
         A5jhZQytO/yIvM7j+XOAb1VgEVhYYasT0zYOc9e9+rDDdHCLCmLmUXqJWC2wy8n9tG6e
         rgAF6F2QOa719RdcLiKHc29YL6L4N7Y2C2Gu4A5W8Kk73mzN4c8u0IolsPg3/EDnYqG4
         D1/jjq6upvJ0o9jj7Kdq+H+N2QycPWarGwyJl99oRHwVTLEmdbclYndr9k7OyDkL1a8G
         iBddZmuMs+kIn3mt+w02zteE/thr/nsN7gGIXa+xHQ/8CwNNDARHi2vsoFDCrxZ6EOYn
         vFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849103; x=1742453903;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkHO/0se169XNtMWH0w7f9TQn0BTGs8vu96SI051qqc=;
        b=omSxuEVWPoanzLKuCOdfXxue85MjsNwtct984s8hD6IepsRTGMTqNT95ZRlcM0yzxh
         blt8v20m7A/5IjceXX1sVqru7JaQ8SNT2HkSGwKiLJLzRbvgUTyIm/omiXl1vtm/OkY2
         6dyW2uFy7KfRyun68OjJpZAzRfRknBqdyZj1e5kZN4JgGDNrdRhnpl8ep04AvPUSSJNh
         /srbthGSvuQ6nvMBIcpE1NlHc29AF/s42FuUtAAnEYMQAAbVqawfN871AD50SPdGki3c
         1go6GI8wIrvcqhvLRQG824C8Vqs0OuHnVV98egvT9vSYyjgVcjoUFUBAg14p4uVLIldp
         Q5pQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWf8YYtZWT3aejSBK7Hrm6DcPWw7OrjdDi5wwGg5jUhbeRwB4OXymyxn4FAxj38CnUzQoNLp8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRjCKb84DzYFcAjhnICELTQDsKa/06ZNlTVKNs5893VTWpwc7c
	19PnbtVvzAfBINynlg9ZtUA7Ivon0aOzxoej2rSrrSy7HtEIZrCUO9OIei0+2UE=
X-Gm-Gg: ASbGncvIcHifK13Ux9aStuhUqS2IK6CdSdsyzn45gninYnB5ek4rJpm3QHoj0mJknHB
	xeBclIrnD5cHiIFURirlx4mZwfIMfJENsoAG2QgagygKpuYq+NIJp9dN2xOKgJImVwjMnKWCf+m
	dc1QGqzckHAZvXiJsRWDrqNOtYT1StWes2+4YvZ8IaSg3GiOp34NgmgAJM1UuBzvAUoFeMmxhsl
	ZaikdwFauXQVbNNSSA/YsdlJ7ygMsIFIC46Ep3Kp5eA4ZhM0UNsyr7FwoU7oZ+aLO58soXbGRSW
	1iKBHToZB8D6KMs+UupAjvquWXgQjJZ/PONvSgSaZKrVNOqg
X-Google-Smtp-Source: AGHT+IF2RBsD42GnNZIX18nfjzpK1BpoSRv9b88G/rsSQnVVNmEUyx7yfAT1x7AejmJJpK2yhnpJRw==
X-Received: by 2002:a17:902:ec92:b0:223:569d:9a8b with SMTP id d9443c01a7336-22428898155mr323431125ad.18.1741849103632;
        Wed, 12 Mar 2025 23:58:23 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c68aa5ffsm6537725ad.82.2025.03.12.23.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:23 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:47 +0900
Subject: [PATCH v4 6/7] KVM: arm64: PMU: Reload PMCNTENSET_EL0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-6-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Disable counters that are no longer included in PMCNTENSET_EL0. It is
not necessary to enable counters included in PMCNTENSET_EL0 because
kvm_pmu_handle_pmcr() does so if appropriate.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 461c76a9cb6b..dfa7048a3e2a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -835,6 +835,7 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
 	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;
 
+	kvm_pmu_disable_counter_mask(vcpu, ~__vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 }
 

-- 
2.48.1

