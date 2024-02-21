Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306693BB53
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 07:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500365; cv=none; b=Q2pkKVe9Q8ps5sEuHRX91ePs3VZ/+fwnXqk5GDEH95v17Nm0mzc48iN3TlGc5oV5HS4pclFnZqY3s20ldWmL+KaLcUwNas/xSTUqF3P/QERKGo+5UbqoRo5fxg2YEaDE8u875lLobhKpKuzwjbMQRuWRs5fLRrYpvnGRg2WAboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500365; c=relaxed/simple;
	bh=Eal+RK83X0qlcGcNEk7z0E4RBKeo7UGh4/zIqBRmhh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMZP2r/WF4WWeGHCnFKLWYvjv8jTkel/+EvOD+i+HEmFSJL2KkUGgQHY30GTNmmjU19Q6OZstVfEi2XfOv5T99RW1Z/qLygmIJyA/C2GXwf4vLRv+kbdq/a8OF6ck0s9pPu3Y8DSn0gndfZJu1hy2LAa5DkRQGUBHQ2Mae97v7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bJOPv1eQ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bJOPv1eQ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1db5212e2f6so46868215ad.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500363; x=1709105163; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLOffij4aJB+MGCya8s97VNV+p1K3jV5QIE+Q+bz00I=;
        b=bJOPv1eQNwPhbw9vi6gow1MjRICbD8fUjWB9PVCUA9LYlSa/5HtGHh5J6z2rAi9rI6
         yCeHQrlRDtCbiY4bVstFyMJE1lXaB7LICJuSRycSFVXIGmbO2uPp4jpyEFjbD28ztYgi
         6JMtFyrvlL0qgX12kWe5gZNY6eOfKJmP2M5tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500363; x=1709105163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLOffij4aJB+MGCya8s97VNV+p1K3jV5QIE+Q+bz00I=;
        b=hEuag2HjxxHTT02rwMIRhahKpqypTOARbFV/8PISpn4KL6QUNWvi8TNAd1MaaPT1d8
         73FoJWWIDW6Dl6mpyhLQhgfDyC7ajehb++HMn5sQTjOQ7mVjyJER2kvk0he1q/PwaHah
         10tklQs2mRc7cf4V+6pU19RTXurhpi82huTs45NfrmBqcNlImsTsdpH7jB0buvsXd5g9
         aNJADoAzhuUnuhs1US33Q2QFa7D6H1bR2Qqn3djxagYvxcHp3ZmXXLzB6G3y0+5msRsC
         cybdSWgcFNA4L0PzScpCELpAgLioL9kh9eNQxgBbZCdEAduBU5czyQuF0hq7s/rnh0nD
         rtNg==
X-Forwarded-Encrypted: i=1; AJvYcCVYE97TDG3/VbeuGbaVeP1RAoIz5jHNvcr/MI1tBrgXnYN/fupA3AXM2Mm5FowTByVSQErDM/x9HmpreUKgXyJwhRVOwizj
X-Gm-Message-State: AOJu0Yw8j2oxA3vTssbvqfW1vdW/gsx/Q0py+OKHmWh/lGRjuc6K3/sF
	gXpD7XY0dM3+//CoktV0fPPiX3LF7ruw+5crPdZfDK/EMszpHTC1Bjy2BEk1tw==
X-Google-Smtp-Source: AGHT+IGuByzcDeNqa0h3/F4p6FUZXddbiOGTGnCFrf3ufIz55abOi6o/JeNcHuNQgDfA/CeMO+SZRQ==
X-Received: by 2002:a17:903:2282:b0:1db:b5be:5981 with SMTP id b2-20020a170903228200b001dbb5be5981mr17305270plh.31.1708500363442;
        Tue, 20 Feb 2024 23:26:03 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id t11-20020a170902d28b00b001db40e91beesm7415349plc.285.2024.02.20.23.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:03 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 2/8] KVM: Relax BUG_ON argument validation
Date: Wed, 21 Feb 2024 16:25:20 +0900
Message-ID: <20240221072528.2702048-3-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

hva_to_pfn() includes a check that KVM isn't trying to do an async page
fault in a situation where it can't sleep. Downgrade this check from a
BUG_ON() to a WARN_ON_ONCE(), since DoS'ing the guest (at worst) is
better than bringing down the host.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Stevens <stevensd@chromium.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5e4bf7c48f9..6f37d56fb2fc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2979,7 +2979,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 	int npages, r;
 
 	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	WARN_ON_ONCE(atomic && async);
 
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
-- 
2.44.0.rc0.258.g7320e95886-goog

