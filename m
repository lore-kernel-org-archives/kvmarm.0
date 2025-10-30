Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2C2BE057
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761844309; cv=none; b=d6F6x+UxDhXmVxbHhLh11qNh49oJC3aHdxmBABpI9YnaI3MU/FAdps9Z0xsYSJXh0esdOvucti38AYfUM3uYzD8HLR5ScQQJBGwMzBscRUC1pswtHj8cAdm5PwV2DzRK/vua12c2G24R9UqLgygel9fuXqId9leTH2TIerkEpKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761844309; c=relaxed/simple;
	bh=w3xQ/IFC4bRYuvUl5HQvrpbvb4x1Naq0qy6bYNOooQM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Vby58u9Wzi0g/0iSAjpUr0NmFC65gPH+zJVvjFizFLp08ehCzbnQ4UnV01cFJ04nmvRw9NQqKo0BftAbNur+ZlyJgU+CngCWeiTTJIxMWDjJILOgzVQg5PYG3AsOYyoxI7ehRmlC4+We2kKFdUzTL1AopVcb5e/KN92TAauxpKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ikzeDLtH; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ikzeDLtH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761844266; x=1762449066; i=markus.elfring@web.de;
	bh=qX9jT0WVKNVZVkQFVvnvBU4twJtmXIXrEgsmm350dtE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ikzeDLtH8pSRBCH0hWG+C1Le3omfx0clVgdtTO203jLvQlx+eAfwBYu8Bc1oVS34
	 0hktkE5p86DAfbQ2V/5+Jo5Z3pD2jXssGBOVJQwL+l9NPERT6J1RZK8hmi40dj9dm
	 4GzL12PZUB/5GInBxbX9lWDALe2cnyzyCT2G6IwF++vTu8vz4eGjmE+KnscJuoKQz
	 3auugnlKUC/7Siy+3dS3N2s5F9psYvbRCPFPjS2E8nvHJpdxj0odfLnB3CUzphIiR
	 9rDDA6DD0GM4lRV7LROIwTOJ1Zjmsyz1fRLUKA1jsUeAyn42EVVTKMgNF/STh4JFK
	 zNdzXfLYo2PcavIICg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.248]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mcpqq-1vn1yt3hKM-00jfVS; Thu, 30
 Oct 2025 18:11:05 +0100
Message-ID: <6e962260-5069-490a-89fb-908a4342ccd9@web.de>
Date: Thu, 30 Oct 2025 18:11:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Brazdil <dbrazdil@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki Poulouse <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Miaoqian Lin <linmq006@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] KVM: arm64: Use pointer from memcpy() call for assignment in
 init_hyp_mode()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rK4JBHFEyHfa/6DyQX45RUvGECOdzSihIRe+9DLkEhLkLcTSO9E
 4ZhRHSVas5MJjtsEsmpa8myg+USRJayiWVGBntVwPbXEg9XHbzfOdQMehiM8tJCmNe/VBBu
 fwaOrY2d8hOzMztUtFxy5wInOeyd+TS8CgBDoQ9PwIgRjLbBAaWWtjcV83owIOQ7mPjvuRb
 vFVv+nP5M/RAtuCTj1JyQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Tk+C6iJsU0c=;tAwdVkpjT2CkaeumDL0GzshrToX
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 30 Oct 2025 18:01:41 +0100

A pointer was assigned to a variable. The same pointer was used for
the destination parameter of a memcpy() call.
This function is documented in the way that the same value is returned.
Thus convert two separate statements into a direct variable assignment for
the return value from a memory copy action.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..feab88c31703 100644
=2D-- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2600,8 +2600,8 @@ static int __init init_hyp_mode(void)
 			goto out_err;
 		}
=20
-		page_addr =3D page_address(page);
-		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size())=
;
+		page_addr =3D memcpy(page_address(page), CHOOSE_NVHE_SYM(__per_cpu_star=
t),
+				   nvhe_percpu_size());
 		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] =3D (unsigned long)page_addr=
;
 	}
=20
=2D-=20
2.51.1

