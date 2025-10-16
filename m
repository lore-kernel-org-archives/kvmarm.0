Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64404226541
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638119; cv=none; b=YXGkCBYhwmZ98+0RubdWKVddFk+8lmgNVKWNRNltbod31hlQ4R5xBgJqCLIkNSBM2h0n/Zc+oaJkGLMk1fMGdYN1a3O9KTAYP6f/ndcsCQbN69VsH4rtraU3vE8COZe2h7cztsvySdtw1tyK9EzhTfC2Gir1fpkZZ/x+hEHEgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638119; c=relaxed/simple;
	bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VvvtoNgO9b+bY1sBMVfllTzJnWlrXkqC7X/xbPiXdz0E3KomCno3ReWpnWpRvIUqlwz0KXbLV6kNvNDSwwaqgiUQn1fX9Xkq+Py7POS4829WyjmpED6kxxgBM4o1+ml7dxsAxeAAUDouVpLQbIHvsRUX+rQI7WL6SMc2sI1VOtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cAoK7Smn; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cAoK7Smn"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-26e81c17d60so2003915ad.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760638117; x=1761242917; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
        b=cAoK7Smnsvwa2RqrvGXTG05mJLaeikZc9fyxYimiyzvyrsniCkM3ac/cMsS4mPKrJk
         WHoOMCzWdnpK7AqYNgJ+3KmDWUQx1s/xBFKZQLRiWLs9jB01qHktz/FgLTbCj6G/j+R5
         0YWLKFKNNOcN91Aku7mt0rema4/0tR/8VX5Q97XfgVWaN4v6xBIPcdK/r3mPTO2kYaPc
         27RuBDZX2wsUqoIF5XG+zzU+JkwN//62qjbLEJ8APKErAIY7P3aPWZg9hZt+zTUWAzHq
         j+LRIll0ktjsM8VTzaezuEvrnxYjavSw73uESZo9+ldCvfD8bPLjZrcTj0zjhZmeRRot
         mp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760638117; x=1761242917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
        b=tB0te3/QssKM2irwCC4nmGpC/arjGiCh073fFBrFLr9dm1ISbsPBgo7LzXGLdObBga
         xaj/9yJqDGUKDBV/R1v6yMkzt5h9uYNoQuoimaJNXkdjF2nuRV2qnh4nt80BEY6Uku4O
         M+2e1TfNZ6uJefzOW4ewtjjIehpqwT8imCEycLMss5EbfqhPAYJ/yZ+vGknrAfUARk1F
         gxIdOTNrF2WLXt1OHFidAKZPdGNldSrCv0e3jj4m3PgII42VTKcS0hZDyID6D7gUYpWj
         1FOXrnyT4T8PTVZDos2Fpx1lLW1Csye4OliTMFW3wSqt5uvfhK5bK2y5PtSMO0+rZMid
         Q9Yw==
X-Forwarded-Encrypted: i=1; AJvYcCX7HGHmmiKYQHEzBNNTusMSb2vKCA7MNKG7nNceoW4fzFBJY48MGpwRGzS5ejwUPB+B2mV+uoI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNXqaeWiRes1yThzw1BhuwTpQ5N3tqLbhffL3QA6xPQmmWo8Mt
	OsMyqLU8KWij6snjfRB1T1BH3isZ8HHAdPWOwqJaEXUGsnz1SzxlERo0bClF59+PItnEJ97OS1u
	EI8Xh/CWeFRIFW+XXzRKg1qAP2fIINWA=
X-Gm-Gg: ASbGncuyXTu2Pq1ZLzqmThoUXIjWrtlcw6u3hqgLxbeihtcBkLHTnr08qEy6q0bil4f
	hwtRuF+dzwOX/bt9n77ECxhqhpN288w28gh4KbjMqKopqMEsvvvp6gfuOxMQPDjwEQoL1VJ4RPe
	/Gvf2Pc2lQW9MtEMywkHvm2/to/bp5eLuaogs3CmNHcXwQi/cPHiXV3QZY2dHnf+z7aSIvVaRKf
	9T+9LQR2jaAkT9JCdtQC8qc0rpsMJxTbPPOlqGOLxd/UoYlLTn+AMOK7lQWSLFznwdPdilFe0DA
	3DRGqxFy/3dk+cHoQzZbuukSlQgPiN3TBuV7tlBhlAY9dXcu11ti2L3f7so0cw34qkWcqdXYzA6
	UYPRSWBqv9bpe2g==
X-Google-Smtp-Source: AGHT+IEoB07YLtvOmgRhJpNg1dneDk3OqPXrwHl8ZjlPvoUL+f8vvKYxA5NW6SB6Z+zvhdKoNNyC5a3rT2Kl6EmYok0=
X-Received: by 2002:a17:902:e743:b0:264:cda8:7fd3 with SMTP id
 d9443c01a7336-290cb27ec63mr5305925ad.6.1760638117403; Thu, 16 Oct 2025
 11:08:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Oct 2025 20:08:25 +0200
X-Gm-Features: AS18NWA8avJ7AT3gN1GiIIdaHzAYbZXDs9-XkxbnI3nrmWWVp79jjOsrQv3WW6I
Message-ID: <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 7:30=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Miguel, you got pulled in due to a one-line change to add a new iterator
> macros in .clang-format.

Thanks!

The macro is not in `include/`, right? That means that, currently,
when I rerun the command to update the list it will go away.

If that is correct, and you want to have it in the list, then we
should add e.g. `virt/` there or similar, or we could have a few
separate lines at the top that are independent of the ones generated
by the command.

Cheers,
Miguel
