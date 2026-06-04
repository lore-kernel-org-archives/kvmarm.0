Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E32EFD9B
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 22:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780613926; cv=none; b=KbmWHUdsnYc5zOxxzzTJ2mVh/jW6TSuAhGxKO/MRqq2q1ZeAmNFVetMz9L2oSxbj3s2KyLzoGeqi4LYZ9M0falQBERuz02tZeTPaypILO04+98svjjMTUs/F3arPk+hNNMgOasiakos1wOVkZYhMgIx0aVexDhYXcHEEw543AJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780613926; c=relaxed/simple;
	bh=FXOn0R6GghyUGhYRAvJfnnVPwuZfBzvJGFehIETMknE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=usXLsjLuMWH2ICwrd8drEnVsqpvzRx0jX0JZ7QgNr0+4BRaChz7V64lRyDKytuyricQsB2TsgvE16apqmSsujObljrdamFWnp+/rRuPmw7pDYG4LiMP6yMGs22Yxu9wuNP+GkWAc0Oh726FNn4TzJNGodRMP3IIWz1jlJeMvWC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgWDCXUY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgWDCXUY"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8604fbe71eso577354a12.3
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 15:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780613924; x=1781218724; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0t+VBqFHEPHbmxYITXwen7bG3EAMYQHm1cDflplkJjE=;
        b=UgWDCXUYcjrYr9fzjNlvvzrsFTusTnQRRKzDLdutpaqpxiGnQDzdJG/oau6yw8k/aT
         +GooIXmThZc46yo6idg8yphEfrflo4UmPYhEQ1oLlfXvmKKKDwgBabjuUfGr/mTneRxQ
         edMxNawiLR1ulEK+DKxdqxrjG0u5aKLYlYdss1y61HJlvpF1wTrb4tQcNYYOgC6gs4TM
         Oh/A8w8KnhduJ00yTD2HCSHYdgOV2U5O0V0ekvfUWEjSyqF9LWsyqn+6cwjNvbQTU2jH
         krSCcArc7eQkIT8nCppPUaatpYpS/+NJtFuJMkiT2OCCb0opg90sPTe7I0ClhxQaQxus
         x1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780613924; x=1781218724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0t+VBqFHEPHbmxYITXwen7bG3EAMYQHm1cDflplkJjE=;
        b=j65IbrV6+nsmYHyd5rCR4K+8fNEJr30XGMvc4FxX8Zr49vE34G2ZOpvY3gTPfzeppF
         taA7MAq8WrenxguwtQ4lj1etmy8z7OAEjiuInnsiXUFg6XpHhI4CiG4ikz90GTWR3w3A
         IdflXJLuOg0tQUOJITCtICu+ZSQONxDTM00supZT1nDpS3tElprVfnWDlzz7diMalM7J
         LrgFJ29O2xygao8WXIjcIo8kYeXYBRSfssuIIke6MW3bwrC6vSb7FYe8UpiofTALUp00
         67xNBIAFdEZPJxXWAsLB/2jtrFbOTMkzl6JrgdSBgns92TqiXXVdrzQ4VZXhA0p3G/Ar
         V80g==
X-Forwarded-Encrypted: i=1; AFNElJ9G1WtGMjuEmsNUOMBPRfMwDh8Gmblx9Xl8MA9BHSWDqhXcFlB+3hG1n1ncKokRCPC9hIMIQXc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxl7fnQ6G57XNeadEvlsDjNzpeQZy9UGGMayfcoH5Ouy6vA33Y
	gguiK/jyV8ruIimXThecW0ivsZ+FKF91xhI3LzFyE0FsCmhc/pexzQQeOtqoxCy5TNE/km+ESL1
	iJoJ1xg==
X-Received: from pgbfq7.prod.google.com ([2002:a05:6a02:2987:b0:c85:69da:2c03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a07:b0:3b4:85db:1bdb
 with SMTP id adf61e73a8af0-3b4cd0801bfmr1026910637.44.1780613923842; Thu, 04
 Jun 2026 15:58:43 -0700 (PDT)
Date: Thu, 4 Jun 2026 15:58:43 -0700
In-Reply-To: <aiH7xKnprU9bUap5@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <aiHEKOeZMVwsRlvP@v4bel> <aiH7xKnprU9bUap5@kernel.org>
Message-ID: <aiIDIwgaFWAE-zEG@google.com>
Subject: Re: [PATCH] KVM: arm64: Reallocate the nested_mmus array under the mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, maz@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, christoffer.dall@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 04, 2026, Oliver Upton wrote:
> The shortlog is very confusing, since "allocate behind $LOCK" is usually
> something alarming. Maybe instead:
> 
>   KVM: arm64: Reassign nested_mmus array behind mmu_lock

+1 from the peanut gallery.  After reading the shortlog, I was about to grab my
pitchfork :-)
