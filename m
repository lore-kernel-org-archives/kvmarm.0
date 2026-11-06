Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975758;
	b=R1HU8Xo35sxGjaGAayQLar5oe8uuCKSjXnN/zK7JUuHENSBWVDVcU8eoj1IfhBE1aHSp
	 c5LfjZZ+LO3KAX0ABSIA7oXarmliTnL+55XXt42r/Wbcm9WBUuS+WEL0iN762NJQYYTK6
	 IRVpcSepXyyHNEkYefvw+3X3q10LW0PFG0U+wrf/F8tf4gWtv3T9JWUXPbo9mSkC43ej1
	 f0KMKEjK9FH+zjmD0MByBmttIMunaJsfJwNIJ1WAyK/mQQbJ2cNGAKle+JzkajNTF28OE
	 30gYG5bYBlTRcgb2b6GUoc2JG6174RMkruKcZStjvddEuuSIkCSCqYVnrttKWxQ+ejg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975758;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=9ne3EpNoMJHND53sLVjB8iHYRzBbI+NXjoTQbJvnLE4=;
	b=P/ZYAdltopKPZ0D3FJOL54pxkJafHCHxzCI5xfs6axJZYSHQExHSF2BpkMKirwilO8wQ
	 kSiMqiSIuHLH7lXzqeMBid0fsGc0uxdgF/ZOwuOqQwoAI1hf1MwijR1DTqYvJaoSsaLNN
	 lMVlhOslt1kCkwh4SkC4FNQHq7JmnSspo2kNWNE4rx3M2Xjqfi+JiAUV+jJWVfR0M8yZw
	 YnFaMC1v1rWg8FYdWq2E4UWf0ms7M2lAXMG3gQeZ2o75NfLIGuYSZPEONBjcWuY+tYrST
	 ge5Dsz+UVWpjSMyB08c4LhslSbV8FuM8X7EhmFhWE4mZU9azpABYXwWWcFnpcJnBRsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.207
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B6606A329
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C55B6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9ne3EpNoMJHND53sLVjB8iHYRzBbI+NXjoTQbJvnLE4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793975750; v=1; x=1794580550;
 b=UOiPmKzsKQcEoSPab25f5vJkH7dcWsq7wjBs4xvttqDa/K0UZDvXV1tvNDDpyrEapsPODfem
 eb7MlsyRPvfiIwkM+D7IBGvFdT5VqdSRRDL7Jkso6nhj5uKXIfNtpCr0/7Q+QQKG1Tt25vSrVoV
 nKN3OaB0O5BDwOmWtx1DNtkk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eafd98a6238733ca;
	Fri, 06 Nov 2026 14:35:32 +0000
X-Mizu-Trace-ID: eafd98a6238733ca
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so69e87.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:35:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxUQoivvEmdBN4iRkR5vlV1cYUcC8ih+5fszAvch3MRf06SOknS9ySitzpg6zL5Dj6zSBqg2Ig=@lists.linux.dev
X-Gm-Message-State: APuU4Z/OW77verYxeuIUWwxSVlxf/TL66Q1llY0nYueTIsmj13siKpHu
	qPBSH1iASpM+Vd5FAvkGGkUb76vUY090XNzvYhWpRz//KRag0oMDCSjwFLsXZuiSFTdrOp4XoyP
	fKIfqKy3e3/pU8ntrThV5ajgnFS+uqP1+DqpAG+CI
X-Received: by 2002:a05:6512:4019:b0:5c0:50:ff89 with SMTP id
 2adb3069b0e04-5c0071d689fmr69373e87.14.1793975731712; Fri, 06 Nov 2026
 06:35:31 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com> <CAPOPQMB6eU0MYNewcq8HKsEMchwY-X3aT0Km9uULBappFWZcjQ@mail.gmail.com>
In-Reply-To: <CAPOPQMB6eU0MYNewcq8HKsEMchwY-X3aT0Km9uULBappFWZcjQ@mail.gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 6 Nov 2026 14:34:55 +0000
X-Gmail-Original-Message-ID: <CA+EHjTz-R016BwhcptZ3xVQe+a8C7au6ZL8jwZANdTf=cXRZHQ@mail.gmail.com>
X-Gm-Features: AclHuK_pCYkO0OW5l_wmtgWxAs8e930i-uFO6iYlwOczI7StHxm9o788PZxd9Ls
Message-ID: <CA+EHjTz-R016BwhcptZ3xVQe+a8C7au6ZL8jwZANdTf=cXRZHQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
To: Xuheng Li <xuheng@cs.columbia.edu>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Nov 2026 at 14:34, Xuheng Li <xuheng@cs.columbia.edu> wrote:
>
> Hi Fuad,
>
> On Fri, Nov 06, 2026 at 12:03:29PM +0000, Fuad Tabba wrote:
> > Could you mention in the message that the WARN_ON() is fatal at EL2,
> > so a caller there gets a hyp panic rather than -EEXIST?
> > kvm_pgtable_hyp_map() is already documented as rejecting such a
> > mapping "with an error and a WARN()", which is a better reason than a
> > future caller.
>
> Thanks. I'll reword the message to say that the WARN_ON() is fatal at
> EL2, and point to kvm_pgtable_hyp_map()'s documented "error and a
> WARN()" instead of a future caller. With patches 1 and 2 dropped, I'll
> resend this one on its own once reviews have settled.

Actually, like Vincent pointed out, why the WARN_ON(). The caller can
just handle the error.

Cheers,
/fuad
