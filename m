Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A8D1E9B20
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129111; cv=none; b=t/D1utVKXXJXs4zOPCIOJgev2fPRn+/9wNZacYEeliNjcWNLM4zyE/Sur6TxhmyVi4War4QahPN61zX33M3XYD4scgE6kDT5HpPEPMlhN7TrnaJDKKDqLhpGN9dIk6v0btxyhogGj1Pgus7AKwfZyrNYijSmhXtx4ZtmHxVoCYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129111; c=relaxed/simple;
	bh=RrcEdIyZNciAODvcFKa5vjo61fBJQKPTlCzq4PSDlaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkZPI75XAXt4prO5IZar3+DIPaYyvBZGWGV2FRIoXTH7tNISti7CBHS21jtr8e3Uv+KdXThteYF3NZpfqe5ln57O83jZcTRbIcxV335J5ice/HaDnL8zEYoXn0Z6rXdhCQA0l4HhnnkdXApSYR37E5kx4enQc6Y51T8dvn1sGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsdssAK8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsdssAK8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747129108;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KrX5dQOsiuTyKGPiD7lJuvLzjNro5fZEtw25f9WuCU=;
	b=KsdssAK8VOj5OopTwWSPW6ugRZTjZJ2BXyRumBPBVdCEDPXm/IA+83osxJpFdBuIOPSCMl
	mtUF61+4thWBxxe7S9pEuby19aaghJymNzxNvgQHxSotvCjoKkm8rUHIQn4OZTwEF+m+M5
	2lPixhUBnp3Kht7aRzHIzjHFfwvdyCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-7V6gJchFOf2fOsTvfHSDeg-1; Tue, 13 May 2025 05:38:24 -0400
X-MC-Unique: 7V6gJchFOf2fOsTvfHSDeg-1
X-Mimecast-MFC-AGG-ID: 7V6gJchFOf2fOsTvfHSDeg_1747129104
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so21825105e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 02:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747129104; x=1747733904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KrX5dQOsiuTyKGPiD7lJuvLzjNro5fZEtw25f9WuCU=;
        b=OEJL1xAm6I5mopQf7d5cFVS+db2cDTw5XTdgAqDTx52qVvT/sRJyVpdPtA4cTC3Gyk
         43I3px6Gj8M1cKCveO2wjj2QWIDfcxc21Jz4RZQPue3FgqFs00SgGPTBTooTgu2n282W
         aY+5wmnQ7ejmYXpfKbZkWNPj/HnfS//XAyfBtEEZoUy9Xm3kTX+M7PiratcIYNKV56W0
         Iba2+ltmyTVFifhGVc+bTjBvM6sRfZ/QIAo6zbFYhWQ6hMB4upVxrbtAqsK0XKR60yxV
         tTt5Hh+TcBVxkR0jcCOpmLIYXbhN1YZuKtEforUkfZZEJorD2Dx2xgNDpqN7N4Lr0GIP
         YX3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFpCuMqJZRobq+ra4Bzz0SetvI7IdHkqBPGWwe0oLYpL1W9+Zk4haTqcbjM8Gc8XSHE6qfitE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdBGYyeJe+9N0y/7iN+fpuBL5JuxKu1Zurx6tFe1XdNFFYhmLd
	gt/rWQRMl61DuaWon3jYbIpPh2RxxkqioPgwvEmkMUOOLKlVkcW369X2Unavw88h15IBVw/MQfR
	CVZyCt1laP9MUxryvj5U3wK2Tnf/DCN9NQF0o8kMqAg7nMnplVTf3cA==
X-Gm-Gg: ASbGncv7kANGW9upBN1fFv9W41IRdixM2KtwrBYV8vg4QHuKjnPEgZP0HP/cLtjrgBn
	EJ41GVKnukfP+zJAufFceGtI6dC01wA3e3f+ZKBUMDK9ivUD/GP/MXdq+91brWsX29AyZVRQHOe
	Fbjbnv4m8EQSamPkm1l27ordgp9IAQNcez5QhtB/SWcAEdQ3VLJQTaOQYS/uVVXFy3z63ZdTRAo
	p9VbvHCuJW8yX8R+fgDCxPp0GTwq2t5FvnP09Zx5frhL9TXQryy1Ou647z2wcShh3MorrqrbGoK
	3R8lmA6bSIq6xraM4GopE3ZYkuS2R0FOzP4v6djh7gg5jNgt7NGpc0fzQJg=
X-Received: by 2002:a05:600c:4d21:b0:43c:f3e1:a729 with SMTP id 5b1f17b1804b1-442eacf980fmr16403415e9.12.1747129103734;
        Tue, 13 May 2025 02:38:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJLKtmMNprOtP6whNggUMo04dtnwmsVA/9z9AbAUkwvGFFOL65KoCRiCgBsYTpq3eWLP7Trw==
X-Received: by 2002:a05:600c:4d21:b0:43c:f3e1:a729 with SMTP id 5b1f17b1804b1-442eacf980fmr16403125e9.12.1747129103224;
        Tue, 13 May 2025 02:38:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aecb0sm206781415e9.28.2025.05.13.02.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:38:22 -0700 (PDT)
Message-ID: <7efea440-f472-4115-9133-436347632c50@redhat.com>
Date: Tue, 13 May 2025 11:38:20 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v6 00/14] arm: rework id register storage
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250506085234.855779-1-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250506085234.855779-1-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QhZPUIaHsseeVDwaYWzfxQKiS8R814k-mEsBHuGqYBU_1747129104
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 5/6/25 10:52 AM, Cornelia Huck wrote:
> Just some small changes:
> - fixed up some botched conversions noted by Eric (thanks!)
> - rebased to current master
> - new patch with a small cleanup suggested by Eric
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v6

