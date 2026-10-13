Received: from mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E746248A8C5
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898076; cv=none; b=HFZ92X0qGJRsUIjUldAbs98/Q1IS77P0EwldzjqZvHBL1dfTYUr78BQ4i6AkQDj8y6U6wpkiaaCaJTt2zTGmYx1K3ctmD4UaDeuurr2uKxdGsijEDnCAQPszVKRMbsxlKYTWBhPkY3vdf85E59ryXCNNh/iUrCl4hbmE49i+Ac8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898076; c=relaxed/simple;
	bh=SIHqZxvERkT8Aik9zKj3iOUoBA0r+lCrV7bOfwUXDno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fhp9NLg7NQqPHDzn6vj6zZSsS3wu5MQKnQK+4yxHUtOoWoAks7ZyKeiuDC07xVKj7hSWXGs3E220X8pEp46sF5pVJH78xB9Z/m4NesxWWhXSxZP7uj6IDKufgH1VX/Ud3GcM2KmN8z9PlXc0L1Z+AlEBrG2ssLDmUYYUGAZZIM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R33YSZzf; arc=none smtp.client-ip=95.215.58.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R33YSZzf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SIHqZxvERkT8Aik9zKj3iOUoBA0r+lCrV7bOfwUXDno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791898071; v=1; x=1792502871;
 b=R33YSZzfU1OZxhf8zv5zmbIGu725gL8wHLAO4L9w+rB9lK3KcDcNmC+xk+pIMMxvgwzJ4ITV
 QB8PNmJ+mAKjrs6C0PPKmBq668AbXdi5pEHePdH50MJ/IehBkhsh7AfW5qPTCtViF0C5cF00rHO
 UL457ar2GCpmnXOzdEUqLQxw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5b7f91973e48002c;
	Tue, 13 Oct 2026 13:27:51 +0000
X-Mizu-Trace-ID: 5b7f91973e48002c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so19854e87.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 06:27:48 -0700 (PDT)
X-Gm-Message-State: AFq9FYJgXE6j+jltYuMfXvkS7VkOWhxd2b769UURig3gn2DSmOQLELib
	4AJYAIBiHTSXidSkAjJb49hPtGT/d+yIywQ+npVVKflb9zO/WjD279MUCA9V6IBbjIcztR4nfMg
	lhzDRKkP5Ydb9Lb9+rM6mF53cMLgGg4kP0BzjqFDB
X-Received: by 2002:a05:6512:3ba5:b0:5bc:b2ec:eaee with SMTP id
 2adb3069b0e04-5bcea8328a2mr344669e87.11.1791898067868; Tue, 13 Oct 2026
 06:27:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
 <20261013130247.4135515-4-fuad.tabba@linux.dev> <sashiko-outbox-169787@kernel.org>
In-Reply-To: <sashiko-outbox-169787@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 13 Oct 2026 14:27:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyUDgdbuSi1_CJ7uC0TP3uxJoOgA3sCPA4X9arnbq_0ZA@mail.gmail.com>
X-Gm-Features: AclHuK910JIQF8Z2todu-S70u0aibAhdbvAd4WRKuP3Y0cjiQl0qPf6kSlNkfL8
Message-ID: <CA+EHjTyUDgdbuSi1_CJ7uC0TP3uxJoOgA3sCPA4X9arnbq_0ZA@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm64: sysreg: Mark fields the architecture dropped
 as RES0
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Oct 2026 14:15:11 +0100, sashiko-bot@kernel.org wrote:
[...]
>> @@ -2663,11 +2662,7 @@ Field        57        EPAN
>>  Field        56        EnALS
>>  Field        55        EnAS0
>>  Field        54        EnASR
>> -Field        53        TME
>> -Field        52        TME0
>> -Field        51        TMT
>> -Field        50        TMT0
>> -Res0        49:47
>> +Res0        53:47
>
>[Severity: Medium]
>This change reclassifies bits 53:50 of SCTLR_EL1 (TME, TME0, TMT, TMT0) from
>Field to Res0. This silently regenerates the aggregate mask SCTLR_EL1_RES0 to
>include these bits.

This hunk is in SCTLRMASK_EL1, not SCTLR_EL1. SCTLR_EL1 has had Res0
53:50 since commit d65bf6e317e7 ("KVM: arm64: Remove all traces of
FEAT_TME"), so SCTLR_EL1_RES0 doesn't change. Nothing uses
SCTLRMASK_EL1_RES0.

Cheers,
/fuad
