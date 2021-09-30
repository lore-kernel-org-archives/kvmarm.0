Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEABC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:14:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FA4D61A50
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8FA4D61A50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A0F4A98B;
	Thu, 30 Sep 2021 17:14:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aUTvMSFBVM-t; Thu, 30 Sep 2021 17:14:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B59B4B0B6;
	Thu, 30 Sep 2021 17:14:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5124A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:14:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o3F7Y8i94fat for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 17:14:26 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61F8A4048A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:14:26 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id 187so1701980pfc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=hg19zG52jI0qoSrULpzK0t3FBxyLRjBAIZa9D41e5lk=;
 b=QJ2E5eoTFWYtnZVdHXO4IdEtHzlO9MrkPk3l20cWB246DnSyrZNoPdUK3RQhoTEfAM
 DDWuOg3j2YlAxjwPYGJBYyVqwcn2N6A2A4cF4BrvYKmUdPfNXQHmWqSl+2yjgwo1InQB
 sgieG+YFv2OePQZ4cB6mf9kkDfmzf29duTb+VVyhtqw4ggSUdPN9e3iRvY/aeQ++V6/+
 /pU9y1KfnwVtzTFc0WM51szH9ox0UEBGJ0QmJBECgXwsD5+XeQ6cO6M94R7IdIEc3KMH
 jeMLSBNMTKPKscmbtVMiDZxSXsuSl/s1KgjpN3Z8EdUwFd/xHwUCqGnMUJ3CyUYoFs3R
 3Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=hg19zG52jI0qoSrULpzK0t3FBxyLRjBAIZa9D41e5lk=;
 b=YL/8y6Lzgm2N6+NtFUWXvAKAL0x+oPBnilSw4Tny0TcfexogLRw6J9C0DLeR7hX4BY
 gyZ9WYcyaUNoc6/ap+WlP7AdAkRMUhzVu2pZr03wNs0vKtOtZ7DSp5dJsdrTqQU4usOV
 wHrzDxbDFew+9iC7rSqhrJ+lHEjk4HI2Yqep9F+Mai5nqGutpZqLw2I/sQSMDK70q9yH
 +XE8xfq/R+OcdIm4BCcjfYvoqWjq0BFmteJY0BeU202eek+rD/ccn0NrZyoim5aow28m
 tvmcBiEVObkcC4ueQifiEQBXRbGrsV8r7LDEJMvo501rc+zitYrBuPSztU5OfUJFYyko
 a0lA==
X-Gm-Message-State: AOAM533Kq9SHcQicEKFFUlAbjb4jhy1CBQw5vy6YWN+cGjfxk2qimr4A
 sJVQa69EFzM2IW3WhbLDNpOgxQ==
X-Google-Smtp-Source: ABdhPJy74/yNwbIvYcf8A1lWFDUbcOCCcR0YUHEGOaBevZ8ZbYervNn3U+Og51vg6wlVAu/3N5VAkg==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr6426537pgl.437.1633036464990; 
 Thu, 30 Sep 2021 14:14:24 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id s188sm3649167pfb.44.2021.09.30.14.14.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 14:14:24 -0700 (PDT)
Date: Thu, 30 Sep 2021 14:14:20 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 07/10] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
Message-ID: <YVYorHtJHBXZ+Aph@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-8-ricarkol@google.com>
 <00b3c776-71e4-3687-0510-540462a43840@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <00b3c776-71e4-3687-0510-540462a43840@redhat.com>
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

On Thu, Sep 30, 2021 at 09:42:50AM +0200, Eric Auger wrote:
> Hi Ricardo,
> =

> On 9/28/21 8:48 PM, Ricardo Koller wrote:
> > Add some GICv2 tests: general KVM device tests and DIST/REDIST overlap
> > tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> > in vgic_init GIC version agnostic.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 107 ++++++++++++------
> >  1 file changed, 75 insertions(+), 32 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/te=
sting/selftests/kvm/aarch64/vgic_init.c
> > index b24067dbdac0..92f5c6ca6b8b 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -79,74 +79,116 @@ static void vm_gic_destroy(struct vm_gic *v)
> >  	kvm_vm_free(v->vm);
> >  }
> >  =

