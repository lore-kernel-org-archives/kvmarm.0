Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9483D9035
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 22:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451586; cv=pass; b=Tun1ZTlnJ9nU46Rj7Vx6Xo7oeERLff23Tdb/l3HdalHkQiEOCRtX9BjXsWSDY385KpK+xUgwvXkZleN+bN9Rd9OkrEWJFjlL2yCC3T016y5mu5GGBJz24l4vMhky/fD+F0wQLod2hkVonvew860UDuZYa7wu9SkDYqGbzLfjMLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451586; c=relaxed/simple;
	bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bC3VO3T5Hv/1ZjlQ4a+tVlRfrbPMyiReeAS5K3wIH5+agqHLSxWmb7HNT+gkdB4KDehayQumMkRLVf2ZsE1TBVQm47XTFgVG3qySHDYXpIgB0E7Iy63s3pMejdBBHuENXGY7UmQPYD9sE0f2GrlzmTg2TcaOn5AFWS68FJBogU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qNJ6X5wZ; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qNJ6X5wZ"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso194313a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 15:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785451584; cv=none;
        d=google.com; s=arc-20260327;
        b=VBx/mAKkrnFUjkaPWEw6HCW5qTibpAfk5nOalTETxkpr6TDsehNeGDC3lUgf0hKlzM
         XydUthkOJ54LdpEEEaCx+zHaSAf9zXJWSL/cgCgJL6NNGa6jw59DmcNbHmorsPfalUmT
         dv+vkmJolEFFcxTJiZWJDv5I+WExsMW6Pqf95wEu8/LugF+SXBBgGfty+3mAYK4RT5SO
         Tl8uGI5lm4qbEomCdNMyb6PKGDIr4/kTASk9ao1aoFliZdRqa1OoGsMfdKSL8iYNUOlL
         c1SCWUnhBKrqjPE7ZI0dYpp9ojUsAuepq7QwgBccl3coB6BgqBXftB72zyNS9zWNUbth
         OY7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        fh=pkm6R9eGK3PBP/Zo+nuLlR3lnMF2d6PI/Bmu68lyb+s=;
        b=hVUJ3Osq6S10Mnb8ztwcAtkbrd2LuSdiye/zS3VRE+zJQCRqtnW2dBbEp3L0iYRNhP
         hBb86qRp6m4X+3aw3v5u2VhoZjBi4KwTRaPRJcFPnw4S5xtvhkyi6WIHtHBw7qBzsCue
         xxv5dTFzntVbqSjToqu3d1sbYn3DFDNHvTETdYtHZ7EQOyaQmy9RCCGfeATCC5S7DmZJ
         M0EWahZPC9mInsTGNEW1KdZEwR4qVfm5MCK4MlBzVwGgxcu8kwXLQP09Clbc+ltlLjN2
         fcehJoQNFcjlRicfLNtjRxsmXjslCnhKQOCmN+DAl9jxGQ1l6ST370K0jOSNK+7XtS8p
         b63Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785451584; x=1786056384; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        b=qNJ6X5wZsuvNNK3fJrEoWwcbd+sbzxgm8l+vxvYy4tQm64iqEUoK9CnbFDCMj0+9jR
         TPD1HPwtSYFlIRGTUeTR2cNxbch2ce/4EWjiFFaNLv0zX78pAXIqYgPr/9K1PGxKOEFq
         301l/vgPrW0SlpQLN+K8pV2/3bmupfzI8CaUht6YHMEEkOthr/LtHqvezRYzoIqdsBUZ
         AnfGdv8xPOFaiCNh0AY6R4UeXlQDdnikBw8AnuULAop3tHJUm5x+biob/t0FQRhaPt2+
         4v5bM0k70B+C68XvQg8ZuouPDlPq+9gbekqDpmoMmFO6rMCjo49dG1/q1x+olqWmNhO8
         vMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785451584; x=1786056384;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        b=Sl4GQoITPq6fzrLCDYCusNzBZHTV8vpPGfyaLfJmXlbYLj3ix6T4L5ksxxri9lX0U6
         YMAFTOepq09S7GhBKXPx2zz6pqcPRki/9alGjCoqaZ8Pj5g38OvCzzrprJCppmNVIjfL
         GzDmvCHoHfRBzlpD0ZusnEu0aUVT4LBJ3wQfZgmF2hi2Cs2ccT4i7UrORToOJmEvED/D
         YWiHMxG9h/rV6Ng4k8yuYSY/nfm2uFRyOcCXRMJehcokphfe5JA0EhTWeQdatcv37J2C
         TERukVzYzDYivqR2hMSm1B/mcSYDF6OerICf2VyJANo+2hCvz8NctyFwMJvAa5uU+/3P
         IUGw==
