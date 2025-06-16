Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D32877F3
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750082040; cv=none; b=GyOw8qtYkKcHEHidRSg2xpPUGxHirtmUGmHijjLhQH+LZj+g70Gk8LpVSYcTwKMIJbUunT3YwN9L6QAyzGP5g1PV4Lvu90hhiW5Ky+so1D1qPzYtljAacGlhNAMWdiZ5NIzze6P7ySh3hgz4bzV2JMI5kPQY2i3A55TAqINX2og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750082040; c=relaxed/simple;
	bh=qBTbr9AtU/aUzo6QwAk5/zZnn8cPtDryqDIEdOlFLc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LytR4h8gtNWiEm2XKnW9xi6SCe4dJeAkd0pgVXWvLdV693hdjMK1wdvGhCP1kl2IeNY+hSYr5hurzmMRZcJleFbPDA/6PfDADwvPAoPm7owgtVrl1kjr9pPvmlr4MUj/Mfhe42LVmNXm6cr3/cI2CWLvudnE31urudSj/lIPBJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=NdX0rkeK; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="NdX0rkeK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1750081954; x=1750686754; i=markus.elfring@web.de;
	bh=qBTbr9AtU/aUzo6QwAk5/zZnn8cPtDryqDIEdOlFLc0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NdX0rkeKpFi2wIlhsTdZYRq0es3tOHZC0FBse+6FAy0K2aeI41bhGzWxVSM3m/tH
	 oiENrRkp2UpT/SpYP1950Ge8T0cCG/SPlWfItM00Nk7dC8ER72obaFBP62iFCQWY/
	 WUtGO7VSg36SL20QPRk0nAD2D1ZcOfogn/muo7Rr2qrRijTbS82EB9Jsgoa5JIndS
	 vAqcVP8xHca9HEw0Weol53+anUpK7e8nrj1swe/fMUSvKYR2Cuu86LWVsjiYVZjpj
	 LquhL+u+Lvl+Gu1uoHAhWZZoSaXa/lTN+QYWVq/VFRZFAbKl8paz8vbkjGFvKr3aX
	 svkH9Auyr/eUXTFZnw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.254]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N3ouw-1urjaU2Ptw-00sXOI; Mon, 16
 Jun 2025 15:52:34 +0200
Message-ID: <9b7e7e8a-c070-46e4-8e77-25117ec57de4@web.de>
Date: Mon, 16 Jun 2025 15:52:30 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [v4 2/5] arm64: tlb: Convert the opencoded field modify
To: Luo Jie <quic_luoj@quicinc.com>, cocci@inria.fr
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
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
 <3537a4ce-b5e8-44d5-a884-70a81562068d@web.de>
 <94b40ff2-9e9e-4eea-8a66-87d8976aeb70@quicinc.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <94b40ff2-9e9e-4eea-8a66-87d8976aeb70@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:L1Ntp29AaKwEMr4PnjAbJmXdbPkjxodHy7XTJKBBCbq5v/CmzK/
 qbVuMqVNzxJTnr1SJz7btoks3CV6ViLCzYXeXByLRuqHlR0LtEwA7HHZVZOMSy6+iIuoxyc
 nOOIFvaNjwB75QYPFqfzAiVjnb0O5+L3+O7DjAtPRkx8SLiFgFBqJpXfcTJpc8MbeHh1uOv
 TizVwhDRSobx3P0fqL4mQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RVf64evWiY4=;i78THtmf23u09RM2RgaXgsMiFpp
 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
 BQ6vM/IG6/NmXEsaNU/Bp/TSZAm7QWOzjXmSqA==

>>> Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
>>> - reg &=3D ~MASK;
>>> - reg |=3D FIELD_PREP(MASK, val);
=E2=80=A6
> I will review the generated message to improve the formatting as you
> suggested, the next time I use it.
Would indentation be more helpful for the mentioned code excerpt
(instead of trying to describe lines with bullet points)?

Regards,
Markus
