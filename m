Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F8431A40;
	Tue, 28 Jul 2026 12:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241290; cv=none; b=mhGzLiMx5X1nat2Q5lCdojI8ikbN95JEqEGJu59l/Z3Dzb6csuQIMo4xUUNFib8uqJyJWz8pookVGme8xYoZNj/vtXh6Dwao+bji7se93WWtnDqtaQFGyl/dZW3EFXvHtm82PYIoqOr+uCa3hZfOglCWo9N/RA/1TBUBh247SSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241290; c=relaxed/simple;
	bh=lHIdQIeqxEaS80L+vB3/GpZlv/2XR+BEUSzTO48vec4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=btHKE6vm+gphEnbPem/inoOzR181SHQeXwZiWYSSroGG4BhFldGtmCs0ylIJgl53mPbmD8h/CW/hdcbsae8dS45DHmxT4ROOcao6+TYdpdAMiYE716srhsynyc4BJtUEmxwodEx127huxq31ZdlnVrcvFbnvor+uMS0duTISNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7gq4nh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7gq4nh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E831F000E9;
	Tue, 28 Jul 2026 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241289;
	bh=dJv/NZJ3ohlFKpJ5fUKWxUtwHbYNHaVnYnWKzedXwjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X7gq4nh0NjiKpCwc8/gZ3jHbQnArcpQSrKdLXTqqKa88XxgW4Gx2NOrI3fvjDMLff
	 gfS1C4YNBwo7q2Zl3BceWFMjhosNGsrKQnBUUXXiCjnNCiwBhLe8wvXcfw6oSZ66NJ
	 8z1YqWdI010GRnEQG/HUWlqzX7avnPqqrlu+LSvRUBVIuhuIZP0cQYwaJRNQUlVxf7
	 HTwaJmkm0DM2TLiYRwpqEXhOpMHCGFt+yQBD3c1iae4/SXyI27nmnuATCAGG41wXWG
	 NYIoP4NcxRPyQJOhxGVYy0OVjHpZxR042koeV7BUK+k/1QoTn8k/aILcXxQAupD575
	 Y6OpPvqof2cKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/11] docs: liveupdate: Add documentation for VM and
 guest_memfd preservation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260728121138.1103610-10-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-10-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:21:28 +0000
Message-Id: <20260728122128.D0E831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Mismatched kernel-doc section titles cause Sphinx build warnings an=
d missing documentation.
--

--- Patch [9]: [PATCH v4 09/11] docs: liveupdate: Add documentation for VM =
and guest_memfd preservation ---
commit a930d2f58a9edc06bdcfd10fb383e97d7fe3996c
Author: Tarun Sahu <tarunsahu@google.com>

docs: liveupdate: Add documentation for VM and guest_memfd preservation
   =20
Add Documentation/liveupdate/vmm.rst detailing VMM requirements, scope,
ordering constraints, and kernel-doc inclusions for KVM VM and
guest_memfd preservation via Live Update Orchestrator (LUO).

> diff --git a/Documentation/liveupdate/vmm.rst b/Documentation/liveupdate/=
vmm.rst
> new file mode 100644
> index 0000000000000..b8e8fb2b63c21
> --- /dev/null
> +++ b/Documentation/liveupdate/vmm.rst
> @@ -0,0 +1,107 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +VM & Guest_Memfd Preservation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +.. kernel-doc:: virt/kvm/kvm_luo.c
> +   :doc: KVM VM Preservation via LUO
> +
> +.. kernel-doc:: virt/kvm/guest_memfd_luo.c
> +   :doc: Guest_Memfd Preservation via LUO

[Severity: Low]
Does this section title exactly match the DOC: title in
virt/kvm/guest_memfd_luo.c?

If the source file uses "Guestmemfd Preservation via LUO" without the
underscore, this directive will fail to find the documentation and generate=
 a
Sphinx build warning.

[ ... ]

> +VM & Guest_Memfd Preservation ABI
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. kernel-doc:: include/linux/kho/abi/kvm.h
> +   :doc: DOC: guest_memfd Live Update ABI

[Severity: Low]
Does this section title match the actual title in include/linux/kho/abi/kvm=
.h?

If the source file uses "KVM and guest_memfd Live Update ABI", this mismatch
will cause empty sections in the generated documentation.

Also, should the literal "DOC: " prefix be omitted here? The directive
typically only expects the text that follows the prefix.

> +
> +.. kernel-doc:: include/linux/kho/abi/kvm.h
> +   :internal:
> +
> +See Also

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D9
