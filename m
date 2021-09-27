Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CC0C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 558DA6108E
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 558DA6108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B153B4B0C5;
	Mon, 27 Sep 2021 13:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KRQbxqOcpJiK; Mon, 27 Sep 2021 13:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA51149F5F;
	Mon, 27 Sep 2021 13:25:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A94FF4083E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DfzVzRi8m9fh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 13:25:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97460406E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:25:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632763509;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=kNKGhtUzyDvvasjBG+sOupwAerMdbRFrkMWzt1aAAJI=;
 b=NzPFSILRn3+n/MA8Yj37irH2PINx2BoHPciay6QK/gaNz2uGPUuEq2USjARuQwNjfZOQ6q
 sl3bvdxZR0ctjM6akZit9KpiW3paU7YaUbve0omh3a4bJaS607Qi35/OwMmiEt3qRJ7vSg
 mO+kT57TfZoG73o2akyRbt+M1HAoY8E=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-p0wYa2vrMmGr5yFLKOqpzg-1; Mon, 27 Sep 2021 13:25:05 -0400
X-MC-Unique: p0wYa2vrMmGr5yFLKOqpzg-1
Received: by mail-pg1-f200.google.com with SMTP id
 t28-20020a63461c000000b00252078b83e4so13328306pga.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kNKGhtUzyDvvasjBG+sOupwAerMdbRFrkMWzt1aAAJI=;
 b=NizS/o/UE5UzWCgvb/pquFtwS7sihi+JziDwiYm8/BrELDnpbukeoxBWOb/vxAiUCY
 jyIAlzE2CdmMKlYqtGbJXar3IJiYXaGPymAMLV2nIHCXb6lHXGN+1o21TUuthYttC+c4
 nN56WirsC9rwdz0z1WDjGirIxwmIyN+wEs/m06SB8m6OvAgEkG5v1eScT8p7l0LeN9Ni
 WQ2ZQsa1dv0CNFDZ0erYMmb7IqwSUrKpOleyof5QrAIVtyWglK7Piez8CLn58m2hUHNh
 rG5xxIjACjZITnkXaYZ4irQ3LgeOmLwmB8Ke0Ac43GzfGjOESjNsFCU7GX/mL5pxzPbs
 NH6Q==
X-Gm-Message-State: AOAM532HEb5xsIdXy7ZzbUQ/ULHA3ZFF0YF83Zdyk+oUEgt2VIDZKCto
 btMlCOYh7MFKK0Il3gD7M3FGlQTa/TV3BIEOzK12QsafsQe5E2YaVw0DKQJaukPyjn04NnixKgQ
 gfIMtNJ2LGQi49YhglUCL7FM6isbRCkLA+Jo7tlng
X-Received: by 2002:a17:902:e752:b0:13b:7e90:af8b with SMTP id
 p18-20020a170902e75200b0013b7e90af8bmr1093617plf.12.1632763503578; 
 Mon, 27 Sep 2021 10:25:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnpQIKn1XEdvXS3sloEadlAQlrcu/KIkFx7e5cSy37I6kVkSfvfoO+V88kOShJrVeyAcUnkFvhI3opAAyj/w8=
X-Received: by 2002:a17:902:e752:b0:13b:7e90:af8b with SMTP id
 p18-20020a170902e75200b0013b7e90af8bmr1093572plf.12.1632763503267; Mon, 27
 Sep 2021 10:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
In-Reply-To: <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Sep 2021 19:24:52 +0200
Message-ID: <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: Christian Borntraeger <borntraeger@de.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, "Kernel Mailing List,
 Linux" <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc <kvm-ppc@vger.kernel.org>,
 David Matlack <dmatlack@google.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> > So I think there are two possibilities that makes sense:
> >
> > * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
>
> what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.

Yes, that's what I meant.  David pointed out that doesn't allow you to
disable halt polling altogether, but for that you can always ask each
VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
don't know about Google's usecase, but mine was actually more about
using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
