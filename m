Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203AF4DEC3D
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009290; cv=none; b=MLkrzvOEsx8W46NYtYx1EQ6SJj4uSY/4nu8GtRaipPajcNmPk6YvjcXu3zLfaEg2At7sVZvmdfCY4D/BGj1PIv5wwRnIKkre8LTYR6jh2TAGWzakvWDQtqRVuBlYpDevfGX1HiQmy6k0xhDOOtsbIzv9aeyydE2A0IMLWBILNcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009290; c=relaxed/simple;
	bh=Tv2EYCjkKjWE0I+S4Qhzl4FRcnMQDBTtZC0liA4U2PE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VNqwWIn3KTIs7wYMwC9I9NGKq88zGXhP+PIOaPoUI4DCBoHmRx9DcTZkFLrzjFByWaLAC9/DhcMe+V/H+dx9/+bDvb+nRr0eVZs1azREAowAsipPc3wpUpFAEOfsg+BXZtIu6lvUUvBNc52RXfLYVcf/uK/G/09l+o5+O2qEQkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G/smAhAH; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G/smAhAH"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so23628485e9.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790009287; x=1790614087; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FMNXFwmnx5s7vUZ96ZeGip3cvNMdnWK8inpODzkfR5o=;
        b=G/smAhAHzVbpOoxxlJ2dJaUZfkkAo9C6ebl+h9QN79mMlYsqegBpm6nbQN2GO2dn3O
         wYRWYfRtqoQWpVNseU9iqkZqsxjgGUi0FQD6lDF7phrLBz3i1Cpf+VVAVqj4Kwqzq1gf
         HrHiJBaoOgoQS6WJfcC46B26AyDsH/9VQwXf1lIG80UamISBAVTKNkvS9h0jdiRXU6v7
         vvPBiXERNYVPGdL4gBNSIzgNI1rZoY48ZrDgHfX1JTMmSBHVCrUZX483jJyBQ7Xwtd4g
         hVltwaxgvUgBuLWrjvk4YG4os8Pawf4V5y6yUv1lcjOjjnbO0M3OsQys371x32uiHiUP
         GYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790009287; x=1790614087;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FMNXFwmnx5s7vUZ96ZeGip3cvNMdnWK8inpODzkfR5o=;
        b=vOrMlCr0IeqUBc3mmeJo+qDrgOxc5TRxrEqPq+w1LMV47yTV1vJlAjzipBX2RD//lq
         3UjCSm4tKdQWA1tk/7zFlEmuJ3zPHjGYlFHDs4mQ5kRjY3A5iM44Vlspb5S2ULTQQkBm
         Dj18vaJ95yzPJbzeTYiG5ntyi8gPBcdWkVm4Mn1K3Q4bcSzg2VfphcTOyFDnkoSjlszg
         pVTMilwZgakDOadXOAYpozBraPvISC/wOdVoTUzKxtQ/km4p6Huy32RQop1wdbizR4bv
         qY/i7YCFyQXkBhGLhX43Gloap+AG+zR/2/DL26kkMLzTXeJA5V03n2CXU15dH0orvSnr
         XDew==
X-Forwarded-Encrypted: i=1; AKwUvBz1EOhUV/3RYiE64nALsRfU5EBrofaF3zVgpIIcki4lTUDIjNqISR8y03+YjQJywsjNjFvUhw0=@lists.linux.dev
X-Gm-Message-State: AFuF++nIGCnEXRqeFCelkk/17Arnl1G5tHzh0R/zvRGcm+L8Uj/9BkDZ
	WoWRW0fzHWU7czM5ZcjNSuZQm8uIrpB0vVFDheEVswxrOMwFJMBNuNYeilyNn5mz8+2CVo1zgBb
	xZTVybmwE9/qJ59rkQjxHiRvqLQ==
X-Received: from wmber9.prod.google.com ([2002:a05:600c:84c9:b0:499:b8f0:3186])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:314a:b0:49f:ce73:7aa with SMTP id 5b1f17b1804b1-49fce730865mr103151975e9.35.1790009286746;
 Mon, 21 Sep 2026 09:48:06 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:47:47 +0000
In-Reply-To: <20260921164748.2958578-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260921164748.2958578-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921164748.2958578-2-snehalreddy@google.com>
Subject: [PATCH 1/2] firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2 function ID
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

FF-A v1.3 ALP5 (DEN0140 rev J) introduces the optional FFA_MEM_RECLAIM2
(0xC4000091) ABI, which enables an Owner to reclaim exclusive access to
a subset of pages of a memory region without requiring the Relayer to
maintain intermediate transaction state.

Add the FFA_FN64_MEM_RECLAIM2 function ID definition to arm_ffa.h.

Link: https://support.arm.com/documentation/den0140/j
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
 include/linux/arm_ffa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e71d83ee0aef..c78cfd72832a 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -78,6 +78,7 @@
 #define FFA_EL3_INTR_HANDLE		FFA_SMC_32(0x8C)
 #define FFA_MSG_SEND_DIRECT_REQ2	FFA_SMC_64(0x8D)
 #define FFA_MSG_SEND_DIRECT_RESP2	FFA_SMC_64(0x8E)
+#define FFA_FN64_MEM_RECLAIM2		FFA_SMC_64(0x91)
 
 /*
  * For some calls it is necessary to use SMC64 to pass or return 64-bit values.
-- 
2.55.0.1082.g2b9226bbc0-goog

