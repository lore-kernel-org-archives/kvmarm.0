Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965198;
	b=lwKUwhu67Br9lZWT8UF1byqc3XrO3iZtvIXBRIOCQoya1EqJDWJWN9mDcnG76W3ByiW0
	 Lwd21dAkyuEfNzMsRiMbg94h/zK35DOMNHkIrN2xoM+43JrqFDTiUqs88UJHtly3m6KIs
	 jE/dYorrkIJzHyUKjySzgcGr4pihWq7qafJB03bPHsFK17TGkje/F+6l47ETyamwxoKJD
	 2HINo5hrdO1K+7SL9W07unFvncW2+ZbRPeK/dS+RnR3r08dcrH35cZwLpPQPs2vMlAroP
	 92cHo4RAJaZGobFuaatyBTAu9y9f/a/KxjFSlYPHeSCcBrQR4hwHkcjEO3BYDb8yEoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965198;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=mTZ0g/OW6bu+fEj7cWkXua+TJ8iDpzumwowuwu98h78=;
	b=cvm/5MnhUjwKM9pRiv5CZP4skQhyNBTtpqXbsq/E0WgojGCsdpVq3GRBycoNnj5RFIFO
	 7PPFTRZtIN88bQjCiTwyaYCt6+yTpm9fYZnhcgCtnA+oPAqwWpDYQxemaOaz0Q6EWGX1Z
	 J0qYeZC+Y32Lf1oKnGVdxbUmv6FMuu+T1qckvBxVEUcOTlzKIy3zsjkJr+WD29jdETbaO
	 qYDAB5fvSDeL/wVBrA9KyADfKYp4gVopSUVjRcX9MdxX5KwQhtQGNgmMavO95Q4ZDdEjI
	 1xwoIzZLNctqG9OFA3fX6v6wz3IYVFLsH/d5TtVOaeaNwQp6FbH5s2F7Yl6XZpKEu1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UIavyxkf;
	arc=none smtp.remote-ip=95.215.58.153
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E2B606A905
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 11:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9E2B606A905
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UIavyxkf
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EKMXTx2vpiPIJLSsvUsSLP2IlFMynyqwRwz2o9btAEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793965196; v=1; x=1794569996;
 b=UIavyxkfi2HCRA7oOL/aZGhuloylx83PPFpQmzHQf4beic6+iKu358nMtNnsDysznwK9dM8w
 uQTm7KG60xaNCj6KeyHbtU5zh05e8SevtsphbJsI3ddwGG/J0Ql6itXewF+sHrHIH2/PdY1u29J
 UFE7Frmk3DRhLraDypsPcmNw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4b1460fc87441680;
	Fri, 06 Nov 2026 11:39:55 +0000
X-Mizu-Trace-ID: 4b1460fc87441680
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so2815e87.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 03:39:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxLU8dHzq9eb5SEEYWTfRfZNajatj7povIPWAlreeTV+xVobkLhVni3XZkzVIisVJAfvtQMQQA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+inWylIEXWwlMeopHVwQ7SoSElD56WSLR1S9XLkJ6T1Qt7mP1K
	/sIGj39dDNcwersNeZLK2/jEGeUDzOmox1UjNH9zalMg8Y1aZz7bFnUNS66dfTnm3QZWNCbpUkP
	DR7KfMKNlanjPX+UrI5owYtXsrkfRo7gYAyCuD3e7
X-Received: by 2002:ac2:4f13:0:b0:5bf:f1ea:16cb with SMTP id
 2adb3069b0e04-5c00641eea8mr70154e87.4.1793965189940; Fri, 06 Nov 2026
 03:39:49 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu> <20261105-hyp-pool-and-map-v2-2-44a6ca90190b@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v2-2-44a6ca90190b@cs.columbia.edu>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 6 Nov 2026 11:39:13 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzSKwuu6L8f0-=1s2XakCXJnM-k89XpagcwjSx6LX6wHA@mail.gmail.com>
X-Gm-Features: AclHuK_vcUGWgqA69ZP0FaHZ948pJbQiiig001SQ8BB8nTw7GVezSPYMrN2-Fbw
Message-ID: <CA+EHjTzSKwuu6L8f0-=1s2XakCXJnM-k89XpagcwjSx6LX6wHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Check the host stage-2 PGD allocation
 for NULL
To: xuheng@cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Xuheng,

On Thu, 05 Nov 2026 22:59:49 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
[...]
> The pool is sized so that this allocation, the first one made from it,
> cannot fail, so nothing in mainline reaches this path once the pool
> size is computed correctly.  Return NULL early anyway, so that a
> mis-sized pool makes initialisation fail cleanly.

Could you drop this patch? Once patch 1 is in nothing reaches it, and
before patch 1 pKVM init fails earlier on those machines.

The guest-side twin, guest_s2_zalloc_pages_exact(), is reachable, and
[1] fixes it by checking the PGD's alignment in __pkvm_init_vm().

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261105075606.367005-2-fuad.tabba@linux.dev/
