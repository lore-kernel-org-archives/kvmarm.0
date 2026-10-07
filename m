Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A24440A94A
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355583; cv=none; b=o4Sh71h7U8gLuk5tpWv4YZiUv7Lqt5jSCtquy56H6pjwPYbneIbYrGzORk83u7/Lmg8e9vLpcM+U7M1q5zpvwwfxZxUiDOnlPW7S1PVG/Cht8RhvMYuw6TUbOVi4SJ59Y8XXegr7dAsRx/4bggoFoN4mF1CcxjVoxaZED/wkj+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355583; c=relaxed/simple;
	bh=U3Wf62xC5r7GPaaJsND27Q/x6Q226FUTfzXzF0+A+bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uYb4cF20CyjixXRw/AROeNyqIP7fB4RSagcnMlqu831uLolOeHDLFJSNXmNbg/YEgMAH56zXt1voejjUSuELkUO/JhRksI8BDePlmVIN4QqeMkiCbVX3qDZ6zaLkkCtpbEDk/Q/hAyr2wNIqmVUW07/H1lv4X9ZyGzzL+el4Hx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kUZbYDdL; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kUZbYDdL"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=U3Wf62xC5r7GPaaJsND27Q/x6Q226FUTfzXzF0+A+bo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791355580; v=1; x=1791960380;
 b=kUZbYDdLZwLHJA9ppxhFdHw5XiNH99YdpqH/qSIKuZGTSFiyuNhiH169Tq6j10K+oMfeVATz
 XKgxQN03kIEcYAktnS8dgRJvKhtfcPArq7u92oQxcrs5hXH8LTfFhCDU749aFU+rFAprQBpOBSx
 PltrZElTwNUoTjVPXP8MOnCU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 61718ea017c58540;
	Wed, 07 Oct 2026 03:25:47 +0000
X-Mizu-Trace-ID: 61718ea017c58540
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so4657e87.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 20:25:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwunxGYqhFNDr7SCmUqg27xJxP+tl2raz6A1EP3B7+IdgAJ1d5JXVp2lkmDLIS9o20xnvU9z6A=@lists.linux.dev
X-Gm-Message-State: AFq9FYIbscmXScmiCD1ss3CEexZDp5FnkWscLQBCCgCIntrCEVEuby0M
	oRwxyBwLEfPq0OkSP2KXB8J8H0J04YykPJDGgvsLpE5zZwlyjbTYD47Ym1PiPPm+OENI4SIfgqX
	EAZWX9T5Tx9G4QdEZ/2sWesUza9Uxe1PMJaImWw0Y
X-Received: by 2002:a05:6512:ba4:b0:5bb:661:7db4 with SMTP id
 2adb3069b0e04-5bcca011cc1mr293031e87.0.1791343542819; Tue, 06 Oct 2026
 20:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260924165329.1684155-1-fuad.tabba@linux.dev> <05714056-53b7-46ce-86eb-fdb7d2afe1fa@arm.com>
In-Reply-To: <05714056-53b7-46ce-86eb-fdb7d2afe1fa@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 05:25:06 +0200
X-Gmail-Original-Message-ID: <CA+EHjTzde+d7UFowKCeBnpD+8mFPcuUn1m2gLsDm9ViEgPfsQg@mail.gmail.com>
X-Gm-Features: AclHuK9K0Yw9pVF-s7nnkYWE_sJH6hYt2igpYcN7bP3h2C7iBW5sGaqUNJ48r1k
Message-ID: <CA+EHjTzde+d7UFowKCeBnpD+8mFPcuUn1m2gLsDm9ViEgPfsQg@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Ben Horgan <ben.horgan@arm.com>, Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

On Fri, 25 Sep 2026 10:22:00 +0100, Ben Horgan <ben.horgan@arm.com> wrote:
[...]
> IIUC, this patch also covers the mismatched system case where EL3 f/w may set MPAMEN for cpus that
> support MPAM but system_supports_mpam() returns false.

Yes. HAS_MPAM is set per CPU from that CPU's own ID registers, so the
traps depend on neither system_supports_mpam() nor MPAMEN.

Oliver, gentle ping on this one too :)

Thanks,
/fuad