> > +struct vgic_region_attr {
> > +	uint64_t attr;
> > +	uint64_t size;
> > +	uint64_t alignment;
> > +};
> > +
> > +struct vgic_region_attr gic_v3_dist_region =3D {
> > +	.attr =3D KVM_VGIC_V3_ADDR_TYPE_DIST,
> > +	.size =3D 0x10000,
> > +	.alignment =3D 0x10000,
> > +};
> > +
> > +struct vgic_region_attr gic_v3_redist_region =3D {
> > +	.attr =3D KVM_VGIC_V3_ADDR_TYPE_REDIST,
> > +	.size =3D NR_VCPUS * 0x20000,
> > +	.alignment =3D 0x10000,
> > +};
> > +
> > +struct vgic_region_attr gic_v2_dist_region =3D {
> > +	.attr =3D KVM_VGIC_V2_ADDR_TYPE_DIST,
> > +	.size =3D 0x1000,
> > +	.alignment =3D 0x1000,
> > +};
> > +
> > +struct vgic_region_attr gic_v2_cpu_region =3D {
> > +	.attr =3D KVM_VGIC_V2_ADDR_TYPE_CPU,
> > +	.size =3D 0x2000,
> > +	.alignment =3D 0x1000,
> > +};
> > +
> >  /**
> > - * Helper routine that performs KVM device tests in general and
> > - * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
> > - * device gets created, a legacy RDIST region is set at @0x0
> > - * and a DIST region is set @0x60000
> > + * Helper routine that performs KVM device tests in general. Eventuall=
y the
> > + * ARM_VGIC (GICv2 or GICv3) device gets created with an overlapping
> > + * DIST/REDIST. A RDIST region (legacy in the case of GICv3) is set at=
 @0x0 and
> > + * a DIST region is set @0x70000 for GICv3 and @0x1000 for GICv2.
> I would add "Assumption is 4 vcpus are going to be used hence the overlap=
".

ACK

> Also the RDIST is GICv3 only. In the above comment also mention the CPU I=
/F.

Will do. I wasn't sure if it was better to refer to both of them as CPU
interfaces, or redistributors (half correct in both cases).

> >   */
> > -static void subtest_v3_dist_rdist(struct vm_gic *v)
> > +static void subtest_dist_rdist(struct vm_gic *v)
> >  {
> >  	int ret;
> >  	uint64_t addr;
> > +	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
> > +	struct vgic_region_attr dist;
> > +
> > +	rdist =3D VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_redist_region
> > +						: gic_v2_cpu_region;
> > +	dist =3D VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_dist_region
> > +						: gic_v2_dist_region;
> >  =

> >  	/* Check existing group/attributes */
> >  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			      KVM_VGIC_V3_ADDR_TYPE_DIST);
> > +			      dist.attr);
> >  =

> >  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
> > +			      rdist.attr);
> >  =

> >  	/* check non existing attribute */
> > -	ret =3D _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, =
0);
> > +	ret =3D _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, =
-1);
> was that necessary?

Yeah, turns out that 0 is used in v2:

#define KVM_VGIC_V2_ADDR_TYPE_DIST	0

> >  	TEST_ASSERT(ret && errno =3D=3D ENXIO, "attribute not supported");
> >  =

> >  	/* misaligned DIST and REDIST address settings */
> > -	addr =3D 0x1000;
> > +	addr =3D dist.alignment / 0x10;
> >  	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> > -	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv3 dist base not 64kB ali=
gned");
> > +				 dist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC dist base not aligned");
> >  =

> > +	addr =3D rdist.alignment / 0x10;
> >  	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > -	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv3 redist base not 64kB a=
ligned");
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC redist/cpu base not alig=
ned");
> >  =

> >  	/* out of range address */
> >  	if (max_ipa_bits) {
> >  		addr =3D 1ULL << max_ipa_bits;
> >  		ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> > +					 dist.attr, &addr, true);
> >  		TEST_ASSERT(ret && errno =3D=3D E2BIG, "dist address beyond IPA limi=
t");
> >  =

> >  		ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > +					 rdist.attr, &addr, true);
> >  		TEST_ASSERT(ret && errno =3D=3D E2BIG, "redist address beyond IPA li=
mit");
> >  	}
> >  =

