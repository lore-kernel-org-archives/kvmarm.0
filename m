Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32D0137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561013; cv=none; b=DJ/zpNd77GFFUHZxWx+WDhsrZ9tKOckQYTasZ4ffh3D2+L2e/2EqK3IwEsRCT9DaFQjiVREtSEW2HnP2znlZlo84fbeTMc/tbry9Z6P6K4Djx4dZrREQnity4MPsYdwoTDiFhnrxCDJHypCz/Mqru0xqaGVi/FINfK0D3CBHUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561013; c=relaxed/simple;
	bh=8gflj1TWlX68dmE+H51qQmeohIybi38znXE4ID0McJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K/Zd/p5yQUOMNHfddtE3csbCGs3RWa2PpRjkZx0KffAmCohNNs6iD4vdfXQUyJS8QBWWlPxtln6zvapLjJg3+HCFTTfkUvRZm/ULv6qaOcFU6svNJArCSBv/QIr6jMcuy8IQtgrFRJMqS/JcfRw2sBaY5n/fXv7rAxnjBJadkSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YM/NyHfv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YM/NyHfv"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609fe93b5cfso1583917b3.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561011; x=1712165811; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9yxmAcqnVJrNUSHYaVuBiLQ6RfheBP2RZtn05Hb/Og=;
        b=YM/NyHfvTVGMGhut5COXNRtdverjI/+dYEsyTEmK3nt012TZiUk0R+tpdyOhARL1dl
         7dYChK6WjwqPQPk9t3NpqTM2C+IimIUdLsnWGMIuQJ68yLiffkoCP7pGXetBqx4EjMhQ
         i7rvv6TdW7Fl8cxPfhzuIfKbal2SWabpZGuvalTh40YUf+7KBBsR5BJXQyNPpgFgQr8C
         npDtPQq8FEwiQml3LRdohiGraJQm+edNTcbhbjNSJE8qhbd6rIQ0w2jl5pb1Ju86njfZ
         4OYwwPvurw7Uq9X5XrWZK1txhi3N2fCdWkU0+epHTkugxfNw6Nam40/BpvZeeIBI3HEn
         xgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561011; x=1712165811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9yxmAcqnVJrNUSHYaVuBiLQ6RfheBP2RZtn05Hb/Og=;
        b=nynnSmrdqRyH4q5tRnHBcGKVyaPEYnrc83bHxWb3jTCyTSMpSMQwmXhtgyprO8Nvwo
         t+3L28LxN4u5xvuYRl/zpobupD6VdENSzrRytebsCIR2WM1JHjz8VjU1TEAxhaCw1o4g
         vdXloEFKwKESpnjwhR3UGCd0ywdg7EUXDPEa/J80zfsp+imfDHrXHh9yEBcx1fAgNn+L
         3KqgBxPLfO4YSKPjQV++L5CjTfi6g2L42RAZQktHtS7FcUdnrrtrPLJGgdTAXCup+m3N
         wMllgsNuxytH8y5hFyha1kca9dM88S9+xsgimC1isZPbnPr0G5WfocGAEy+VgJ5qjmyu
         DoTA==
X-Gm-Message-State: AOJu0YyL9FktOuPTXsy7KQkjC78lymjjY346jgWKbWjf8eh/Gd86oJaX
	OVmS0LhrAWZ4bC5QJUeDhuXCzTWvfI51bEQL0BSKAFRSXA8BiWp5DZVeDcWlwl2M+bk2rEsUX4v
	XfCJ/rwZXOEdD0pv5hnmk/3BV+mLbRUKaaLbm31Owmck9pPKuGzIbUMHCsH83D0kq97Vl/mHOtp
	xzTCy0XV309poSwzgZfWAVG4IJ4Fo=
X-Google-Smtp-Source: AGHT+IH/GnH6sUQfjG0op4AJWtA6hmqiAN3+7QZPqX2vZlVg9ITRRq9X7r/duTw1I26S8iTS0OHnQw0Mwg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:a192:0:b0:60d:47bf:235a with SMTP id
 y140-20020a81a192000000b0060d47bf235amr50325ywg.5.1711561011072; Wed, 27 Mar
 2024 10:36:51 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:19 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-33-tabba@google.com>
Subject: [PATCH v1 32/44] KVM: arm64: Prevent kmemleak from accessing .hyp.data
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

We've added a .data section for the hypervisor, which kmemleak is
eager to parse. This clearly doesn't go well, so add the section
to kmemleak's block list.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b7be96a53597..a0af0926d9f8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -259,6 +259,7 @@ static int __init finalize_pkvm(void)
 	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__hyp_rodata_start, __hyp_rodata_end - __hyp_rodata_start);
 	kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
 
 	ret = pkvm_drop_host_privileges();
-- 
2.44.0.478.gd926399ef9-goog

