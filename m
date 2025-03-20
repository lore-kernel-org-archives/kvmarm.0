Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3A61E25F2
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485607; cv=none; b=khK85bFFLvCQJ3dOdBgoCZRu27ERglHzhjLAGy1RLrVbDba4ZcTLLenIcI1yrWh8RlauOrohh78DYXpWwsEr5YMVhveDfTFH/zEj6yBneVFT/m00Qpl4ueKNGnqu7kHW0fAAC7j08wwSsgBMyWJVtFt0obS6ni27+wows9IaxMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485607; c=relaxed/simple;
	bh=BNE9RBqYKZ9c6eKlkosWrnSANBK40WgRBIxwV3C9AX4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Sgo6rTTIUyrZiFn+uV7lbhfLmXuaHFA6hDM9ur/PM9T/W60mGFnxc9EVeIxBajCQ6YRuNUhtBiI+qh1G5yDy6bbVSyT83wDiAFy8YVKaL8zuk5RX2TE/MXM05PHqscxsnbne+B/dXKCTryNKKw+NeUKxd5ZkahleNDD90eWwwDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rif/iGJK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rif/iGJK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742485604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HslmlnQwOo6JvynSQuem06I4JILJtTZsP+BQG1VIez0=;
	b=Rif/iGJKXfmNnh+zbJjrZxVtzV/nYSaMP0klir7NOnoaWW+eiVIwCSLaqyX+UG9tHUULxd
	pNNMt4A7IcHG0DqYFwRWgBq4EF/RaFN90P6Wr1Dg8PLlk4MN76ncWL6T11lsjZNRCd/s26
	XsAMy7QlxPI3RiHlzdM7+h2QG37V1eY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-HR3uqDHAMnSD1g6Zn8uqsA-1; Thu, 20 Mar 2025 11:46:42 -0400
X-MC-Unique: HR3uqDHAMnSD1g6Zn8uqsA-1
X-Mimecast-MFC-AGG-ID: HR3uqDHAMnSD1g6Zn8uqsA_1742485601
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-391345e3aa3so536400f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 08:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742485601; x=1743090401;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HslmlnQwOo6JvynSQuem06I4JILJtTZsP+BQG1VIez0=;
        b=ocMcO7TqOV8aqXV14HP9Fv+OCjzSP3ZGJSAXCiJQs5dle2zL3reFvxsvSF+Wq6QzZM
         BZaDiVEoTumqEdEU30HMg1fwU7FDsUPRiWWmN0/OEPTAZxhvDWgG3K6LIbdvRxXTE4Dj
         +tHB10v1V3n/yCGhVn993N9qrZKriKatml3c+fyFI4cdDAssBTSwXjzO/LsAPpAQpCwi
         apkSvDj7jRyv2ggfFOWGLCZgLkfOTKDLN5i9s6InBQKg6p5T5wHzNTLul3h/IqsDEkoZ
         kiXPRROGNCeJ8exXTH0kjzn6r/R1qmQzubN4w4bp6df33lDGC8yOUrk/vHKR2gUZEijF
         oqlw==
X-Forwarded-Encrypted: i=1; AJvYcCV2YJIutK9y9CnfW1z4TthMXRj0IL47YwmcOxDjNr9ArDX/tc3u9TuWf8g5CGZAqYog8jkW094=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxkyQuX/WlrD0/bbZOL3WXQd0KHDvTdBRon1fdzjECoYXBLDYW
	VKMq2B3NQSFHj3+ziIxnTWX4lB7ZLKGiZQ9mO5XlXwbeBhi5RWOgyD2P6oZF/vsxqnlI+DYblgO
	gIXtuQ/g9U/7dcNHJNdNfPlQfoiCEZz3sOwrkm/U5H6Ypibk61g80Bw==
X-Gm-Gg: ASbGnctP3YdDT8wV3gudN2CnyQ9hYyTERRv+pGeC/JCMX3MCq2cuYd3kAGsQmWoMg0f
	ZZAyfYBnd+ukBoq4kG0R/Bo/dzlz8xjZ5nHWoDTHueSwIMGtYh9hONhMTAkQZ0xJJkGNVsl0+si
	MAYlGmPNmr0bCPkI/a1f/PEHmHewWxi81SJ8Zg1DMqwIIvJ/aAXjmrPXkREgBnQN9MN459CrKxb
	DUGIZfHAS8yFOS40xAB1BABk9bTud4t3Ijb9cs6bztb+dg+bZOGiWZQ/sbxt1BHFJvLNDwAp/vX
	gQYAAO3w7IdM7U6j7/hOF6AhxU6xdRM85nzrIW3iGYVhFe+FX8dl0LVZCazfldyv
X-Received: by 2002:a5d:59a2:0:b0:38f:6287:6474 with SMTP id ffacd0b85a97d-3997f8fc43dmr8309f8f.15.1742485600665;
        Thu, 20 Mar 2025 08:46:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyD4EROmupcYNNL7YZI2NHMAKFdzHsbAxlqkXUrS/wvbgf5i9Cb+Ap3R4Xgsi1yDbHIZ7g3Q==
X-Received: by 2002:a5d:59a2:0:b0:38f:6287:6474 with SMTP id ffacd0b85a97d-3997f8fc43dmr8278f8f.15.1742485600138;
        Thu, 20 Mar 2025 08:46:40 -0700 (PDT)
