Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33632F430D
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749746934; cv=none; b=HJ7ripLRO3qjFPDod2CvxWZQBE7q5//LeJ8qYV93s5ozR4DXPt/3ohomzzXTRh1hW0qREIDEQ2icEwim0bAEoyh0tWfrC5KLMBqgwNnNAr2MB5RQVKayzRSxGf/upOTNx0cjZS54nYy/acxseodJGBAZiClPkyTHKb67O+IsUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749746934; c=relaxed/simple;
	bh=cnrtHuLSnHhkaw5++Xi2CqlDQT9Sy6ElLKZ+GhU6NKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=AseOc0MZ/YTsrf4qWfp772lwcRNOwaiOXlWW0eaV12GQJBztlKlWeTeRx3rHaibJvjrdQIqckcjHbxhJFDOE4CSKiyarUYdy7YxqPtk45T6eu13ixtT310eyX383SGWkpjD7as5Pm8+5poWwQVtf8YAohKHqn7PGlQ+ZHCSoSvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=oULeuCSf; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="oULeuCSf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1749746907; x=1750351707; i=markus.elfring@web.de;
	bh=v/+L6f/1uHzWnn9d+9wYdEO6UW4NdjChdkgAdlxXmrg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:Cc:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oULeuCSf9Sbnd3qn8vGzLM1Fvxw/fzfSMKT3bFwAWJMVklyRvL6LpNwZsYp1bEV1
	 xMKeFvnz1WauR9T7jYaPKffjtP7gl1EPhPwnIHPnhhWSIElS3M6GL9L14upE5GeW3
	 HHfSWgkn0BabMBL7qNJ/tGSpfLGuOVQhBLfcY9tF3BqLJUQt1qD/bQd7MgxTa1G4O
	 Wti9SJOeE8L3QO1a1PuuuFEfra4ChN3vl3T1K16qJ9F+x4yBQANcjkg59vQ15Q3cq
	 6dHVOMxGaXOEGJ3hZYkKInhAgSptyqrOPKvOmQB+1gXYBvD0Y/JzxLZ3d3FPxhX/9
	 JdFru0RoyB58W8GmPw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.213]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N5CUp-1urDcU1OZJ-00riKD; Thu, 12
 Jun 2025 18:48:27 +0200
Message-ID: <77406d43-230f-4690-b306-4d698449c01b@web.de>
Date: Thu, 12 Jun 2025 18:48:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v4 1/5] coccinelle: misc: Add field_modify script
To: Luo Jie <quic_luoj@quicinc.com>, cocci@inria.fr
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <20250612-field_modify-v4-1-ae4f74da45a6@quicinc.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Andrew Lunn <andrew@lunn.ch>, Catalin Marinas <catalin.marinas@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Kiran Kumar C.S.K" <quic_kkumarcs@quicinc.com>,
 Lei Wei <quic_leiwei@quicinc.com>, Marc Zyngier <maz@kernel.org>,
 Nicolas Palix <nicolas.palix@imag.fr>, Oliver Upton
 <oliver.upton@linux.dev>, Pavithra R <quic_pavir@quicinc.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Suruchi Agarwal <quic_suruchia@quicinc.com>,
 Suzuki Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zenghui Yu <yuzenghui@huawei.com>,
 quic_linchen@quicinc.com
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250612-field_modify-v4-1-ae4f74da45a6@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UzKkftK+8VBIQ8zZF1Grhg2CG5pgrqfHBd7AQzZq0RLtAcod8Gk
 EMQmvWcuAKpkDnY30sv8oPuXMFXm8WWJdnXJTVbs0wZ+6Wj38MIeOyvcBfJJwhaedbVR9SN
 K35gc21Uync3Bf6bVP3s22rzYrdFyR9lHgR4PfQ9ir9TLBEv2X+GyQrK37aHesGQ2ZrvNDL
 5NQIGiKfHrR0c8C0nbeSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xmzVfNKDDmw=;EUX4lV23la1vGW48h/NMjdiIgwW
 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
 HZYrzrjuPjG33emz

=E2=80=A6
> ---
>  scripts/coccinelle/misc/field_modify.cocci | 61 +++++++++++++++++++++++=
+++++++
=E2=80=A6

Did you overlook the addition of patch version descriptions?
https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pre=
viously+submitted+patch%22
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.15#n310


=E2=80=A6
> +@ depends on context && !patch && !org && !report@
=E2=80=A6

I imagine that the condition selections can be simplified.


=E2=80=A6
> +@script:python depends on report@
> +p << r.p;
> +x << r.reg;
> +@@
> +
> +msg=3D"WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
> +coccilib.report.print_report(p[0], msg)
Do you know that a string construction can also be directly passed
to such a function call?

Regards,
Markus
