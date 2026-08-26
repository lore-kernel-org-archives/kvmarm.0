Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F8C39E16C;
	Wed, 26 Aug 2026 23:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785966; cv=none; b=E5uRdsQI5Oo0HdUO77e8dzJYU6+8jwXNgjgYDhEgjmJwvzABH/kMLbIDEj11mvubRwrRRj9WO24RPxiF8tf5OW+/2xUeivRs9TeBddJ12CDg0AiFCNSgpCp1C9FEOZ6EmwyTZttmUZ4x7K8yx2RRs8OA+aPmapa5MzE1fVDJyPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785966; c=relaxed/simple;
	bh=7px+YoKri90hxJTGXQSf2BwXZqtGPXPSwqJ9HEYROZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L66yyvNoZgsfm/Cir0cpJIznmXctP0dq917dC47Gf32OY7tVZt3jtbz/tW+ltWQItlUr+/60gKaQdE2NFVSx5WOcRobEhPBD4/SwAALEY1IQbnfm18tghhDNjP+qD9LMXJtgK4prx+5V0I3SgLWUwoD5wsPPPYOoumZLd3ZK7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gzpk5gXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gzpk5gXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF64C1F000E9;
	Wed, 26 Aug 2026 23:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787785965;
	bh=gEH9yFdq0TljK9P0XR0To4EasaNcp09Q6y9sLp3MDK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gzpk5gXP+9ktl0RD6/LAjwDjgVCdHPMZWYz56ivMIM3ssq5O2XFHjqlAfEkE5B6Mn
	 T5JfaafcspJ4GNmYpnfmxSzyA9+L2hkf9qM8eX21Ke1/p+STygBQ1E84wtQ6BqOXXW
	 FVWuowNnkYJSZJTHWtrbcBFMlEfW9TP+iyvHuo8djhmKcdEyF6Cj7ufHHqADbY03+e
	 IZFm5jKUtJjrzct2DSec0my8eFM0esrbrgUr8JP4PQEwXhnl3pIFx04EJ1H3oaCe3G
	 7sQmUILa6/VJW11s6yBeHP36Z8XoA3Y3vFFDTRhS+eD+6MPgoy93hg5TzQ5hlD4819
	 ZF98i/GT66qMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/20] KVM: selftests: Rename "num" param to "nr_pages"
 for physical page allocators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260826230511.972824-5-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:12:44 +0000
Message-Id: <20260826231244.CF64C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Typo in the new comment introduces missing and incorrect words, mak=
ing the sentence confusing.
--

commit 98eb73af6590845b3086e8d4eb766da617c1c334
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Rename "num" param to "nr_pages" for physical page allocato=
rs

This commit renames the "num" parameter to "nr_pages" in the physical page
allocator APIs to clarify the parameter's role. It also updates the function
comment for __vm_phy_pages_alloc() to drop kerneldoc style and explicitly
state that success is guaranteed.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 9ddc047d5c275..b071d77dd301f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
[ ... ]
> @@ -2025,33 +2025,20 @@ const char *exit_reason_str(unsigned int exit_rea=
son)
>  }
> =20
>  /*
> - * Physical Contiguous Page Allocator
> + * Allocate contiguous (guest) physical pages in a given memory region, =
at or
> + * the minimum specific GPA.  If the memory is protected/private, also a=
dd the
> + * allocate pages to the region's set of protected pages, e.g. so that a=
rch

[Severity: Low]
This isn't a bug, but there appear to be grammatical issues in the newly
added comment block for __vm_phy_pages_alloc().

Could "at or the minimum" be "at or above the minimum", and "allocate pages"
be "allocated pages"?

> + * code knows which pages need to be encrypted when launching the VM.
> + *
> + * Note, success is guaranteed!
>   */
> -gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			   gpa_t min_gpa, u32 memslot,
> -			   bool protected)
> +gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min=
_gpa,
> +			   u32 memslot, bool protected)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D4
