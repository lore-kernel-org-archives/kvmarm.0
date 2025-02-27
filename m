Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498CEC2C9
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616408; cv=none; b=TpAQfb8ggITNbZZAgTOr8ByTX5XopVJbJHjoIoKDkndyZTEtXC4X6jH1ODSMoNqEvEF7dT18PnJ2DHTbQnHtoGJqrJw0riOITdyuhbRD53U9Alh70Fiw2Z9wX/WqYEEqsBcG6MyqQ8L+SgcYznsqrpcAGORjJQGvw3GXolG2/yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616408; c=relaxed/simple;
	bh=rp3IDhVnxkQh03oSaa4+o9TnUw4DyqtAF5BOWHgKtFI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LJzo+17gh4n4hbLD/C3fJAYgHT/kB7h64yI6SkpUG8Auqd6gIV2ojpfRs7nylUoj7dLyaJXQ1YkSYhG9dwKtbMtXYKRrec5u95Sqky8eI/fzoLwlIdzstTyjPhxrF/jgG1ii4H2UOG72EtPEOLayOiz8ubp0v46Dph5cimle9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wf/vwghF; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wf/vwghF"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5dc5beb5eb0so207214a12.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 16:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740616405; x=1741221205; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=go/rSw9bkr3V2Z7S0UpAa5FZKtjaGuIC5hzD90cfQFg=;
        b=wf/vwghFf+yF9nIMNl1r2fRhCoVR16dlDTnSqbxDDQO5xfSN84TItaeCUuQ+YhCOx5
         8//B9aDR4fvOdmCA76UGC/3bYyWhWQJj8fbyXcZ1ELmelIfyT4ekmE9HvUrcFuvDdrJD
         mcqB+KNjdMh5+xKbtwvkhmQ8b7hBMwYllySEgP3tA3Zdd5KAiDPlbylYQAPOlvT8/XeK
         fxoRIQevSb4dwbD/KNL8rA/KEENAwKHuiAheuxr1euIjfrd2D32zEvtfxY7Zg7j185bi
         nKzzaRJ3/mNvQ/+ijYtWhOfW9Y1u4s3rH5NGKYjD6d02LKoASeCnm5y/3ylVk6LyLxA5
         5bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740616405; x=1741221205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=go/rSw9bkr3V2Z7S0UpAa5FZKtjaGuIC5hzD90cfQFg=;
        b=CVkZFUPT7N6BS3eRPcYMRyiPTF86EmHheDy5sPbk2GPqTGfwrJQleP9Xoi56QDzg+m
         5RAYDOHlPxGbw4TEf+5wy6VX5quENsuaHC6Gwfdj+O3uS1EnGOvuhicLhCvnnnO0nt5m
         UjMg2vSItnA7LwrtfHqov9aYo8zvh8DlEXaNhvdKUN03LdkCMJxZTjGwQIsOSYjqZ6c3
         UYIOGbMyKsRgNVfHTlh5pm/Vrini/p0thEbD/DWqkd2vMuLY1QK6PXuxSCos+azjpKjm
         68EyuSbjc6WZf0vHfDc9vRALAt0OV9GpAap3sNERzpkFhWQLU8vhnmWuzRsmd2QH0b1X
         svsg==
X-Forwarded-Encrypted: i=1; AJvYcCXBDSCTpVRw4aPfik0cqLPI4bNq7kWhWAXCJ7z8BabVO4wFKGZ6opq+LzcriUk0VH2fW2CoF8M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqBxlFMzLUKXs1OJnTMq40t4F8FJrM7ytcc3LGu99hIbN9Dq5f
	Q+/xqiLszI9Tolv+6ntpJ7Kz7dhHupG/8kTvNDIgQ1SDOjRWbuX8VDW8lnQ59IzoJn20elozQqi
	6khDxqQ==
X-Google-Smtp-Source: AGHT+IHoE0D/+VTxFu9mBffqWU8TmUIEm77P7VHQouobm1YsZoARZri0ZIO8rfS0b5y60ajdzwb57L0Mwq80
X-Received: from ejclm3.prod.google.com ([2002:a17:907:18c3:b0:abb:9896:c72f])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5202:b0:5e0:8c55:4fa
 with SMTP id 4fb4d7f45d1cf-5e444853ef4mr25783357a12.6.1740616405565; Wed, 26
 Feb 2025 16:33:25 -0800 (PST)
Date: Thu, 27 Feb 2025 00:33:10 +0000
In-Reply-To: <20250227003310.367350-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227003310.367350-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250227003310.367350-7-qperret@google.com>
Subject: [PATCH 6/6] KVM: arm64: Unconditionally cross check hyp state
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor's state is stored in the hyp_vmemmap, we no
longer need an expensive page-table walk to read it. This means we can
now afford to cross check the hyp-state during all memory ownership
transitions where the hyp is involved unconditionally, hence avoiding
problems such as [1].

[1] https://lore.kernel.org/kvmarm/20241128154406.602875-1-qperret@google.com/

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ae39d74be1f2..22a906c7973a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -695,11 +695,9 @@ int __pkvm_host_share_hyp(u64 pfn)
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
@@ -755,11 +753,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
@@ -785,11 +781,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __host_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __host_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
-- 
2.48.1.658.g4767266eb4-goog

