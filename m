Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E30221275
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754568101; cv=none; b=JoEIDCwLnyjMzjELPR7p13LJ3IOAkx7YRcSIOLAvQuxtpHyF+H2V0MqfjstXnVs4IPTwG8sA3SbpMR2/z2jq5Psed093WOYfZGK5rPvuRxLGyzHbloJySVu99KSEjzwVRW2gxWbjvBNUe9FLX0FoeYGu0jreWJUaj3TyAc3o4KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754568101; c=relaxed/simple;
	bh=iLtySnvG1gttOwujmHulupEmNFzFD1J2TWZHp/Qnc3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lakGKjX6jRlHVJz2Kae83q46tGKZtuaILFzyaA9/PL1grEORkGrvzD49MdAwLJEmdLRK3np5KcYJRlyJcgJyQLqtninR6sMT2Viq5aDfaKidggEd3ityplfya7x1WEa3VvjA2lYigXOvEsgJOoAZrhpVfxd2HHZ4wx1KUcmW968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJ1ZaDuE; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJ1ZaDuE"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169cso1036272a12.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Aug 2025 05:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754568097; x=1755172897; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ym8ckk+VrCoktE6lkLMoRO29CSpEB7biJzQ35QJvlbM=;
        b=EJ1ZaDuENZaYQgTS26iLxgzpwL53L3QVXcxhjxnZ/GTg94jOt3msps0v0QvK+vlTgq
         mALxjPBcR/3Wv9OoboFhgQbWLl0ACyN6B23OMfVmnMTiC3V7e2IXx+Wq6ddtppz97xk+
         RSNc1VEoDOzsPd6HyqLH1BcT/HYfs/E1oYOteRO8ZqgLtyCRSuA4dJKOcwkrH44Y9jZj
         S+8bEDkq3ihOW1RD6QCRndgyadXbl9LJFHbg5MaE3ej4WhZC3MO5EUv9UwQ4PwzzUx7e
         o6U9cwecFiq3PCW3VGAtMQERH83TZKAOuWfwbhERoqG0vhj0IVWonJsDdvrb+wIKWA5s
         8yMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754568097; x=1755172897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ym8ckk+VrCoktE6lkLMoRO29CSpEB7biJzQ35QJvlbM=;
        b=QHgC+OmBwkp+O/fogJP36Ryq5DIO3lTu9MyQZ700lKwHhBYZjUVXGMpN8URvD3URKE
         lDOxhSl9zRzjZCyyXC/suxxKt4yIzD3ctIIqfXXeEU5npuzP+9pTYamAeIhZkXc7Tf7N
         Hzp/UImFdTuyi/O8Opz6yxo9RgQGQZ/AtHMiFNakcD7ESTs5R5GZ7YzCHcm7r8IzbhoP
         cTTIjwJajSHMFXPPfLOQggOOM+ir7tt0OWgq0yrvwzcGhzJ89kT708IP4XROTuu5EdAC
         pq1bIj0qoOC5sKnv9EytIdmUOTW3FhdoAm+pA0Z7q63PsEL5uaspfjEyseAX/sHEpMYf
         CKzA==
X-Gm-Message-State: AOJu0Yxc9g+Lm/NiXrakLmQFnhgm79M3fpWvaQ9eGzDSduBWQZ93ITbw
	jHQ0comt/Hlx32RvDXmwVlAjOtRMeHCycOWMo68nGQmY3Wbf/GRxBD/yKO9QzZS7au6x613MS1c
	XqL/+ZekiBZPbxCrs0I1ITj72VmkvUi5sGxOcyKZEbdYiUlPcRIr1bQ4WPkAdid1YXQAUgdQZPk
	2UEZ0jLxnLrRtz4wBTi6PoiM0382Js4pA=
X-Google-Smtp-Source: AGHT+IHCXiYdGkqSZezcMr/5HJ8nW+vXd0I20GHxpc650nk5XAEIKQRYW0qXtNDvRlsqHYqyF+bbLH2eYA==
X-Received: from edss28.prod.google.com ([2002:a50:8d1c:0:b0:608:fc64:b570])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:254d:b0:615:a5f0:26f9
 with SMTP id 4fb4d7f45d1cf-6179614219dmr4720604a12.21.1754568095234; Thu, 07
 Aug 2025 05:01:35 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:01:31 +0100
In-Reply-To: <20250807120133.871892-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250807120133.871892-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250807120133.871892-2-tabba@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since commit 17efc1acee62 ("arm64: Expose AIDR_EL1 via sysfs"), AIDR_EL1
is read early during boot. Therefore, a guest running as a protected VM
will fail to boot because when it attempts to access AIDR_EL1, access to
that register is restricted in pKVM for protected guests.

Similar to how MIDR_EL1 is handled by the host for protected VMs, let
the host handle accesses to AIDR_EL1 as well as REVIDR_EL1. However note
that, unlike MIDR_EL1, AIDR_EL1 and REVIDR_EL1 are trapped by
HCR_EL2.TID1. Therefore, explicitly mark them as handled by the host for
protected VMs. TID1 is always set in pKVM, because it needs to restrict
access to SMIDR_EL1, which is also trapped by that bit.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 1ddd9ed3cbb3..bbd60013cf9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -372,6 +372,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Debug and Trace Registers are restricted. */
 
+	/* Group 1 ID registers */
+	HOST_HANDLED(SYS_REVIDR_EL1),
+
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
 	AARCH32(SYS_ID_PFR0_EL1),
@@ -460,6 +463,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	HOST_HANDLED(SYS_CCSIDR_EL1),
 	HOST_HANDLED(SYS_CLIDR_EL1),
+	HOST_HANDLED(SYS_AIDR_EL1),
 	HOST_HANDLED(SYS_CSSELR_EL1),
 	HOST_HANDLED(SYS_CTR_EL0),
 
-- 
2.50.1.565.gc32cd1483b-goog

