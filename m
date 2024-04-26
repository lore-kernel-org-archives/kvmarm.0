Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755514430D
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128599; cv=none; b=NpXwdIxzBDniFWNnxWHLNygB7hF699CKwEU1dm7WwsrYvsdWwymzqUE270MJbpnKNQXf5aAhs0MqseqOsCyp4XAL9MQKX2t0RmhkSdcVxwR5sOUY3P8LTRINEstONqh1zWViJgVDDh3wV46ylu+BuTu/A3V9AI8yt2vgZhAw7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128599; c=relaxed/simple;
	bh=3TP2uHC4mQRfabmD1+dpyNDOj8vwZ4B4oSRmGaqT+Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hShfp56HWObpX7AI0HU0WrnhGtoHimstsoKVtpZUCaW+0OY8tlBHh+EPyQSO6CftsLGbykeGMXemGnmj++T400FGjvB77oq3wN6U6fGGr/0IN4qSxqe7HYjO6WXOl4OUdTawmnzMfEqV1DIhD99+Fkh9LLREgeI37nkHzXiymME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YTvViA2s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YTvViA2s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AySb1TlhVPPrqTACK8fU1SzEo7gL7MLhlk77wlxrmQo=;
	b=YTvViA2s24UEmr1Nct7zx/TTqq6Sw5L3RgDe++ea3bDT9hLoGD/sso1F3nfTdXKGsAS91C
	A0f80Lw4JuDaZTnEjFZ0+Znqy50ttREFHz6SomAorEI3g3OGrmT8Mgqn7cDQ8a0i4U2UpO
	aotd2eJeREOoUf19lF5W4xpytDef1yc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-cr60nUyiPyqv6v2lnFxWtw-1; Fri, 26 Apr 2024 06:49:55 -0400
X-MC-Unique: cr60nUyiPyqv6v2lnFxWtw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c61104bebfso2591429b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128594; x=1714733394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AySb1TlhVPPrqTACK8fU1SzEo7gL7MLhlk77wlxrmQo=;
        b=Kswekm9390qZsgZxZJrpE7FMZ3yBH7HNVTpO8mloBmlP0IcaivDOQvvUgz4h3O0Zw9
         xbcS3UYm8X1YdUX/5LDosVHerPZRcPNi7zNSXbZCep2iDVsM3f6jWLJJYhVRguMoil6k
         VNKRMctFVa5NSVDXn1G4+yatlBcRTuEdG0niLpZ7FdBi8QZpf4hJQnSQ6hC2eLh/3wqJ
         xRdA99naf+owYtKM4f3J1U+/zxZMIFcKOaatL5WElq7D/NLkz4rQyc1Gm/sYvWScV/Cz
         /z2SZmuAs++P9GjttzzlsAOuAZ3ZJyxOWzQHkAlZ/bmjgeFuqagHn97qOhba9mjXg43J
         nmew==
X-Forwarded-Encrypted: i=1; AJvYcCX0kHP6I0Zcu+Vz3KeLNYD9Cmc4VDUiiSDNIPe89kwwSXrY07cgMCMaoSW4dFsbo8j86GvfMtAxsc7TwefXUDf31YtNcTnE
X-Gm-Message-State: AOJu0YyH6vQ4TbwM89qno0WjqsZL29WE5+DoLPW3Ywa8T4k+KcjxkNLj
	h28yBSDNGWIQsvqK9mfFJZpwrr3IAo3TGNfmvL4t0Uw6QjTYQqzrDhYpYMk52z9/vd2XzbHm4A0
	RdJ089C3A75ObR7Hje1Z77b1sC8Aaf/FIX2Z3ZGqjyw0J7nzUQqLQ9g==
X-Received: by 2002:a05:6808:bc8:b0:3c6:f7b1:b228 with SMTP id o8-20020a0568080bc800b003c6f7b1b228mr2723682oik.31.1714128594185;
        Fri, 26 Apr 2024 03:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZsGfT69zsmTCVgTcj+/En2dvpkEVqYiuQXZdoAX6RGBoDOOIyO2jwTtLnAHh1VuafDtHvkA==
X-Received: by 2002:a05:6808:bc8:b0:3c6:f7b1:b228 with SMTP id o8-20020a0568080bc800b003c6f7b1b228mr2723673oik.31.1714128593932;
        Fri, 26 Apr 2024 03:49:53 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:49:53 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/6] KVM: arm64: emulation for CTR_EL0
Date: Fri, 26 Apr 2024 12:49:44 +0200
Message-ID: <20240426104950.7382-1-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Hej folks,

I'm looking into supporting migration between 2 Ampere Altra (Max)
machines (using Neoverse-N1). They are almost identical regarding
their feature id register state except for CTR_EL0.DIC which is set
on one machine but not the other.

CTR_EL0 is currently marked as invariant and migrating a VM between
those 2 machines using qemu fails.

Changes RFC [0] -> V1 [1]:
 * store the emulated value per VM and not per VCPU
 * allow to change more values than just the DIC bit
 * only trap guest access to that reg when needed
 * make sure to not present the guest with an inconsistent register set
Changes V1 -> V2:
 * implemented Marc's suggestion for keeping registers consistent while
   not breaking userspace ABI / expectations (I hope correctly this time)
 * keep the shadowed value valid at all time
 * unify the code to setup traps

Note:
* in order to switch off CTR_EL0.IDC userspace first has to set up
  CLIDR_EL1 accordingly
* reading CCSIDR before and after changing the cache size in CTR_EL0
  could result in different values (but only if CCSIDR was not changed
  from the generated value)
* I'll prepare a testcase for the next revision

Thanks,
Sebastian

[0]: https://lore.kernel.org/all/20240318111636.10613-1-sebott@redhat.com/T/
[1]: https://lore.kernel.org/lkml/20240405120108.11844-1-sebott@redhat.com/T/

Sebastian Ott (6):
  KVM: arm64: change return value in arm64_check_features()
  KVM: arm64: unify trap setup code
  KVM: arm64: maintain per VM value for CTR_EL0
  KVM: arm64: add emulation for CTR_EL0 register
  KVM: arm64: show writable masks for feature registers
  KVM: arm64: rename functions for invariant sys regs

 arch/arm64/include/asm/kvm_emulate.h |  37 -----
 arch/arm64/include/asm/kvm_host.h    |   4 +-
 arch/arm64/kvm/arm.c                 |   3 +-
 arch/arm64/kvm/sys_regs.c            | 225 ++++++++++++++++++++-------
 4 files changed, 173 insertions(+), 96 deletions(-)

-- 
2.42.0

