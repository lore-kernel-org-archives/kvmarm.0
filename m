Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CAF29AAF3
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 21:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930520; cv=none; b=mZ1qLKMsAyg/luK5iHkLXnrA/SJ8EFrsQHdOpm72Ufh5PUV+0TwCtL00MibUnkum+TPVUkf6Tfu35HvH5ieiato/KukQq+tYwcR2sg1jctN6tMJ7UHQNgTVOvYd3BqZx9cmBJ2GxX0nJVl+u1fwhn3soZFx9Q56Si7hJOCMxCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930520; c=relaxed/simple;
	bh=Si4a3lubEVIsFr5xg//zf0cPvmnb0GNinNu5h5MauAE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DGj+YT9ZbGw1yNI5cNSx15z+A95HVXkADzkTsPDhe2BPKrg59tNGztwWWNlks27euaVfZ+DeD4k/DxsOPDWRSOIkOjXjU1+SFQKCwc1DOGfxHMQDDULaHS3iPW0xvLzpcMN7gUUMIOkvREVWXQbFVOXxfy1q+uW4ZuKU/J3Etxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGP6dFe9; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGP6dFe9"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6744760f6daso1616798eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 13:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770930518; x=1771535318; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DEi6lE69DtAre9+98et1Td5y86Gv96d2+RPCeTq+27M=;
        b=vGP6dFe9qw1tlfa80HK5pne38oE8JQfIaHj0P8OW2kCq2xV6qBrvYXj/TVPLHZvDsq
         lquG62g3xYiTKVW8WZzlVJTxr2gW6BXY0jsv4+Y4Vk3iTzYBMLDKQIcEM+QEhtFUAF11
         /GcsdO+IAnROHR5p+kRUY9Yd57ijFbBWPgzKvcWlnzapw0Y+TkHA/sdc0I7saxHUMShz
         Rlf9D0E8h8Psu9GLqO+jndQv1IYJqnymc7IJr7KkitjMNqwodLOXQm8VF9lCgoSdIeCJ
         bdxfYs30COSMfbdA4XhaW7dPukj2MkeejACo/M5XrVmz54rP8jv1Hy/eqYWRot41BM+/
         midA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770930518; x=1771535318;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEi6lE69DtAre9+98et1Td5y86Gv96d2+RPCeTq+27M=;
        b=NR4yHb7B0wt2kMxR1mmq59uUDtlp5++0SSnOsu9dvOM7bOWABu39OCkFnR3d/ygFB2
         FZFV0dmdHDnMgVLMCyhD/CEGCooalV+vIR6zJakiGEhRZRBxUF2meOnwgetrzQk/84Fa
         9xgO2nvY5D1DAwPghclyQq52Sazo9bCsB/QG7gBXY6E8Lof6OzvSJEKaK56dgnH3Pns+
         h+tyjrqAQZ+CbwQW3oq4pzAg/1YWQFQAbj85/lDYmtCOjelkfmYgm+mvogTYFglr8kic
         CRrMN1K9TZ2D4UfcTKlkQGxwYkm6PU5jpb5ruHvU61wSdx0stux2ItGnOxlBVWJDbhMf
         lSLg==
X-Forwarded-Encrypted: i=1; AJvYcCWGUyI2Fh2ZGtRA6aPiBxB7DQjpAGgaQHbjK0w3SMoRPhRyM9BJhLJG8vD/WDw8S1n3DE/VbOk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQg7I9lCD53XOuAHPRrS0+I2vXT8PvbCaQOF7VDx8g+0lIlVpe
	U6EUH8L+TD/sw5INFGalPk5lhJ8Y7ON84XJsHiCrrW8rP0o5uzXhpIRW5QHRLYk2aWGo9jjbYSK
	I9yDskD27MAQuDe6aY3judMsIMw==
X-Received: from ilmv6.prod.google.com ([2002:a92:c6c6:0:b0:468:4e21:6fcf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:61d:b0:663:2b12:14f1 with SMTP id 006d021491bc7-677243b521amr65721eaf.83.1770930517469;
 Thu, 12 Feb 2026 13:08:37 -0800 (PST)
Date: Thu, 12 Feb 2026 21:08:36 +0000
In-Reply-To: <86v7g5asp4.wl-maz@kernel.org> (message from Marc Zyngier on Tue,
 10 Feb 2026 08:49:59 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt8qcxhdpn.fsf@coltonlewis-kvm.c.googlers.com>
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

Hey Marc, thanks for the review.

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 09 Feb 2026 22:13:55 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> allows reserving a subset of counters for more direct guest access,
>> significantly reducing overhead. More details, including performance
>> benchmarks, can be read in the v1 cover letter linked below.

>> An overview of what this series accomplishes was presented at KVM
>> Forum 2025. Slides [1] and video [2] are linked below.

>> IMPORTANT: This iteration does not yet implement the dynamic counter
>> reservation approach suggested by Will Deacon in January [3]. I am
>> working on it, but wanted to send this version first to keep momentum
>> going and ensure I've addressed all issues besides that.

> [...]

> As I have asked before, this is missing an example of how userspace is
> going to use this. Without it, it is impossible to correctly review
> this series.

> Please consider this as a blocker.

Understood. I remember you asking for a QEMU patch specifically.

I had hoped that the use in the selftest was sufficient to show how to
use the uAPI. If not, I can send out an example QEMU patch to the QEMU
ARM mailing list.

> Thanks,

> 	M.

> --
> Without deviation from the norm, progress is not possible.
