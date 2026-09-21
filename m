Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0B730568B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999557; cv=none; b=CmsLnLp23bM+YZDYsofdI0MB5BZza1+AqwTjzXvzuS3FwbuY7vef6inx8OTFl79Dgqb5M3tf+NNapepX3YFCkWpE3ZNWbdhHtaJ5axQzorZNA3idfNaJE3wcVoFSVdB2QgiXN+UVOoAML/k4YgAKEFHVo74by8zLyNMIWuzTmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999557; c=relaxed/simple;
	bh=HYGgnNmi3QVtldKOycpSOnTBz70WPgmKQmW8PXNpJz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ch+Q4mkDpIv34OrtL49POeF4zahPKxqlGEttoE5pUbo8ZfrQ3p23tp5YYYKJ4NewdG51CAwR7cVDyTRSBNC+crUFnIyBM4JQcIuoQc/fgrfWQUXxpk0aqKnJ9pmjYIe6jyLIwMRmvu2ZDkZ9x5c2iIZJIVbAirIQLSHYo72nUb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A9Gq5bSm; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A9Gq5bSm"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc489e7a701so4499897a12.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789999555; x=1790604355; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kDaByuob3STQywTT3cAOlaBCTEAiWYMVBfjiNkGWQmQ=;
        b=A9Gq5bSm7+t8RnTGoNJDwYiNKBtPVTZ6RAAYMlQxArmzjW9Ir1eyVBEfbm4VS5GFrZ
         N3ii1X5IBRod0GxByMieagUN9TdMbSgrRRKOT8uZtTD1Vi6HtQ8xDxmi9sAMTsUPgnia
         0pawDESnERDHxkHCalkDFbbySX5jhyBxpc1QIpL7EZrAciokJnQhFu5Y5TrY2FQeezCh
         kM6ktRfzH822P1CJgFejfOd+Oby7vSEHcDQHLe/hRwoAiAAom6rTarKbiIiNjCIWWXxy
         jayLGE1EUKnoCe8TZxaE/tJmYO2J13Z9qSi7QYqetb2QoZklsySnCR09HmvX4F4TTs6n
         vJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999555; x=1790604355;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kDaByuob3STQywTT3cAOlaBCTEAiWYMVBfjiNkGWQmQ=;
        b=Aa8daaPvByc21bUX3PtSEWsp5/ZvCQYvpOwa7ZPxKxlOvFUnQV2wImlhkcGz/KUjIW
         t+CuVwWMS1eE3hsikV+J3VBUCcEjSw9z1F5VN7Il9P2dtdtCBKBgY536Zn58mKOGW2X8
         rJJ6Z8mZR9eIiiXLUYn6qwTsbG919JIiaVqCW9Db9tcsPr21WZeQOaHuFJ6Tcmcjti1O
         Oe9oZpOO40Fz/Yp4McAeZKvrpNmFd37qTaGFlm4Zj0K7En7pwFYEh+wGKusSW0h78oCp
         BS9Jrn5d8ZRDDYkdgeen6utXFJSi3WKlpAsqTZAPpy/NMRPGgUi0HNi2P4ohpgWUGoRx
         u5ag==
X-Forwarded-Encrypted: i=1; AKwUvBzdkP1Lcdw9MnrIEgJ/e5QEz6MsHHqtwM77Q1tCX2SwEfiqidkTxHZ3lehPj2dNpGcfNnO9a4I=@lists.linux.dev
X-Gm-Message-State: AFuF++n9FxBh1Bi7dnpo3vT9GpENc5b2fqJAsgD8JnlmY95jT2AFD8ef
	JBVebMe5ZbrL0p0/MrHarJF+CnYja1QFQZR2tFgK3nyrJN/5EzpZYUoRyhJbR6a10AAZ6tBkhO5
	INvHKMg==
X-Received: from pgdt6.prod.google.com ([2002:a05:6a02:3006:b0:cc4:e953:2e4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d07:b0:3d3:aec2:4dcd
 with SMTP id adf61e73a8af0-3dd8c48ee7amr18530514637.25.1789999555175; Mon, 21
 Sep 2026 07:05:55 -0700 (PDT)
Date: Mon, 21 Sep 2026 07:05:02 -0700
In-Reply-To: <20260806214618.82180-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260806214618.82180-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <178999694044.717318.4471496122366852907.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Aug 2026 14:46:18 -0700, Sean Christopherson wrote:
> Use kvm_test_request() instead of kvm_check_request() when querying
> KVM_REQ_VM_DEAD, i.e. don't clear KVM_REQ_VM_DEAD, as the entire purpose
> of KVM_REQ_VM_DEAD is to prevent the vCPU from enterring the guest ever
> again, even if userspace insists on redoing KVM_RUN.
> 
> Ensuring KVM_REQ_VM_DEAD is never cleared will allow relaxing KVM's rule
> that ioctls can't be invoked on dead VMs, to only disallow ioctls if the
> VM is bugged, i.e. if KVM hit a KVM_BUG_ON().
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
      https://github.com/kvm-x86/linux/commit/8cd280282d12

--
https://github.com/kvm-x86/linux/tree/next
