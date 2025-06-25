Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DEC285C99
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 09:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842662; cv=none; b=l646Pr+MR901gXfzPPDuwSoT+TiCIl4nh/KvUJ8IjxC7fIan1hPXNkF7Zu+L48Ebej8YBvSqkKk5LX/TN8c63GoIyFpt0MLxjDVombr6fiGubdWQPRl5t8wtQN8AtAYIH4SvhrK19r4NXlJHHxO3DwITVj+kVlcessbCFmfwxuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842662; c=relaxed/simple;
	bh=7JJcuP3aIfzXndP2LqEvsQ/93PmXZk3xPmsco7vx0Ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AuiXHk+MTI+mIJBjJlw3eH/q7kxhWeAODskStDL8GAOLQkTDDo7aPeywNyLjp2lHu/R7BENrk8mOVNVIeANWF/QiLhi3Mcw1ImJ1wrHjo6+jpeFHhHPu7TfBz2MJJ3r3TakUDNBKYzOmB8H+Qa+UkW3azCjUY2wnHUdPAmUsqiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/xaSS/T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/xaSS/T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750842658;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvRYaL9u/cnlzz34+2r3/ELm9ZSEkzASj3rbxggGcDE=;
	b=B/xaSS/TfKwR1nex0jCBrIL/ZTh0AYo/m7dhN19p9DM2Ycuc4QtndCNbkRExoy62SwdkP9
	65NwAI40vvRfAWH6nQhJ25+I0oN/VW7u2w4/ZUN8MWgoIK3oXwngANXR2WOEE+iF4gXKt5
	eU4FySPqnZccoSFX/0cKPIuOcYk90vg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-BpCD5hBIOcWMgdAw5K8gOA-1; Wed, 25 Jun 2025 05:10:56 -0400
X-MC-Unique: BpCD5hBIOcWMgdAw5K8gOA-1
X-Mimecast-MFC-AGG-ID: BpCD5hBIOcWMgdAw5K8gOA_1750842655
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so8706955e9.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 02:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750842655; x=1751447455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvRYaL9u/cnlzz34+2r3/ELm9ZSEkzASj3rbxggGcDE=;
        b=hsw/Uxb6toLiorG5ZszGE3U4YPBHffAL8xGAWdcMNbMCKRYRR6ekYN9PC/e3+LfKEX
         SGU1Jsqiox4gKxWyVRc4Jsh4keeNKokx39v7rZgdK3hhPb4a9rsldaP19jvik3YvqDTW
         B6mbaNvUoQWzrXsVvLFmQKxHBJAT7Gbuofymrtkd+qiQtBNsJq7PcEIhrCuhH/Gzkwyr
         U2vNCEDObVmka/oYQMbJfJA9SNNe6HUx6XBO8SrKjvLO03z1R5syETqsueNRG5s+3SfJ
         4H8ZJse34luB5czGilCBUuMOxfKBGRkCtMIpZDmCaLyNIkozy/kPUFVsX2hGUopH72ZJ
         eu9g==
X-Forwarded-Encrypted: i=1; AJvYcCVhVQk64qvnQsXg3TIbjcHng2gNKWAzhoIQJmv3BtyGXSLs+8b4y3KKTFDAagRGePNHDZBAwEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTJ+GyG1eO5trr/8PmheNvH1/NMoNT2dfz0QkKsZx7iL3YAvHT
	CC5blcHWJnSAwy+4ROjbMJgEJth03WwtTb2kfM10SeGUMcbNHM3Zh9Phmmg9JeTTzyunE5F2yDX
	jz4KpRXAzi/3nQ+RmCU/9LxKaSl08mqqvJXpXN3p1DVGAF0lQWDAWmy5T9g==
X-Gm-Gg: ASbGncuS8kELKln3b7YD8oARXVApDcsq9dMMByoMT/WvdwZpKkzjEbRKatZXsvxTxxj
	1ok8drjn0cYvPWActPCpcbKiVLroHVNYKGTeHlmX7ubY9emUGHQxtfztMjlwt4DxAzQrOu1tXHy
	q/D1eeUOfytb3/tghtRymBiXKPxIdEa9QeNoTX3yTZcfpTri+Fh4+eEyMSwOFdJP2Q2N1O8TB0c
	ie3tuL+736UhCUZHqA+IFwcS3WPbA6+LLilYJNuVRQ9RsoycVgxTlfpC9cBGqF4XcuDlWG5xBtd
	QdmciUgLfPfUfnOrW/Q6Dzhl5GaSlTPVUIRknWlNdLIPru/XYaLSjfksD7N7/hiPIM6exA==
X-Received: by 2002:a05:6000:2006:b0:3a5:8cc2:a4a1 with SMTP id ffacd0b85a97d-3a6ed66dcd5mr1565442f8f.39.1750842655170;
        Wed, 25 Jun 2025 02:10:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNsTdF1L2Q0OWF6ui2fbbv2ZvRsvURxTECZSEg5DuGjbLUinevJMpfMB2NVV2arKOdRL+ekA==
