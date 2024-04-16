Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A3985929
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261407; cv=none; b=CCebflNIcOg+tvtsUT3yLvr8BSIvSJe01OxyIbj66+/u82dMGl7n5gkJbWqPHQDbjMAmTato6ydqX1AoWkBA56+EAU3L3uryPaUQ21rasOtQZLKQNbOFi5jxraXCN8u6Z9e4J1yttamzL4pAUcG07z5S+1cw5o6OKIxTM4Km238=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261407; c=relaxed/simple;
	bh=owaBLfeg248aO9lLf3q+3T7UT3i7dxvkALkzcz7b8S0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uk86akbf8obDYGTHGX14j3Tas6CnQAwiZB3IKW4siP3gZ9kjCHK8lYss+Av08MDLLR9eKNvyR3cOa9x8dfj4shbpMW8+AvqWH5pNgqtSZ2BTMExHMNqo/v1XNM/2vcpRLfrgfxKxEXwlX7dN1o8u6X/Kbhkfhq6E4QU7PcIktKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P84p+Z+M; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P84p+Z+M"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61afa79081dso2010667b3.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261405; x=1713866205; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=at9lzwCGSA7CXT/GRtJPexMfZIJS/Ma1k0CMgdbKfk4=;
        b=P84p+Z+MF6/OwyNBr3FSPVS2Gg1mizCGD9Iy+9vI6aZG/ttvkF8W5UMDV9KDgD2UUD
         3uLUUtE4RMWncoEapxzDGXzGZVGNf4oHD+2LDWTuhkuSBxig2LNLnDCF+e5zn25iNWY5
         FkXuhUGacr1CaV2tj6Gjs2DjabAvRQ3TYX1EvW6w5wcSF1Mk7jWUPgVo3aHP0yYzOaUs
         biZwspM73670S+rqcqt0wIrB3k4+k3VllTR+4sNJ5TrVAkzcEHrO9e2qkR0uSgFKmhBs
         0bbbh6bngfHcOeBNUDOTHEuQyLJnWDPU2MdcP/jmrVx6XDaYdzDzt+83A2pFJaD+xH0D
         1/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261405; x=1713866205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=at9lzwCGSA7CXT/GRtJPexMfZIJS/Ma1k0CMgdbKfk4=;
        b=j+MLpAFxDs+78ZEeahInTqPRGk8sFfCgMHjazJpIbUjvhqa6Qh56cwM304pH/GfIwr
         hSS7D9pnoch267pzIS0fDS82YGHDV0q3OFwepnEuCO9fhPwzNYSJnglCKAy3U+Ws40au
         qxzw97zG7YdZZNHl9G0pHrQqUWxQ4VIDBeTImI/VrmkRII9Ky9ygfWblxFW/IGruSy6q
         E8XmNgHpfD+Y6kyVYQyBJG3TOPFlqI2e48r+RkaCOiDdJf4530rXM8C6cdf5AORmWolc
         HeTwXPC6RPN4iNF+E0+pc0vno779p+acLLePYf7v34CA0V3Z69CcbNEDGJ+rxxy0yWcg
         X5og==
X-Gm-Message-State: AOJu0YwGkWcS/FQfIZWxfJgHk/nlfWxgq5ekbz0V6ql8CwskEKFaLOWW
	IhfySsfws2iY3GDlelJtgLqzXRHPvJ6CXLtuOSE2w0pW4Na0tfdZ18inrb9IAotwK65jYvLWBil
	bpunTjuNSUh37xdmt/Oh3qggB4gq2zKN8BEr7PABp+tnXLL6lBj6gVt5wHl/ue6EwvbmiIVxatY
	LXkOGjjqYq9yuvb9wII3obMLpRh3s=
X-Google-Smtp-Source: AGHT+IErPkanCpLWOqYLSbyIeNz8iDynw1uLoROXeFLWbPo52Kkfbz3Q5bFY/ZB2xyO+XC+ibLzinwNStA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:d50d:0:b0:618:66ef:b215 with SMTP id
 i13-20020a81d50d000000b0061866efb215mr3296710ywj.2.1713261405293; Tue, 16 Apr
 2024 02:56:45 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:53 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-3-tabba@google.com>
Subject: [PATCH v2 02/47] KVM: arm64: Do not re-initialize the KVM lock
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
2.44.0.683.g7961c838ac-goog

