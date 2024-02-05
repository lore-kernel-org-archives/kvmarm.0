Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FCF4D10A
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 23:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175933; cv=none; b=i2XzgR5kmM1B/mML1H07kre0t4h0Nx0fIYpWDZVWY5t83NCzyu563HRcCy52tQ5d5o6Fz3YWOW8Aa43hv/vi8QKIWMuJtZOg9YaiXe3dPuvsHxGACYojxFeOPacLQqyXk5XxCXHUCvWZfwQY9Nk2vysG+E+sChMuRgoU00HJHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175933; c=relaxed/simple;
	bh=s+ba7UNNd4l6rcm9bL2S4lJrdSzTfcoNEa8bBjhT/34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XmPzTXiDd0eMoz4mhhMVKJbrSyVudBdxDeLdC4AIbL73X0H5lON8TOwGsElwyGfFNndAX294aUWJtN+YJsih+LT1FxogownEK4YA5PoLx8iF+fqjU9zBUI27u9erPp4hr46L2eSpjFroCwQ/IAbXdjIkgnOlEbngtdp57tiLdbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LE6LHuze; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LE6LHuze"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dc148f91faso2242725a12.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 15:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707175931; x=1707780731; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aHiF8WGptYmPz5iXMzHQodsCytVgYePbufYEivoKF8=;
        b=LE6LHuzevwrzhIfZIslheQ3GJPKABFmutIg58OSw3bKpbSHQQt5M6Yz6a5S2e7KRl8
         bDveDwf3Mm9YUocf/vO119G+a1/9wcsDmF+UaSbo1GKrINlz+orK/21tFFRlrpIIMzF3
         eDRTTXlSZfyHSmxC13c9QHVnY4ZUO7DPX9lvJ7U3mLetES3i68lKE39md8DQUoMwvM2V
         bkwFT3cmAUfSmR5JoQwr/wAyXQykvLVPORTq1rvZ6SYONkeDcSn1mP7vN2VgUYvejs7m
         rUqRlqgpoqBGNyjxElF4ebhMgRqmJnWLXKkz+2r/A0ty9AEkvcNzRAyBveBTrb86Jr9z
         6aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707175931; x=1707780731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aHiF8WGptYmPz5iXMzHQodsCytVgYePbufYEivoKF8=;
        b=NiyLkrNYTnyHzzT5TjdMQDRYGmYpcDD9EXoEeuR4aGsYfsOs3Mz4BFLNtNmDVcFFC+
         dL37BrwaYJLa/aBY3gkpI6izBeUJukIXfpCHLj2gEZ5nqnSpsSTW2HL55edikr1bPvec
         zJetk1uj+H0wB+os1I23vfCMCFzGaEmH+SdEZiZeQNXEOI1oH+GY7NSEp0FFqZQcWFEJ
         80rUSNc1LmlXpChOApuWOAF0G20DXkR25qxbXwvHtx9glKZV63Do0MgSaO1RbrxRVlef
         RbkK4Lm8zuo27W5IlRBgt5wanvz5lYqztNo/kjqYtTQrshoSHl8OsSba2jj/yJjCHOQ+
         dp9g==
X-Gm-Message-State: AOJu0YzWPbzCbxTIIwCTph9yZDS18uurP8/RNmiMIAUYa8gBgUlWmv4W
	UY0PGiot5AyBZDrpPz5mWiZMvJ6gHGN+Qa3/dfr6DaDH1eRvkV7AS4Kpl5JILiWxZtlbeGrTfQv
	QaA==
X-Google-Smtp-Source: AGHT+IF9pQzmD6LV2uQvxz4V7wiPEQ0CxqP6mZJtdq5EHg/fzbnEEZKqUoflqGDmgX/A+FwqUkK4tjTOOUk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2452:b0:1d9:68ae:b650 with SMTP id
 l18-20020a170903245200b001d968aeb650mr2496pls.12.1707175931486; Mon, 05 Feb
 2024 15:32:11 -0800 (PST)
Date: Mon, 5 Feb 2024 15:32:09 -0800
In-Reply-To: <Zb69ryhz_mDw9UK4@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240202234603.366925-1-seanjc@google.com> <Zb69ryhz_mDw9UK4@linux.dev>
Message-ID: <ZcFv-cYtQghiz2JK@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 03, 2024, Oliver Upton wrote:
> On Fri, Feb 02, 2024 at 03:46:03PM -0800, Sean Christopherson wrote:
> > Fix a pile of -Wformat warnings in the KVM ARM selftests code, almost all
> > of which are benign "long" versus "long long" issues (selftests are 64-bit
> > only, and the guest printf code treats "ll" the same as "l").  The code
> > itself isn't problematic, but the warnings make it impossible to build ARM
> > selftests with -Werror, which does detect real issues from time to time.
> > 
> > Opportunistically have GUEST_ASSERT_BITMAP_REG() interpret set_expected,
> > which is a bool, as an unsigned decimal value, i.e. have it print '0' or
> > '1' instead of '0x0' or '0x1'.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> This all looks good to me. Just want to confirm before applying: you're
> not planning any other patches that'll go through your tree that depend
> on this right?

Correct.  There's one patch in kvm-x86/selftests (see below) that touches some
of the same files, but unless I had a bad -ENOCOFFEE on Friday, there are no conflicts.

[2/5] KVM: selftests: aarch64: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/95be17e4008b
