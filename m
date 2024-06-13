Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2E6145345
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284865; cv=none; b=gUlGrd79P20eIerExxuPu6FYLNr01grkw5lRh1eM863WHnrxvjDciuWZfw0ptHsEh8EJ7FC54/RWqC+If5iELvLNNyAxOSG1JN0fDrL5py04CMrtxDwi7CRFbS5c5nmlu2iCupwyTJGUlX+i4Jlo4GUehMULCiqP8JHpGyr/ZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284865; c=relaxed/simple;
	bh=kxJ6yca6FhrEdaeRJHlyh47eGEiERJamoE3DlUAPJas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pxur2o03zWc1wUGaT0pLrKGyqMr39JPzshPmG4/iG7znQmhuHUxD5Qv56cWdfOUTWtcwSiUdr00w0O1V4GRtVg7UuZFrYOfPHXum5mQ0o+Tx8siHxYPOcr/GJRTv+kE7F3jgyl6Q1i5lSorW7Z5JICXJJenHmbH/uDfo9pZ2YHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RfHD42v/; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RfHD42v/"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-35f2760ab86so772236f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718284862; x=1718889662; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=85ojJxkNYXxh97Mo9k1gfrYfK0JeNvYJnaS4+QvvHCA=;
        b=RfHD42v/Xl2ozuTsHL4M01g4nZxj+792Y+ACa8Yo1bS2cYoqxlxrbmUOn/GuZZ4avK
         dlBrn68YKTVQlcPpVW77Fy342cw351HWD9OzM9LQJ2OgohOqJpEMjbErWgMnFHeBBMnt
         fATF1sjLEyo1BVceuqtYBr2PRk61v7G8+E10G55E+lFWM3tWHaHPA7Q6RBwBXIyMOTYV
         qC/yfL3Ogby/a8NoJYheoYpS74Ab9mgYm/6jtsm+fJz6syQqrMMRVSv8IDFxyMjXf3mq
         IgSFqJ7VGmZPE/nHG342KgAZLpmTfR0aPPZrNYLqYSLGf/vXIEHm1o0oTwuG5JyPGzdG
         lfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284862; x=1718889662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85ojJxkNYXxh97Mo9k1gfrYfK0JeNvYJnaS4+QvvHCA=;
        b=Lhbk3fqb7+NdTT/FtHtG9Y6c6EsOWrzGQA7R3d1quEdvx/Pzk3uIJXIPygBXkzc+rC
         VgaPADPYEq9KCFv9JO2G2YFG/5vokiXpjk74IIDvG+iiiuk9FWJRAPuS7hiK3LxvC7GV
         VAkB5sSwf9usQyEY26Pzwlh4mliCMR41zP3br01JKD2OwzUq5hclyVVbK7oj9y9uFyGa
         +VAf77IOXZ78okhbxS6fLG6qOu+8SvlQd2qbpYC1a8nfBg9MoZi/UzngWhqbV/M5V0ps
         0zKDlzNqjy23vM8RiMSOrEOJu8oZf3a30KQAxsO8Ff55cSyiqDZJEc74yD70mbPhNINr
         gtFA==
X-Gm-Message-State: AOJu0Yz4h8KcRExeKSgblpF68+d2JW1p67ph9Np0chq6+2iAe0A94G1m
	hhMWB4vd2EdwgJ0c+qYLBDZ+H/p9Vhy5t/Sf6g+pCJPsMYTvzmG7h7IPAvZ7FVB8LCsc9rDH705
	tSPgKUEoti0wCgDw6pFIrnplE3g==
X-Google-Smtp-Source: AGHT+IEGmcAxjB2wRcZVPwbydQye9U+Lfxf52+t870ONm/t/2enRlN5yWNU9fxSxYfGOvDAZatwr0XKHsQNvtwSMq2I=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a5d:4e09:0:b0:354:f4a4:6d35 with SMTP
 id ffacd0b85a97d-35fe8928988mr10512f8f.13.1718284862437; Thu, 13 Jun 2024
 06:21:02 -0700 (PDT)
Date: Thu, 13 Jun 2024 13:20:35 +0000
In-Reply-To: <20240613132035.1070360-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240613132035.1070360-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240613132035.1070360-5-sebastianene@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: Use FF-A 1.1 with pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the layout of the structures is compatible with 1.1 it is time
to probe the 1.1 version of the FF-A protocol inside the hypervisor. If
the TEE doesn't support it, it should return the minimum supported
version.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4eaef673e98d..fdb63b7857ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -457,7 +457,7 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	memcpy(buf, host_buffers.tx, fraglen);
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -536,7 +536,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	fraglen = res->a2;
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
@@ -844,7 +844,7 @@ int hyp_ffa_init(void *pages)
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
 
-	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_0, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_1, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
 
@@ -864,7 +864,11 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
-	hyp_ffa_version = FFA_VERSION_1_0;
+	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_1))
+		hyp_ffa_version = res.a0;
+	else
+		hyp_ffa_version = FFA_VERSION_1_1;
+
 	tx = pages;
 	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
 	rx = pages;
-- 
2.45.2.505.gda0bf45e8d-goog

