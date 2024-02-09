Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0FA76043
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494478; cv=none; b=XL0LB8AbtWJfxxGnVIdE0zg2MVUlkpYPJqGfVNU/IxQ9K6xXRRHhHCWu6o/oDr7fOjCKi9Tbw4ZeaBCKKgGs+oBBMuOBk7OHSwgZxNIdTatHJt8mGShDw+fZmdNwKUDW1DMsdE0V1ukFv3ZetOkgy+5lwhzGAGoyYRyQj7MHuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494478; c=relaxed/simple;
	bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LxuIhMpgXEIyzOYyP0545vG344ABF/EA/fPeSwrvKtLQpwMby4NLnosnybHm2xiPsJ9YXuAp+uSu0TYSq1wXnPThgMU4POj1YWSsUR0LbMNEI54+8LBt6Rt8AB5GUq4LRfx3sGtcddjsioiSEA8ytshyj3bxfXeZZSA5yVwzXpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kuxGEW9I; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kuxGEW9I"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3bfd27f6dc0so561657b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 08:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707494476; x=1708099276; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
        b=kuxGEW9Iyhb5DCm4aJ4saXLIFS3HvjyxDkriM9z+SrmKRggFMdvJQOzCdh+aU6F1iL
         SjCTrai7oaUz//0yfBwgy8jHPVnNWih21QcethLxtD27/WrOejNqC3i1xw7uuehBYrFE
         tmT4wBSpk1nHplYa+/VrJ+Ko7s8I/FOTCIJv0e6acFOZDZBFr5s3Lw+O5htLA3PYgg1f
         wKtgk4g046wAYDlFP/9FE9HMEy+wygpx3LmAl1LsHSbRn7K9ueEYDKV0/e+FHOykuncC
         Owm3ZWum6JdsQKykuI3IhgwYNtBri6zBhB2H5sFSRzAvMX6Fgi1pE0FCCbrzURH0yDrZ
         RdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707494476; x=1708099276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
        b=IFVfgq7Qdr8hTrKO5VYtptfP2DyrBwgAvzxCL0VV25ITwiDTxXsw35XG/TzZQm9dJw
         X3RRZC6qTKQhomhkR4rolXWhU1ZyQH4TiE/egoiBPzf4TPsAqnlk3ndQr4gpfhSAyGSX
         RzuCjjveZFuEJRwPS4EnCEJaJP051SfSo3HwUwYfLwTEeFenzitV4z5AaLtFahVRFkS8
         vArck/EEWTSGaZ1TA2ECaTYzCfo6ouuvccwJoBU9Hgqc80XcfSb7nfdPm3AtOHp4KYul
         Fud/6tKIGTuosoFu76MdxGCxmOGgB67NQyFrMyWCQC2i+W2wzgOu+6TlHsQqt1kE0HJS
         cwkQ==
X-Gm-Message-State: AOJu0Yx78GPp6vjIAsUULqqG+r5vPrqcHKAFwqmbjlcr/HxhIIqqNAy8
	b120h8sfGLY9qXGTzGv8zLXSBu0WDSK7nG5ipx5uR5aMJGqq0Nszs/1bxyDmmqwvpcM6Q7l+zwD
	4D3/omAcVgm/XuHB2bUIkXVmQlczYXVkN9Csy
X-Google-Smtp-Source: AGHT+IGMzobIrEgwax9OJLArVtPMh63+jV60hRyd1mTmkkI5+jbhHei18a99n8eXpND7phU8QcXSWqNBdUQ2ajSqokc=
X-Received: by 2002:a05:6870:414b:b0:214:44cf:a824 with SMTP id
 r11-20020a056870414b00b0021444cfa824mr2454691oad.32.1707494476045; Fri, 09
 Feb 2024 08:01:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <ZcOl4PTbobZTsuNW@google.com>
In-Reply-To: <ZcOl4PTbobZTsuNW@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 9 Feb 2024 08:00:00 -0800
Message-ID: <CAF7b7mp=oUzDtD6Kph3fEGAo1KAHKF6RipyfSEd3SvxGW8K4VA@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] Improve KVM + userfaultfd performance via
 KVM_MEMORY_FAULT_EXITs on stage-2 faults
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:46=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> A few nits throughout, but this is looking good for 6.9.
>
> Oliver / Marc,
>
> Any objection to taking this through kvm-x86? (when you feel it's ready, =
obviously)
> My plan is to put it in a dedicated topic branch, with a massaged cover l=
etter as
> the tag used for the pull request so that we can capture the motivation/b=
enefits.

Oliver and Marc,

I have a v7 ready based on the feedback I've received so far- please
let me know if I should send it or wait for you to take a look at this
version first.

On the one hand I obviously want to incorporate any feedback you have
for the next version, but on the other I suspect that if/when you look
at this you'll want to see a version with as few (known) flaws as
possible
