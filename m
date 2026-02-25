Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5ED3E9F9C
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041509; cv=none; b=E6ZOq6foYxMwflVkaf++WVj3LsogXc6FM5TIintfRHdqFyiBzG+LnjLlAZAytHuXRmkF5MlI0nd+3XIZ3ju7QYhpJ1gVaruGMLVdQ8XKraI6Klk/rrrMEk3e5JzdkdLRA304kWd4GD98QtjRp4a5YsTHgAJYGO/y6xhBWI1WNDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041509; c=relaxed/simple;
	bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lWC3sD0ln2gYKnBzvOwxOAq/xzQvdtAbK7OJ+mFTdWw+RHr988RwWBnQ7jtyhZAQkjMizfUKuvEqtQCh+KBzXW+c3Zeu/nlMTU7qkvevBcq+GCUR+oNaTAE/RO3t4pjUpJtLiNlWSY169SWkIektocjE1pJvPvgXn7Pcm/47ZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1kOZsWBa; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1kOZsWBa"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679dc77d151so994797eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 09:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041507; x=1772646307; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
        b=1kOZsWBacDnhG/p70v4C7QqFzgT7twucOHIQ4PXLGWbLuPZ/V9fVeqQsGo4WNagxvR
         rwqSOlvwa7Z9hG74LpeqyYKESuFfpXXo1sZMAHAfEQaGiVKGH3ly0X3/EJubZjDQejw8
         fJNPKnpw0pxp4+dEfYYHvDbKpe+z1hJJkYWM2s2hGAgY/ozXyymZwBIdyUmAeNdXwRCE
         8Oooy/XA6NatJmOEf8IhIMnEl9q4/m5fcXe3O8x1q6QRHgeULHoiL7QL3orsrrMeB81/
         HF4PVKguzJa1iKtdYEeJCNcfBdm05grefss8lS2ycqZ44oEWVl0Tmy6zUC9+tjVTpMsn
         aD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041507; x=1772646307;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
        b=duFiLAQQ41b0GdYXG293PwLgyt+e7fP/VXIsKhdG3yHhdBo0LHRMrIOjL4C6aHgGW8
         mPhsFDSlniztKefdjosWWy98hkvIAbAlNRHC70fivXCud2BsEsOVdWOjvs0K8tsUCOfy
         o6YsTmSBC7Lly0UZBrDvams1DHfnO+nX0pgRT6MnDf3KukNIF7hfSr6pXhx7teRcte8n
         ac43kwIgLyq2Cm7p7H4P+GH151R6tZ7PKhr8rx7D63f2984ZT35GIUgX/o6dLuK0zd11
         7cPJpJxBQshaZATAlRe9jxI0dqoKULq5Fha/wgMsggh6NeTNG0XhDFodjXRC98Ur5HxO
         U3vw==
X-Forwarded-Encrypted: i=1; AJvYcCWd/JLEB1ZNiW49WKAL2RrA4CMw+Me6iY/4/uI/rYpOfD75uYVmafCCb8f767tGcHL6s20g5+Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLLbdi3rcwj1i7Btc5wIiGH6+e5E1XBJqGd4+P42XpRs8opExT
	cRIk10JH9a31NN+wKM4KKp6lHaVaP33ZIiiBw05bh6eBW39uQz9NMKW7abJA2NO6e4tp75++ODF
	EHGyVP9lqL0yREiik6k1yIXEX8g==
X-Received: from iobjf28.prod.google.com ([2002:a05:6602:649c:b0:957:6d3d:c3bf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2d01:b0:679:a4cc:e04f with SMTP id 006d021491bc7-679c4618dbbmr8769461eaf.51.1772041506836;
 Wed, 25 Feb 2026 09:45:06 -0800 (PST)
Date: Wed, 25 Feb 2026 17:45:06 +0000
In-Reply-To: <86ldgyba96.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 12 Feb 2026 09:07:33 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv7fkogyl.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 09/19] KVM: arm64: Write fast path PMU register handlers
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

> On Mon, 09 Feb 2026 22:14:04 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> We may want a partitioned PMU but not have FEAT_FGT to untrap the
>> specific registers that would normally be untrapped. Add a handler for
>> those registers in the fast path so we can still get a performance
>> boost from partitioning.

>> The idea is to handle traps for all the PMU registers quickly by
>> writing directly to the hardware when possible instead of hooking into
>> the emulated vPMU as the standard handlers in sys_regs.c do.

> This seems extremely premature. My assumption is that PMU traps are
> rare, and that doing a full exit should be acceptable. Until you
> demonstrate the contrary, I don't want this sort of massive bloat in
> the most performance-critical path.

After some consideration I agree. I will try a full exit and see if that
is sufficient.
