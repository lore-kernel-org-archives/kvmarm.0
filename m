Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02E71F237A
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749759356; cv=none; b=tk+cB4R6+LG5wefaT17AtYsLhOIn1Iz4EI5l1QHRkmFDo56Cx28OTdlxFFmWXiV/+TSF8EqvhHf3ZraT0+xMgHiTjiOntFQFz8hkbczCtSwMUFiB56qKaCbi83njP9dabPxf07XDGPZ0nUNQLGFrVXlBRAUHQpWpEwROIjDRazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749759356; c=relaxed/simple;
	bh=6qiWD4JXlRTSkr0OCRaCLJF5LrOxAnEBQoG5YvQMX2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Fz2Z7jncQD+dzgGshG+Fq0oFKzD/zw2HU3C36aEifAY/MZ4gRIBK1c4THTeu2hFnStkco+Vaj7rIrmvQkK9V4lIXmjwdm02KEcb0b920+wX5YjNb35wrs/127uEg9cJm8kGugGFjuoDKBRlGiVn7jm78JlrVVnbG7V3iPZTDlw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=O/61qFsW; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="O/61qFsW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1749759321; x=1750364121; i=markus.elfring@web.de;
	bh=6qiWD4JXlRTSkr0OCRaCLJF5LrOxAnEBQoG5YvQMX2A=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:Cc:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=O/61qFsWC+jsy2q8T+nUj4Cth0ry95AIGHDhC2oaqerD3418OvlNptTBmW85AMoC
	 mnyO8xQh2OpmWDbicbE8bQQk8B3iYE6BJaiIwTArq0wxp1czYYIDHAxB+DFHp/yml
	 DFfoZfRFkuzKLGe6ltaIAukKIWIbBhjY9bX1D/FiQUeF0huZuJpFqzdlCNB/6PGF9
	 N81vNLLSvlfCKOOj85gJgHbkySGlgZxTMj8jkipr1bDP0yeMduLpmgpts2W/5PyOo
	 QbKRuimmOM+k8m9J5oR1G4GLsHH/jTBJj2cdu/dJr0dJpLkrrOyoQymTpdxK5HwTK
	 myNP377FjEkEG4k3sw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.213]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N0qqv-1umon62TMT-011GGb; Thu, 12
 Jun 2025 22:15:21 +0200
Message-ID: <3537a4ce-b5e8-44d5-a884-70a81562068d@web.de>
Date: Thu, 12 Jun 2025 22:15:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v4 2/5] arm64: tlb: Convert the opencoded field
 modify
To: Luo Jie <quic_luoj@quicinc.com>, cocci@inria.fr
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
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
In-Reply-To: <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:pA7EGEjfJnflF4TE9tOyoGXxUB/CzNseX2uUxJifNOawy2xR3sw
 EpfU8UgiCF7Gkwcx+fgXhi8wIvPzl+Z1knLjb45m3UDFMU8K/nfuWw9NUvJ3Evp0bONcLYm
 6pRgCRt5Hwqlt+w524mTGSeQuG0RXzixxhhasYuD7PsfvRW2QzHuFbVbd1wisbV7nM8DrjW
 /Kdo1s6l3WTQSOLXK/9Mg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W0k8pYu0TLU=;0N+yz1Jd+j/p7C7cl3SIf5Tx+gs
 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
 THSY34RPGLT/+AIU

I see further refinement possibilities for such a change description.


> Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> - reg &= ~MASK;
> - reg |= FIELD_PREP(MASK, val);

* How do you think about to omit leading minus characters?

* Subsequent blank line?


> More information about semantic patching is available at
> http://coccinelle.lip6.fr/

I suggest to omit this information here (and in similar patches).

Regards,
Markus
