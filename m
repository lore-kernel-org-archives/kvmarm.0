Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8DD345CD8
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 09:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738429; cv=pass; b=cfc8+qWk9z4MFFB0+4HQKpZY9Qkq1fwl0Yjrk0VtMX2hhhcaLS5iZwluD7kQbYQw2TnDCmJtePOyMBLVIceJbCFJmLm1X3LJ6iAbC1LGbTt8a4o77z8VUIYcqov7caETKbfXTZExHorhH5gDqLQQWLI8jn2OIxv8EnwQDFsu0+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738429; c=relaxed/simple;
	bh=QN78xOepje/Tuor+2DDcaGWelLDv1nwAfmlArH7Kjww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SoITmpiWDcT8irzeggBt1ThUniw/SAz2avigbqeiO7y+2Pgpnpfj4+VIXoLtg59iNC+XqX9VQQJJoWu424bDErTxjFwMlKCuLvlfW6z/wP1SN/8n/ygarEh9TqdQ5kQhLkBZzlKEufg9V1AxCtANYEZxpS/3Rbs0fpUD4xRdi+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qr+10xtC; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qr+10xtC"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50906a98ffeso497551cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 02:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773738427; cv=none;
        d=google.com; s=arc-20240605;
        b=MAUTsnDE/nKx9xM8q2ipLJEcPgA4FVH7VvVuOYW4yea/UQ4m/idzayPSsCPtXBZGib
         1r24OGBLpGZexV4wY9CqcOtG44agjPRtckr6COSvC9Hzlfl4cRaUkg0FYiM3GMR4Gzdg
         gs5prYPEq70qKDxNcnIkusJpHIjy4Aw0cH4FEWboUEBkItE2r1EubuoDaRpjPmVdQ4kl
         GeNvDb7JbZ93sskHgtU0Z9RSA+qu70x6o8Xdqzn7uZXlEK4dOGsQUL6BbiPLzRZ55Bb1
         dNrJ6qG45lGR47tuE/EmXXO1uWqPZQeBcxHU+7b7Poh80p/AD6DsYQqoQO1JQWbDfRRY
         bz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=I1c7pb+cTV3a4lUModBj1JLwgNeKNIM2osZBRVDQQUs=;
        fh=iBkMQK4DKH3DDAt5v8nynVEM1R0DzYMCr1EIJuVJG+8=;
        b=RBqO858VSLDIUhBogsNqnt5t6M3f5JZIsik+merUNoirJzMr0klcXTHn8jzOy1YMEW
         /z+fuhZcWuRFsGqzQhfwVBbw0UmhSSd4FG7bQzAu3krVlU3Oh7sZFhqVnzQnAf7cA0PT
         FW10yDvGEb156l1zjh//yYD8iYaPAnCfsuaHbhgWjd8Dajxd4ln1Uzqq6f3ILu8A0WAU
         czVqJhp7zYkxWoMnD9LcHH0QN7vSn/Vb6PidGUe0y6HB9duCRY2Lw2miJRAWEmvT4Pmb
         YVFWtci6KskMe4WuEMklH0LzvlaypXn4/n2KHIjC9W1i7yb2/SS9ECLxPzfl4pAmYiOE
         ZX0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773738427; x=1774343227; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I1c7pb+cTV3a4lUModBj1JLwgNeKNIM2osZBRVDQQUs=;
        b=qr+10xtCCwUYF0rlJz8Nr+4+p8bb+fs4H4KbEa4+9viwq4NJOCGk0hyjENdaoUB289
         Tx2PDoWLYbSPu+eoyr27Dlkixg9cK3tEUlTllaVPQ6NNgq9MVS0vUbw1uDhf0osn5ZkQ
         nMleEUwt2bq6S7ziTRKtqt0kie3yk/sJqux+qNoJ5Pd2RSJUiG/o5mU4tMmYBMtXKHf5
         Oms1reGxEMQNFBBKPkV2/ai5HoEF2VoAv2Zkd8B2kSH4uic53HKAFeck5DYTHHKi6mSi
         n0JxiDEq8Tg7tQ/QVAJIXA1X+JopEWheANbMxY8gCOoBEaDShddShBFHtzMEyy8R8Jy5
         CUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773738427; x=1774343227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1c7pb+cTV3a4lUModBj1JLwgNeKNIM2osZBRVDQQUs=;
        b=DeZWwV7CW5qy84eLy2NB6p3B0EHnMWGwoisQkb++Udxyr1HbyYFMHjTwCsXxj42tF6
         Sa/WkQohV0zDS9iYYt5o74iEBdSZ9CUOqSz0TcAQFscMo9p99iSPEL4P3r8WdP6NY269
         urwB3aHsWS6hN7TSHTgq5h2OG3klsbciBztciuLJ5muFMBxeJfOA/17K+r6QB1nzQ8yn
         TBhPkxvMILnpWhw4yKW2srzEPGnyWyVZQ7aIkUGpTz5ok9NYWT7FoV7cD2zr3i1bjg13
         CfiE50ptbC5jZWJnFDFdA4KfftmwFtj2kEdbVvCOIHzCwlx6nJ0lYW9bN7x1EkI1kUyh
         G3Yg==