X-Forwarded-Encrypted: i=1; AHgh+RqvqYoKpfKHz9D31VqLXMzPiEkjGI+BEOUNsAdgHE2be7Tuhs5LyBGYAaoff/ZC1V4LN8GpzLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw79UB0qjmLFwb85wgDJ3MYF4IsRBnV5246sRfAQQhp8ptFROrb
	gsbAQEKP2+inGnoLjxEmuTgRLWzFUrfEorHTmkrrrkbV6NsLeAUCqnghhsbE07boRgsaoqUdQi+
	NL2mHn2N78K9ef7OaiHweijFb9PdqCI4ttW20QllO
X-Gm-Gg: AR+sD10K+FJmfTiRRo9KTahyUiV9m+DEyfPfZnudZTUJwpMNBhBnQNvXLbdMBREoXUR
	YS/Bb5LgJLkxvr71QqUpW3tkVE0w/SLjAFueoPxEKIevnCpLss3+95WZFdOvZRqPNQuTu9MRwqK
	tmRCdhYvHKPE8+CITBLplEdN/QXWJtdEglWHJbNs1m9b+sm50VQ+ldwjD9GXvUarD3cge9+bZHj
	EBxz1AS8yXeyVGhsa00V9fFQodVp+R6lRVoUEdIF8j/+WKxhhuV9HM1NqKHHJzsT3NVRbCqzLI7
	yd6PuXkDkvXKxqtzSMTeEH9wd/8Nn7Rihe5rh+sk/+ZXhn7rawqWb2mJKcSwKq/4676L21gjyv7
	mqOMuP0VZqfXYyHwERpCVNBwM5GH1FmqWMjiFCTmhTMraSg==
X-Received: by 2002:a17:90b:2f06:b0:36b:b903:994 with SMTP id
 98e67ed59e1d1-38fa68500b7mr1838360a91.4.1785451583701; Thu, 30 Jul 2026
 15:46:23 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:46:22 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:46:22 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <afEwWZksU0Fw61oT@plex>
References: <afEwWZksU0Fw61oT@plex>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:46:22 -0700
X-Gm-Features: AUfX_mztKVf-vmsid_VHO9yf9OChzZkQAo084zzlpI1FA8C_xfqYz8r7z-LEAo8
Message-ID: <CAEvNRgE8YHXVZLTQQYZJrJvnrW+WUfpGUn2XpxpkDRj1Zwi4Cw@mail.gmail.com>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, maz@kernel.org, oupton@kernel.org, dwmw2@infradead.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, rientjes@google.com, 
	Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, baolu.lu@linux.intel.com, 
	david@kernel.org, dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com, 
	jgg@nvidia.com, pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, 
	vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
Content-Type: text/plain; charset="UTF-8"

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>
> [...snip...]
>
> The Caretaker
> =============
>
> The Caretaker is a specialized, identity-mapped bare-metal executable
> attached to each vCPU. While it is installed during the initial VM setup
> and remains permanently enabled as an interpose layer between the Guest
> and KVM, it is the key architectural feature required for a VM to be
> orphaned. By providing an execution environment independent of the host
> OS, the Caretaker enables the guest workload to safely survive the host
> lifecycle transition.
>
> During normal VM operation, the Caretaker acts as a fast-path shim: it
> forwards standard VM Exits down to the backing KVM kernel module and
> handles certain exits autonomously. However, during the "Management Gap"
> (when no host OS is active and standard KVM handlers are offline), the
> Caretaker enters a standalone mode to ensure continuous guest execution
> without host intervention.
>

I think this might already be explained in different ways by the other
commenters.

I guess the main question I have is, if the Caretaker could indeed take
over caretaking during a "Management Gap", then we're adding code to
tell KVM what to do to handle some VM exits.

In that case, it would be awesome to have that functionality provided by
KVM in the first place, to avoid some number of kernel exits to the
userspace VMM.

> While this proposal focuses on its critical role in minimally disruptive
> Live Update, the Caretaker is fundamentally designed as an extensible
> primitive.

If the Caretaker can/needs to be extended, then on the other extreme,
the entirety of the userspace VMM's functionality could go into the
caretaker, and perhaps that's another direction to go, where maybe LUO
could keep some slice of userspace alive? (then the VM is no longer
orphaned)

> Its architecture allows it to be leveraged for a variety of
> other advanced virtualization use cases, such as running custom
> lightweight hypervisors or completely offloading virtualization duties
> to an accelerator card.
>
>
> [...snip...]
>
