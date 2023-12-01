Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA75C8EA
	for <kvmarm@lists.linux.dev>; Fri,  1 Dec 2023 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Eo9OJav"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6c7c69e4367so2901548b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 01 Dec 2023 08:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701446913; x=1702051713; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SUzSIwk7HT8dyZz+ygqaaq2fkvYNgaSclIN2mCrDJ6o=;
        b=0Eo9OJavoKe+Co3da2wScvnEPRq65JGS++W0WSCQsod+PDAQDIBsDoWxqI/qeeII+6
         1yFTVNQtTsZX+PG+JTIA1ta6OlwF81uQf8UgvrDGb+D7IrHjTHAFOX51FV6QS1brEW5i
         KC5EEIxEurwwuUvvdOn5DdwJCmEWsBwB0wTr8bONmj8dycHLg3KlIRgiefYGtatKsAGl
         8QtfbZE9xj0zX21y883kyUrERsTlIpvvtWN/YQy/K/0cFnHSYPITq1QL9UlHluTCy3Fg
         d3W/2l/im7m7RiKNhPESt+SBC0/Fj1A67wwsiLITaF/pS2hIrY5FQGfhr47NluYPXQRP
         mowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701446913; x=1702051713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUzSIwk7HT8dyZz+ygqaaq2fkvYNgaSclIN2mCrDJ6o=;
        b=b+7et8BxjAQi/yGlDYz7d0zZ6ofjCxFkApmBdj0at/NpGkdW5t4dRAKr9+HbP40J9H
         Dj15bTXdiL0Y/VyV6EAV6ztigijniei08TebLMpFeVKEesYeOZi5sK+2ww0ruI+K8i2A
         D11wyIFDT/pPWziWGNBmL1FglcPc/+OfWEZPgon1SJkCKdXuEUj8caTB7stQTuvOgQdc
         HWjppShdZzaq6bikx3AhKGs96yOUKjE2VhYcv1mPZjeTnFRi9yGoXiSoZEtF5mRjVoh5
         gqdzTmweVW4Sv/NO9eUhfJwf4KobC1uNS/v1N5+Of6kwL1gPEYtPl4yykhIrESnyUKQq
         ZiyA==
X-Gm-Message-State: AOJu0Yw4HbJMfCcbYN4PhVsjFxQ+4sDyTWvL05Korj2rU7bcxglGjoqz
	1iQq+N3i5wxnRyh46sdah9zj0uqD6YM=
X-Google-Smtp-Source: AGHT+IEAgiPoi8owubrQZyENMwuhRbFd2eI1EsNr015bLVPqPEqSXeSZt+Sd/CSW+w3SJFOBSyfHE1Otll0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:885:b0:6cd:d8c6:5f36 with SMTP id
 q5-20020a056a00088500b006cdd8c65f36mr1468980pfj.3.1701446912742; Fri, 01 Dec
 2023 08:08:32 -0800 (PST)
Date: Fri, 1 Dec 2023 08:08:31 -0800
In-Reply-To: <ZWjfjAnZcomGa1Ey@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231130182832.54603-2-ajones@ventanamicro.com> <ZWjfjAnZcomGa1Ey@google.com>
Message-ID: <ZWoE_55_6q7lqJvo@google.com>
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Andrew Jones wrote:
> > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > in an extra one being output. Rather than remove the newlines from
> > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > the other callers, as __TEST_REQUIRE was the only output function
> > appending newlines and consistency is a good thing.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> > 
> > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > MAGIC_TOKEN change)
> 
> Heh, and then I went and created a conflict anyways :-)
> 
> https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> 
> If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> MAGIC_TOKEN conflict.

Actually, I misread the patch.  I thought you were removing newlines, not adding
them.  My thinking for TEST_REQUIRE() is that it should look and behave like
TEST_ASSERT(), not like a raw printf().  I.e. the caller provides the raw message,
and the framework handles formatting the final output.
