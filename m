Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C9FC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 14:29:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F0240B87;
	Wed, 26 Jan 2022 09:29:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nNbJLRYKUlWK; Wed, 26 Jan 2022 09:29:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2558740DF3;
	Wed, 26 Jan 2022 09:29:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE2240D01
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 09:29:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id whOs7CNqVvhk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 09:29:21 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5925C40B87
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 09:29:21 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1C7426178E;
 Wed, 26 Jan 2022 14:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC5BC340E3;
 Wed, 26 Jan 2022 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643207359;
 bh=mkzlzshfwmXGC5C35YNhdausZ28P0cfPjSTLQMvdsdg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=l+xIuCxCCzh0nxhuQkj9j0uPv1RhNkS6M51isL5dn/mbPFythrmY3OyQgdjy862mg
 u31suntXEKmF9obu+OQluiFHQox3RjItHPkEoWh2kfRohHBUBIWfrHPT2QJSaCsKzM
 F4IkoZ65Fut1gvcNaoA/EZtJwgpvzwYetC/GSWPxsinghCXVYiENlyNDIX1GG+GyI4
 GzuyNRgfWLty1UnWfMNuYtkPU8cTxvcfQBOBO5/iyRTf7CIC0xM91NEfdaTwefSlPy
 dMqY4OTJJds4VrHDVcXPhfsRUUrQGwD8LGdQI9ARMpAC0oVONQyBC76izA/kbueYtP
 86g9ua6EIBlcA==
Date: Wed, 26 Jan 2022 14:29:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfFauhK4FuM1/I8S@sirena.org.uk>
References: <20220126135319.1918802-1-broonie@kernel.org>
 <20220126141741.zxxltis5zdtjzz33@gator>
MIME-Version: 1.0
In-Reply-To: <20220126141741.zxxltis5zdtjzz33@gator>
X-Cookie: Use only in a well-ventilated area.
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kselftest@vger.kernel.org
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
Content-Type: multipart/mixed; boundary="===============1007224331892273410=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1007224331892273410==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q0r4KlKPWGD9cZBd"
Content-Disposition: inline


--Q0r4KlKPWGD9cZBd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2022 at 03:17:41PM +0100, Andrew Jones wrote:
> On Wed, Jan 26, 2022 at 01:53:19PM +0000, Mark Brown wrote:

> > -	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> > +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> > +	if (ret < 0) {
> > +		pr_info("Failed to create vgic-v3, skipping\n");

> Please use 'print_skip', which appends ", skipping test" to keep the skip
> messages consistent. Also, print_skip can't be disabled with -DQUIET like
> pr_info.

I see.  It might be nice to convert these tests to use the ksft_
stuff...

> > -	/* Distributor setup */
> > +	/* Distributor setup - test if it's possible then actually do it */
> > +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
> > +	if (gic_fd != 0)
> > +		return -1;
> >  	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);

> kvm selftests generally asserts on failure with the nonunderscore
> prefixed KVM ioctl wrapper functions, which is why you appear to
> be forced to do this nasty dance. However, kvm selftests usually
> always also offers an underscore prefixed version of the KVM ioctl
> wrapper function too for cases like these. So we can just do

>   if (_kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false, &gic_fd) != 0)
>           return -1;

And the _ version is OK to use in the vgic code?  The _ makes it look
like it's internal only.

--Q0r4KlKPWGD9cZBd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxWroACgkQJNaLcl1U
h9DGogf/eAFnfs352DIqX0ZCza8kHAZYU9UXqh6gAgNBgbeRICZ+kKetNtsj5efi
ANrpL5tKqb6cHfI3yz2p1dK+H37fpMP4STYGX0KOdqeE/W8a25US5pXd1OLBMPih
CON/GwSIe9tkPXlhiETSWHGXulnSg2h+JutOhEM6Tx0aqBySW7eOg0iBy3yOkUgk
68JIYTqD169Q3jFIP+8V/3wFI+V+A172GR5Gh8BmB29hITIUeEGYHsoMkzOW9GGd
rBEXBekq0U8GxMnWudFkH2Gfkkl/A306iu7cTgyYZhoBeR4ikQ7fEoYZt5wQo0e2
UZ4q8NqZbIhIxxGB9APUTjpKJm503g==
=e1L/
-----END PGP SIGNATURE-----

--Q0r4KlKPWGD9cZBd--

--===============1007224331892273410==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1007224331892273410==--
