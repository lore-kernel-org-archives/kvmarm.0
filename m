Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603B2D3A9E
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 13:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773291; cv=none; b=mp/sMRjcUAojhDianJJk95nqcZDYfHJbmcCEluTOZKavAQdnA7SWxSR1YwXnCls+pYAHy8Qh4RFCR/pL/g/9QqLoPx5RR1kZljvk3iP++k2vbXF6jO6Oxh6YIbwq84sWSEX9YoVlqNEEB/jqcfWzOAp66IMeaQsk9ycswdKBmaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773291; c=relaxed/simple;
	bh=nAspC3WP7Npov8DZfWyyVTwC7r8mOQn9CIkK1tgRJnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYb0ollpPULF7bQN2XUFLJri69iw/kUa0GTDhzjS1zv/BgR5x7+NRRmc1I0gDhsUb6sRKbcLJ+3woapFUtHTPNLactK0oTr8nC5aF2e4nSFQisKdG85s4lK4vvyTga4+URCsQ2r1uvKGHSUgPaAzmwIB0bEUtlV2I7USwfqDv5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=JmQfGbdr; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JmQfGbdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1750773258; x=1751378058; i=markus.elfring@web.de;
	bh=nAspC3WP7Npov8DZfWyyVTwC7r8mOQn9CIkK1tgRJnI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JmQfGbdrycpf7iW1IaEmxK9XgDFX7goswEPbfiNqzDUfbjDn2AfASqGC7NxwgHDw
	 Yq8NXs5p2vUlW1yPyUl+NOXNzTzsPmMc9eQmpOPlQPMqMP6CjngQpfKMQkVLfVINX
	 h79nCuGUjSAROTkYzHzsggf58JN40aLpoe5CrF1LggPd3TJOTTNI1QhGahsVtuaBq
	 QNYw9Nu4Ze76Hmrt2x2xzB93cmMA9KulOjbkm941fB2Y0CethWUo0ZqPKnkLi6/G9
	 nnuCzGswGOqUf3mIlC99cgo8oC0+K/A6fbvxP0jE1hMO+X3RsYrWpNV1pVdvPhKz9
	 4PygHQsydPue8x6JHg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.200]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MCXZh-1ucYQb2ZZj-001XJX; Tue, 24
 Jun 2025 15:54:18 +0200
Message-ID: <e694666a-ec94-4443-bae7-54ac2f0f0e7d@web.de>
Date: Tue, 24 Jun 2025 15:54:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] coccinelle: misc: Add field_modify script
To: Luo Jie <quic_luoj@quicinc.com>, cocci@inria.fr,
 Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Marc Zyngier <maz@kernel.org>,
 Nicolas Palix <nicolas.palix@imag.fr>, Oliver Upton
 <oliver.upton@linux.dev>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Suzuki Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
 "Kiran Kumar C.S.K" <quic_kkumarcs@quicinc.com>,
 Lei Wei <quic_leiwei@quicinc.com>, Pavithra R <quic_pavir@quicinc.com>,
 Suruchi Agarwal <quic_suruchia@quicinc.com>, quic_linchen@quicinc.com
References: <20250624-field_modify-v5-1-cd67127030e4@quicinc.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250624-field_modify-v5-1-cd67127030e4@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:BxwhYr5KPqaoChoZS4nBRipO+hb3znKQbMhT2/FewqmcxGiFGXm
 oChwojR/Ygi3iDg4j7kznTwoKuaAZakLFtDxb0W5BEeZKWQPyZU/UcUTV0p3RelvLTq2TOi
 FoELt62MsZEUdfIuU3EJwMibjHNJcyMsfO5IvkfnMOJ7hhxqGckQd/lAG4CrabfYzEK2Sva
 4kZsMB3Vo/2Faa6nasy4Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jweyu8AFEUU=;KIKiMtgt6YoBvgg1ereISGrRNuy
 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
 bqQ3P+e

> +msg="WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
> +msg_safe=msg.replace("[","@(").replace("]",")")
> +coccilib.org.print_todo(p[0], msg_safe)

How do you think about to use the following code variant instead?

msg = f"WARNING: Consider using FIELD_MODIFY helper on {x}"
coccilib.org.print_todo(p[0], msg.replace("[","@(").replace("]",")"))


Regards,
Markus
