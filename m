Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F0BC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 23:32:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDCD4B712;
	Mon, 17 Oct 2022 19:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1JJekxdJBJTb; Mon, 17 Oct 2022 19:32:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132074B743;
	Mon, 17 Oct 2022 19:32:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3FF4B712
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:32:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8JgquinQTkEL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 19:32:16 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DACB54B6E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:32:16 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 o17-20020a17090aac1100b0020d98b0c0f4so14319805pjq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=yiFrNuPRLUt6X6xjKV68iAAf2ofz98aq5uXkbPkmdVk=;
 b=eT3nz9X6K4lR28izSZqgJLzSis/D5+BWPs1OkKQffM8Wy32Rm9GqE2SOwSMPx04Cfr
 OMWNKwL0D8G3pxScE3+PGWFfsT3zOh+BqzjBtvO7EEzy5RFMDRVpg8XgWSndERImRzzu
 vAvuBeZgTD9Xfqmv7dh3BB4iYCzbXeiOcBklgM9VG5nQilAZdRxOsaZojDOXksxYyEw9
 +e52fzM+t+ipCJ2Te/D2uf7AUaYDY9Sne7nvrR757h8hvFmSnXV77N/B5k1RSkYKVcLP
 00Mmhjn8/Dd0lznVbkTJaZJZsmM/hdSDugo6JEY2h3efQc65xD2HiMYC0a3shGPvSHZt
 nznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yiFrNuPRLUt6X6xjKV68iAAf2ofz98aq5uXkbPkmdVk=;
 b=f7FoRnt0Kq2sxTL+wexOF74IkGvn8j1ErIJJIrAgN7UIKveHHJErnBmGFyv66IDOWr
 t60BYwt6D3t2tdRvlcZXcYC4SuITftx6Sem1DWEbdugdvexnBNO5ChEXIIf0AQMm7gId
 tN6purxhSpFJb3CfLD6M0jx6bxrJNTjCX9dTIE5P3jsv7nxbXUJbp6byOTUVBFb5lnNg
 ocGvFbHzNgdFFkrCYi7GpTQCqeWdvS9VpwT2kgT7hni8LgJ2yPM6b6hW2Q371pU7WEvV
 faQ1x0pm/c75ZNsSxD7jUvEChC1Chsaq2S7OhWotKfrlVxCW87wytMTuJKOaOvLMx3/W
 DGvw==
X-Gm-Message-State: ACrzQf2dJZrsnbU3irlgBxpVWZ8+aHgpuokk8TwwaOEm2oDwquE/UbjW
 KWi8oPrQ07p2l/nUurPA3UTbMA==
X-Google-Smtp-Source: AMsMyM7KQ54TM4Kkd7qdZQ0Pj4PW+GQXkGsSErIdlOIyRTcsTKekXEdVRC4SMmndV5RcbZYqd4SEFA==
X-Received: by 2002:a17:902:bd47:b0:17f:685b:27ee with SMTP id
 b7-20020a170902bd4700b0017f685b27eemr87911plx.22.1666049535619; 
 Mon, 17 Oct 2022 16:32:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 g186-20020a6252c3000000b0055f98a2c64bsm7948994pfb.142.2022.10.17.16.32.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Oct 2022 16:32:14 -0700 (PDT)
Date: Mon, 17 Oct 2022 23:32:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y03l+kwGxNW1Icp/@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
 <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, kvm@vger.kernel.org,
 maz@kernel.org, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 shan.gavin@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Oct 18, 2022, Gavin Shan wrote:
> On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
> > On 18.10.2022 00:51, Gavin Shan wrote:
> > > On 10/18/22 6:08 AM, Sean Christopherson wrote:
> > > > On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > > > > > +#define MEM_EXTRA_SIZE=A0=A0=A0=A0=A0=A0=A0 0x10000
> > > > > =

> > > > > Also, an expression like "(64 << 10)" is more readable than a "1"
> > > > > with a tail of zeroes (it's easy to add one zero too many or be o=
ne
> > > > > zero short).
> > > > =

> > > > +1 to not open coding raw numbers.
> > > > =

> > > > I think it's high time KVM selftests add #defines for the common si=
zes, e.g. SIZE_4KB,
> > > > 16KB, 64K, 2MB, 1GB, etc...
> > > > =

> > > > Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB=
, and then do
> > > > math off of those.
> > > > =

> > > =

> > > Ok. I will have one separate patch to define those sizes in kvm_util_=
base.h,
> > > right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let m=
e know
> > > if it looks good to you?
> > > =

> > > =A0=A0=A0=A0 #define KB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 10)
> > > =A0=A0=A0=A0 #define MB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 20)
> > > =A0=A0=A0=A0 #define GB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 30)
> > > =A0=A0=A0=A0 #define TB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 40)

Any objection to prefixing these with SIZE_ as well?  IMO it's worth burnin=
g the
extra five characters to make it all but impossible to misinterpret code.

> > > =A0=A0=A0=A0 /* Base page and huge page size */
> > > =A0=A0=A0=A0 #define SIZE_4KB=A0=A0 (=A0 4 * KB)
> > > =A0=A0=A0=A0 #define SIZE_16KB=A0 ( 16 * KB)
> > > =A0=A0=A0=A0 #define SIZE_64KB=A0 ( 64 * KB)
> > > =A0=A0=A0=A0 #define SIZE_2MB=A0=A0 (=A0 2 * MB)
> > > =A0=A0=A0=A0 #define SIZE_32MB=A0 ( 32 * MB)
> > > =A0=A0=A0=A0 #define SIZE_512MB (512 * MB)
> > > =A0=A0=A0=A0 #define SIZE_1GB=A0=A0 (=A0 1 * GB)
> > > =A0=A0=A0=A0 #define SIZE_16GB=A0 ( 16 * GB)
> > =

> > FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
> > =

> =

> Right. I checked QEMU's definitions and it makes sense to use
> KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
> our tests don't use that large memory.

Ha!  I had typed out KiB, etc... but then thought, "nah, I'm being silly". =
 KiB
and friends work for me.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
