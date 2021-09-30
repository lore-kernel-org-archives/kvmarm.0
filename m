Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E394C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 20:49:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD2D16124F
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 20:49:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD2D16124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11BEC4B0CC;
	Thu, 30 Sep 2021 16:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fievQrOBX-wo; Thu, 30 Sep 2021 16:49:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C408A402A9;
	Thu, 30 Sep 2021 16:49:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21D2C402A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 16:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ujx-bGIySxOX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 16:49:18 -0400 (EDT)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6A8340068
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 16:49:17 -0400 (EDT)
Received: by mail-pl1-f179.google.com with SMTP id y5so4901333pll.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=kLLmidAxMlLrdM1tZPimMc82gDNJKFY7wcdU77wPZiU=;
 b=TBZgEJYjteguWk5616AMItXm6yve+qVhATFjz8gBV5WDFRGP1wZvHZTdm3IDmTtH1D
 1wB4ZcEIFkOupe5TkwbYhi23DS4PmIJ1eMdK3cFrKs3LWEYlApJDgT/x+b7rE/bNl3dG
 YaN+LYmVyVKxypCt4HU650OkabquPf9HEO3eFSvmuIGxqkeUEO2Y5gX+MfqSxp4XKijD
 /u2RhL2p98csvcwvFM4slYvwtqRwToATdc6lFUNHWAP5hcfY92C156Rb9aRciYF+Tzjq
 1jrYkI02ynQ8DlwF3+uHv1+23+LrcGWWGQ7GAfoLWskAgHuw+O7bTI+96CmvwYBVtzb+
 e5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=kLLmidAxMlLrdM1tZPimMc82gDNJKFY7wcdU77wPZiU=;
 b=dc3r6UWH1CyJf9n8yFh5sG8EllkDZLXtACWhzfeQ1C8v+9xh/kOJz+rmFQeUpLzm9M
 1VVALwKsCRwyt99iNjxcD3u3b+Vn3Spz5iw6rFD+RYLpRRDD1btXd83DZR6QzBG5yoWV
 59CRgfu4Voq3Qgf+6VLGuxrixiKC6vPJs9m1Lqbu0MgF12G44lfd41xLVXVJRMVNQQM/
 JeQJftaE0zpbsUark5gkqnxrQD91KI7wOuZyR8g9ExgIhhS3OJJa7XQ7vce2QCRmvlGO
 i3kF0qqLoXejXr88nwN9m/+KcdiDGBiZQFuSgcayR56ky6KvyWRXYj6AIDRauvCE950z
 42Og==
X-Gm-Message-State: AOAM533Kvk1yHOhHU0/ZI73yzYfIbjRpV/GC4RmRE8Y50q2P45osvYR9
 PhAdtAXkaKfSIOldsYrauFc/lA==
X-Google-Smtp-Source: ABdhPJyqHKzG5RrYTh9IkRhNrJWSMeZUZtw+hXM3xDqdNnmQt9Pjprn1kzoU/PZkNz3EuZS8va2WZw==
X-Received: by 2002:a17:90b:1d01:: with SMTP id
 on1mr15010347pjb.21.1633034956551; 
 Thu, 30 Sep 2021 13:49:16 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id d8sm3897581pfu.139.2021.09.30.13.49.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 13:49:16 -0700 (PDT)
Date: Thu, 30 Sep 2021 13:49:12 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
Message-ID: <YVYiyLnZtjgt7Zeo@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-9-ricarkol@google.com>
 <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
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

On Thu, Sep 30, 2021 at 10:51:05AM +0200, Eric Auger wrote:
> Hi Ricardo,
> =

> On 9/28/21 8:48 PM, Ricardo Koller wrote:
> > Add tests for checking that KVM returns the right error when trying to
> > set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> > addressable IPA range. Also tighten the IPA range by replacing
> > KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> > guest (i.e., the default).
> >
> > The check for the GICv3 redistributor created using the REDIST legacy
> > API is not sufficient as this new test only checks the check done using
> > vcpus already created when setting the base. The next commit will add
> > the missing test which verifies that the KVM check is done at first vcpu
> > run.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 46 ++++++++++++++-----
> >  1 file changed, 35 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/te=
sting/selftests/kvm/aarch64/vgic_init.c
> > index 92f5c6ca6b8b..77a1941e61fa 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -31,7 +31,7 @@ struct vm_gic {
> >  	uint32_t gic_dev_type;
> >  };
> >  =

> > -static int max_ipa_bits;
> > +static uint64_t max_phys_size;
> >  =

> >  /* helper to access a redistributor register */
> >  static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> > @@ -150,16 +150,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
> >  	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC redist/cpu base not alig=
ned");
> >  =

> >  	/* out of range address */
> > -	if (max_ipa_bits) {
> > -		addr =3D 1ULL << max_ipa_bits;
> > -		ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 dist.attr, &addr, true);
> > -		TEST_ASSERT(ret && errno =3D=3D E2BIG, "dist address beyond IPA limi=
t");
> > +	addr =3D max_phys_size;
> > +	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 dist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG, "dist address beyond IPA limit=
");
> >  =

> > -		ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 rdist.attr, &addr, true);
> > -		TEST_ASSERT(ret && errno =3D=3D E2BIG, "redist address beyond IPA li=
mit");
> > -	}
> > +	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG, "redist address beyond IPA lim=
it");
> > +
> > +	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
> > +	addr =3D max_phys_size - dist.alignment;
> > +	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > +			"half of the redist is beyond IPA limit");
> >  =

> >  	/* set REDIST base address @0x0*/
> >  	addr =3D 0x00000;
> > @@ -248,7 +253,21 @@ static void subtest_v3_redist_regions(struct vm_gi=
c *v)
> >  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  =

> > -	addr =3D REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
> > +	addr =3D REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
> > +	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > +		    "register redist region with base address beyond IPA range");
> > +
> > +	/* The last redist is above the pa range. */
> > +	addr =3D REDIST_REGION_ATTR_ADDR(1, max_phys_size - 0x10000, 0, 2);
> > +	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > +	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > +		    "register redist region with base address beyond IPA range");
> s/base address/top address

ACK

> > +
> > +	/* The last redist is above the pa range. */
> > +	addr =3D REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
> >  	ret =3D _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> Why this second check?

Wanted to test having two redists (just a bonus test). This one is
sligthtly more interesting than the previous one, so will just remove
the previous one.

> >  	TEST_ASSERT(ret && errno =3D=3D E2BIG,
> > @@ -608,8 +627,13 @@ void run_tests(uint32_t gic_dev_type)
> >  int main(int ac, char **av)
> >  {
> >  	int ret;
> > +	int max_ipa_bits, pa_bits;
> >  =

> >  	max_ipa_bits =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> > +	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> > +	TEST_ASSERT(max_ipa_bits && pa_bits <=3D max_ipa_bits,
> > +		"The default PA range should not be larger than the max.");
> Isn't it already enforced in the test infra instead?
> I see in lib/kvm_util.c
> =

> #ifdef __aarch64__
> =A0=A0=A0=A0=A0=A0=A0 if (vm->pa_bits !=3D 40)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vm->type =3D KVM_VM_TYPE_AR=
M_IPA_SIZE(vm->pa_bits);
> #endif

You are right, and this is a weird place to make that check.

> =

> vm_open()
> > +	max_phys_size =3D 1ULL << pa_bits;
> >  =

> >  	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
> >  	if (!ret) {
> Eric
>

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
