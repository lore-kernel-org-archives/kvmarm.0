Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3274F39922
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KgW2aVzZ"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3ae388eb437so758158b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 15:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697061878; x=1697666678; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjjnXqI9pbqoQJZ2xQAPRouGUG/LzE7OccZFWoVEwes=;
        b=KgW2aVzZ6H39j5U834CzE5chxPGTATYIk+gvXKXkjvLBzV9GX8shkl4H2vjEOapruB
         6uh2VSq8cqZS2wTrfZCoLbiheNWEUwDuaSveuduikQKwQ9YaGL75Y9TYtYo9lb9xcHz0
         udxp4ZvpbNNjru9fVAp8ZUbK0QBokm1fYUV86zcSPdfU5Y01+2TgdM96mOQ1vqn2xA8h
         +biphUcWRcGBpYa2ZYaWc+MDg2KAq+/Q0eVsmO8B49UhTPfFx5fN/W3V4U/9+pU+xgRA
         8sW99rWE/w9g6IkFhZhKi//bEhfjPmL8X0gdLz7Aq+6R0e6N/j3lwif49Ak9dVoNdo09
         trOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697061878; x=1697666678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjjnXqI9pbqoQJZ2xQAPRouGUG/LzE7OccZFWoVEwes=;
        b=ONaXD++hS648Q67V2Gfs+ydr4Dxn+tBFkWAedk8hIVfIpONJBWfNcBccQtLx+1WIU3
         hNX/gG200sMOq6/fXCdhIb+H3fmzDGB7H5hIX94gpsUZmaxJvw8DI9B5ftC0W1k4D/2C
         vVb0Na9ELHYdDSDOTRSG+AU3JaSaeYeW190XJomzGYVBdOVHaBOG7MeVjY7mesyM7KmN
         HQzq4hdRP5sqe/QUZrD0P6qzBdBRLUG1Gg0hKGlr2pOq7gVv9QiX3dUPlwNGdxN9YW5u
         O1X3vLLQrbhOa1LZqi81le46tAL/mx6OvdSkEn+dZDHJD9C3NMk7z7LkRmAXhTjjO1XQ
         ELsA==
X-Gm-Message-State: AOJu0YzmyD/g2MtupvBQGSr3HyynGjfRHssv1/mnkknpEkZPwVhtBPHp
	T/9KJa6wDntHsHf6hZ4NOK/lfr7A6A2jmaEjOoYG3A==
X-Google-Smtp-Source: AGHT+IG0se0BKjzQv599bsjggnp+VNDb3eO/7HsXNoOFWxmAUDb5hh1HcVYt8wlFdNMonYsDKX0aC5GQRpMR/Jr64JM=
X-Received: by 2002:a05:6808:1b10:b0:3ae:60f:117a with SMTP id
 bx16-20020a0568081b1000b003ae060f117amr11511266oib.3.1697061878139; Wed, 11
 Oct 2023 15:04:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
 <ZR9SLOQcFEqPg01A@google.com>
In-Reply-To: <ZR9SLOQcFEqPg01A@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 11 Oct 2023 15:04:02 -0700
Message-ID: <CAF7b7moMG1=CcUSjjkXw=Bcf_ws43ft4omQmY6rDS_6Vr1hPnA@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 5:17=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> > Sorry, what exactly are you suggesting via "bite the bullet" here?
>
> Add another boolean, the "bool can_do_userfault" from the diff that got s=
nipped.

Whoops, somehow mistook that for my patch being quoted back to me :/