The series looks good to me and I have not spotted any additional
conversion issue.

Thanks

Eric
>
> <v5 cover letter>
> Just a quick respin to fix a missed conversion in hvf.c.
>
> <v4 cover letter>
> Next iteration of the id register patches; only small changes.
>
> Changed from v3:
> - added R-bs (thanks!)
> - added missing SPDX header
> - merged patch introducing accessors for kvm to the first user
> - skip over sysregs outside of the id register range when generating
>   register definitions again
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v4
>
> <v3 cover letter>
> Yet another update of the id register series, less changes this time
> around.
>
> Changed from v2:
> - changed generation of the various register defines via the "DEF"
>   magic suggested by Richard
> - some kvm-only code moved to kvm.c; some code potentially useful to
>   non-kvm code stayed out of there (the cpu model code will make use
>   of it, and that one should be extendable outside of kvm -- a
>   revised version of those patches is still in the works, but I'll be
>   off for a few days and rather wanted to get this one out first)
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v3
>
> <v2 cover letter>
>
> Changed from v1:
> - Noticed that we missed the hvf code. Converted, compiled, but not tested
>   as I'm lacking an environment for testing.
> - Hopefully incorporated most of the suggested changes -- if I missed
>   something, it was unintentional unless mentioned below.
>   - fixed repeated inclusion of definitions
>   - hopefully made macros more robust
>   - removed distinction between reading 32/64 values, which was mostly
>     adding churn for little value
>   - postponed generating property definitions to the cpu model patches,
>     where they are actually used
>   - juggled hunks and moved them to the right patches
>   - fixed some typos
> - rebased to a more recent code base
>
> NOT changed from v1:
> - definitions are still generated from the Linux sysregs file
>   - I still think updating the generated files on demand (so that we can
>     double check the result) is the right thing to do
>   - I'm open to changing the source of the definitions from the sysregs
>     file to the JSON definitions published by Arm; however, I first wanted
>     to get the code using it right -- we can switch out the code generating
>     the file to use a different source easily later on, and I'd also like
>     to steal parts of the script from Linux once integrated (which I think
>     hasn't happened yet?)
>
> <v1 cover letter>
>
> [Note: I've kept the cc list from the last round of cpu model patches;
> so if you're confused as to why you're cc:ed here, take it as a
> heads-up that a new cpu model series will come along soon]
>
> This patch series contains patches extracted from the larger cpu model
> series (RFC v2 last posted at
> https://lore.kernel.org/qemu-devel/20241206112213.88394-1-cohuck@redhat.com/)
> and aims at providing a base upon which we can continue with building
> support for cpu models, but which is hopefully already an improvement
> on its own.
>
> Main changes from the patches in that series include:
> - post-pone the changes to handle KVM writable ID registers for cpu models
>   (I have a series including that on top of this one)
> - change how we store the list of ID registers, and access them
>   basically, use an enum for indexing, and an enum doing encodings in a
>   pattern similar to cpregs
> - move some hunks to different patches
> - update the scripts to generate the register descriptions, and run
>   them against a recent Linux sysregs file
>
> What I've kept:
> - generating the register descriptions from the Linux sysregs file
>   I think that file is still our best bet to generate the descriptions
>   easily, and updating the definitions is a manual step that can be checked
>   for unintended changes
> - most of the hard work that Eric had been doing; all new bugs in there
>   are my own :)
>
> </v1 cover letter>
> </v2 cover letter>
> </v3 cover letter>
> </v4 cover letter>
> </v5 cover letter>
>
> Cornelia Huck (2):
>   arm/cpu: switch to a generated cpu-sysregs.h.inc
>   arm/kvm: use fd instead of fdarray[2]
>
> Eric Auger (12):
>   arm/cpu: Add sysreg definitions in cpu-sysregs.h
>   arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
>   arm/cpu: Store aa64isar1/2 into the idregs array
>   arm/cpu: Store aa64pfr0/1 into the idregs array
>   arm/cpu: Store aa64mmfr0-3 into the idregs array
>   arm/cpu: Store aa64dfr0/1 into the idregs array
>   arm/cpu: Store aa64smfr0 into the idregs array
>   arm/cpu: Store id_isar0-7 into the idregs array
>   arm/cpu: Store id_pfr0/1/2 into the idregs array
>   arm/cpu: Store id_dfr0/1 into the idregs array
>   arm/cpu: Store id_mmfr0-5 into the idregs array
>   arm/cpu: Add sysreg generation scripts
>
>  hw/intc/armv7m_nvic.c                 |  27 +-
>  scripts/gen-cpu-sysregs-header.awk    |  35 ++
>  scripts/update-aarch64-sysreg-code.sh |  25 ++
>  target/arm/cpu-features.h             | 317 +++++++++---------
>  target/arm/cpu-sysregs.h              |  42 +++
>  target/arm/cpu-sysregs.h.inc          |  52 +++
>  target/arm/cpu.c                      | 111 +++----
>  target/arm/cpu.h                      |  80 +++--
>  target/arm/cpu64.c                    | 128 +++----
>  target/arm/helper.c                   |  68 ++--
>  target/arm/hvf/hvf.c                  |  39 ++-
>  target/arm/internals.h                |   6 +-
>  target/arm/kvm.c                      | 139 ++++----
>  target/arm/ptw.c                      |   6 +-
>  target/arm/tcg/cpu-v7m.c              | 174 +++++-----
>  target/arm/tcg/cpu32.c                | 320 +++++++++---------
>  target/arm/tcg/cpu64.c                | 459 +++++++++++++-------------
>  17 files changed, 1103 insertions(+), 925 deletions(-)
>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>  create mode 100644 target/arm/cpu-sysregs.h
>  create mode 100644 target/arm/cpu-sysregs.h.inc
>

