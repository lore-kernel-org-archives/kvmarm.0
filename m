Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A950311CAD
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 10:41:10 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3f6e1393f13so30524495e9.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 03:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686566469; x=1689158469;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9tBU14E6VKx0YubCyPNQ5lyogOgkdDtf33E5BuQuYsw=;
        b=Z34TIB7boruHotdH1rDFRTTBoMFSIB3TD1z3RGNuQby4W3EPnvTgahzb+MdVcxwQQX
         Nce8Ks1ZZEIb5KD4NibYq6f9CHonGjatKr4HhjVQs7vUim1dk7qEIAXJLBpFBGankPJZ
         WbKh87PbL6mx9P6ZabQZ3LLksG2HGBW5xTJIG/Zptjco4oeDJDtBVDp4KS9p5HZ9MSTy
         jPkhpkr6/olSSW5qE24BYkiTmg9qLqyPMgerD7Q9m7LnQYrP8uO0xzFaqX5Qju1FOfMb
         IsEeABUcW1zB80CEsKm/f8RjjF8g+/P1g3ngyABpxGwxklRSHHHXffdsb69FgyopVund
         t7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686566469; x=1689158469;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tBU14E6VKx0YubCyPNQ5lyogOgkdDtf33E5BuQuYsw=;
        b=CRbkJi8bCnjuR99L/ai4OGjOKHfEUXJXBPkZULEtOajiyjsotaUJWOzVlRUaJvaBUM
         nUPfk3KhIqY+wcuR/GgKlKaa5Y7valJGdNbOtpLlfuNktO1GCXvBYYAmTHlGIqPl0ore
         4WgoQwSTIoDtWoR/qCN8/t3Ek+u7plUErRtzVw57WSaIuTOFfuuiDsDBcgJGupB3B4sW
         Al8wPmdXfc/dFArusWaAtqYPFSSD7W/qJu88r0ynGHAP4v0dB+rAF09m8W+X+PKeqlZd
         loYmpxo2IZN/KBtNLXc65AotGm3suCkgVCdmmINIb6lU5XNzKFJj0sd3lcw8WZKwBYtv
         0vBQ==
X-Gm-Message-State: AC+VfDweOQYhZ4aUiTeAcdPnuSs9RNAhsQvfaxyUiY4pWPxqJFia0LLq
	9u/KBHYYp+2krN8eIjPuI2G9sw==
X-Google-Smtp-Source: ACHHUZ5J1iNkaETbBu27FRv7AwM9V8iffK4aOJ+xUv7HDf997VyUZog9DPqRi/Gu9HT6HBxNqGeljg==
X-Received: by 2002:a7b:c318:0:b0:3f7:3074:d2f2 with SMTP id k24-20020a7bc318000000b003f73074d2f2mr6479793wmj.34.1686566468731;
        Mon, 12 Jun 2023 03:41:08 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m9-20020a056000008900b0030ae499da59sm12039371wrx.111.2023.06.12.03.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:41:08 -0700 (PDT)
Date: Mon, 12 Jun 2023 12:41:07 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, 
	Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com, ricarkol@google.com, 
	shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230612-a9f763ef517c2c5fe728bc38@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>

On Mon, Jun 12, 2023 at 10:52:00AM +0100, Nikos Nikoleris wrote:
> On 12/06/2023 08:52, Andrew Jones wrote:
> > On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
> > > 
> > > > On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > > > 
> > > > Hello,
> > > > 
> > > > This series adds initial support for building arm64 tests as EFI
> > > > apps and running them under QEMU. Much like x86_64, we import external
> > > > dependencies from gnu-efi and adapt them to work with types and other
> > > > assumptions from kvm-unit-tests. In addition, this series adds support
> > > > for enumerating parts of the system using ACPI.
> > > 
> > > Just an issue I encountered, which I am not sure is arm64 specific:
> > > 
> > > All the printf’s in efi_main() are before current_thread_info() is
> > > initialized (or even memset’d to zero, as done in setup_efi).
> > > 
> > > But printf() calls puts() which checks if mmu_enabled(). And
> > > mmu_enabled() uses is_user() and current_thread_info()->cpu, both
> > > of which read uninitialized data from current_thread_info().
> > > 
> > > IOW: Any printf in efi_main() can cause a crash.
> > > 
> > 
> > Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi and
> > put a zero_range call, similar to the one in arm/cstart64.S which zero's
> > the thread-info area, in arm/efi/crt0-efi-aarch64.S?
> > 
> 
> While I haven't run into any problems with this in this series,

We're fine on QEMU, since QEMU zeros the memory.


> I had in a
> previous version and back then the solution was this patch:
> 
> 993c37be - arm/arm64: Zero BSS and stack at startup
> 
> So I agree we should drop the memset and call some macro like zero_range in
> arm/efi/crt0-efi-aarch64.S.
> 
> Let me know if you want me to send a patch for this.

Yes, please, but we also don't have to hold this series up by it, since we
agreed that this series was focused on EFI over QEMU as a first step.
We'll need to worry about zeroing memory and more when we start running
on bare-metal.

To be clear, the patch for this can be on top of this series.

Thanks,
drew
