Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB1365D21
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846061; cv=none; b=hftDKMIzJfO9Dnlxyg2B7EPum8q5vnpDby3iq3uaE0Te9c2ohJG76OX2MXjdEjoMEQ8lW/pOAbSIp1xU4yNKEs4/4U9rTB0eAh0plPQfe8ZNpT97mlJQvvHyR0dzKEClHHzVsG/DhfQHikl/s2I8HM9Yho/v0jInsaIA2dRJejM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846061; c=relaxed/simple;
	bh=3KrA9M5w1PiW0CW1poq5OqzlB6ApiBlvsx/9+I6BFzc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=GRh3QMEah5bviEfVEUju/Q0yqa/5LPm+NpiuEykGIXZx7lJ9CwVl5C7RMytd8wrlgLKQ2loDY1q6ThSdefOyWgbcBrvLwiQiRA9qqEdsNm62P05DtEq+ybDi6UZD8s3Winh9f4OVOEo7DNcES8HYO35AfNZF9/RpB6Tc1a/IE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=bA0l6x/D; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="bA0l6x/D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761846043; x=1762450843; i=markus.elfring@web.de;
	bh=EfEyQRRkKmEPuB2iUtdTbDbVJBbOaxNhqPEa0eVlBt0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=bA0l6x/DhVEEMYZ26pGRsjHhVvOUDDf7OVphIroAR8UOkqZutcYBqeeD+4o8b7O+
	 SzdHALRcSwfJOrGELSuYTKyKO6WjfBY8g4t1SbrkIDZl/CeJ+uE8mur3PhmDuY5H2
	 2DdG69J3KP/6RNThA6BLO7Q7O0INMIth9ZCjKkAeJaGtYJMQXXQaNyLD40S/ptXAf
	 I/iD5pNFjLWlRptk9/fOHbarVFaAiTRK9SnhEJbqWCfP2PrtRyDnQGZ0gKkJmysPA
	 5GUtwrTuVTXyBVBbZk3RKqM9fNhAes1aJRJa2LyDOjSbeB9NH9mCCtZBs2P4k4VJi
	 +8y9v3ihlH3UZNW2VA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.248]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MtyA2-1w8ZCZ2b1A-010x9N; Thu, 30
 Oct 2025 18:40:43 +0100
Message-ID: <cb3bd42f-4fec-4300-8875-b6861716f274@web.de>
Date: Thu, 30 Oct 2025 18:40:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Andrew Walbran <qwandor@google.com>, Ayrton Munoz <ayrton@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Per Larsen <perlarsen@google.com>, Quentin Perret <qperret@google.com>,
 Suzuki Poulouse <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Miaoqian Lin <linmq006@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] KVM: arm64: FFA: Use pointers from memcpy() calls for
 assignments in three functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:S6gZxxuqFI/YnBJlSJWbqagIGXm2MkPVAXgzQCECJnvhPvPSHbl
 8dsy+i2tm+KblFXfuyLfRy/d0eYKxxHe43K4UtbNtoIfjGDX8XCtWtf/rs3nxICk7fxAl+x
 yy+ZuEK6Ys+ZQs+tp3ENZN075qoI7ypgHIE81H5YE4gKq+dFTnmzYlkcDFkiune3jTbr1GT
 KDyjRUHhzjvYmPvppj1Kg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ex01CIpj/tw=;+Y8a1e5ZdzdwNmA1D9YYqAMUHic
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 30 Oct 2025 18:25:55 +0100

A pointer was assigned to a variable in three function implementations.
The same pointer was used for the destination parameter of a memcpy() call=
.
This function is documented in the way that the same value is returned.
Thus convert separate statements into direct variable assignments for
the return values from memory copy actions.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4e16f9b96f63..4820a9e96f80 100644
=2D-- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -431,8 +431,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_re=
gs *res,
 	if (!host_buffers.tx)
 		goto out_unlock;
=20
-	buf =3D hyp_buffers.tx;
-	memcpy(buf, host_buffers.tx, fraglen);
+	buf =3D memcpy(hyp_buffers.tx, host_buffers.tx, fraglen);
 	nr_ranges =3D fraglen / sizeof(*buf);
=20
 	ret =3D ffa_host_share_ranges(buf, nr_ranges);
@@ -505,8 +504,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out_unlock;
 	}
=20
-	buf =3D hyp_buffers.tx;
-	memcpy(buf, host_buffers.tx, fraglen);
+	buf =3D memcpy(hyp_buffers.tx, host_buffers.tx, fraglen);
=20
 	ep_mem_access =3D (void *)buf +
 			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
@@ -615,8 +613,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_re=
gs *res,
 		goto out_unlock;
 	}
=20
-	buf =3D ffa_desc_buf.buf;
-	memcpy(buf, hyp_buffers.rx, fraglen);
+	buf =3D memcpy(ffa_desc_buf.buf, hyp_buffers.rx, fraglen);
 	ffa_rx_release(res);
=20
 	for (fragoff =3D fraglen; fragoff < len; fragoff +=3D fraglen) {
=2D-=20
2.51.1

