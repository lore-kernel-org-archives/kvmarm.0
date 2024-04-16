Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119F2907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261411; cv=none; b=MPt95RlGo40RNK3D5rn+chmUwr3z98KOQPCQHqY/g+11kPADciVuTrsCQJOsfzrSsxgpyNBZAbDYTtN8IrnBR2cNE0xuE8Z9Pct/uzbbxVSThy2OQ5Z/J23FClJLFpLPSGFg0YGDuCPxajZY8LiY9rv9dKgRnnO+lDLfs+dQIb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261411; c=relaxed/simple;
	bh=fYxpMrbpJvuPh5ffqVwGj088JPzx4+Mj2stD74m+54Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nV5NtlAD2i0+EFX3iZ9evvxZzzawi8XBQIq1mzfy0bsltfC1orqm9khweUQEXK6hn4JIr2EHxKgkJej6qdhHxVMP+nyk92amOU+uivXhj+YKUyU3G6BqLimLblyWMoKMozGKwv635+MJbd9eHpaf47WikfkTGY7QlSPbOZ9178o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tfpJWKiA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tfpJWKiA"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd8e82dd47eso5750259276.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261409; x=1713866209; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/D2LADnGuMqDgo1B4sr0HChc0AxC15FXYAR4+ipeQM=;
        b=tfpJWKiA2JlrdZhXIBUz0ps+/BZKMn5uSUI2CjY4OvqjTTafHmLzeUOG2qPBjBPSif
         ly4JHH0JfnYhmIBQYWTX7fVUVuVE287kzS94IGfZ8W+aQbUhp++jaXDh8LlRbnjizULE
         V8NpzHiiTdWte2K/L6cWGHpy5f/onIt55aZrUM6uVn9549hxs85x87Z+aSQi6bbCi2rG
         QE6tyGj/3xnLsAnUXFrARQe3qR+pwUoDbZa2LP4bq1jXSnr8hLIYxuuDeIZWI9APKvoW
         WNeJwg9oYsLdCIA3sUqSK1E62Pl+dY/oqIPcxopTHNpHlHl9uMg0Vx9rXXldAxpY/Ysx
         IR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261409; x=1713866209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/D2LADnGuMqDgo1B4sr0HChc0AxC15FXYAR4+ipeQM=;
        b=gzKCMKUFE2dQMgvJAkTblig8cTxLAOaLplAHHwLq6XJhtpbOVBmkGbQSalLlhbdgZn
         QxUNpHTqdIklIbbvZ/+IHK3uWehbkIp2/MEImr31PoI9e9+MQaeklIatm0qQVIKd8A5Z
         /jvuuPuKYy2rGXtbjWhqygSRXu6bIvQ3f7UCpUHLQPhDzqabe3PtEbJRZ9kaVa7A/FJU
         7EQbUmGyDHNQpfNHyAmtZVnb2kq5N54lJCPEWF+goRSiup+bgKJPdDQz462F5E+eUuH5
         pg08M8dqsqRzpp6ISH1oz+gCUZapHKmCEmdZapaMd4JTsP9YakS0SUIOivEH8EekMxRg
         Abzg==
X-Gm-Message-State: AOJu0YzzmaoHamc3gJDcG+Ov/VA7ezgH4DNi3+KhQyzz18NRGoBILlrX
	5bEh7vq63Z1M5KmPg2Cw2wHcYExbLnNVPao2HWmpBFv4wdSZwsZkNPYQTTE2d8SjCh95RMS/ac2
	AEzHjdf7um4aC0/DZlNrQlZiQcEkWkSGVLmv3OTWqgN44DYhWhN0cRixXvDHXSokevqhFmxICUi
	yHLfXRwpzVpYSM1opVPTkYleKcYvU=
X-Google-Smtp-Source: AGHT+IGZFcodPtdtvT9uHxQTknr3D+zQ/9YqJ1c9Dup0+zUeFv/DLCiFDRF7IiqoM7YpxYq0rRREBA7pOA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:10c2:b0:dc7:82ba:ba6e with SMTP id
 w2-20020a05690210c200b00dc782baba6emr781297ybu.7.1713261407914; Tue, 16 Apr
 2024 02:56:47 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:54 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-4-tabba@google.com>
Subject: [PATCH v2 03/47] KVM: arm64: Issue CMOs when tearing down guest s2 pages
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
index 16ccb69e6479..ce88034540bd 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -448,6 +448,7 @@ static void *map_donated_memory(unsigned long host_va, size_t size)
 
 static void __unmap_donated_memory(void *va, size_t size)
 {
+	kvm_flush_dcache_to_poc(va, size);
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
-- 
2.44.0.683.g7961c838ac-goog

