Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E2A242910
	for <kvmarm@lists.linux.dev>; Sun,  4 Oct 2026 08:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791100878; cv=none; b=P54oF1v/USBjGouGzIoxXODfhoQJq0FWxkZ6QtjmxIUUkTAdWO12WsdMsGTs3LzfUtrh15zy6MJiHD+n2PQakK9avXMK+wCGR47lrnCEn9DXFY79O5ZLQaZ8PkdCgSDKi0k+nuoLdMTBQNtBvNMum50hxz78idIILKrc7R541kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791100878; c=relaxed/simple;
	bh=9M3x7X8al5SvKY4/uuzHfOHfRDjeMR648jQnVaDLq+w=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=IF4p8Dm1tPGaj5oKC0SawR3QSuDbMLwlJto/ZqPlGlogErOTYyu8fbFttL1OxVavoSzKmszJnP4Re3RJka7aq2HxPm106Ibst6nElp8PtImzvAY7Ru5sNQ177Mh5c9FyV2HElrlnRiyaPzKjzF3qcdJVwNaDusXnlPcf4OEy/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PM2le/HC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PM2le/HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8151F00899;
	Sun,  4 Oct 2026 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791100876;
	bh=F9kBSf7wm8l5Shredw3rUxbEz7kCjNDe52nqsiHGf7c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PM2le/HCwH86RAFv+Jo+sJCLAV783qk5VH3uI2+CdKaPtYAyY/CKWXVxUAj4qwQdx
	 KGjaSgK806uWpAviyVLRX3dwjKNKaQcwAidYIgqUr8atlA6RnS6DBk04gEUWHPDj17
	 lEff1PZov1zc5QhssrAnEIYGyF3j8me87JlN8rApUEf2VKU/7MWnpCcF12B9TpTcSo
	 p7rgwMyamssXTbSdwdqR6eMfSshTw4Apv3UfIYZhNEzZoSkfXtexFYKzXEO2WmFaqj
	 dcrIE2gawvhPXVpRtg0jm6mcNPOYSdEqFJpawzsqcFRJoM8TvqyOUgGlpB65XiduDr
	 zt5ZPmXaqbxZQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5220E198003A;
	Sun,  4 Oct 2026 04:01:14 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sun, 04 Oct 2026 04:01:14 -0400
X-ME-Sender: <xms:xwfCakEod5fFvxOBBv2kiOyyZv7rRjgxgGbSFAP-Ei9-6ZhIlQsAAQ>
    <xme:xwfCaoJdYeHsNYdVgnotXfcdIuESrAJ4RkR86I-blYp4IDhYMMR8gYhBDwuoACyJY
    LmLcYCthRMkizG0pRkcCyemUaAhs8047u6A4WY86E0FDpCznFAxRs-m>
X-ME-Proxy-Cause: dmFkZTF7bRBgwhxff1sp0njzeucjRIZKeidM1lEvn3ZkcmfabbQS21vmUcl/545EvBZxYC
    zmeS4tx/0rEzZEMw3ccK+pwEOxmlfLHDn+oPtpWd5pOzFhWZ8qx0nN1aELo4ar9rn24ijj
    lt8/erIwFtrzSrAHD113d22ZYP8CFMJmR/vDmycv/nC2SeWpI9uH5xe/IEscARpoJxgo46
    FJv1pR6b9wBRLtsf81TURnFMk8GOO51bYmfLKA142e69wg5DdI/KUAwLwfVSgyRCgJF6WE
    BL4Qhsvf7BTn5Mh2kVIGZnS/KllKOa3Dm3r+PB37qaKuRaOSVAsz9QxnDOVGQ8hf8CEFfH
    abwBjdSx8Nnjut7m2nkZzlH/6bsc6PLml+YXqrkIsy4Iy73vIjS5gdD+w8R3Dd1VLIalF1
    JZSd7edsqIb/gBKQZ+h2jjgU7KLM4Oab/A+4fazFPOH7jaIruJVZPUOjtHfXOzaCMIvYnm
    KoB1sgpVxHBxni6yuuQtuYamVXhQkBMYmc6YAILTmxYTiLqIp5uG4kv5XNQGD+yuXfuZPa
    VOR95jGwFdW5IhZKkce6jsBhvCmzs5QONFECOW1LQbtAT5T0vCOwUOZRHeO66Qs3wQ5U9Y
    WnTO5s8R+uyUsgLdrKlklFCL/KmCKg7R1uJkRPbFIAtlS31F8Yj98JDGX+CQ
X-ME-Proxy: <xmx:ygfCagMBEWJ0TC2y822tslwIkU9EGr4a1dl-1HA3EO5TxVYrvxKbfw>
    <xmx:ygfCaiYyM5Cb-YEttx2FGt_2OddfYJxKFQQ18bowOg7B7FbeVTizRA>
    <xmx:ygfCal-k0-OvCYXRuNIn0hf10SL5f1xA9E2t3rIZVUvQCHqbxEAXbg>
    <xmx:ygfCal2FAGmTPivKNvlif1cvHitcH4BsqFj2VPgq_nCxLp66pfjdTw>
    <xmx:ygfCau2iEO2Il_VijwzWz-tuMXBEdpbKieehYZzfHoRW9wkRi8MjCKIw>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 05795F80096; Sun,  4 Oct 2026 04:01:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sun, 04 Oct 2026 10:00:50 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 "Linux ACPI" <linux-acpi@vger.kernel.org>, kvmarm@lists.linux.dev,
 linux-efi@vger.kernel.org
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Linu Cherian" <linu.cherian@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Lorenzo Pieralisi" <lpieralisi@kernel.org>,
 "Hanjun Guo" <guohanjun@huawei.com>,
 "Sudeep Holla" <sudeep.holla@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
 "Oliver Upton" <oupton@kernel.org>, "Fuad Tabba" <fuad.tabba@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>, "Steffen Eiden" <seiden@linux.ibm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Message-Id: <52231d93-98f9-4413-9e0d-4bc7ec7666db@app.fastmail.com>
In-Reply-To: <20261001110655.461473-9-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-9-kristina.martsenko@arm.com>
Subject: Re: [RFC 08/12] efi/arm: Check return value of init_new_context()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Thu, 1 Oct 2026, at 13:06, Kristina Mart=C5=A1enko wrote:
> init_new_context() will soon be able to return an error. Check for
> errors before continuing.
>
> Signed-off-by: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>
> ---
>  drivers/firmware/efi/arm-runtime.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/arm-runtime.c=20
> b/drivers/firmware/efi/arm-runtime.c
> index 3167cab62014..7ef29cd0bfb7 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -55,7 +55,8 @@ static bool __init efi_virtmap_init(void)
>=20
>  	efi_mm.pgd =3D pgd_alloc(&efi_mm);
>  	mm_init_cpumask(&efi_mm);
> -	init_new_context(NULL, &efi_mm);
> +	if (init_new_context(NULL, &efi_mm))
> +		return false;
>=20

Can we make this a WARN_ON() so any failures are not misidentified
as invalid or missing virtual mappings?

With that,

Acked-by: Ard Biesheuvel <ardb@kernel.org>
