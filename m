Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1997082D
	for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745858639; cv=none; b=psYZGnPpGrD2tGnG/ADdtuRa7YJuCePR/BWc2teV67gmmPK08Y32b1+uN3D8vLl/H6GfOnD7BY6zeI1rsuTh39C/bOCJOEfF5c75pqIucQkfeqdPpmL9WowNMADGqc4Ci2aRC0QmnbnsOqmJ3rzSWHNjf83U3q2kNs9tevTZW7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745858639; c=relaxed/simple;
	bh=iO3k2WrGvQBjtcv0+td8h36vIcgu/DH+50JFZClHgX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DfbXUmDs3nWzUvJfGGquGd6tvb7a9I9pPhfuW7qklRtszw14wCuxr7QNC0f9IaGjQGQXlar1Gon6570QjEWT6+6gT8N2IBqjcapcnECsnf7S8+MhAOdc3EqPuoXbtkv4ZR6pFO/hyfA0h7T0/pAwQPS3fFNa7xOBmSedPnOJkaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a66VeyfM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a66VeyfM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745858635;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT9szaBMS1wuwJ4Sk2MNJGIE71RFervjbyhX/iYXJP0=;
	b=a66VeyfMbaH7GitLLFRkJHsQKqU2L2Zf9vfwAVRZq9uZBi45+kXKaaSLRvggHzKcT7groY
	wJbvJgSl3jT7oXYS9OuRGlr7u+cCxmO//oxkIF1Gm7uSCWBlPHwQPaJc+48UKavd9OxPVJ
	1sdBBd4Y2edaX3fyulYQ7sP4bQOxi78=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-0YE0n6gGPJyzxCpzVyQhVA-1; Mon, 28 Apr 2025 12:43:54 -0400
X-MC-Unique: 0YE0n6gGPJyzxCpzVyQhVA-1
X-Mimecast-MFC-AGG-ID: 0YE0n6gGPJyzxCpzVyQhVA_1745858633
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf446681cso29019525e9.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 09:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745858633; x=1746463433;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hT9szaBMS1wuwJ4Sk2MNJGIE71RFervjbyhX/iYXJP0=;
        b=QcSnKJfHEVAu03fG0O09Kx/ZuKRm/JSeEfPmy+TIoXtQXPIYnauxw4unOQWtp/oqni
         /9dSB9g5l/frI89N2YQOcpxaLD17jfqIxa85+sykbqQ9r+/ejWpePNswCi4/7sEuL+tN
         FJJqGRX4QpOf+wdIRC78q1bFvvjAv/Ykld0kQpQ4qnmW3dpBVxpF6jDKIICTe09q36Db
         LvVSWJdOvJ6c2haGXHtUXhRFkE8vzRbgirf86gqc+rgqY8mCC54PHK4tLdskxxdgHO15
         HjhjIhzpW9pXO1cUZREIXqAVvAz5rOgYP0QFVNkStZ6jv66e/A5o4TyljdTFwOpQIYTG
         n7zw==
X-Forwarded-Encrypted: i=1; AJvYcCX5NM0swt2Ti/cEb6MB7DbyAQVButQbLZQ71px5WpsBXUGDpEYEgO8RQ4mqXOVV3+v5K2wTAPQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YywiNj6RL/DVDIYpziPpaE67Djqwe0s3G5uomoY8HhghO/ce7EN
	Puwsv6SGyyvz/6X7z4l01F2GF/6dEO2cvq9JvtbiDdspOoAPqSjy9M5QXthdTkHqKOiuLH01M2r
	RYnWLF59v99LqkpKYt7RzWxmKLW8e5P8xT+GDW/qhJyBZCS7hEseRAA==
X-Gm-Gg: ASbGncsZjRq+bHSKyaceSCx9oxi2w6zKIkHQO4HEr7f70IYXSD0HKxli90Im4X+YhRe
	Y/Ow4f72c0QkEZzhnSBKxhn+XMiYBR7h3mk0SUfyBEmYVQ0wY125vy8biTEgNHMkwTIrA1GWxgE
	UbcEKqmsUaS6GyMmXgcs38e8LVMOMfLF3QLs9j9CgsKh1BWcbNJmML5PBVCFetrTrCPTnYhh3vs
	C/mAraNc2KDFdT7nfJ0hZJY6A7av+L8MlFZGOAAlODdnOuzE/wWRngp9eEMVsu8Kwh7Qq4w4Mvc
	QZQ7/6qATr/iO87tSZeULOzUHTKXBeQT5pjuRttkGl3Oz2XMBOitZ/YOd1U=
X-Received: by 2002:a05:600c:3d0b:b0:43c:f44c:72b7 with SMTP id 5b1f17b1804b1-441ac859010mr273645e9.14.1745858633346;
        Mon, 28 Apr 2025 09:43:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLoqim8nFsSahRim40TfQnTSHnj1tPFhatyQmqpgUa6XY03VLvomjulc/lu48GhOOcB6i9mA==
X-Received: by 2002:a05:600c:3d0b:b0:43c:f44c:72b7 with SMTP id 5b1f17b1804b1-441ac859010mr273125e9.14.1745858632764;
        Mon, 28 Apr 2025 09:43:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a53108f2sm128676115e9.19.2025.04.28.09.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 09:43:52 -0700 (PDT)
Message-ID: <4cbaa46b-2114-49b3-8d59-e92a4967665b@redhat.com>
Date: Mon, 28 Apr 2025 18:43:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH for-10.1 v5 00/13] arm: rework id register storage
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250409144304.912325-1-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250409144304.912325-1-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s7jXrt7uUsVQSCJoGceJbeGH6c4jY6Qn-1Mr55Kxo4E_1745858633
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 4/9/25 4:42 PM, Cornelia Huck wrote:
> Just a quick respin to fix a missed conversion in hvf.c.
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v5

I reviewed it again - I can't send any R-b through since I am co-author
;-) - and I spotted few conversion mistakes (I am most probably the one
to blame here sorry)

Once those fixed, I think we should be good.

Eric
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
>
> Cornelia Huck (1):
>   arm/cpu: switch to a generated cpu-sysregs.h.inc
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
>  target/arm/cpu-sysregs.h              |  46 +++
>  target/arm/cpu-sysregs.h.inc          |  52 +++
>  target/arm/cpu.c                      | 111 +++----
>  target/arm/cpu.h                      |  80 +++--
>  target/arm/cpu64.c                    | 128 +++----
>  target/arm/helper.c                   |  68 ++--
>  target/arm/hvf/hvf.c                  |  39 ++-
>  target/arm/internals.h                |   6 +-
>  target/arm/kvm.c                      | 129 ++++----
>  target/arm/ptw.c                      |   6 +-
>  target/arm/tcg/cpu-v7m.c              | 174 +++++-----
>  target/arm/tcg/cpu32.c                | 320 +++++++++---------
>  target/arm/tcg/cpu64.c                | 460 +++++++++++++-------------
>  17 files changed, 1103 insertions(+), 920 deletions(-)
>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>  create mode 100644 target/arm/cpu-sysregs.h
>  create mode 100644 target/arm/cpu-sysregs.h.inc
>