Received: from rh (p200300f6af11ec00f9928575aec32536.dip0.t-ipconnect.de. [2003:f6:af11:ec00:f992:8575:aec3:2536])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c4f9d59dsm24220135f8f.0.2025.03.20.08.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 08:46:39 -0700 (PDT)
Date: Thu, 20 Mar 2025 16:46:38 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
    qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com, 
    mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/14] arm: rework id register storage
In-Reply-To: <20250311162824.199721-1-cohuck@redhat.com>
Message-ID: <acb05338-1256-aefd-0283-9bf801256d82@redhat.com>
References: <20250311162824.199721-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xo9lY4Uu6_uQin6sFDzoCtqkramb547NBI2cafQUY-s_1742485601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 11 Mar 2025, Cornelia Huck wrote:
> Yet another update of the id register series, less changes this time
> around.
>
> Changed from v2:
> - changed generation of the various register defines via the "DEF"
>  magic suggested by Richard
> - some kvm-only code moved to kvm.c; some code potentially useful to
>  non-kvm code stayed out of there (the cpu model code will make use
>  of it, and that one should be extendable outside of kvm -- a
>  revised version of those patches is still in the works, but I'll be
>  off for a few days and rather wanted to get this one out first)
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v3
>
> <v2 cover letter>
>
> Changed from v1:
> - Noticed that we missed the hvf code. Converted, compiled, but not tested
>  as I'm lacking an environment for testing.
> - Hopefully incorporated most of the suggested changes -- if I missed
>  something, it was unintentional unless mentioned below.
>  - fixed repeated inclusion of definitions
>  - hopefully made macros more robust
>  - removed distinction between reading 32/64 values, which was mostly
>    adding churn for little value
>  - postponed generating property definitions to the cpu model patches,
>    where they are actually used
>  - juggled hunks and moved them to the right patches
>  - fixed some typos
> - rebased to a more recent code base
>
> NOT changed from v1:
> - definitions are still generated from the Linux sysregs file
>  - I still think updating the generated files on demand (so that we can
>    double check the result) is the right thing to do
>  - I'm open to changing the source of the definitions from the sysregs
>    file to the JSON definitions published by Arm; however, I first wanted
>    to get the code using it right -- we can switch out the code generating
>    the file to use a different source easily later on, and I'd also like
>    to steal parts of the script from Linux once integrated (which I think
>    hasn't happened yet?)
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
>  (I have a series including that on top of this one)
> - change how we store the list of ID registers, and access them
>  basically, use an enum for indexing, and an enum doing encodings in a
>  pattern similar to cpregs
> - move some hunks to different patches
> - update the scripts to generate the register descriptions, and run
>  them against a recent Linux sysregs file
>
> What I've kept:
> - generating the register descriptions from the Linux sysregs file
>  I think that file is still our best bet to generate the descriptions
>  easily, and updating the definitions is a manual step that can be checked
>  for unintended changes
> - most of the hard work that Eric had been doing; all new bugs in there
>  are my own :)
>
> </v1 cover letter>
> </v2 cover letter>
>
> Cornelia Huck (2):
>  arm/kvm: add accessors for storing host features into idregs
>  arm/cpu: switch to a generated cpu-sysregs.h.inc
>
> Eric Auger (12):
>  arm/cpu: Add sysreg definitions in cpu-sysregs.h
>  arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
>  arm/cpu: Store aa64isar1/2 into the idregs array
>  arm/cpu: Store aa64pfr0/1 into the idregs array
>  arm/cpu: Store aa64mmfr0-3 into the idregs array
>  arm/cpu: Store aa64dfr0/1 into the idregs array
>  arm/cpu: Store aa64smfr0 into the idregs array
>  arm/cpu: Store id_isar0-7 into the idregs array
>  arm/cpu: Store id_pfr0/1/2 into the idregs array
>  arm/cpu: Store id_dfr0/1 into the idregs array
>  arm/cpu: Store id_mmfr0-5 into the idregs array
>  arm/cpu: Add sysreg generation scripts
>
> hw/intc/armv7m_nvic.c                 |  27 +-
> scripts/gen-cpu-sysregs-header.awk    |  39 +++
> scripts/update-aarch64-sysreg-code.sh |  25 ++
> target/arm/cpu-features.h             | 317 +++++++++---------
> target/arm/cpu-sysregs.h              |  41 +++
> target/arm/cpu-sysregs.h.inc          | 170 ++++++++++
> target/arm/cpu.c                      | 111 +++----
> target/arm/cpu.h                      |  80 +++--
> target/arm/cpu64.c                    | 128 +++----
> target/arm/helper.c                   |  68 ++--
> target/arm/hvf/hvf.c                  |  36 +-
> target/arm/internals.h                |   6 +-
> target/arm/kvm.c                      | 129 ++++----
> target/arm/ptw.c                      |   6 +-
> target/arm/tcg/cpu-v7m.c              | 174 +++++-----
> target/arm/tcg/cpu32.c                | 320 +++++++++---------
> target/arm/tcg/cpu64.c                | 460 +++++++++++++-------------
> 17 files changed, 1218 insertions(+), 919 deletions(-)
> create mode 100755 scripts/gen-cpu-sysregs-header.awk
> create mode 100755 scripts/update-aarch64-sysreg-code.sh
> create mode 100644 target/arm/cpu-sysregs.h
> create mode 100644 target/arm/cpu-sysregs.h.inc
>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