X-Forwarded-Encrypted: i=1; AJvYcCWaJEBQRia5WWMxMr5HgFeQGTjlKYb70JaZ2tdBgBe6xWMPeauNsOf7Y5pnXNB9dPLuvwcMbTw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOsVUFleCWdcPBSGCjFmblL8zCnxS8k9qoqw7pHhVYslEae21b
	4GXxKStTtr38QRZTeaTA3Ytkn/o4mTEnCyvPyZE/ayeAjtxzeDBJdlAUMCtI0dAcIqCcZ+ODvbH
	rbvp6pNTyIlS9PlAUoS7yqOarvNHHHwnb4n1ZZXrR
X-Gm-Gg: ATEYQzytEuCdWUrrTFapa9uW/0tiYiemnB51bR0MfkxFnNf+Tmq6cKnUxUO8HSgjqdp
	L4eEQKUn/baudPG5bKANFzWSNPbqrgQo4qQGFFI21ihBeg0x0NQlSJ7tQfyH8mrbaeAIOjMN9GW
	IfDmIaWDqfOPTbQ4MgLq0fW0BnZVlfEkL+9Mhgnx+L9A9Lp8FS7y1tbfCtaFkyU6vp0n+15xyIO
	KTIgjYnGYk/0iQpy7UUC7A7wULibAZMVpVdxJrcOpl+QuYVd7cH3pP8P/bo/AJXjaOIx7ucVSkG
	e9UWo1b73dnsV4TniK6BNShsp3D09xwWJSio
X-Received: by 2002:a05:622a:10:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-5099ac7560bmr9779271cf.3.1773738426348; Tue, 17 Mar 2026
 02:07:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com> <86v7eu6f59.wl-maz@kernel.org>
In-Reply-To: <86v7eu6f59.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 09:06:27 +0000
X-Gm-Features: AaiRm514QcmZILX1j2R8FGeKV4j8mR_Z1aFciuUI6QiV9uL-s8tuqzHMU9c2xwE
Message-ID: <CA+EHjTyJ75o=_epv7BBrX8LVKa-=EsTRStBKWmDG7pgn0RL42A@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: arm64: Adopt scoped resource management
 (guard) for EL1 and EL2
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 17 Mar 2026 at 08:20, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 16 Mar 2026 17:35:21 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi everyone,
> >
> > I stumbled upon a lock leak while reviewing Sebastien's recent GIC Hardening
> > series [1] on an early error path. It reminded me that we've run into this exact
> > kind of bug pretty often while working on pKVM. Since we're going to be
> > hopefully upstream even more pKVM code soon, I'd like to try and fix this
> > pattern once and for all.
>
> I'm of the opposite opinion. I'd rather convert things as code gets
> modified, because this otherwise makes backporting patches a real pain
> (we have been through that exercise with the irq stack, and it wasn't
> an enjoyable experience).
>
> So while I'm not opposed to this in general, I'd rather see it as a
> prefix for new features, instead of a standalone series.

I'm happy to do whatever is easier for you. My thinking was that,
since the coming pKVM series (assuming Will's series goes in soon) is
going to be pretty long, it would be easier to have this done earlier.

>
> [...]
>
> > There are definitely other parts of the KVM codebase that could benefit from
> > this (especially the vGIC), but I'm stopping here for now to see what everyone
> > thinks of the approach before touching anything else.
>
> The vgic is specially difficult to convert because of some of the
> constructs that take a lock in a function and release it in another,
> defeating the scope-based locking.
>
> I'll have a look at the series anyway.

Thanks! In case you think this is a good idea, let me know and I'll
respin without those "Change-ids".

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