X-Received: by 2002:a05:6000:2006:b0:3a5:8cc2:a4a1 with SMTP id ffacd0b85a97d-3a6ed66dcd5mr1565385f8f.39.1750842654604;
        Wed, 25 Jun 2025 02:10:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8105f93sm4072273f8f.76.2025.06.25.02.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 02:10:53 -0700 (PDT)
Message-ID: <05e903b3-02bf-4c04-ac2b-cdec0b45fe3f@redhat.com>
Date: Wed, 25 Jun 2025 11:10:52 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250617153931.1330449-1-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ey0Wh0-xRKMCmnj36cfcEDDGQx_WrhwdlqDuvmvpUuA_1750842655
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Connie,

On 6/17/25 5:39 PM, Cornelia Huck wrote:
> Mostly addressed Peter's feedback:
> - make sure every inbetween stage compiles (also fixed some bonus issues)
I compile-tested each patch and it is fixed now.
> - try to make the scripts more robust, add a note the generated file,
>   and make sure to grab only registers we actually want
>   - I did a half-hearted attempt to use python instead of awk, but I'm
>     out of my depth, especially with the script that will be used for
>     the register fields in the cpu models series
However there are other checkpatch errors besides the one you reported, in
52873a54ad arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
ERROR: line over 90 characters
#388: FILE: target/arm/kvm.c:225:
+    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >>
CP_REG_ARM64_SYSREG_OP0_SHIFT,

ERROR: line over 90 characters
#389: FILE: target/arm/kvm.c:226:
+                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >>
CP_REG_ARM64_SYSREG_OP1_SHIFT,

ERROR: line over 90 characters
#390: FILE: target/arm/kvm.c:227:
+                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >>
CP_REG_ARM64_SYSREG_CRN_SHIFT,

ERROR: line over 90 characters
#391: FILE: target/arm/kvm.c:228:
+                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >>
CP_REG_ARM64_SYSREG_CRM_SHIFT,

ERROR: line over 90 characters
#392: FILE: target/arm/kvm.c:229:
+                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >>
CP_REG_ARM64_SYSREG_OP2_SHIFT);

WARNING: line over 80 characters
#396: FILE: target/arm/kvm.c:233:
+static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
ARMIDRegisterIdx index)

and in


5f15ebdf3f arm/cpu: Add sysreg definitions in cpu-sysregs.h
ERROR: Macros with complex values should be enclosed in parenthesis
#56: FILE: target/arm/cpu-sysregs.h:21:
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) NAME##_IDX,

ERROR: Macros with complex values should be enclosed in parenthesis
#64: FILE: target/arm/cpu-sysregs.h:29:
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) \
+    SYS_##NAME = ENCODE_ID_REG(OP0, OP1, CRN, CRM, OP2),

ERROR: Macros with complex values should be enclosed in parenthesis
#203: FILE: target/arm/cpu64.c:40:
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
+    [NAME##_IDX] = SYS_##NAME,


Thanks

Eric

>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v8
>
> <v7 cover letter>
> Some small fixes, including fixing up/adding SPDX identifiers, keeping the
> series bisectable, and updating MAINTAINERS (please check if that's ok.)
>
> <v6 cover letter>
> Just some small changes:
> - fixed up some botched conversions noted by Eric (thanks!)
> - rebased to current master
> - new patch with a small cleanup suggested by Eric
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
> </v6 cover letter>
> </v7 cover letter>
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
>  MAINTAINERS                            |   1 +
>  hw/intc/armv7m_nvic.c                  |  27 +-
>  scripts/arm-gen-cpu-sysregs-header.awk |  37 ++
>  scripts/update-aarch64-sysreg-code.sh  |  32 ++
>  target/arm/cpu-features.h              | 317 ++++++++---------
>  target/arm/cpu-sysregs.h               |  42 +++
>  target/arm/cpu-sysregs.h.inc           |  53 +++
>  target/arm/cpu.c                       | 111 +++---
>  target/arm/cpu.h                       |  80 +++--
>  target/arm/cpu64.c                     | 128 ++++---
>  target/arm/helper.c                    |  68 ++--
>  target/arm/hvf/hvf.c                   |  39 ++-
>  target/arm/internals.h                 |   6 +-
>  target/arm/kvm.c                       | 139 ++++----
>  target/arm/ptw.c                       |   6 +-
>  target/arm/tcg/cpu-v7m.c               | 174 +++++-----
>  target/arm/tcg/cpu32.c                 | 320 ++++++++---------
>  target/arm/tcg/cpu64.c                 | 459 +++++++++++++------------
>  18 files changed, 1114 insertions(+), 925 deletions(-)
>  create mode 100755 scripts/arm-gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>  create mode 100644 target/arm/cpu-sysregs.h
>  create mode 100644 target/arm/cpu-sysregs.h.inc
>