> >  	/* set REDIST base address @0x0*/
> >  	addr =3D 0x00000;
> >  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > +			  rdist.attr, &addr, true);
> >  =

> >  	/* Attempt to create a second legacy redistributor region */
> >  	addr =3D 0xE0000;
> >  	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > -	TEST_ASSERT(ret && errno =3D=3D EEXIST, "GICv3 redist base set again"=
);
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D EEXIST, "GIC redist base set again");
> >  =

> > -	/* Attempt to mix legacy and new redistributor regions */
> > -	addr =3D REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> > -	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > -	TEST_ASSERT(ret && errno =3D=3D EINVAL, "attempt to mix GICv3 REDIST =
and REDIST_REGION");
> > +	if (VGIC_DEV_IS_V3(v->gic_dev_type)) {
> Instead you could check
> =A0=A0=A0 ret =3D kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_A=
DDR,
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0 KVM_VGIC_V3_ADDR_TYP=
E_REDIST);

ACK, will do that instead.

> > +		/* Attempt to mix legacy and new redistributor regions */
> > +		addr =3D REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> > +		ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
> > +					 &addr, true);
> > +		TEST_ASSERT(ret && errno =3D=3D EINVAL,
> > +			    "attempt to mix GICv3 REDIST and REDIST_REGION");
> > +	}
> >  =

> >  	/*
> >  	 * Set overlapping DIST / REDIST, cannot be detected here. Will be de=
tected
> >  	 * on first vcpu run instead.
> >  	 */
> > -	addr =3D 3 * 2 * 0x10000;
> > -	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_A=
DDR_TYPE_DIST,
> > -			  &addr, true);
> > +	addr =3D rdist.size - rdist.alignment;
> > +	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  dist.attr, &addr, true);
> >  }
> >  =

> >  /* Test the new REDIST region API */
> > @@ -256,14 +298,14 @@ static void subtest_v3_redist_regions(struct vm_g=
ic *v)
> >   * VGIC KVM device is created and initialized before the secondary CPUs
> >   * get created
> >   */
> > -static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> > +static void test_vgic_then_vcpus(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret, i;
> >  =

> >  	v =3D vm_gic_create_with_vcpus(gic_dev_type, 1);
> >  =

> > -	subtest_v3_dist_rdist(&v);
> > +	subtest_dist_rdist(&v);
> >  =

> >  	/* Add the rest of the VCPUs */
> >  	for (i =3D 1; i < NR_VCPUS; ++i)
> > @@ -276,14 +318,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_=
dev_type)
> >  }
> >  =

> >  /* All the VCPUs are created before the VGIC KVM device gets initializ=
ed */
> > -static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
> > +static void test_vcpus_then_vgic(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret;
> >  =

> >  	v =3D vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
> >  =

> > -	subtest_v3_dist_rdist(&v);
> > +	subtest_dist_rdist(&v);
> >  =

> >  	ret =3D run_vcpu(v.vm, 3);
> >  	TEST_ASSERT(ret =3D=3D -EINVAL, "dist/rdist overlap detected on 1st v=
cpu run");
> > @@ -552,9 +594,10 @@ int test_kvm_device(uint32_t gic_dev_type)
> >  =

> >  void run_tests(uint32_t gic_dev_type)
> >  {
> > +	test_vcpus_then_vgic(gic_dev_type);
> > +	test_vgic_then_vcpus(gic_dev_type);
> > +
> >  	if (VGIC_DEV_IS_V3(gic_dev_type)) {
> > -		test_v3_vcpus_then_vgic(gic_dev_type);
> > -		test_v3_vgic_then_vcpus(gic_dev_type);
> >  		test_v3_new_redist_regions();
> >  		test_v3_typer_accesses();
> >  		test_v3_last_bit_redist_regions();
> Thanks
> =

> Eric
> =


Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
