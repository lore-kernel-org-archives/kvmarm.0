Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA3306D3F;
	Wed, 18 Mar 2026 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856235; cv=none; b=qV13YfpubHhMgcPMkuWQ5sBQ+L5DeqayUJUQNeXxeRsMALnf0WysuD1respL6cJXEm3jfBrKSCNVu8SHTqQ4dxP/Syf2GTi6/sgFWOvsDsoVxnca+FZJCZ4Bqr3H6blhwjnjxP0EnIrY9vhHBry9mPWIMudNcYzwWszhZqK4MWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856235; c=relaxed/simple;
	bh=yY5/7b9upughYC3SjZivmgk/LeNfjtglZwOe0Pmiuss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/lhag5TR3BWR3aQtpLMvfWy2wNiD2IasVXQZzAgBhw5bYVCt57gq1wZdPXIT28PHDWH3Q/gdk1z9PoBZsjdhQbS5qk5t6G+tBW4XPKUBQ7H5COeyQAK6kNS5UXgw5N/CiiRygnNT6sTA7hE9O5n0YRtduN4FvP77uUafNxuaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFzHOehq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFzHOehq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF59C19421;
	Wed, 18 Mar 2026 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856235;
	bh=yY5/7b9upughYC3SjZivmgk/LeNfjtglZwOe0Pmiuss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oFzHOehqxPUBE7i33A7/NP22cW2clKfq9HsIUn7W7o4UHr7O9Lz9Wmkw/PPf2wkHI
	 ctC2BWjwX8axh8JicFZcyV9D2zPPPewV92QGVgApK71nEBzHnSzVhqy5SyaEanAh/O
	 bJULBoZWTqa8HIoOjsslsg4nFfniEa4ws77JYIoBhQvx2lVojRQOCfL5bDv9mQFzqq
	 6qv/h0sSEjO0+6M9lbDW3+Jocwxh4Ql5eBhtCdOtvdVaWuHUOMoiUOaTkVPHFsYE2w
	 XZjZisZ+6yJKDaDv9yzd0hbYe/9omcj4qQBJmjYPH7uBxxJvrrI8U0JZ8QjkU5JvNB
	 SeJTkOn/TCowQ==
Date: Wed, 18 Mar 2026 17:50:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Philippe Brucker <jpb@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 09/30] KVM: arm64: Define internal features for SME
Message-ID: <4403381b-c4a0-43d4-8b24-b0d0c1e75d24@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-9-43f7683a0fb7@kernel.org>
 <20260318174410.GG2390801@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VvvcpSFxAc69oYKR"
Content-Disposition: inline
In-Reply-To: <20260318174410.GG2390801@myrica>
X-Cookie: The coast was clear.


--VvvcpSFxAc69oYKR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2026 at 05:44:10PM +0000, Jean-Philippe Brucker wrote:
> On Fri, Mar 06, 2026 at 05:01:01PM +0000, Mark Brown wrote:

> > +#define kvm_has_sme(kvm)	(system_supports_sme() &&		\
> > +				 test_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &(kvm)->arch.flags))

> Can the GUEST_HAS_SME flag ever be set if !system_supports_sme()?  Seems
> like it depends on KVM_ARM_VCPU_SME feature which can't be set if the
> system doesn't support it, so the system_supports_sme() check is redundant

It can't be, the reason for the system_supports_sme() check is that SME
is a build time option as well as a runtime one.  If the kernel is built
without SME support then the compiler can remove the code at build time,
the existing code does the same thing for at least SVE.

--VvvcpSFxAc69oYKR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm65eIACgkQJNaLcl1U
h9C7Xgf/buA9UbqSWGotQIhCCZi2M8eucZopqvd2y+Yz8RG3CGGJcgD210T2RV24
2IbAutf88VUJrFR05vpgpG9gonNcjRjEvn2/eV3H8+WdYm4Ux9/TZJqkwuJaS0Jf
39osJNAabwFqCXDqefCQim9F3CLM2T3uw9wqnJfUtYtQw8GHF6s1W1H8aQDwTtkv
kjWYT4mxAx42Ta5pmQdK1oIm01baX1EdxIoN1IGi9wDGb+snfdVos4ncMJzpeX7R
S8lhOFeaJBjRWmF8MP9AGE42bI39DrkJmWx5PySdEQaOZn4NHuwezaggAA+hiI35
x6P1xYKFo3bdSU5DNoh79SXWEfgziw==
=4AVX
-----END PGP SIGNATURE-----

--VvvcpSFxAc69oYKR--
