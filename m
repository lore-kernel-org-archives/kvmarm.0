Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD384949F1
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946366; cv=pass; b=XtjjwkdmD2iDVP6ekuAHS9AcEOpBywmAu2pYUdvkA2pvKF2RXgp7pHZgyj3HcqwW4vX5rksMRNongMmpaUdGiXxoOAc5SwB960eSMtU5XdnCyVsjxfs8YbW6yIPAalPdOt2rGqt7d12ksOXJmuHj7qPOYdPOo1EJS2k6FXp6Pho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946366; c=relaxed/simple;
	bh=E3o9mY11vfyNe7daMSPv/Jpy/COQ66uBOFgs4MlwYzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ebPWu5qb4gzuqvERKvP66kwlY6/4n31wOX2R8gvU/7jN0nDjKHAgOlzC+nKM4wm52YtHj1WmmyPeVuWLeJ+aqVvnsrVVF09D+JNcDtz5Tgd7y9gMcZk1uJ3u+xqtOBgiZ3IiijMVACpkoIwr6hmStI+8yjWAUJQ1OP8gzObApkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W2Phv1rM; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W2Phv1rM"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so5729e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 06:05:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790946354; cv=none;
        d=google.com; s=arc-20260327;
        b=eqYMOf0k+Pbps9xIg7HRQoyZ4cNkqN06pS9HrI17wgD7jJ9D+y5zkRFNx8KMGvrzNW
         +MddX9gXAQ5tMTL2v38ZZj8YWN/KAfvXJHDx9+1dKE1yBEvHS10HEcBT32dR7t7NHb8b
         ZGONhl0Qq2+nhtODZwsEC358MOg86mpfKn13LtDKTzVVNXlUa7Cx/utIIelXILmMTtdt
         +mhU0JcLIvu9eXArSumxBiN3efhWi5CiFK4vtUNxKi1K5H0GeW88/T8QNwtHXS9ArdBg
         5q7sxVok0qkoZ2Muff326SDondDw80O9w6PBlj3ikDy74Aui5ptJVVE8vQGyER+H0Yzz
         CenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E3o9mY11vfyNe7daMSPv/Jpy/COQ66uBOFgs4MlwYzE=;
        fh=dS2kYksMedj7UJCO83IE4KCsFp19fqBHjHkcParxBBI=;
        b=Mm8+q4czEV0Bnw4bkLvEF/qsOXXtP7ZvfJ30GGxvsRGL73iNs+EiYIeDZWnqTUCtrH
         e/gpkJR1h1cz6klGie6/pb/7qbvRpRePJVxRwi0bgHHHe1kgEiJFW5vkWZQV8NMXBPkU
         otop82GNdBc95NIYLuLJiIrYJyWKbM9vXglq8GetsV+kBPthTBvbDvmelLMMqNHIieVq
         wDyDus+5FCJSfFGa8jBo9G2OyQqRNxw2X0VFbwEjVGBR5YRoGGsxqnx+G5fkdAXWrJ/1
         fVAfeN8SnmmmLANPnnCUaBm3CEPBEM9KiFtXU3gPXLtWEx3R+aFW3tkbpeVX2CWBNKoH
         W0Hg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790946354; x=1791551154; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E3o9mY11vfyNe7daMSPv/Jpy/COQ66uBOFgs4MlwYzE=;
        b=W2Phv1rM71oVjbA/8lnLfVri88gI1M30eRNn40Urn258q1MiUGNLN/Jcel+L12i38N
         YK2aI/VLPf682nbEUaEtM4iCQnSL+ga5QN8MVJauUCOS7bQ4Q6KVKEHRZThuUEEM4Ihq
         7yLETuOCmKW9xKo5bFk9kqRqBomvjfeBir1qmjVsS3rSnQtkR5t7+3DfSEdukWyIdpfi
         5E06ZW51I9oN/DQ14ZHg0PRAw6Cm9TJ4IwsIkLFeoy0yb34p5aOC6LxhBg7XAeEfpEgj
         vuffNPXOFRlB1EF1k4x8REg83cNTpOPZyk7UtQh4J2yfHVXodul6womhF0lrOAGKZLfW
         2rWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946354; x=1791551154;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E3o9mY11vfyNe7daMSPv/Jpy/COQ66uBOFgs4MlwYzE=;
        b=QOjDNuXRmiewbVqeA42QjoKgtS4BLSSreN6B5g9XfBWF8IKqSdHy2+RGuFI/co0hp4
         Gj49iyGp0Lru9Ay3K7aQU8oAw32ks3rHz6AsmWel3QxcVFuNTgVL1nDpsV/MMtJZ2QAz
         t3uV9fSmthuqpti4FOH/l4aOJ580cBUxil7DLHIWlWtbgk1AKxgR1Oq9A1hIoFaiIRtQ
         MqTGzQf/NOabBAZ9xUjlCaeSEZnWt1eHTnMIuqhjTl+2ZTXKZyvrsae8S2er1rJFfPyU
         SDBI8dH072afnGo56iobOatn24U0Ne+6eoK6qf92zhqWNQXQogfaMnNdsvWIQgFOhAM4
         Pztw==
X-Forwarded-Encrypted: i=1; AKwUvBwLTG68c0TisDVdeZHSYY+l5rlozRWkbjowCNrfVTuQCQwHHcqOtcsd0BKcx1MTAM1WoDd4GsQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYLcgCVCE8ip+Xgix94iz/GUaUL1lWxl0zWFNreyYf0Z19nzqzvV
	GDEfpVCFCMOFigjSDuQ4t4yMLFK2WZMYKpBAL49DRzJ+pmHVyUclcugdK4IngeXcqdrGQPLqR8k
	1i6vD7uNfGgkMy7GJfdW53KG0i1NIs0hx5NIV/FZd
X-Gm-Gg: AYBFou2/onrLOMGSddLm3dKFK7PDTIT6kcJqnKxmhnXh1RvQV4ZT1UDBnmzUcaMBaML
	643Wj+/3ymD/71ChTwxlFGnVYFdBF5S7/t8JqFf//9tOqS+FOmThuDHIPqVXufZuNh3YKQogJCq
	63iTF3lqMmSymdwcxVh/pQ17viB3sJQQurrgCj+Y1dhJe7t7jURXxhU54kFHdbDpvRe22YEU8rJ
	yn4ogVuQJGNtzRTlrYEuhRKlBl1SIj28qVgTZb3yUEX5AQWKgD9rlJTQDD7QphQ+UuyrHZeyBfj
	PyXbF1RQL1hmZ+0TQXF8kLxEVAVYAWtPQ5NEvhpIM3M18tiudtD25VizpLuRN56wwCXasboNTMa
	wFfOo3pKcK61NOQ==
X-Received: by 2002:ac2:5b41:0:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5bbe07ff867mr111076e87.9.1790946353509; Fri, 02 Oct 2026
 06:05:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com> <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org>
In-Reply-To: <86se2o2rbs.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 14:05:17 +0100
X-Gm-Features: AclHuK-8Kjrfe19sfHmKlc-tMXZBvGMWfs-wEUp4fL4Zc1UtRtbnXSXF_N2l_2s
Message-ID: <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 02 Oct 2026 13:57:11 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Just to make sure. Is that what you had in mind?

A diff is worth a thousand words :) Yes, that's it. With that, every
remaining hyp user of vcpu_is_protected() only runs with pKVM, so the
kern_hyp_va() case in the macro can go too.

Cheers,
/fuad
