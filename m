Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793301124;
	b=y7MVofrmUcXmX0az+L8bSUSBuJssfOBq7/UhEcpWYhC8ctN40mjkJXxyAzFd/OsSxAtB
	 +a0RNCJGw4Lhaiq6T72tPoyt+Ek2PIVs3uynJovzEeOMs6OWytiHziniV7mT3MPsu6oVX
	 1K4qM8DUjpOQFI24UKqC4BQOMZ0PLx86no/e4akGpukKpjYduTPj/Wu6/px/D0LS+csBG
	 degHBeCSZ3U0LNUHuhj1yxCKiHqVJ3UYg/yXaUtHveJB3MGeEz/sIke13lTbuXjJ6wwCt
	 oIk7gjdzz2sySMX333KJEen0DYhIbrvM5I3nRWctm33pbkiKehIt/9YR8DJCZL22mKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793301124;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=dhVNqyPxm3jM+00wO9DouSQBRFyH0+S1340RWBDvsr0=;
	b=LmgJ7YH7okyLaOhXmurr1VBAvnEMljWO4dkUEgukAXtVjKJqfOJdbZkn8++GQ56Gjg1g
	 o117nhiLqUE5QwstAAwfyyzGtszj/lmrs3Y55+3dpRTxZYpjRbXRXSuEXI8TszM6UuTse
	 GXFHtXpAS0S3UTn0k8M8958wTM97D7h7/oNwvBOBhwauHaV8IgpE4/2XyCwFhPOtdj0yc
	 3pou7TaNYejls5CPAAK0vnpZ5RcPEs7j+yc4KhZH8agcpCLjwJwLWycp62bd2E8IE5aoq
	 otFA795v1mpDHGaUqI210v9s9hzZ5mWugyR/wozwsEjP8upWBPtXQqbon0iANTCOCmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cxVfBycw;
	arc=none smtp.remote-ip=95.215.58.52
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88300606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 19:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88300606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cxVfBycw
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dhVNqyPxm3jM+00wO9DouSQBRFyH0+S1340RWBDvsr0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793301120; v=1; x=1793905920;
 b=cxVfBycwwIKAbDxfy1jnwvFQzYMCRupRpPrI3uLI+55/mNRvdoTJUEJEUhKrUxenYUd0pF18
 6dgCS2k8ZIQ5KV4mdECu5TUC2tkFygZKm0VyU/7q/MA7lXHfhuaD37P4mSCYIRNXpJXwUHcFtVQ
 ykd300RVN5BYA6MTbZYcyyK0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 541a87e6e65fd90e;
	Thu, 29 Oct 2026 19:12:00 +0000
X-Mizu-Trace-ID: 541a87e6e65fd90e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so1981e87.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 12:11:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw+GJNAF8GHpfp9D1+wsTnuLil1pYcxO3JLK2HxdgeCAAZn/MXjjF2RF3ATZn4fe2EV60tJu9A=@lists.linux.dev
X-Gm-Message-State: AFq9FYKbpiYj4CaaaDe+gVsxX/75STLSDFxcvi8jqgLPzPtl4eoq6qaZ
	w1OSwHxEb+taN8Et3tDYTI/ymSOYaj0YPcvYa8sDb7fhCurHGN5joUckJNmejAhrlh0+An0URvw
	8npdyhbTY7++Gwq6QB/xdyVurs854yZiWKKwnPLoa
X-Received: by 2002:a05:6512:10c1:b0:5bf:c3e1:532b with SMTP id
 2adb3069b0e04-5bfd13f5375mr256926e87.5.1793301116286; Thu, 29 Oct 2026
 12:11:56 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029090522.64662-1-oupton@kernel.org> <CA+EHjTz-kXVbzcjtMte8B26f0Undr+kWjF2-d0B8TLT8n03hJg@mail.gmail.com>
 <86ld7gydqp.wl-maz@kernel.org> <CA+EHjTw0EjMHKOH8s0F6PZRR7WkmRJJrMrqTzpYoP9gm5n_9Gg@mail.gmail.com>
 <auOSYE97K5y19DAy@kernel.org>
In-Reply-To: <auOSYE97K5y19DAy@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 29 Oct 2026 19:11:20 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw0vSqbP3mbg+Sy=VFcXByM6p=Z2BbMHXpQEamZu8Evxg@mail.gmail.com>
X-Gm-Features: AclHuK9KN3ZShpCMVtHDwjAltyq7vN_HmIZYhtTuwLuiqVNd0XSq_WHTMUo5iCo
Message-ID: <CA+EHjTw0vSqbP3mbg+Sy=VFcXByM6p=Z2BbMHXpQEamZu8Evxg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Respect HA when computing translated TCR
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Oct 2026 at 18:37, Oliver Upton <oupton@kernel.org> wrote:
[...]
>
> This is definitely helpful but my understanding is that the pseudocode
> is *not* authoritative. I think the line "If a translation table hardware
> update is not atomic as observed by other agents ..." in R_NNNMB gives
> an implementation enough freedom to decide something Non-Shareable at S1
> is actually atomic after the result of S2 translation (e.g. S2FWB).

I was under the impression that the pseudocode was more authoritative
than the textual description (bugs aside, which the text can also
have). Maybe someone at ARM could help settle this? :)

> So if the implementation decides it is atomic, no MMU fault is generated
> and the update happens like normal. Now, with that being IMP DEF there's
> a good chance the behavior can vary, like we saw on the output of
> translation on N3 [*].
>
> I'll add another patch to propagate SH0 and HPD, thanks Fuad.

Thanks!
/fuad
