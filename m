Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DCF3ECBFD
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041260; cv=none; b=ubpvkb7BbqcOc61gJlNL2Ibl972sWVs9SyrViGvkpgBpIXOTQuh0dUi68UPvPRHr6AEV64+4HBpJulBRSC9LwXUTwkuxp3iw4raxpkxkjVfCy/7a7drn39cDHiq4F2Zw+pXMXwZ7PKEI0wxPPC5XWiIPqVdUs4AZXbvJ9P8fudo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041260; c=relaxed/simple;
	bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=psan6Nu9oLLSaOg8cdyaOc3nOrD5nZqJnOWA4bfiH6nePWmJlXAEpoTnz8I5eEjCvvkkGDWlAAYmkPRQPRq4Cu/PmUhjiB2X0ubgjZOcN11SaiIKGd54oTCEH9UC0t/2J9bIphScX8Y0o+gxLGIhEs3tHQFg3WCHxnom7zjzLA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cKzUlBcD; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cKzUlBcD"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679e5688b33so197710eaf.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 09:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041257; x=1772646057; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
        b=cKzUlBcDNTTwRF7Oe6km+WjjnwkSNQ0zNF+JPz4+ekY6l+2pmLJnDh6wQeOfdMD84h
         UCnWBZHSuJ/YXaSLPXio48ClhQJCiA2ADhx+CSnRYXL9cvOrhPzOTFHVFD1DEdJQdcFd
         rV4D4Xk2JI3L/rDG9P1X1yvqIs8TiKPOEBLqCtFQOj8ABAr658PKdkT1y5hAYxX0IJiW
         6e3VQQmgDvxSHGnlHnmF7arDkiJV8ZDTI08NOTOTO1Is5tXcpnVs2NX9IwENY3hkz1jU
         H0Rpo35dJ5OK4N8+nYMzlSiONrMBwRF1kKLdgX2ErPfjiGigNPYFSzEbwvVmaFEgivye
         bHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041257; x=1772646057;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
        b=NF2LE7GwLBoKtsCwTI2Wn/nkutsaBLwUQP/NcD7DtJCFFd3qTz+M33gkhd8stD6q+r
         o0Ct7r5ka76+Hm43G3FpLO+P1jN6w3CcbjJcIxjGI1XJ9nwHohqLpfIYUkfI0jbafst9
         K5zkbupxFlzBM8Q6ApclcRX4b7fkwANLqFzrwhUUCQuREiFrBUA12CsxKx3uC4kR/UPu
         dPHWlDf46blHzNQkVXTFmG0OCbJZOp4iWdbB3UuC6n/YsZeVu3mVFb++N3dmyNet+dPC
         jWTWLyP3iiemTkbAMlpyOJfCHC0yiiZcSEyV6105zvHn9k8i1l0UM/rs8uS1eIVHAlW3
         6Swg==
X-Forwarded-Encrypted: i=1; AJvYcCUPgPqWum/uw9NLreffObpxLKdQ//O+NcX/tmtUXJXdI1bLJuBFzprBL1qrLjG9M1+MzPtR/vA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh9MtcJ8lT8RvXIlYBJuabivI4+kcfopCBJ5ISGNTAIuZueTqD
	irw67qJZLPhP+fQHBxAR+f5qZilcdl4PynrDZfpwgg4EK6GalaTMDFAYOy95uV/B2DKU9kguh0Z
	GPVUzq0DLxziItPaQiQKX72bROQ==
X-Received: from iluj15.prod.google.com ([2002:a05:6e02:154f:b0:4d2:8640:5d64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2019:b0:672:e67a:96cf with SMTP id 006d021491bc7-679c4684cbcmr8062877eaf.16.1772041256681;
 Wed, 25 Feb 2026 09:40:56 -0800 (PST)
Date: Wed, 25 Feb 2026 17:40:55 +0000
In-Reply-To: <86h5rlawru.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 13 Feb 2026 08:11:01 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnty0kgoh5k.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 00/19] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 12 Feb 2026 21:08:36 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Hey Marc, thanks for the review.

>> Marc Zyngier <maz@kernel.org> writes:

>> > On Mon, 09 Feb 2026 22:13:55 +0000,
>> > Colton Lewis <coltonlewis@google.com> wrote:

>> >> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> >> allows reserving a subset of counters for more direct guest access,
>> >> significantly reducing overhead. More details, including performance
>> >> benchmarks, can be read in the v1 cover letter linked below.

>> >> An overview of what this series accomplishes was presented at KVM
>> >> Forum 2025. Slides [1] and video [2] are linked below.

>> >> IMPORTANT: This iteration does not yet implement the dynamic counter
>> >> reservation approach suggested by Will Deacon in January [3]. I am
>> >> working on it, but wanted to send this version first to keep momentum
>> >> going and ensure I've addressed all issues besides that.

>> > [...]

>> > As I have asked before, this is missing an example of how userspace is
>> > going to use this. Without it, it is impossible to correctly review
>> > this series.

>> > Please consider this as a blocker.

>> Understood. I remember you asking for a QEMU patch specifically.

> No. *any* VMM. QEMU, kvmtool, crosvm, firecrackpoter, whichever you want.

>> I had hoped that the use in the selftest was sufficient to show how to
>> use the uAPI.

> The selftests are absolutely pointless, like 99% of all selftests.
> They don't demonstrate how the userspace API works, now how
> configuring the PMU is ordered with the rest of the save/restore flow.

>> If not, I can send out an example QEMU patch to the QEMU ARM mailing
>> list.

Okay I sent one to you, qemu-arm, and everyone else I asked to review
this series.
