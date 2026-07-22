Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687F4779A9;
	Wed, 22 Jul 2026 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706955; cv=none; b=LKmpQKV40Ul7yvzcCxUKE6rkFp7ZDBi+rzuJEp22OZpMQpw4sZ2x4lboNMsAw4Na0NrQAzuBX11wcrvHCKPlL7CKgqrlkDUFDfMGEH4L+7xAeNZRlKMBuMxPns0rjbbl1yeXHB/n9TJSOvFxJTc4AlXofoPFeA40XPT3V6wCK3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706955; c=relaxed/simple;
	bh=W/WwTYIkbrX8+0XI6DdVnzC8HVK2JrHkBa2HmSnpS+Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=If5f24l9rFwJ3Gi/bmGLm8dH0qV9/fY5wpW14+VRwfU8ysZMsUNCr89oVmC9TS77jkjOZK8XtwJSVn3oGlHssATPf5gJCg9NbmIjgxD9EkWh2GyQOm1/78vpLmxsgMNWEduNcSlRQATbRUzXTr4aMwSzqDorRWO293h3Xo7q4vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJmnp4rl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJmnp4rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B11F00A3A;
	Wed, 22 Jul 2026 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706954;
	bh=EdAvDpZtxvvUAksCXkcGmSkSaBVrMoPqgwDcfsUCJQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SJmnp4rllq9owXwDhU3xzOeVsmWy0Cnv0IjAaM61rcMGZrkYkBH423OeLKEG4TdVe
	 G8e8eu1NpZt0Zurc6pTc8hiNzLDmlwRWw4pFmJs3bGn01ecNUYh9CR6uL8U2bRcX6X
	 oJI2VbtjxH1ltEI0JIou2M8vnM25pftOvCYEcRLWyGjtgExPkqlm3wHkLK/lIrB9rB
	 hbf48sdKgEaswqlhVJArRJ86LxQE7BqSnFuKwHJ6qVslAaxWYIXeIE8v3rlnGUiUAm
	 0xic0LX35+PP5RJLtBPUL9/ZJyy3AGuxzQNn54qATEH/HyGcEu2EY/5jsw3qxv2TD0
	 qJyVE9LbM6Z6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/28] arm64: sysreg: Emit RESx/UNKN values for
 Mapping/Fields definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260722074234.3330999-2-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 07:55:53 +0000
Message-Id: <20260722075554.137B11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The updated comment explicitly claims '"Mapping" does emit the RESx=
/UNKN definitions', which misleadingly omits the fact that the 'Fields' qua=
lifier also emits these definitions.
--

--- Patch [1]: [PATCH v3 01/28] arm64: sysreg: Emit RESx/UNKN values for Ma=
pping/Fields definitions ---
commit ed28be9bab17b360a9e12769aa91d7ac6b649b8d
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions

This commit relaxes the rule that skips emitting definitions for Mapping
and Fields qualifiers. It updates gen-sysreg.awk to emit RESx and UNKN
values for both of these qualifiers.

> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysre=
g.awk
> index 86860ab672dc7..e099f7d3b2833 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk
> @@ -228,7 +228,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysr=
eg" {
>  }
> =20
>  # Currently this is effectivey a comment, in future we may want to emit
> -# defines for the fields.
> +# defines for the fields. "Mapping" does emit the RESx/UNKN definitions.

[Severity: Low]
This isn't a bug, but does this comment incorrectly imply that only "Mappin=
g"
emits the definitions?=20

The condition on the next line applies identically to both "Fields" and
"Mapping", and the commit message notes that both qualifiers are being upda=
ted
to emit the RESx/UNKN values.

>  ($1 =3D=3D "Fields" || $1 =3D=3D "Mapping") && block_current() =3D=3D "S=
ysreg" {
>  	expect_fields(2)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D1
