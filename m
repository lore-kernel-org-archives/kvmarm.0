Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32D5226CFE
	for <kvmarm@lists.linux.dev>; Sun,  7 Jun 2026 08:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780821839; cv=none; b=PsHbxFoBIUDQDJQhbr6OiMI7Oc1Tp3SIqRQ8DNI3nBEFzmYiVk5t8hOYEptrH+QPzMeuhePBmsaSgxjhr69+plr9UR1oSEUNy+c/aZCGFl4clULpQtyvayslzuNN3KY7qvcJINMKKxlBG0cGq1+ri2d+0PKLKuxOuYdU4mVvL0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780821839; c=relaxed/simple;
	bh=QkkdtfffhCW83bbIECO9svPMXL3gFi5LIcYlxuz1qp8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JFRyWUJ9VVHc68oH7ALaEwTbHjzO1YoAeAufBjyyjK0o+T0sGXxgRdVarvvy/3Bs7Qr+UmqF+D88JL00K09Oy+43sD/EuU1+fjzYvh8tNMSXe9El8WFEVpVHijQj7JctCL9/ijVwu5Gt/E8LcxgHzH0INlMAEPOl6Ge1i+OvyS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFHR1uPv; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFHR1uPv"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c858dc05ee3so2084282a12.2
        for <kvmarm@lists.linux.dev>; Sun, 07 Jun 2026 01:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780821837; x=1781426637; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I12sMqC6/04DUeHmMWlOOJ5aYC5HrERy4a3xEEa3sfM=;
        b=QFHR1uPvFunhHlbUEcwLMa1loI/9NbbhDFFQXrjoQJkbGO9DHIjZbDNuzWAn6g6lyS
         HYA2auGnQIhCn8EiYkFhdNZxUKoqS8/ifTjm2gK2Iw9y0Ly2Wc7tsrq3uGXzmTzP6FSi
         +WF88LrE3xVBIPEH1HV8OkCjBkELJJGWzmRt+KBMmGhbUcTHfn1glWtTK68xAqIrTLs2
         rde+lfG21LOFUnhesa6LMzHPAMdamh4DcSJhQ9ssN/GAPgMViQMeNlogPLB3+7ge7iUh
         5AgyPmDwP6hX/4v2PspJ6HRagyBpHUb3l2NFawyQI9DJP6c9b20CM0oI4APmtgJRGPGS
         HFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780821837; x=1781426637;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I12sMqC6/04DUeHmMWlOOJ5aYC5HrERy4a3xEEa3sfM=;
        b=Cz65AuzIbDhfVhn0a9iozat5JckX05Lindyqht43teF+Wk1weuB7xDSW8lxXg49MrN
         ruzrYCaT838mBC2o7B14yzkmM23Z+SaBMRzCJ5tDS4+oRWe8dUkSYq5Y7nfkz59MDE8d
         Hd/814z8dnm3a8zRU/P4ozSe9F7XKt/b4zljbjKvBi9clplK3YhMX2LLDgJ9BRb+HyFa
         met0Q6m+vMwzwWRJtJt0goesiThQNNiyTrF2AyAfnGiUd+fQMQGOj0jHB8POjoeAX7G7
         PfwMchJeRJ2AAcV0cyje+kICks5pLXxDAwyZmfJh6n8+L7yXbyW26B8nePxcE9Di6X36
         K1bw==
X-Forwarded-Encrypted: i=1; AFNElJ/Fd0P4I5j9xNR2dwBR8tW2WuDBNg5upLmOWwiBcMl/Bn9zlP+u80oI8X1SVEV88u7Rbi2Q6gc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6iWWvd57vaMskDcnBZEQURi4zpsNWFXPZRVLjfIW91AVicvvu
	4sw6fyyMThbdZ/LAGd20Bw7SUGjF1mY4hnhCeLZfeuI7EFoUm6kd6hUh
X-Gm-Gg: Acq92OFThn7fMyBAbbDMcSN3/SfH1X6glmpZZ2G9dPXUWlFkPYShgAe/krgThtO1MKV
	X944v4vmCx1zNtLrMzqoo7eC7D0zN/2JVFOMVbH39+L1JFysBCExeIvEIluyAOCVy2QiRI5pn+g
	+GjBuPIykzUKhm68Z+abEd2aE9xHxq7T7jVT0m07/qEQZYMF1SUoIdpSw91UPUm+YInazvG6vzZ
	ad18z4pT0EbCi0PBGETlVEUYfNqVYgGi8Wb6h9I0cr5dd0gkxr7NoIoZktQ3zrd5vj6v6qgQd6m
	K0y89Q/gfNtwniAfPzGO6UnNbdtEG15RfP3jmLHVJcaqNwd1C+fFPYqiBSwWwVJUTawqR6DRBJn
	V0DEm76lOEYsJ9/ZIuBiMSyyjcbxQMEpQ3hohcwmFn3olZximv2JxluKm/aZVzdZfAukNrObkZf
	48XVrpY7+XZIXY0l8woICRp6FOJp8RTi8gLUy7iTjzeCTpvEibKuE/GQ==
X-Received: by 2002:a05:6a21:4d92:b0:3b4:6c68:b100 with SMTP id adf61e73a8af0-3b4ccdb61f6mr12356449637.19.1780821837181;
        Sun, 07 Jun 2026 01:43:57 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85deeb2bdesm12177119a12.0.2026.06.07.01.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 01:43:56 -0700 (PDT)
Date: Sun, 7 Jun 2026 17:43:53 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: nv: Skip vCPUs without a pseudo-TLB in
 invalidate_vncr_va()
Message-ID: <aiUvSbrWndQeUPc8@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

vncr_tlb is not allocated before a vCPU runs for the first time, so
vcpu->arch.vncr_tlb is NULL for a vCPU that has been created but not yet
run. Code that iterates over every vCPU's pseudo-TLB must skip those.

invalidate_vncr_va() iterates over the vCPUs with kvm_for_each_vcpu() and
dereferences vt->valid without checking whether vncr_tlb is NULL.

While iterating, skip vCPUs whose pseudo-TLB has not been allocated.

Fixes: 4ffa72ad8f37 ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6f7bc9a9992e..063e079d1d1a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -969,6 +969,10 @@ static void invalidate_vncr_va(struct kvm *kvm,
 		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
 		u64 va_start, va_end, va_size;
 
+		/* Skip vCPUs whose pseudo-TLB hasn't been allocated yet */
+		if (!vt)
+			continue;
+
 		if (!vt->valid)
 			continue;
 
-- 
2.43.0

