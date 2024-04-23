Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E862313BADD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884755; cv=none; b=Un4pUxhzAScUi0PqNVINahYhJP0Vp7NPYRtawe0PF1OO7LdT6Vg0K/zYFNgnjkfyPq5EKdA9Rrx0PzEC5Km2fEgmLpJp42MzhMoTCxrYqehGQh0KUYP+6J372a8Jr3m78OH/o+CctGwVmVk3j5dfmxsEzFFz6tHTje9hPeKYmgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884755; c=relaxed/simple;
	bh=W+5yRtzoy7EUvDb4KK31Lnj5j51ojL+O+NPBsRD8we4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Probt7lQPpgIudijkCru0pywFlj4K+eePKPhgUkAVaw7WkZO+BoczWM5eTwrYy8gIFdaPdRWObZJSq90b/z2MdrGZf9OSvyWeDqy+sxOtTySDTB/jvHEjYyt8DIhYSq032bSXEhZoiP0v3lBk3Je1xWJzas6nsgiptHkMqRJ2zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=md0X8/7n; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="md0X8/7n"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de45dba157dso9446017276.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884753; x=1714489553; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5vwxGHvKc7IvdW16eJM/90clVgPk4hg4QdQd0laEsM=;
        b=md0X8/7nTTajZ6pTsDU0arXbV/Sjg5kkzF6dYXlKNap35zj1IgVxkYBwEBbjiEhyJH
         cklaxDlz8aOE1m7JazNi5HY2JyCnE1uy/oCnrg9RA+ShGa2EShABBH6KamS1TVCMyDnq
         CI1kZ/mV8VbVFNyDKukWGRYFQlqSpcd1SGQ4wsROa5YUZ8Z+uAnzAQJ6tuXyKjpy7JvH
         zmTamBiP4ZLcjr5dpMFgTbFO5vUi9qpBdy0ATIPuu1D6Z8MtJsd4SmVEuhQcxFuG9TW+
         qlB+4wIoKbyfI9IAIkmzq0VuGV5iT+MDBeKLjDsIomiHE9pPTLHEj2mDMT8CeMYQG6CU
         isZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884753; x=1714489553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5vwxGHvKc7IvdW16eJM/90clVgPk4hg4QdQd0laEsM=;
        b=T1CztcjMtCCRvTO50tVmQYEKiE+iaBGp4sRWfU415zWJnUsJW1nYPVkFSsy1tevVzJ
         z3+I7BWD5JFwieLOSuhq0P7kYfO4j2LddHUIQXeBcjNbbycUZh3saqOTuSFcEyloUrg5
         dwC8SabMrlwxlW15CvJEu5P1Blca3SjQ4Mujd9A9qjIQKPDfLdN7szqUFq6dVutQYY8b
         PE8Q8/7wNTbQxrq4a9Buaet1X/rv3dfkQKmKudhzFdk2/p5/jc/aJYsAxTZS7GUDLKzC
         MI22fld6Mpd08iHjrBvCzldkT2JP5ZWfwy7tF+vVyK+oKnHW3z2jGSKZT3pAqfAdvnCN
         0sZQ==
X-Gm-Message-State: AOJu0Yxu/PuiT1UBYBcjXCwGJJQ3BN+qAq+Dhjl6gBl44RtgnfnsSQhh
	VYfRttOysARICgG932YVtPzyE7tjNx4pZG3IGf+mYfDa4jgVcjPe6Acc03VNM+D5Q2na7ZTQMHg
	OyN0VuxmNs4Y1NhYmllFUewYs1RSP6/SGQYXQ4oSedVMdRLFRX9E5HPywy5qaa4j+/LeqRJ21nF
	vvQyQ7QktPbAHQHdaFLuZAs7rdsXc=
X-Google-Smtp-Source: AGHT+IFzoIlPq56wU0jOF5hCY3hdWfegQVUfDg0CRgaTOM2WC1UtLn/xDn6Kc1lxkaVcuMiDlNhlCx1DPw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:150f:b0:dda:c566:dadd with SMTP id
 q15-20020a056902150f00b00ddac566daddmr1034721ybu.4.1713884752291; Tue, 23 Apr
 2024 08:05:52 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:13 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-6-tabba@google.com>
Subject: [PATCH v4 05/30] KVM: arm64: Issue CMOs when tearing down guest s2 pages
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

On the guest teardown path, pKVM will zero the pages used to back
the guest data structures before returning them to the host as
they may contain secrets (e.g. in the vCPU registers). However,
the zeroing is done using a cacheable alias, and CMOs are
missing, hence giving the host a potential opportunity to read
the original content of the guest structs from memory.

Fix this by issuing CMOs after zeroing the pages.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 492b7fc2c0c7..315d4ebe1d6a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -441,6 +441,7 @@ static void *map_donated_memory(unsigned long host_va, size_t size)
 
 static void __unmap_donated_memory(void *va, size_t size)
 {
+	kvm_flush_dcache_to_poc(va, size);
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
-- 
2.44.0.769.g3c40516874-goog

