Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE7323D
	for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679926947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyn1Z4Cm3Qnn1B5gjs0PMw218V0pgoJF2q9YZrci5IA=;
	b=dfxq7n3PnTXeg3Efz7F3Hi7lcQv+dDfdqIBSurLjvDdZ3zhg3DpHRi26SYtyBieCcH7sFx
	Tx5tRFPFc4VoxANfBL1BFsuzzSyOORWzEw//xqhzuargqaSVKIkUuOWtS57nJqGNyS+6T5
	Lz2o3CDX1R3W9rcQeIGpk/aGHD2phdE=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74--NEpkpQkP4imjlPozW7HcA-1; Mon, 27 Mar 2023 10:22:25 -0400
X-MC-Unique: -NEpkpQkP4imjlPozW7HcA-1
Received: by mail-ua1-f70.google.com with SMTP id p6-20020ab01ec6000000b00764be254863so4192522uak.8
        for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 07:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyn1Z4Cm3Qnn1B5gjs0PMw218V0pgoJF2q9YZrci5IA=;
        b=jdHweoGs6fuG2QvT+NlYhbavdyF4BoIl4kgTS7zd4kP9sCdcPdHSgAH+FIuEDxAAcE
         j7UVb5N0wxPo4iHJuzxFDQabmXv3v+ayD8nEWv9W5wS4g1Ffi+hYqGtXe2qxS3vXS/DA
         9X0R9UUmr7xsnxCCchYfYPZgfXRijFtwLO0JakmH+6p0MJCi17zWirDMP5Ea6vhpHCjf
         IS5i2tuzVk+PNv1taEQOs8+6J839NPKbK3jxIcu7POA293qOpdGOUql6Q78x5R6Xn0Qi
         EV60mPrh9tU5ch67KWPcnsH1R/bTbmDRHF4rckCbm0UJPplYl2Y9t9evZGWKLHojGcpz
         FcHg==
X-Gm-Message-State: AAQBX9dW9glfzO0sVnXnt7FWaQDB703zsjYbBWUwD8nHuw1qlV7KlOc2
	JiZgmOrSVlIj7FWshvtElm8XhQ3YzYCHRm++GKnDUKts8OW2v5B7CdCph9yBnf1TR/CtzRZGFfx
	/w/bv8CfYcZn3PBIcbp/6r5UOJw/VlmY4
X-Received: by 2002:a67:ca87:0:b0:425:d255:dd38 with SMTP id a7-20020a67ca87000000b00425d255dd38mr6251392vsl.1.1679926945219;
        Mon, 27 Mar 2023 07:22:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350bl07pHGy/zP3d2BdHOczsEcEI97K10LYgkyXfU7tsU+NpG6dVmvmQkJy6N40BAAu9eE9DlNDALHagepcKfrtM=
X-Received: by 2002:a67:ca87:0:b0:425:d255:dd38 with SMTP id
 a7-20020a67ca87000000b00425d255dd38mr6251374vsl.1.1679926944945; Mon, 27 Mar
 2023 07:22:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZBPZ4D9MIsaCNDh6@thinky-boi> <ZB3o/jsQIwS+4g4E@linux.dev>
 <86v8imwhi1.wl-maz@kernel.org> <49385a34-6ad7-255d-68d9-6b41a76f01df@redhat.com>
 <86sfdqwa9h.wl-maz@kernel.org>
In-Reply-To: <86sfdqwa9h.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Mar 2023 16:22:13 +0200
Message-ID: <CABgObfYYxznmrV1_ooDvjnDwXvL5EY=xF59Fs2stQOgnaF8Y5A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #2
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, reijiw@google.com, dmatlack@google.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2023 at 4:15=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
> > It missed the pull request I sent on March 17th by a few hours.  I
> > have queued it now and will send it to Linus later today.
>
> Maybe you could help us here and state what is your schedule when it
> comes to sending these pull requests? It would certainly help
> coordinate and avoid wasting 10+ days to get things merged.
>
> I appreciate that you don't need nor want to wait for us to send
> something to Linus, but if we know when the train is departing, we can
> make sure we're standing on the platform early enough.

In general, sending the pull request to me on or before Thursday will
work best, though I have no problem sending stuff to Linus on Sunday
morning (so that architectures don't need to time their request too
carefully).

These weeks my Friday afternoon was more free than usual due to all
meetings with American people moving one hour earlier, and that
translated into different family plans for Friday itself and over the
weekend.

Paolo

