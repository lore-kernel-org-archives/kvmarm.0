Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CBC2AF00
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757011569; cv=none; b=Hc1dtUrNRrQrvoD9IXgo06sFwwL9fbtaZrfCsLriyurju13ldLMAirpzd/kZ/d38O90bITfOiyp5KT1tLhGmLDwNf28XkMhN0VbOHCpKKnUFi9T5khW6JIGQlj/UXn3aZ+8mxYWKKOxL6CVRHuCS3ck9yIVmn+UkeSJl+gWPrlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757011569; c=relaxed/simple;
	bh=lvuwRmNZNM7aSL/GeaizMNzN5z2gDAqq7f4Bxl2+g5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YjB2o+yjwZ/7IQYA/FfivXU+q2ALBgrW99r/RzT5sDmdiZnuOKU771Q2eauTb/NlTjBCHkQ02k0VvhB97dnYBbJ9GVU64s8u+r0cTbMZVpeqtVqZ4I/z655Y2kKmRq340jONYUTl6TkLSC8VCbdA0kGTTh5GW3ol2+WfuldyHRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u4IP89fu; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4IP89fu"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e970599004aso1444136276.0
        for <kvmarm@lists.linux.dev>; Thu, 04 Sep 2025 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757011567; x=1757616367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMO3Rs3kVsbeR9kpL3G2iwG3KSDbb6leHyCteNZWJKU=;
        b=u4IP89fujHfD7+Xw25RKiw5RBGjxfIditGE4i+xv7OmDEkZZpD9/ULD0JJww/VIwNA
         BFIvKEj9Y6y/9sUtdgwegnN7cG5d7MaP6hPyWuN2YwMFCl6GB2EA2imj5xHyU/gB1W+r
         kEg5E1gfaY0PQVCTmT0WXBiE5KEhRbNlHgqGJ1IhNBNbBOnIH+nfCCg1eyS4xXImZ4vY
         jE1oh7xf/Dl4Utb43dawmg/4U2A3f632JAKlmApqKE3ui2FObwYpHFVgHJ68DDq3EA+W
         QySYSFhDL5ZXEbWsWnH1k7crktyweXGv3RQNchAdMgwR6WA0X2SpKcMOzM3SXkGHsX+i
         tjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757011567; x=1757616367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMO3Rs3kVsbeR9kpL3G2iwG3KSDbb6leHyCteNZWJKU=;
        b=SJYB3QKfL1ALmwcknaFVlG7bd/uriVUb+ucUWpLm7s8NHDVATx+NAmLYH0B0sTDGwX
         QyumXtDXA1FOkGkaiPfqNwz/AxIyGoof2tuEoffIdYIFkunlheM0fztMsKXwAXK3ejb5
         BeH3gY+qgBvT06GWHzfLUkpCxFH6ad/ixJDALOr2CDWCB2GADhhQ/tPFYwKxJsvKXqPU
         34HqkiFhOKVv6oxWuAj+0P0L/tWj4PUar5EOWrP+8juPRcCIN4UNsb8cTXW5w/qTMasK
         +c/qN5sYQrIGga72hyw5BcFNnp8ieIsreOadlHLrIzTxDmrJmNaqJpon3UlISUQQth18
         f71A==
X-Forwarded-Encrypted: i=1; AJvYcCXRW8y/KeCcidL5teJdi5qVKpxmW4tsdebafncJ4B7WvE+9l6OsyEPxBOhWiL7QqRfuLqTJgTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDnq/lWYsZ2driiTGq8meVmaqKkgqBxQIzL88P+eI1iB2Nc0PY
	Goy5b07IM0f6uDn6AECWeTb4iSIN5LekMuATlbvgf9rswOdhliIT+hgz/G/xd7105RUgqlPeUdU
	unUx2LNqJEyAvq77stxyrDTrhXpVEokAPlkymikgV
X-Gm-Gg: ASbGncuJVeGN19NHWvry3VZu50+dgIbUYKQGeFUBs2PePs3qJnlWIP5naPHcf6fM3OE
	EHUam5Zoa7CeA0LWR5chNc4hFnJGNV9eXgUAY5QI+USG+A4W2ZUCmpeUx6ko6y/o9wF2TBEgkdY
	8v/g38YrARLm2d34Blshg4jovm5rcikpw0AHsRcX0ZN3Cd0ijc4FkvO00MH8xLsGTS8sGRPunjv
	uV0Xc8p7gTuHTKYefsuE2cSmfjqlmx8dyd++n/lcURdJEoHXBNWeMQ=
X-Google-Smtp-Source: AGHT+IGn9N+homcANGMwR4jfEFzD2NCD2KcIcBhFWplr8ibSUoc3dBeDSKfXSBSRcFnFSDBlKc1RK8qrGOI6Pnn1inw=
X-Received: by 2002:a05:690c:f86:b0:71c:40c9:b0d1 with SMTP id
 00721157ae682-72276134719mr229604487b3.0.1757011566319; Thu, 04 Sep 2025
 11:46:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com> <de7da4d8-0e9d-46f2-88ec-cfd5dc14421c@amazon.com>
In-Reply-To: <de7da4d8-0e9d-46f2-88ec-cfd5dc14421c@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 4 Sep 2025 11:45:30 -0700
X-Gm-Features: Ac12FXzXQ2J2IObwStpXP8KUnuPjviPOSORfujA1_ZEACSuvKQLNHacmBk1cLV0
Message-ID: <CADrL8HVxvwB4JrnUf6QtDCyzZojEvR4tr-ELEn+fL8=1cnbMQQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] KVM: Introduce KVM Userfault
To: kalyazin@amazon.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 9:43=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.com=
> wrote:
>
>
>
> On 18/06/2025 05:24, James Houghton wrote:
> > Hi Sean, Paolo, Oliver, + others,
> >
> > Here is a v3 of KVM Userfault. Thanks for all the feedback on the v2,
> > Sean. I realize it has been 6 months since the v2; I hope that isn't an
> > issue.
> >
> > I am working on the QEMU side of the changes as I get time. Let me know
> > if it's important for me to send those patches out for this series to b=
e
> > merged.
>
> Hi Sean and others,
>
> Are there any blockers for merging this series?  We would like to use
> the functionality in Firecracker for restoring guest_memfd-backed VMs
> from snapshots via UFFD [1].  [2] is a Firecracker feature branch that
> builds on top of KVM userfault, along with direct map removal [3], write
> syscall [4] and UFFD support [5] in guest_memfd (currently in discussion
> with MM at [6]) series.

Glad to hear that you need this series. :)

I am on the hook to get some QEMU patches to demonstrate that KVM
Userfault can work well with it. I'll try to get that done ASAP now
that you've expressed interest. The firecracker patches are a nice
demonstration that this could work too... (I wish the VMM I work on
was open-source).

I think the current "blocker" is the kvm_page_fault stuff[*]; KVM
Userfault will be the first user of this API. I'll review that series
in the next few days. I'm pretty sure Sean doesn't have any conceptual
issues with KVM Userfault as implemented in this series.

[*]: https://lore.kernel.org/linux-arm-kernel/20250821210042.3451147-1-sean=
jc@google.com/

>
> Thanks,
> Nikita
>
> [1]:
> https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapsho=
tting/handling-page-faults-on-snapshot-resume.md
> [2]:
> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hi=
ding
> [3]: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.u=
k
> [4]: https://lore.kernel.org/kvm/20250902111951.58315-1-kalyazin@amazon.c=
om
> [5]: https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.c=
om
> [6]:
> https://lore.kernel.org/linux-mm/20250627154655.2085903-1-peterx@redhat.c=
om
