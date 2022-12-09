Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67824C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:07:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D77F24B915;
	Fri,  9 Dec 2022 12:07:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OxidNwpCOc7L; Fri,  9 Dec 2022 12:07:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67894B984;
	Fri,  9 Dec 2022 12:07:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 678374B943
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:07:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 380nQTWdRhJK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:07:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E38FB4B915
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:07:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670605646;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
 b=KTQEbWzI2fpNN/pK8TzTknALfIyGTnoAIquWcRivhRsnKakVH1E2GCcRqCj65ACFzWkhx9
 Iu8H8I0fVl8dcDmDUxfGthsPQDePOPW/JR2Pt2RGjcPUrB7r2e9+fQUDRIueYWxYc1/wbV
 ZWGXF392nxCovD61beHKZKjlRS4Sxw0=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-g4PFxmEcN8iTXCjf31VIKA-1; Fri, 09 Dec 2022 12:07:23 -0500
X-MC-Unique: g4PFxmEcN8iTXCjf31VIKA-1
Received: by mail-vk1-f200.google.com with SMTP id
 d137-20020a1fb48f000000b003b81c572136so1861560vkf.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
 b=Cr5NXa0ld+Odq6M++ZkS4Do6TcFREXfRDG5WPMojf2keB1TKv5LGlTRupI+J6yGzvN
 dWoiYdu8v2rdPhI0WphxDozbSODC3CgcMvd08IrGJCrOkVNvHb7htaT5poJOZGnwUUYr
 4RLOLeHuYMD64u58GElx1X/snj2W9n8jFZKPv2yBrh4m3vbLNlmr9Q9YASdPv13ieruh
 CuVTwhIFgvYr9nkyF+kCDyaOoi5U17euwjWvGksjK88d5G3tacIjkk/8nKJnICk49PYM
 Bd4rVVgnuZ0Q5DaCXERN0k8cMZWy/O7wivV/8q+JIfcsvro1nwkMqpbbtxH4d0paMdgF
 EKPw==
X-Gm-Message-State: ANoB5plUKFRql31cQsP+nY0c6mLv7Yx8w6uynR1BYb+iXg33KrZXDhnh
 JoSQF1PWkwc+U86qBM0OvQxTB2Zw5RC0TCYYAuCr4lALgmStfs/OQ76IbamQdccu/8+iWPTJDlX
 4sno46ULF75MOls8h2y95FTf9oxr4G6bxTtzpXAkg
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr45546855vsp.16.1670605643013; 
 Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5zz6uhq0KfiH7V7TqkPbJSPeXdssw5wlXfqjy07mP6JlwmbeZfTCfhWp5bmBRLBRYOfMVw/rtjU5EJ/PG8pbE=
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr45546820vsp.16.1670605642739; Fri, 09
 Dec 2022 09:07:22 -0800 (PST)
MIME-Version: 1.0
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
 <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
 <Y5Nq0a2JxUP+JuP+@google.com>
In-Reply-To: <Y5Nq0a2JxUP+JuP+@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 9 Dec 2022 18:07:06 +0100
Message-ID: <CABgObfbAwaseKFYUSAwowGzP7Hh4bw6QDZrj+76HJ9pzHP3Jtw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Oliver Upton <oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Fri, Dec 9, 2022 at 6:05 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> Mind dumping what I had in v1 and applying this instead?
>
> https://lore.kernel.org/kvm/20221209015307.1781352-1-oliver.upton@linux.dev/

Ouch, five minutes too late... I can take care of the difference but
it'll have to wait for Monday.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
