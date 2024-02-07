Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D086147
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707331514; cv=none; b=bLudT99UrNJoeWRDbtl+WswygnDBweRdOq0DISPPo6T4bMnxJaQHb5aY+FqyjtHecHdDHUlKh02V62Aoxu1TJTt4rgVLV4f4KpZE9uKjaJuM20PdtNU2J9zmW2z8MApU0++lRU2SzWPe8JESmSJElMfYvvRplfgapjjLAesXrOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707331514; c=relaxed/simple;
	bh=rB6Ec3p7AhKSA+4vWbIWmOnRXzrkeuPKLZuukgZZEB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIxwpOM2otQJc5Ah2zbAKCY0aECrtzRQk61lSin0EzW7r9yUmwd15znZtEAjtJypNe07BRK0wYmkxAUKnqihzKRfH5aGRSnHICttKizUkIgu9QPu/IAfbkpOq/zZa8IbgWS1Ob1g65USIKuokF0xGUy86BZa7WW3irwZ1D0PJZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OHr6ByL2; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHr6ByL2"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5957ede4deaso539563eaf.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 10:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707331512; x=1707936312; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/ClBNBLoP9L3DooA9dVRQXDTvqkKaBQDDYFzsdwXvU=;
        b=OHr6ByL2AaAcOuzgZreVh7gSHA3cq2yu+6Ek0A5rNnOfWppuwRrOKKaLN4ZL8S9yEm
         rD80qKkOq/Rlc9s+UCOxwtC+A0xio3L/Jugdlzh+NELqSFVc2jyyOZwkGH1oD8x8+kHe
         eLPqNIf7lal6+4eCr8oUcZdkvp9cqYM8OXgbVcx0DuKuyt2iG05ga07lzWWF2OD53z3m
         G8RqSuEo8t6cgoWJUiJxmv1yedBFmr4GiAWrCBFWKANNLQ6k2Tn7qWuDwuBBkdPHv+l5
         8f+XL1fUms5KdNxmxp2lSPz4wYjNHrGh6zELqBReNrCW/HCWrWzd8bsAeyinNZDLlWQR
         XJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707331512; x=1707936312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/ClBNBLoP9L3DooA9dVRQXDTvqkKaBQDDYFzsdwXvU=;
        b=Yy+l6HYGM0F5TlNvPOJs3i5S9/YFWVxHMBZewLtG8l0UiZMeKZ0asUOnLyUSxRc5UP
         9pTwnpJ0aXsJ88BEprL+UrhbIklZmMmfIefiMg9K72qk62PmsIdHasAEQXSUYfonj+Ek
         qa5Xje7PkiTSfHx29onO63mcYq30QEzf+hseLEUdXV51imYlg5m3Mmk4D1NZmBo5DKFS
         vDvZadIIWClIjr/MXUXhLs44/eP3N52MvwPl4X6E5BurB+zkA3/tkQGgvkHiOmIwpjkF
         OwHRXpVIhn0Uf0pjYv4fRXJoTwXd1sOV6D3SBYCvoHgffmmOT4qM8HxiNY96JI9Uyq2/
         7u0g==
X-Forwarded-Encrypted: i=1; AJvYcCUQ5YcPHwKab1zcgnQi+I/qF/rltVJe9G+XyAXrDfokmRIGo4Y0Z3dND9dTSau868hvzPleevqQzBPDSyeB2bB19OMydBi7
X-Gm-Message-State: AOJu0YwVBl+6wnrGAXQ9o+J71nndzXyxxdTNo3+8IUzJHV7QzzgbbKNT
	EYSBz06R41dU/ym4flAbYYakJQnu9zqMT/tF57IDmsoEApzxlzECxXO6X6c5kftF/lXEWoB7hDP
	VCbEw/I4T7QTrAusPspBQpgpRHE9oBah9VlLi
X-Google-Smtp-Source: AGHT+IFr75SrPnd63j+W0s/lOHj2a8WzH7MkXgPW3MqyBgjBBBpINO6XePXGPl2a+oNRSfCWUuFBSWROkh2x3mJJ2OQ=
X-Received: by 2002:a4a:9c8b:0:b0:593:f906:614f with SMTP id
 z11-20020a4a9c8b000000b00593f906614fmr7576755ooj.4.1707331511783; Wed, 07 Feb
 2024 10:45:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-2-amoorthy@google.com>
 <ZcOhM5wPguyNC0j5@google.com>
In-Reply-To: <ZcOhM5wPguyNC0j5@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 10:44:34 -0800
Message-ID: <CAF7b7mrfn5jbDQpDf4_0_1vtMq8YS9mo4MpUK1wKuxgQ328rBA@mail.gmail.com>
Subject: Re: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:26=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> This is not a Documentation change.  The comment might make its way to ge=
nerated
> docs, but this is not Documentation/ and I most definitely did not expect=
 a change
> to kvm_main.c based on the scope.

Whoops, didn't realize that Documentation: carried that specific
meaning- thanks for letting me know
