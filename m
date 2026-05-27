Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACFB42983C
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894178; cv=none; b=CgsZESlU6E4G9r5KCvncyIaZVwcHLUSo6BG1IGswyPvndmQk3Cb6j3wNzfM1Zc4ho3Bk8auhaP6wOrE9Yge2/ptqZpXSvRpP+TcL3dH052itwhX5wPCvENaeIRSFKWT16o0acIQiHhc58HklPDO0jjKTbkUsI1Vrwr5/yhWyZOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894178; c=relaxed/simple;
	bh=SP4Kec8y+oWOlOQeZ//P8sSlKwGT5+/gmSM055b4H6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A5nGeTrzeqNXsG5ksvoi0SOt85sUBMsDCcmmMQnevIcFJyaginPgDuxvME+mCTFSSv9JMUFksh3xlANNFSFIEdLoSoQpPoIWCTx8RE6RIty9ZChXLiinVlvbWbqKndJ4OUJnZxX/5LC9lnXitMNtPoA59PMJcrQIzpZ+3xdoPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o508G3LR; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o508G3LR"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6872faa5ec6so6968482a12.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894168; x=1780498968; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwo4Qh0di/1vFA0Eu7i+PSEhw4tHDX1V0gCvzn+6kjI=;
        b=o508G3LRmZ8g3mXFcphuspmikPYW5/Apthepn6SyP+dlVf0P6kWoL4jn/i1VinbBaI
         eJNIe5oPHrmeVOUCGBfxiExwvw7rUxnUkeZCt14PkxTI50Z7jeCdiU2etYijbhsYD3Mt
         uyANJgb9HRlDnDKZ950qfxxw9hIJQS/ppQ92QaGLRPk2UK1zUZ0yVBtSLr9tCzSncP50
         oHzmMBAog+aJ12sHTbd3aWzzDiOnD908YmS8EKNIGZQQ8NwYvxYDFBUsa9tN0czW1MW5
         VtF00HafVQuvtyEXF9hqfQ3n3F3k7LUQSpFYHLj8jzLL3cq/ljaF9heGonb7jP6Wu5nh
         +Uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894168; x=1780498968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwo4Qh0di/1vFA0Eu7i+PSEhw4tHDX1V0gCvzn+6kjI=;
        b=JuVOSvghpCsYsh1qNcRzTy41zUADxvYKvhREL7V7woj/8utbeQytmsNoTQidwRRFcS
         vT49Y7nzH3PpzScXBb3ddtgL8Cjw9IkjWvOh4wQpegt0hZsCSf4f937AJm/cqj93FxOB
         CnlFMMZQuL+bOYjttjz9jLFqf62t/helulYWGyWxplTgOquthpJRZPI0UsINMzfGVnkd
         TSMzKZZXKFcax0wBme6qa32xpi3NBhiKiC2iwZSlHaqyd7Nsvkoj9IpscEPzUCSV/1Z6
         Oo/tGiVMpTWXvcw0hT4+LgXCyoqIYmiVReSNpeEc5GNuI4htWZzswBV3QHaXVajq0efr
         DMUA==
X-Forwarded-Encrypted: i=1; AFNElJ/A2rRY+0mPgnoCaeUHlNzIDGMjY1TuH8Hf06mqPYdviEpSFkkuptzmZEBynP8KxiG7T9how6k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIU77OpuM2LwIHQTZUj628bI0vrxRTfApiuQ1ougfWfWGPmQlv
	wlApdsOSc2VwSde859Iw/HJS/MYMByLJDkrazvTmdpN5ZbsgKbmSMUENhJYk5AHWSxmMlyE1RwX
	RProDF7EEXze06g==
X-Received: from edyd3.prod.google.com ([2002:a05:6402:783:b0:688:c574:279d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a51b:20b0:689:6c2e:6cce with SMTP id 4fb4d7f45d1cf-6896c2e6e11mr5575010a12.2.1779894167979;
 Wed, 27 May 2026 08:02:47 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:36 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-7-smostafa@google.com>
Subject: [PATCH v6 6/6] KVM: arm64: Ensure FFA ranges are page aligned
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At the moment we only check that the size of the range is page
aligned, and truncate the address to the page boundary.
This make an assumption that TZ will do the same.

However, it might decide to use the extra offset of the neighbour
page at the end, which is valid under FFA if NS is using larger
page size.

Harden this check by also checking that the base address is aligned
and reject it otherwise.

Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a12e01883314..daf0e328c847 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
@@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
-- 
2.54.0.746.g67dd491aae-goog

