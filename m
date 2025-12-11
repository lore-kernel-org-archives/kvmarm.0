Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AFE2F5A36
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450035; cv=none; b=U97l9nddkKcsNnHzYpqOm6iJBO6L9Fl0A57Pwcir5eb1uQCmn47YM89XPf9n85iZ59MiqFywOiFywytfhGzajegCtkyRAfdCz8zuZf2ivk5yIBp5HLMSpXc0L2cDt021m1R9gDqgJUoIvTPWpBKkl+oF75TRsDMP3wQUBwDRenE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450035; c=relaxed/simple;
	bh=DVsd37nCvE94CkkPU3ro//ptcGcxUZZpp+9ilN/9FT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fnNXqxNW8LK+St1eXtmsNYOR/rA679eChLVCv0aH4ujGbNAPaTogmRwN+AF6WtlDy50QdKAGgAhypcWOhqHWng43g5olYIicx2TUftArGwyBgDPZt6YisyYQEhunRss3Y9DT1cqhjzAhwx68BrvyFyFW1ewPJd6dCNxqPqNz3YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gdblvgJN; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdblvgJN"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b70b1778687so55262666b.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450031; x=1766054831; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqqmxcdVkzTCOajtcgiZXftpHXD5dGukksoxeGfTga0=;
        b=gdblvgJN/fWtfho7qLHnvtYw3k0Bu12ZlJZ5IufZevUPY8uD9YKpvvBfQZxFaG8IH+
         ycKf61q8iw6Y8YqSYUBbAURARjlhB7GHfUY7F2+ysOzOVAgYTjC49QUw1xFQnsDO+oTf
         MiFIexO1+SeTzFfeD/GoPhxAlHNZQXgN6EKKH6g8jn3sesKHKCXdZu0YztEhjFXy1jhM
         0dPGXVlWRaAQ8fUhH+cZGbXXkRiD1N8Y5LKXY/tHBqQ8kZldl4QgJK2ZQi5CHo7JF05B
         qwadTHWPUib2WrJNp7nnNzZldjA9b9oR1lG5U3L/XWrP7emNN6din8B63cRCi/6gm5OC
         Io3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450031; x=1766054831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqqmxcdVkzTCOajtcgiZXftpHXD5dGukksoxeGfTga0=;
        b=v4aZYyzNJogIcmSI3G1qzbPs+I+P+nKnWbL+o1f4LRwH5j6dTDr3fiRum34ySyQkft
         UhAh9lBx7IIFIywP1O/G/LBZgFhOGYeXqbcYLERg6wZh+Be+gkfFcw3LsZPxdFjEdqjM
         7W7MNm573EmT+f571ZPUVHLyj8zWeFesENRzHGj/dVcypvn5698yNhGriDXqVmjQCHQk
         s7kl+drw4mih9he4JC+zB2AjoxQGglhUb28nO3jt1oC+CdoLDSmApwWLFsdtstO2m1dV
         z6qNtqDTDDRc7UMq81t2A0UmhvXb146Xu/DyzXghNTdcNjiKFLCNx4cOeGSuYpVlkDfL
         PnSg==
X-Gm-Message-State: AOJu0Ywq3P8mRzRj+6Awp/YykTnYyg0p/dzrQjcfCsZkzoLv3khh1XV3
	K7CLsgcEKC3RZUnuGqMkUsV47PP2mRMiw3aqrBwtNsSHk7GvJY1zkCjmvfvGSilSsH5iXcZ/2OF
	txgw1RuVp7doAqDP9s21sqofDMF/IfPZl3gJ9x9oHeWXv0nLCTUH/H3wkT6Ab4DMjK+lTkvBltX
	dCXSGwthocbLao+BpBRt+5QkU/OA/CRv0=
X-Google-Smtp-Source: AGHT+IF+0VU7+ANp0QfeE8zIM8Vmgpcs4f/A+ibyHzS59B8VrSVBA5mSFGH+wSJ/LBwQMJHzgebSqsDiDA==
X-Received: from ejdcx5.prod.google.com ([2002:a17:907:1685:b0:b73:7b15:46])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:1c0a:b0:b73:758c:c96f
 with SMTP id a640c23a62f3a-b7ce84853bamr566099966b.52.1765450031334; Thu, 11
 Dec 2025 02:47:11 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:01 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-2-tabba@google.com>
Subject: [PATCH v6 1/9] KVM: arm64: Fix Trace Buffer trapping for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs in pKVM, the hypervisor should trap accesses to trace
buffer system registers if Trace Buffer isn't supported by the VM.
However, the current code only traps if Trace Buffer External Mode isn't
supported.

Fix this by checking for FEAT_TRBE (Trace Buffer) rather than
FEAT_TRBE_EXT.

Fixes: 9d5261269098 ("KVM: arm64: Trap external trace for protected VMs")
Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..8d06a246dfd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -117,7 +117,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		val |= MDCR_EL2_TTRF;
 
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
 		val |= MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
-- 
2.52.0.223.gf5cc29aaa4-goog

