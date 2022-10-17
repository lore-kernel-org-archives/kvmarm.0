Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71A4A13
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 23:32:16 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id b2so12200026plc.7
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=F+yBv0RGEs1uHSlcASeYzkmfiO3HlUUL+vK6CaQeIzFOZDVhe0B29Z1p+kOHP8MTUF
         PA6gZ+CdvkPUGO+EFkObZbMC8FmvuVtvT6zSiXPoMI5fl5FDj8MVa8zQSvOg2IFpB8RP
         AOQLTr5qrZxnj0MSBCZgZ2KXjAknKQUEBNRkYYjRWKZFxs+NvQuAWbQWYQACv/F7rrtF
         LRssZVXll7ne94CKR2rhBma/JDcvwwp/298TdJGd1teoIFdI0CKCxrFTADHO4EXJ3mUP
         mi4W+bYDdy6LaGXzUTxgAllXYO5sTMpBqUcrtS+nhCJO//wbHeuY1pKecwlu+uKqU6Mt
         YlgA==
X-Gm-Message-State: ACrzQf2oHFg9lRpi1ZuKMq5wK1dMcEZZPB1sTpSXbwvOPeFlXwLnpi5Z
	wbswj8tikqJ1Y88r9WBe6169VQ==
X-Google-Smtp-Source: AMsMyM7KQ54TM4Kkd7qdZQ0Pj4PW+GQXkGsSErIdlOIyRTcsTKekXEdVRC4SMmndV5RcbZYqd4SEFA==
X-Received: by 2002:a17:902:bd47:b0:17f:685b:27ee with SMTP id b7-20020a170902bd4700b0017f685b27eemr87911plx.22.1666049535619;
        Mon, 17 Oct 2022 16:32:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g186-20020a6252c3000000b0055f98a2c64bsm7948994pfb.142.2022.10.17.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 16:32:14 -0700 (PDT)
Date: Mon, 17 Oct 2022 23:32:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
	shuah@kernel.org, oliver.upton@linux.dev, peterx@redhat.com,
	ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
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
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
Message-ID: <20221017233210.jlX-V5HK4eWOJ3GORurBMU9qNrDphPLyQ4SOY_74bas@z>

On Tue, Oct 18, 2022, Gavin Shan wrote:
> On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
> > On 18.10.2022 00:51, Gavin Shan wrote:
> > > On 10/18/22 6:08 AM, Sean Christopherson wrote:
> > > > On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > > > > > +#define MEM_EXTRA_SIZE        0x10000
> > > > > 
> > > > > Also, an expression like "(64 << 10)" is more readable than a "1"
> > > > > with a tail of zeroes (it's easy to add one zero too many or be one
> > > > > zero short).
> > > > 
> > > > +1 to not open coding raw numbers.
> > > > 
> > > > I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
> > > > 16KB, 64K, 2MB, 1GB, etc...
> > > > 
> > > > Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
> > > > math off of those.
> > > > 
> > > 
> > > Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
> > > right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
> > > if it looks good to you?
> > > 
> > >      #define KB         (1UL << 10)
> > >      #define MB         (1UL << 20)
> > >      #define GB         (1UL << 30)
> > >      #define TB         (1UL << 40)

Any objection to prefixing these with SIZE_ as well?  IMO it's worth burning the
extra five characters to make it all but impossible to misinterpret code.

> > >      /* Base page and huge page size */
> > >      #define SIZE_4KB   (  4 * KB)
> > >      #define SIZE_16KB  ( 16 * KB)
> > >      #define SIZE_64KB  ( 64 * KB)
> > >      #define SIZE_2MB   (  2 * MB)
> > >      #define SIZE_32MB  ( 32 * MB)
> > >      #define SIZE_512MB (512 * MB)
> > >      #define SIZE_1GB   (  1 * GB)
> > >      #define SIZE_16GB  ( 16 * GB)
> > 
> > FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
> > 
> 
> Right. I checked QEMU's definitions and it makes sense to use
> KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
> our tests don't use that large memory.

Ha!  I had typed out KiB, etc... but then thought, "nah, I'm being silly".  KiB
and friends work for me.
