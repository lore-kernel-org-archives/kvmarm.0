Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC0437419A
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372214; cv=none; b=E1dHAy0TvcmU1Xlu7ISUvDjYVQxdaxtHcnEAU3HHK4Qa/ksi4UUkNJdhaOtkxCD16uG3sgkDyJY8j2KWZO2ZyKsu1jcTpiMFlMrVGhiTYot+/y3OCcbvGmOCD5NFUuUc7QQpi88JrV012j8Gzdo/7Nx0Z+v9YhG9siwAbWS2S1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372214; c=relaxed/simple;
	bh=9Wt0iy5ayw0cQwuJpZ/wnzJmfEyzqf8hdthusy325Pw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B1s1SE3jFPQmNbe++ccjJ6CTFspCAloIlOIEV8XlHuBdVWJ9S1w3DSjxwJys5uRvqie8oxqY3cl1nyVy3nZMPhSqpgn0bwwLQJULE7tW8mh/eIv53eqXDxpmtLa0IQ8waGBWxtOTZZz6Vy3conTII1uDfboQX13pSKUJ+PkhwZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OrgOAjkE; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OrgOAjkE"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-671656523efso13560329a12.2
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372211; x=1777977011; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J7c867vhN0NJ0ysluuN7kPjni8MsLU+yiUrh20mCAzU=;
        b=OrgOAjkEhiqomQ/3VDB/D9qNK3NGPjpuzgGPAPOW5dljm/LqrcrH8ncUBvC/q7/3/N
         EDZ21tXFcOf7OAdPRy7R+X2Q6vpCvrOUl6+gDpo9DuSOF2Qh9I0X32BsyzCq6U8MSThI
         jcqqAoBJFgOHF3+RB+pq7D4iaYpseYs2jJvCJPMpPSJTJPbm/MldrDTyQcxPCMxrWZLq
         Q4q/nPwYFX+z0PdYPLkGo9hRtzE66G9w2A7QyD8VCELDPH6C75Ojy3qqlmMBX+wOLivO
         2XgeUOPj2QIXRv5HmISZqpnxjDnd51O470n7j/NZYwEM6uGB4lcqYk4ktzODlTqR6Nzc
         b9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372211; x=1777977011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7c867vhN0NJ0ysluuN7kPjni8MsLU+yiUrh20mCAzU=;
        b=JvDqRc2zkh3m837PNj+SzXMMOUQ6eia7vnqJKWklkOxN+05TQ5wVonFMprQ8CxvGC4
         zkR9ybNFD3FjKKudGAu4m3L0xeBBv92skh+pAzPNVAB9KRMX+zs16a9aMEYr1DQv29MI
         CORd2MLt4YDh2Mj2zcHXiAS5J9+06aLYq4dFgHkCp0+tBJms/CW23GAz3oxMi1C7cEIZ
         LNzBhPMHVC+NHz3gRcqjayZBBY0L2iOS2OjRQxRWlhakp2Ua3Nqsy3JdmdkDvg/Gch7I
         eiDonGN+npaFXq6VXz7JTypO2gWd5BXJJE8YY06R8CA86vufJbaozuzzGkJTQjIqaKKe
         Ivig==
X-Forwarded-Encrypted: i=1; AFNElJ+SCS7lF1kor9F0Ic7pArFrhEltUOTOfBcnOPRTedHpCdRXZQ6eLulJFY2R0dDRt23mpYcY9T4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHo/ScH9n73YRTsG8MbsUlxUP7pz4+jRgRE45XGzr3e+T0Po9e
	U+o5zPZF10e1ftQm7N1Up+0UHJFtPtgldm4WYTcMt5AnM9e4kLs3ffspBXXYj8Ft+ZW5POi0kCQ
	H7Q==
X-Received: from edru26.prod.google.com ([2002:aa7:d55a:0:b0:674:1e56:7dde])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:158d:b0:678:a553:bcf3
 with SMTP id 4fb4d7f45d1cf-679bb0a125bmr1160027a12.21.1777372210503; Tue, 28
 Apr 2026 03:30:10 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:01 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-2-tabba@google.com>
Subject: [PATCH 1/8] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
0487 M.b, EIS is governed by D1.4.2 rule RBBSRF (p. D1-7205) and EOS
by D1.4.4.1 rule RBWCFK (p. D1-7209). D24.2.175 (p. D24-9754):

  - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
    a CSE.
  - FEAT_ExS: the reset value is architecturally UNKNOWN; software
    must set the bit to make the entry/exit a CSE.

INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
MSRs to context-switching system registers (HCR_EL2, HFGxTR_EL2,
HCRX_EL2, ZCR_EL2, CPACR_EL1, CPTR_EL2, SCTLR_EL1, ptrauth keys,
etc.); examples include the activate-traps path,
ptrauth_switch_to_guest, and the FPSIMD trap re-enable in
kvm_hyp_handle_fpsimd. On FEAT_ExS hardware those reliances are not
architecturally backed unless EOS=1 (and, for entry, EIS=1), and
whether they hold today depends on firmware initialisation outside
the kernel's control.

Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
unconditionally CSEs regardless of whether FEAT_ExS is implemented.
This matches the pairing in arch/arm64/kvm/config.c which treats EIS
and EOS together as RES1 under !FEAT_ExS.

INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
very early EL2 init and the EL2 MMU-off transition, neither of which
relies on these bits in the same way.

Fixes: fe2c8d19189e ("KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_EL2_MMU_ON")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 736561480f36..7aa08d59d494 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -844,7 +844,7 @@
 #define INIT_SCTLR_EL2_MMU_ON						\
 	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
 	 SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |		\
-	 SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
+	 SCTLR_ELx_ITFSB | SCTLR_ELx_EIS | SCTLR_ELx_EOS | SCTLR_EL2_RES1)
 
 #define INIT_SCTLR_EL2_MMU_OFF \
 	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
-- 
2.54.0.545.g6539524ca2-goog

