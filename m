Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671946453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513595; cv=none; b=OOoNDvEp2xoqJPNKeEPhWfze35NABSCFMDNP9FhWAVOTqlAizrHbZi76HNbggS+iW1/RZrzMN7I7qWcEBdw9El29PA7T6bhq6WGTulilxcGoGPWAgE+5CqJkSBhx1SDFFY85I6BGKCGvPOyXV/0N6x/bl28zT31p5fZZYS2WRwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513595; c=relaxed/simple;
	bh=vtogVAifVPZKkCAz+2mDqhqyszqWQ659/3xtyqLQK2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RxpGbaZy0H12sROWW2Z7/6IopypGBQXJ3zhRuHv81gBaE7zG0b1VtZz9U/8jnmH5Nc4/ddMmkr4OUjOVPhFC7l9ADdlhXoGxnH3waexuvWOFph9ZnEY7K2xSuG8ocpUsryjUximD/inyGU+oDKTEcmgGuj49950zR2aQSvhnyMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tnSKRnWk; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tnSKRnWk"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3479b511725so1224387f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513593; x=1714118393; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikSaXoFKf1wLAyACTTUVaZ2PDIoXO3/gDxsl101nxRc=;
        b=tnSKRnWk9blNlZvqLPZ1pO10q1JU+XMLjLmG5NGPevrNKjiYaHoICG1Si1IWbRH4SY
         hc0I4IN+fA3anyUbU4iASUEGx3/iSXkJ2Tz32cIdqH2vKN9phvZm29DLNKNH8zNz5t2e
         kDGgrMjL924UjOrW+k14S/gR6NU7UwwRrfVMuYckN0eE2gJp1G/RACB452wvwOZIFHbK
         2rN9B1gIZleyEefsrwu41VXTgJzghy9SswvfhMGpkuxG275G7zJVwVoqzirWx27ogJRN
         xROvJDPU2hq8uP2n0gl2Le0acD4RRsPCyL/HIPl/vn1Ebk7FJASIThC5HlnJhPjJ9BRu
         hppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513593; x=1714118393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikSaXoFKf1wLAyACTTUVaZ2PDIoXO3/gDxsl101nxRc=;
        b=Foj3140e94ri+jkO+pZUEtybyO3uD/X7Sdpq2CWrLu4Ub9tSMtn0ywB4c9ok6howrG
         BWAZiZkKFKNVUtMBitDY/XnNOqNYnV5P5e5UCduOwO0cCDdFdhzi8YbSzrd6wxY7WeQL
         /wAVeniC7XItLzA/rEdEsCmHnNq2RDBP6pPAOInlTPcXCLmM84IWGy1xSmB9J/9QzkMS
         uiASCnahqkUpAYIpiusI/YtosbC+FsR4MntUvKP2oV3QuVlS6muA20dhAPUVUWxN3YjV
         mO7hWbMozfEoA8Kj3LSLztW5FuiQz/veI0Rf6qCmjtiHVZ1jaNLysnyIy1+y936CW2wU
         ULTw==
X-Gm-Message-State: AOJu0YxFsAO2hwOqiYdxL+3eG1d526uGGr4qpPgBePL3gWBR133n2UNG
	UU2/Jz5Vkgx/qi/aarSKfyKKo//pbf9vKtoA0MjYmSRkXGaLH6KXiHPqb/FjsMRu0WGcZHuyxfU
	mOQmFsgOd+4bXd+fqNNOAmA0SvCnK4slNtwRRUSE78kAa0LjqoCvx0Dp6WUh2DheI+DzJerDeLu
	YK31ZCifGVpBHjqeUuG9uCUsp5Bjk=
X-Google-Smtp-Source: AGHT+IFmB3/BYAvHPhJwtb9mex3QtPsuWjQMxIxAAa4grQfwgjyGpUvFdC0cC2mhqLuNpDGdOKlLRCZdXg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:db43:0:b0:346:858c:b929 with SMTP id
 f3-20020adfdb43000000b00346858cb929mr2859wrj.14.1713513592520; Fri, 19 Apr
 2024 00:59:52 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:14 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-5-tabba@google.com>
Subject: [PATCH v3 04/31] KVM: arm64: Do not re-initialize the KVM lock
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The lock is already initialized in core KVM code at
kvm_create_vm().

Fixes: 9d0c063a4d1d ("KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b7be96a53597..e2c08443f284 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -222,7 +222,6 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 int pkvm_init_host_vm(struct kvm *host_kvm)
 {
-	mutex_init(&host_kvm->lock);
 	return 0;
 }
 
-- 
2.44.0.769.g3c40516874-goog

