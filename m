Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006F3EC2E6
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780416267; cv=none; b=CJAnzhfpZPs7s4iDmtvY6OxNs97uljHzoMYRoAYGjZO2T9cu4vjvGxfMvkj741JqoAadnYlkZH4lu5JA4eSYVbHPzbl4urLo5GM7Ajcdry0D/pbANUTXGEnHKNZnmDx+3U9dXHkMY89Iq3aWUnH+0SV8ECW1WJSW6uNrQk+rqGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780416267; c=relaxed/simple;
	bh=CgUR528ltaPd7rr9XGuU8qxQxZkouETPRzdIsLLIalI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=a/1YnD47NJEeJCRlXWDOUbbyyEKNG4p9alrPTr6ZlvaKSoESevS8pHaFnOpEVCWdoJLTfsFniIjkLAJNw4PdlZIbuxlQumM1G3ih/rRNXuQarCgTRw4NO1zfCFlqCYqdmHrOBT0bX3Exb49nrLH/8A/tti+0PHbIi/3QskA6Ejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JA78ITij; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JA78ITij"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0c2a68d01so17584795ad.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Jun 2026 09:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780416265; x=1781021065; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CPM66VcrINL92Jo5ORupc7PN6tPDPcidTQjTGXaIkdE=;
        b=JA78ITijdWL2h1l3j3WzweJ6xBnNuPVbxhH4EXRao5sMRvKNHfvBC0d9XEs6i3kyK4
         Iid+NoNuY7mU25YXGxGbpZR5taYYr0zSKvsuS0IpMZRSGudFlf1ZhzyT2iWPF9+Wlgnj
         5FRtOic+tGTVQJIjcpJoyPqr3LCUlPmdxrQFhdovLaOZ5Nmsi5zhK0Qwx4S7Z9wFVgwH
         y1QEQaK3plNHKRgXYAT1MJ2Zk25fP5WjrR19Ii1ftdTztZsvtHFipDajsHaE+HQb+4SJ
         PtXwIG/xDUHidzvifQwoFXIyV6T/0OuDk30FQy5e32Cfu9SgxrU9wwH6Km/GaOscm5a6
         TTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780416265; x=1781021065;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPM66VcrINL92Jo5ORupc7PN6tPDPcidTQjTGXaIkdE=;
        b=As2dqrbczuPbymacSKNu7X9yqPuSKrjo+R2xHtd0g3ufkV5G9lD02S7OBU3oTEjIf8
         giFpRpDmJkxHb48SqLBRFck6Plw1/h851PltAv1TAKLouTWtRH3iYnW0+XnBFWFjA/Zl
         HS9S5UED5aTXwVj288vipPWcUt58SDSDHLJUfenX+UHpp58eJNumH8F5POfsXldwXRTs
         Uk7c3Q2tjutRCvM4PGudoEbxQGL0vpVdBMTjb7UCc5tyetT/pvWOxMCisyjQSRS8oNLQ
         ehKv9XKktiZkcmktx43uUVN5ygeCQeZMQtS0dwl04thSTKAPD8ZRwpo23INORQaB7oeE
         oCfQ==
X-Forwarded-Encrypted: i=1; AFNElJ9JwwzX05mjjVlGND6lqTwxttQZ0zox8PdVNQBL5mnenVi04vwFJi758lN9spe+PMXGKaMhMNA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy1MsloOKiltVr5fUsW9difFIABiFjgxiVVCe6z1FyfMQKf72T
	9oDyfi9rSJerVz+6Nm8ILUDR/CELm/ncrTALDRp2/jKNxMn+2oio0qmS
X-Gm-Gg: Acq92OFQV5br8C/RB4h3nsNpos5NKMCsc3eLmoBNLof1LgOVyRCAxYEW1fWbv0ialkH
	s4OS6fqt6AmGil0DrmVOBrJTMPu5a8auEjRaxTKrcNnm3G+jiuC0YQDBbTmn47iDM6j5HTr9R63
	0NTW7+Wwb51cFAHLHm6oPxYHnM9COqDKiTJ9ao+qbiH9apGnhW6xy+B/JiR2RwWGggK0QqBEV7O
	Q3HXOMUBrPBxoYt+3mtfeXM2LURjKUyBK/U1MwaaKW9TLWarYDK609VxvvUVZoUa8Z7iq3eG0MF
	ojAp9QHvMzEejlUJBuCqWjoo+QK9g3cLRWLu+oHjUPjqgwrZyorYg/455QPI6cSLX+MD64hgXtV
	Avm3H46cWKO8Cxgo2mGt9tVxCTtxAWFWRwh4Oe0uB9evLO3CVkQvlcY3gxMCpUc2ptvlcI86QqL
	zP87I26ERkAlKfABdAYjpPUxeQXs3UYsvxZed8p7rX8A/iBEcPgszORg==
X-Received: by 2002:a17:903:4b07:b0:2c0:b6c7:2273 with SMTP id d9443c01a7336-2c0b6c7267emr145511365ad.3.1780416265235;
        Tue, 02 Jun 2026 09:04:25 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c2381bsm140818235ad.62.2026.06.02.09.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 09:04:24 -0700 (PDT)
Date: Wed, 3 Jun 2026 01:04:20 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	stable@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: Take the SRCU lock for page table walks in fault
 injection and AT emulation
Message-ID: <ah7_BAAzHggzdZeI@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

inject_abt64() rewalks the guest stage-1 page tables via
__kvm_find_s1_desc_level() when injecting an abort for a failed S1PTW, and
__kvm_at_s12() calls kvm_walk_nested_s2() to perform the stage-2
translation. Both walks reference kvm->memslots through kvm_read_guest(),
which reads the descriptors, and __kvm_at_swap_desc(), which updates the
access flag, so they must run while holding the kvm->srcu read lock.
__kvm_at_swap_desc() asserts srcu_read_lock_held() on entry, and the other
callers of these walks, handle_at_slow(), kvm_translate_vncr() and
kvm_handle_guest_abort(), take the lock before calling them.

inject_abt64() is reached from the SEA and size fault injection paths,
which run before kvm_handle_guest_abort() takes the lock, and
__kvm_at_s12() does not hold the lock across the stage-2 walk. Take the
kvm->srcu read lock with guard(srcu) in both places so that it is held for
the duration of the walk.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/at.c           | 3 +++
 arch/arm64/kvm/inject_fault.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9f8f0ae8e86e..eb334a1c2672 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1569,6 +1569,9 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
+
+	guard(srcu)(&vcpu->kvm->srcu);
+
 	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return ret;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 89982bd3345f..868895ed0930 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -121,6 +121,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 		if (hpfar == INVALID_GPA)
 			return;
 
+		guard(srcu)(&vcpu->kvm->srcu);
+
 		ret = __kvm_find_s1_desc_level(vcpu, addr, hpfar, &level);
 		if (ret)
 			return;
-- 
2.43.0

