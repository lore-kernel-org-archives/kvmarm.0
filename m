Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492C620EB
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685819705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnPK8tVOnIu5iVyOmiMdqzb+Fu0aARjMaEhuhDTR2qQ=;
	b=evwIt6HB6zREOV39/oEnVfIpubggDSG1OS+a/wmMtGOzj/7lZcfsw/5PSJPZjSJ1hJLotf
	5ivlW8P2+hZeksTsUmoR/R3MwZvAKQ1y/UQuq7pKD2VLegNyU41qKKDKyIZyBCsZRcaPaD
	SHMY2zFqY6p9dC08a4ipQhnu9/tvoqQ=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-_-2_OhGAMBSIaTS0ev9p1w-1; Sat, 03 Jun 2023 15:15:04 -0400
X-MC-Unique: _-2_OhGAMBSIaTS0ev9p1w-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-437e78027a9so732149137.3
        for <kvmarm@lists.linux.dev>; Sat, 03 Jun 2023 12:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685819704; x=1688411704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnPK8tVOnIu5iVyOmiMdqzb+Fu0aARjMaEhuhDTR2qQ=;
        b=Xc2YnIft+K+w/MjTto3Gm6dfYASYZbgXcPvAbgNYxVD+kimR/eF4lOWe/WtRMz15iR
         HoEaZRUqhnPyWfJJgdlBCPc1jNuM/OIGfJm1KiRwaCx2hcirREIbaNHsf6BYURihhxDK
         ve0JaYzQStEp5gw7uEO7Jk+gfSlev3vwuCLxVLjrEMjhGmZcRjvWmmrkgw/XXplUxMMa
         hgDLw1KfuZtJBOtAmG5uqY5DbjOLdJQjNugKqsd3HAoOCiS/E4uuvtsp1Y9CiZeB3vNT
         VR1or97ocmo0W6eExWOu620QvM0uXTXwAAaoKPgT0saO3fMiIcDDuJ90Av1rZ+CURFa8
         r0Lw==
X-Gm-Message-State: AC+VfDzBHOwjBKqDn4vU0J0ARk6qDFEm1d9plmI/CdYuAqdzs2wbXS4p
	XkgPwvWMhUNlHRRKUuj6CT9RJP159rSSyL6OxWGkW4UlynRm20mM1b+AiWyGWzbBQd8FiiXbCB5
	iqrpuVPYZKnWmzNhK64MhSZJQRwItxchW
X-Received: by 2002:a67:f516:0:b0:43b:1a6e:b105 with SMTP id u22-20020a67f516000000b0043b1a6eb105mr3300215vsn.13.1685819704085;
        Sat, 03 Jun 2023 12:15:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Bst0bhcf5pkOuZSlY76/be3DNNv46RicRmDFmPPFPfvt9ff7FUTtG4TIWehE6uZmToXLR2lgL8HtrGGGuonY=
X-Received: by 2002:a67:f516:0:b0:43b:1a6e:b105 with SMTP id
 u22-20020a67f516000000b0043b1a6eb105mr3300212vsn.13.1685819703859; Sat, 03
 Jun 2023 12:15:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524125757.3631091-1-maz@kernel.org> <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
In-Reply-To: <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 3 Jun 2023 21:14:52 +0200
Message-ID: <CABgObfY5igVKMre4Ze21XrGffuG9wEa1ROpLDqk8_4PNi0h7xQ@mail.gmail.com>
Subject: Re: [GIC PULL] KVM/arm64 fixes for 6.4, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 4:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On 2023-05-24 13:57, Marc Zyngier wrote:
> > Paolo,
> >
> > Here's the second batch of fixes for 6.4: two interesting MMU-related
> > fixes that affect pKVM, a set of locking fixes, and the belated
> > emulation of Set/Way MTE CMO.
>
> OK, $subject is an indication of what's on my mind...
>
> But please pull anyway!

Uh oh, this was not filtered correctly. Pulled now, separately to
preserve the tag message.

Paolo

