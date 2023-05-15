Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADCFBE7
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 17:17:10 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f42d937d61so68287755e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 10:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684171028; x=1686763028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRNM9TiImjxuTXseGdv/jjf6zIOSVE9iFFKWkLCdwbw=;
        b=s6AVoEauyNuLSEzLRJpAAC6NelJtBURB8ifKHg1U4vi+WcZ/fhM7bi+p5g39jV7tvx
         fkGwuxRYinQPCcwxVEc4iDmJPRU733fqSXQvgVolQl9K5Z+EqqafSsKu+hMpJ7A1u10W
         72BuRoJ7KKmXv5bn8QwiBZHgdvw6L69wtb0/nkoSH+oPCDoMvPFGM4MnPgBZ9BTcJrpp
         KHqoWa1if6fhgjy64zhDedQWzlkjakgqurSdp2vRHVRRKIdY5QfbUUd3s4TvUVp+bywk
         uE/eQR6WzYrZz9umVTBi3yHE7wpK+9vVj960cSKta8vQnyL58fHwLZtV9qbxM6SdVZjS
         PfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684171028; x=1686763028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRNM9TiImjxuTXseGdv/jjf6zIOSVE9iFFKWkLCdwbw=;
        b=BuRLkf6PO9ehGNtUEzDdW7KIiifbweDGnKa2PsiGmkWSeVP1VHFdzEGk0BzM3U2IFg
         n+uVSUymHfka5R6tsM64huvIX/rmSMFEOaCci8wNSXCGSZilR+4CFwY2nMZoPjPubg/e
         vWCh94fJvN9SZmbsT54gknuKksjyU9LPzW0yemSjNJBZWmx7//b+f+qH6TCB7T/A+1OU
         Nn5MuMIDOlsfLPgf1O6qQOhZ50a1ek2RX+vxSyRUqdEsqovuh2Z0SJ1JhecRUU+1pBTg
         VkHWfLe3+U4UNDtX6Z5JeCykf7nepOIplQlc+vN8CCPcf8XkbA+e4rRJtyNqZpxMIh+z
         Geww==
X-Gm-Message-State: AC+VfDxC6TeAEXOYp68ImgjUTWH7eUpi7TYc03uG/JEAIFGhLX9TImbV
	Tng0SNVnX6dBXVPdejsNqSKGrBO0AjRbokB1V5bs/Q==
X-Google-Smtp-Source: ACHHUZ7hVivkNOvDkroqqO/GCV8XH1xVY5YHgcP6OLoyOiqdL19EFyFXmodIF1lpjHnlQI26b3C+UXrzpl/cBtsFEUU=
X-Received: by 2002:a1c:f314:0:b0:3f4:f7c2:d681 with SMTP id
 q20-20020a1cf314000000b003f4f7c2d681mr8811102wmq.29.1684171028420; Mon, 15
 May 2023 10:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
In-Reply-To: <ZFwRuCuYYMtuUFFA@x1n>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 15 May 2023 10:16:28 -0700
Message-ID: <CAF7b7mr_EZrBC_8mHxEXtj9u=4qFuxGUaSxH6qd2bz04HgbRzw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 2:51=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> What I wanted to do is to understand whether there's still chance to
> provide a generic solution.  I don't know why you have had a bunch of pmu
> stack showing in the graph, perhaps you forgot to disable some of the per=
f
> events when doing the test?  Let me know if you figure out why it happene=
d
> like that (so far I didn't see), but I feel guilty to keep overloading yo=
u
> with such questions.

Not at all, I'm happy to help try and answer as many questions as I
can. It helps me learn as well.

I'll see about revisiting these traces, but I'll be busy for the next
few days with other things so I doubt they'll come soon. I'll jump
back into the mailing list sometime on Thursday/Friday
