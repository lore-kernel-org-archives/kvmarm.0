Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB310969
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 08:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YfjZILr0"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-db8892a5f96so1942027276.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 00:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702023620; x=1702628420; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IVq5r+vNWXjvmE2KybM8jf/JrsATUf4eFpxstMy5F0=;
        b=YfjZILr0gE9zvXWCTmtxnh3drXGtYVQ5RbO01KHw06CKQipIyXQEpRLKxLNFLMQ2gt
         Q/qz14oSwkzZ+QqbsPC0wSAN7kA/4bfS7sEjEWUfmuRwz4Wr111uQMrEJE8/Yb53ZpUL
         GXrvNwwBE/T+wn+UtE1zA8exfpYAcse3YWOTkRiyE9o+zD2vAbJqCVdVNfhCxsplUjoS
         tKx7psTL1cPfNmNkas9eYVKpQIhTh13gKFsm8WC24GyZekwxGEhWLD6WhPaM83WP8/RN
         DWx/E5m9u/dhf/2nqyPhFeCJk/F+X/Y9wiWr85uUrJboBzECEKhKZMrzctyoZXqm8lDP
         n44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023620; x=1702628420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6IVq5r+vNWXjvmE2KybM8jf/JrsATUf4eFpxstMy5F0=;
        b=qhOdGBOyVrgPuzMKtrLg1Br9w9AvNVfLKmIvwVMLW7aSFrPHo1xwgger8BW4bcFMdT
         +zl25R86IfjkNkWO0EDKVOf111ew31idBTnEpxdBStJQif7yRd9Jxu6oUs+fhHLFwto/
         HGKSf7f4gMbI+znkyHLnO9iT5GCefVxl4oooHBh93Q/yqTnurkkG0B50gJ7Et6f9XiUM
         poT3JM2lQkrZ6Y2XptuFbG88tjNAB+5c3QIQrPQOjJMfh6b+BRR0vMl+uif2jXzBAc5r
         Fw1HZ9464Y+e5Ed3Xekd9F4HaqmL/b+ic5vM8Q/PpkObZzntbpSOq2vzICTaXFc9d2od
         RwpA==
X-Gm-Message-State: AOJu0YxNqsaffnPJ3ieuO3d34ouScdhcC8XKl+ZLFkS9Y/cv8ofcckr6
	h/8YHRLq27URWJpM48Mn5cEYJMT/rbgDvkdaN5RQQw==
X-Google-Smtp-Source: AGHT+IEAwXDfKI/rs/cVUYkNV8sjU8Z2rEH20XgkyYUOQxP3fMyLJX0wNSpi9gm8rcePGpmsRevDz17oAAzV7DKBgzI=
X-Received: by 2002:a25:6853:0:b0:db7:dacf:621a with SMTP id
 d80-20020a256853000000b00db7dacf621amr3645297ybc.108.1702023620460; Fri, 08
 Dec 2023 00:20:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-6-tabba@google.com>
 <006ec2b0-6263-4e86-8641-d81c01a91c8e@sirena.org.uk>
In-Reply-To: <006ec2b0-6263-4e86-8641-d81c01a91c8e@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 8 Dec 2023 08:19:43 +0000
Message-ID: <CA+EHjTx42qgepOaFMt1wLSQ6uPUv8wQTa2z-Z_PEiVPUwYAL8A@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] KVM: arm64: Handle HAFGRTR_EL2 trapping in
 nested virt
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 7, 2023 at 5:28=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Dec 06, 2023 at 10:04:55AM +0000, Fuad Tabba wrote:
>
> > Add the encodings to fine grain trapping fields for HAFGRTR_EL2
> > and add the associated handling code in nested virt. Based on
> > the 2023-09 Arm Architecture System Registers xml
> > specification [*]. Add the missing field definitions as well,
> > both to generate the correct RES0 mask and to be able to toggle
> > their FGT bits.
>
> > Also add the code for handling FGT trapping, reading of the
> > register, to nested virt.
>
> > [*] https://developer.arm.com/downloads/-/exploration-tools
>
> DDI0601.

Yup! :)

> > +Sysreg HAFGRTR_EL2   3       4       3       1       6
> > +Res0 63:50
> > +Field        49      AMEVTYPER115_EL0
> > +Field        48      AMEVCNTR115_EL0
> > +Field        47      AMEVTYPER114_EL0
> > +Field        46      AMEVCNTR114_EL0
> > +Field        45      AMEVTYPER113_EL0
> > +Field        44      AMEVCNTR113_EL0
> > +Field        43      AMEVTYPER112_EL0
> > +Field        42      AMEVCNTR112_EL0
> > +Field        41      AMEVTYPER111_EL0
> > +Field        40      AMEVCNTR111_EL0
> > +Field        39      AMEVTYPER110_EL0
> > +Field        38      AMEVCNTR110_EL0
> > +Field        37      AMEVTYPER19_EL0
> > +Field        36      AMEVCNTR19_EL0
> > +Field        35      AMEVTYPER18_EL0
> > +Field        34      AMEVCNTR18_EL0
> > +Field        33      AMEVTYPER17_EL0
> > +Field        32      AMEVCNTR17_EL0
> > +Field        31      AMEVTYPER16_EL0
> > +Field        30      AMEVCNTR16_EL0
> > +Field        29      AMEVTYPER15_EL0
> > +Field        28      AMEVCNTR15_EL0
> > +Field        27      AMEVTYPER14_EL0
> > +Field        26      AMEVCNTR14_EL0
> > +Field        25      AMEVTYPER13_EL0
> > +Field        24      AMEVCNTR13_EL0
> > +Field        23      AMEVTYPER12_EL0
> > +Field        22      AMEVCNTR12_EL0
> > +Field        21      AMEVTYPER11_EL0
> > +Field        20      AMEVCNTR11_EL0
> > +Field        19      AMEVTYPER10_EL0
> > +Field        18      AMEVCNTR10_EL0
> > +Field        17      AMCNTEN1
> > +Res0 16:5
> > +Field        4       AMEVCNTR03_EL0
> > +Field        3       AMEVCNTR02_EL0
> > +Field        2       AMEVCNTR01_EL0
> > +Field        1       AMEVCNTR00_EL0
> > +Field        0       AMCNTEN0
> > +EndSysreg
> > +
>
> Oh, we actually have the register fully encoded since we needed the
> fields.  Given this why did we need the manual encoding in the previous
> patch?  In any case this looks good according to DDI0601 2023-09:

We need both because we need to know the polarity. RES0 and the valid
bits are generated. In later patches in this series I move completely
to using the generated RES0, and to calculating nMASK based on the
other fields. But we still need the definitions in kvm_arm.h for the
polarity.

> Reviewed-by: Mark Brown <broonie@kernel.org>

Thanks!
/fuad
