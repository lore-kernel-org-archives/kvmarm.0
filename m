Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584809;
	b=ft+0YYfNx06JzEpqsdr/fDUaUQ8BJd8tdDpP3N2XDHhqn4b8mycvDdl5cgVHb3KR4pec
	 OyUY6wz+ZsXXCG6nmv2YxZf4FmbL3aTorrfubliYvjF+v1PBh3OyR9JTErhEGDecClo0V
	 89El7/PbV+8+9Al+mwsQUmS5qxbStL6K7ZBBxNkj3IMTR4zd9v63BnQuAbJQor/Eez3HW
	 v9gYIHvQ85k0NOVXtTYjYpjf5eXyMrBu/MljZ+Xod3s2GgtQtWorQI9ucZNwLp8gN2Dfv
	 F3xLDyo6LfF6vp/OXPiNeFt9MpeBc5daAtgUNHz9lZs6seLRM3JSvzgEsIXxij8YAOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584809;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=C6r9UhT0HEFK6UfPUuCuwD1iwb6CoAylgybqtONDCEE=;
	b=OpCSIEUwFqpmkKlbY+XT6uIoP12EGyJWwiyAsfZThQhVxk/4xgmWY7dQ7xotZd+0iHXn
	 DY2uEWValkF3sA+2hjT8t8RptA0bHTlQLqriqj3Pc8UJ4gTbQKzeg08Cn5BrYJevc7b3i
	 onMyuMtdZrEeVMvmE0YWbqohhuHkgH/ON8RrYeJb+FIwCcfU+OOjINUpaG2YCQaVCUcFD
	 J8Zp0Md9iMesZwnFNeodl0UmXGA5NV27Wi4y7vpjWmKDCaw7qdiUyeDl7q9wuV7L/f83Y
	 qTpZ3rghV4fWQspTOw1JS+1abHhUQnQT1cr2h+J6wFyyNnUUqEWpfv9yoNvZmBiJHGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gZ+49ZMP;
	arc=none smtp.remote-ip=91.218.175.71
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F26606A320
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 12:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57F26606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gZ+49ZMP
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=C6r9UhT0HEFK6UfPUuCuwD1iwb6CoAylgybqtONDCEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792584805; v=1; x=1793189605;
 b=gZ+49ZMP8d25sVboqCk9+cd1h7152EERDH5aBsPO07WdeKN8ZrRvWYev/34X946Gr2Uv4vVM
 VUI9pfC2myw0+yBLzAwrzRE5dgd+Cl0EWhTlP6J8YMHBZBFNzB/1fcX9RpzA6dXu+/QsbwIvNkc
 JN8x0YWGMy7KKuDzIJJocHXY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5090a44a66f54538;
	Wed, 21 Oct 2026 12:13:25 +0000
X-Mizu-Trace-ID: 5090a44a66f54538
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso6204e87.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 05:13:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBySWFZFGyhJPXG4FA/nqnQcTSLcQ5dkUq+iiZ4oWc/V1U8wOunzBzgan30nLjOGZJcOJ+P7wp0=@lists.linux.dev
X-Gm-Message-State: AFq9FYI3swqn7sfDtC693rOrRfqM+ytsIimSASOUwKAmhpd7LkzUVnJS
	D3Ax3ijUXZvvxiYbk18wMKC0xc0AY6GusAMeryJfv7fyIMEOCHpkMT6PJZ1CGK8Wt633BwRVwjS
	YaZazqjgrtfN8Z8Fny5KLZ6mxrixYvKHC+OvxDTe+
X-Received: by 2002:a05:6512:3a91:b0:5be:362f:27b4 with SMTP id
 2adb3069b0e04-5be66f45d0emr297020e87.7.1792584802992; Wed, 21 Oct 2026
 05:13:22 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021110000.508827-1-vdonnefort@google.com>
In-Reply-To: <20261021110000.508827-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 21 Oct 2026 13:12:46 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzHFpdR0CD0e0MBRenhci614qVEz=bidKtszqKRoqst8A@mail.gmail.com>
X-Gm-Features: AclHuK9dxoyuqm6J1yx8Oee_PPPZNymPFmNEb-zW_eag5eTNixeBeaxaZ8hZ_ug
Message-ID: <CA+EHjTzHFpdR0CD0e0MBRenhci614qVEz=bidKtszqKRoqst8A@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: pkvm: Clear GICv3 LRs in the hypervisor
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Wed, 21 Oct 2026 12:00:00 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:
> The LR registers are architecturally UNKNOWN when the CPU boots or
> resumes. However, in protected mode, only the used ones are reset.
[...]
> Cc: stable@vger.kernel.org

Could you say in the commit message what happens to a guest when an LR
isn't cleared? It's what justifies the Cc: stable.

I tested it with QEMU modified to leave a chosen value in the top LR
at every CPU reset. Without the patch, the guest took a spurious
interrupt when that LR held a pending interrupt. When the LR had only
its EOI bit set, the EOI maintenance interrupt stayed asserted while
the guest ran, and the guest didn't print anything in 150s. With the
patch, neither happened.

With the commit message updated:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
