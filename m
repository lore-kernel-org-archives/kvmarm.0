Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE2B4C3CD
	for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708166629; cv=none; b=NG+UtcO2U+gFTZnITcZYbx+VNPpodWOCkVrTyJY7WQdMbOpHh2/jir0WvsAyA6HvdMLwhhoasK3Dl18Im4vMNQoG8PA9X3nA+LDqfxmXV0uM8RPYAKkX7mzJdzvnp14bGKE1ESB5oICQlNfyLer3ObTKEmy219tCuwmMhg7/ZtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708166629; c=relaxed/simple;
	bh=pueJuBjvdty/exNX+JTCxpqDqsWosCNdOPaeLoPKiT4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=k5MusGmMKhLwj0IpaGsc3Po5rhUqMruF+9Uh5MTmgTwfkkWBYOwqzJ3LkOl+xP7iDGwwx3ohNVb7Uw5PxLXTSNarziFgCxe/4gKew/kMXy1v0WwHRYDl2Xm9cG34pzHnkfACnPGmviOg8oSsYsYCvWBzdCOnATWlTSpqykWId1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J663iyup; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J663iyup"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c0a36077a5so1721115b6e.0
        for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 02:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708166626; x=1708771426; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZfe2MKb984rLMd7yvUTT/B2xvgJx56CObl73IQLbW8=;
        b=J663iyupd7qvkVfPU12FcS9buN9Geym4x0wSNXXpyxKicM3rFVE6R2+VxR2gc+o1F2
         GfwyvdLd+lVLBGW5u4OeYOyIMg1e8r5uCfEJO2zp3o48ENBKbR6vLUpDX9pYz/8mbPJ/
         Mt+Ef/azIU2lVqF+G5X+I1EWz8eU0WPE7vluNkJjNJfYgxju1Bx/0nuhlDjSEbF4tvFG
         X3DYwb0Ard0UTBJI61ZNU+hL/tSuFsccmulDVN1pKcgrXQ6WhqJtHRg5lV72zyVzgTGB
         i6OIK2fjon5K4sf0tmXtMF6qWOnD92wh5pzk6su2YKH1Huzxk2rGVjPyMdJsL6Lto2fi
         gP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708166626; x=1708771426;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QZfe2MKb984rLMd7yvUTT/B2xvgJx56CObl73IQLbW8=;
        b=ZGnLj7IFeeo0W9hAUr0uCZBRB/v7dxvlLYsfQ9E2e2JsaR6RB0khgBtlBNb7TYinbT
         oVrxitZheB7sR0fjUfFHmLUnaYfFtWLzgLlgIWFcPVqF5CjMtsaUz1xCn0QSDtdMBmOZ
         JiJxrQ0CvKwB21HU+OT6W9TujYFvHyujtHPVErWNLaVxzx2YCfoTuyjyiuYOuGF6LHvH
         WDOmroDrXWFpo0aVOaJO9WtIvojOOWQXrpdCUv04Ea/kURIZ5rlMU3z/uXWE/Vc4IXaG
         aIY5ib9hackViWCo+QZmGaeQOr+qbaOzWuev9GkKbV5ZyYDi06PE85MR+3Pc+oLh5YuD
         Kk7w==
X-Gm-Message-State: AOJu0Yxr9QyTn6itZXKvyuqF7MCB0Aq8gJD8jXp8KH1LGBZ+TvCxQ7v7
	8l4WhcJn/tlQaI57p/NIni4hdW5sDruK7xzqSQvZOrWy5mUtrsRB
X-Google-Smtp-Source: AGHT+IE/vMvcYy5KXfjptEtql1xt08TOeqPgYYDYiMrarXVweeKxNps8OyFxTOWhvz2nM6XxuQOjZA==
X-Received: by 2002:a54:4603:0:b0:3c0:30c0:e6f6 with SMTP id p3-20020a544603000000b003c030c0e6f6mr7099723oip.19.1708166626642;
        Sat, 17 Feb 2024 02:43:46 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id u12-20020a6540cc000000b005df41b00ee9sm907578pgp.68.2024.02.17.02.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 02:43:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Feb 2024 20:43:41 +1000
Message-Id: <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementati=
on
> is a little bit too  na=C3=AFve: After the first character has arrived, t=
he
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
>
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Nice, thanks for fixing this up.

I see what you mean about multi-migration not waiting. It seems
to be an arm issue, ppc works properly. This patch changed things
so it works a bit better (or at least differently) now, but
still has some bugs. Maybe buggy uart migration?

Thanks,
Nick
