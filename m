Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A823F3C37B4
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 06:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780556394; cv=none; b=TkAHtjM/jbgp8gzz7Qd0zo8cvSI0ggeFiT2FD0tXy0wG+dCe8X70pqRXHPiZRst12qcolKzl98fmosNvmyHW7oEr1+Fs5f6V3pzxoskfKJMvMAtmPKD/Fn8ZjESnnWo+uDbRgcHyy0G0n/qv8sF98EHgtUBGh2t6idr+Csa07WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780556394; c=relaxed/simple;
	bh=QnXRONpNlSjysoSdbGBCNj+OfXgnKW+XPqOyXlgH7Nw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=jhUQbxs47FuZG3UGLB9YcSY4WpwiXZhvz+qFCR2exxwqE/dE9j3PQglR2fQ9gHhr+WUfqjOlaYzXPg0EMpw8Zz4LzngUPHMK24bH9NlEMYcxK78mDWdR2j3I6Ylymi7RB9rkwoUTiLgtNcGo7VTTtJ4yJBmpKjPFrNjNrKz+8lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q1SjqbTA; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q1SjqbTA"
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780556391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89fgQI2MyG5GwpzH4bnJ+61l5og0hczL62ghWcdv4i8=;
	b=Q1SjqbTAiGs06RwvRDUK/EqJrxv6iRhxFv3Vuje1OIEYQTdbbxCZtsxTEhirAP7gUbY42E
	ihDvn+H9+1v9SgLCNIciuaF2xArOsxSnQ3ikuBZrTx2XPwUT3ILJw0m1F9O5k6A+xx3cau
	LuB/Z3sx+4Y3g2NwvULBvCKRm2EkFZA=
Date: Thu, 04 Jun 2026 06:59:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jackie Liu" <liu.yun@linux.dev>
Message-ID: <0bc286797b469d93631cb3ad2c99e135f49d5200@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] KVM/arm64: vgic-its: Fix memory leak when
 vgic_its_set_abi() fails
To: "Oliver Upton" <oupton@kernel.org>
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 yuzenghui@huawei.com, will@kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <aiEeKGsLg9098OUt@kernel.org>
References: <20260604031426.16109-1-liu.yun@linux.dev>
 <aiEeKGsLg9098OUt@kernel.org>
X-Migadu-Flow: FLOW_OUT

2026=E5=B9=B46=E6=9C=884=E6=97=A5 14:41, "Oliver Upton" <oupton@kernel.or=
g mailto:oupton@kernel.org?to=3D%22Oliver%20Upton%22%20%3Coupton%40kernel=
.org%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Thu, Jun 04, 2026 at 11:14:26AM +0800, Jackie Liu wrote:
>=20
>=20>=20
>=20> From: Jackie Liu <liuyun01@kylinos.cn>
> >=20=20
>=20>  In vgic_its_create(), if vgic_its_set_abi() fails after allocating=
 the
> >  its structure and setting kvm state, the allocated 'its' is leaked
> >  because the function returns without freeing it.
> >=20=20
>=20>  Fix by rolling back the kvm state flags and freeing the its struct=
ure
> >  when vgic_its_set_abi() returns an error.
> >=20=20
>=20>  Fixes: 71afe470e20d ("KVM: arm64: vgic-its: Introduce migration AB=
I infrastructure")
> >  Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> >=20
>=20vgic_its_set_abi() always succeeds so there's no actual memory leak
> here. I'd prefer getting rid of the return value instead.

That was my original thought as well. However, I kept the defensive clean=
up logic in place
to make future extensions easier. This way, if additional resource alloca=
tion paths are=20
introduced=20later, we're less likely to miss the corresponding cleanup.

That said, looking at the current code, the return value no longer serves=
 any real=20
purpose,=20so removing it would also be a reasonable and cleaner approach=
.

I'll send a V2 with this change.

Thanks.
Jackie


>=20
>=20Thanks,
> Oliver
>
