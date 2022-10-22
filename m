Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13AD7C
	for <kvmarm@lists.linux.dev>; Sat, 22 Oct 2022 07:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666424033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
	b=RdWg+9QuELbf9wsYlcgHsN3adTlnewUzl0JvRY8HhTwRUKAt9hH3HbjEc8Ymhq4c7LWU1M
	59/2UNQbryi+4DuFMYHX4Qg1GdCbOAOburG5EJaj73HdCE8tZNKaefQDQgS11ffMQzR1xI
	sDYYs9CAQW7J8ik8cP1VKs6myROUDVU=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197-_Tyk3jJCN6WX3-Pi3jBjsQ-1; Sat, 22 Oct 2022 03:33:52 -0400
X-MC-Unique: _Tyk3jJCN6WX3-Pi3jBjsQ-1
Received: by mail-ua1-f70.google.com with SMTP id k9-20020a9f30c9000000b003df15f05649so2976169uab.6
        for <kvmarm@lists.linux.dev>; Sat, 22 Oct 2022 00:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
        b=QKyqI2AC0sBpJ+Jr3j6HTBxik6QmFDIV01LresNBdl9bk2TRs2C9Ke7V5IDl4s/Sja
         qU9nQVWmSccOWbi2y0Z0JF0Mur1Cc9Rp/VVWcCcB5rDbllRbhJWrVCAY4PQI87Jdva2h
         B3OChv4ufEfsLQv/+zYWE4baRKdYjjTo5c3XIy+MBCOfHr6jHPvG3wS7Qtx/2mVlleca
         qfNm8rJ3BDuwysQyo9eTnDKXbSBG8rbM+GqPLEodcOQbLC1ZLLYWPGyLMmNr6df9uYBG
         vZU+5J0Yr6qFAktwR1IRosBFjUpn27Z4QPPU0Q6oUnYrw0ejflvn7s3GmOwgfhn4ws5X
         niQQ==
X-Gm-Message-State: ACrzQf3DoGxAKlkjHo7oPnqcsvAG3L+dsfjLScFREsA3+G60G/qhW4i8
	fRLP/WXNCGorGYnCZAGwvano/Wuj52xWSrBCyP9+TdbPh0LfW6/wNOmPfMFoyeaI3L7P32NAQSU
	GPJLA8ZgM7wmgG2abKTgNdHeXjvQ7O43J
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id ay9-20020a056122180900b003aed68e92b8mr14353339vkb.10.1666424031900;
        Sat, 22 Oct 2022 00:33:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XJ6Px8OxHtSAMMDOSIaZ7WomWjAkS8tov7b+lxHhzJeJhpDcwPk1Rbhq4f/pfEg9kswJ6CRijofNfOryUOu0=
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id
 ay9-20020a056122180900b003aed68e92b8mr14353325vkb.10.1666424031644; Sat, 22
 Oct 2022 00:33:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221020100125.3670769-1-maz@kernel.org>
In-Reply-To: <20221020100125.3670769-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 22 Oct 2022 09:33:40 +0200
Message-ID: <CABgObfYexXFT507Ufz3o2SLOAVDWO1AhJV5yKi9Ar1OeLNnPSQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Denis Nikitin <denik@chromium.org>, Eric Auger <eric.auger@redhat.com>, 
	Eric Ren <renzhengeek@gmail.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221022073340.6ZumrIrUXeL8BRqWyTbylIDc6yTnR1S8A_Xa3d0jN0U@z>

On Thu, Oct 20, 2022 at 12:02 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a couple of additional fixes for 6.1. The ITS one is pretty
> annoying as it prevents a VM from being restored if it has a
> convoluted device topology. Definitely a stable candidate.
>
> Note that I can't see that you have pulled the first set of fixes
> which I sent last week[1]. In order to avoid any problem, the current
> pull-request is a suffix of the previous one. But you may want to pull
> them individually in order to preserve the tag descriptions.

Yes, that's why I did. Pulled now, thanks.

Paolo

>
> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/r/20221013132830.1304947-1-maz@kernel.org
>
> The following changes since commit 05c2224d4b049406b0545a10be05280ff4b8ba0a:
>
>   KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-2
>
> for you to fetch changes up to c000a2607145d28b06c697f968491372ea56c23a:
>
>   KVM: arm64: vgic: Fix exit condition in scan_its_table() (2022-10-15 12:10:54 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.1, take #2
>
> - Fix a bug preventing restoring an ITS containing mappings
>   for very large and very sparse device topology
>
> - Work around a relocation handling error when compiling
>   the nVHE object with profile optimisation
>
> ----------------------------------------------------------------
> Denis Nikitin (1):
>       KVM: arm64: nvhe: Fix build with profile optimization
>
> Eric Ren (1):
>       KVM: arm64: vgic: Fix exit condition in scan_its_table()
>
>  arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
>  arch/arm64/kvm/vgic/vgic-its.c   | 5 ++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>

