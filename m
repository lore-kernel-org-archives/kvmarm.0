Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78116C848
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760296; cv=none; b=Pm0hCyjfHzejTxRZLJSd9O9S7ZMu9uSsYA2MYIzgTcEgKftIM5NI8Bk8LAoZzK1FxrJiVrWo2SuV60kJnK5J6/zRHzpUiiXRxFnY4MqGmNYEax0nxNLoT40QPzOINUpldq+9k7ZtrzvbZM1tYMUfVdvyhK/4DMRhtqbwVU3yI+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760296; c=relaxed/simple;
	bh=vdSS8oSfCOnVaZjt/jgZZmNqUFixNGmzq6ar9ljb28g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exNx0aNkKGV7JdfRvyrbODRqESXTa7H2E36+sQas/k/nPbzhx4bTLB3dL9aTjZffga5mZDxO1tTgInUC9DiHaWiI/iPnz2dRJEbjbG63hs1FSucefIO30wjn9zk0/Mq/UJ1dnA3ZlXDTryhMlrse410evs4RDyxpSfHPMk+0URU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NRPAk2ed; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NRPAk2ed"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56e6a1edecfso4289687a12.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 07:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712760293; x=1713365093; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SorY6BMN4ofXw7AkV1BJGHD1ZDym8XWxLWPHdQQ4SL4=;
        b=NRPAk2edrog01njm3mXq6RClCFrPnCMAcV86jZgXadg2i2HgusyFP6tEFoqWbjdK8u
         7L54VvCYAZj6XRP3JIHvI6x+y4AHNv7xmJmwiE8T+ia0ocw0HDqr6EL1InNzZv/cCvZ8
         8z5i3ruGwWHQPL0c3qj7dNtJwIvN6AUkF1pEpi/i97XTzTYZpVIz8toze+KNK9ifihmc
         JlNsE/9yXMk8YJ+NZve/qofUtWrn7PUc3LASB1OPwwtTeY2661k1/rZX4qr8Xtf+S0rj
         vYjkmArVaEMRwZmw/AnQ54ynRaUyVyhMLXl6kDywjIbe4QxOntGEuzE/hBg85MQw5onU
         LxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712760293; x=1713365093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SorY6BMN4ofXw7AkV1BJGHD1ZDym8XWxLWPHdQQ4SL4=;
        b=oSS1yS3T3NIw5WsVuqkdWhJJi53dd35RS7qmNP7mYhJamMvZBablJMTcL1dqgKnjVG
         0aJ7tIctByzE/rda0HyhdY92VQEUM86fz/HiwHYkSTU/Di8sd9C1NYuB5O45wqCoCvZL
         eyp0l0kVnA6B7M10eXxdeDWxmrPOYgl2T1Kv1NJ2jyfJ/9weW5o6YbkC+cmqF0niL+oR
         I0dWhKovxo0mDvF7HaFpbxlsuZYjBLa3yieEdZICtyh7cm1Xe8UWS9utOocpUnJ+8cQe
         NxHltDt8PwXcDFUMj1aKd5kGHpHSQMnodsvSudGDGlJcYLq9j3erZWrAXMF2u9eCy9tW
         Xqsw==
X-Gm-Message-State: AOJu0Yx5kIOKb3NLNx8PN3H1LrIWky1Y6YogyN5UyY9he3AhxwniTvq5
	ZhyCM4Zk+BTIyTUhV7Fey7U4GSz3ZVuXODPS/JI9x03oIxVH64Qv858OU8pT1Q==
X-Google-Smtp-Source: AGHT+IGxJ9gIqQrf+HvEjnspNjc7cdxKHlWD5YVIJkYKWhir2ZuLe/UJfbhkg/iRaUNh0SAoCgtxig==
X-Received: by 2002:a17:906:ca91:b0:a4e:62b2:a09e with SMTP id js17-20020a170906ca9100b00a4e62b2a09emr1635742ejb.35.1712760293137;
        Wed, 10 Apr 2024 07:44:53 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id gz15-20020a170906f2cf00b00a51e9b299b9sm2402050ejb.55.2024.04.10.07.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 07:44:52 -0700 (PDT)
Date: Wed, 10 Apr 2024 15:44:48 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 05/10] KVM: arm64: nVHE: Add EL2 sync exception handler
Message-ID: <seowwg3mfexvtif3vtaxkxttrsfdputkwcb7bfmjuqk25xdoz4@ez2dapcfsfe4>
References: <cover.1710446682.git.ptosi@google.com>
 <cebafe40b170589d52e2ef66f3bfac7396fa1f56.1710446682.git.ptosi@google.com>
 <86bk7d13uz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86bk7d13uz.wl-maz@kernel.org>

Hi Marc,

On Sun, Mar 17, 2024 at 11:42:44AM +0000, Marc Zyngier wrote:
> On Thu, 14 Mar 2024 20:24:31 +0000,
> Pierre-Clément Tosi <ptosi@google.com> wrote:
> > 
> > Remove superfluous SP overflow check from the non-synchronous
> > handlers.
> 
> Why are they superfluous? Because we are panic'ing? Detecting a stack
> overflow is pretty valuable in any circumstances.

I've reverted to keeping these in v2.

However, the rationale was based on the assumption that the stack overflows into
an invalid mapping so that accessing it post-overflow triggers a page fault. If
that is correct, can't handlers of non-synchronous exceptions just blindly
access SP and rely on the synchronous exception handler to catch any overflow
(and somehow handle it or panic, this isn't really relevant)?

In particular, note that passing those checks doesn't guarantee that the SP
won't actually overflow while the handler is running (as most push to the
stack). In that case, they'll end up in the synchronous handler anyway, right?

So, given that the checks seem (to me) to happen at completely arbitrary points
in time (due to the nature of exceptions), it is therefore not clear how they
make the code more robust than not having them?

But I'm probably missing something?

-- 
Pierre
