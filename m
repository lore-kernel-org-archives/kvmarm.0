Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4EBC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:03:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4926961507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4926961507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A894B27E;
	Mon,  4 Oct 2021 21:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1shMb6aBlPqf; Mon,  4 Oct 2021 21:03:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B141B4B29C;
	Mon,  4 Oct 2021 21:03:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9F1E4B286
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 85NcSpDGTiO2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:03:52 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC0CD4B278
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:03:52 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 na16-20020a17090b4c1000b0019f5bb661f9so1150958pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=zzNse5XZD5zqkQVj8assgOpyA3GCGgkuXvEMqCR3Jzw=;
 b=aWMmBTgJQ6GE3fYS3ULud5M/5C3q8Zmtqp6VpCAkzLcwjXs6M7tlduWhVOQTY0Dcj5
 7UZrCvEJv8kCzJAVR9dPCiV3I3Ofu6wMRLxkI5TuRNTIGWmN69slWs1ltcIiIO7v+hye
 ipj/GSKGkCVR7jERaBvXw9APHJaQsTf5Kq1VwP4zAEkaCaMQne1mUiYPGuNT7UazBahS
 PQVleqYaNBE4j6UtyxM6HapEn7g4G+Npdel8YwvLoWi75W7QV32PSEpMCyquqrWQgvhE
 rko4sOkLPds8WlaZ8HIJmuhx5FU3d9v5EOZgCF1x0Mx4lnOMbiglFz/kS0V6YgymmX5L
 IBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=zzNse5XZD5zqkQVj8assgOpyA3GCGgkuXvEMqCR3Jzw=;
 b=Or23oJG+/MMK3bp6OLU0PqLgCFRXMQwo6uHJ4oz9DdRxF/1TJuve/15MZcUY+ib/5d
 cUWjx2hRFRNA2KkAxmsETUS388G5lg6wXJsq9VE/aIHxg0S+ZZMfpDDvnPLHmyr56x4h
 3YsjYq1+qcQoAl7fX1Tl0LNs0BRNYJCu3MsPjKtk0dPnz9cyKFYq/7ZBMDyYQtDfVtmB
 qBomqoKDPW2eIumyj0xfq8OL/FJMJDXY9Y6TsoxajoLfnU9jHjDxXGY38AByTPzwNR8u
 vG92sQurIQ/T6I4YzyssUlFZSJhFnBFTj6vQ+QJowqynBSDvoqPUXEGO5g7RZ79HlVHS
 V+2w==
X-Gm-Message-State: AOAM530u+nvxV84kNsMmY+GpQ60OmPf0ZzCZWW+/SiwBS53FTzblG2rQ
 Pyg1GgO3YlHHor6EJ8TjXwYbcQ==
X-Google-Smtp-Source: ABdhPJyKyWa2vMeW0C9A0MkBjs1KnK+VrEbgkX0ymrdNQD9TFJX8rUkK9/a66h8v4s/EBc9xidzIsQ==
X-Received: by 2002:a17:90b:f8d:: with SMTP id
 ft13mr289854pjb.137.1633395831398; 
 Mon, 04 Oct 2021 18:03:51 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id t23sm11087609pgn.25.2021.10.04.18.03.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 18:03:50 -0700 (PDT)
Date: Mon, 4 Oct 2021 18:03:47 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
Message-ID: <YVukc0eMUKfyz3Ps@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
 <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 30, 2021 at 11:14:02AM +0200, Eric Auger wrote:
> Hi Ricardo,
> =

> On 9/29/21 2:10 AM, Ricardo Koller wrote:
> > Add some ITS device tests: general KVM device tests (address not defined
> > already, address aligned) and tests for the ITS region being within the
> > addressable IPA range.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/te=
sting/selftests/kvm/aarch64/vgic_init.c
> > index 417a9a515cad..180221ec325d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu=
_run(void)
> >  	vm_gic_destroy(&v);
> >  }
> >  =

> > +static void test_v3_its_region(void)
> > +{
> > +	struct vm_gic v;
> > +	uint64_t addr;
> > +	int its_fd, ret;
> > +
> > +	v =3D vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
> > +	its_fd =3D kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
> this may fail if the ITS device has not been registered by KVM (host GICv=
2)
> =

> Maybe refine the patch title mentionning this is an ITS device "init" tes=
t.
> as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
> instantiating the ITS before the GIC and try instantiating several ITSs
> with overlapping addresses.
> But I would totally understand if you consider this out of the scope of
> your=A0 fixes + tests.

Will just send a v4 with init tests for now. ACK on changing the patch
title.

Thanks,
Ricardo

> =

> Thanks!
> =

> Eric
> > +
> > +	addr =3D 0x401000;
> > +	ret =3D _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D EINVAL,
> > +		"ITS region with misaligned address");
> > +
> > +	addr =3D max_phys_size;
> > +	ret =3D _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > +		"register ITS region with base address beyond IPA range");
> > +
> > +	addr =3D max_phys_size - 0x10000;
> > +	ret =3D _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > +		"Half of ITS region is beyond IPA range");
> > +
> > +	/* This one succeeds setting the ITS base */
> > +	addr =3D 0x400000;
> > +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +
> > +	addr =3D 0x300000;
> > +	ret =3D _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D EEXIST, "ITS base set again");
> > +
> > +	close(its_fd);
> > +	vm_gic_destroy(&v);
> > +}
> > +
> >  /*
> >   * Returns 0 if it's possible to create GIC device of a given type (V2=
 or V3).
> >   */
> > @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
> >  		test_v3_last_bit_redist_regions();
> >  		test_v3_last_bit_single_rdist();
> >  		test_v3_redist_ipa_range_check_at_vcpu_run();
> > +		test_v3_its_region();
> >  	}
> >  }
> >  =

> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
