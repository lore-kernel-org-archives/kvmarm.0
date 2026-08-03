Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89EA367B7B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753972; cv=none; b=iG5Qumf4MOWUsrp5gP2VZR68BDcEc/2zZqACX6dxh+DQ7GoUdybUN6a7R+IdNh29VJNOFVTNlof2jbs1DMjJLCA5H6aZgk19TzBlCKZ4lUXG1L4MTNVGX7N71J2QE9jRHFJb/0k3nxt0zFC8oKLWcx8zgNtNEwPDItQg3FdF6fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753972; c=relaxed/simple;
	bh=34HR/vKW9+K7D59800nXWmjgacuKRkFRqWQo0Hfr7XY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sUhWoLtI4ASh+vK779EHMB6MzDTdyNSge37LMXm7YajJoGt3gsa6gBgd+l8K49FUpg3+qwWH+vovzG9jSWRDIswhfaQk9BvpkE7YRlhmndxL3hVMItKjSKHqhLKRJRpXgG4n1+6S6tBPOxau1BBL9MB3xKtom1T+G1cZgKIfB5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHhA3qgQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHhA3qgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A691F000E9;
	Mon,  3 Aug 2026 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753971;
	bh=a4f4ZVjrgjeeloRzR4SRjn/DnlnNSTTZE9A75G5oeKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EHhA3qgQzkzFh12A3TyuUGva3bCvD36ffm0IpPLkSn1rgMxFYhiF2jSlOo6/koMJF
	 U3Bh3mOjY8vpWyo0IJwV+taleXIQu6SxwLllWRMMkWuIW2N6r20MyNkEaedI+U97wP
	 Bvksg04xD0rktJRwFrFYgLCLqXBha1h4k7Wf1KL2g06zXcLA5d3lCSL8ksQf2qWbSf
	 +nuDDQ1GLn1KJzz5XBGcvbb5+85t3DVM13sjhLkp4oFXGxu/hrs2l9uVx8snzg8Y5C
	 MucR63K3hPzKExYPezF6muvBiAQ/lcKupVydyv1f80kB/9ezlnfQHrIMvyv1JEF0+x
	 XxdF534fTysqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/20] KVM: arm64: Add pkvm_hyp_req infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803100904.3563942-16-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-16-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:46:10 +0000
Message-Id: <20260803104610.F1A691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The new exception type ARM_EXCEPTION_PKVM_HYP_REQ is not added t=
o the perf tooling's exception types array.
--

--- Patch [15]: [PATCH 15/20] KVM: arm64: Add pkvm_hyp_req infrastructure -=
--
commit 1c1513703a277d8ea203bc42984c3485444883e4
Author: Vincent Donnefort <vdonnefort@google.com>
KVM: arm64: Add pkvm_hyp_req infrastructure

The pKVM hypervisor depends on the host for operations like memory
allocation. This commit introduces struct pkvm_hyp_req and a new
exception type to enable the hypervisor to request resources.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index 37c5e22fac988..00ba99c858741 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
[ ... ]
> @@ -28,6 +29,7 @@
>  	{ARM_EXCEPTION_IRQ,		"IRQ"		},	\
>  	{ARM_EXCEPTION_EL1_SERROR, 	"SERROR"	},	\
>  	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
> +	{ARM_EXCEPTION_PKVM_HYP_REQ,	"PKVM_HYP_REQ"	},	\

[Severity: Medium]
Does the perf tool need to be updated to recognize this new exception
type?

The perf tool maintains a mirror of the exception types for decoding
KVM exit reasons:

tools/perf/util/kvm-stat-arch/arm64_exception_types.h:
#define kvm_arm_exception_type                                  \
	{ARM_EXCEPTION_IRQ,             "IRQ"           },      \
	{ARM_EXCEPTION_EL1_SERROR,      "SERROR"        },      \
	{ARM_EXCEPTION_TRAP,            "TRAP"          },      \
	{ARM_EXCEPTION_IL,              "ILLEGAL"       },      \
	{ARM_EXCEPTION_HYP_GONE,        "HYP_GONE"      }

Without adding ARM_EXCEPTION_PKVM_HYP_REQ to this array, will
perf kvm stat fail to parse and display this new exit reason correctly
when profiling a pKVM host?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D15
