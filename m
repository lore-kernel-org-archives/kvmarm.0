Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC8D73196
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447878; cv=none; b=BDq3+6NxXlyoH+HyatqCatIP+X33qB4s4ZOF2e0cLmqaXabn07LP8cTKYK5kjZfnjwoqz6l34fULIIXkSRgob4E9UdTsBEy8FhLW3I4YGphNpyDb17ZwrYZq1yCNgnjMMY8GG20g2a4szi3swKjbkOnWSh1xSCjREGjl2g7UINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447878; c=relaxed/simple;
	bh=dGbffwfi9F8o5vKXOK784z8lOxK3B61CBLe05LF4uDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/v1Omr1/vKvRUxhr8WPzvj34R5p57GqFNWWaMKzZSHGAvpRIvX4SgS36rUbnw4PQtgUT0BfGPqOUlbN+VSOdkbjajDmbww2/62wi1//cWoj7MeGaARkA/HzAxcRv6s002Qka4tZjBmd8+wsoftfez25YhFasTEZUgQSPUlnm7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFHLNw+F; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFHLNw+F"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a46644fee93so193006666b.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447875; x=1711052675; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KeVadU2hZeC83X7EyIxA1rm2PDaUR9fvRb0RDycrigU=;
        b=bFHLNw+FgK/jlEY6a/O+0DOZq14sj5KpXIchWIB1fjSu9GErIqBiEbxxaPiZDUnsUs
         pJiiuYvukiHv6Gg1GLIQF5j7PZ6zw2QPD6zQ9ZB55RGGSrlUhFWFFWCv2+gipcsTXgmy
         /hKemcjN62h58dNSAItWzpU87xezRU2C7csgFHrjAEiEphOQaWlXYhSvQ/iVHYl6fN5N
         3YDwhFUK46UCkZ1F/GBDv6CfJ+EKpz0M99mbtn+FXHTzgzAb6cW24B9ArbX+6N6blQ1m
         a35ghDQcbrJDGuSrLZfnJEm1F4EaHwZIm3BYFjCa9efkqmiRtKLmUK9wLbIvmqIIZS0i
         RirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447875; x=1711052675;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KeVadU2hZeC83X7EyIxA1rm2PDaUR9fvRb0RDycrigU=;
        b=rqdUfYUdvUo0gpZe5PrYovfDinRgYZ4F6eKXe+K+A+BILZWL7JHG6zG5U1FbV1Gqmd
         AOeVOJOZ8pYFFoUf3QGXDa5s+b/Pm1CqmCPx4vaLB67c1cRkrfNlwgrNwDsmCJdqW0Ts
         q0LqH+8aCQ5UdXrloAUCf/bpe5/GRx9ZTeP2BsShm4lYsnMx/dm//S4nVO/A14zQWJ2N
         hCrqZfN6frBhtHw7Hown5NIcMg00gbkvFgZKr9jRWnhA9oj+v5KVLXOdWkXOA3SeY9uM
         qJNWLoqf4drhabhUPM3zTDTh462O3aM5nvJPkLMYnASglPEMY6SeoU8rpP4ktQty2AAZ
         4ZWQ==
X-Gm-Message-State: AOJu0YxDhIa279Xol308v+G9TyyKU+F0iOf0Ec9whJWiNLkhWHulkyAa
	b1JcPMAefpUEE2iFmtwhv2yTfVlq1J5IaCDM4PoJCZTKnNMq1BguWebgNQuBxWlSDxoSoZ9rfpG
	192dy
X-Google-Smtp-Source: AGHT+IHucnNpHcGZETVpGOJfR1+fsfUsDKCT0Rc1DvLZfkdGAS5fojQQqY/5p5KP8nfAh80FDRV5yA==
X-Received: by 2002:a17:906:bc56:b0:a46:5e38:29d7 with SMTP id s22-20020a170906bc5600b00a465e3829d7mr1861511ejv.10.1710447875391;
        Thu, 14 Mar 2024 13:24:35 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id vi2-20020a170907d40200b00a45c8b6e965sm1012429ejc.3.2024.03.14.13.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:35 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:31 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 05/10] KVM: arm64: nVHE: Add EL2 sync exception handler
Message-ID: <cebafe40b170589d52e2ef66f3bfac7396fa1f56.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Introduce handlers for EL2{t,h} synchronous exceptions distinct from
handlers for other "invalid" exceptions when running with the nVHE host
vector. This will allow a future patch to handle CFI (synchronous)
errors without affecting other classes of exceptions.

Remove superfluous SP overflow check from the non-synchronous handlers.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 27c989c4976d..1b9111c2b480 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -183,7 +183,7 @@ SYM_FUNC_END(__host_hvc)
 .endif
 .endm
 
-.macro invalid_host_el2_vect
+.macro host_el2_sync_vect
 	.align 7
 
 	/*
@@ -221,6 +221,11 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
 
+.macro invalid_host_el2_vect
+	.align 7
+	b	__hyp_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consuming
  * SErrors that should only be consumed by the host. Guest entry is deferred by
@@ -233,12 +238,12 @@ SYM_FUNC_END(__host_hvc)
  */
 	.align 11
 SYM_CODE_START(__kvm_hyp_host_vector)
-	invalid_host_el2_vect			// Synchronous EL2t
+	host_el2_sync_vect			// Synchronous EL2t
 	invalid_host_el2_vect			// IRQ EL2t
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
 
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h

-- 
Pierre
