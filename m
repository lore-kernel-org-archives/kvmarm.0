Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5457C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 20:10:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42AC761A3D
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 20:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 42AC761A3D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C9449F5F;
	Thu, 30 Sep 2021 16:10:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2WkUttNgolqX; Thu, 30 Sep 2021 16:10:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A0149FE6;
	Thu, 30 Sep 2021 16:10:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA75406E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 16:10:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kZmwQ-nHYHqW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 16:10:38 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6405040191
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 16:10:38 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id 133so7399580pgb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=6qQX8FGSXGvNLB2OkI54oxIKxt1ew2e183YmWQIOfeQ=;
 b=XQHp8DRPm3f2VxlgHmiuaVYEEvk6aHZEFiJkodu7vU9Tb1qSPgXWUt+VhTR/AKgEz0
 yZfIXcad5ydtrF6PtkMEJW0f3CsRmFrhtc9OPt84zbPtZzVcx3ahJbrMo5zB8BiNs6i3
 T10UA2ALiCNw9ostYuzy/CBFXRThHdgNs18vDyTbvXWOfJHQfba0wqslP39EALWMCY5l
 WmytgZ+U9CtbX8BHeHbF3H0Nk6SB6jClSAefZDUNXduxjkULSQy80R2B+nHMkCVDN8ft
 qV1FiDqoSgp3Mb7Glh+DX/fSoZrEIKT+y4JTI6iwyJGhSWbppOJg2hH2WiOivBIj5xm9
 QjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=6qQX8FGSXGvNLB2OkI54oxIKxt1ew2e183YmWQIOfeQ=;
 b=FMbnkxRSVJCp/lqo889DihmGdhaWVMO7Fy69gmgmyGClhGqI22xW1rL837SwM/QFZ1
 o8duRt9TqM4K03VKJrNuzPofIjskudKVqdOE/I0s6bpxv7+3qs9/8mQ8DF2rKNhaBC38
 Ka6e4EeJKfKJ2JImpt4nGoTFtPqJwVlkIOY67U0IC/He+pmfFkGioa7uHOjsIWqkB+1s
 PtFi74MmTNrVv86EjNu7o7GT/HZpmpdkv47ZrBZhkZIcvCsMhTNw2ZHuHlzktqy0NQub
 sdLGPLmjXsqIhCv55j7OKAUjnlnmC5LBTkt4WoAB3opRKgmNtzD7bFrCu16BweB5uBqe
 OIqg==
X-Gm-Message-State: AOAM533BWQRI/57lx1yNfvTROJ8pNANNxfyDH9/rc//ysWR/ZJSV37J+
 yBOe9wtJQoSlT6yi2HdkNpWGFA==
X-Google-Smtp-Source: ABdhPJwVo62/0ALTnBnDedVNgO544Rk8j1ps8d2HWRwbvmqGmnDiqt6GSXTZFO8UYdGDhfAl9twtbQ==
X-Received: by 2002:aa7:8116:0:b0:44b:e0d1:25e9 with SMTP id
 b22-20020aa78116000000b0044be0d125e9mr7343208pfi.53.1633032636962; 
 Thu, 30 Sep 2021 13:10:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id s38sm3656966pfw.209.2021.09.30.13.10.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 13:10:36 -0700 (PDT)
Date: Thu, 30 Sep 2021 13:10:32 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
Message-ID: <YVYZuBrvV7fnWTSs@google.com>
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

Hi Eric,

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

At the moment it's just called in the GICv3 case. It seems that
registering a GICv3 device results in having an ITS registered as well
(from kvm_register_vgic_device()). I'm assuming this won't change;
we might as well check that assumption. What do you think?

Thanks,
Ricardo

> =

> Maybe refine the patch title mentionning this is an ITS device "init" tes=
t.
> as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
> instantiating the ITS before the GIC and try instantiating several ITSs
> with overlapping addresses.
> But I would totally understand if you consider this out of the scope of
> your=A0 fixes + tests.
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
